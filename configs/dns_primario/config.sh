#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends apt-utils
apt-get install -y bind9 -o Dpkg::Options::="--force-confold"
apt-get install -y iproute2 iputils-ping net-tools tcpdump dnsutils python3
ip addr add 192.168.50.11/24 dev eth1
ip route del default
ip route add default via 192.168.50.1
/etc/init.d/named status
/etc/init.d/named start
/etc/init.d/named status

echo "------------------------------------------------------------"
echo "Chequeando archivo named.conf"
echo "------------------------------------------------------------"
named-checkzone labredes.com /etc/bind/db.directa
echo "------------------------------------------------------------"
echo "FIN Chequeo archivo named.conf"
echo "------------------------------------------------------------"


#Comandos para probar transferencia de zona
#dig @192.168.50.11 labredes.com AXFR # El AXFR es la opcion para ver la zone transfer.
#dig @192.168.50.12 labredes.com AXFR