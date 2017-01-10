#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Summery: Bash Script to install PHP symlinks

if [ ! -d "/usr/local/php$SELECTED_PHP_VERSION/etc/conf.d" ]; then
    mkdir -v "/usr/local/php$SELECTED_PHP_VERSION/etc/conf.d"
fi

if [[ "${ENABLE_SAPIS[@]}" =~ "cli" ]] && [ ! -f "/usr/local/bin/php$SELECTED_PHP_VERSION" ]; then
    ln -sv "/usr/local/php$SELECTED_PHP_VERSION/bin/php" "/usr/local/bin/php$SELECTED_PHP_VERSION"
fi

if [[ "${ENABLE_SAPIS[@]}" =~ "cgi" ]] && [ ! -f "/usr/local/bin/php-cgi$SELECTED_PHP_VERSION" ]; then
    ln -sv "/usr/local/php$SELECTED_PHP_VERSION/bin/php-cgi" "/usr/local/bin/php-cgi$SELECTED_PHP_VERSION"
fi

if [[ "${ENABLE_SAPIS[@]}" =~ "phpdbg" ]] && [ ! -f "/usr/local/bin/phpdbg$SELECTED_PHP_VERSION" ]; then
    ln -sv "/usr/local/php$SELECTED_PHP_VERSION/bin/phpdbg" "/usr/local/bin/phpdbg$SELECTED_PHP_VERSION"
fi

if [[ "${ENABLE_SAPIS[@]}" =~ "fpm" ]] && [ ! -f "/usr/local/sbin/php$SELECTED_PHP_VERSION-fpm" ]; then
    ln -sv "/usr/local/php$SELECTED_PHP_VERSION/sbin/php-fpm" "/usr/local/sbin/php$SELECTED_PHP_VERSION-fpm"
fi
