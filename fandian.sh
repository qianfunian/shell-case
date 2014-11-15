#!/bin/zsh
#if [ -z $1 ] || [[ $1 == 10 ]];then
#echo $1
#fi
#exit
#[ -z STRING ] 如果STRING的长度为零则为真 ，即判断是否为空，空即是真；
#[ -n STRING ] 如果STRING的长度非零则为真 ，即判断是否为非空，非空即是真；
#[ STRING1 = STRING2 ] 如果两个字符串相同则为真 ；
#[ STRING1 != STRING2 ] 如果字符串不相同则为真 ；
#[ STRING1 ]　 如果字符串不为空则为真,与-n类似

if [ -z $1 ] || [ $1 -eq 1 ];then
    ip=192.168.1.1
else
    ip=192.168.2.1
fi
ssh root@$ip
