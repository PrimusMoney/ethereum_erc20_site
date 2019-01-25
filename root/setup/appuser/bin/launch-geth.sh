#!/bin/sh

echo "****************************"
echo "* Executing launch-geth.sh *"
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


if [ -z "${GETH_PATH+xxx}" ]; then echo "GETH_PATH is not set, setting GETH_PATH=/usr/local/geth/bin/geth"; GETH_PATH=/usr/local/geth/bin/geth; else echo "GETH_PATH was set to $GETH_PATH"; fi
#if [ -z "${GETH_DATADIR+xxx}" ]; then echo "GETH_DATADIR is not set, setting GETH_DATADIR=/home/appuser/var/lib/geth/datadir"; GETH_DATADIR=/home/appuser/var/lib/geth/datadir; else echo "GETH_DATADIR was set to $GETH_DATADIR"; fi
if [ -z "${GETH_OPTIONS+xxx}" ]; then echo "GETH_OPTIONS is not set, setting GETH_OPTIONS= --rpc console"; GETH_OPTIONS="--rpc console"; else echo "GETH_OPTIONS was set to $GETH_OPTIONS"; fi

if [ -z "${GETH_USER+xxx}" ]; then echo "GETH_USER is not set, setting GETH_USER=geth"; GETH_USER=geth; else echo "GETH_USER was set to $GETH_USER"; fi

#su $GETH_USER -c "$GETH_PATH --datadir $GETH_DATADIR $GETH_OPTIONS"
su $GETH_USER -c "$GETH_PATH $GETH_OPTIONS"
