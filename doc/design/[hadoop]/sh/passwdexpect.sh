#!/usr/bin/expect -f
#echo "password" | passwd --stdin hadoop

set cmd_prompt "~]?"
set passuser "hadoop"

set ip [ lindex $argv 0 ]
set port [ lindex $argv 1 ]
set oldpass [ lindex $argv 2 ]
set newpass [ lindex $argv 3 ]

spawn ssh -p $port $passuser@$ip
set timeout 300
expect {
  "*password:" { send "$oldpass\r" }
  $cmd_prompt { send "\r" }
}
#非免鉴权
expect {
  "*password:" { send "$oldpass\r" }
  $cmd_prompt { send "\r" }
}
#-------------------------------------------修改密码
send "passwd \r";
expect {
  "*(current) UNIX password:" { send "$oldpass\r" }
  timeout { exit 4}
  eof { exit 2}
}
expect {
 "New*password:" { send "$newpass\r" }
 "*Only root can *" { exit 3 }
}
expect {
 "Retype new*password:" { send "$newpass\r" }
}
#---------------------------------------------退出
expect -re $cmd_prompt
exit 0


#------------------------------------------------------添加一个新用户并改密码
#expect -re  $cmd_prompt
#sleep 1
#send "useradd  $newusername \r"
#sleep 1
#send "passwd $newusername \r";
#expect {
# "New UNIX password:" {
#   send "$newpasswd\r"
# }
# "passwd: Only root can specify a user name." {
#  exit
# }
#}
#
#expect {
# "Retype new UNIX password:" {
#   send "$newpasswd\r"
# }
#}

# expect {
#     -re "Are you sure you want to continue connecting (yes/no)?" {
#         send "yes\r"
#     } -re "assword:" {
#         send "$loginpass\r"
#     } -re "Permission denied, please try again." {
#        exit
#     } -re "Connection refused" {
#         exit
#     } timeout {
#        exit
#     } eof {
#        exit
#     }
#}


#expect "Connection refused" {exit 5}
#expect {
#     "yes/no" {
#         send "yes\n";
#           }
#      }
#expect "*password:"
#send "$oldpass\r"
#expect "please try again" {exit 1 }
#expect "hadoop@*"
##set timeout 3
##send "su - root\r"
##expect "*password:"
##send "$pass\r"
##expect "incorrect*" {exit 2 }
##expect "su: 密码不正确" {exit 2 }
##expect "root@*"
#set timeout 1
#send "echo $newpass |passwd --stdin\n"
#expect "Only root can do that." {exit 3 }
#expect "successfully."
#send "echo $newpass |passwd --stdin\n"
#expect "Only root can do that." {exit 3 }
#expect "successfully."
#send "exit\n"
#interact


# set ip [lindex $argv 0 ]     #接收第一个参数,并设置IP
# set password [lindex $argv 1 ]   #接收第二个参数,并设置密码
# set timeout 10                   #设置超时时间
# spawn ssh root@$ip       #发送ssh请滶
# expect {                 #返回信息匹配
# "*yes/no" { send "yes\r"; exp_continue}  #第一次ssh连接会提示yes/no,继续
# "*password:" { send "$password\r" }      #出现密码提示,发送密码
# }
# interact          #交互模式,用户会停留在远程服务器上面.


# set ip [lindex $argv 0 ]
# set dir [lindex $argv 1 ]
# set file [lindex $argv 2 ]
# set timeout 10
# spawn ftp $ip
# expect "Name*"
# send "zwh\r"
# expect "Password:*"
# send "zwh\r"
# expect "ftp>*"
# send "lcd $dir\r"
# expect {
# "*file"  { send_user "local $_dir No such file or directory";send "quit\r" }
# "*now*"  { send "get $dir/$file $dir/$file\r"}
# }
# expect {
# "*Failed" { send_user "remote $file No such file";send "quit\r" }
# "*OK"     { send_user "$file has been download\r";send "quit\r"}
# }
# expect eof