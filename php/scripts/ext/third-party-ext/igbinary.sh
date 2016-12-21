#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to Install, update the latest Igbinary

echo -e "\e[92m"
read -p "Would you like to enable Igbinary [y/n]:" IGBINARY

if [ "$IGBINARY" == "y" ]; then

    echo -e "\e[92mInstalling Igbinary now.\e[39m"
    sleep 2

    cd "$INSTALLER_DIR/src"

    if [ ! -d igbinary ]; then
        git clone https://github.com/igbinary/igbinary.git
    fi

    cd igbinary

    # Check for lastest version
    check_version '^[0-9]*.[0-9]*.[0-9]*$'

    if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then

        echo -e "\e[92mCompiling Igbinary Version: $LATEST_VERSION\e[39m"
        sleep 2

        git checkout "$LASTEST_VERSION"
        git pull

        /usr/local/php7/bin/phpize
        ./configure --with-php-config=/usr/local/php7/bin/php-config
        make "$MAKE_OPTIONS"
        make install
        make clean

        if [ ! -f /usr/local/php7/etc/conf.d/20igbinary.ini ]; then
            cp -v "$INSTALLER_DIR/conf.d/igbinary.ini" /usr/local/php7/etc/conf.d/20igbinary.ini
        fi

        cd "$INSTALLER_DIR"

        echo -e "\e[92mFinished installing Igbinary.\e[39m"
        sleep 2

    else
        echo -e "\e[92mIgbinary on lastest version: $LASTEST_VERSION.\e[39m"
        sleep 2
    fi
fi
