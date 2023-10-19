#!/bin/sh

# IPTABLES PCA1

#flush
iptables -F

iptables -t nat -A POSTROUTING -o eth1 -j SNAT --to 192.168.7.10

iptables -t nat -A POSTROUTING -o eth1 -p tcp --dport 22 -j SNAT --to 192.168.10.1:2016
iptables -t nat -A POSTROUTING -o eth1 -p tcp --dport 22 -j SNAT --to 192.168.10.2:2016
