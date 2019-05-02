#!/bin/sh

# create usr
mkdir /homedir/appuser/

mkdir /homedir/appuser/bin

cp -R /home/root/setup/appuser/bin/* /homedir/appuser/bin
chmod 775 /homedir/appuser/bin/*.sh

mkdir /homedir/appuser/usr
mkdir /homedir/appuser/usr/local
mkdir /homedir/appuser/usr/local/bin

cp -R /home/root/setup/appuser/usr/local/bin/* /homedir/appuser/usr/local/bin
chmod 775 /homedir/appuser/usr/local/bin/*.sh


# create etc
mkdir /homedir/appuser/etc

mkdir /homedir/appuser/etc/mysql
cp -R /home/root/setup/appuser/etc/mysql/* /homedir/appuser/etc/mysql

mkdir /homedir/appuser/etc/nginx
cp -R /home/root/setup/appuser/etc/nginx/* /homedir/appuser/etc/nginx

mkdir /homedir/appuser/etc/geth
cp -R /home/root/setup/appuser/etc/geth/* /homedir/appuser/etc/geth

# create var
mkdir /homedir/appuser/var
mkdir /homedir/appuser/var/lib

mkdir /homedir/appuser/var/lib/mysql
mkdir /homedir/appuser/var/lib/mysql/datadir
mkdir /homedir/appuser/var/lib/mysql/log
mkdir /homedir/appuser/var/lib/mysql/tmp

mkdir /homedir/appuser/var/lib/nginx
mkdir /homedir/appuser/var/lib/nginx/logs
mkdir /homedir/appuser/var/lib/nginx/www
cp -R /home/root/setup/appuser/var/lib/nginx/www/* /homedir/appuser/var/lib/nginx/www

mkdir /homedir/appuser/var/lib/geth
mkdir /homedir/appuser/var/lib/geth/datadir-mainnet
mkdir /homedir/appuser/var/lib/geth/datadir-rinkeby

# apps

# ethereum_reader_server
mkdir /homedir/appuser/var/lib/ethereum_reader_server
mkdir /homedir/appuser/var/lib/ethereum_reader_server/logs
mkdir /homedir/appuser/var/lib/ethereum_reader_server/settings
echo "{\"service_name\": \"ethereum reader service\",\"server_listening_port\": 13000}" > /homedir/appuser/var/lib/ethereum_reader_server/settings/config.json

mkdir /homedir/appuser/var/lib/ethereum_webapp
mkdir /homedir/appuser/var/lib/ethereum_webapp/logs
mkdir /homedir/appuser/var/lib/ethereum_webapp/settings

echo "{}" > /homedir/appuser/var/lib/ethereum_webapp/settings/config.json

# write launch.config
echo "# bootstrap" > /homedir/appuser/launch.config
printf "USERNAME=$USERID\n" >> /homedir/appuser/launch.config
printf "USERID=$USERID\n" >> /homedir/appuser/launch.config
printf "\n" >> /homedir/appuser/launch.config

printf "# starter (executed as root)\n" >> /homedir/appuser/launch.config
printf "STARTER=/home/appuser/bin/starter.sh\n" >> /homedir/appuser/launch.config
printf "\n" >> /homedir/appuser/launch.config

printf "# launcher (executed as USERID)\n" >> /homedir/appuser/launch.config
printf "LAUNCHER=/home/appuser/usr/local/bin/launcher.sh\n" >> /homedir/appuser/launch.config
printf "\n" >> /homedir/appuser/launch.config

printf "# shell\n" >> /homedir/appuser/launch.config
printf "SHELL=/bin/bash\n" >> /homedir/appuser/launch.config
printf "\n" >> /homedir/appuser/launch.config

printf "# nginx\n" >> /homedir/appuser/launch.config
if [ $WEB_PORT != -1 ]; then
printf "NGINX_START=1\n" >> /homedir/appuser/launch.config
else
printf "NGINX_START=0\n" >> /homedir/appuser/launch.config
fi	
printf "NGINX_DIR=/usr/sbin\n" >> /homedir/appuser/launch.config
printf "NGINX_CONF=/home/appuser/etc/nginx/nginx.conf\n" >> /homedir/appuser/launch.config
printf "NGINX_ERROR_LOG_DIR=/home/appuser/var/lib/nginx/logs/error.log\n" >> /homedir/appuser/launch.config
printf "\n" >> /homedir/appuser/launch.config

printf "# mysql\n" >> /homedir/appuser/launch.config
if [ $MYSQL_PORT != -1 ]; then
printf "MYSQL_START=1\n" >> /homedir/appuser/launch.config
else
printf "MYSQL_START=0\n" >> /homedir/appuser/launch.config
fi
printf "MYSQL_DIR=/usr/bin\n" >> /homedir/appuser/launch.config
printf "MYSQLD_DIR=/usr/sbin\n" >> /homedir/appuser/launch.config
printf "MYSQL_DATA_DIR=/home/appuser/var/lib/mysql/datadir\n" >> /homedir/appuser/launch.config
printf "MYSQL_TMP_DIR=/home/appuser/var/lib/mysql/tmp\n" >> /homedir/appuser/launch.config
printf "MYSQL_LOG_DIR=/home/appuser/var/lib/mysql/log\n" >> /homedir/appuser/launch.config
printf "MYSQL_CONF=/home/appuser/etc/mysql/my.cnf\n" >> /homedir/appuser/launch.config
printf "\n" >> /homedir/appuser/launch.config

printf "# node js\n" >> /homedir/appuser/launch.config
printf "NPM_DIR=/usr/local/node/bin\n" >> /homedir/appuser/launch.config
printf "\n" >> /homedir/appuser/launch.config

printf "# geth\n" >> /homedir/appuser/launch.config
if [ $GETH_PORT != -1 ]; then
printf "GETH_START=1\n" >> /homedir/appuser/launch.config
else
printf "GETH_START=0\n" >> /homedir/appuser/launch.config
fi
printf "GETH_PATH=/usr/local/geth/bin/geth\n" >> /homedir/appuser/launch.config
printf "GETH_USER=geth\n" >> /homedir/appuser/launch.config
#printf "GETH_DATADIR=/home/appuser/var/lib/geth/datadir\n" >> /homedir/appuser/launch.config
printf "GETH_OPTIONS=\"console --rpc --config /home/appuser/etc/geth/config.toml\"\n" >> /homedir/appuser/launch.config
printf "\n" >> /homedir/appuser/launch.config

printf "# ethereum_reader_server\n" >> /homedir/appuser/launch.config
printf "ETHEREUM_READER_SERVER_BASE_DIR=/home/root/usr/local/ethereum_reader_server\n" >> /homedir/appuser/launch.config
printf "ETHEREUM_READER_SERVER_EXEC_DIR=/home/appuser/var/lib/ethereum_reader_server\n" >> /homedir/appuser/launch.config
printf "\n" >> /homedir/appuser/launch.config

printf "# ethereum_webapp\n" >> /homedir/appuser/launch.config
printf "ETHEREUM_WEBAPP_BASE_DIR=/home/root/usr/local/ethereum_webapp\n" >> /homedir/appuser/launch.config
printf "ETHEREUM_WEBAPP_EXEC_DIR=/home/appuser/var/lib/ethereum_webapp\n" >> /homedir/appuser/launch.config
printf "\n" >> /homedir/appuser/launch.config

# setup mysql database
. /home/root/setup/setup-mysql-database.sh

# give ownership of all directories to USERID
chown -R $USERID:$USERID /homedir/appuser

# give ownership of /home/appuser/var/lib/mysql directories to mysql
touch /homedir/appuser/var/lib/mysql/log/mysql.log
chown -R mysql:mysql /homedir/appuser/var/lib/mysql

# give ownership of /home/appuser/var/lib/geth directories to geth
chown -R geth:geth /homedir/appuser/var/lib/geth

# initialize networks with their genesis block
echo "Initializing rinkeby genesis block."
su geth -c "/usr/local/geth/bin/geth --datadir=/homedir/appuser/var/lib/geth/datadir-rinkeby --verbosity \"0\" init /homedir/appuser/etc/geth/rinkeby.json"
