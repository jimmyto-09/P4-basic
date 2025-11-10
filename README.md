# 🧠 Proyecto P4 básico — IPv4 Forwarding con BMv2 y Mininet

Este proyecto implementa un **switch programable en P4** que realiza **reenvío de paquetes IPv4** (IP forwarding) usando una tabla de coincidencia por prefijo (*Longest Prefix Match – LPM*).  
Está diseñado para funcionar sobre el entorno **BMv2 simple_switch** y **Mininet**.

---

## 🚀 Objetivo del proyecto

- Comprender la estructura de un programa **P4_16** basado en el modelo **v1model**.  
- Implementar un pipeline con **parser**, **ingress**, **egress** y **deparser**.  
- Realizar reenvío (routing) de paquetes IPv4 entre dos hosts conectados al switch P4.  

---

## ⚙️ Estructura del proyecto

| Archivo | Descripción |
|----------|--------------|
| `basic.p4` | Código P4 principal (define parser, controles, tabla y acciones). |
| `basic.json` | Salida compilada del código P4 (se genera con `p4c-bm2-ss`). |
| `topo.py` | Script de Mininet que define la topología (2 hosts y 1 switch). |

---

## 🧩 Contenido principal del código P4

- **Parser**: Extrae cabeceras Ethernet e IPv4.  
- **MyIngress**:  
  - Define la acción `ipv4_forward` → cambia la MAC destino y decide el puerto de salida.  
  - Define la acción `drop` → descarta el paquete.  
  - Tabla `ipv4_lpm` → consulta el destino IP y aplica la acción correspondiente.  
- **MyEgress, VerifyChecksum, ComputeChecksum** → bloques vacíos en este ejemplo.  
- **Deparser**: Reempaqueta el paquete y lo envía al puerto de salida.

---

## ⚙️ Ejecución rápida

```bash
# Compilar el programa P4
p4c-bm2-ss basic.p4 -o basic.json

# Ejecutar el switch (Terminal 1)
sudo simple_switch -i 1@s1-eth1 -i 2@s1-eth2 --thrift-port 9090 basic.json

# Levantar Mininet (Terminal 2)
sudo mn --custom topo.py --topo simpletopo --controller none

# Programar tablas (Terminal 3)
simple_switch_CLI --thrift-port 9090
table_add MyIngress.ipv4_lpm MyIngress.ipv4_forward 10.0.0.1/32 => 00:00:00:00:00:01 1
table_add MyIngress.ipv4_lpm MyIngress.ipv4_forward 10.0.0.2/32 => 00:00:00:00:00:02 2

# Probar conexión
mininet> h1 ping h2

