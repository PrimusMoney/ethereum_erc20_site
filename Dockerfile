FROM ubuntu:16.04

MAINTAINER PrimusMoney <contact@primusmoney.com>

# container primusmoney/ethereum_erc20_site
# to build a specific combination of releases
# replace master by the tag of the corresponding
# release (e.g. 0.11.0) then build image with
# a specific tag (e.g. "docker build -t primusmoney/ethereum_erc20_site:0.11.0")
ARG ethereum_erc20_dapp_tag=0.20.8
ARG ethereum_webapp_tag=0.20.8
ARG ethereum_reader_tag=v0.1.2


# system users and groups (id < 999)
RUN groupadd -g 201 nginx &&  useradd -g nginx -u 201 -c "NGINX Server" nginx
RUN groupadd -g 205 geth &&  useradd -m -d /home/geth -g geth -u 205 -c "GETH Server" geth

#
# L = Linux
#

# ubuntu utils
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && \
	apt-get install -y --no-install-recommends apt-utils

# standard tools
RUN apt-get update && \
	apt-get install -y nano && \
	apt-get install -y bash && \
	apt-get install -y sudo && \
	apt-get install -y tmux && \
	apt install net-tools 

RUN apt-get update && \
	apt-get install -y curl && \
	apt-get install -y git
	
# libraries
RUN apt-get update && \
	apt-get install -y libzmq3-dev


#
# N = nginx
#

RUN apt-get update && \
	apt-get install -y nginx

# M = mysql
RUN echo 'mysql-server mysql-server/root_password password rootpass' | debconf-set-selections && \
	echo 'mysql-server mysql-server/root_password_again password rootpass' | debconf-set-selections && \
	apt-get update && \
	apt-get install -y mysql-server


#
# N = node js
#

# python (for npm install)
RUN apt-get update && \
	apt-get -y install software-properties-common && \
	apt-get install -y build-essential python2.7 && \
	ln -s /usr/bin/python2.7 /usr/bin/python

# node js
COPY ./middleware/node-v10.15.3-linux-x64.tar.xz /root/tmp/node-v10.15.3-linux-x64.tar.xz

RUN tar -xf /root/tmp/node-v10.15.3-linux-x64.tar.xz --directory=/root/tmp/ && \
	mv /root/tmp/node-v10.15.3-linux-x64/ /usr/local/node/


ENV NPM_DIR=/usr/local/node/bin
ENV	PATH=${NPM_DIR}:${PATH}


# clean install directory
RUN rm -rf /root/tmp


#
# G = geth
#

COPY ./middleware/geth-1-8-27 /usr/local/geth/bin/geth

RUN chmod 775 /usr/local/geth/bin/geth

#
# W = Web3app node
#

# apps copy root/bin, root/etc, root/usr, and root/var folders
COPY ./root/ /home/root/

# make shell files executable
RUN chmod 775 /home/root/bin/*.sh && \
	chmod 775 /home/root/setup/*.sh
	
# apps copy ethereum_reader_server
# run npm install
# (--unsafe-perm because of "gyp WARN EACCES attempting to reinstall using temporary dev dir")
RUN git clone https://github.com/p2pmoney-org/ethereum_reader_server /home/root/usr/local/ethereum_reader_server --branch $ethereum_reader_tag && \
	cd /home/root/usr/local/ethereum_reader_server && \
	npm install --unsafe-perm 

	

# apps copy ethereum_webapp
# run npm install
# (--unsafe-perm because of "gyp WARN EACCES attempting to reinstall using temporary dev dir")
RUN git clone https://github.com/p2pmoney-org/ethereum_webapp /home/root/usr/local/ethereum_webapp --branch $ethereum_webapp_tag && \
	cd /home/root/usr/local/ethereum_webapp  && \
	echo "\n\nConstants.push('lifecycle', {eventname: 'webapp checkout', time:$(date +%s)*1000, checkout_branch:'$ethereum_webapp_tag'});\n" >> /home/root/usr/local/ethereum_webapp/server/includes/common/constants.js && \
	npm install --unsafe-perm 
	
	
#
# E = ERC20 dapp
#

# apps copy ethereum_dapp
# tag checkout time in constant.js
RUN git clone https://github.com/p2pmoney-org/ethereum_erc20_dapp /home/root/usr/local/ethereum_dapp --branch $ethereum_erc20_dapp_tag && \
	echo "\nConstants.push('lifecycle', {eventname: 'app checkout', time:$(date +%s)*1000, checkout_branch:'$ethereum_erc20_dapp_tag'});\n" >> /home/root/usr/local/ethereum_dapp/app/js/src/constants.js


# CMD start command
CMD /home/root/bin/bootstrap.sh
