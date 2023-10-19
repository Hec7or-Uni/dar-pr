#!/bin/sh

# IPTABLES PCA2

#flush
iptables -f

iptables -t nat -A POSTROUTING -o eth0 -p tcp --dport 22 -j SNAT --to 192.168.20.1:2016
iptables -t nat -A POSTROUTING -o eth0 -p tcp --dport 22 -j SNAT --to 192.168.20.2:2016
