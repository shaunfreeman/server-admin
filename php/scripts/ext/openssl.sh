#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the OpenSSL extension

if [[ "${ENABLE_EXTS[@]}" =~ "openssl" ]]; then
    PHP_CONFIGURE_OPTIONS+=("--with-openssl")
    PHP_DEPS+=("libssl-dev" "libsslcommon2-dev")
fi
