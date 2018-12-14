#!/bin/sh

MYSQLD_DIR=/usr/sbin
MYSQL_DATA_DIR=/homedir/appuser/var/lib/mysql/datadir


echo "Creating mysql database with an initial blank password for root."
echo "Please set subsequently a password for the mysql root user through the admin url."
echo "DATABASE CREATION MAY TAKE A WHILE."

$MYSQLD_DIR/mysqld --basedir=$MYSQLD_DIR --datadir=$MYSQL_DATA_DIR --initialize-insecure

echo "The mysql database has been created in the appuser directory."

