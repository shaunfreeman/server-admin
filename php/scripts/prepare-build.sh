#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Summery: Bash Script to install/update the latest PHP

dialog --infobox "\nPlease wait I setup PHP build." 5 35;

if [ ! -d src ]; then
    mkdir src
fi

cd src

PHP_DEPS+=("build-essential" "git" "autoconf" "bison" "cmake" "pkg-config" "re2c")

check_deps  | dialog --title "Checking Dependencies" \
       --progressbox 20 100

if [ ! -d php-src ]; then

    git clone http://github.com/php/php-src.git --progress $1 > git.log 2>&1 | (
        PERCENTAGE=0
        OBJECTS_DONE=0
        DELTAS_DONE=0
        FINISHED=0

        while [ "$FINISHED" == 0 ]; do

            if [ "$OBJECTS_DONE" == 0 ]; then
                OBJECTS=($(cat -A git.log | grep -Po "Receiving objects: *\K([0-9]*)"));
                if [ ! -z "$OBJECTS" ]; then
                    NUM="${#OBJECTS[@]}";
                    PERCENTAGE="${OBJECTS[$NUM-1]}";
                    echo XXX
                    echo "$PERCENTAGE";
                    echo "Receiving objects.";
                    echo XXX
                 fi

                if [ "$PERCENTAGE" == 100 ]; then
                    OBJECTS_DONE=1;
                fi

            elif [ "$DELTAS_DONE" == 0 ]; then
                DELTAS=($(cat -A git.log | grep -Po "Resolving deltas: *\K([0-9]*)"));
                if [ ! -z "$DELTAS" ]; then
                    NUM="${#DELTAS[@]}";
                    PERCENTAGE="${DELTAS[$NUM-1]}";
                    echo XXX
                    echo "$PERCENTAGE";
                    echo "Resolving deltas.";
                    echo XXX
                fi

                if [ "$PERCENTAGE" == 100 ]; then
                    DELTAS_DONE=1;
                fi
            else
                FINISHED=1
            fi

            sleep 0.5;
        done

    ) | dialog --clear --title "PHP Source Code Download" --gauge "Please wait while I download the PHP source code." 10 70 0;
fi
    
select_version "$BUILD_TYPE"

dialog --infobox "\nChecking for latest PHP version: $SELECTED_PHP_VERSION.*" 5 45

cd php-src

LATEST_VERSION=$(check_version "^php-$SELECTED_PHP_VERSION.[0-9]*$")
PHP_INSTALLED=$(command -v "php$SELECTED_PHP_VERSION")

PHP_VERSION="${LATEST_VERSION^^}"

dialog \
    --title "Updating the System" \
    --prgbox "git checkout --progress $PHP_VERSION" 20 100
