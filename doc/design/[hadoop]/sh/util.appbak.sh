#!/bin/sh
. /home/hadoop/app/sh/stats.head.const.v21.sh

ERRORLOG=/home/hadoop/log/util.appbak.log
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

scp -P $SSH_PORT $BASE_HOME/bak/$HOSTNAME.$TODAY_D.bak hadoop@master1:$BASE_HOME/bak

echo "`date +"%F %T"` $HOSTNAME appBak done ..."
}

appBak 1>>$ERRORLOG 2>&1
