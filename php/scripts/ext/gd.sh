#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the GD extension

ask_question "GD [y/N]"

if [ "$INSTALL_EXTENSION" == "y" ]; then
    GD_DEPS=()
    PHP_CONFIGURE_OPTIONS+=("--with-gd")

    # Not used in PHP 7.x
    #ask_question "Tiff for GD [y/N]"
    #if [ "$INSTALL_EXTENSION" == "y" ]; then
    #    PHP_CONFIGURE_OPTIONS+=("--enable-gd-native-tiff")
    #fi
    
    ask_question "FreeType for GD [y/N]"
    if [ "$INSTALL_EXTENSION" == "y" ]; then
        PHP_CONFIGURE_OPTIONS+=("--with-freetype-dir")
        PHP_DEPS+=("libfreetype6" "libfreetype6-dev")
    fi
    
    ask_question "JPEG for GD [y/N]"
    if [ "$INSTALL_EXTENSION" == "y" ]; then
        PHP_CONFIGURE_OPTIONS+=("--with-jpeg-dir")
    fi
    
    ask_question "PNG for GD [y/N]"
    if [ "$INSTALL_EXTENSION" == "y" ]; then
        PHP_CONFIGURE_OPTIONS+=("--with-png-dir")
        PHP_DEPS+=("libpng12-dev")
    fi

    ask_question "XPM for GD [y/N]"
    if [ "$INSTALL_EXTENSION" == "y" ]; then
        PHP_CONFIGURE_OPTIONS+=("--with-xpm-dir")
        PHP_DEPS+=("libxpm-dev")
    fi

    ask_question "WebP for GD [y/N]"
    if [ "$INSTALL_EXTENSION" == "y" ]; then
        PHP_CONFIGURE_OPTIONS+=("--with-webp-dir")
        PHP_DEPS+=( "libwebp-dev")
    fi

    ask_question "JIS-mapped Japanese Font Support for GD [y/N]"
    if [ "$INSTALL_EXTENSION" == "y" ]; then
        PHP_CONFIGURE_OPTIONS+=("--enable-gd-jis-conv")
    fi
fi
