#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Summery: Bash Script to edit PHP ini file

select_version

INPUT="/etc/php/$SELECTED_PHP_VERSION/php.ini"

if [ ! -f "$INPUT" ]; then
    touch "$INPUT"
fi

OUTPUT=$(
    dialog \
    --title "Edit PHP INI File" \
    --help-button \
    --fixed-font "$@" \
    --editbox "$INPUT" 0 0 \
    3>&1 1>&2 2>&3
)
RETVAL=$?

case $RETVAL in
    "$DIALOG_OK")
        echo "$OUTPUT" > "$PHP_INI"
        display_result "Edit PHP INI" "\nYour edits have been saved.\n\n"
        source "$PHP_DIR/php-menu.sh"
        ;;
    "$DIALOG_HELP")
        dialog \
            --title "Edit PHP Box" \
            --msgbox "$EDITBOX_HELP_MESSAGE" 0 0

        source "$PHP_DIR/scripts/edit-ini.sh"
        ;;
    "$DIALOG_CANCEL" | "$DIALOG_ESC")
        source "$PHP_DIR/php-menu.sh"
        ;;
esac
