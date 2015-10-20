#!/bin/sh
. /home/hadoop/app/sh/stats.head.v21.sh

ERRORLOG=/home/hadoop/log/hadoop.install.log
#使变量成为环境变量，就能为子shell取用  export  declare -x 变量=""   取消环境变量：testVar=   或 unset testVar
#type：有 soft，hard 和 -，soft 指的是当前系统生效的设置值。hard 表明系统中所能设定的最大值。soft 的限制不能比har 限制高。用 - 就表明同时设置了 soft 和 hard 的值。

envSet()
{
#chmod 770 /home/hadoop; chmod 770 /home/klsf;
#chmod 775 /home/hadoop/hadoop*;chmod 775 /home/hadoop/hive-0.9.0/;chmod -R 775 /home/hadoop/hive-0.9.0/bin
#chmod -R 775 /home/hadoop/hadoop-hadoop/;chmod -R 775 /tmp/klsf;chmod -R 775 /tmp/hadoop;

#chown -R hadoop:hadoop /home/hadoop; chown -R hadoop:hadoop /data;echo '/sbin/swapoff -a'>>/etc/rc.local
#find ~ -mindepth 1 -maxdepth 1 -type f -! -name '.*' -name '*' | xargs rm -f
#find ~ -maxdepth 1 -size 0 -type f | xargs rm -f
#sysctl -w vm.swappiness=0;sysctl -w vm.vfs_cache_pressure=200;echo 'vm.swappiness=0'>>/etc/sysctl.conf;echo 'vm.vfs_cache_pressure=200'>>/etc/sysctl.conf; sudo sync; sudo sysctrl -w vm.drop_caches=3; free -m;
#RHEL6 即只有当使用*号让全局用户生效的时候，生效的nproc的值大小是受文件/etc/security/limits.d/90-nproc.conf中nproc值大小制约的，而如果仅仅是针对某个用户，那么就不受该文件nproc值大小的影响。
#echo 'hadoop          soft    nproc     10240'>>/etc/security/limits.conf
#vim /etc/security/limits.d/90-nproc.conf     *          -    nproc     65536
#echo "">>.bash_profile;echo 'export LC_CTYPE="zh_CN.UTF-8"'>>.bash_profile;echo 'export LANG=zh_CN.UTF-8'>>.bash_profile;

echo 'umask 0022'>>~/.bash_profile;echo '/usr/local/lib'>/etc/ld.so.conf.d/usrlocallib.conf;echo '/usr/local/lib64'>>/etc/ld.so.conf.d/usrlocallib.conf;/sbin/ldconfig;

mkdir -p /home/hadoop/app/sh;mkdir -p $DFSDATA_PATH $DFSDATA2_PATH $DFSDATA3_PATH $DFSDATA4_PATH; mkdir -p $ZOOKEEPERDLOGS_PATH $ZOOKEEPERDATA_PATH;
sudo mkdir -p /home/tmp;sudo chmod 777 /home/tmp;
chmod -R 755 $DFSDATA_PATH $DFSDATA2_PATH $DFSDATA3_PATH $DFSDATA4_PATH $ZOOKEEPERDLOGS_PATH $ZOOKEEPERDATA_PATH;

for i in $(cat $HADOOP_HOME/conf/hdfs); do
	echo "`date +%Y%m%d%t%T` envSet to $i "

	ssh -p 10022 $i "echo 'umask 0022'>>~/.bash_profile;echo '/usr/local/lib'>/etc/ld.so.conf.d/usrlocallib.conf;echo '/usr/local/lib64'>>/etc/ld.so.conf.d/usrlocallib.conf;/sbin/ldconfig;"
	ssh -p 10022 $i "mkdir -p /home/hadoop/app/sh;mkdir -p $DFSDATA_PATH $DFSDATA2_PATH $DFSDATA3_PATH $DFSDATA4_PATH; mkdir -p $ZOOKEEPERDLOGS_PATH $ZOOKEEPERDATA_PATH;sudo mkdir -p /home/tmp;sudo chmod 777 /home/tmp; chmod -R 755 $DFSDATA_PATH $DFSDATA2_PATH $DFSDATA3_PATH $DFSDATA4_PATH $ZOOKEEPERDLOGS_PATH $ZOOKEEPERDATA_PATH;"
done
echo "`date +%Y%m%d%t%T` envSet cluster done ..."
}
shInstall()
{
chmod 770 ~/app/sh/*.sh

for i in $(cat $HADOOP_HOME/conf/hdfs); do
	echo "`date +%Y%m%d%t%T` shInstall to $i "
#scp是直接覆盖
	ssh -p 10022 $i "mkdir -p /home/hadoop/app/sh"
	scp -P 10022 ~/app/sh/*.sh  hadoop@$i:~/app/sh
done
echo "`date +%Y%m%d%t%T` shInstall cluster done ..."
}
jdkInstall()
{
rm -rf ~/jdk1.*; chmod 777 ~/*.bin; ~/jdk-6u37-linux-x64.bin;

for i in $(cat $HADOOP_HOME/conf/hdfs); do
	echo "`date +%Y%m%d%t%T` jdkInstall to $i "

	scp -P 10022 ~/jdk-6u37-linux-x64.bin hadoop@$i:~/
	ssh -p 10022 $i "rm -rf ~/jdk1.*; ~/jdk-6u37-linux-x64.bin; mv -f ~/jdk-6u37-linux-x64.bin ~/app;"
done
mv -f ~/jdk-6u37-linux-x64.bin ~/app
echo "`date +%Y%m%d%t%T` jdkInstall cluster done ..."
}

#$HADOOP_HOME/bin/hadoop namenode -format
#$HADOOP_HOME/bin/start-dfs.sh          $HADOOP_HOME/bin/stop-dfs.sh

#if -overwrite or -update are set, each source URI is interpreted as an isomorphic update to an existing directory.
#$HADOOP_HOME/bin/hadoop distcp -i hdfs://namenode1/foo hdfs://namenode2/bar/foo
#$HADOOP_HOME/bin/hadoop distcp -m 5 hftp://112.25.19.159:50070/user/hive/warehouse/m_asconfuser hdfs://master1:3001/user/hive/warehouse/m_asconfuser
#$HADOOP_HOME/bin/hadoop distcp -m 5 hftp://112.25.19.159:50070/user/hive/warehouse/s_surfashit_wall hdfs://master1:3001/user/hive/warehouse/s_surfashit_wall

#$HADOOP_HOME/bin/hadoop dfsadmin -upgradeProgress status
#$HADOOP_HOME/bin/hadoop-daemon.sh start namenode -upgrade
#$HADOOP_HOME/bin/start-dfs.sh -upgrade
#$HADOOP_HOME/bin/hadoop-daemon.sh stop namenode
#$HADOOP_HOME/bin/hadoop dfsadmin -finalizeUpgrade
#scp /home/hadoop/dfs/data/current/VERSION hadoop@node01:/home/hadoop/dfs/data/current/VERSION
#/home/hadoop/hadoop-hadoop/dfs/data/current/VERSION   /data/dfs/data/current/VERSION

hadoopInstall()
{
#rm -rf $HADOOP_HOME; tar zxf $HADOOP_HOME.tar.gz;mv $HADOOP_HOME.tar.gz ~/app;
##cp:conf, commons-net-2.0.jar, java-mail.jar activation.jar,hive-exec-0.9.0.jar hive-jdbc-0.9.0.jar hive-metastore-0.9.0.jar hive-service-0.9.0.jar libfb303.jar
#cp -f $HADOOP_HOME/conf/hadoop $HADOOP_HOME/bin;rm -f $HADOOP_HOME/lib/commons-net-1.4.1.jar;tar zcf $HADOOP_VS.tgz $HADOOP_VS

for i in $(cat $HADOOP_HOME/conf/hdfs); do
	echo "`date +%Y%m%d%t%T` hadoopInstall to $i "

	scp -P 10022 $HADOOP_HOME.tgz  hadoop@$i:~/
	ssh -p 10022 $i "rm -rf $HADOOP_HOME; tar zxf $HADOOP_HOME.tgz; mv -f $HADOOP_HOME.tgz ~/app;"
done
mv -f $HADOOP_HOME.tgz ~/app
echo "`date +%Y%m%d%t%T` hadoopInstall cluster done ..."
}
distHadoopNNCfgs()
{
for i in $(cat $HADOOP_HOME/conf/hdfs); do
	echo "`date +%Y%m%d%t%T` distHadoopNNCfgs to $i "

#	scp -P 10022 $HADOOP_HOME/conf/*  hadoop@$i:$HADOOP_HOME/conf/
	scp -P 10022 $HADOOP_HOME/conf/*-site.xml $HADOOP_HOME/conf/hadoop-env.sh hadoop@$i:$HADOOP_HOME/conf/
#	scp -P 10022 $HADOOP_HOME/lib/hive-*.jar $HADOOP_HOME/lib/libfb303.jar $HADOOP_HOME/lib/java-mail.jar $HADOOP_HOME/lib/activation.jar $HADOOP_HOME/lib/commons-net-2.0.jar hadoop@$i:$HADOOP_HOME/lib/
done
echo "`date +%Y%m%d%t%T` distHadoopNNCfgs to cluster done ..."
}
distHadoopjtCfgs()
{
for j in 1 2 3; do
	for i in $(cat $HADOOP_HOME/conf/jt$j); do
		echo "`date +%Y%m%d%t%T` distHadoopjt$j'Cfgs' to $i "

		scp -P 10022 $HADOOP_HOME/conf/*.jt$j  hadoop@$i:$HADOOP_HOME/conf/
		ssh -p 10022 $i "rm -f $HADOOP_HOME/conf/mapred-site.xml $HADOOP_HOME/conf/slaves; mv -f $HADOOP_HOME/conf/mapred-site.xml.jt$j $HADOOP_HOME/conf/mapred-site.xml; mv -f $HADOOP_HOME/conf/slaves.jt$j $HADOOP_HOME/conf/slaves;"
	done
done
echo "`date +%Y%m%d%t%T` distHadoopjtCfgs cluster done ..."
}

restartHadoopDn()
{
for i in $(cat $HADOOP_HOME/conf/slaves); do
	echo "`date +%Y%m%d%t%T` restartHadoopDn stop to $i "

	ssh -p 10022 $i "$HADOOP_HOME/bin/hadoop-daemon.sh stop datanode"
done
sleep 5
for i in $(cat $HADOOP_HOME/conf/slaves); do
	echo "`date +%Y%m%d%t%T` restartHadoopDn start to $i "

	ssh -p 10022 $i "$HADOOP_HOME/bin/hadoop-daemon.sh start datanode"
done

echo "`date +%Y%m%d%t%T` restartHadoopDn cluster done ..."
}
restartHadoopjt1tt()
{
for i in $(cat $HADOOP_HOME/conf/slaves.jt1); do
	echo "`date +%Y%m%d%t%T` restartHadoopjt1tt stop to $i "

	ssh -p 10022 $i "$HADOOP_HOME/bin/hadoop-daemon.sh stop tasktracker"
done
sleep 5
for i in $(cat $HADOOP_HOME/conf/slaves.jt1); do
	echo "`date +%Y%m%d%t%T` restartHadoopjt1tt start to $i "

	ssh -p 10022 $i "$HADOOP_HOME/bin/hadoop-daemon.sh start tasktracker"
done

echo "`date +%Y%m%d%t%T` restartHadoopjt1tt cluster done ..."
}
restartHadoopjt2tt()
{
for i in $(cat $HADOOP_HOME/conf/slaves.jt2); do
	echo "`date +%Y%m%d%t%T` restartHadoopjt2tt stop to $i "

	ssh -p 10022 $i "$HADOOP_HOME/bin/hadoop-daemon.sh stop tasktracker"
done
sleep 5
for i in $(cat $HADOOP_HOME/conf/slaves.jt2); do
	echo "`date +%Y%m%d%t%T` restartHadoopjt2tt start to $i "

	ssh -p 10022 $i "$HADOOP_HOME/bin/hadoop-daemon.sh start tasktracker"
done

echo "`date +%Y%m%d%t%T` restartHadoopjt2tt cluster done ..."
}
#nohup $HIVE_HOME/bin/hive --service hiveserver &
#update sds t set t.location=replace(t.location,'hdfs://namenode:','hdfs://master1:');
#update dbs t set t.db_location_uri=replace(t.db_location_uri,'hdfs://namenode:','hdfs://master1:');
distHive()
{
#rm -rf $HIVE_HOME; tar zxf $HIVE_HOME.tar.gz;mv $HIVE_HOME.tar.gz ~/app;
#rm -rf ~/apache-ant-1.8.4; tar zxf ~/apache-ant-1.8.4-bin.tar.gz;
#rm -f $HIVE_HOME/lib/hbase-*.jar;rm -f $HIVE_HOME/lib/zookeeper-*.jar;
##cp:conf, cplatform.tools.jar, jdom.jar ojdbc14_g.jar,WorkManager.jar, hive-hwi-0.9.0.war hive-metastore-0.9.0.jar zookeeper-3.4.4.jar hbase-0.94.2-security.jar protobuf-java-2.4.0a.jar

tar zcf $HIVE_VS.tgz $HIVE_VS

for i in $(cat $HIVE_HOME/conf/dist); do
	echo "`date +%Y%m%d%t%T` distHive to $i "

	scp -P 10022 $HIVE_HOME.tgz ~/apache-ant-1.8.4-bin.tar.gz hadoop@$i:~/
	ssh -p 10022 $i "rm -rf $HIVE_HOME;tar zxf $HIVE_HOME.tgz;rm -rf ~/apache-ant-1.8.4;tar zxf ~/apache-ant-1.8.4-bin.tar.gz;mv -f $HIVE_HOME.tgz ~/app;mv ~/apache-ant-1.8.4-bin.tar.gz ~/app;"
done
mv -f $HIVE_HOME.tgz ~/app;mv ~/apache-ant-1.8.4-bin.tar.gz ~/app;
echo "`date +%Y%m%d%t%T` distHive cluster done ..."
}
distHiveCfgs()
{
for i in $(cat $HIVE_HOME/conf/dist); do
	echo "`date +%Y%m%d%t%T` distHiveCfgs to $i "

#	scp -P 10022 $HIVE_HOME/conf/*  hadoop@$i:$HIVE_HOME/conf/
	scp -P 10022 $HIVE_HOME/conf/*-site.xml $HIVE_HOME/conf/hive-env.sh hadoop@$i:$HIVE_HOME/conf/
#	ssh -p 10022 $i "rm -f $HIVE_HOME/lib/hbase-*.jar;rm -f $HIVE_HOME/lib/zookeeper-*.jar;"
#	scp -P 10022 $HIVE_HOME/lib/zookeeper-3.4.4.jar $HIVE_HOME/lib/hbase-0.94.2-security.jar $HIVE_HOME/lib/protobuf-java-2.4.0a.jar $HIVE_HOME/lib/WorkManager.jar $HIVE_HOME/lib/ojdbc14_g.jar $HIVE_HOME/lib/jdom.jar $HIVE_HOME/lib/cplatform.tools.jar $HIVE_HOME/lib/hive-hwi-0.9.0.war $HIVE_HOME/lib/hive-metastore-0.9.0.jar hadoop@$i:$HIVE_HOME/lib/
done
echo "`date +%Y%m%d%t%T` distHiveCfgs cluster done ..."
}

distZookeeper()
{
#rm -rf $ZOOKEEPER_HOME; tar zxf $ZOOKEEPER_HOME.tar.gz; mv $ZOOKEEPER_HOME.tar.gz ~/app;
cp -f $ZOOKEEPER_HOME/conf/myid $ZOOKEEPERDATA_PATH/;tar zcf  $ZOOKEEPER_VS.tgz $ZOOKEEPER_VS

j=2
for i in $(cat $ZOOKEEPER_HOME/conf/dist); do
	echo "`date +%Y%m%d%t%T` distZookeeper to $i "

	scp -P 10022 $ZOOKEEPER_HOME.tgz  hadoop@$i:~/
	ssh -p 10022 $i "rm -rf $ZOOKEEPER_HOME;tar zxf $ZOOKEEPER_HOME.tgz;echo '$j' > $ZOOKEEPER_HOME/conf/myid;cp -f $ZOOKEEPER_HOME/conf/myid $ZOOKEEPERDATA_PATH/myid;$ZOOKEEPER_HOME/bin/zkServer.sh start;mv -f $ZOOKEEPER_HOME.tgz ~/app"
	j=`expr $j + 1`
done
cp -f $ZOOKEEPER_HOME/conf/myid $ZOOKEEPERDATA_PATH/;$ZOOKEEPER_HOME/bin/zkServer.sh start;mv -f $ZOOKEEPER_HOME.tgz ~/app

echo "`date +%Y%m%d%t%T` distZookeeper cluster done ..."
}
distZookeeperCfgs()
{
j=2
for i in $(cat $ZOOKEEPER_HOME/conf/dist); do
	echo "`date +%Y%m%d%t%T` distZookeeperCfgs to $i "

	scp -P 10022 $ZOOKEEPER_HOME/conf/*  hadoop@$i:$ZOOKEEPER_HOME/conf/
	ssh -p 10022 $i "echo '$j' > $ZOOKEEPER_HOME/conf/myid;cp -f $ZOOKEEPER_HOME/conf/myid $ZOOKEEPERDATA_PATH/myid;$ZOOKEEPER_HOME/bin/zkServer.sh restart"
#	sleep 3
#	ssh -p 10022 $i "$ZOOKEEPER_HOME/bin/zkServer.sh start"
	j=`expr $j + 1`
done
$ZOOKEEPER_HOME/bin/zkServer.sh restart

echo "`date +%Y%m%d%t%T` distZookeeperCfgs cluster done ..."
}

distHbase()
{
#rm -rf $HBASE_HOME; tar zxf $HBASE_HOME.tar.gz; mv $HBASE_HOME.tar.gz ~/app;

ln -s $ZOOKEEPER_HOME/conf/zoo.cfg $HBASE_HOME/conf/zoo.cfg;ln -s $HADOOP_HOME/conf/hdfs-site.xml $HBASE_HOME/conf/hdfs-site.xml
rm -f $HBASE_HOME/lib/hadoop-core-*.jar;rm -f $HBASE_HOME/lib/zookeeper-*.jar
cp $HADOOP_HOME/hadoop-core-*.jar $HBASE_HOME/lib/;cp $ZOOKEEPER_HOME/$ZOOKEEPER_VS.jar $HBASE_HOME/lib/
tar zcf  $HBASE_VS.tgz $HBASE_VS

for i in $(cat $HBASE_HOME/conf/dist); do
	echo "`date +%Y%m%d%t%T` distHbase to $i "

	scp -P 10022 $HBASE_HOME.tgz  hadoop@$i:~/
	ssh -p 10022 $i "rm -rf $HBASE_HOME;tar zxf $HBASE_HOME.tgz;mv -f $HBASE_HOME.tgz ~/app;"
done
mv -f $HBASE_HOME.tgz ~/app;$HBASE_HOME/bin/start-hbase.sh

echo "`date +%Y%m%d%t%T` distHbase cluster done ..."
}
distHbaseCfgs()
{
for i in $(cat $HBASE_HOME/conf/dist); do
	echo "`date +%Y%m%d%t%T` distHbaseCfgs to $i "

#	scp -P 10022 $HBASE_HOME/conf/*  hadoop@$i:$HBASE_HOME/conf/
	scp -P 10022 $HBASE_HOME/conf/hbase-site.xml $HBASE_HOME/conf/hbase-env.sh hadoop@$i:$HBASE_HOME/conf/
done
$HBASE_HOME/bin/stop-hbase.sh;
sleep 10
$HBASE_HOME/bin/start-hbase.sh;
echo "`date +%Y%m%d%t%T` distHbaseCfgs to cluster done ..."
}

tmpRename()
{
#$BASE_HOME/hadoop-0.20.203.0/bin/stop-dfs.sh
#ssh -p 10022 node05 "$BASE_HOME/hadoop-0.20.203.0/bin/stop-mapred.sh"
#ssh -p 10022 master2 "$BASE_HOME/hadoop-0.20.203.0/bin/stop-mapred.sh"
#sleep 10
mv $BASE_HOME/hadoop-0.20.203.0 $HADOOP_HOME;mv $BASE_HOME/hive-0.7.1 $HIVE_HOME;

for i in $(cat $HADOOP_HOME/conf/hdfs); do
	echo "`date +%Y%m%d%t%T` tmpRename hadoop to $i "

	ssh -p 10022 $i "mv $BASE_HOME/hadoop-0.20.203.0 $HADOOP_HOME;"
done
for i in $(cat $HIVE_HOME/conf/dist); do
	echo "`date +%Y%m%d%t%T` tmpRename hive to $i "

	ssh -p 10022 $i "mv $BASE_HOME/hive-0.7.1 $HIVE_HOME;"
done

echo "`date +%Y%m%d%t%T` tmpRename cluster done ..."
}

tmpRestartHadoop()
{
#for i in $(cat $HADOOP_HOME/conf/hdfs); do
#	ssh -p 10022 $i "$HADOOP_HOME/bin/stop-all.sh;"
#done

$HADOOP_HOME/bin/stop-dfs.sh
ssh -p 10022 node05 "$HADOOP_HOME/bin/stop-mapred.sh"
ssh -p 10022 master2 "$HADOOP_HOME/bin/stop-mapred.sh"
ssh -p 10022 master3 "$HADOOP_HOME/bin/stop-mapred.sh"
sleep 10

$HADOOP_HOME/bin/start-dfs.sh
sleep 3
ssh -p 10022 node05 "$HADOOP_HOME/bin/start-mapred.sh"
ssh -p 10022 master2 "$HADOOP_HOME/bin/start-mapred.sh"
ssh -p 10022 master3 "$HADOOP_HOME/bin/start-mapred.sh"

echo "`date +%Y%m%d%t%T` tmpRestartHadoop cluster done ..."
}

tmpDistApp()
{
for i in $(cat /home/hadoop/app/sh/app); do
	echo "`date +%Y%m%d%t%T` tmpDistApp to $i "

	scp -P 10022 -r ~/app/*  hadoop@$i:~/app/
#	ssh -p 10022 $i "mkdir -p /home/hadoop/app_test/liuliang;"
#	scp -P 10022 -r /home/hadoop/app_test/liuliang/*  hadoop@$i:/home/hadoop/app_test/liuliang/
done

echo "`date +%Y%m%d%t%T` tmpDistApp cluster done ..."
}

#路径 /user/hive/warehouse/m_fun/dt=201205
tmpGet2163()
{
HADOOP_HOME=/home/hadoop/hadoop-0.20.203.0
for i in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31; do
	echo "`date +%Y%m%d%t%T` tmpGet2163 to $i "

	$HADOOP_HOME/bin/hadoop fs -getmerge $*$i '/home/hadoop/hadoop-hadoop'$*$i
done

echo "`date +%Y%m%d%t%T` tmpGet2163 cluster done ..."
#rm -rf /home/hadoop/hadoop-hadoop/user
}
#app/sh/hadoop.install.sh --tmpGet2163 /user/hive/warehouse/m_fun/dt=201210
#app/sh/hadoop.install.sh --tmpPut2New m_fun dt=201210
#m_fun dt=201205
tmpPut2New()
{
#mkdir -p /home/hadoop/app_test/liuliang;scp -r hadoop@112.25.19.163:/home/hadoop/app_test/liuliang/*.jar /home/hadoop/app_test/liuliang/
#$HADOOP_HOME/bin/hadoop dfs -rmr -skipTrash /user/hive/warehouse/m_fun/dt=201205*
#$HADOOP_HOME/bin/hadoop dfs -lsr /user/hive/warehouse/m_fun/dt=201205*

mkdir -p /home/hadoop/tmp/user/hive/warehouse/$1
scp -r hadoop@112.25.19.163:/home/hadoop/hadoop-hadoop/user/hive/warehouse/$1/$2* /home/hadoop/tmp/user/hive/warehouse/$1/
for i in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31; do
	echo "`date +%Y%m%d%t%T` tmpPut2New to $i "

	$HADOOP_HOME/bin/hadoop fs -put /home/hadoop/tmp/user/hive/warehouse/$1/$2$i /user/hive/warehouse/$1/$2$i/000000_0
done
echo "`date +%Y%m%d%t%T` tmpPut2New cluster done ..."
#rm -rf /home/hadoop/tmp/user
}

#str=$3    arr=(${str//,/ })    for j in ${arr[@]}

#1) case 语句为多选择语句。一个值与多个模式匹配，如果匹配成功，执行相匹配的命令。每个模式的语句块必须以 2 个分号(;;)结尾
case $1 in

--tmpGet2163)
	shift
	echo $@
	tmpGet2163 $@
	;;
--tmpPut2New)
	shift
	echo $@
	tmpPut2New $@
	;;
--tmpRestartHadoop)
	tmpRestartHadoop
	;;
#--envSet)
#	envSet
#	;;
--shInstall)
	shInstall
	;;
#--jdkInstall)
#	jdkInstall
#	;;
#--hadoopInstall)
#	hadoopInstall
#	;;
--distHadoopNNCfgs)
	distHadoopNNCfgs
	;;
--distHadoopjtCfgs)
	distHadoopjtCfgs
	;;
#--restartHadoopDn)
#	restartHadoopDn
#	;;
#--restartHadoopjt1tt)
#	restartHadoopjt1tt
#	;;
#--restartHadoopjt2tt)
#	restartHadoopjt2tt
#	;;
#--distHive)
#	distHive
#	;;
--distHiveCfgs)
	distHiveCfgs
	;;
#--distZookeeper)
#	distZookeeper
#	;;
--distZookeeperCfgs)
	distZookeeperCfgs
	;;
#--distHbase)
#	distHbase
#	;;
--distHbaseCfgs)
	distHbaseCfgs
	;;
*)
	echo "usage params : --{shInstall|distHadoopNNCfgs|distHadoopjtCfgs|distHiveCfgs|distZookeeperCfgs|distHbaseCfgs} "

esac
