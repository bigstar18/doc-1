#!/bin/bash
. /home/hadoop/app/sh/stats.head.const.v21.sh
. /home/hadoop/app/sh/ip.sh

#字符串判断
#str1 = str2　　　　　　当两个串有相同内容、长度时为真
#str1 != str2　　　　　 当串str1和str2不等时为真
#-n str1　　　　　　　 当串的长度大于0时为真(串非空)
#-z str1　　　　　　　 当串的长度为0时为真(空串)
#str1　　　　　　　　   当串str1为非空时为真

# kill -9 `ps -ef|grep "watch.restart.sh"|grep -v grep|awk '{print $2}'`
# kill -9 `ps -ef|grep "HiveReportTask.jar"|grep -v grep|awk '{print $2}'`
# ps -ef|grep sh           ll | more
#kill -9 `ps auxww|grep "/home/hadoop/app/sh/file/stats"|grep -v grep|awk '{print $2}'`;
#rsHive()
#{
#kill -9 `ps auxww|grep "home/hadoop/hive-0.9.0/lib/hive-service-0.9.0.jar"|grep -v grep|awk '{print $2}'`;
#sleep 2;
#nohup /home/hadoop/hive-0.9.0/bin/hive --service hiveserver > /home/hadoop/log/hiveReStart.log &
#}
killOld()
{
PID=$$
APP=$1
kill -9 `ps -ef|grep "watch.restart.sh --$APP"|grep -vw $PID|grep -v grep|awk '{print $2}'`
}

sendAlert()
{
CMD=$1
PARAMETER=$2

/home/hadoop/jdk1.6.0_37/bin/java -jar /home/hadoop/app/HiveUtil.jar $CMD "$PARAMETER"
}

watchPort()
{
COUNTER=6
APP=$1
PORT=$2
Delimiter=$3
APP_CMD=$4

while [ 1 -lt 2 ]; do
	DEAD="false"
	if [ "$APP" = "hbase" ]; then
		FOUND=`netstat -tln|grep $PORT|awk '/^tcp/ {print $4}'|awk -F$Delimiter '{print $5}'|sort -n`
	else
		FOUND=`netstat -tln|grep $PORT|awk '/^tcp/ {print $4}'|awk -F$Delimiter '{print $2}'|sort -n`
	fi
	if [ -n "$FOUND" ]; then
		if [ $FOUND -eq $PORT ]; then
			echo "PORT $PORT connection"
			COUNTER=1;
		else
			DEAD="true"
		fi
	else
		DEAD="true"
	fi
	if [ "$DEAD" = "true" ]; then
		echo "`date +"%F %T"` PORT $PORT disconnection"
#		COUNTER=$(($COUNTER*2))
		COUNTER=12
		sendAlert mail "huangxx@c-platform.com,luyun@c-platform.com,cuiyang@c-platform.com,zhangshu@c-platform.com-@-$APP Server PORT:$PORT disconnection-@-$APP Server($IP `uname -n`) `date +"%F %T"` PORT:$PORT disconnection"
		sendAlert sms "15295520632,18251957809,13851546129,13851507032-@-$APP Server($IP `uname -n`) `date +"%F %T"` PORT:$PORT disconnection"
		if [ -n "$APP_CMD" ]; then
			nohup $APP_CMD &
		fi
	fi
	sleep $((10*$COUNTER));
done
}

watchHive()
{
killOld 'watchHive'
watchPort hive $1 : "$HIVE_HOME/bin/hive --service hiveserver"
}
watchHwi()
{
killOld 'watchHwi'
watchPort hwi $1 : "$HIVE_HOME/bin/hive --service hwi"
}
watchHbase()
{
#(watchPort hbase $1 : &)
killOld 'watchHbase'
watchPort hbase $1 :
}
watchZk()
{
killOld 'watchZk'
watchPort zookeeper $1 ::: "$ZOOKEEPER_HOME/bin/zkServer.sh restart"
}

#cat /dev/null>nohup.out
case $1 in
--watchHive)
	shift
	watchHive $@
	;;
--watchHwi)
	shift
	watchHwi $@
	;;
--watchHbase)
	shift
	watchHbase $@
	;;
--watchZk)
	shift
	watchZk $@
	;;
*)
	echo "`date +"%F %T"` error $@"
esac

# master1:60000
# master2:60020
# master3:60020
# node05:60000
# node06:60020
# nohup /home/hadoop/app/sh/watch.restart.sh --watchHive 10000 &
# nohup /home/hadoop/app/sh/watch.restart.sh --watchHwi 9999 &
# nohup /home/hadoop/app/sh/watch.restart.sh --watchHbase 60000 &
# nohup /home/hadoop/app/sh/watch.restart.sh --watchHbase 60020 &
# nohup /home/hadoop/app/sh/watch.restart.sh --watchZk 2181 &
