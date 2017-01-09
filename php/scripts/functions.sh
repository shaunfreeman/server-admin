#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script for all functions

PHP_SUPPORTED_VERSIONS=("7.1" "7.0" "5.6" "5.5")
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
    PHP_DEPS=($1)

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
            "uninstall")
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

    case "$EXIT_STATUS" in
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
        cgi     "CGI"       on \
        cli     "CLI"       on \
        fpm     "FPM"       off \
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
        bcmath      "BCMath"                    off \
        bzip2       "Bzip2"                     off \
        calendar    "Calendar"                  off \
        ctype       "Ctype"                     on \
        curl        "Curl"                      off \
        dom         "DOM"                       on \
        exif        "Exif"                      off \
        fileinfo    "FileInfo"                  on \
        filter      "Filter"                    on \
        ftp         "FTP"                       off \
        gd          "GD"                        off \
        gettext     "Gettext"                   off \
        hash        "Hash"                      on \
        iconv       "Iconv"                     on \
        intl        "Intl"                      off \
        json        "JSON"                      on \
        libxml      "LibXML"                    on \
        mbstring    "Mulibyte String"           off \
        mcrypt      "Mcrypt"                    off \
        mysql       "MySQL"                     off \
        opcache     "OPcache"                   on \
        openssl     "OpenSSL"                   off \
        pdo         "PDO"                       on \
        phar        "Phar"                      on \
        posix       "POSIX"                     on \
        pspell      "Pspell"                    off \
        readline    "Readline"                  off \
        recode      "Recode"                    off \
        session     "Session"                   on \
        simplexml   "SimpleXML"                 on \
        snmp        "SNMP"                      off \
        soap        "Soap"                      off \
        sockets     "Sockets"                   off \
        sqlite      "SQLite"                    on \
        sysvmsg     "System V Messages"         off \
        sysvsem     "System V Shared Memory"    off \
        sysvshm     "System V Semaphore"        off \
        tidy        "Tidy"                      off \
        tokenizer   "Tokenizer"                 on \
        wddx        "WDDX"                      off \
        xml         "XML"                       on \
        xmlreader   "XML Reader"                on \
        xmlrpc      "XML-RPC"                   off \
        xmlwriter   "XML Writer"                on \
        xsl         "XSL"                       off \
        zip         "Zip"                       off \
        zlib        "Zlib"                      off \
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