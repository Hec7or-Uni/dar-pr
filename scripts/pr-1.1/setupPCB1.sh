#!/bin/sh

# SETUP PCB1

#Direccionamiento permanente
tee /etc/sysconfig/network-scripts/ifcfg-eth0 > /dev/null << EOF
DEVICE=eth0
IPADDR=192.168.20.1
NETMASK=255.255.255.0
NETWORK=192.168.20.0
BROADCAST=192.168.20.255
ONBOOT=yes
BOOTPROTO=none
USERCTL=no
EOF

ifdown eth0
ifup eth0

ip route add 0.0.0.0/0 via 192.168.20.3
