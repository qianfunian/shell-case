####删除表中visible 为3，6，7的数据
#####思路:先查slave获取primarykey，在master数据库中删除primarykey 数据

```
#!/bin/bash


date '+%Y-%m-%d %H:%M:%S'

DATABASE='test'
TABLE='test_db'
PRIMARY_FIELD='id'
TIME_FIELD='visible'

my_limit_step=10

my_slave_ip='127.0.0.1'
my_slave_port='3306'
my_slave_user='root'
my_slave_password=''

my_master_ip='192.168.1.102'
my_master_port='3306'
my_master_user='root'
my_master_password=''

slave_mysql="mysql -h${my_slave_ip} -P${my_slave_port} -u${my_slave_user} -p${my_slave_password} -Ns -D ${DATABASE} -e"

master_mysql="mysql -h${my_master_ip} -P${my_master_port} -u${my_master_user} -p${my_master_password} -Ns -D ${DATABASE} -e"

id_list=`$slave_mysql "set session group_concat_max_len=16777216; select group_concat(${PRIMARY_FIELD}) from (select ${PRIMARY_FIELD} from ${TABLE} where ${TIME_FIELD} in (3,6,7) limit ${my_limit_step}) a;"`;

if [ -z $id_list ]
then
echo 'Error: Can not get id_list from slave'
break
elif [ $id_list == 'NULL' ]
then
break
fi

master_error=`$master_mysql "select 1;"`
if [ -z $master_error ]
then
echo 'Error: Can not connect to master'
break
fi
rows=`$master_mysql "select count($PRIMARY_FIELD) from $TABLE where $PRIMARY_FIELD in ($id_list);"`;
echo "rows="$rows
$master_mysql "delete from ${TABLE} where ${PRIMARY_FIELD} in ($id_list);"

```
