#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to do simple server admin

EDITBOX_HELP_MESSAGE=$(<"$ADMIN_DIR/help-files/editbox.txt")

display_result() {
  dialog \
    --title "$1" \
    --no-collapse \
    --msgbox "$2" 0 0
}

infobox() {
    dialog --infobox "$1" $2 $3;

}

error() {
  printf '\E[31m'; echo "$@"; printf '\E[0m'
}
