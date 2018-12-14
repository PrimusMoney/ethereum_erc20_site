#!/bin/sh

echo "*******************************"
echo "* Executing local launcher.sh *"
echo "*******************************"

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

#
# container services
#


# ETHEREUM BLOCKCHAIN

# geth	
if [ $GETH_START != 0 ]; then
echo "starting geth"
$LOCAL_SCRIPT_DIR/start-geth.sh &
fi



#	
# appuser services
#
echo "starting ethereum_reader_server"
$LOCAL_SCRIPT_DIR/start-ethereum-reader.sh 

echo "starting ethereum_securities_webapp"
$LOCAL_SCRIPT_DIR/start-ethereum-webapp.sh 

#
# loop
#	
if [ -z "${SHELL+xxx}" ]; then echo "SHELL is not set, setting SHELL to /bin/sh"; SHELL=/bin/sh; else echo "SHELL was set to $SHELL"; fi
	
echo "starting $SHELL"
/bin/sh
#$SHELL

