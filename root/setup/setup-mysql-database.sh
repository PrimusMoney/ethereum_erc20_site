#!/bin/sh

. ./appuser/bin/exec_env.sh

echo "Creating mysql database with an initial blank password for root, it may take a while. Please setup subsequently a password for the mysql root user through the admin url."

$MYSQLD_DIR/mysqld --defaults-file=$MYSQL_CONF --initialize-insecure

echo "The mysql database has been created in the appuser directory."

