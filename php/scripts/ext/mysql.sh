#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the MySQL Extentions extension

ask_question "MySQL [y/N]"

if [ "$INSTALL_EXTENSION" == "y" ]; then
    PHP_CONFIGURE_OPTIONS+=("--enable-mysqlnd")

    ask_question "MySQL Improved [y/N]"

    if [ "$INSTALL_EXTENSION" == "y" ]; then
        PHP_CONFIGURE_OPTIONS+=("--with-mysqli")
    fi

    ask_question "PDO MySQL [y/N]"

    if [ "$INSTALL_EXTENSION" == "y" ]; then
        PHP_CONFIGURE_OPTIONS+=("--with-pdo-mysql")
    fi

    MYSQL_DEP=($(dpkg -l | grep -Po "libmysqlclient-dev"))

    if [ ! "$MYSQL_DEP" ]; then
        apt-get install libmysqlclient-dev
    fi

    MYSQL_SOCKET=($(mysql_config --socket))
    PHP_CONFIGURE_OPTIONS+=("--with-mysql-sock=$MYSQL_SOCKET")
fi
