#!/bin/bash
mysql_db_path="/var/lib/mysql/"
datenow=`date +%Y%m%d`
backup_prefix="/p/backup/data/mysql/"
this_backup_path=${backup_prefix}${datenow}/

rm -rf ${this_backup_path}
mkdir -pv ${this_backup_path}

for db in [fandian waimaibao gaoyang gaoyang_db]
do
    if [ -d ${mysql_db_path}${db} ]; then
           /usr/bin/mysqldump $db --hex-blob -u proxy -pfdw@20120 > ${this_backup_path}/${db}.sql
    echo "${db} done."
    fi
done

clogdir=/p/logs/cherokee/

for x in `ls ${clogdir}`
do
    log=${clogdir}${x}/access.log
    if [ -f $log ]; then
            mv ${log} ${log}.${datenow}
    fi;

    errorlog=${clordir}${x}/error.log
    if [ -f $errorlog ]; then
        mv ${errorlog} ${errorlog}.${datenow}
    fi
done

kill -USR1 `cat /var/run/cherokee.pid`

cd $backup_prefix
tar jcf mysql_${datenow}.tar.bz2 ${this_backup_path}
rm -rf ${this_backup_path}

scp -P 6510 mysql_${datenow}.tar.bz2 pysche@192.168.1.92:/p/backup/servers/230/
rm -rf mysql_${datenow}.tar.bz2

cd /p/backup/logs
cp -R /p/logs/ ./${datenow}
tar jcf logs_${datenow}.tar.bz2 ${datenow}
scp -P 6510 logs_${datenow}.tar.bz2 pysche@192.168.1.92:/p/backup/servers/230/
rm -rf logs_${datenow}.tar.bz2
rm -rf ${datenow}

mkdir -pv syslogs
cp -R /var/log/* ./syslogs

tar jcf syslogs_${datenow}.tar.bz2 syslogs
scp -P 6510 syslogs_${datenow}.tar.bz2 pysche@192.168.1.92:/p/backup/servers/230/
rm -rf syslogs_${datenow}.tar.bz2
rm -rf syslogs

cp -R /p/www/fandian.com/logs/production ${datenow}
rm -rf /p/www/fandian.com/logs/production/*.log
tar jcf application_${datenow}.tar.bz2 ${datenow}
scp -P 6510 application_${datenow}.tar.bz2 pysche@192.168.1.92:/p/backup/servers/230/
rm -rf application_${datenow}.tar.bz2
rm -rf ${datenow}

cd /p/backup/opt
cp -R /opt ${datenow}
tar jcf opt_${datenow}.tar.bz2 ${datenow}
scp -P 6510 opt_${datenow}.tar.bz2 pysche@192.168.1.92:/p/backup/servers/230/
rm -rf opt_${datenow}.tar.bz2
rm -rf ${datenow}
echo "Done."

for x in `ls ${clogdir}`
do
	for y in `find ${clogdir}${x} -name "*.log" -ctime 7`
	do
		rm -rf ${clogdir}${x}/${y}
	done
done
