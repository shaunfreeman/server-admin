#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Version: 1.0.0
# Summery: Bash Script for all functions

error() {
  printf '\E[31m'; echo "$@"; printf '\E[0m'
}

check_version() {
    git fetch --tags
    CURRENT_VERSION=($(git name-rev --name-only HEAD | grep -Po "$1"))
    VERSIONS=($(git tag -l | grep -Po "$1" | sort -V))
    NUM_VERSIONS="${#VERSIONS[@]}"
    LATEST_VERSION="${VERSIONS[$NUM_VERSIONS-1]}"
}

check_deps() {
    DEPS_TO_INSTALL=()
    
    for dep in ${PHP_DEPS[@]}; do
        DEP_INSTALLED=($(dpkg -l | grep -Po "$dep"))

        if [ "$DEP_INSTALLED" != "$dep" ]; then
            DEPS_TO_INSTALL+=("$dep")
        else
            echo -e "\e[92m$dep already installed.\e[39m"
        fi
    done

    if [[ "${DEPS_TO_INSTALL[@]}" ]]; then
        apt-get install -y $(printf "%s " "${DEPS_TO_INSTALL[@]}")
    fi
}

ask_question() {
    INSTALL_EXTENSION=""
    echo -e "\e[92m"
    read -p "Would you like to enable $1:" INSTALL_EXTENSION
    echo -e "\e[39m"
}