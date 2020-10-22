#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Summery: Bash Script to Install, update and remove the lastest PHP

cd "$ADMIN_DIR/php"
PHP_DIR=$(pwd)
PHP_INSTALLED=()

source "$PHP_DIR/scripts/functions.sh"

OPTION_ARRAY=()
BACK_TITLE="PHP Options"

for VERSION in "${PHP_SUPPORTED_VERSIONS[@]}"; do
    INSTALLED=($(php_installed "$VERSION"))

    if [ "$INSTALLED" ];then
        VERSION=($(php_version "$INSTALLED"))
        PHP_INSTALLED+=("$VERSION")
    fi
done

if [ ! "$PHP_INSTALLED" ]; then
    OPTION_ARRAY+=(1 "Install PHP")
else
    OPTION_ARRAY+=(
        1 "Install PHP" \
        2 "Update PHP" \
        3 "Uninstall PHP" \
        4 "Edit PHP INI File" \
        5 "PHP-FPM Pools"
    )
    VERSIONS=$(printf ":%s " "${PHP_INSTALLED[@]}")
    BACK_TITLE+=" - PHP Version$VERSIONS"
fi

OPTION=$(
    dialog \
    --backtitle "$BACK_TITLE" \
    --title "PHP Options" \
    --cancel-label "Back" \
    --menu "Choose your option" 15 60 10 \
    "${OPTION_ARRAY[@]}" \
     3>&1 1>&2 2>&3
)

EXIT_STATUS=$?

case "$EXIT_STATUS" in
    "$DIALOG_OK")
        case "$OPTION" in
            1)
                source "$PHP_DIR/scripts/install.sh"
                ;;
            2)
                source "$PHP_DIR/scripts/update.sh"
                ;;
            3)
                source "$PHP_DIR/scripts/uninstall.sh"
                ;;
            4)
                source "$PHP_DIR/scripts/edit-ini.sh"
                ;;
            5)
                source "$PHP_DIR/scripts/pools.sh"
                ;;
            esac
            ;;
    "$DIALOG_CANCEL" | "$DIALOG_ESC")
        exec ${SCRIPT};
        ;;
esac
