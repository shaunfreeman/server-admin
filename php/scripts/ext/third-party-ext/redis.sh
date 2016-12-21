#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to Install, update the latest PHP Redis

echo -e "\e[92m"
read -p "Would you like to enable PHP Redis [y/n]:" REDIS
echo -e "\e[39m"

if [ "$REDIS" == "y" ]; then

    echo -e "\e[92mChecking PHP Redis now.\e[39m"
    sleep 2

    cd "$INSTALLER_DIR/src"

    if [ ! -d phpredis ]; then
        git clone https://github.com/phpredis/phpredis.git
    fi

    cd phpredis
    # Check for lastest version
    check_version '^[0-9]*.[0-9]*.[0-9]*$'

    if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then

        echo -e "\e[92mCompiling PHP Redis Version: $LATEST_VERSION\e[39m"
        sleep 2

        git checkout ${LASTEST_VERSION}
        git pull

        IGBINARY=($(/usr/local/php7/sbin/php-fpm -m | grep 'igbinary'))

        if [ "$IGBINARY" != "igbinary" ]; then
            echo -e "\e[92m"
            read -p "Would you like to enable Igbinary support for Redis [y/n]:" IGBINARY_SUPPORT
            echo -e "\e[39m"

            if [ "$IGBINARY_SUPPORT" == "y" ]; then
                IGBINARY_ENABLED="--enable-redis-igbinary "
            fi
        fi

        /usr/local/php7/bin/phpize
        ./configure --with-php-config=/usr/local/php7/bin/php-config "$IGBINARY_ENABLED"
        make "$MAKE_OPTIONS"
        make install
        make clean

        if [ ! -f /usr/local/php7/etc/conf.d/20redis.ini ]; then
            cp -v "$INSTALLER_DIR/conf.d/redis.ini" /usr/local/php7/etc/conf.d/20redis.ini
        fi

        cd "$INSTALLER_DIR"

        echo -e "\e[92mFinished checking PHP Redis.\e[39m"
        sleep 2
    else
        echo -e "\e[92mPHP Redis on lastest version: $LATEST_VERSION.\e[39m"
        sleep 2
    fi
fi