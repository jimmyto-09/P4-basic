#include <core.p4>
#include <v1model.p4>

// Cabeceras Ethernet e IPv4
header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}

header ipv4_t {
    bit<4>  version;
    bit<4>  ihl;
    bit<8>  diffserv;
    bit<16> totalLen;
    bit<16> identification;
    bit<3>  flags;
    bit<13> fragOffset;
    bit<8>  ttl;
    bit<8>  protocol;
    bit<16> hdrChecksum;
    bit<32> srcAddr;
    bit<32> dstAddr;
}

// Estructura de cabeceras
struct headers {
    ethernet_t ethernet;
    ipv4_t ipv4;
}

// Metadatos vacíos
struct metadata { }

// Parser
parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {
    state start {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            0x0800: parse_ipv4;
            default: accept;
        }
    }

    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition accept;
    }
}

// Verificación de checksum (vacío)
control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply { }
}

// Cálculo de checksum (vacío)
control MyComputeChecksum(inout headers hdr, inout metadata meta) {
    apply { }
}

// Control de ingreso
control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {

    // Acción de reenvío
    action ipv4_forward(bit<48> new_dst_mac, bit<9> port) {
        hdr.ethernet.dstAddr = new_dst_mac;
        // Normalmente pondrías aquí la MAC del switch en srcAddr.
        hdr.ethernet.srcAddr = hdr.ethernet.srcAddr;
        standard_metadata.egress_spec = port;
    }

    // Acción de descarte
    action drop() {
        mark_to_drop(standard_metadata);
    }

    // Tabla de reenvío por IP
    table ipv4_lpm {
        key = {
            hdr.ipv4.dstAddr: lpm;
        }
        actions = {
            ipv4_forward;
            drop;
            NoAction;
        }
        size = 1024;
        default_action = drop();
    }

    apply {
        if (hdr.ipv4.isValid()) {
            ipv4_lpm.apply();
        }
    }
}

// Control de egreso (vacío)
control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply { }
}

// Deparser
control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.ipv4);  // Se emite solo si es válido
    }
}

// Switch principal
V1Switch(
    MyParser(),
    MyVerifyChecksum(),
    MyIngress(),
    MyEgress(),
    MyComputeChecksum(),
    MyDeparser()
) main;
