#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script to configure the SQLite Extentions extension

ask_question "SQLite [Y/n]"

if [ "$INSTALL_EXTENSION" == "n" ]; then
    PHP_CONFIGURE_OPTIONS+=("--without-sqlite3")

    MATCH=0

    for OPTION in "${PHP_CONFIGURE_OPTIONS[@]}"; do
        if [ "$OPTION" == "--without-pdo-sqlite" ]; then
            MATCH=1
        fi
    done

    if [ "$MATCH" == 0 ]; then
        PHP_CONFIGURE_OPTIONS+=("--without-pdo-sqlite")
    fi

else

    ask_question "PDO SQLite [Y/n]"

    if [ "$INSTALL_EXTENSION" == "n" ]; then
        PHP_CONFIGURE_OPTIONS+=("--without-pdo-sqlite")
    fi

fi
