信号 | 说明
--|--
HUP(1)| 挂起，通常因终端掉线或用户退出而引发
INT(2)| 中断，通常因按下Ctrl+C组合键而引发
QUIT(3)| 退出，通常因按下Ctrl+\组合键而引发
ABRT(6)| 中止，通常因某些严重的执行错误而引发
ALRM(14)| 报警，通常用来处理超时
TERM(15)|  终止，通常在系统关机时发送


```
#!/bin/bash
#经纪人列表下载job

currentFile=`basename $0`
pidfile=/home/www/bin/mendian/pid/$currentFile.pid

execScript() {
  touch $pidfile
  echo $$ > $pidfile
  sleep 10
}

exitScript() {
  rm -f $pidfile
  exit 0
}

trap 'exitScript'  2

if test -e $pidfile then
  kill -0 `cat $pidfile` >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "Another instance is running , `cat $pidfile`"
    exit 1
  else
    rm -f $pidfile
    execScript;
  fi
else
  execScript;
fi
  while true;do
    sleep 3;
    php /home/www/bin/launcher.php Broker_BrokerReportDown &
  done

exitScript;
```
