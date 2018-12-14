#!/bin/sh

echo "Executing bootstrap.sh"


if [ ! -f /home/appuser/launch.config ]; then
	echo "Could not find a launch.config file in /home/appuser !"
else
	echo "Found launch.config file in /home/appuser !"
	. /home/appuser/launch.config
fi


if [ -z "${USERNAME+xxx}" ]; then echo "USERNAME is not set"; USERNAME=root; 
else 
	echo "USERNAME was set to $USERNAME"; 
	
	# setting userid, groupname and groupid if necessary
	if [ -z "${USERID+xxx}" ]; then echo "USERID is not setting USERID to 1000"; USERID=1000; else echo "USERID was set to $USERID"; fi
	if [ -z "${GROUPNAME+xxx}" ]; then echo "GROUPNAME is not set, setting GROUPNAME to $USERNAME"; GROUPNAME=$USERNAME; else echo "GROUPNAME was set to $GROUPNAME"; fi
	if [ -z "${GROUPID+xxx}" ]; then echo "GROUPID is not set, setting GROUPID to $USERID"; GROUPID=$USERID; else echo "GROUPID was set to $GROUPID"; fi
	
fi

if [ -z "${LAUNCHER+xxx}" ]; then echo "LAUNCHER is not set, setting LAUNCHER to /bin/sh"; LAUNCHER=/bin/sh; else echo "LAUNCHER was set to $LAUNCHER"; fi 

# start (as root)
if [ ! -z "${STARTER+xxx}" ]; 
 then 
 	
 	echo "*****************************";
 	echo "* executing STARTER as root *";
	echo "*****************************";
  	echo "STARTER is set to "$STARTER;
 	echo "It is recommended that programs called are executed as a non-root user (e.g. daemon, mysql,..)";
 	
 	$STARTER;
 else
 	echo "no STARTER set";
fi

# launch (as USERID if set)
if [ "$(id -u)" != "0" ]; then
	echo "This container is run as $UID" 1>&2
	
	echo "launching as $UID"
	
	$LAUNCHER
else
	echo "This container is run as root" 1>&2
	
	if [ "$USERNAME" != "root" ]
	then
		#add group to /etc/group
		echo "$GROUPNAME:x:$GROUPID:" >> "/etc/group"
		#add user to /etc/passwd
		echo "$USERNAME:x:$USERID:$USERID:$USERNAME,,,:/home/appuser:/bin/sh" >> "/etc/passwd"
	
		#addgroup -g $GROUPID $GROUPNAME
		#adduser -u $USERID -g $GROUPID $USERNAME
		
		echo "launching as user $USERNAME"
		su $USERNAME -c "$LAUNCHER"
	
	else
		echo "Running within the container as root is not recommended!"	
		echo "Proceeding but using launch.config file  at the root of the volume"
		echo "provided for /home/appuser/ is a better option to run launcher"	
		echo "under a host user with lower privileges"	
		
		$LAUNCHER
	fi

fi

