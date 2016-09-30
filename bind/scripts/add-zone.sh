#!/bin/bash

#Setting Variables
## Nameservers
NAMESERVER="ns.nnxx"

## Apache and FTP server
WEB_IP="10.27.0.222"

##Mail server
MAIL_IP="10.27.0.224"

## DB Server
MYSQL_IP="10.27.0.223"

############################################################

if [ $# -ne 1 ];then
    echo "Usage: add-zone.sh <My Domain>"
    exit 1
fi

## Domain name
MYDOMAIN=$1
ZONECONFIG="/etc/bind/named.conf.default-zones"

if [ `sed -n '/^zone "'${MYDOMAIN}'."/p' ${ZONECONFIG}|wc -l` -eq 1 ];then
    echo "[ERROR] Entry for ${MYDOMAIN} already exists"
    exit 1
fi

## Create zone file
cat > /etc/bind/zones/${MYDOMAIN} << EOF \
;
; BIND data file for domain "${MYDOMAIN}"
;
$TTL    604800
@       IN      SOA     ns.${MYDOMAIN}. root.${MYDOMAIN}. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@			IN	NS	${NAMESERVER}.
${MYDOMAIN}.	IN	A	${WEB_IP}
www.${MYDOMAIN}.	IN	CNAME	${MYDOMAIN}.
${MYDOMAIN}.	IN	MX	10	mail.${MYDOMAIN}.
mail.${MYDOMAIN}.	IN	A	${MAIL_IP}
smtp.${MYDOMAIN}.	IN	A	${MAIL_IP}
pop.${MYDOMAIN}.	IN	A	${MAIL_IP}
imap.${MYDOMAIN}.	IN	A	${MAIL_IP}
mysql.${MYDOMAIN}.	IN	A	${MYSQL_IP}
ftp.${MYDOMAIN}.	IN	A	${WEB_IP}
EOF

echo "[*] Created zone file for ${MYDOMAIN}"
## Create zone entry in bind configuration
cat >> ${ZONECONFIG} << EOF

zone "${MYDOMAIN}." {
    type master;
    file "/etc/bind/zones/${MYDOMAIN}";
};
EOF

echo "[*] Added zone entry for ${MYDOMAIN} in bind configuration"
