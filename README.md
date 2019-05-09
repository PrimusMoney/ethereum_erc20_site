Demo
=====

You can see a demo running on rinkeby at

https://rinkeby-dapps.primusfinance.fr/erc20-dapp/index.html#!/home/login

**user**: test@primusmoney.com

**password**: test

Installation
=========
Installation is done in two steps.

First step: container setup
------------------------------------

To install your container run , as root, or as a user with docker privileges, from the directory (e.g. /home/myuser/ethereum_erc20_site) where you want to install volume files the command line:

`$ docker run -i -t -e IMAGE_NAME=primusmoney/ethereum_erc20_site:latest -e HOME_ROOT_HOST_DIR=$(pwd) -v $(pwd):/homedir --entrypoint /home/root/setup/setup-container-starter.sh primusmoney/ethereum_erc20_site:latest`

Setup will guide you in defining the user under which the application will run, the ports that will be exposed (e.g. 8000 for http access, 3336 for mysql,...).

Second step: application setup
-------------------------------------------
When container setup is finished. Start the container using the start-container.sh file that is created in your installation directory (e.g. /home/myuser/ethereum_erc20_site)

`$ ./start-container.sh`

Then call from your browser the setup url:

`http://servername:port/admin`

(e.g. http://localhost:8000/admin, or http://192.168.0.1:8000/admin,...). You will then define the mysql root password, application user, REST url,...

Site management
==============

Administration of your site will then be accessible through the admin url:

`http://servername:port/admin`

(e.g. http://localhost:8000/admin, or http://192.168.0.1:8000/admin,...).


You will authenticate with your mysql root password, then create your users thanks to the *Users* tab.

Your users will then be able to authenticate and interact with your site through the url:

`http://servername:port/dapp/index.html#!/home/login`

(e.g. http://localhost:8000/dapp/index.html#!/home/login or http://192.168.0.1:8000/dapp/index.html#!/home/login,...).
