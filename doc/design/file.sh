#!/bin/sh
#unzip -o   overwrite files WITHOUT prompting  

#-n∶使用安静(silent)模式。在一般 sed 的用法中，所有来自 STDIN的资料一般都会被列出到萤幕上。但如果加上 -n 参数后，则只有经过sed 特殊处理的那一行(或者动作)才会被列出来。
#-i∶直接修改读取的档案内容，而不是由萤幕输出。       
#s  ∶取代，可以直接进行取代的工作哩！通常这个 s 的动作可以搭配正规表示法！例如 1,20s/old/new/g 就是啦！
#p  ∶列印，亦即将某个选择的资料印出。通常 p 会与参数 sed -n 一起运作～
#g	 在行内进行全局替换

#-Xms2g -Xmx3500m -XX:PermSize=256m -XX:MaxPermSize=512m
# JAVA_OPTS="-Xms1024m -Xmx2048m -XX:PermSize=128m -XX:MaxPermSize=256m -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70"
#JAVA_MEM_OPTS=" -server -d64 -Xmx2g -Xms2g -Xmn256m -XX:PermSize=128m -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 "

#./file.sh --replaceFile MarketMessage_zh_CN.properties
#./file.sh --replaceFile rmi.properties
#./file.sh --replaceFile jdbc.properties
# sed -n "/-Xm.*-Xm.*[mgMG]/p" ./vendue_core/start.sh;

#./file.sh --replaceStr .bash_profile GNNT YRDCE
#/users/file.sh --replaceStr .bash_profile GNNT YRDCE

#find ~/ -type f -name "keycode.js" -o -name "InstallOCX.zip" -o -name "GnntKey.cab"  -exec rm -f  {} \;   problem：多个不行
#find ~/ -type f -name "keycode.js" -o -name "InstallOCX.zip" -o -name "GnntKey.cab" | xargs -i rm -f {}\; 
#find ~/ -type f -name "keycode.js" -o -name "InstallOCX.zip" -o -name "GnntKey.cab" | xargs rm -f; 
#find . -name *.pdf | xargs -i cp {} ../docbook_pdf/           xargs -i xxx ：其中xxx==cp {} ../docbook_pdf/，表示将输入的内容，用{}替换   xargs -I{} cp {} dir


export LANG=zh_CN.UTF-8

chgMem()
{
if [ $# -eq 3 ] ; then
	#files=`find ~/ -name "$1"`
	#for f in $files ; do
		#sed -i "s#-Xms.*m #-Xms'$2' #g" $f;
		#sed -i "s#-Xmx.*m #-Xmx'$3' #g" $f;
	#done

	files=`find ~/ -name "$1"`
	for f in $files ; do
		sed -i "s/-Xm.*-Xm.*[mgMG]/-Xms$2 -Xmx$3/g" $f;
	done

else
	echo "input the java env set file name, eg: ./file.sh --chgMem catalina.sh 2g 2g"
fi
}

replaceFile()
{
find ~/ -type f -name $1 -exec cp -f $1 {} \;
find ~/ -type f -name $1 -print;
#find ~/ -type f -name $1 -exec cat {} \;
}

#此时需要把单引号改成双引号,如下边例子
replaceStr()
{
str=$2;
to=$3;
find ~/ -type f -name $1 | xargs sed -i "s/$str/$to/g"  
find ~/ -type f -name $1 -print;
}

printStr()
{
str=$2;
find ~/ -type f -name $1 | xargs sed -n "/$str/p"  
}


#cat /dev/null>nohup.out
case $1 in
--replaceFile)
	shift
	replaceFile $@
	;;
--replaceStr)
	shift
	replaceStr $@
	;;
--printStr)
	shift
	printStr $@
	;;
--chgMem)
	shift
	chgMem $@
	;;
*)
	echo "`date +"%F %T"` error $@"
esac
