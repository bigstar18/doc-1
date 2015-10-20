#!/bin/bash

#脚本分类：stats.log,stats.task,stats.monitor  脚本编码：UTF-8
#Shell中的变量只能由字母，数字和下划线组成，且不能以数字开头。如果变量值中含有空格，应该用引号(单引号双引号均可)括起，比如 "Hello world"或'Hello world'。
#*号的匹配问题：系统命令后的参数不要引号，函数的参数里面的*需要‘’防止被匹配
#在条件中，引用变量一定要用双引号 ，否则报错   等号左右都没有空格。
#sh -n验证脚本   -x调试
#执行内建命令相当于调用Shell进程中的一个函数，并不创建新的进程。凡是用which命令查不到程序文件所在位置的命令都是内建命令
#通常也用0表示成功非零表示失败，虽然内建命令不创建新的进程，但执行结束后也会有一个状态码，也可以用特殊变量$?读出
#source或者.命令是Shell的内建命令，这种方式也不会创建子Shell，而是直接在交互式Shell下逐行执行脚本中的命令。
#./script.sh   $ sh ./script.sh  交互Shell（bash）fork/exec一个子Shell（sh）用于执行脚本，父进程bash等待子进程sh终止。
#命令代换：`或 $()   算术计算，$(())中的Shell变量取值将转换成整数

. /home/hadoop/app/sh/stats.head.const.v21.sh


RETRY_COUNT=2
RETRY=2
SUCCESS_TOTAL=1
NOTIFYTODB_SUCCESS=0

