#!/bin/bash
. /home/hadoop/app/sh/stats.head.const.v21.sh

SSH_PORT=10022

share()
{
HOSTNAME=`uname -n`;
echo "`date +"%F %T"` $HOSTNAME share begin..."
#klsf       echo 'umask 0002'>>~/.bash_profile;

#π≤œÌ
chmod 770 $BASE_HOME $BASE_HOME/*.sh;
chmod 770 -R $BASE_HOME/log;
chmod 770 -R $BASE_HOME/app_test;

chmod 770 $BASE_HOME/hadoop*;
chmod 775 -R $BASE_HOME/hadoop-hadoop/* /tmp/hadoop;
chmod 750 -R $HADOOP_HOME/bin $HADOOP_HOME/conf $HADOOP_HOME/lib;

chmod 770 $HIVE_HOME;
chmod 750 -R $HIVE_HOME/bin $HIVE_HOME/conf;
chmod 770 -R $HIVE_HOME/log $HIVE_HOME/bin/log;
#’˝ Ω
chmod 750 -R $BASE_HOME/app;
chmod 770 -R $BASE_HOME/app/*.properties $BASE_HOME/app/explainpics $BASE_HOME/app/sh;

chmod 750 -R $HIVE_HOME/lib;
#≤‚ ‘
chmod 770 -R $BASE_HOME/app;

chmod 770 -R $HIVE_HOME/lib;



for i in 'master2' 'master3' 'node06'; do
	echo "`date +%Y%m%d%t%T` $i do share..."

	ssh -p $SSH_PORT $i ""
done


echo "`date +"%F %T"` hadoop cluster share done ..."
}

case $1 in
--share)
	shift
	share $@
	;;
*)
	echo "`date +"%F %T"` error $@"
esac
