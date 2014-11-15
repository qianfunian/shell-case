#!/bin/sh
#MAC设置IPV6
EN0_IP=`/sbin/ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}'`
EN1_IP=`/sbin/ifconfig en1 | grep inet | grep -v inet6 | awk '{print $2}'`

if [ -n "$EN0_IP" ]; then
  LOCAL_IP=$EN0_IP
else
  LOCAL_IP=$EN1_IP
fi

INET6=`/sbin/ifconfig gif0 | grep "inet6 2001" | awk '{print $2}'`

if [ -n "$INET6" ]; then
	for i in $INET6 ;
  do  `/sbin/ifconfig gif0 inet6 $i delete`; done
fi

if [ -n "$LOCAL_IP" ]; then
  /sbin/ifconfig gif0 tunnel $LOCAL_IP 172.16.100.9
  /sbin/ifconfig gif0 inet6 2001:470:36:104:0:5efe:$LOCAL_IP prefixlen 64
  /sbin/route delete -inet6 default
  /sbin/route add -inet6 default 2001:470:36:104::1
fi
