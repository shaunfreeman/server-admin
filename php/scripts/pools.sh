#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Summery: Bash Script to install/update/delete the PHP-FPM Pools

select_version

OPTION=$(
    dialog \
    --backtitle "PHP-FPM $SELECTED_PHP_VERSION Pools" \
    --title "PHP-FPM $SELECTED_PHP_VERSION Options" \
    --cancel-label "Back" \
    --menu "Choose your option" 15 60 4 \
    1 "Add Pool" \
    2 "Edit Pool" \
    3 "Remove Pool" \
     3>&1 1>&2 2>&3
)

EXIT_STATUS=$?

case "$EXIT_STATUS" in
    "$DIALOG_OK")
        case "$OPTION" in
            1)
                source "$PHP_DIR/scripts/fpm-pools/add-pool.sh"
                ;;
            2)
                source "$PHP_DIR/scripts/fpm-pools/edit-pool.sh"
                ;;
            3)
                source "$PHP_DIR/scripts/fpm-pools/remove-pool.sh"
                ;;
            esac
            ;;
    "$DIALOG_CANCEL" | "$DIALOG_ESC")
        source "$PHP_DIR/php-menu.sh"
        ;;
esac
