#!/usr/bin/env bash

# -------------------------------------------------------
# Args
# -------------------------------------------------------

TUN_NAME="he-ipv6"

# --- LAN A --------------------
PCA1_ETH0="192.168.10.1"
PCA2_ETH0="192.168.10.2"
PCA3_ETH0="192.168.10.3"

# --- LAN B --------------------
PCA1_ETH0="192.168.20.1"
PCA2_ETH0="192.168.20.2"
PCA3_ETH0="192.168.20.3"

# --- LAN C --------------------
PCA3_ETH0="192.168.7.10"
PCB3_ETH0="192.168.7.20"

# -------------------------------------------------------
# Functions
# -------------------------------------------------------

function PCA1() {
    # Configuración máquina
    # desactivar el forwarding de pkgs ipv6
    service network restart
}

function PCA2() {
    # Configuración máquina
    # desactivar el forwarding de pkgs ipv6
    service network restart
}

function PCB1() {
    # Configuración máquina
    # desactivar el forwarding de pkgs ipv6
    service network restart
}

function PCB2() {
    # Configuración máquina
    # desactivar el forwarding de pkgs ipv6
    service network restart
}

function PCA3() {
    # Configuración Tunel
    ip tunnel add he-ipv6 mode sit remote $PCB3_ETH0 local $PCA3_ETH0 ttl 255
    ip link set he-ipv6 up
    ip addr add 2000:C::A3/64 dev he-ipv6
    ip route add ::/0 dev he-ipv6

    # Configuración dirección
    ip -6 addr add 2000:A::A3/64 dev eth0
    ip route add 2000:A::/64 dev eth0

    # configuración router
    # configurar fichero /etc/radvd.conf
    # habilitar pkg forwarding ipv6
}

function PCB3() {
    # Configuración Tunel
    ip tunnel add he-ipv6 mode sit remote $PCA3_ETH0 local $PCB3_ETH0 ttl 255
    ip link set he-ipv6 up
    ip addr add 2000:C::B3/64 dev he-ipv6
    ip route add ::/0 dev he-ipv6

    # Configuración dirección
    ip -6 addr add 2000:B::A3/64 dev eth0
    ip route add 2000:B::/64 dev eth0

    # configuración router
    # configurar fichero /etc/radvd.conf
    # configurar fichero /etc/sysctl.conf
    # habilitar pkg forwarding ipv6
}

# -------------------------------------------------------
# Main
# -------------------------------------------------------

# ejecuta la funcion hello_world
hello_world $NAME