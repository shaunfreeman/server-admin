#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script for all functions

PHP_SUPPORTED_VERSIONS=("7.4" "7.3" "7.2")
PHP_DEPS=()

php_installed() {
    command -v php$1
}

php_version() {
    $1 -version | grep -Po '^PHP \K([0-9]*.[0-9]*.[0-9]*)' | tr ' ' -
}

check_version() {
    git fetch --tags
    CURRENT_VERSION=($(git name-rev --name-only HEAD | grep -Po "$1"))
    VERSIONS=($(git tag -l | grep -Po "$1" | sort -V))
    NUM_VERSIONS="${#VERSIONS[@]}"
    echo "${VERSIONS[$NUM_VERSIONS-1]}"
}

check_deps() {
    DEPS_TO_INSTALL=()

    for dep in "${PHP_DEPS[@]}"; do
        DEP_INSTALLED=($(dpkg -l | grep -Po "$dep"))

        if [ "$DEP_INSTALLED" != "$dep" ]; then
            DEPS_TO_INSTALL+=("$dep")
        else
            echo "$dep already installed."
        fi
    done

    if [[ "${DEPS_TO_INSTALL[@]}" ]]; then
        apt-get install -y $(printf "%s " "${DEPS_TO_INSTALL[@]}")
    fi
}

select_version() {
    SELECTED_VERSION_OPTIONS=()
    for VERSION in "${PHP_SUPPORTED_VERSIONS[@]}"; do
        PHP_INSTALLED=$(command -v php"$VERSION")

        case $1 in
            "install")
                if [ ! "$PHP_INSTALLED" ]; then
                    SELECTED_VERSION_OPTIONS+=("$VERSION" "PHP $VERSION" off)
                fi
                ;;
            *)
                if [ "$PHP_INSTALLED" ]; then
                    SELECTED_VERSION_OPTIONS+=("$VERSION" "PHP $VERSION" off)
                fi
                ;;
        esac
    done
    
    SELECTED_PHP_VERSION=$(dialog \
        --title "PHP Version List" \
        --radiolist "Please choose which version you wish me to $1" \
        20 30 5 \
        "${SELECTED_VERSION_OPTIONS[@]}" \
        3>&1 1>&2 2>&3
    )
    EXIT_STATUS=$?

    if [ "$1" == "install" ] || [ "$1" == "update" ]; then
        PHP_CONFIGURE_OPTIONS=(
            "--prefix=/usr/local/php$SELECTED_PHP_VERSION" \
            "--with-config-file-path=/usr/local/php$SELECTED_PHP_VERSION/etc" \
            "--with-config-file-scan-dir=/usr/local/php$SELECTED_PHP_VERSION/etc/conf.d"
        )
    fi

    case "$EXIT_STATUS" in
        "$DIALOG_OK")
            if [[ ! "$SELECTED_PHP_VERSION" ]]; then
                source "$PHP_DIR/php-menu.sh"
            fi
            ;;
        "$DIALOG_CANCEL" | "$DIALOG_ESC")
            source "$PHP_DIR/php-menu.sh"
            ;;
    esac

}

sapi_options() {

    ENABLE_SAPIS=$(dialog \
        --title "PHP SAPI List" \
        --backtitle "PHP Build List" \
        --visit-items \
        --no-cancel \
        --buildlist "Select the PHP SAPIs you would like in this build" 40 70 30 \
        cgi     "CGI"       off \
        cli     "CLI"       on \
        fpm     "FPM"       on \
        phpdbg  "PHPDBG"    on \
        3>&1 1>&2 2>&3
    )

    SAPIS="$PHP_DIR/scripts/sapi/*.sh"

    for SAPI in $SAPIS; do
        source "$SAPI"
    done
}

extension_options() {
    
    ENABLE_EXTS=$(dialog \
        --title "PHP Extension List" \
        --backtitle "PHP Build List" \
        --visit-items \
        --no-cancel \
        --buildlist "Select the PHP Extensions you would like in this build" 40 70 30 \
        bcmath          "BCMath"                    off \
        bzip2           "Bzip2"                     off \
        calendar        "Calendar"                  off \
        ctype           "Ctype"                     on \
        curl            "Curl"                      off \
        dom             "DOM"                       on \
        exif            "Exif"                      off \
        fileinfo        "FileInfo"                  on \
        filter          "Filter"                    on \
        ftp             "FTP"                       off \
        gd              "GD"                        off \
        gettext         "Gettext"                   off \
        hash            "Hash"                      on \
        iconv           "Iconv"                     on \
        intl            "Intl"                      off \
        json            "JSON"                      on \
        libxml          "LibXML"                    on \
        mbstring        "Mulibyte String"           off \
        mcrypt          "Mcrypt"                    off \
        mysql           "MySQL"                     off \
        opcache         "OPcache"                   on \
        openssl         "OpenSSL"                   off \
        password-argon2 "Password Argon 2"          on \
        pdo             "PDO"                       on \
        phar            "Phar"                      on \
        posix           "POSIX"                     on \
        pspell          "Pspell"                    off \
        readline        "Readline"                  off \
        recode          "Recode"                    off \
        session         "Session"                   on \
        simplexml       "SimpleXML"                 on \
        snmp            "SNMP"                      off \
        soap            "Soap"                      off \
        sockets         "Sockets"                   off \
        sodium          "Sodium"                    on \
        sqlite          "SQLite"                    on \
        sysvmsg         "System V Messages"         off \
        sysvsem         "System V Shared Memory"    off \
        sysvshm         "System V Semaphore"        off \
        tidy            "Tidy"                      off \
        tokenizer       "Tokenizer"                 on \
        wddx            "WDDX"                      off \
        xml             "XML"                       on \
        xmlreader       "XML Reader"                on \
        xmlrpc          "XML-RPC"                   off \
        xmlwriter       "XML Writer"                on \
        xsl             "XSL"                       off \
        zip             "Zip"                       off \
        zlib            "Zlib"                      off \
        3>&1 1>&2 2>&3
    )

    EXIT_STATUS=$?

    case "$EXIT_STATUS" in
        "$DIALOG_CANCEL" | "$DIALOG_ESC")
            ;;
    esac

    EXTS="$PHP_DIR/scripts/ext/*.sh"

    for EXT in $EXTS; do
        source "$EXT"
    done
}