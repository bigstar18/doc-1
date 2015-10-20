#!/bin/bash

export LANG=zh_CN.UTF-8

export HADOOP_VS=hadoop-1.0.4
export ZOOKEEPER_VS=zookeeper-3.4.4
export HBASE_VS=hbase-0.94.2-security
export HIVE_VS=hive-0.9.0

export BASE_HOME=/home/hadoop
export MNT_HOME=/data
export JAVA_HOME=$BASE_HOME/jdk1.6.0_25
export ANT_LIB=$BASE_HOME/apache-ant-1.8.4/lib

export HADOOP_HOME=$BASE_HOME/$HADOOP_VS
export ZOOKEEPER_HOME=$BASE_HOME/$ZOOKEEPER_VS
export HBASE_HOME=$BASE_HOME/$HBASE_VS
export HIVE_HOME=$BASE_HOME/$HIVE_VS

DFSNAME_PATH=$BASE_HOME/dfs/name
DFSNAME2_PATH=$MNT_HOME/dfs/name
DFSDATA_PATH=$BASE_HOME/dfs/data
DFSDATA2_PATH=$MNT_HOME/dfs/data
ZOOKEEPERDLOGS_PATH=$BASE_HOME/zookeeperlogs
ZOOKEEPERDATA_PATH=$MNT_HOME/zookeeperdata
