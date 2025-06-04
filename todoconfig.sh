#!/bin/sh
echo "------------------------------------------------------------"
echo "Comenzando con la configuración del dns_primario"
echo "------------------------------------------------------------"

docker exec -it clab-lab3-dns_primario ./config.sh

echo "------------------------------------------------------------"
echo "Fin de la configuración del dns_primario"
echo "------------------------------------------------------------"

echo "------------------------------------------------------------"
echo "Comenzando con la configuración del dns_secundario"
echo "------------------------------------------------------------"

docker exec -it clab-lab3-dns_secundario ./config.sh

echo "------------------------------------------------------------"
echo "Fin de la configuración del dns_secundario"
echo "------------------------------------------------------------"

echo "------------------------------------------------------------"
echo "Comenzando con la configuración del PC1"
echo "------------------------------------------------------------"

docker exec -it clab-lab3-PC1 ./config.sh

echo "------------------------------------------------------------"
echo "Fin de la configuración del PC1"
echo "------------------------------------------------------------"

echo "------------------------------------------------------------"
echo "Comenzando con la configuración del PC2"
echo "------------------------------------------------------------"

docker exec -it clab-lab3-PC2 ./config.sh

echo "------------------------------------------------------------"
echo "Fin de la configuración del PC2"
echo "------------------------------------------------------------"

echo "------------------------------------------------------------"
echo "Comenzando con la configuración del PC3"
echo "------------------------------------------------------------"

docker exec -it clab-lab3-PC3 ./config.sh

echo "------------------------------------------------------------"
echo "Fin de la configuración del PC3"
echo "------------------------------------------------------------"

echo "------------------------------------------------------------"
echo "Comenzando con la configuración del r2"
echo "------------------------------------------------------------"

docker exec -it clab-lab3-r2 ./config.sh

echo "------------------------------------------------------------"
echo "Fin de la configuración del r2"
echo "------------------------------------------------------------"

echo "------------------------------------------------------------"
echo "Comenzando con la configuración del r3"
echo "------------------------------------------------------------"

docker exec -it clab-lab3-r3 ./config.sh

echo "------------------------------------------------------------"
echo "Fin de la configuración del r3"
echo "------------------------------------------------------------"

echo "------------------------------------------------------------"
echo "Comenzando con la configuración del sw1"
echo "------------------------------------------------------------"

docker exec -it clab-lab3-sw1 ./config.sh

echo "------------------------------------------------------------"
echo "Fin de la configuración del sw1"
echo "------------------------------------------------------------"

echo "------------------------------------------------------------"
echo "Comenzando con la configuración del web_server"
echo "------------------------------------------------------------"

docker exec -it clab-lab3-web_server ./config.sh

echo "------------------------------------------------------------"
echo "Fin de la configuración del web_server"
echo "------------------------------------------------------------"

#socat TCP-LISTEN:9090,fork TCP:172.20.20.5:80
# El socat Es la herramienta que permite redirigir conexiones entre sockets
# Le dice que escuche en el 9090 (http://localhost:9090)
# y lo rediriga a ese ip en tcp tmb que es el container que tiene el web server.
# Esto lo hago en wsl2 pero los puertos que abro ahi (9090) se traducen en windsows
#directamente en localhost:9090.