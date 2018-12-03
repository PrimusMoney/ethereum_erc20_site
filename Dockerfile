FROM ubuntu

MAINTAINER PrimusMoney <contact@primusmoney.com>


# apps copy dapp
COPY ./root/usr/local /home/root/usr/local

CMD /home/root/bin/bootstrap.sh
