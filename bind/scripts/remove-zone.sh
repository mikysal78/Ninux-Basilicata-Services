#!/bin/bash

if [ $# -ne 1 ];then
    echo "Usage: remove-zone.sh <domainname>"
    exit 1
fi

## Domain name
DOMAIN=$1

ZONECONFIG="/etc/bind/named.conf.default-zones"

if [ `sed -n '/^zone "'${DOMAIN}'."/p' /etc/bind/named.conf.default-zones|wc -l` -eq 1 ];then
    ##Remove entries from dns configuration file
    sed -i -e '/^zone "'${DOMAIN}'."/,/^};/d' ${ZONECONFIG}
    sed -i '$d' ${ZONECONFIG}

    echo "[*] Removed zone entries from bind configuration"
else
    echo "[ERROR] ${DOMAIN} not present in bind configuration"
    exit 1
fi

#Remove zone file if it exists
if [ -f /etc/bind/zones/${DOMAIN} ];then
    rm -f /etc/bind/zones/${DOMAIN}
    echo "[*] Removed zone db file"
fi
