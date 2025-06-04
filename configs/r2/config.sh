#!/bin/bash

# Habilitar FRR
echo "Comenzando FRR..."
/etc/init.d/frr start

# Habilitar reenvío de paquetes en Linux
sysctl -w net.ipv4.ip_forward=1

# Instalando dependencias (Alpine Linux)
apk update
apk add tcpdump

# Crear el bridge para manejar las VLANs
ip link add name BRIDGE type bridge
ip link set dev BRIDGE up

# Habilitar el filtrado de VLANs en el bridge
ip link set dev BRIDGE type bridge vlan_filtering 1

# Configuracion de ip en la interface que va a pasar la VxLAN
#ip addr add 10.0.0.1/24 dev eth5
#ip link set eth5 up

# Creacion de VxLAN en la int eth5 del r2.
ip link add vxlan100 type vxlan id 100 dev eth5 remote 10.0.0.2 local 10.0.0.1 dstport 4789 nolearning
ip link set vxlan100 up

# Agregar las interfaces al bridge
#ip link set dev eth5 master BRIDGE
ip link set dev eth1 master BRIDGE
ip link set dev vxlan100 master BRIDGE

# Crear interfaces VLAN
ip link add link BRIDGE name Gerencia type vlan id 10
ip link add link BRIDGE name Empleados type vlan id 20
ip link add link BRIDGE name Servidores type vlan id 50
ip link set dev Gerencia up
ip link set dev Empleados up
ip link set dev Servidores up

# Agregar VLANs al bridge con tagged
bridge vlan add dev BRIDGE vid 10 self  #el tráfico de la VLAN 10 pase a través del puente.
bridge vlan add dev BRIDGE vid 20 self # Tienen que estar presentes las VLAN en el bridge para luego sacarlas por la subint.
bridge vlan add dev BRIDGE vid 50 self

# Asignar puertos tagged a sus VLANs
bridge vlan add dev vxlan100 vid 10 tagged #por vxlan100 tienen que salir todas las vlans tagged que se conectan a r3.
bridge vlan add dev vxlan100 vid 20 tagged
bridge vlan add dev vxlan100 vid 50 tagged
bridge vlan add dev eth5 vid 10 tagged
bridge vlan add dev eth5 vid 20 tagged
bridge vlan add dev eth5 vid 50 tagged
bridge vlan add dev eth1 vid 10 tagged
bridge vlan add dev eth1 vid 20 tagged
bridge vlan add dev eth1 vid 50 tagged

# Mostrar VLANs 
echo "VLANs asociadas a cada interfaz:"
bridge vlan show

# Mostrar Interfaces asignadas al bridge.
echo "Interfaces asignadas al bridge:"
brctl show

# DNAT: permitir que desde afuera se acceda al web server
#iptables -t nat -A PREROUTING -i eth5 -p tcp --dport 80 -j DNAT --to-destination 192.168.50.50:80

# MASQUERADE salen con la ip de eth5 a internet 
# iptables -t nat -A POSTROUTING -o eth5 -j MASQUERADE