#!/bin/sh

cd /home

# collect input parameters
read -p "Please enter userid to run within container (default 1000):" USERID
USERID=${USERID:-1000}

read -p" Please enter the port exposed for accessing the webapp (default 8000, -1 do not start):" WEB_PORT
WEB_PORT=${WEB_PORT:-8000}

read -p "Please enter the port exposed for accessing the internal mysql server (default 3306, 0 not exposed, -1 do not start):" MYSQL_PORT
MYSQL_PORT=${MYSQL_PORT:-3306}

read -p "Please enter the port exposed for accessing the internal geth node (default 30303, 0 not exposed, -1 do not start):" GETH_PORT
GETH_PORT=${GETH_PORT:-30303}

# write docker.config file
echo "IMAGE_NAME=$IMAGE_NAME" > /homedir/docker.config
printf "\n" >> /homedir/docker.config
printf "USERID=$USERID\n" >> /homedir/docker.config
printf "\n" >> /homedir/docker.config
printf "ENTRY_POINT=/home/root/bin/bootstrap.sh\n" >> /homedir/docker.config
printf "\n" >> /homedir/docker.config
printf "HOME_ROOT_HOST_DIR=$HOME_ROOT_HOST_DIR\n" >> /homedir/docker.config
printf "\n" >> /homedir/docker.config
printf "WEB_PORT=$WEB_PORT\n" >> /homedir/docker.config
printf "MYSQL_PORT=$MYSQL_PORT\n" >> /homedir/docker.config
printf "GETH_PORT=$GETH_PORT\n" >> /homedir/docker.config

# write start-container file
echo "#!/bin/sh" > /homedir/start-container.sh
printf "\n" >> /homedir/start-container.sh
printf ". ./docker.config\n" >> /homedir/start-container.sh
printf "\n" >> /homedir/start-container.sh
printf "docker run -i -t \\" >> /homedir/start-container.sh
printf "\n" >> /homedir/start-container.sh

if [ $WEB_PORT != 0 ] && [ $WEB_PORT != -1 ]; then
printf "    -p \$WEB_PORT:8080 \\" >> /homedir/start-container.sh
printf "\n" >> /homedir/start-container.sh
fi

if [ $MYSQL_PORT != 0 ] && [ $MYSQL_PORT != -1 ]; then
printf "    -p \$MYSQL_PORT:3306 \\" >> /homedir/start-container.sh
printf "\n" >> /homedir/start-container.sh
fi

if [ $GETH_PORT != 0 ] && [ $GETH_PORT != -1 ]; then
printf "    -p \$GETH_PORT:30303 \\" >> /homedir/start-container.sh
printf "\n" >> /homedir/start-container.sh
fi

printf "    --entrypoint \$ENTRY_POINT \\" >> /homedir/start-container.sh
printf "\n" >> /homedir/start-container.sh
printf "    -v \$HOME_ROOT_HOST_DIR/appuser:/home/appuser \\" >> /homedir/start-container.sh
printf "\n" >> /homedir/start-container.sh
printf "    \$IMAGE_NAME\n" >> /homedir/start-container.sh

chmod o+x /homedir/start-container.sh

# make appuser home directory
mkdir /homedir/appuser
chown -R $USERID:$USERID /homedir/appuser

# run appuser setup
if [ ! -f /home/root/setup/setup-appuser-home.sh ]; then
	echo "Could not find a setup-appuser-home.sh file in /home/root/setup !"
else
	echo "Found setup-appuser-home.sh file in /home/root/setup !"
	. /home/root/setup/setup-appuser-home.sh
fi

echo ""
echo "You can now run \"./start-container.sh\" from the current directory to execute the container with the parameters chosen."
