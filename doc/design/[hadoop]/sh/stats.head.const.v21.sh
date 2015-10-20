#!/bin/bash

export LANG=zh_CN.UTF-8

export HADOOP_VS=hadoop-1.0.4
export ZOOKEEPER_VS=zookeeper-3.4.4
export HBASE_VS=hbase-0.94.2-security
export HIVE_VS=hive-0.9.0

export BASE_HOME=/home/hadoop
export MNT_HOME=/data
export JAVA_HOME=$BASE_HOME/jdk1.6.0_37
export ANT_LIB=$BASE_HOME/apache-ant-1.8.4/lib

export HADOOP_HOME=$BASE_HOME/$HADOOP_VS
export ZOOKEEPER_HOME=$BASE_HOME/$ZOOKEEPER_VS
export HBASE_HOME=$BASE_HOME/$HBASE_VS
export HIVE_HOME=$BASE_HOME/$HIVE_VS

DFSNAME_PATH=$BASE_HOME/dfs/name
DFSNAME2_PATH=$MNT_HOME/dfs/name
DFSDATA_PATH=$BASE_HOME/dfs/data
DFSDATA2_PATH=$MNT_HOME/dfs/data
DFSDATA3_PATH=$MNT_HOME/dfs/data2
DFSDATA4_PATH=$MNT_HOME/dfs/data3
ZOOKEEPERDLOGS_PATH=$BASE_HOME/zookeeperlogs
ZOOKEEPERDATA_PATH=$MNT_HOME/zookeeperdata

#TIME=`date +"%F %T"`
#TIME_STR=`date +%Y%m%d%t%T`
TODAY_D=`date +%d`
TODAY_YMD=`date +%Y%m%d`

YESTERDAY_Y=`date -d yesterday +%Y`
YESTERDAY_M=`date -d yesterday +%m`
YESTERDAY_D=`date -d yesterday +%d`
YESTERDAY_YMD=`date -d yesterday +%Y%m%d`

LASTMONTH_M=`date -d last-month +%m`
LASTMONTH_YM=`date -d last-month +%Y%m`

DAY2AGO_Y=`date -d "2 days ago" +%Y`
DAY2AGO_M=`date -d "2 days ago" +%m`
DAY2AGO_D=`date -d "2 days ago" +%d`
DAY2AGO_YMD=`date -d "2 days ago" +%Y%m%d`
DAY3AGO_YMD=`date -d "3 days ago" +%Y%m%d`

if [ $# -eq 3 ] ; then
	YESTERDAY_Y=$1
	YESTERDAY_M=$2
	YESTERDAY_D=$3
	YESTERDAY_YMD=$1$2$3

	if [ "$2" = "01" ] ; then
		LASTMONTH_M='12'
		LASTMONTH_YM=`expr $1 - 1`'12'
	else
		LASTMONTH_YM=`expr $1$2 - 1`
		LASTMONTH_M=${LASTMONTH_YM:4:5}
	fi
fi
STATS_DAY_YMD=$YESTERDAY_YMD
STATS_MONTH_YM=$LASTMONTH_YM
