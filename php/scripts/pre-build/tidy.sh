#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the Tidy extension

if [[ "${ENABLE_EXTS[@]}" =~ "tidy" ]] && [[ "$SELECTED_PHP_VERSION" < "7.1" ]]; then
    sed -i 's/buffio.h/tidybuffio.h/' ext/tidy/*.c
fi