#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Summery: Bash Script to install PHP

NO_CPU=($(grep -c ^processor /proc/cpuinfo))
MAKE_OPTIONS="-j$NO_CPU"
CONFIGURE_OPTIONS_FILE="$PHP_DIR/$SELECTED_PHP_VERSION-configure-options.txt"

dialog --infobox "\nPreparing to build $PHP_VERSION" 5 45

PRE_BUILD="$PHP_DIR/scripts/pre-build/*.sh"

for PRE_EXT in $PRE_BUILD; do
    source "$PRE_EXT"
done

printf "%s\n" "${PHP_CONFIGURE_OPTIONS[@]}" > "$CONFIGURE_OPTIONS_FILE"

check_deps | dialog --title "Checking Dependencies" \
       --progressbox 20 100

# start timing the build
START=$(date +"%s")

./buildconf --force | dialog --title "buildconf" --progressbox 20 100

./configure $(printf "%s " "${PHP_CONFIGURE_OPTIONS[@]}") | dialog --title "Configure" --progressbox "Running Configure. Please wait." 20 100

make "${MAKE_OPTIONS}"
make install | dialog --title "Make Install" --progressbox "Installing PHP. Please wait." 20 100
make clean | dialog --title "Make Clean" --progressbox "Running make clean. Please wait." 20 100

# finish timing the build
END=$(date +"%s")
DIFF=$(($END-$START))

POST_BUILD="$PHP_DIR/scripts/post-build/*.sh"

for POST_EXT in $POST_BUILD; do
    source "$POST_EXT"
done
