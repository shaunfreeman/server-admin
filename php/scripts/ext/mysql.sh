#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the MySQL Extentions extension

if [[ "${ENABLE_EXTS[@]}" =~ "mysql" ]]; then
    PHP_CONFIGURE_OPTIONS+=("--enable-mysqlnd")

    dialog --defaultno --yesno "MySQL Improved" 10 60
    if [ "$?" == 0 ]; then
        PHP_CONFIGURE_OPTIONS+=("--with-mysqli")
    fi

    dialog --defaultno --yesno "PDO MySQL" 10 60
    if [ "$?" == 0 ]; then
        PHP_CONFIGURE_OPTIONS+=("--with-pdo-mysql")
    fi

    MYSQL_DEP=($(dpkg -l | grep -Po "libmysqlclient-dev"))

    if [ ! "$MYSQL_DEP" ]; then
        dialog \
            --title "Adding MySQL Dependencies" \
            --prgbox "apt-get install -y libmysqlclient-dev" 20 100

    fi

    MYSQL_SOCKET=($(mysql_config --socket))
    PHP_CONFIGURE_OPTIONS+=("--with-mysql-sock=$MYSQL_SOCKET")
fi
