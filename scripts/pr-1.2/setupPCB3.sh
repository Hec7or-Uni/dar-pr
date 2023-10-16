#!/bin/sh

# SETUP PCB3

ip -4 addr add 192.168.20.3/24 broadcast 192.168.10.255 dev eth0

ip -4 addr add 192.168.7.20/24 dev eth1

sysctl -w net.ipv4.ip_forward=1

ip route add 192.168.10.0/24 via 192.168.7.10

service zebra stop
service ripd stop

ip -4 link set eth0 mtu 1500
ip -4 link set eth1 mtu 1500