#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y iproute2 iputils-ping net-tools tcpdump curl dnsutils python3
ip addr add 192.168.20.20/24 dev eth1
ip route del default
ip route add default via 192.168.20.1
echo "nameserver 192.168.50.11" > /etc/resolv.conf # Para que use de DNS el 50.11 que es donde esta el DNS_primario.
echo "nameserver 192.168.50.12" >> /etc/resolv.conf 