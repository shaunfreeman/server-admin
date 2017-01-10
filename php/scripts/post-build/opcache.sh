#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the OPcache extension

if [[ "${ENABLE_EXTS[@]}" =~ "opcache" ]]; then
    cp -v "$PHP_DIR/conf.d/opcache.ini" "/usr/local/php$SELECTED_PHP_VERSION/etc/conf.d/10opcache.ini"
fi
