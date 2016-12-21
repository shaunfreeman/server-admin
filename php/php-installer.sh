#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to Install, update and remove the lastest PHP

cd "$(dirname "$0")"
SCRIPT=$(readlink -f "$0")
INSTALLER_DIR=$(pwd)
PHP_DEPS=()
PHP_CONFIGURE_OPTIONS=()
PHP_INI_FILES=()
COMPILE_PHP=0

source "$INSTALLER_DIR/scripts/functions.sh"

if [[ $EUID -ne 0 ]]; then
    error "This script should be run using sudo or as the root user"
    exit 1
fi

# Mode the script will run in install [1], update [2], uninstall [3], exit [4]
echo -e "\e[92mPlease choose a mode."
echo -e "[1] Install"
echo -e "[2] Update"
echo -e "[3] Uninstall"
echo -e "[4] Exit"

read -p "Please enter Mode [1-4]:" MODE

if [ "$MODE" == 4 ]; then
    echo -e "\e[39m"
    exit 0
fi

if [ "$MODE" == 1 ] || [ "$MODE" == 2 ]; then

    if [ ! -d src ]; then
        mkdir src
    fi

    cd src

    NO_CPU=($(grep -c ^processor /proc/cpuinfo))
    MAKE_OPTIONS="-j$NO_CPU"

    PHP_DEPS+=("build-essential" "git-core" "autoconf" "bison" "cmake")

    echo -e "\e[92mChecking for latest PHP version .\e[39m"
    sleep 2

    if [ ! -d php-src ]; then
        if [ ! -d /usr/local/php7 ]; then
            mkdir /usr/local/php7
        fi
        git clone git://github.com/php/php-src.git
    fi

    cd php-src

    # Check for lastest version
    check_version '^php-7.[0-9]*.[0-9]*$'
    PHP_INSTALLED=$(command -v php)

    if [ "$PHP_INSTALLED" ]; then
        CURRENT_VERSION=($(php -version | grep -Po '^PHP ([0-9]*.[0-9]*.[0-9]*)' | tr ' ' -))
    fi
    
    PHP_VERSION="${LATEST_VERSION^^}"
    
    if [ "$CURRENT_VERSION" != "$PHP_VERSION" ]; then
        COMPILE_PHP=1
        git checkout "$PHP_VERSION"
        git pull
    else
        echo -e "\e[92mPHP on lastest version: $PHP_VERSION."
        read -p "Do you want to recompile PHP? [y,n]:" RECOMPILE
        echo -e "\e[39m"

        if [ "$RECOMPILE" == 'y' ]; then
            COMPILE_PHP=1
        fi
    fi

    if [ "$COMPILE_PHP" == 1 ]; then
    
        PHP_CONFIGURE_OPTIONS+=("--prefix=/usr/local/php7" "--with-config-file-path=/usr/local/php7/etc" "--with-config-file-scan-dir=/usr/local/php7/etc/conf.d")
    
        CHOOSE_OPTIONS=1

        CONFIGURE_OPTIONS_FILE="$INSTALLER_DIR/configure-options.txt"
    
        if [ -f  "$CONFIGURE_OPTIONS_FILE" ]; then
            echo -e "\e[92m"
            read -p "Do you want to use the saved configure options? [y or n]:" DO_OPTIONS
            echo -e "\e[39m"

            if [ "$DO_OPTIONS" == 'y' ]; then
                CHOOSE_OPTIONS=0
            fi
        fi

        if [ "$CHOOSE_OPTIONS" == 0 ]; then
            mapfile -t PHP_CONFIGURE_OPTIONS < "$CONFIGURE_OPTIONS_FILE"
        else
            SAPIS="$INSTALLER_DIR/scripts/sapi/*.sh"
            EXTS="$INSTALLER_DIR/scripts/ext/*.sh"

            for SAPI in $SAPIS; do
                source "$SAPI"
            done

            for EXT in $EXTS; do
                source "$EXT"
            done
            
            printf "%s\n" "${PHP_CONFIGURE_OPTIONS[@]}" > "$CONFIGURE_OPTIONS_FILE"
        fi
        
        # Dependencies
        echo -e "\e[92mChecking build dependencies...\e[39m"
        sleep 2
        check_deps
        
        ./buildconf --force
        
        echo -e "\e[92mCompiling PHP Version: $PHP_VERSION\e[39m"
        sleep 2

        # start timing the build
        START=$(date +"%s")

        ./configure $(printf "%s " "${PHP_CONFIGURE_OPTIONS[@]}")

        make ${MAKE_OPTIONS} || exit 1;
        make install || { make clean; exit 1; }
        make clean

        # finish timing the build
        END=$(date +"%s")
        DIFF=$(($END-$START))

        echo -e "\e[92mCompiling PHP took $(($DIFF / 60)) minutes and $(($DIFF % 60)) seconds to complete.\e[39m"
        echo -e "\e[92mFinished compiling PHP.\e[39m"
        sleep 2
        
        if [ "$OPCACHE" == 'y' ]; then
            cp -v "$INSTALLER_DIR/conf.d/opcache.ini" /usr/local/php7/etc/conf.d/10opcache.ini
        fi

        cd ${INSTALLER_DIR}

        if [ "$MODE" == 1 ]; then
            echo -e "\e[92mSetting up PHP.\e[39m"
            sleep 2

            echo -e "\e[92mMaking directories.\e[39m"
            sleep 2

            # Create a directories for storing PHP
            mkdir -v /usr/local/php7/etc/conf.d
            mkdir -v /usr/local/php7/lib/tmpfiles.d
            mkdir -v /var/run/php
            mkdir -v /etc/php

            echo -e "\e[92mAdding files.\e[39m"
            sleep 2

            cp -v /usr/local/php7/etc/php-fpm.conf.default /usr/local/php7/etc/php-fpm.conf
            cp -v "$INSTALLER_DIR/php-src/php.ini-production" /usr/local/php7/etc/php.ini
            cp -v "$INSTALLER_DIR/tempfiles.d/php-fpm.conf" /usr/local/php7/lib/tmpfiles.d/php-fpm.conf
            cp -v "$INSTALLER_DIR/php-fpm-checkconf" /usr/local/php7/php-fpm-checkconf
            cp -v "$INSTALLER_DIR/systemd/php7-fpm.service" /lib/systemd/system/php7-fpm.service
            chmod +x /usr/local/php7/php-fpm-checkconf

            # Add symlinks for /etc and local/bin and /local/sbin
            echo -e "\e[92mAdding symlinks for PHP FPM.\e[39m"
            sleep 2

            ln -sv /usr/local/php7/etc /etc/php/php7
            ln -sv /usr/local/php7/bin/pear /usr/local/bin/pear
            ln -sv /usr/local/php7/bin/peardev /usr/local/bin/peardev
            ln -sv /usr/local/php7/bin/pecl /usr/local/bin/pecl
            ln -sv /usr/local/php7/bin/phar /usr/local/bin/phar
            ln -sv /usr/local/php7/bin/php /usr/local/bin/php
            ln -sv /usr/local/php7/bin/php-cgi /usr/local/bin/php-cgi
            ln -sv /usr/local/php7/bin/php-config /usr/local/bin/php-config
            ln -sv /usr/local/php7/bin/phpdbg /usr/local/bin/phpdbg
            ln -sv /usr/local/php7/bin/phpize /usr/local/bin/phpize
            ln -sv /usr/local/php7/sbin/php-fpm /usr/local/sbin/php7-fpm

            systemctl daemon-reload
            systemctl enable php7-fpm

            echo -e "\e[92mStarting PHP FPM.\e[39m"
            sleep 2

            systemctl start php7-fpm
        fi
        
        echo -e "\e[92mRestarting PHP FPM.\e[39m"
        systemctl restart php7-fpm
    fi
