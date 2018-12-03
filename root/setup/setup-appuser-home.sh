#!/bin/sh

# create usr
mkdir /home/appuser/

mkdir /home/appuser/bin

cp -R /home/root/setup/appuser/bin/* /home/appuser/bin


# create etc
mkdir /home/appuser/etc

mkdir /home/appuser/etc/mysql
cp -R /home/root/setup/appuser/etc/mysql/* /home/appuser/etc/mysql

mkdir /home/appuser/etc/nginx
cp -R /home/root/setup/appuser/etc/nginx/* /home/appuser/etc/nginx

# create var
mkdir /home/appuser/var
mkdir /home/appuser/var/lib

mkdir /home/appuser/var/lib/mysql
mkdir /home/appuser/var/lib/mysql/datadir
mkdir /home/appuser/var/lib/mysql/log
mkdir /home/appuser/var/lib/mysql/tmp

mkdir /home/appuser/var/lib/nginx
mkdir /home/appuser/var/lib/nginx/logs

mkdir /home/appuser/var/lib/geth
mkdir /home/appuser/var/lib/geth/datadir


mkdir /home/appuser/var/lib/ethereum_webapp

# write launch.config
echo "# bootstrap" > /home/appuser/launch.config
printf "USERNAME=$USERID\n" >> /home/appuser/launch.config
printf "USERID=$USERID\n" >> /home/appuser/launch.config
printf "\n" >> /home/appuser/launch.config

printf "# launcher\n" >> /home/appuser/launch.config
printf "LAUNCHER=/home/appuser/bin/launcher.sh\n" >> /home/appuser/launch.config
printf "\n" >> /home/appuser/launch.config

printf "# shell\n" >> /home/appuser/launch.config
printf "SHELL=/bin/bash\n" >> /home/appuser/launch.config
printf "\n" >> /home/appuser/launch.config

printf "# nginx\n" >> /home/appuser/launch.config
printf "NGINX_DIR=/usr/sbin\n" >> /home/appuser/launch.config
printf "NGINX_CONF=/home/appuser/etc/nginx/nginx.conf\n" >> /home/appuser/launch.config
printf "NGINX_ERROR_LOG_DIR=/home/appuser/var/lib/nginx/logs/error.log\n" >> /home/appuser/launch.config
printf "\n" >> /home/appuser/launch.config

printf "# mysql\n" >> /home/appuser/launch.config
printf "MYSQL_DIR=/usr/bin\n" >> /home/appuser/launch.config
printf "MYSQLD_DIR=/usr/sbin\n" >> /home/appuser/launch.config
printf "MYSQL_DATA_DIR=/home/appuser/var/lib/mysql/datadir\n" >> /home/appuser/launch.config
printf "MYSQL_TMP_DIR=/home/appuser/var/lib/mysql/tmp\n" >> /home/appuser/launch.config
printf "MYSQL_LOG_DIR=/home/appuser/var/lib/mysql/log\n" >> /home/appuser/launch.config
printf "MYSQL_CONF=/home/appuser/etc/mysql/my.cnf\n" >> /home/appuser/launch.config

printf "# node js\n" >> /home/appuser/launch.config
printf "NPM_DIR=/usr/local/node/bin\n" >> /home/appuser/launch.config


# setup mysql database
. /home/root/setup/setup-mysql-database.sh

# give ownership of all directories to USERID
chown -R $USERID:$USERID /home/appuser