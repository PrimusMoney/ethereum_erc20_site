#!/bin/sh

echo "**************************************"
echo "* Executing start-ethereum-reader.sh *"
echo "**************************************"

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



/usr/bin/tmux new-session -d -s ethereum-reader "$LOCAL_SCRIPT_DIR/launch-ethereum-reader.sh"

