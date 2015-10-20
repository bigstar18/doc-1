#!/bin/bash
. /home/hadoop/app/sh/stats.head.const.v21.sh

SSH_PORT=10022
SSH_HOST=node06

envSet()
{
mkdir -p $BASE_HOME/app/sh/tmp $BASE_HOME/app/explainpics $BASE_HOME/app_test;rm -rf $BASE_HOME/app/sh/tmp/*;
ssh -p $SSH_PORT $SSH_HOST "mkdir -p $BASE_HOME/app/sh/tmp $BASE_HOME/app/explainpics $BASE_HOME/app_test;rm -rf $BASE_HOME/app/sh/tmp/*;"
}

cronSync()
{
echo "`date +"%F %T"` cronSync to $SSH_HOST begin..."

cat $BASE_HOME/app/sh/crontab.task > $BASE_HOME/app/sh/tmp/cron;
scp -P $SSH_PORT $BASE_HOME/app/sh/tmp/cron hadoop@$SSH_HOST:$BASE_HOME/app/sh/tmp/cron
ssh -p $SSH_PORT $SSH_HOST "crontab $BASE_HOME/app/sh/tmp/cron;"
#touch tmp;crontab tmp;

echo "`date +"%F %T"` cronSync to $SSH_HOST done."
}

shellSync()
{
echo "`date +"%F %T"` shellSync to $SSH_HOST begin..."

scp -P $SSH_PORT $BASE_HOME/*.sh hadoop@$SSH_HOST:$BASE_HOME/
scp -r -P $SSH_PORT $BASE_HOME/app/sh/* hadoop@$SSH_HOST:$BASE_HOME/app/sh/

echo "`date +"%F %T"` shellSync to $SSH_HOST done."
}

jarSync()
{
echo "`date +"%F %T"` jarSync to $SSH_HOST begin..."

scp -P $SSH_PORT $BASE_HOME/app/*.jar $BASE_HOME/app/*.properties hadoop@$SSH_HOST:$BASE_HOME/app/
scp -P $SSH_PORT $BASE_HOME/app/explainpics/* hadoop@$SSH_HOST:$BASE_HOME/app/explainpics/
scp -P $SSH_PORT $BASE_HOME/app_test/*.jar hadoop@$SSH_HOST:$BASE_HOME/app_test/

echo "`date +"%F %T"` jarSync to $SSH_HOST done."
}

hiveCfgSync()
{
echo "`date +"%F %T"` hiveCfgSync to $SSH_HOST begin..."

scp -P $SSH_PORT $HIVE_HOME/conf/* hadoop@$SSH_HOST:$HIVE_HOME/conf/
scp -P $SSH_PORT $HIVE_HOME/lib/*.jar $HIVE_HOME/lib/*.war hadoop@$SSH_HOST:$HIVE_HOME/lib/

echo "`date +"%F %T"` hiveCfgSync to $SSH_HOST done."
}

envSet

case $1 in
--cronSync)
	shift
	cronSync $@
	;;
--shellSync)
	shift
	shellSync $@
	;;
--jarSync)
	shift
	jarSync $@
	;;
--hiveCfgSync)
	shift
	hiveCfgSync $@
	;;
*)
	echo "`date +"%F %T"` error $1"
esac

