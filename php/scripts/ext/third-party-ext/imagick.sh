#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to Install, update the latest Imagick

echo -e "\e[92m"
read -p "Would you like to enable Imagick [y/n]:" IMAGICK

if [ "$IMAGICK" == "y" ]; then

    echo -e "\e[92mChecking Imagick now.\e[39m"
    sleep 2

    cd "$INSTALLER_DIR/src"

    # set up Imagick
    if [ ! -d imagick ]; then
        git clone https://github.com/mkoppanen/imagick.git
    fi

    cd imagick

    # Check for lastest version
    check_version '^[0-9]*.[0-9]*.[0-9]*(RC[0-9]*)?$'

    if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then

        if [ "$MODE" == 1 ]; then
            # Dependencies
            echo -e "\e[92mInstalling Imagick dependencies...\e[39m"
            sleep 2
            apt-get install -y \
                imagemagick \
                libmagickwand-dev
        fi

        echo -e "\e[92mCompiling Imagick Version: $LATEST_VERSION\e[39m"
        sleep 2

        git checkout "$LASTEST_VERSION"
        git pull

        sed "s/@PACKAGE_VERSION@/$LASTEST_VERSION/" php_imagick.h

        /usr/local/php7/bin/phpize
        ./configure --with-php-config=/usr/local/php7/bin/php-config
        make "$MAKE_OPTIONS"
        make install

        sed "s/$LASTEST_VERSION/@PACKAGE_VERSION@/" php_imagick.h

        if [ ! -f /usr/local/php7/etc/conf.d/20imagick.ini ]; then
            cp -v "$INSTALLER_DIR/conf.d/imagick.ini" /usr/local/php7/etc/conf.d/20imagick.ini
        fi

        cd "$INSTALLER_DIR"

        echo -e "\e[92mFinished checking Imagick.\e[39m"
        sleep 2

    else

        echo -e "\e[92mImagick on lastest version: $LASTEST_VERSION.\e[39m"
        sleep 2
    fi
fi
