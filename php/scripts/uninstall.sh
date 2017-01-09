#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Summery: Bash Script to remove the latest PHP

select_version "uninstall"

(
    systemctl stop "php$SELECTED_PHP_VERSION-fpm"
    systemctl disable "php$SELECTED_PHP_VERSION-fpm"

    rm -v "/lib/systemd/system/php$SELECTED_PHP_VERSION-fpm.service"

    rm -v "/usr/local/bin/pear$SELECTED_PHP_VERSION"
    rm -v "/usr/local/bin/peardev$SELECTED_PHP_VERSION"
    rm -v "/usr/local/bin/pecl$SELECTED_PHP_VERSION"

    rm -v "/usr/local/bin/phar$SELECTED_PHP_VERSION"
    rm -v "/usr/local/bin/php$SELECTED_PHP_VERSION"
    rm -v "/usr/local/bin/php-cgi$SELECTED_PHP_VERSION"
    rm -v "/usr/local/bin/php-config$SELECTED_PHP_VERSION"
    rm -v "/usr/local/bin/phpdbg$SELECTED_PHP_VERSION"

    rm -v "/usr/local/bin/phpize$SELECTED_PHP_VERSION"
    rm -v "/usr/local/sbin/php$SELECTED_PHP_VERSION-fpm"

    rm -v "/etc/php/php$SELECTED_PHP_VERSION"
    rm -frv "/usr/local/php$SELECTED_PHP_VERSION"

    if [ -d "$PHP_DIR/src/php-src" ]; then
        rm -frv php-src
    fi
) | dialog \
    --title "Uninstalling PHP" \
    --programbox 20 100

source "$PHP_DIR/php_menu.sh"
