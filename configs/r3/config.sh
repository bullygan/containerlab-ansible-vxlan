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
ip link add name BRIDGE2 type bridge
ip link set dev BRIDGE2 up

# Habilitar el filtrado de VLANs en el bridge
ip link set dev BRIDGE2 type bridge vlan_filtering 1

# Configuracion de ip en la interface que va a pasar la VxLAN
#ip addr add 10.0.0.2/24 dev eth5
#ip link set eth5 up

# Creacion de VxLAN en la int eth5 del r3.
ip link add vxlan100 type vxlan id 100 dev eth5 remote 10.0.0.1 local 10.0.0.2 dstport 4789 nolearning 
ip link set vxlan100 up

# Agregar las interfaces al bridge
#ip link set dev eth5 master BRIDGE2
ip link set dev eth2 master BRIDGE2
ip link set dev vxlan100 master BRIDGE2

# Crear interfaces VLAN
ip link add link BRIDGE2 name Gerencia type vlan id 10
ip link add link BRIDGE2 name Empleados type vlan id 20
ip link add link BRIDGE2 name Servidores type vlan id 50
ip link set dev Gerencia up
ip link set dev Empleados up
ip link set dev Servidores up

# Agregar VLANs al bridge con tagged
bridge vlan add dev BRIDGE2 vid 10 self # el tráfico de la VLAN 10 pase a través del puente.
bridge vlan add dev BRIDGE2 vid 20 self # Tienen que estar presentes las VLAN en el bridge para luego sacarlas por la subint.
bridge vlan add dev BRIDGE2 vid 50 self

# Asignar puertos tagged a sus VLANs
bridge vlan add dev vxlan100 vid 10 tagged #por vxlan100 tienen que salir todas las vlans tagged que se conectan a r2.
bridge vlan add dev vxlan100 vid 20 tagged
bridge vlan add dev vxlan100 vid 50 tagged
bridge vlan add dev eth5 vid 10 tagged
bridge vlan add dev eth5 vid 20 tagged
bridge vlan add dev eth5 vid 50 tagged

# Asignar puertos de acceso (untagged) a sus VLANs
bridge vlan add dev eth2 vid 20 pvid untagged

# Mostrar VLANs 
echo "VLANs asociadas a cada interfaz:"
bridge vlan show

# Mostrar Interfaces asignadas al bridge.
echo "Interfaces asignadas al bridge:"
brctl show

