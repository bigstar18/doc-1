#!/bin/sh
. /home/hadoop/app/sh/stats.head.const.v21.sh

ERRORLOG=/home/hadoop/log/hadoop.install.log
SSH_PORT=10022

#rz -bey            sz       ;chmod 700 update.sh;
envSet()
{
mkdir -p $DFSDATA3_PATH $DFSDATA4_PATH;chmod -R 755 $DFSDATA3_PATH $DFSDATA4_PATH;

for i in $(cat $HADOOP_HOME/conf/hdfs); do
	echo "`date +%Y%m%d%t%T` envSet to $i "

#	ssh -p $SSH_PORT $i "echo 'umask 0022'>>~/.bash_profile;"
#	ssh -p $SSH_PORT $i "mkdir -p /home/hadoop/app/sh;mkdir -p $DFSDATA_PATH $DFSDATA2_PATH; mkdir -p $ZOOKEEPERDLOGS_PATH  $ZOOKEEPERDATA_PATH;chmod -R 755 $DFSDATA_PATH $DFSDATA2_PATH $ZOOKEEPERDLOGS_PATH $ZOOKEEPERDATA_PATH;"
	ssh -p $SSH_PORT $i "mkdir -p $DFSDATA3_PATH $DFSDATA4_PATH;chmod -R 755 $DFSDATA3_PATH $DFSDATA4_PATH;"
done
echo "`date +%Y%m%d%t%T` envSet cluster done ..."
}
#ssh -p $SSH_PORT node01 "rm -f /home/hadoop/app/sh/ip.sh /home/hadoop/app/sh/hadoop.install.sh /home/hadoop/app/sh/stats.head.v21.sh /home/hadoop/app/sh/stats.log.ashit.ftp.loop2.sh /home/hadoop/app/sh/update.sh /home/hadoop/app/sh/util.mvExcel.sh;"
shInstall()
{
chmod 770 ~/app/sh;chmod 750 ~/app/sh/*.sh

for i in $(cat $HADOOP_HOME/conf/nodeadd); do
	echo "`date +%Y%m%d%t%T` shInstall to $i "
	ssh -p $SSH_PORT $i "rm -f /home/hadoop/app/sh/ip.sh /home/hadoop/app/sh/hadoop.install.sh /home/hadoop/app/sh/stats.head.v21.sh /home/hadoop/app/sh/stats.log.ashit.ftp.loop2.sh /home/hadoop/app/sh/update.sh /home/hadoop/app/sh/util.mvExcel.sh;"
done
for i in $(cat $HADOOP_HOME/conf/hdfs); do
	echo "`date +%Y%m%d%t%T` shInstall to $i "
#scp是直接覆盖
#	ssh -p $SSH_PORT $i "mkdir -p /home/hadoop/app/sh;chmod 770 ~/app/sh;"
#	scp -P $SSH_PORT ~/app/sh/*.sh  hadoop@$i:~/app/sh
	scp -P $SSH_PORT ~/app/sh/stats.head.const.v21.sh  hadoop@$i:~/app/sh
done
echo "`date +%Y%m%d%t%T` shInstall cluster done ..."
}
jdkInstall()
{
for i in $(cat $HADOOP_HOME/conf/nodeadd); do
	echo "`date +%Y%m%d%t%T` jdkInstall to $i "

	scp -P $SSH_PORT ~/jdk-6u37-linux-x64.bin hadoop@$i:~/
	ssh -p $SSH_PORT $i "rm -rf ~/jdk1.*; ~/jdk-6u37-linux-x64.bin; mv -f ~/jdk-6u37-linux-x64.bin ~/app;"
done
mv -f ~/jdk-6u37-linux-x64.bin ~/app
echo "`date +%Y%m%d%t%T` jdkInstall cluster done ..."
}
distAntAdd()
{
for i in $(cat $HADOOP_HOME/conf/nodeadd); do
	echo "`date +%Y%m%d%t%T` distAntAdd to $i "

	scp -P $SSH_PORT ~/app/apache-ant-1.8.4-bin.tar.gz hadoop@$i:~/
	ssh -p $SSH_PORT $i "rm -rf ~/apache-ant-1.8.4;tar zxf ~/apache-ant-1.8.4-bin.tar.gz;mv ~/apache-ant-1.8.4-bin.tar.gz ~/app;"
done
echo "`date +%Y%m%d%t%T` distAntAdd cluster done ..."
}
hadoopInstall()
{
for i in $(cat $HADOOP_HOME/conf/nodeadd); do
	echo "`date +%Y%m%d%t%T` hadoopInstall to $i "

	scp -P $SSH_PORT $HADOOP_HOME.tgz  hadoop@$i:~/
	ssh -p $SSH_PORT $i "rm -rf $HADOOP_HOME; tar zxf $HADOOP_HOME.tgz; mv -f $HADOOP_HOME.tgz ~/app;"
done
mv -f $HADOOP_HOME.tgz ~/app/hadoop.ibm.tgz
echo "`date +%Y%m%d%t%T` hadoopInstall cluster done ..."
}
distHadoopNNCfgs()
{
for i in $(cat $HADOOP_HOME/conf/hdfs); do
	echo "`date +%Y%m%d%t%T` distHadoopNNCfgs to $i "

	scp -P $SSH_PORT $HADOOP_HOME/conf/hdfs-site.xml*  hadoop@$i:$HADOOP_HOME/conf/
#	scp -P $SSH_PORT $HADOOP_HOME/conf/*  hadoop@$i:$HADOOP_HOME/conf/
#	scp -P $SSH_PORT $HADOOP_HOME/conf/*-site.xml $HADOOP_HOME/conf/hadoop-env.sh hadoop@$i:$HADOOP_HOME/conf/
#	scp -P $SSH_PORT $HADOOP_HOME/lib/hive-*.jar $HADOOP_HOME/lib/libfb303.jar $HADOOP_HOME/lib/java-mail.jar $HADOOP_HOME/lib/activation.jar $HADOOP_HOME/lib/commons-net-2.0.jar hadoop@$i:$HADOOP_HOME/lib/
	ssh -p $SSH_PORT $i "rm -f $HADOOP_HOME/conf/hdfs-site.xml; cp -f $HADOOP_HOME/conf/hdfs-site.xml.dn $HADOOP_HOME/conf/hdfs-site.xml;"
done
for i in $(cat $HADOOP_HOME/conf/nodeadd); do
	echo "`date +%Y%m%d%t%T` cfgNodeaddHdfs to $i "

	ssh -p $SSH_PORT $i "rm -f $HADOOP_HOME/conf/hdfs-site.xml; cp -f $HADOOP_HOME/conf/hdfs-site.xml.add $HADOOP_HOME/conf/hdfs-site.xml;"
done

ssh -p $SSH_PORT node05 "rm -f $HADOOP_HOME/conf/hdfs-site.xml; cp -f $HADOOP_HOME/conf/hdfs-site.xml.nn $HADOOP_HOME/conf/hdfs-site.xml;"
rm -f $HADOOP_HOME/conf/hdfs-site.xml; cp -f $HADOOP_HOME/conf/hdfs-site.xml.nn $HADOOP_HOME/conf/hdfs-site.xml;

echo "`date +%Y%m%d%t%T` distHadoopNNCfgs to cluster done ..."
}
distHadoopjtCfgs()
{
for j in 1 2 3; do
	for i in $(cat $HADOOP_HOME/conf/jt$j); do
		echo "`date +%Y%m%d%t%T` distHadoopjt$j'Cfgs' to $i "

		scp -P $SSH_PORT $HADOOP_HOME/conf/*.jt$j  hadoop@$i:$HADOOP_HOME/conf/
		ssh -p $SSH_PORT $i "rm -f $HADOOP_HOME/conf/mapred-site.xml $HADOOP_HOME/conf/slaves; cp -f $HADOOP_HOME/conf/mapred-site.xml.jt$j $HADOOP_HOME/conf/mapred-site.xml; cp -f $HADOOP_HOME/conf/slaves.jt$j $HADOOP_HOME/conf/slaves;"
	done
done
for i in $(cat $HADOOP_HOME/conf/nodeadd); do
	echo "`date +%Y%m%d%t%T` distHadoopjtaddCfgs to $i "

	ssh -p $SSH_PORT $i "rm -f $HADOOP_HOME/conf/mapred-site.xml; cp -f $HADOOP_HOME/conf/mapred-site.xml.add $HADOOP_HOME/conf/mapred-site.xml;"
done
echo "`date +%Y%m%d%t%T` distHadoopjtCfgs cluster done ..."
}

#restartHadoopDn()
#{
#for i in $(cat $HADOOP_HOME/conf/slaves); do
#	echo "`date +%Y%m%d%t%T` restartHadoopDn stop to $i "
#
#	ssh -p $SSH_PORT $i "$HADOOP_HOME/bin/hadoop-daemon.sh stop datanode"
#done
#sleep 5
#for i in $(cat $HADOOP_HOME/conf/slaves); do
#	echo "`date +%Y%m%d%t%T` restartHadoopDn start to $i "
#
#	ssh -p $SSH_PORT $i "$HADOOP_HOME/bin/hadoop-daemon.sh start datanode"
#done
#
#echo "`date +%Y%m%d%t%T` restartHadoopDn cluster done ..."
#}
#restartHadoopjt1tt()
#{
#for i in $(cat $HADOOP_HOME/conf/slaves.jt1); do
#	echo "`date +%Y%m%d%t%T` restartHadoopjt1tt stop to $i "
#
#	ssh -p $SSH_PORT $i "$HADOOP_HOME/bin/hadoop-daemon.sh stop tasktracker"
#done
#sleep 5
#for i in $(cat $HADOOP_HOME/conf/slaves.jt1); do
#	echo "`date +%Y%m%d%t%T` restartHadoopjt1tt start to $i "
#
#	ssh -p $SSH_PORT $i "$HADOOP_HOME/bin/hadoop-daemon.sh start tasktracker"
#done
#
#echo "`date +%Y%m%d%t%T` restartHadoopjt1tt cluster done ..."
#}
#restartHadoopjt2tt()
#{
#for i in $(cat $HADOOP_HOME/conf/slaves.jt2); do
#	echo "`date +%Y%m%d%t%T` restartHadoopjt2tt stop to $i "
#
#	ssh -p $SSH_PORT $i "$HADOOP_HOME/bin/hadoop-daemon.sh stop tasktracker"
#done
#sleep 5
#for i in $(cat $HADOOP_HOME/conf/slaves.jt2); do
#	echo "`date +%Y%m%d%t%T` restartHadoopjt2tt start to $i "
#
#	ssh -p $SSH_PORT $i "$HADOOP_HOME/bin/hadoop-daemon.sh start tasktracker"
#done
#
#echo "`date +%Y%m%d%t%T` restartHadoopjt2tt cluster done ..."
#}

singleRsHadoopDn()
{
for i in $(cat $HADOOP_HOME/conf/hdfs); do
	echo "`date +%Y%m%d%t%T` singleRsHadoopDn stop to $i "
	ssh -p $SSH_PORT $i "$HADOOP_HOME/bin/hadoop-daemon.sh stop datanode;"
	sleep 3
	echo "`date +%Y%m%d%t%T` singleRsHadoopDn start to $i "
	ssh -p $SSH_PORT $i "$HADOOP_HOME/bin/hadoop-daemon.sh start datanode;"
	sleep 5
done

$HADOOP_HOME/bin/hadoop-daemon.sh stop datanode;
sleep 2
$HADOOP_HOME/bin/hadoop-daemon.sh start datanode;

echo "`date +%Y%m%d%t%T` singleRsHadoopDn cluster done ..."
}

tmpRestartHadoop()
{
#stopall166()
#{
#	ssh -p $SSH_PORT 'master1' "$HADOOP_HOME/bin/stop-dfs.sh;"
#	ssh -p $SSH_PORT 'node05' "$HADOOP_HOME/bin/stop-mapred.sh;"
#	ssh -p $SSH_PORT 'master2' "$HADOOP_HOME/bin/stop-mapred.sh;"
#	ssh -p $SSH_PORT 'master3' "$HADOOP_HOME/bin/stop-mapred.sh;"
#}
#startall166()
#{
#	ssh -p $SSH_PORT 'master1' "$HADOOP_HOME/bin/start-dfs.sh;"
#	ssh -p $SSH_PORT 'node05' "$HADOOP_HOME/bin/start-mapred.sh;"
#	ssh -p $SSH_PORT 'master2' "$HADOOP_HOME/bin/start-mapred.sh;"
#	ssh -p $SSH_PORT 'master3' "$HADOOP_HOME/bin/start-mapred.sh;"
#}

#for i in $(cat $HADOOP_HOME/conf/hdfs); do
#	ssh -p $SSH_PORT $i "$HADOOP_HOME/bin/stop-all.sh;"
#done

$HADOOP_HOME/bin/stop-dfs.sh
ssh -p $SSH_PORT node05 "$HADOOP_HOME/bin/stop-mapred.sh"
ssh -p $SSH_PORT master2 "$HADOOP_HOME/bin/stop-mapred.sh"
ssh -p $SSH_PORT master3 "$HADOOP_HOME/bin/stop-mapred.sh"
sleep 10

$HADOOP_HOME/bin/start-dfs.sh
sleep 3
ssh -p $SSH_PORT node05 "$HADOOP_HOME/bin/start-mapred.sh"
ssh -p $SSH_PORT master2 "$HADOOP_HOME/bin/start-mapred.sh"
ssh -p $SSH_PORT master3 "$HADOOP_HOME/bin/start-mapred.sh"

echo "`date +%Y%m%d%t%T` tmpRestartHadoop cluster done ..."
}
tmpDistApp()
{
for i in $(cat /home/hadoop/app/sh/app); do
	echo "`date +%Y%m%d%t%T` tmpDistApp to $i "

	scp -P $SSH_PORT -r ~/app/*  hadoop@$i:~/app/
#	ssh -p $SSH_PORT $i "mkdir -p /home/hadoop/app_test/liuliang;"
#	scp -P $SSH_PORT -r /home/hadoop/app_test/liuliang/*  hadoop@$i:/home/hadoop/app_test/liuliang/
done

echo "`date +%Y%m%d%t%T` tmpDistApp cluster done ..."
}

#scp -P $SSH_PORT /home/hadoop/hadoop-1.0.4/lib/native/Linux-amd64-64/* hadoop@master1:/home/hadoop/tmp/Linux-amd64-64/
addzip()
{
for i in $(cat $HADOOP_HOME/conf/nodeadd); do
	echo "`date +%Y%m%d%t%T` addzip to $i "

	scp -P $SSH_PORT /home/hadoop/tmp/Linux-amd64-64/*  hadoop@$i:$HADOOP_HOME/lib/native/Linux-amd64-64/
#	scp -P $SSH_PORT $HADOOP_HOME/lib/hadoop-lzo-0.4.15.jar  hadoop@$i:$HADOOP_HOME/lib/
done

echo "`date +%Y%m%d%t%T` addzip to cluster done ..."
}
zipInstall()
{
wget --no-check-certificate https://github.com/kevinweil/hadoop-lzo/archive/master.zip
unzip master ;cd hadoop-lzo-master/;
export JAVA_HOME=/home/hadoop/jdk1.6.0_37/;export CFLAGS=-m64; export CXXFLAGS=-m64;
rm -rf hadoop-gpl-compression-0.1.0.jar lib/native/ lib/*.jar;cp /home/hadoop/hadoop-1.0.4/*.jar ./lib/;
#rm -f /usr/bin/java /usr/bin/jar /usr/bin/javac /usr/bin/javadoc;
#ln -s  /home/hadoop/jdk1.6.0_37/bin/java /usr/bin/java;
#ln -s  /home/hadoop/jdk1.6.0_37/bin/jar /usr/bin/jar;
#ln -s  /home/hadoop/jdk1.6.0_37/bin/javac /usr/bin/javac;
#ln -s  /home/hadoop/jdk1.6.0_37/bin/javadoc /usr/bin/javadoc;
#cp 改动的代码
rm -rf src/java/com;cp -rf /home/hadoop/tmp/com src/java;
#vim build.xml  rpm -qa ant    rpm -e ant-1.7.1-13.el6.x86_64 mv /usr/bin/ant /usr/bin/ant.bak;LDFLAGS=-L/usr/local/lzo/lib CPPFLAGS=-I/usr/local/lzo/include   ./configure
export LDFLAGS=-L/usr/local/lzo/lib;export CPPFLAGS=-I/usr/local/lzo/include;export LD_LIBRARY_PATH=/usr/local/lzo/lib;export C_INCLUDE_PATH=/usr/local/lzo/include; export LIBRARY_PATH=/usr/local/lzo/lib;

/home/hadoop/apache-ant-1.8.4/bin/ant compile-native tar;
rm -f /home/hadoop/hadoop-1.0.4/lib/hadoop-gpl-compression-0.1.0-dev.jar /home/hadoop/hadoop-1.0.4/lib/native/*/libgplcompression* /home/hadoop/hadoop-1.0.4/lib/native/*/libsnappy*;
cp -f build/hadoop-lzo-0.4.15.jar /home/hadoop/hadoop-1.0.4/lib;
cp -f build/hadoop-lzo-0.4.15/lib/native/Linux-amd64-64/* /home/hadoop/hadoop-1.0.4/lib/native/Linux-amd64-64/;
cp -f /usr/local/lib/libsnappy* /home/hadoop/hadoop-1.0.4/lib/native/Linux-amd64-64/
cp -f /usr/local/snappy/lib/libsnappy* /home/hadoop/hadoop-1.0.4/lib/native/Linux-amd64-64/
chown -R hadoop:hadoop /home/hadoop/hadoop-1.0.4/lib/;
#user hadoop      vim core-site.xml   mapred-site.xml  hive-site.xml
#/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -rmr -skipTrash /jar/hadoop-lzo-0.4.15.jar;
/home/hadoop/hadoop-1.0.4/bin/hadoop fs -put /home/hadoop/hadoop-1.0.4/lib/hadoop-lzo-0.4.15.jar  /jar/hadoop-lzo-0.4.15.jar;
#add jar hdfs://master1:3001/jar/hadoop-lzo-0.4.15.jar;
}

case $1 in
--envSet)
	envSet
	;;
--shInstall)
	shInstall
	;;
#--jdkInstall)
#	jdkInstall
#	;;
#--distAntAdd)
#	distAntAdd
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
--singleRsHadoopDn)
	singleRsHadoopDn
	;;
#--addzip)
#	shift
#	addzip $@
#	;;
*)
	echo "usage params : --{envSet|} "

esac
