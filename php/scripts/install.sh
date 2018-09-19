#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Summery: Bash Script to install PHP

BUILD_TYPE="install"

source "$PHP_DIR/scripts/prepare-build.sh"

mkdir "/usr/local/php$SELECTED_PHP_VERSION"

sapi_options
extension_options

source "$PHP_DIR/scripts/build.sh"

(
    mkdir -v "/usr/local/php$SELECTED_PHP_VERSION/lib/tmpfiles.d"

    if [ ! -d /etc/php ]; then
        mkdir /etc/php
    fi

    mv -v "/usr/local/php$SELECTED_PHP_VERSION/etc/php-fpm.conf.default" "/usr/local/php$SELECTED_PHP_VERSION/etc/php-fpm.conf"
    cp -v "$PHP_DIR/src/php-src/php.ini-production" "/usr/local/php$SELECTED_PHP_VERSION/etc/php.ini"
    cp -v "$PHP_DIR/tempfiles.d/php-fpm.conf" "/usr/local/php$SELECTED_PHP_VERSION/lib/tmpfiles.d/php-fpm.conf"
    cp -v "$PHP_DIR/php-fpm-checkconf" "/usr/local/php$SELECTED_PHP_VERSION/php-fpm-checkconf"
    cp -v "$PHP_DIR/systemd/php-fpm.service" "/lib/systemd/system/php$SELECTED_PHP_VERSION-fpm.service"
    chmod +x "/usr/local/php$SELECTED_PHP_VERSION/php-fpm-checkconf"

    REPLACE_STRING="s/{SELECTED_PHP_VERSION}/$SELECTED_PHP_VERSION/g"

    sed -i "$REPLACE_STRING" "/usr/local/php$SELECTED_PHP_VERSION/lib/tmpfiles.d/php-fpm.conf"
    sed -i "$REPLACE_STRING" "/usr/local/php$SELECTED_PHP_VERSION/php-fpm-checkconf"
    sed -i "$REPLACE_STRING" "/lib/systemd/system/php$SELECTED_PHP_VERSION-fpm.service"

    ln -sv "/usr/local/php$SELECTED_PHP_VERSION/etc" "/etc/php/$SELECTED_PHP_VERSION"

    ln -sv "/usr/local/php$SELECTED_PHP_VERSION/bin/pear" "/usr/local/bin/pear$SELECTED_PHP_VERSION"
    ln -sv "/usr/local/php$SELECTED_PHP_VERSION/bin/peardev" "/usr/local/bin/peardev$SELECTED_PHP_VERSION"
    ln -sv "/usr/local/php$SELECTED_PHP_VERSION/bin/pecl" "/usr/local/bin/pecl$SELECTED_PHP_VERSION"
    ln -sv "/usr/local/php$SELECTED_PHP_VERSION/bin/phar" "/usr/local/bin/phar$SELECTED_PHP_VERSION"
    ln -sv "/usr/local/php$SELECTED_PHP_VERSION/bin/php-config" "/usr/local/bin/php-config$SELECTED_PHP_VERSION"
    ln -sv "/usr/local/php$SELECTED_PHP_VERSION/bin/phpize" "/usr/local/bin/phpize$SELECTED_PHP_VERSION"

) | dialog \
    --title "Installing PHP" \
    --programbox 20 100

systemctl daemon-reload
systemctl enable "php$SELECTED_PHP_VERSION-fpm"

source "$PHP_DIR/php-menu.sh"
