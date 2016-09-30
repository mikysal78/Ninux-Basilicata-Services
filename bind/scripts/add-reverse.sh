#!/bin/bash

#Setting Variables
## Nameservers
NAMESERVER="ns.nnxx"

# NY DOMAIN
MYDOMAIN="pippo.loc"

############################################################

if [ $# -ne 1 ];then
    echo "Usage: add-reverse.sh <My Network> "
    exit 1
fi

## Domain name
MYNETWORK=$1
set `echo "${MYNETWORK}" | sed 's/\./ /g'`
REVZONE=$3.$2.$1.in-addr.arpa
MYNET=$1.$2.$3

ZONECONFIG="/etc/bind/named.conf.default-zones"

if [ `sed -n '/^zone "'${MYNET}'."/p' ${ZONECONFIG}|wc -l` -eq 1 ];then
    echo "[ERROR] Entry for ${MYNET} already exists"
    exit 1
fi

## Create reverse zone file

cat > /etc/bind/db.$1.$2.$3 << EOF \

;
; BIND reverse data file for network ${MYNET}.0/24
;
$TTL    604800
@       IN      SOA     ${MYDOMAIN}. root.${MYDOMAIN}. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ${NAMESERVER}.
5.0     IN      PTR      ${NAMESERVER}.
EOF

echo "[*] Created zone file for ${MYNET}"
## Create zone entry in bind configuration
cat >> ${ZONECONFIG} << EOF

zone "${REVZONE}" {
    type master;
    file "/etc/bind/db.$1.$2.$3";
};
EOF

echo "[*] Added zone entry for ${MYNET} in bind configuration"
