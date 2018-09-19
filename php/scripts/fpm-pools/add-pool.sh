#!/bin/bash
# Copyright (c) 2016 Shaun Freeman  All Rights Reserved
# Author: Shaun Freeman <shaun@shaunfreeman.co.uk>
# Date: 21/11/2016
# Summery: Bash Script to add PHP-FPM Pools

USER=""
GROUP=""
LISTEN="var/run/php-fpm.sock"
LISTEN_OWNER="www-data"
LISTEN_GROUP="www-data"

# Store data to $VALUES variable
VALUES=$(dialog --ok-label "Submit" \
	  --backtitle "PHP-FPM Pool Management" \
	  --title "Pool Add" \
	  --output-separator ":" \
	  --form "Create a new php-fpm pool" \
15 70 0 \
	"User:"         1 1	"$USER" 	    1 14 20 0 \
	"Group:"        2 1	"$GROUP"  	    2 14 20 0 \
	"Listen:"       3 1	"$LISTEN"  	    3 14 50 0 \
	"Listen Owner:" 4 1	"$LISTEN_OWNER" 4 14 20 0 \
	"Listen Group:" 5 1	"$LISTEN_GROUP" 5 14 20 0 \
    3>&1 1>&2 2>&3
)

EXIT_STATUS=$?

case "$EXIT_STATUS" in
    "$DIALOG_OK")
            IFS=':' read -r -a VALUES <<< "$VALUES"
            POOL_CONF="/usr/local/php$SELECTED_PHP_VERSION/etc/php-fpm.d/${VALUES[0]}.conf"
            cp "$PHP_DIR/scripts/fpm-pools/php-fpm.d/skeleton.conf" "$POOL_CONF"
            sed -i "s@{USER}@${VALUES[0]}@" "$POOL_CONF"
            sed -i "s@{GROUP}@${VALUES[1]}@" "$POOL_CONF"
            sed -i "s@{LISTEN}@${VALUES[2]}@" "$POOL_CONF"
            sed -i "s@{LISTEN_OWNER}@${VALUES[3]}@" "$POOL_CONF"
            sed -i "s@{LISTEN_GROUP}@${VALUES[4]}@" "$POOL_CONF"
            systemctl restart "php$SELECTED_PHP_VERSION-fpm"
            source "$PHP_DIR/php-menu.sh";
            ;;
    "$DIALOG_CANCEL" | "$DIALOG_ESC")
        source "$PHP_DIR/php-menu.sh";
        ;;
esac
