#!/bin/sh

echo "***************************************"
echo "* Executing launch-ethereum-webapp.sh *"
echo "***************************************"

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

ROOT_LOCAL_APP_DIR=/home/root/usr/local

if [ -z "${ETHEREUM_WEBAPP_BASE_DIR+xxx}" ]; then echo "ETHEREUM_WEBAPP_BASE_DIR is not set, setting ETHEREUM_WEBAPP_BASE_DIR=$ROOT_LOCAL_APP_DIR/ethereum_webapp"; ETHEREUM_WEBAPP_BASE_DIR=$ROOT_LOCAL_APP_DIR/ethereum_webapp; else echo "ETHEREUM_WEBAPP_BASE_DIR was set to $ETHEREUM_WEBAPP_BASE_DIR"; fi
if [ -z "${ETHEREUM_WEBAPP_EXEC_DIR+xxx}" ]; then echo "ETHEREUM_WEBAPP_EXEC_DIR is not set, setting ETHEREUM_WEBAPP_EXEC_DIR=$ROOT_LOCAL_APP_DIR/ethereum_webapp"; ETHEREUM_WEBAPP_EXEC_DIR=$ROOT_LOCAL_APP_DIR/ethereum_webapp; else echo "ETHEREUM_WEBAPP_EXEC_DIR was set to $ETHEREUM_WEBAPP_EXEC_DIR"; fi

if [ -z "${NPM_DIR+xxx}" ]; then echo "NPM_DIR is not set, setting NPM_DIR=/usr/local/node/bin"; NPM_DIR=/usr/local/node/bin; else echo "NPM_DIR was set to $NPM_DIR"; fi
	

# need to export to access it in server.js
export ETHEREUM_WEBAPP_BASE_DIR;
export ETHEREUM_WEBAPP_EXEC_DIR;

export PATH=$NPM_DIR:$PATH
echo "PATH is $PATH"


cd $ETHEREUM_WEBAPP_BASE_DIR

$NPM_DIR/npm start