#远程路径、文件名、本地路径、文件名
scpFile()
{
if [ $SUCCESS_TOTAL -eq 1 ] ; then
	rm -f $3/$4
	rm -rf $3/tmp/*
	scp -P 10022 $1/$2 $3/$4
	if [ $? -ne 0 ] ; then
		echo "`date +%Y%m%d%t%T` $1/$2 scpFile error"
		RETRY=`expr $RETRY - 1`
		if [ $RETRY -gt 0 ] ; then
			echo "`date +%Y%m%d%t%T` sleep 30 to retry $1/$2 scpFile"
			sleep 30
			scpFile $@
		else
			SUCCESS_TOTAL=0
		fi
	else
		echo "`date +%Y%m%d%t%T` $1/$2 scpFile success"
		SUCCESS_TOTAL=1
	fi
fi
RETRY=$RETRY_COUNT
}
#Ip地址、用户、密码、远程服务器中源文件的目录、将源文件放在本地主机的目录、获取的文件
ftpFile()
{
if [ "x$5" == "x" ]; then
    SUCCESS_TOTAL=0
    return
else
	if [ "$5" == "$BASE_HOME" ]; then
	    SUCCESS_TOTAL=0
	    return
	fi
	if [ "$5" == "$BASE_HOME/" ]; then
	    SUCCESS_TOTAL=0
	    return
	fi
fi
if [ $SUCCESS_TOTAL -eq 1 ] ; then
#        rm -f $5/*
	rm -rf $5/*
#如果使用<<- ，则会忽略接下来输入行首的tab，结束行也可以是一堆tab再加上一个与text相同的内容
	#批量下载文件
	ftp -v -n $1<<FTP
	user $2 $3
	binary
#	passive
	quote pasv
	prompt
	cd $4
	lcd $5
	mget "$6"
	bye
FTP
#如果使用<<- ，则会忽略接下来输入行首的tab，结束行也可以是一堆tab再加上一个与text相同的内容
	if [ $? -ne 0 ] ; then
		echo "`date +%Y%m%d%t%T` $4/$6 ftpFile error"
		RETRY=`expr $RETRY - 1`
		if [ $RETRY -gt 0 ] ; then
			echo "`date +%Y%m%d%t%T` sleep 30 to retry $4/$6 ftpFile"
			sleep 30
			ftpFile $@
		else
			SUCCESS_TOTAL=0
		fi
	else
		echo "`date +%Y%m%d%t%T` $4/$6 ftpFile success"
		SUCCESS_TOTAL=1
	fi
fi
RETRY=$RETRY_COUNT
}
#本地路径、文件名、转码
gunzipFile()
{
if [ $SUCCESS_TOTAL -eq 1 ] ; then
	gunzip  $1/$2.gz
	if [ $? -ne 0 ] ; then
		echo "`date +%Y%m%d%t%T` $1/$2 gunzipFile error"
		SUCCESS_TOTAL=0
	else
		if [ "$3" = "iconv" ] ; then
			iconv -f GBK -t UTF-8//IGNORE -c -o $1/$2'tmp' $1/$2
			SUCCESS_TOTAL=1
			echo "`date +%Y%m%d%t%T` $1/$2 gunzipFile success"
		else
			echo "`date +%Y%m%d%t%T` $1/$2 gunzipFile success"
			SUCCESS_TOTAL=1
		fi
	fi
fi
RETRY=$RETRY_COUNT
}
#本地路径、生成文件名、转码
gunzipFiles()
{
if [ $SUCCESS_TOTAL -eq 1 ] ; then
        gzip -d  $1/tmp/*.gz
	if [ $? -ne 0 ] ; then
		echo "`date +%Y%m%d%t%T` $1/$2 gunzipFiles error"
		SUCCESS_TOTAL=0
	else
		cat $1/tmp/* >$1/$2
		if [ $? -eq 0 ] ; then
			if [ "$3" = "iconv" ] ; then
				iconv -f GBK -t UTF-8//IGNORE -c -o $1/$2'tmp' $1/$2
				SUCCESS_TOTAL=1
				echo "`date +%Y%m%d%t%T` $1/$2 gunzipFiles success"
			else
				echo "`date +%Y%m%d%t%T` $1/$2 gunzipFiles success"
				SUCCESS_TOTAL=1
			fi
		else
			echo "`date +%Y%m%d%t%T` $1/$2 gunzipFiles cat error"
			SUCCESS_TOTAL=0
		fi
	fi
	rm -rf $1/tmp/*
fi
RETRY=$RETRY_COUNT
}
#源、目的、转码
catFiles()
{
if [ $SUCCESS_TOTAL -eq 1 ] ; then
	cat $1 >$2
	if [ $? -eq 0 ] ; then
		if [ "$3" = "iconv" ] ; then
			iconv -f GBK -t UTF-8//IGNORE -c -o $2'tmp' $2
			SUCCESS_TOTAL=1
			echo "`date +%Y%m%d%t%T` $1 catFiles success"
		else
			echo "`date +%Y%m%d%t%T` $1 catFiles success"
			SUCCESS_TOTAL=1
		fi
	else
		echo "`date +%Y%m%d%t%T` $1 catFiles cat error"
		SUCCESS_TOTAL=0
	fi
fi
RETRY=$RETRY_COUNT
}
#本地路径、文件名、转码、提取文件名
untarFile()
{
if [ "x$1" == "x" ]; then
    SUCCESS_TOTAL=0
    return
else
	if [ "$1" == "$BASE_HOME" ]; then
	    SUCCESS_TOTAL=0
	    return
	fi
	if [ "$1" == "$BASE_HOME/" ]; then
	    SUCCESS_TOTAL=0
	    return
	fi
fi
if [ $SUCCESS_TOTAL -eq 1 ] ; then
        tar -zxf  $1/$2 -C $1/
        if [ $? -ne 0 ] ; then
		echo "`date +%Y%m%d%t%T` $1/$2 untarFile error"
                SUCCESS_TOTAL=0
        else
                if [ "$3" = "iconv" ] ; then
                        iconv -f GBK -t UTF-8//IGNORE -c -o $1/$YESTERDAY_D/$4'tmp' $1/$YESTERDAY_D/$4
                        SUCCESS_TOTAL=1
			echo "`date +%Y%m%d%t%T` $1/$2 untarFile success"
		else
			echo "`date +%Y%m%d%t%T` $1/$2 untarFile success"
                        SUCCESS_TOTAL=1
                fi
        fi
        rm -rf $1/$2
fi
RETRY=$RETRY_COUNT
}
#本地路径、文件名、转码、提取文件名      没有自动加子目录
untarFile2()
{
if [ "x$1" == "x" ]; then
    SUCCESS_TOTAL=0
    return
else
	if [ "$1" == "$BASE_HOME" ]; then
	    SUCCESS_TOTAL=0
	    return
	fi
	if [ "$1" == "$BASE_HOME/" ]; then
	    SUCCESS_TOTAL=0
	    return
	fi
fi
if [ $SUCCESS_TOTAL -eq 1 ] ; then
	tar -zxf  $1/$2 -C $1/
	if [ $? -ne 0 ] ; then
		echo "`date +%Y%m%d%t%T` $1/$2 untarFile2 error"
		SUCCESS_TOTAL=0
	else
		if [ "$3" = "iconv" ] ; then
			iconv -f GBK -t UTF-8//IGNORE -c -o $1/$4'tmp' $1/$4
			SUCCESS_TOTAL=1
			echo "`date +%Y%m%d%t%T` $1/$2 untarFile2 success"
		else
			echo "`date +%Y%m%d%t%T` $1/$2 untarFile2 success"
			SUCCESS_TOTAL=1
		fi
	fi
	rm -rf $1/$2
fi
RETRY=$RETRY_COUNT
}
#本地路径、文件名、转码、提取文件名1、提取文件名2
untarMultiFiles()
{
if [ "x$1" == "x" ]; then
    SUCCESS_TOTAL=0
    return
else
	if [ "$1" == "$BASE_HOME" ]; then
	    SUCCESS_TOTAL=0
	    return
	fi
	if [ "$1" == "$BASE_HOME/" ]; then
	    SUCCESS_TOTAL=0
	    return
	fi
fi
if [ $SUCCESS_TOTAL -eq 1 ] ; then
        tar -zxf  $1/$2 -C $1/
        if [ $? -ne 0 ] ; then
		echo "`date +%Y%m%d%t%T` $1/$2 untarFile error"
                SUCCESS_TOTAL=0
        else
                if [ "$3" = "iconv" ] ; then
                        iconv -f GBK -t UTF-8//IGNORE -c -o $1/$YESTERDAY_D/$4'tmp' $1/$YESTERDAY_D/$4
                        iconv -f GBK -t UTF-8//IGNORE -c -o $1/$YESTERDAY_D/$5'tmp' $1/$YESTERDAY_D/$5
                        SUCCESS_TOTAL=1
			echo "`date +%Y%m%d%t%T` $1/$2 untarFile success"
		else
			echo "`date +%Y%m%d%t%T` $1/$2 untarFile success"
                        SUCCESS_TOTAL=1
                fi
        fi
        rm -rf $1/$2
fi
RETRY=$RETRY_COUNT
}
#本地路径、文件名、转码、提取文件名
iconvFile()
{
if [ $SUCCESS_TOTAL -eq 1 ] ; then
        iconv -f GBK -t UTF-8//IGNORE -c -o $1/$YESTERDAY_D/$2'tmp' $1/$YESTERDAY_D/$2
        SUCCESS_TOTAL=1
        echo "`date +%Y%m%d%t%T` $1/$2 iconvFile success"
fi
#RETRY=$RETRY_COUNT
}
#本地文件名、dfs文件名
saveToDFS()
{
if [ $SUCCESS_TOTAL -eq 1 ] ; then
	$HADOOP_HOME/bin/hadoop dfs -rmr -skipTrash $2
	$HADOOP_HOME/bin/hadoop dfs -copyFromLocal $1 $2
	if [ $? -ne 0 ] ; then
		echo "`date +%Y%m%d%t%T` $2 saveToDFS error"
		RETRY=`expr $RETRY - 1`
		if [ $RETRY -gt 0 ] ; then
			echo "`date +%Y%m%d%t%T` sleep 30 to retry $2 saveToDFS"
			sleep 30
			saveToDFS $@
		else
			SUCCESS_TOTAL=0
		fi
	else
		echo "`date +%Y%m%d%t%T` $2 saveToDFS success"
		SUCCESS_TOTAL=1
	fi
fi
RETRY=$RETRY_COUNT
}
#本地文件目录、dfs文件目录、本地文件名1、dfs文件名1、本地文件名2、dfs文件名2
saveMultiToDFS()
{
if [ $SUCCESS_TOTAL -eq 1 ] ; then
        $HADOOP_HOME/bin/hadoop dfs -rmr -skipTrash $2/$4
        $HADOOP_HOME/bin/hadoop dfs -rmr -skipTrash $2/$6
        $HADOOP_HOME/bin/hadoop dfs -copyFromLocal $1/$3 $2/$4
        $HADOOP_HOME/bin/hadoop dfs -copyFromLocal $1/$5 $2/$6
        if [ $? -ne 0 ] ; then
                echo "`date +%Y%m%d%t%T` $2 saveToDFS error"
                RETRY=`expr $RETRY - 1`
                if [ $RETRY -gt 0 ] ; then
                        echo "`date +%Y%m%d%t%T` sleep 30 to retry $2 saveToDFS"
                        sleep 30
                        saveMultiToDFS $@
                else
                        SUCCESS_TOTAL=0
                fi
        else
                echo "`date +%Y%m%d%t%T` $2 saveToDFS success"
                SUCCESS_TOTAL=1
        fi
fi
RETRY=$RETRY_COUNT
}
#日期、文件名
notifyToDB()
{
if [ $SUCCESS_TOTAL -eq 1 ] ; then
	$JAVA_HOME/bin/java -jar /home/hadoop/app/HiveFile.jar $1 $2 "ok"
	if [ $? -ne 0 ] ; then
		echo "`date +%Y%m%d%t%T` $1$2 notifySuccessToDB error"
		RETRY=`expr $RETRY - 1`
		if [ $RETRY -gt 0 ] ; then
			echo "`date +%Y%m%d%t%T` sleep 60 to retry $1$2 notifySuccessToDB"
			sleep 60
			notifyToDB $@
		else
			NOTIFYTODB_SUCCESS=0
		fi
	else
		echo "`date +%Y%m%d%t%T` $1$2 notifySuccessToDB success--------------------------------------------"
		NOTIFYTODB_SUCCESS=1
	fi
else
	$JAVA_HOME/bin/java -jar /home/hadoop/app/HiveFile.jar $1 $2 "error"
	if [ $? -ne 0 ] ; then
		echo "`date +%Y%m%d%t%T` $1$2 notifyFailureToDB error"
		RETRY=`expr $RETRY - 1`
		if [ $RETRY -gt 0 ] ; then
			echo "`date +%Y%m%d%t%T` sleep 60 to retry $1$2 notifyFailureToDB"
			sleep 60
			notifyToDB $@
		else
			NOTIFYTODB_SUCCESS=0
		fi
	else
		echo "`date +%Y%m%d%t%T` $1$2 notifyFailureToDB success--------------------------------------------"
		NOTIFYTODB_SUCCESS=1
	fi
fi
RETRY=$RETRY_COUNT
}
#日期、文件名
#拷贝任务没有开始返回0，其他状态（运行中、成功）返回非0；直接创建一条记录，再创建就抛异常
beginJobDB()
{
$JAVA_HOME/bin/java -jar /home/hadoop/app/HiveFile.jar $1 $2 "run"
if [ $? -ne 0 ] ; then
	echo "`date +%Y%m%d%t%T` $1$2 beginJobDB error"
	RETRY=`expr $RETRY - 1`
	if [ $RETRY -gt 0 ] ; then
		echo "`date +%Y%m%d%t%T` sleep 10 to retry $1$2 beginJobDB"
		sleep 10
		beginJobDB $@
	else
		SUCCESS_TOTAL=0
	fi
else
	echo "`date +%Y%m%d%t%T` $1$2 beginJobDB success--------------------------------------------"
	SUCCESS_TOTAL=1
fi
RETRY=$RETRY_COUNT
}
