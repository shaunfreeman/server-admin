#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Summery: Bash Script to Install, update and remove the lastest PHP

BUILD_TYPE="update"
COMPILE_PHP=0

source "$PHP_DIR/scripts/prepare-build.sh"

CONFIGURE_OPTIONS_FILE="$PHP_DIR/$SELECTED_PHP_VERSION-configure-options.txt"
CURRENT_VERSION=($("php$SELECTED_PHP_VERSION" -version | grep -Po "^PHP ([0-9]*.[0-9]*.[0-9]*)" | tr " " -))

if [ "$CURRENT_VERSION" != "$PHP_VERSION" ]; then
    COMPILE_PHP=1
    RESULT=$(git checkout --progress "$PHP_VERSION")
    infobox "\n$RESULT" 5 60

    RESULT=$(git pull --progress)
    infobox "\n$RESULT" 5 60
else
    dialog --yesno "You are on the latest version of PHP ($PHP_VERSION). Do you want me to recompile PHP?" 0 0
    EXIT_STATUS=$?

    case "$EXIT_STATUS" in
        "$DIALOG_OK")
            COMPILE_PHP=1
            ;;
        "$DIALOG_CANCEL" | "$DIALOG_ESC")
            source "$PHP_DIR/php-menu.sh"
            ;;
    esac
fi

if [ -f  "$CONFIGURE_OPTIONS_FILE" ]; then

    dialog --yesno "Do you want to use the saved configure options?" 0 0
    EXIT_STATUS=$?

    case "$EXIT_STATUS" in
        "$DIALOG_OK")
            mapfile -t PHP_CONFIGURE_OPTIONS < "$CONFIGURE_OPTIONS_FILE"
            ;;
        "$DIALOG_CANCEL")
            sapi_options
            extension_options
            ;;
        "$DIALOG_ESC")
            source "$PHP_DIR/php-menu.sh"
            ;;
    esac
else
    sapi_options
    extension_options
fi

source "$PHP_DIR/scripts/build.sh"

systemctl restart "php$SELECTED_PHP_VERSION-fpm"

source "$PHP_DIR/php-menu.sh"