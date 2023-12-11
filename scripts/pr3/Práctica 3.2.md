## 2.2 Configuración de OvS como Learning Switch

Comprobamos la configuración actual:

```shell
ovs-vsctl show
```

Eliminar **cada uno de los bridge** para partir de una configuración limpia:

```shell
ovs-vsctl del-br br0
...
ovs-vsctl del-br brN
```

Creamos el bridge br0:

```shell
ovs-vsctl add-br br0
```

Añadimos diferentes puertos al bridge, pero **NO eth0**:

```shell
ovs-vsctl add-port br0 eth1
ovs-vsctl add-port br0 eth2
ovs-vsctl add-port br0 eth3
...
```

---
*Guardar los cambios que hagamos en `/bin/boot.sh` para que las máquinas conserven la configuración aunque las apaguemos.* 

*Comprobar configuración:*
```
ovs-vsctl list interface  ->  lista puertos
ovs-vsctl list bridge     ->  lista switches
```

*Comprobar funcionamiento con ping de PC1 a PC2...*

---
### Configuración de STP

Activamos STP **en ambos OvS :**

```shell
ovs-vsctl set br br0 stp_enable=true
```

Damos pesos a los enlaces:

```shell
ovs-vsctl set port eth1 other_config={stp-path-cost=1000}
ovs-vsctl set port eth2 other_config={stp-path-cost=1000}
```

#### DAR2324_Pr3_2_g1_P1
- Reescribir los comandos exactos que hemos introducido en cada OvS
- Con las tablas ARP vacías, hacer `ping` entre PC1 y PC4 y capturar **entre switchs**. Comprobar paquetes STP, ARP e ICMP y valores de las @IP Y @MAC.

```shell
#!/bin/sh
## Configuración de OvS-gestion-1

```

```shell
#!/bin/sh
## Configuración de OvS-gestion-2

```

```shell
# PC1
ip 192.168.10.1 netmask 255.255.255.0
show ip
save
```

---
### Bridge en modo seguro

En modo seguro, si no hay conexión al controlador, no se configura como "learning switch", y hay que definir los flujos manualmente.

```shell
ovs-vsctl set br br0 stp_enable=false
ovs-vsctl set-fail-mode br0 secure
```

## 2.3 Configuración de flujos en OvS para trabajar con VLAN

A partir del escenario anterior configurar el P13 de la práctica 3.1.

*Configurar los OvS como learning switch y capturar el tráfico para ver los flujos.*

### Configurar OvS 1

```shell
# Borrar bridges
ovs-vsctl del-br br0
ovs-vsctl del-br br1
ovs-vsctl del-br br2
ovs-vsctl del-br br3

# Crear bridge limpio y asociar puertos (OJO VLANs: 100, 200 -> 2 y 3???)
ovs-vsctl add-br br0
ovs-vsctl add-port br0 eth1
ovs-vsctl add-port br0 eth2
ovs-vsctl add-port br0 eth15 trunk=100,200 # Enlace entre switchs (trunk -> puede ser tagged)

# Primero obviar esto?? -> deshabilitar STP
ovs-vsctl set br br0 stp_enable=false
ovs-vsctl set-fail-mode br0 secure
ovs-vsctl -- --columns=name,ofport list Interface # Check

# Añadir flujos al switch
ovs-ofctl add-flow br0 in_port=1,actions=mod_vlan_vid=100,output:3
ovs-ofctl add-flow br0 in_port=2,actions=mod_vlan_vid=200,output:3
ovs-ofctl add-flow br0 in_port=3,dl_vlan=100,actions=strip_vlan,output:1 # dl_vlan -> hace que el puerto sea tagged
ovs-ofctl add-flow br0 in_port=3,dl_vlan=200,actions=strip_vlan,output:2

ovs-ofctl dump-flows br0 # Check
```

### Configurar OvS 2 (router)

