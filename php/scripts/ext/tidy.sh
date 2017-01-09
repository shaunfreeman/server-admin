#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the Tidy extension

if [[ "${ENABLE_EXTS[@]}" =~ "tidy" ]]; then
    # Install Tidy

    cd "${PHP_DIR}/src"

    if [ ! -d tidy-html5 ]; then

        git clone git://github.com/htacg/tidy-html5.git --progress $1 > git.log 2>&1 | (
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

        ) | dialog --clear --title "Tidy Source Code Download" --gauge "Please wait while I download the Tidy source code." 10 70 0;
    fi

    cd "$PHP_DIR/src/tidy-html5"

    dialog --infobox "\nChecking for latest Tidy version." 5 45

    # Check for lastest version
    check_version '[0-9]*.[0-9]*.[0-9]*$'
    TIDY_INSTALLED=$(command -v tidy)

    if [ "$TIDY_INSTALLED" ]; then
        CURRENT_VERSION=($(tidy -v | grep -Po '[0-9]*.[0-9]*.[0-9]*$'))
    fi

    if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then

        RESULT=$(git checkout --progress "$LASTEST_VERSION")
        infobox "\n$RESULT" 5 60

        RESULT=$(git --progress pull)
        infobox "\n$RESULT" 5 60

        cd build/cmake
        cmake ../..
        make ${MAKE_OPTIONS} | dialog --title "Compiling Tidy $LATEST_VERSION" --progressbox "Compiling Tidy. Please wait"  20 100
        make install | dialog --title "Installing Tidy $LATEST_VERSION" --progressbox "Installing. Please wait"  20 100
        make clean | dialog --title "Clean Tidy $LATEST_VERSION" --progressbox "Cleaning build. Please wait"  20 100


        cd "$PHP_DIR/src/php-src"

        infobox "\nFinished checking Tidy." 5 60
        sleep 2
    else
        cd "$PHP_DIR/src/php-src"
        infobox "\nTidy on lastest version: $LATEST_VERSION." 5 60
        sleep 2
    fi

    PHP_CONFIGURE_OPTIONS+=("--with-tidy=/usr/local")
fi
