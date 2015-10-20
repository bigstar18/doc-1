#!/bin/sh
. /home/hadoop/app/sh/stats.head.v21.sh

ERRORLOG=/home/hadoop/log/log.ashit.ftp.loop.log
#相加注意空格				i=`expr $i + 1`

A_HOUR=('00' '01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22' '23')
A_MINUTE=('00' '15' '30' '45')
pid="ashit_pid"

#日期 小时分钟
gatherASHit()
{
LOCALDIR=/home/hadoop/hadoop-hadoop/local/stats/surfas/ashitloop
DFSDIR=/home/hadoop/hadoop-hadoop/data/stats/surfaswall/$1
mkdir -p $LOCALDIR/tmp

for DIR in 'web2' 'web3' 'web4' 'web5'
do
	ftpFile "112.4.12.10" "logftp" "logftp!#!$" /backlog/surflog/assistantOut/$DIR $LOCALDIR/tmp 'assistantOut_'$1$2'.log'
	if [ -s $LOCALDIR/tmp/'assistantOut_'$1$2'.log' ] ; then
		catFiles $LOCALDIR/tmp/'assistantOut_'$1$2'.log' $LOCALDIR/$DIR'_asHit.log' "no"
	fi
done
catFiles $LOCALDIR/'*_asHit.log' $LOCALDIR/'asHit.log' "no"
saveToDFS $LOCALDIR/"asHit.log" $DFSDIR/"asHit.log"

rm -rf $LOCALDIR/*
}

#日期小时分钟
runASHit()
{
if [ $SUCCESS_TOTAL -eq 1 ] ; then
	$HADOOP_HOME/bin/hadoop jar /home/hadoop/app_test/liuliang/HiveReport.jar assistantwall2 $1
	if [ $? -eq 0 ] ; then
		SUCCESS_TOTAL=1
		echo "`date +%Y%m%d%t%T` dataWall $1 stats ok"
	else
		SUCCESS_TOTAL=0
		echo "`date +%Y%m%d%t%T` dataWall $1 stats error"
	fi
fi
}

#日期小时分钟
checkTime()
{
INPUT=$1
if [ "${INPUT:10}" == "45" ] ; then
	if [ $((`date +%Y%m%d%H%M` - $1)) -gt 59 ] ; then
		SUCCESS_TOTAL=1
	else
		SUCCESS_TOTAL=0
	fi
else
	if [ $((`date +%Y%m%d%H%M` - $1)) -gt 19 ] ; then
		SUCCESS_TOTAL=1
	else
		SUCCESS_TOTAL=0
	fi
fi
}

#日期 小时下标 分钟下标
process()
{
echo "`date +%Y%m%d%t%T` begin process $@"

touch "$1"
touch "lock"
echo $*>"lock"
rm -f "sleep"

checkTime $1${A_HOUR[$2]}${A_MINUTE[$3]}
gatherASHit $1 ${A_HOUR[$2]}${A_MINUTE[$3]}
runASHit $1${A_HOUR[$2]}${A_MINUTE[$3]}

if [ $SUCCESS_TOTAL -eq 1 ] ; then
	echo $2>$1
	echo $3>>$1
fi

rm -f "lock"
touch "sleep"
}

#处理日、处理日后一天
checkHis()
{
PROCESS_DAY=$1
PROCESS_NEXT_DAY=$2

#echo $! > $pid     子进程号
echo $$ > $pid

while [ "true" ] ; do
	if [ -f "$PROCESS_DAY" ] ; then
		LINE_COUNT=`grep -c "" $PROCESS_DAY`
		if [ $LINE_COUNT -eq 2 ] ; then
			A_CURSOR=(0 0)
			i=0
			while read LINE
			do
				A_CURSOR[$i]=$LINE
				i=`expr $i + 1`
			done < $PROCESS_DAY
#			echo ${A_CURSOR[@]}
			if [ ${A_CURSOR[1]} -eq 3 ] ; then
				if [ ${A_CURSOR[0]} -eq 23 ] ; then
					process $PROCESS_NEXT_DAY "0" "0"
					if [ $SUCCESS_TOTAL -eq 1 ] ; then
						rm -f $PROCESS_DAY
	#					日期应该加
						PROCESS_DAY=`date +%Y%m%d`
						PROCESS_NEXT_DAY=`date -d tomorrow +%Y%m%d`
					fi
				else
					process $PROCESS_DAY `expr ${A_CURSOR[0]} + 1` "0"
				fi
			else
				process $PROCESS_DAY "${A_CURSOR[0]}" `expr ${A_CURSOR[1]} + 1`
			fi
		else
			process $PROCESS_DAY 0 0
		fi
	else
		process $PROCESS_DAY 0 0
	fi

	echo "`date +%Y%m%d%t%T` sleeping 60s..."
	sleep 60
done
}

checkSleep()
{
if [ -f "sleep" ] ; then
	if [ $((`date +%s`-`stat -c %Y sleep`)) -gt 300 ] ; then
		echo "`date +%Y%m%d%t%T` 主进程休眠时长超过5分钟"
		. ~/stats.util.task.sh mail "huangxx@c-platform.com,luyun@c-platform.com,liuliang@c-platform.com-@-警报：助手点击实时任务处理进程休眠时长超过5分钟-@-sleep时间：`stat -c %y sleep`"
		exit
#		再长可以杀以前的进程，清除标志文件，由该进程接管
	else
#		echo "`date +%Y%m%d%t%T` 主进程休眠中"
		exit
	fi
else
	echo "`date +%Y%m%d%t%T` lock sleep 都不存在"
fi
}

checkLock()
{
if [ -f "lock" ] ; then
	if [ $((`date +%s`-`stat -c %Y lock`)) -gt 600 ] ; then
		echo "`date +%Y%m%d%t%T` 任务处理超过10分钟"
		. ~/stats.util.task.sh mail "huangxx@c-platform.com,luyun@c-platform.com,liuliang@c-platform.com-@-警报：助手点击实时任务处理超时-@-任务：`cat lock`； lock时间：`stat -c %y lock`； 当前处理时长：$((`date +%s`-`stat -c %Y lock`))s。"
		exit
#		再长可以杀以前的进程，清除标志文件，由该进程接管
#		./stats.util.task.sh sms "13851507032-@-icbc：6222024301057706606"
	else
#		echo "`date +%Y%m%d%t%T` 有任务正在处理中"
		exit
	fi
else
	checkSleep
fi
}

startApp()
{
CURRENT_DAY=`date +%Y%m%d`
NEXT_DAY=`date -d tomorrow +%Y%m%d`
PRE_DAY=`date -d yesterday +%Y%m%d`

if [ "$1" == "--force" ] ; then
	echo "force task to start."
else
	checkLock
fi

if [ -f "$CURRENT_DAY" ] ; then
	checkHis $CURRENT_DAY $NEXT_DAY
else
	if [ -f "$PRE_DAY" ] ; then
		checkHis $PRE_DAY $CURRENT_DAY
	else
		checkHis $CURRENT_DAY $NEXT_DAY
	fi
fi
}

startApp $@ 1>>$ERRORLOG 2>&1