```shell
# Borrar bridges
ovs-vsctl del-br br0
ovs-vsctl del-br br1
ovs-vsctl del-br br2
ovs-vsctl del-br br3

# Crear bridge limpio, asociar IP gateway de cada VLAN y asociar puertos (OJO VLANs: 100, 200 -> 2 y 3???)
ovs-vsctl add-br br0
ovs-vsctl add-port br0 gateway1 -- set interface gateway1 type=internal
ovs-vsctl add-port br0 gateway2 -- set interface gateway2 type=internal

ifconfig gateway1 192.168.100.254 netmask 255.255.255.0 up
ifconfig gateway2 192.168.200.254 netmask 255.255.255.0 up

sysctl -w net.ipv4.ip_forward=1

ovs-vsctl add-port br0 eth3
ovs-vsctl add-port br0 eth4
ovs-vsctl add-port br0 eth15 trunk=100,200


# Primero obviar esto?? -> deshabilitar STP
ovs-vsctl set br br0 stp_enable=false
ovs-vsctl set-fail-mode br0 secure
ovs-vsctl -- --columns=name,ofport list Interface # Check

# Añadir flujos al switch
ovs-ofctl add-flow br0 in_port=1,dl_type=0x0806,nw_dst=192.168.100.3,actions=output:3
ovs-ofctl add-flow br0 in_port=1,dl_type=0x0806,actions=mod_vlan_vid=100,output:5
ovs-ofctl add-flow br0 in_port=2,dl_type=0x0806,nw_dst=192.168.200.4,actions=output:4
ovs-ofctl add-flow br0 in_port=2,dl_type=0x0806,actions=mod_vlan_vid=200,output:5
ovs-ofctl add-flow br0 in_port=3,dl_type=0x0806,nw_dst=192.168.100.254,actions=output:1
ovs-ofctl add-flow br0 in_port=3,dl_type=0x0806,actions=mod_vlan_vid=100,output:5
ovs-ofctl add-flow br0 in_port=4,dl_type=0x0806,nw_dst=192.168.200.254,actions=output:2
ovs-ofctl add-flow br0 in_port=4,dl_type=0x0806,actions=mod_vlan_vid=200,output:5
ovs-ofctl add-flow br0 in_port=5,dl_vlan=100,dl_type=0x0806,actions=strip_vlan,output:1,3
ovs-ofctl add-flow br0 in_port=5,dl_vlan=100,dl_type=0x0800,nw_dst=192.168.100.3,actions=strip_vlan,output:3
ovs-ofctl add-flow br0 in_port=5,dl_vlan=100,dl_type=0x0800,nw_dst=192.168.100.254,actions=strip_vlan,output:1
ovs-ofctl add-flow br0 in_port=5,dl_vlan=100,dl_type=0x0800,nw_dst=192.168.200.254/24,actions=strip_vlan,output:1
ovs-ofctl add-flow br0 in_port=5,dl_vlan=200,dl_type=0x0806,actions=strip_vlan,output:2,4
ovs-ofctl add-flow br0 in_port=5,dl_vlan=200,dl_type=0x0800,nw_dst=192.168.200.4,actions=strip_vlan,output:4
ovs-ofctl add-flow br0 in_port=5,dl_vlan=200,dl_type=0x0800,nw_dst=192.168.200.254,actions=strip_vlan,output:2
ovs-ofctl add-flow br0 in_port=5,dl_vlan=200,dl_type=0x0800,nw_dst=192.168.100.254/24,actions=strip_vlan,output:2
ovs-ofctl add-flow br0 in_port=1,dl_type=0x0800,nw_dst=192.168.100.1,actions=mod_vlan_vid=100,output:5
ovs-ofctl add-flow br0 in_port=1,dl_type=0x0800,nw_dst=192.168.100.3,actions=output:3
ovs-ofctl add-flow br0
in_port=2,dl_type=0x0800,nw_dst=192.168.200.2,actions=mod_vlan_vid=200,output:5
ovs-ofctl add-flow br0 in_port=2,dl_type=0x0800,nw_dst=192.168.200.4,actions=output:4
ovs-ofctl add-flow br0
in_port=3,dl_type=0x0800,nw_dst=192.168.100.1,actions=mod_vlan_vid=100,output:5
ovs-ofctl add-flow br0 in_port=3,dl_type=0x0800,nw_dst=192.168.100.254,actions=output:1
ovs-ofctl add-flow br0
in_port=3,dl_type=0x0800,nw_dst=192.168.200.254/24,actions=strip_vlan,output:1
ovs-ofctl add-flow br0
in_port=4,dl_type=0x0800,nw_dst=192.168.200.2,actions=mod_vlan_vid=200,output:5
ovs-ofctl add-flow br0 in_port=4,dl_type=0x0800,nw_dst=192.168.200.254,actions=output:2
ovs-ofctl add-flow br0 in_port=4,dl_type=0x0800,nw_dst=192.168.100.254/24,actions=strip_vlan,output:2
ovs-ofctl dump-flows br0 # Check
```

#### DAR2324_Pr3_2_g1_P2
- Reescribir los comandos exactos que hemos introducido en cada OvS
- Con las tablas ARP vacías, hacer `ping` entre PC1 y PC2 y capturar **entre switchs**. Comprobar paquetes STP, ARP e ICMP y valores de las @IP y @MAC (y TTL).


## 2.4 Configuración de OvS para conectar LAN mediante WAN

OBJETIVO -> encapsular ethernet sobre IP para interconectar redes LAN












