#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the Tidy extension

ask_question "Tidy [y/N]"

if [ "$INSTALL_EXTENSION" == "y" ]; then
    # Install Tidy
    echo -e "\e[92mChecking Tidy.\e[39m"
    sleep 2

    cd "${INSTALLER_DIR}/src"

    if [ ! -d tidy-html5 ]; then
        git clone git://github.com/htacg/tidy-html5.git
    fi

    cd "$INSTALLER_DIR/src/tidy-html5"

    # Check for lastest version
    check_version '[0-9]*.[0-9]*.[0-9]*$'
    TIDY_INSTALLED=$(command -v tidy)

    if [ "$TIDY_INSTALLED" ]; then
        CURRENT_VERSION=($(tidy -v | grep -Po '[0-9]*.[0-9]*.[0-9]*$'))
    fi

    if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
        echo -e "\e[92mCompiling TIDY Version: $LATEST_VERSION\e[39m"
        sleep 2

        git checkout "$LASTEST_VERSION"
        git pull

        cd build/cmake
        cmake ../..
        make ${MAKE_OPTIONS}
        make install
        make clean

        cd "$INSTALLER_DIR/src/php-src"

        echo -e "\e[92mFinished checking Tidy.\e[39m"
        sleep 2
    else
        cd "$INSTALLER_DIR/src/php-src"
        echo -e "\e[92mTidy on lastest version: $LATEST_VERSION.\e[39m"
        sleep 2
    fi

    PHP_CONFIGURE_OPTIONS+=("--with-tidy=/usr/local")
fi
