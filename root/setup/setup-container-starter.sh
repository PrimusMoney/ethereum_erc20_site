#!/bin/sh

cd /home

# collect input parameters
read -p "Please enter userid to run within container (default 1000):" USERID
USERID=${USERID:-1000}

read -p" Please enter the port exposed for accessing the webapp (default 8000):" WEB_PORT
WEB_PORT=${WEB_PORT:-8000}

read -p "Please enter the port exposed for accessing the internal mysql server (default 3306):" MYSQL_PORT
MYSQL_PORT=${MYSQL_PORT:-3306}

read -p "Please enter the port exposed for accessing the internal geth node (default 30303):" GETH_PORT
GETH_PORT=${GETH_PORT:-30303}

# write docker.config file
echo "IMAGE_NAME=$IMAGE_NAME" > /home/docker.config
printf "\n" >> /home/docker.config
printf "USERID=$USERID\n" >> /home/docker.config
printf "\n" >> /home/docker.config
printf "ENTRY_POINT=/home/root/bin/bootstrap.sh\n" >> /home/docker.config
#printf "ENTRY_POINT=/bin/bash\n" >> /home/docker.config
printf "\n" >> /home/docker.config
printf "HOME_ROOT_HOST_DIR=$HOME_ROOT_HOST_DIR\n" >> /home/docker.config
printf "\n" >> /home/docker.config
printf "WEB_PORT=$WEB_PORT\n" >> /home/docker.config
printf "MYSQL_PORT=$MYSQL_PORT\n" >> /home/docker.config
printf "GETH_PORT=$GETH_PORT\n" >> /home/docker.config

# write start-container file
echo "#!/bin/sh" > /home/start-container.sh
printf "\n" >> /home/start-container.sh
printf ". ./docker.config\n" >> /home/start-container.sh
printf "\n" >> /home/start-container.sh
printf "docker run -i -t \\" >> /home/start-container.sh
printf "\n" >> /home/start-container.sh
printf "    -p \$WEB_PORT:8080 \\" >> /home/start-container.sh
printf "\n" >> /home/start-container.sh
printf "    -p \$MYSQL_PORT:3306 \\" >> /home/start-container.sh
printf "\n" >> /home/start-container.sh
printf "    -p \$GETH_PORT:30303 \\" >> /home/start-container.sh
printf "\n" >> /home/start-container.sh
printf "    --entrypoint \$ENTRY_POINT \\" >> /home/start-container.sh
printf "\n" >> /home/start-container.sh
printf "    -v \$HOME_ROOT_HOST_DIR/appuser:/home/appuser \\" >> /home/start-container.sh
printf "\n" >> /home/start-container.sh
# for DEV only
printf "    -v \$HOME_ROOT_HOST_DIR/root:/home/root \\" >> /home/start-container.sh
printf "\n" >> /home/start-container.sh
# for DEV only
printf "    \$IMAGE_NAME\n" >> /home/start-container.sh

chmod o+x /home/start-container.sh

# make appuser home directory
mkdir /home/appuser
chown -R $USERID:$USERID /home/appuser

# run appuser setup
if [ ! -f /home/root/setup/setup-appuser-home.sh ]; then
	echo "Could not find a setup-appuser-home.sh file in /home/root/setup !"
else
	echo "Found setup-appuser-home.sh file in /home/root/setup !"
	. /home/root/setup/setup-appuser-home.sh
fi

echo ""
echo "You can now run \"./start-container.sh\" from the current directory to execute the container with the parameters chosen."

