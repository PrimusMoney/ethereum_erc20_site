#!/bin/sh

echo "*****************************"
echo "* Executing launch-mysql.sh *"
echo "*****************************"

################################ exec_env.sh ##########################################
current_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "$current_script_path")

if [ -f $current_script_dir/exec_env.sh ]; then
	echo "setting execution variables for script with $current_script_dir/exec_env.sh"
	. $current_script_dir/exec_env.sh
else
	if [ ! -z "${BASE_SCRIPT_DIR+xxx}" ] && [ -f $BASE_SCRIPT_DIR/exec_env.sh ]; then
		echo "setting execution variables for script with $BASE_SCRIPT_DIR/exec_env.sh"
		. $BASE_SCRIPT_DIR/exec_env.sh
	else
		if [ -f /home/root/exec_env.sh ]; then
			echo 'setting execution variables for script with /home/root/exec_env.sh'
			. /home/root/exec_env.sh
		else
			echo 'no exec_env.sh found to set execution variables for script'
		fi		
	fi
fi
#######################################################################################

if [ -z "${MYSQL_DIR+xxx}" ]; then "MYSQL_DIR is not set, setting MYSQL_DIR to /usr/bin"; MYSQL_DIR=/usr/bin; else echo "MYSQL_DIR was set to $MYSQL_DIR"; fi
if [ -z "${MYSQLD_DIR+xxx}" ]; then "MYSQLD_DIR is not set, setting MYSQLD_DIR to /usr/sbin"; MYSQLD_DIR=/usr/sbin; else echo "MYSQLD_DIR was set to $MYSQLD_DIR"; fi
if [ -z "${MYSQL_CONF+xxx}" ]; then "MYSQL_CONF is not set, setting MYSQL_CONF to /etc/mysql/my.cnf"; MYSQL_CONF=/etc/mysql/my.cnf; else echo "MYSQL_CONF was set to $MYSQL_CONF"; fi

if [ -z "${MYSQL_DATA_DIR+xxx}" ]; then "MYSQL_DATA_DIR is not set, setting MYSQL_DATA_DIR to /home/appuser/var/lib/mysql/datadir"; MYSQL_DATA_DIR=/home/appuser/var/lib/mysql/datadir; else echo "MYSQL_DATA_DIR was set to $MYSQL_DATA_DIR"; fi
if [ -z "${MYSQL_TMP_DIR+xxx}" ]; then "MYSQL_TMP_DIR is not set, setting MYSQL_TMP_DIR to /home/appuser/var/lib/mysql/tmp"; MYSQL_TMP_DIR=/home/appuser/var/lib/mysql/tmp; else echo "MYSQL_TMP_DIR was set to $MYSQL_TMP_DIR"; fi
if [ -z "${MYSQL_LOG_DIR+xxx}" ]; then "MYSQL_LOG_DIR is not set, setting MYSQL_LOG_DIR to /home/appuser/var/lib/mysql/log"; MYSQL_LOG_DIR=/home/appuser/var/lib/mysql/log; else echo "MYSQL_LOG_DIR was set to $MYSQL_LOG_DIR"; fi


export PATH=$MYSQL_DIR/bin:$MYSQLD_DIR/bin:$PATH


#$MYSQL_DIR/mysqld_safe --datadir=$MYSQL_DATA_DIR --socket=$MYSQL_SOCKET_DIR/mysql.sock --defaults-file=$MYSQL_CONF &
$MYSQL_DIR/mysqld_safe --defaults-file=$MYSQL_CONF &