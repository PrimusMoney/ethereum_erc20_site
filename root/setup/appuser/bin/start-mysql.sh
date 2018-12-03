#!/bin/sh

echo "****************************"
echo "* Executing start-mysql.sh *"
echo "****************************"

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

if [ -z "${MYSQL_TMP_DIR+xxx}" ]; then "MYSQL_TMP_DIR is not set, setting MYSQL_TMP_DIR to /home/appuser/var/lib/mysql/tmp"; MYSQL_TMP_DIR=/home/appuser/var/lib/mysql/tmp; else echo "MYSQL_TMP_DIR was set to $MYSQL_TMP_DIR"; fi
if [ -z "${MYSQL_SOCKET_DIR+xxx}" ]; then "MYSQL_SOCKET_DIR is not set, setting MYSQL_SOCKET_DIR to /home/appuser/var/lib/mysql/tmp"; MYSQL_SOCKET_DIR=/home/appuser/var/lib/mysql/tmp; else echo "MYSQL_SOCKET_DIR was set to $MYSQL_SOCKET_DIR"; fi
if [ -z "${MYSQL_LOG_DIR+xxx}" ]; then "MYSQL_LOG_DIR is not set, setting MYSQL_LOG_DIR to /home/appuser/var/lib/mysql/log"; MYSQL_LOG_DIR=/home/appuser/var/lib/mysql/log; else echo "MYSQL_LOG_DIR was set to $MYSQL_LOG_DIR"; fi

# clean socket in case container did not exit gracefully
rm $MYSQL_TMP_DIR/mysql.sock
rm $MYSQL_SOCKET_DIR/mysql.sock.lock
rm $MYSQL_SOCKET_DIR/mysql.pid

mkdir $MYSQL_TMP_DIR
mkdir $MYSQL_LOG_DIR

$CURRENT_SCRIPT_DIR/launch-mysql.sh &
