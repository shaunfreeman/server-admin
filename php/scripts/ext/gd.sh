#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the GD extension

if [[ "${ENABLE_EXTS[@]}" =~ "gd" ]]; then

    PHP_CONFIGURE_OPTIONS+=("--with-gd")

    # Not used in PHP 7.x
    #ask_question "Tiff for GD [y/N]"
    #if [ "$INSTALL_EXTENSION" == "y" ]; then
    #    PHP_CONFIGURE_OPTIONS+=("--enable-gd-native-tiff")
    #fi

    dialog --defaultno --yesno "FreeType for GD" 10 60
    if [ "$?" == 0 ]; then
        PHP_CONFIGURE_OPTIONS+=("--with-freetype-dir")
        PHP_DEPS+=("libfreetype6" "libfreetype6-dev")
    fi

    dialog --defaultno --yesno "JPEG for GD" 10 60
    if [ "$?" == 0 ]; then
        PHP_CONFIGURE_OPTIONS+=("--with-jpeg-dir")
        PHP_DEPS+=("libjpeg-turbo8-dev")
    fi

    dialog --defaultno --yesno "PNG for GD" 10 60
    if [ "$?" == 0 ]; then
        PHP_CONFIGURE_OPTIONS+=("--with-png-dir")
        PHP_DEPS+=("libpng12-dev")
    fi

    dialog --defaultno --yesno "XPM for GD" 10 60
    if [ "$?" == 0 ]; then
        PHP_CONFIGURE_OPTIONS+=("--with-xpm-dir")
        PHP_DEPS+=("libxpm-dev")
    fi

    dialog --defaultno --yesno "WebP for GD" 10 60
    if [ "$?" == 0 ]; then
        PHP_CONFIGURE_OPTIONS+=("--with-webp-dir")
        PHP_DEPS+=( "libwebp-dev")
    fi

    dialog --defaultno --yesno "JIS-mapped Japanese Font Support for GD" 10 60
    if [ "$?" == 0 ]; then
        PHP_CONFIGURE_OPTIONS+=("--enable-gd-jis-conv")
    fi
fi
