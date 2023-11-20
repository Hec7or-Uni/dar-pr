#!/usr/bin/env bash

SELECTED_MACHINE=$1
# -------------------------------------------------------
# Args
# -------------------------------------------------------

TUN_NAME="he-ipv6"

# --- LAN A --------------------
PCA1_ETH0="192.168.10.1"
PCA2_ETH0="192.168.10.2"
PCA3_ETH0="192.168.10.3"

# --- LAN B --------------------
PCB1_ETH0="192.168.20.1"
PCB2_ETH0="192.168.20.2"
PCB3_ETH0="192.168.20.3"

# --- LAN C --------------------
PCA3_ETH1="192.168.7.10"
PCB3_ETH1="192.168.7.20"

# -------------------------------------------------------
# Functions
# -------------------------------------------------------

function IPV6_OFF() {
    sed -i 's/^net.ipv6.conf.all.forwarding.*/net.ipv6.conf.all.forwarding=0/' /etc/sysctl.conf
    sysctl -p
}

function IPV6_ON() {
    sed -i 's/^net.ipv6.conf.all.forwarding.*/net.ipv6.conf.all.forwarding=1/' /etc/sysctl.conf
    sysctl -p
}

function CONF_RADVD() {
    tee /etc/radvd.conf << EOF
interface eth0
{
    AdvSendAdvert on;
    MinRtrAdvInterval 30;
    MaxRtrAdvInterval 100;
    prefix 2001:db8:1:0::/64
    {
            AdvOnLink on;
            AdvAutonomous on;
            AdvRouterAddr off;
    };

};
EOF
}

function PCA1() {
    # Configuración máquina
    ip -6 addr add 2000:A::A1/64 dev eth0
    ip route add 2000:A::A3/64 dev eth0
    #service network restart
    # desactivar el forwarding de pkgs ipv6
    IPV6_OFF
}

function PCA2() {
    # Configuración máquina
    ip -6 addr add 2000:A::A2/64 dev eth0
    ip route add 2000:A::A3/64 dev eth0
    #service network restart
    # desactivar el forwarding de pkgs ipv6
    IPV6_OFF
}

function PCB1() {
    # Configuración máquina
    ip -6 addr add 2000:B::B1/64 dev eth0
    ip route add 2000:B::B3/64 dev eth0
    #service network restart
    # desactivar el forwarding de pkgs ipv6
    IPV6_OFF
}

function PCB2() {
    # Configuración máquina
    ip -6 addr add 2000:B::B2/64 dev eth0
    ip route add 2000:B::B3/64 dev eth0
    #service network restart
    # desactivar el forwarding de pkgs ipv6
    IPV6_OFF
}

function PCA3() {
    ip -4 addr add ${PCA3_ETH1}/24 broadcast 192.168.7.255 dev eth1

    # Configuración Tunel
    ip tunnel add he-ipv6 mode sit remote $PCB3_ETH1 local $PCA3_ETH1 ttl 255
    ip link set he-ipv6 up
    ip addr add 2000:C::A3/64 dev he-ipv6
    ip route add ::/0 dev he-ipv6

    # Configuración dirección
    ip -6 addr add 2000:A::A3/64 dev eth0
    ip route add 2000:A::/64 dev eth0
    #service network restart
    # configuración router
    # configurar fichero /etc/radvd.conf
    # habilitar pkg forwarding ipv6
    CONF_RADVD
    IPV6_ON
}

function PCB3() {
    ip -4 addr add ${PCB3_ETH1}/24 broadcast 192.168.7.255 dev eth1

    # Configuración Tunel
    ip tunnel add he-ipv6 mode sit remote $PCA3_ETH1 local $PCB3_ETH1 ttl 255
    ip link set he-ipv6 up
    ip addr add 2000:C::B3/64 dev he-ipv6
    ip route add ::/0 dev he-ipv6

    # Configuración dirección
    ip -6 addr add 2000:B::B3/64 dev eth0
    ip route add 2000:B::/64 dev eth0
    #service network restart

    # configuración router
    # configurar fichero /etc/radvd.conf
    # configurar fichero /etc/sysctl.conf
    # habilitar pkg forwarding ipv6
    CONF_RADVD
    IPV6_ON
}

# -------------------------------------------------------
# Main
# -------------------------------------------------------

if [ $SELECTED_MACHINE = "PCA1" ]; then
    PCA1;
elif [ $SELECTED_MACHINE = "PCA2" ]; then
    PCA2;
elif [ $SELECTED_MACHINE = "PCA3" ]; then
    PCA3;
elif [ $SELECTED_MACHINE = "PCB1" ]; then
    PCB1;
elif [ $SELECTED_MACHINE = "PCB2" ]; then
    PCB2;
elif [ $SELECTED_MACHINE = "PCB3" ]; then
    PCB3;
elif [ $SELECTED_MACHINE = "PCC1" ]; then
    PCC1;
elif [ $SELECTED_MACHINE = "PCC2" ]; then
    PCC2;
else
    echo "Elige una maquina valida";
fi