fi

if [ "$MODE" == 3 ]; then
    echo -e "\e[92mUnstalling PHP and it's dependencies.\e[39m"
    sleep 2

    systemctl stop php7-fpm
    systemctl disable php7-fpm

    rm -v /lib/systemd/system/php7-fpm.service

    rm -v /usr/local/bin/tidy
    rm -v /usr/local/lib/libtidys.a
    rm -v /usr/local/include/tidyplatform.h
    rm -v /usr/local/include/tidy.h
    rm -v /usr/local/include/tidyenum.h
    rm -v /usr/local/include/tidybuffio.h
    rm -v /usr/local/lib/libtidy.so.5.2.0
    rm -v /usr/local/lib/libtidy.so.5
    rm -v /usr/local/lib/libtidy.so

    rm -v /usr/local/bin/pear
    rm -v /usr/local/bin/peardev
    rm -v /usr/local/bin/pecl
    rm -v /usr/local/bin/phar
    rm -v /usr/local/bin/php
    rm -v /usr/local/bin/php-cgi
    rm -v /usr/local/bin/php-config
    rm -v /usr/local/bin/phpdbg
    rm -v /usr/local/bin/phpize
    rm -v /usr/local/sbin/php7-fpm

    rm -frv /var/run/php
    rm -v /etc/php
    rm -frv /usr/local/php7

    if [ -d tidy-html5 ]; then
        rm -frv tidy-html5
    fi

    if [ -d php-src ]; then
        rm -frv php-src
    fi

    echo -e "\e[92mPHP is Uninstalled.\e[39m"

fi

exec ${SCRIPT}
