#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the Exif extension

ask_question "Exif [y/N]"

if [ "$INSTALL_EXTENSION" == "y" ]; then
    PHP_CONFIGURE_OPTIONS+=("--enable-exif")
fi