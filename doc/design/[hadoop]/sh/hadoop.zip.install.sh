#!/bin/sh
. /home/hadoop/app/sh/stats.head.v21.sh

ERRORLOG=/home/hadoop/log/hadoop.zip.install.log

#对hadoop账号启用sudo nopasswd
#visudo
#Cmnd_Alias HADOOPINSTALL=/bin/chown,/bin/chmod,/bin/cp,/sbin/ldconfig,/bin/mkdir
#hadoop    ALL=(ALL)       NOPASSWD: HADOOPINSTALL
install159()
{
stopall159
tar -zcf /home/hadoop/tmp/lib.tgz /usr/local/lib/libsnappy* /usr/local/lib/liblzo2*
for i in 'jobtracker' 'node01' 'node02' 'node03' 'node04' 'node05' 'node06' 'node07' 'node08'; do
	echo "`date +%Y%m%d%t%T` installall to $i "

	ssh -t $i "sudo mkdir -p /home/tmp;sudo chmod 777 /home/tmp;sudo mkdir -p /home/hadoop/tmp;rm -f $HADOOP_HOME/lib/hadoop-gpl-compression-0.1.0-dev.jar $HADOOP_HOME/lib/native/*/libgplcompression*;"
	scp $HADOOP_HOME/conf/core-site.xml $HADOOP_HOME/conf/mapred-site.xml hadoop@$i:$HADOOP_HOME/conf/
	scp $HADOOP_HOME/lib/native/Linux-amd64-64/*  hadoop@$i:$HADOOP_HOME/lib/native/Linux-amd64-64/
	scp $HADOOP_HOME/lib/hadoop-lzo-0.4.15.jar  hadoop@$i:$HADOOP_HOME/lib/
	scp /home/hadoop/tmp/lib.tgz /usr/local/bin/lzop /etc/ld.so.conf.d/usrlocallib.conf hadoop@$i:/home/hadoop/tmp/;
	ssh -t $i "tar -zxf /home/hadoop/tmp/lib.tgz -C /home/hadoop/tmp;sudo cp -fP /home/hadoop/tmp/usr/local/lib/libsnappy* /usr/local/lib/;sudo cp -fP /home/hadoop/tmp/usr/local/lib/liblzo2* /usr/local/lib/;sudo cp -f /home/hadoop/tmp/lzop /usr/local/bin/;sudo chmod 755 /usr/local/bin/lzop;sudo cp -f /home/hadoop/tmp/usrlocallib.conf /etc/ld.so.conf.d/;sudo /sbin/ldconfig;"
done
startall159
echo "`date +%Y%m%d%t%T` installall to cluster done ..."
}
stopall159()
{
	ssh 'namenode' "$HADOOP_HOME/bin/stop-dfs.sh;"
	ssh 'jobtracker' "$HADOOP_HOME/bin/stop-mapred.sh;"
}
startall159()
{
	ssh 'namenode' "$HADOOP_HOME/bin/start-dfs.sh;"
	ssh 'jobtracker' "$HADOOP_HOME/bin/start-mapred.sh;"
}
distHadoopNNCfgs159()
{
stopall159
for i in 'jobtracker' 'node01' 'node02' 'node03' 'node04' 'node05' 'node06' 'node07' 'node08'; do
	echo "`date +%Y%m%d%t%T` distHadoopNNCfgs to $i "

	scp $HADOOP_HOME/conf/*-site.xml hadoop@$i:$HADOOP_HOME/conf/
done
startall159
echo "`date +%Y%m%d%t%T` distHadoopNNCfgs to cluster done ..."
}

installall166()
{
stopall166

scp -P 10022 $HIVE_HOME/conf/hive-site.xml hadoop@node05:$HIVE_HOME/conf/
scp -P 10022 $HIVE_HOME/conf/hive-site.xml hadoop@master2:$HIVE_HOME/conf/
scp -P 10022 $HIVE_HOME/conf/hive-site.xml hadoop@master3:$HIVE_HOME/conf/

for i in $(cat $HADOOP_HOME/conf/hdfs); do
	echo "`date +%Y%m%d%t%T` installall166 to $i "

	scp -P 10022 $HADOOP_HOME/conf/core-site.xml $HADOOP_HOME/conf/mapred-site.xml* hadoop@$i:$HADOOP_HOME/conf/
	scp -P 10022 $HADOOP_HOME/lib/native/Linux-amd64-64/*  hadoop@$i:$HADOOP_HOME/lib/native/Linux-amd64-64/
	scp -P 10022 $HADOOP_HOME/lib/hadoop-lzo-0.4.15.jar  hadoop@$i:$HADOOP_HOME/lib/
done
distHadoopjtCfgs166
startall166
#kill -9 `ps -ef|grep 'HiveServer'|grep -v grep|awk '{print $2}'`
HiveServerPid=`ssh -p 10022 node05 "ps -ef|grep 'HiveServer'|grep -v grep;" | awk '{print $2}'`;ssh -p 10022 node05 "kill -9 $HiveServerPid";
HiveServerPid=`ssh -p 10022 master2 "ps -ef|grep 'HiveServer'|grep -v grep;" | awk '{print $2}'`;ssh -p 10022 master2 "kill -9 $HiveServerPid";
HiveServerPid=`ssh -p 10022 master3 "ps -ef|grep 'HiveServer'|grep -v grep;" | awk '{print $2}'`;ssh -p 10022 master3 "kill -9 $HiveServerPid";

echo "`date +%Y%m%d%t%T` installall166 to cluster done ..."
}
distHadoopjtCfgs166()
{
for j in 1 2 3; do
	for i in $(cat $HADOOP_HOME/conf/jt$j); do
		echo "`date +%Y%m%d%t%T` distHadoopjt$j'Cfgs' to $i "

		scp -P 10022 $HADOOP_HOME/conf/*.jt$j  hadoop@$i:$HADOOP_HOME/conf/
		ssh -p 10022 $i "rm -f $HADOOP_HOME/conf/mapred-site.xml $HADOOP_HOME/conf/slaves; mv -f $HADOOP_HOME/conf/mapred-site.xml.jt$j $HADOOP_HOME/conf/mapred-site.xml; mv -f $HADOOP_HOME/conf/slaves.jt$j $HADOOP_HOME/conf/slaves;"
	done
done
echo "`date +%Y%m%d%t%T` distHadoopjtCfgs to cluster done ..."
}
stopall166()
{
	ssh -p 10022 'master1' "$HADOOP_HOME/bin/stop-dfs.sh;"
	ssh -p 10022 'node05' "$HADOOP_HOME/bin/stop-mapred.sh;"
	ssh -p 10022 'master2' "$HADOOP_HOME/bin/stop-mapred.sh;"
	ssh -p 10022 'master3' "$HADOOP_HOME/bin/stop-mapred.sh;"
}
startall166()
{
	ssh -p 10022 'master1' "$HADOOP_HOME/bin/start-dfs.sh;"
	ssh -p 10022 'node05' "$HADOOP_HOME/bin/start-mapred.sh;"
	ssh -p 10022 'master2' "$HADOOP_HOME/bin/start-mapred.sh;"
	ssh -p 10022 'master3' "$HADOOP_HOME/bin/start-mapred.sh;"
}
install166()
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
#vim build.xml  rpm -qa ant    rpm -e ant-1.7.1-13.el6.x86_64 mv /usr/bin/ant /usr/bin/ant.bak;   LDFLAGS=-L/usr/local/lzo/lib CPPFLAGS=-I/usr/local/lzo/include ./configure
export LDFLAGS=-L/usr/local/lzo/lib;export CPPFLAGS=-I/usr/local/lzo/include;export LD_LIBRARY_PATH=/usr/local/lzo/lib;export C_INCLUDE_PATH=/usr/local/lzo/include; export LIBRARY_PATH=/usr/local/lzo/lib;

/home/hadoop/apache-ant-1.8.4/bin/ant compile-native tar;
rm -f /home/hadoop/hadoop-1.0.4/lib/hadoop-gpl-compression-0.1.0-dev.jar /home/hadoop/hadoop-1.0.4/lib/native/*/libgplcompression*;
cp -f build/hadoop-lzo-0.4.15.jar /home/hadoop/hadoop-1.0.4/lib;
cp -f build/hadoop-lzo-0.4.15/lib/native/Linux-amd64-64/* /home/hadoop/hadoop-1.0.4/lib/native/Linux-amd64-64/;
chown -R hadoop:hadoop /home/hadoop/hadoop-1.0.4/lib/;
#user hadoop      vim core-site.xml   mapred-site.xml  hive-site.xml
#/home/hadoop/hadoop-1.0.4/bin/hadoop dfs -rmr -skipTrash /jar/hadoop-lzo-0.4.15.jar;
/home/hadoop/hadoop-1.0.4/bin/hadoop fs -put /home/hadoop/hadoop-1.0.4/lib/hadoop-lzo-0.4.15.jar  /jar/hadoop-lzo-0.4.15.jar;
add jar hdfs://master1:3001/jar/hadoop-lzo-0.4.15.jar;
}

case $1 in

#--install159)
#	shift
#	install159 $@
#	;;
#--distHadoopNNCfgs159)
#	shift
#	distHadoopNNCfgs159 $@
#	;;
--installall166)
	shift
	installall166 $@
	;;
*)
	echo "usage params : --{installall166|} "

esac
