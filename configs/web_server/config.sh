#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
echo "------------------------------------------------------------"
echo "Actualizando apt-get update"
echo "------------------------------------------------------------"

apt-get update

echo "------------------------------------------------------------"
echo "FIN apt-get update"
echo "------------------------------------------------------------"

echo "------------------------------------------------------------"
echo "Instalando dependencias"
echo "------------------------------------------------------------"

apt-get install -y --no-install-recommends apt-utils
apt-get install -y apache2
apt-get install -y iproute2 iputils-ping net-tools tcpdump python3

echo "------------------------------------------------------------"
echo " FIN Instalando dependencias"
echo "------------------------------------------------------------"

echo "------------------------------------------------------------"
echo " Definiendo IPs y rutas"
echo "------------------------------------------------------------"

ip addr add 192.168.50.50/24 dev eth1
ip route del default
ip route add default via 192.168.50.1

echo "------------------------------------------------------------"
echo " FIN Definiendo IPs y rutas"
echo "------------------------------------------------------------"

echo "------------------------------------------------------------"
echo " Configuracion Apache 2"
echo "------------------------------------------------------------"

/etc/init.d/apache2 status
/etc/init.d/apache2 start
/etc/init.d/apache2 status
cd /etc/apache2/sites-available/
a2dissite 000-default.conf
# Para 1 sitio (Comentar la config que no vayamos a usar de 1 sitio o 2 sitios) ESTA
#a2ensite labredes.conf #Habilita esa conf de ese site en mi web server. pasa de sites avai a enab.
# Para 2 sitios  O ESTA
a2ensite sitio1.conf
a2ensite sitio2.conf
#Reload Service
service apache2 reload

echo "------------------------------------------------------------"
echo " FIN Configuracion Apache 2"
echo "------------------------------------------------------------"