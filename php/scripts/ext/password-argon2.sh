#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the XML Extentions extension

if [[ "${ENABLE_EXTS[@]}" =~ "password-argon2" ]]; then
    PHP_CONFIGURE_OPTIONS+=("--with-password-argon2")
    PHP_DEPS+=("libargon2-0" "libargon2-0-dev")
fi