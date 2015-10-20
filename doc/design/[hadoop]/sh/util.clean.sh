#!/bin/sh
. /home/hadoop/app/sh/stats.head.const.v21.sh

ERRORLOG=/home/hadoop/log/util.clean.log
SSH_PORT=10022

#”tar: Removing leading `/’ from member names”，并且实际产生的压缩包会将绝对路径转化为相对路径。
#tar -tvf master1.20130624.bak
appBak()
{
HOSTNAME=`uname -n`;
echo "`date +"%F %T"` $HOSTNAME appBak begin..."

mkdir -p $BASE_HOME/tmp/bak $BASE_HOME/bak /data/bak;
crontab -l > $BASE_HOME/tmp/bak/cron;
cp -f $BASE_HOME/*.sh $BASE_HOME/tmp/bak;cp -rf $BASE_HOME/app/sh $BASE_HOME/tmp/bak;cp -f $BASE_HOME/app/*.jar *.properties $BASE_HOME/tmp/bak;cat /dev/null>nohup.out;
cd $BASE_HOME/tmp/bak;tar -zcf $BASE_HOME/tmp/$HOSTNAME.$TODAY_D.bak *;mv -f $BASE_HOME/tmp/$HOSTNAME.$TODAY_D.bak $BASE_HOME/bak;rm -rf $BASE_HOME/tmp/bak/*;

 for slave in 'master2' 'master3' 'node05' 'node06';do
   echo "`date +"%F %T"` $slave appBaking..."
   ssh -p $SSH_PORT $slave "mkdir -p $BASE_HOME/tmp/bak $BASE_HOME/bak;crontab -l > $BASE_HOME/tmp/bak/cron;cp -f $BASE_HOME/*.sh $BASE_HOME/tmp/bak;cp -rf $BASE_HOME/app/sh $BASE_HOME/tmp/bak;cp -f $BASE_HOME/app/*.jar *.properties $BASE_HOME/tmp/bak;cat /dev/null>nohup.out;cd $BASE_HOME/tmp/bak;tar -zcf $BASE_HOME/tmp/$slave.$TODAY_D.bak *;mv -f $BASE_HOME/tmp/$slave.$TODAY_D.bak $BASE_HOME/bak;rm -rf $BASE_HOME/tmp/bak/*;"
	scp -P $SSH_PORT hadoop@$slave:$BASE_HOME/bak/$slave.$TODAY_D.bak $BASE_HOME/bak
 done

cp -f $BASE_HOME/bak/* /data/bak/;
 echo "`date +"%F %T"` hadoop cluster appBak done ..."
}

rmExcel()
{
 echo "`date +"%F %T"` will rmExcel ...."

#access time  ， atime在读取文件或执行文件时会修改
#create time  ， ctime在文件写入，更改所有者，权限。链接时文件的ctime会随之改变
#modified time ，mtime 在文件写入时会改变。              d      directory
#EMACS Regular Expression  不在乎所出现的字母为何，可以『.』 来表示。『*』，可表示字元重复出现的次数， 从零次到无限多次。\ 在 Regexp 中有二种涵意：一、使特殊字元变为 普通字元，二、使普通字元转为特殊字元。\| ，（表示选择的用法）

#mkdir -p /home/hadoop/app/excel/$YESTERDAY_Y$YESTERDAY_M
#find /home/hadoop -maxdepth 1 -atime 24 -type f -name '*.xls' | xargs -I '{}' mv {} /home/hadoop/app/excel/$YESTERDAY_Y$YESTERDAY_M
#find /home/hadoop -maxdepth 1 -mmin +1200 -size +0 -type f -regex '.*\.zip\|.*\.xls' | xargs -I '{}' mv {} /home/hadoop/app/excel/$YESTERDAY_Y$YESTERDAY_M
find /home/hadoop -maxdepth 1 -mmin +1200 -size +0 -type f -regex '.*\.zip\|.*\.xls' | xargs -I '{}' rm -f {}

 echo "`date +"%F %T"` rmExcel done ..."
}

rmHadoopLogs()
{
 echo "`date +"%F %T"` will delete hadoop cluster logs ...."

 rm -f $HADOOP_HOME/logs/*log.$YESTERDAY_Y* $HADOOP_HOME/logs/*log.201* $HADOOP_HOME/logs/*.out*;
 find $HADOOP_HOME/logs/ -maxdepth 1 -size 0 -type f -name '*' | xargs -I '{}' rm -f {}
 find $HADOOP_HOME/logs/userlogs -mindepth 1 -maxdepth 1 -mtime +0 -type d -name '*' | xargs -I '{}' rm -rf {}
 find $HADOOP_HOME/logs/history -maxdepth 1 -mtime +1 -type f -name '*' | xargs -I '{}' rm -f {}
 find $HADOOP_HOME/logs/history/done/version-1 -mindepth 1 -maxdepth 1 -mtime +6 -type d -name '*' | xargs -I '{}' rm -rf {}
 echo "`date +"%F %T"` delete hadoop `uname -n` logs done "

 for slave in $(cat $HADOOP_HOME/conf/slaves);do
   echo "`date +"%F %T"` delete $slave hadoop logs"
   ssh -p $SSH_PORT $slave "rm -f $HADOOP_HOME/logs/*log.$YESTERDAY_Y* $HADOOP_HOME/logs/*log.201* $HADOOP_HOME/logs/*.out*;find $HADOOP_HOME/logs/ -maxdepth 1 -size 0 -type f -name '*' | xargs -I '{}' rm -f {};find $HADOOP_HOME/logs/userlogs -mindepth 1 -maxdepth 1 -mtime +0 -type d -name '*' | xargs -I '{}' rm -rf {};"
 done

 echo "`date +"%F %T"` delete hadoop cluster logs done ..."
}

rmHiveLogs()
{
 echo "`date +"%F %T"` will delete `uname -n` hive logs ...."

 rm -f /tmp/hadoop/*$YESTERDAY_YMD*;
 rm -rf /tmp/hadoop/hive_$YESTERDAY_Y-$YESTERDAY_M-$YESTERDAY_D*
 find /tmp/hadoop -maxdepth 1 -size 0 -type f -name '*' | xargs -I '{}' rm -f {}
# find /tmp/hadoop -maxdepth 1 -mtime +0 -type f -name '*' | xargs -I '{}' rm -f {}   +0是24小时前
# find /tmp/hadoop -maxdepth 1 -mtime +1 -type d -name '*' | xargs -I '{}' rm -f {}
# find /tmp/hadoop -maxdepth 1 -mtime +1 -name '*' | xargs -I '{}' rm -rf {}

 echo "`date +"%F %T"` delete `uname -n` hive logs done "
}

rmHbaseLogs()
{
 echo "`date +"%F %T"` will delete hbase cluster logs ...."

 rm -rf $HBASE_HOME/logs/*
 echo "delete hbase `uname -n` logs done "

 for slave in $(cat $HBASE_HOME/conf/dist);do
   echo "`date +"%F %T"` delete $slave hbase logs"
   ssh -p $SSH_PORT $slave "rm -rf $HBASE_HOME/logs/*"
 done

 echo "`date +"%F %T"` delete hbase cluster logs done ..."
}

rmTmpFiles()
{
 echo "`date +"%F %T"` will delete `uname -n` tmp logs ...."

 find /tmp -maxdepth 1 -mtime +6 -name '*' | xargs -I '{}' rm -rf {}
 find /home/hadoop/tmp -mindepth 1 -maxdepth 1 -mtime +6 -name '*' | xargs -I '{}' rm -rf {}
 find /home/hadoop/hadoop-hadoop -mindepth 1 -maxdepth 1 -mtime +6 -type d -name 'hadoop-unjar*' | xargs -I '{}' rm -rf {}
# find /home/hadoop/hadoop-hadoop/local/stats/boss_process -maxdepth 1 -mtime +6 -type d -name '*' | xargs -I '{}' rm -rf {}
 find /home/hadoop/hadoop-hadoop/tmp -mindepth 1 -maxdepth 2 -mtime +6 -type d -! -name 'zsh' -name '*' | xargs -I '{}' rm -rf {}
# find /home/hadoop/hadoop-hadoop/userUpDownLogData/*/*/* -maxdepth 1 -mtime +6 -type d -name '*' | xargs -I '{}' rm -rf {}

 echo "`date +"%F %T"` delete `uname -n` tmp logs done "
}

rmHiveHdfsTmp()
{
echo "`date +"%F %T"` will delete hdfs hive tmp files ...."

$HADOOP_HOME/bin/hadoop dfs -rmr -skipTrash  /tmp/hive-hadoop/hive_$DAY2AGO_Y-$DAY2AGO_M-$DAY2AGO_D*
#$HADOOP_HOME/bin/hadoop dfs -rmr -skipTrash  /user/hive/tmp/hive_$DAY2AGO_Y-$DAY2AGO_M-$DAY2AGO_D*

echo "`date +"%F %T"` delete hdfs hive tmp files done "
}

rmTTLocal()
{
 echo "`date +"%F %T"` will delete hadoop cluster TTLocal ...."

 find /home/hadoop/hadoop-hadoop/mapred/local/userlogs -mindepth 1 -maxdepth 1 -mtime +0 -type d -name '*' | xargs -I '{}' rm -rf {}
 find /home/hadoop/hadoop-hadoop/mapred/local/taskTracker/distcache -mindepth 1 -maxdepth 1 -mtime +0 -type d -name '*' | xargs -I '{}' rm -rf {}
 find /home/hadoop/hadoop-hadoop/mapred/local/taskTracker/hadoop/* -mindepth 1 -maxdepth 1 -mtime +0 -type d -name '*' | xargs -I '{}' rm -rf {}
 find /home/hadoop/hadoop-hadoop/mapred/local/ttprivate/taskTracker/hadoop/* -mindepth 1 -maxdepth 1 -mtime +0 -type d -name '*' | xargs -I '{}' rm -rf {}
 find /home/hadoop/hadoop-hadoop/mapred/* -mindepth 1 -maxdepth 1 -mtime +0 -type d -! -name 't*' -name '*' | xargs -I '{}' rm -rf {}
 echo "delete hadoop `uname -n` TTLocal done "

 for slave in $(cat $HADOOP_HOME/conf/slaves);do
   echo "`date +"%F %T"` begin delete $slave hadoop TTLocal..."
   ssh -p $SSH_PORT $slave "find /home/hadoop/hadoop-hadoop/mapred/local/userlogs -mindepth 1 -maxdepth 1 -mtime +0 -type d -name '*' | xargs -I '{}' rm -rf {};find /home/hadoop/hadoop-hadoop/mapred/local/taskTracker/distcache -mindepth 1 -maxdepth 1 -mtime +0 -type d -name '*' | xargs -I '{}' rm -rf {};find /home/hadoop/hadoop-hadoop/mapred/local/taskTracker/hadoop/* -mindepth 1 -maxdepth 1 -mtime +0 -type d -name '*' | xargs -I '{}' rm -rf {};find /home/hadoop/hadoop-hadoop/mapred/local/ttprivate/taskTracker/hadoop/* -mindepth 1 -maxdepth 1 -mtime +0 -type d -name '*' | xargs -I '{}' rm -rf {};find /home/hadoop/hadoop-hadoop/mapred/* -mindepth 1 -maxdepth 1 -mtime +0 -type d -! -name 't*' -name '*' | xargs -I '{}' rm -rf {}"
 done

 echo "`date +"%F %T"` delete hadoop cluster TTLocal done ..."
}

#通过sh -x ./shellcode.sh来达到调试的目的   “-n”可用于测试shell脚本是否存在语法错误，但不会实际执行命令。
#set -x　　　 #启动"-x"选项
#要跟踪的程序段
#set +x　　　　 #关闭"-x"选项
#在一个 shell 脚本中将一个命令通过 & 放入后台执行，这个命令和当前 shell 的执行是并行的，当前 shell 会派生一个子 shell 执行这个后台命令，而自己则继续往下执行，两者并没有相互依赖及等待的关系，所以这是一种异步的执行方式。
#但是如上方到后台执行的进程，其父进程还是当前终端shell的进程，而一旦父进程退出，则会发送hangup信号给所有子进程，子进程收到hangup以后也会退出。如果我们要在退出shell的时候继续运行进程，则需要使用nohup忽略hangup信号，或者setsid将将父进程设为init进程(进程号为1)
#另外还有一种方法，即使将进程在一个subshell中执行，其实这和setsid异曲同工。方法很简单，将命令用括号() 括起来即可：

appBak 1>>$ERRORLOG 2>&1
rmExcel 1>>$ERRORLOG 2>&1
rmHadoopLogs 1>>$ERRORLOG 2>&1
rmHiveLogs 1>>$ERRORLOG 2>&1
rmTmpFiles 1>>$ERRORLOG 2>&1
rmHiveHdfsTmp 1>>$ERRORLOG 2>&1
rmTTLocal 1>>$ERRORLOG 2>&1
($HADOOP_HOME/bin/start-balancer.sh &)
