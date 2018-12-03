#!/bin/sh

echo "*****************************"
echo "* Executing launch-nginx.sh *"
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

if [ -z "${NGINX_DIR+xxx}" ]; then "NGINX_DIR is not set, setting NGINX_DIR to /usr/sbin"; NGINX_DIR=/usr/sbin; else echo "NGINX_DIR was set to $NGINX_DIR"; fi
if [ -z "${NGINX_CONF+xxx}" ]; then "NGINX_CONF is not set, setting NGINX_CONF to /etc/nginx/conf.d/nginx.conf"; NGINX_CONF=/etc/nginx/conf.d/nginx.conf; else echo "NGINX_CONF was set to $NGINX_CONF"; fi


$NGINX_DIR/nginx -c $NGINX_CONF
#$NGINX_DIR/nginx -c $NGINX_CONF -g "pid /tmp/nginx.pid; error_log $NGINX_ERROR_LOG_DIR/error.log;" &