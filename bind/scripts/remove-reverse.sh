#!/bin/bash -x

if [ $# -ne 1 ];then
    echo "Usage: remove-reverse.sh <My Network>"
    exit 1
fi

# My Network
MYNETWORK=$1
set `echo "${MYNETWORK}" | sed 's/\./ /g'`
REVZONE=$3.$2.$1.in-addr.arpa
MYNET=$1.$2.$3

ZONECONFIG="/etc/bind/named.conf.default-zones"

if [ `sed -n '/^zone "'${REVZONE}'"/p' /etc/bind/named.conf.default-zones|wc -l` -eq 1 ];then
    ##Remove entries from dns configuration file
    sed -i -e '/^zone "'${REVZONE}'"/,/^};/d' ${ZONECONFIG}
    sed -i '$d' ${ZONECONFIG}

    echo "[*] Removed zone entries from bind configuration"
else
    echo "[ERROR] ${REVZONE} not present in bind configuration"
    exit 1
fi

#Remove zone file if it exists
if [ -f /etc/bind/db.${MYNET} ];then
    rm -f /etc/bind/db.${MYNET}
    echo "[*] Removed zone db.${MYNET} file"
fi
