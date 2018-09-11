#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to do simple server admin

sudo dpkg -s dialog 2>/dev/null >/dev/null || sudo apt-get -y install dialog

export NCURSES_NO_UTF8_ACS=1

cd "$(dirname "$0")"

SCRIPT=$(readlink -f "$0");
ADMIN_DIR=$(pwd);

DIALOG=$(dialog)

DIALOG_ERROR=-1
DIALOG_OK=0
DIALOG_CANCEL=1
DIALOG_HELP=2
DIALOG_EXTRA=3
DIALOG_ITEM_HELP=4
DIALOG_ESC=255

HEIGHT=0
WIDTH=0

source "$ADMIN_DIR/scripts/functions.sh";

#echo mypassword | sudo -S command

[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@";

MAIN_MENU=$(
    dialog \
    --clear \
    --backtitle "Server Admin" \
    --title "Main Menu" \
    --cancel-label "Log Out" \
    --menu " Please Choose a Task" "$HEIGHT" "$WIDTH" 10 \
    1 "PHP Menu" \
    2 "System Information" \
    3 "Update" \
    4 "Root Terminal" \
    5 "Reboot Server" \
    3>&1 1>&2 2>&3
)

EXIT_STATUS=$?

case "$EXIT_STATUS" in
    "$DIALOG_OK")
        case "$MAIN_MENU" in
            1)
                source ./php/php-menu.sh;
                ;;
            2)
                RESULT=$(echo "Hostname: $HOSTNAME"; uptime);
                display_result "System Information" "$RESULT";
                ;;
            3)
                #RESULT=$(sudo cat /var/lib/update-notifier/updates-available);
                #display_result "Update Information" "$RESULT";
                dialog \
                    --title "Updating the System" \
                    --prgbox "apt-get update && apt-get -y upgrade" 20 100
                ;;
            4)
                clear;
                sudo -i;
                ;;
            5)
                sudo reboot;
                ;;
        esac
        ;;
    "$DIALOG_ITEM_HELP")
        exit;
        ;;
    "$DIALOG_CANCEL" | "$DIALOG_ESC")
        clear;
        echo "Admin Panel Closed.";
        exit;
        ;;
esac

exec ${SCRIPT}






