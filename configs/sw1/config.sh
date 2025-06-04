#!/bin/bash
echo "Configurando SW1 con VLANs en FRR..."

# Habilitar reenvío de paquetes en Linux
sysctl -w net.ipv4.ip_forward=1

# Instalando dependencias (Alpine Linux)
apk update
apk add tcpdump

# Crear el bridge para manejar las VLANs
ip link add name TRUNK type bridge
ip link set dev TRUNK up

# Habilitar el filtrado de VLANs en el bridge
ip link set dev TRUNK type bridge vlan_filtering 1

# Agregar las interfaces al bridge
ip link set dev eth5 master TRUNK # Asociamos int al bridge TRUNK
ip link set dev eth4 master TRUNK
ip link set dev eth6 master TRUNK
ip link set dev eth1 master TRUNK
ip link set dev eth2 master TRUNK
ip link set dev eth3 master TRUNK

# Configurar VLANs sobre el TRUNK
ip link add link TRUNK name Gerencia type vlan id 10 # Creamos subint tipo VLAN en el brigde TRUNK que sale tagged 10.
ip link add link TRUNK name Empleados type vlan id 20
ip link add link TRUNK name Servidores type vlan id 50
ip link set dev Gerencia up
ip link set dev Empleados up
ip link set dev Servidores up

# Agregar VLANs al bridge con tagged
bridge vlan add dev TRUNK vid 10 self  #el tráfico de la VLAN 10 pase a través del puente.
bridge vlan add dev TRUNK vid 20 self # Tienen que estar presentes las VLAN en el bridge para luego sacarlas por la subint.
bridge vlan add dev TRUNK vid 50 self

# Asignar puertos tagged a sus VLANs
bridge vlan add dev eth5 vid 10 tagged #por eth5 tienen que salir todas las vlans tagged que se conectan a r2.
bridge vlan add dev eth5 vid 20 tagged
bridge vlan add dev eth5 vid 50 tagged

# Asignar puertos de acceso (untagged) a sus VLANs
bridge vlan add dev eth4 vid 10 pvid untagged  # PC1 - Gerencia ; configura el puerto eth4 como un puerto de acceso para la VLAN 10.
bridge vlan add dev eth6 vid 20 pvid untagged  # PC2 - Empleados;
bridge vlan add dev eth1 vid 50 pvid untagged  # DNS Primario
bridge vlan add dev eth2 vid 50 pvid untagged  # DNS Secundario
bridge vlan add dev eth3 vid 50 pvid untagged  # Web Server

# Mostrar VLANs 
echo "VLANs asociadas a cada interfaz:"
bridge vlan show

# Mostrar Interfaces asignadas al bridge.
echo "Interfaces asignadas al bridge:"
brctl show

# Bloquear/Permitir tráfico entre VLANS.
# por defecto de iptables esta en ACCEPT para reglas paquetes que no matchean ninguna rule.
# osea que debo dropear lo que no quiero que se comunique.

# Bloquear tráfico entre VLAN 10 (Gerencia) y VLAN 20 (Empleados)
iptables -A FORWARD -s 192.168.10.0/24 -d 192.168.20.0/24 -j DROP
iptables -A FORWARD -s 192.168.20.0/24 -d 192.168.10.0/24 -j DROP

#Seria mas seguro dropear todo y solo aceptar lo que si, entonces:

#Cambio la politica a que por defecto en la chain forward DROP
#iptables -P FORWARD DROP

# Permitir que ambas VLANs accedan a la VLAN50 (servidores)
#iptables -A FORWARD -s 192.168.10.0/24 -d 192.168.50.0/24 -j ACCEPT
#iptables -A FORWARD -s 192.168.20.0/24 -d 192.168.50.0/24 -j ACCEPT
#iptables -A FORWARD -s 192.168.50.0/24 -d 192.168.10.0/24 -j ACCEPT
#iptables -A FORWARD -s 192.168.50.0/24 -d 192.168.20.0/24 -j ACCEPT




