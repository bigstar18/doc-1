#!/bin/bash
rpm -qa |grep expect &>/dev/null
if [ $? -eq 0 ] ; then
  A_IP=('master2' 'master3' 'master4' 'master5' 'node01' 'node02' 'node03' 'node04' 'node05' 'node06' 'node07' 'node08' 'node09' 'node10' 'node11' 'node12' 'node13' 'llyx010.jsydrd.com' 'llyx011.jsydrd.com' 'llyx012.jsydrd.com' 'llyx013.jsydrd.com' 'llyx014.jsydrd.com' 'llyx015.jsydrd.com' 'llyx016.jsydrd.com' 'llyx017.jsydrd.com' 'llyx018.jsydrd.com')
  A_OLDPD=('hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#' 'hadoop@123!@#')
  #执行循环，一次修改每个服务器的用户密码
  for ((i=0;i<${#A_IP[@]};i++))
  do
    ~/app/sh/passwdexpect.sh ${A_IP[$i]} 10022 ${A_OLDPD[$i]} 'hxx!@#123'
    level=`echo $?`
    #记录修改成功与失败的日志
     [ $level -eq 0 ] && echo "`date +"%F %T"` ${A_IP[$i]} change password ok"

     [ $level -eq 1 ] && echo "`date +"%F %T"` ${A_IP[$i]} 用户密码不正确"
     [ $level -eq 2 ] && echo "`date +"%F %T"` ${A_IP[$i]} 未知错误？"
     [ $level -eq 3 ] && echo "`date +"%F %T"` ${A_IP[$i]} 非root用户"
     [ $level -eq 4 ] && echo "`date +"%F %T"` ${A_IP[$i]} 连接超时"
     [ $level -eq 5 ] && echo "`date +"%F %T"` ${A_IP[$i]} 主机拒绝连接"
  done
else
  echo "请安装expect工具\n"
fi
