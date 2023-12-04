
## LAN A

### C3725-[1,2]

```bash
vlan database
vlan 2
vlan 3
exit
```

```bash
configure terminal
interface FastEthernet 2/0
switchport mode access
switchport access vlan 2

interface FastEthernet 2/1
switchport mode access
switchport access vlan 3
exit
```

```bash
write
```

---

```bash
configure terminal
interface FastEthernet 2/15
switchport mode trunk
vlan-range dot1q 2 3
exit
```

```bash
write
```

---

```bash
c3725-1#show vlan-switch

VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Fa2/2, Fa2/3, Fa2/4, Fa2/5
                                                Fa2/6, Fa2/7, Fa2/8, Fa2/9
                                                Fa2/10, Fa2/11, Fa2/12, Fa2/13
                                                Fa2/14, Fa2/15
2    VLAN0002                         active    Fa2/0
3    VLAN0003                         active    Fa2/1
1002 fddi-default                     active
1003 token-ring-default               active
1004 fddinet-default                  active
1005 trnet-default                    active

VLAN Type  SAID       MTU   Parent RingNo BridgeNo Stp  BrdgMode Trans1 Trans2
---- ----- ---------- ----- ------ ------ -------- ---- -------- ------ ------
1    enet  100001     1500  -      -      -        -    -        1002   1003
2    enet  100002     1500  -      -      -        -    -        0      0
3    enet  100003     1500  -      -      -        -    -        0      0
1002 fddi  101002     1500  -      -      -        -    -        1      1003
1003 tr    101003     1500  1005   0      -        -    srb      1      1002
1004 fdnet 101004     1500  -      -      1        ibm  -        0      0
1005 trnet 101005     1500  -      -      1        ibm  -        0      0
```

```bash
c3725-1#show vlan-range
IDB-less VLAN Ranges on FastEthernet2/15 (1 ranges)
2-3                                     (range)
```

### Router -> C3725-2

```bash
c3725-2#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
FastEthernet0/0            unassigned      YES unset  administratively down down
FastEthernet0/1            unassigned      YES unset  administratively down down
Serial1/0                  unassigned      YES unset  administratively down down
Serial1/1                  unassigned      YES unset  administratively down down
Serial1/2                  unassigned      YES unset  administratively down down
Serial1/3                  unassigned      YES unset  administratively down down
FastEthernet2/0            unassigned      YES unset  up                    up
FastEthernet2/1            unassigned      YES unset  up                    up
FastEthernet2/2            unassigned      YES unset  up                    down
FastEthernet2/3            unassigned      YES unset  up                    down
FastEthernet2/4            unassigned      YES unset  up                    down
FastEthernet2/5            unassigned      YES unset  up                    down
FastEthernet2/6            unassigned      YES unset  up                    down
FastEthernet2/7            unassigned      YES unset  up                    down
FastEthernet2/8            unassigned      YES unset  up                    down
FastEthernet2/9            unassigned      YES unset  up                    down
FastEthernet2/10           unassigned      YES unset  up                    down
FastEthernet2/11           unassigned      YES unset  up                    down
FastEthernet2/12           unassigned      YES unset  up                    down
FastEthernet2/13           unassigned      YES unset  up                    down
FastEthernet2/14           unassigned      YES unset  up                    down
FastEthernet2/15           unassigned      YES unset  up                    down
Vlan1                      unassigned      YES unset  up                    down
```

```bash
configure terminal
interface vlan 2
ip address 192.168.2.254 255.255.255.0
exit
```

```bash
interface vlan 3
ip address 192.168.3.254 255.255.255.0
exit
```

```bash
ip routing
end
write
```

```bash
c3725-2#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
FastEthernet0/0            unassigned      YES unset  administratively down down
FastEthernet0/1            unassigned      YES unset  administratively down down
Serial1/0                  unassigned      YES unset  administratively down down
Serial1/1                  unassigned      YES unset  administratively down down
Serial1/2                  unassigned      YES unset  administratively down down
Serial1/3                  unassigned      YES unset  administratively down down
FastEthernet2/0            unassigned      YES unset  up                    up
FastEthernet2/1            unassigned      YES unset  up                    up
FastEthernet2/2            unassigned      YES unset  up                    down
FastEthernet2/3            unassigned      YES unset  up                    down
FastEthernet2/4            unassigned      YES unset  up                    down
FastEthernet2/5            unassigned      YES unset  up                    down
FastEthernet2/6            unassigned      YES unset  up                    down
FastEthernet2/7            unassigned      YES unset  up                    down
FastEthernet2/8            unassigned      YES unset  up                    down
FastEthernet2/9            unassigned      YES unset  up                    down
FastEthernet2/10           unassigned      YES unset  up                    down
FastEthernet2/11           unassigned      YES unset  up                    down
FastEthernet2/12           unassigned      YES unset  up                    down
FastEthernet2/13           unassigned      YES unset  up                    down
FastEthernet2/14           unassigned      YES unset  up                    down
FastEthernet2/15           unassigned      YES unset  up                    down
Vlan1                      unassigned      YES unset  up                    down
Vlan2                      192.168.2.254   YES manual up                    up
Vlan3                      192.168.3.254   YES manual up                    up
```

### PC1

```bash
ip 192.168.2.1 netmask 255.255.255.0 192.168.2.254
show ip
save
```

### PC2

```bash
ip 192.168.3.2 netmask 255.255.255.0 192.168.3.254
show ip
save
```

---

## LAN B

### PC3

```bash
ip 192.168.2.3 netmask 255.255.255.0 192.168.2.254
show ip
save
```

### PC4

```bash
ip 192.168.3.4 netmask 255.255.255.0 192.168.3.254
show ip
save
```