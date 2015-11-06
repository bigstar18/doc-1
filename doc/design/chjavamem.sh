#!/bin/sh
if [ $# -eq 3 ] ; then
	#files=`find ~/ -name "start.sh"`
	#find ~/ -name "catalina.sh" 
	files=`find ~/ -name "$1"`

	for f in $files ; do
		sed -i 's#-Xms.*m #-Xms'$2' #' $f;
		sed -i 's#-Xmx.*m #-Xmx'$3' #' $f;
	done
else
	echo "input the java env set file name, eg: ./chjavamem.sh catalina.sh"
fi


#-Xms2g -Xmx3500m -Xss1024K -XX:PermSize=256m -XX:MaxPermSize=512m

    #JAVA_MEM_OPTS=" -server -d64 -Xmx2g -Xms2g -Xmn256m -XX:PermSize=128m -Xss256k -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 "
