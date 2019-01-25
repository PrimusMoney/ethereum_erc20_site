FROM ubuntu:16.04

MAINTAINER PrimusMoney <contact@primusmoney.com>

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
COPY ./middleware/node-v8.9.1-linux-x64.tar.gz /root/tmp/node-v8.9.1-linux-x64.tar.gz

RUN tar -xf /root/tmp/node-v8.9.1-linux-x64.tar.gz --directory=/root/tmp/ && \
	mv /root/tmp/node-v8.9.1-linux-x64/ /usr/local/node/


ENV NPM_DIR=/usr/local/node/bin
ENV	PATH=${NPM_DIR}:${PATH}


# clean install directory
RUN rm -rf /root/tmp


#
# G = geth
#

COPY ./middleware/geth /usr/local/geth/bin/geth

RUN chmod 775 /usr/local/geth/bin/geth

#
# W = Web3app node
#

# apps copy root/bin root/etc root/usr and root/usr/local folders
COPY ./root/ /home/root/

# make shell files executable
RUN chmod 775 /home/root/bin/*.sh && \
	chmod 775 /home/root/setup/*.sh
	
# apps copy ethereum_reader_server
# run npm install
# (--unsafe-perm because of "gyp WARN EACCES attempting to reinstall using temporary dev dir")
RUN git clone https://github.com/p2pmoney-org/ethereum_reader_server /home/root/usr/local/ethereum_reader_server && \
	cd /home/root/usr/local/ethereum_reader_server && \
	npm install --unsafe-perm 

	

# apps copy ethereum_webapp
# run npm install
# (--unsafe-perm because of "gyp WARN EACCES attempting to reinstall using temporary dev dir")
RUN git clone https://github.com/p2pmoney-org/ethereum_webapp /home/root/usr/local/ethereum_webapp && \
	cd /home/root/usr/local/ethereum_webapp && \
	npm install --unsafe-perm 
	
	
#
# E = ERC20 dapp
#

# apps copy ethereum_webapp
RUN git clone https://github.com/p2pmoney-org/ethereum_erc20_dapp /home/root/usr/local/ethereum_dapp


# CMD start command
CMD /home/root/bin/bootstrap.sh
