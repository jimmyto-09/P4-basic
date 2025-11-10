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

## 🧠 Topología usada

