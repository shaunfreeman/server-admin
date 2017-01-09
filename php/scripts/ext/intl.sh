#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the Intl extension

if [[ "${ENABLE_EXTS[@]}" =~ "intl" ]]; then
    PHP_CONFIGURE_OPTIONS+=("--enable-intl")
    PHP_DEPS+=('libicu-dev')
fi
