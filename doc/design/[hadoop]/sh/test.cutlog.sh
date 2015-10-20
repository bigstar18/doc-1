#!/bin/sh
. /home/hadoop/app/sh/stats.head.v21.sh

ERRORLOG=/home/hadoop/log/util.cutlog.log

app1()
{
## 零点执行该脚本
## Nginx 日志文件所在的目录
LOGS_PATH=/usr/local/nginx/logs
## 获取昨天的 yyyy-MM-dd
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
## 移动文件
mv ${LOGS_PATH}/access.log ${LOGS_PATH}/access_${YESTERDAY}.log
## 向 Nginx 主进程发送 USR1 信号。USR1 信号是重新打开日志文件
kill -USR1 $(cat /usr/local/nginx/nginx.pid)
}

app2()
{
nginx_app=/home/nginx/sbin/nginx #设置nginx的目录
logs_dir=/data/logs/ #log目录
bak_dir=/data/logs/bak/ #log备份目录

#先把现有的log文件挪到备份目录临时存放
cd $logs_dir
echo “moving logs”
/bin/mv *.log $bak_dir
sleep 3

#重建nginx log
echo “rebuild logs”
echo “$nginx_app -s reopen”
$nginx_app -s reopen

#按天打包log文件
echo “begining of tar”
cd $bak_dir
/bin/tar czf `date +%Y%m%d`.tgz *.log

#删除备份目录的临时文件
echo “rm logs”
rm -f *.log
echo “done”
}
