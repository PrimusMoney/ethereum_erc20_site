#!/bin/sh

echo "*************************"
echo "* Executing launcher.sh *"
echo "*************************"

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


export NPM_DIR=/usr/local/node/bin
export	PATH=$NPM_DIR:$PATH


#
# container services
#

# HTTP entry point
# Apache or Nginx

# apache	
#echo "starting apache"
#$CURRENT_SCRIPT_DIR/start-apache24.sh &
	
# nginx	
echo "starting nginx"
$CURRENT_SCRIPT_DIR/start-nginx.sh &
	

# DATABASE

# mysql
if [ -z $MYSQL_START ] || [ $MYSQL_START != 0 ]; then
echo "starting mysql"
$CURRENT_SCRIPT_DIR/start-mysql.sh &
fi

# ETHEREUM BLOCKCHAIN

# geth	
if [ $GETH_START != 0 ]; then
echo "starting geth"
$CURRENT_SCRIPT_DIR/start-geth.sh &
fi

