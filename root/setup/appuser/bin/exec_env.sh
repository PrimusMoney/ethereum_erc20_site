#!/bin/sh

CURRENT_SCRIPT_PATH=$(readlink -f "$0")
CURRENT_SCRIPT_DIR=$(dirname "$CURRENT_SCRIPT_PATH")

export CURRENT_SCRIPT_DIR


if [ -z "${HOME_SCRIPT_DIR+xxx}" ]; then
echo 'setting environment variables for the first time'
	
	
	HOME_APP_DIR='/home/appuser'
	HOME_ROOT_DIR='/home/root'
	HOME_SCRIPT_DIR=$(echo "$CURRENT_SCRIPT_DIR" | cut -d "/" -f 1-3)
	
	echo "HOME_SCRIPT_DIR is $HOME_SCRIPT_DIR"
	
	export HOME_APP_DIR
	export HOME_ROOT_DIR
	export HOME_SCRIPT_DIR
	
	BASE_SCRIPT_DIR=$HOME_SCRIPT_DIR"/bin"
	
	export BASE_SCRIPT_DIR
	
	export LOCAL_SCRIPT_DIR

	LOCAL_APP_DIR=$HOME_SCRIPT_DIR"/usr/local"
	LOCAL_SCRIPT_DIR=$HOME_SCRIPT_DIR"/usr/local/bin"
	
	export LOCAL_APP_DIR
	export LOCAL_SCRIPT_DIR
	
else
	echo 'environment variables already set'
fi

echo "Doller0 is $0"
script_path=$(readlink -f "$0")
echo "BASE_SCRIPT_PATH is $BASE_SCRIPT_PATH"
scriptpath="$( cd "$(dirname "$0")" ; pwd -P )"
echo "scriptpath is $scriptpath"

temp=$(tty) 
echo "current tty is $temp"


if [ ! -f /home/appuser/launch.config ]; then
	echo "Could not find a launch.config file in /home/appuser !"
else
	echo "Found launch.config file in /home/appuser !"
	. /home/appuser/launch.config
fi


