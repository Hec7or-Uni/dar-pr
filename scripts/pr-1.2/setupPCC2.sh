#!/bin/sh

# SETUP PCC2

sudo ip -4 addr add 192.168.7.2/24 broadcast 192.168.7.255 dev eth0

sudo ip route add 192.168.10.0/24 via 192.168.7.10
sudo ip route add 192.168.20.0/24 via 192.168.7.20
sudo ip route add 0.0.0.0/0 via 192.168.7.3