#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the Zlib extension

if [[ "${ENABLE_EXTS[@]}" =~ "zlib" ]]; then
    PHP_CONFIGURE_OPTIONS+=("--with-zlib")

    for OPTION in "${PHP_CONFIGURE_OPTIONS[@]}"; do
        if [ "$OPTION" == "--with-png-dir" ]; then
            PHP_CONFIGURE_OPTIONS+=("--with-zlib-dir")
        fi
    done

    PHP_DEPS+=("zlib1g" "zlib1g-dev")
else
    if [[ "${PHP_CONFIGURE_OPTIONS[@]}" =~ "--with-png-dir" ]]; then
        PHP_CONFIGURE_OPTIONS+=("--with-zlib" "--with-zlib-dir")
        PHP_DEPS+=("zlib1g" "zlib1g-dev")
    fi
fi