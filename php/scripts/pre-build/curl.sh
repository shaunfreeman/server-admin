#!/usr/bin/env bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Summery: Bash Script to install PHP symlink for curl for PHP 5.6

if [[ "${ENABLE_EXTS[@]}" =~ "curl" ]]; then
    if [ ! -d "/usr/include/curl" ]; then
        ln -sv "/usr/includex86_64-linux-gnu/curl" "/usr/include/curl"
    fi
fi
