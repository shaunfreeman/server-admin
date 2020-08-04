#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the GD extension

if [[ "${ENABLE_EXTS[@]}" =~ "gd" ]]; then

    if [ "$SELECTED_PHP_VERSION" == "7.4" ]; then
      PHP_CONFIGURE_OPTIONS+=("--enable-gd")
    else
      PHP_CONFIGURE_OPTIONS+=("--with-gd")
    fi

    dialog --defaultno --yesno "FreeType for GD" 10 60
    if [ "$?" == 0 ]; then
       if [ "$SELECTED_PHP_VERSION" == "7.4" ]; then
          PHP_CONFIGURE_OPTIONS+=("--with-freetype")
        else
          PHP_CONFIGURE_OPTIONS+=("--with-freetype-dir")
        fi
        PHP_DEPS+=("libfreetype6" "libfreetype6-dev")
    fi

    dialog --defaultno --yesno "JPEG for GD" 10 60
    if [ "$?" == 0 ]; then
        if [ "$SELECTED_PHP_VERSION" == 7.4 ]; then
          PHP_CONFIGURE_OPTIONS+=("--with-jpeg")
        else
          PHP_CONFIGURE_OPTIONS+=("--with-jpeg-dir")
        fi

        PHP_DEPS+=("libjpeg-turbo8-dev")
    fi

    if [ "$SELECTED_PHP_VERSION" != "7.4" ]; then
      dialog --defaultno --yesno "PNG for GD" 10 60
      if [ "$?" == 0 ]; then
          PHP_CONFIGURE_OPTIONS+=("--with-png-dir")
          PHP_DEPS+=("libpng-dev")
      fi
    fi

    dialog --defaultno --yesno "XPM for GD" 10 60
    if [ "$?" == 0 ]; then
        if [ "$SELECTED_PHP_VERSION" == "7.4" ]; then
          PHP_CONFIGURE_OPTIONS+=("--with-xpm")
        else
          PHP_CONFIGURE_OPTIONS+=("--with-xpm-dir")
        fi

        PHP_DEPS+=("libxpm-dev")
    fi

    if [ "$SELECTED_PHP_VERSION" != "7.4" ]; then
      dialog --defaultno --yesno "WebP for GD" 10 60
      if [ "$?" == 0 ]; then
          PHP_CONFIGURE_OPTIONS+=(" --with-vpx-dir" "--with-webp-dir")
          PHP_DEPS+=( "libwebp-dev" "libvpx-dev")
      fi
    fi

    dialog --defaultno --yesno "JIS-mapped Japanese Font Support for GD" 10 60
    if [ "$?" == 0 ]; then
        PHP_CONFIGURE_OPTIONS+=("--enable-gd-jis-conv")
    fi
fi
