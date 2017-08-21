From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH] tests: json: Add test cases for json format
Date: Tue, 22 Aug 2017 02:25:04 +0530
Message-ID: <1503348904-16654-1-git-send-email-mayhs11saini@gmail.com>
Cc: pablo@netfilter.org, Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33127 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753840AbdHUU5K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 16:57:10 -0400
Received: by mail-pg0-f68.google.com with SMTP id u191so436726pgc.0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2017 13:57:10 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These cases can be used to test upcoming "import json" command.

Here is the short description of the files:
all_ruleset_list   ->    contains list of all the individual rules
rules_ipv4*        ->    ip  table
rules_ipv6*        ->    ip6 table
rules_arp*         ->    arp table
rules_bridge*      ->    bridge table

At this point of time some tests may fails.
For example:
 dup to 172.20.0.2
 ether daddr 00:01:02:03:04:05 ether saddr set ff:fe:dc:ba:98:76 drop

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 tests/json/all_ruleset_list                        | 50 ++++++++++++++++++++++
 tests/json/rules_arp_hlen_range.json               |  1 +
 tests/json/rules_arp_htype.json                    |  1 +
 tests/json/rules_arp_operation.json                |  1 +
 tests/json/rules_arp_operation_check.json          |  1 +
 tests/json/rules_arp_ptype_ip.json                 |  1 +
 tests/json/rules_bridge_ether_saddr_drop.json      |  1 +
 ...ge_ether_type_reject_icmp_host_unreachable.json |  1 +
 tests/json/rules_bridge_vlan.json                  |  1 +
 tests/json/rules_bridge_vlan_id.json               |  1 +
 ...bridge_vlan_id_saddr_udp_dport_drop_domain.json |  1 +
 tests/json/rules_ipv4_ct_state_accept.json         |  1 +
 tests/json/rules_ipv4_dup.json                     |  1 +
 .../rules_ipv4_icmp_type_echo-request_accept.json  |  1 +
 .../rules_ipv4_icmp_type_echo-request_counter.json |  1 +
 tests/json/rules_ipv4_iifname_accept.json          |  1 +
 tests/json/rules_ipv4_saddr_daddr_counter.json     |  1 +
 tests/json/rules_ipv4_set_elements.json            |  1 +
 tests/json/rules_ipv4_tcp_dport_http_ssh.json      |  1 +
 tests/json/rules_ipv4_tcp_flags.json               |  1 +
 tests/json/rules_ipv6_daddr_udp_dport_counter.json |  1 +
 ...es_ipv6_daddr_udp_dport_counter_masquerade.json |  1 +
 tests/json/rules_ipv6_icmpv6_id.json               |  1 +
 ...iifname_ct_state_tcp_dport_vmap_masquerade.json |  1 +
 tests/json/rules_ipv6_l4proto_tcp_masquerade.json  |  1 +
 ...dport_ssh_daddr_mapping_ether_saddr_accept.json |  1 +
 26 files changed, 75 insertions(+)
 create mode 100644 tests/json/all_ruleset_list
 create mode 100644 tests/json/rules_arp_hlen_range.json
 create mode 100644 tests/json/rules_arp_htype.json
 create mode 100644 tests/json/rules_arp_operation.json
 create mode 100644 tests/json/rules_arp_operation_check.json
 create mode 100644 tests/json/rules_arp_ptype_ip.json
 create mode 100644 tests/json/rules_bridge_ether_saddr_drop.json
 create mode 100644 tests/json/rules_bridge_ether_type_reject_icmp_host_unreachable.json
 create mode 100644 tests/json/rules_bridge_vlan.json
 create mode 100644 tests/json/rules_bridge_vlan_id.json
 create mode 100644 tests/json/rules_bridge_vlan_id_saddr_udp_dport_drop_domain.json
 create mode 100644 tests/json/rules_ipv4_ct_state_accept.json
 create mode 100644 tests/json/rules_ipv4_dup.json
 create mode 100644 tests/json/rules_ipv4_icmp_type_echo-request_accept.json
 create mode 100644 tests/json/rules_ipv4_icmp_type_echo-request_counter.json
 create mode 100644 tests/json/rules_ipv4_iifname_accept.json
 create mode 100644 tests/json/rules_ipv4_saddr_daddr_counter.json
 create mode 100644 tests/json/rules_ipv4_set_elements.json
 create mode 100644 tests/json/rules_ipv4_tcp_dport_http_ssh.json
 create mode 100644 tests/json/rules_ipv4_tcp_flags.json
 create mode 100644 tests/json/rules_ipv6_daddr_udp_dport_counter.json
 create mode 100644 tests/json/rules_ipv6_daddr_udp_dport_counter_masquerade.json
 create mode 100644 tests/json/rules_ipv6_icmpv6_id.json
 create mode 100644 tests/json/rules_ipv6_iifname_ct_state_tcp_dport_vmap_masquerade.json
 create mode 100644 tests/json/rules_ipv6_l4proto_tcp_masquerade.json
 create mode 100644 tests/json/rules_ipv6_tcp_dport_ssh_daddr_mapping_ether_saddr_accept.json

diff --git a/tests/json/all_ruleset_list b/tests/json/all_ruleset_list
new file mode 100644
index 000000000000..e5ed635b9580
--- /dev/null
+++ b/tests/json/all_ruleset_list
@@ -0,0 +1,50 @@
+table ip mangle {
+	set set1 {
+		type ipv4_addr
+		elements = { 192.168.1.4, 192.168.1.5 }
+
+	}
+	chain prerouting {
+		type filter hook prerouting priority 0; policy accept;
+		ip saddr @set1 drop
+		ip saddr 192.168.1.100 ip daddr 192.168.1.1 counter packets 0 bytes 0
+		tcp flags != syn counter packets 619772 bytes 389570486
+		icmp type echo-request counter packets 0 bytes 0 drop
+		ct state established,related accept
+		iifname "lo" accept
+		icmp type echo-request accept
+		tcp dport { http, ssh} accept
+	}
+
+}
+table ip6 x {
+	chain y {
+		type nat hook postrouting priority 0; policy accept;
+		ip6 daddr fe00::1-fe00::200 udp dport domain counter packets 0 bytes 0 masquerade
+		meta l4proto tcp masquerade to :1024
+		iifname "wlan0" ct state established,new tcp dport vmap { 222 : drop, ssh : drop} masquerade
+		ip6 daddr fe00::1-fe00::200 udp dport domain counter packets 0 bytes 0 masquerade
+		iifname "eth0" ct state established,new tcp dport vmap { 222 : drop, ssh : drop} masquerade
+		tcp dport ssh ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:04 accept
+	        icmpv6 id 33-45
+	}
+}
+table arp x {
+	chain y {
+		arp operation { request, reply, inreply, inrequest, nak, rrequest, rreply}
+		arp operation != rrequest
+		arp ptype ip
+		arp hlen 33-45
+		arp htype 22
+	}
+}
+table bridge x {
+	chain y {
+		type filter hook input priority 0; policy accept;
+		ether daddr 00:01:02:03:04:05 ether saddr set ff:fe:dc:ba:98:76 drop
+		vlan id 4094 vlan cfi 0
+		vlan id 4094
+		vlan id 1 ip saddr 10.0.0.0/23 udp dport domain
+		ether type ip reject with icmp type host-unreachable
+	}
+}
diff --git a/tests/json/rules_arp_hlen_range.json b/tests/json/rules_arp_hlen_range.json
new file mode 100644
index 000000000000..d4ad00cd7a54
--- /dev/null
+++ b/tests/json/rules_arp_hlen_range.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"arp","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"table":"x","family":"arp","use":1}},{"rule":{"family":"arp","table":"x","chain":"y","handle":3,"expr":[{"type":"payload","dreg":1,"offset":4,"len":1,"base":"network"},{"type":"cmp","sreg":1,"op":"gte","data":{"reg":{"type":"value","len":1,"data0":"0x00000021"}}},{"type":"cmp","sreg":1,"op":"lte","data":{"reg":{"type":"value","len":1,"data0":"0x0000002d"}}}]}}]}]}
diff --git a/tests/json/rules_arp_htype.json b/tests/json/rules_arp_htype.json
new file mode 100644
index 000000000000..95bd5580676d
--- /dev/null
+++ b/tests/json/rules_arp_htype.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"arp","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"table":"x","family":"arp","use":1}},{"rule":{"family":"arp","table":"x","chain":"y","handle":5,"expr":[{"type":"payload","dreg":1,"offset":0,"len":2,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}}]}}]}]}
diff --git a/tests/json/rules_arp_operation.json b/tests/json/rules_arp_operation.json
new file mode 100644
index 000000000000..94389a33725e
--- /dev/null
+++ b/tests/json/rules_arp_operation.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"arp","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"table":"x","family":"arp","use":1}},{"set":{"name":"__set0","table":"x","flags":3,"family":"arp","key_type":11,"key_len":2,"desc_size":7,"set_elem":[{"key":{"reg":{"type":"value","len":2,"data0":"0x00000900"}}},{"key":{"reg":{"type":"value","len":2,"data0":"0x00000400"}}},{"key":{"reg":{"type":"value","len":2,"data0":"0x00000300"}}},{"key":{"reg":{"type":"value","len":2,"data0":"0x00000800"}}},{"key":{"reg":{"type":"value","len":2,"data0":"0x00000200"}}},{"key":{"reg":{"type":"value","len":2,"data0":"0x00000a00"}}},{"key":{"reg":{"type":"value","len":2,"data0":"0x00000100"}}}]}},{"rule":{"family":"arp","table":"x","chain":"y","handle":3,"expr":[{"type":"payload","dreg":1,"offset":
 6,"len":2,"base":"network"},{"type":"lookup","set":"__set0","sreg":1,"flags":0}]}}]}]}
diff --git a/tests/json/rules_arp_operation_check.json b/tests/json/rules_arp_operation_check.json
new file mode 100644
index 000000000000..fac7b9447e3c
--- /dev/null
+++ b/tests/json/rules_arp_operation_check.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"arp","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"table":"x","family":"arp","use":1}},{"rule":{"family":"arp","table":"x","chain":"y","handle":2,"expr":[{"type":"payload","dreg":1,"offset":6,"len":2,"base":"network"},{"type":"cmp","sreg":1,"op":"neq","data":{"reg":{"type":"value","len":2,"data0":"0x00000300"}}}]}}]}]}
diff --git a/tests/json/rules_arp_ptype_ip.json b/tests/json/rules_arp_ptype_ip.json
new file mode 100644
index 000000000000..81d2b6d366cd
--- /dev/null
+++ b/tests/json/rules_arp_ptype_ip.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"arp","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"table":"x","family":"arp","use":1}},{"rule":{"family":"arp","table":"x","chain":"y","handle":4,"expr":[{"type":"payload","dreg":1,"offset":2,"len":2,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00000008"}}}]}}]}]}
diff --git a/tests/json/rules_bridge_ether_saddr_drop.json b/tests/json/rules_bridge_ether_saddr_drop.json
new file mode 100644
index 000000000000..52cdcd1c1349
--- /dev/null
+++ b/tests/json/rules_bridge_ether_saddr_drop.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"bridge","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"bytes":0,"packets":0,"table":"x","family":"bridge","use":1,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}},{"rule":{"family":"bridge","table":"x","chain":"y","handle":2,"expr":[{"type":"payload","dreg":1,"offset":0,"len":6,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":6,"data0":"0x03020100","data1":"0x00000504"}}},{"type":"immediate","dreg":1,"data":{"reg":{"type":"value","len":6,"data0":"0xbadcfeff","data1":"0x00007698"}}},{"type":"payload","offset":6,"len":6,"base":"link"},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"drop"}}}]}}]}]}
diff --git a/tests/json/rules_bridge_ether_type_reject_icmp_host_unreachable.json b/tests/json/rules_bridge_ether_type_reject_icmp_host_unreachable.json
new file mode 100644
index 000000000000..a6f1ba4ea98c
--- /dev/null
+++ b/tests/json/rules_bridge_ether_type_reject_icmp_host_unreachable.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"bridge","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"bytes":0,"packets":0,"table":"x","family":"bridge","use":1,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}},{"rule":{"family":"bridge","table":"x","chain":"y","handle":12,"expr":[{"type":"payload","dreg":1,"offset":12,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00000008"}}},{"type":"reject","type":0,"code":1}]}}]}]}
diff --git a/tests/json/rules_bridge_vlan.json b/tests/json/rules_bridge_vlan.json
new file mode 100644
index 000000000000..375ea9b2e29a
--- /dev/null
+++ b/tests/json/rules_bridge_vlan.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"bridge","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"bytes":0,"packets":0,"table":"x","family":"bridge","use":1,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}},{"rule":{"family":"bridge","table":"x","chain":"y","handle":6,"expr":[{"type":"payload","dreg":1,"offset":12,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00000081"}}},{"type":"payload","dreg":1,"offset":14,"len":2,"base":"link"},{"type":"bitwise","sreg":1,"dreg":1,"len":2,"mask":{"reg":{"type":"value","len":2,"data0":"0x0000ff0f"}},"xor":{"reg":{"type":"value","len":2,"data0":"0x00000000"}}},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x0000fe0f"}}}]}}]}]}
diff --git a/tests/json/rules_bridge_vlan_id.json b/tests/json/rules_bridge_vlan_id.json
new file mode 100644
index 000000000000..8f01fcedf9d2
--- /dev/null
+++ b/tests/json/rules_bridge_vlan_id.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"bridge","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"bytes":0,"packets":0,"table":"x","family":"bridge","use":1,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}},{"rule":{"family":"bridge","table":"x","chain":"y","handle":4,"expr":[{"type":"payload","dreg":1,"offset":12,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00000081"}}},{"type":"payload","dreg":1,"offset":14,"len":2,"base":"link"},{"type":"bitwise","sreg":1,"dreg":1,"len":2,"mask":{"reg":{"type":"value","len":2,"data0":"0x0000ff0f"}},"xor":{"reg":{"type":"value","len":2,"data0":"0x00000000"}}},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x0000fe0f"}}},{"type":"paylo
 ad","dreg":1,"offset":14,"len":1,"base":"link"},{"type":"bitwise","sreg":1,"dreg":1,"len":1,"mask":{"reg":{"type":"value","len":1,"data0":"0x00000010"}},"xor":{"reg":{"type":"value","len":1,"data0":"0x00000000"}}},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000000"}}}]}}]}]}
diff --git a/tests/json/rules_bridge_vlan_id_saddr_udp_dport_drop_domain.json b/tests/json/rules_bridge_vlan_id_saddr_udp_dport_drop_domain.json
new file mode 100644
index 000000000000..69f8446e7622
--- /dev/null
+++ b/tests/json/rules_bridge_vlan_id_saddr_udp_dport_drop_domain.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"bridge","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"bytes":0,"packets":0,"table":"x","family":"bridge","use":1,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}},{"rule":{"family":"bridge","table":"x","chain":"y","handle":9,"expr":[{"type":"payload","dreg":1,"offset":12,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00000081"}}},{"type":"payload","dreg":1,"offset":14,"len":2,"base":"link"},{"type":"bitwise","sreg":1,"dreg":1,"len":2,"mask":{"reg":{"type":"value","len":2,"data0":"0x0000ff0f"}},"xor":{"reg":{"type":"value","len":2,"data0":"0x00000000"}}},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00000100"}}},{"type":"paylo
 ad","dreg":1,"offset":16,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00000008"}}},{"type":"payload","dreg":1,"offset":12,"len":4,"base":"network"},{"type":"bitwise","sreg":1,"dreg":1,"len":4,"mask":{"reg":{"type":"value","len":4,"data0":"0x00feffff"}},"xor":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0000000a"}}},{"type":"meta","dreg":1,"key":"l4proto"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000011"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00003500"}}}]}}]}]}
diff --git a/tests/json/rules_ipv4_ct_state_accept.json b/tests/json/rules_ipv4_ct_state_accept.json
new file mode 100644
index 000000000000..942f19850026
--- /dev/null
+++ b/tests/json/rules_ipv4_ct_state_accept.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"mangle","family":"ip","flags":0,"use":1}},{"chain":{"name":"prerouting","handle":1,"bytes":696,"packets":8,"table":"mangle","family":"ip","use":1,"type":"filter","hooknum":"prerouting","prio":0,"policy":"accept"}},{"rule":{"family":"ip","table":"mangle","chain":"prerouting","handle":2,"expr":[{"type":"ct","dreg":1,"key":"state"},{"type":"bitwise","sreg":1,"dreg":1,"len":4,"mask":{"reg":{"type":"value","len":4,"data0":"0x00000006"}},"xor":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"cmp","sreg":1,"op":"neq","data":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"accept"}}}]}}]}]}
diff --git a/tests/json/rules_ipv4_dup.json b/tests/json/rules_ipv4_dup.json
new file mode 100644
index 000000000000..54491d01f994
--- /dev/null
+++ b/tests/json/rules_ipv4_dup.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"mangle","family":"ip","flags":0,"use":1}},{"chain":{"name":"prerouting","handle":1,"bytes":4658,"packets":42,"table":"mangle","family":"ip","use":1,"type":"filter","hooknum":"prerouting","prio":0,"policy":"accept"}},{"rule":{"family":"ip","table":"mangle","chain":"prerouting","handle":2,"expr":[{"type":"immediate","dreg":1,"data":{"reg":{"type":"value","len":4,"data0":"0x020014ac"}}},{"type":"dup","sreg_addr":1}]}}]}]}
diff --git a/tests/json/rules_ipv4_icmp_type_echo-request_accept.json b/tests/json/rules_ipv4_icmp_type_echo-request_accept.json
new file mode 100644
index 000000000000..5a1032d0b771
--- /dev/null
+++ b/tests/json/rules_ipv4_icmp_type_echo-request_accept.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"mangle","family":"ip","flags":0,"use":1}},{"chain":{"name":"prerouting","handle":1,"bytes":46200,"packets":417,"table":"mangle","family":"ip","use":1,"type":"filter","hooknum":"prerouting","prio":0,"policy":"accept"}},{"rule":{"family":"ip","table":"mangle","chain":"prerouting","handle":2,"expr":[{"type":"meta","dreg":1,"key":"l4proto"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000001"}}},{"type":"payload","dreg":1,"offset":0,"len":1,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000008"}}},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"accept"}}}]}}]}]}
diff --git a/tests/json/rules_ipv4_icmp_type_echo-request_counter.json b/tests/json/rules_ipv4_icmp_type_echo-request_counter.json
new file mode 100644
index 000000000000..a95de6759a17
--- /dev/null
+++ b/tests/json/rules_ipv4_icmp_type_echo-request_counter.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"mangle","family":"ip","flags":0,"use":1}},{"chain":{"name":"prerouting","handle":1,"bytes":104,"packets":2,"table":"mangle","family":"ip","use":1,"type":"filter","hooknum":"prerouting","prio":0,"policy":"accept"}},{"rule":{"family":"ip","table":"mangle","chain":"prerouting","handle":2,"expr":[{"type":"meta","dreg":1,"key":"l4proto"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000001"}}},{"type":"payload","dreg":1,"offset":0,"len":1,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000008"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/json/rules_ipv4_iifname_accept.json b/tests/json/rules_ipv4_iifname_accept.json
new file mode 100644
index 000000000000..5a37a017901d
--- /dev/null
+++ b/tests/json/rules_ipv4_iifname_accept.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"mangle","family":"ip","flags":0,"use":1}},{"chain":{"name":"prerouting","handle":1,"bytes":4435,"packets":51,"table":"mangle","family":"ip","use":1,"type":"filter","hooknum":"prerouting","prio":0,"policy":"accept"}},{"rule":{"family":"ip","table":"mangle","chain":"prerouting","handle":5,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0":"0x00006f6c","data1":"0x00000000","data2":"0x00000000","data3":"0x00000000"}}},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"accept"}}}]}}]}]}
diff --git a/tests/json/rules_ipv4_saddr_daddr_counter.json b/tests/json/rules_ipv4_saddr_daddr_counter.json
new file mode 100644
index 000000000000..396cf2368b94
--- /dev/null
+++ b/tests/json/rules_ipv4_saddr_daddr_counter.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"mangle","family":"ip","flags":0,"use":1}},{"chain":{"name":"prerouting","handle":1,"bytes":2009,"packets":15,"table":"mangle","family":"ip","use":1,"type":"filter","hooknum":"prerouting","prio":0,"policy":"accept"}},{"rule":{"family":"ip","table":"mangle","chain":"prerouting","handle":2,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":8,"data0":"0x6401a8c0","data1":"0x0101a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/json/rules_ipv4_set_elements.json b/tests/json/rules_ipv4_set_elements.json
new file mode 100644
index 000000000000..ea641e384047
--- /dev/null
+++ b/tests/json/rules_ipv4_set_elements.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"mangle","family":"ip","flags":0,"use":2}},{"chain":{"name":"prerouting","handle":1,"bytes":15927,"packets":169,"table":"mangle","family":"ip","use":1,"type":"filter","hooknum":"prerouting","prio":0,"policy":"accept"}},{"set":{"name":"blackhole","table":"mangle","family":"ip","key_type":7,"key_len":4,"set_elem":[{"key":{"reg":{"type":"value","len":4,"data0":"0x0401a8c0"}}},{"key":{"reg":{"type":"value","len":4,"data0":"0x0501a8c0"}}}]}},{"rule":{"family":"ip","table":"mangle","chain":"prerouting","handle":2,"expr":[{"type":"payload","dreg":1,"offset":12,"len":4,"base":"network"},{"type":"lookup","set":"blackhole","sreg":1,"flags":0},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"drop"}}}]}}]}]}
diff --git a/tests/json/rules_ipv4_tcp_dport_http_ssh.json b/tests/json/rules_ipv4_tcp_dport_http_ssh.json
new file mode 100644
index 000000000000..b0f1709b8f49
--- /dev/null
+++ b/tests/json/rules_ipv4_tcp_dport_http_ssh.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"mangle","family":"ip","flags":0,"use":1}},{"chain":{"name":"prerouting","handle":1,"bytes":1308,"packets":12,"table":"mangle","family":"ip","use":1,"type":"filter","hooknum":"prerouting","prio":0,"policy":"accept"}},{"set":{"name":"__set0","table":"mangle","flags":3,"family":"ip","key_type":13,"key_len":2,"desc_size":2,"set_elem":[{"key":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"key":{"reg":{"type":"value","len":2,"data0":"0x00005000"}}}]}},{"rule":{"family":"ip","table":"mangle","chain":"prerouting","handle":2,"expr":[{"type":"meta","dreg":1,"key":"l4proto"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"lookup","
 set":"__set0","sreg":1,"flags":0},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"accept"}}}]}}]}]}
diff --git a/tests/json/rules_ipv4_tcp_flags.json b/tests/json/rules_ipv4_tcp_flags.json
new file mode 100644
index 000000000000..e0eadddd9528
--- /dev/null
+++ b/tests/json/rules_ipv4_tcp_flags.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"mangle","family":"ip","flags":0,"use":1}},{"chain":{"name":"prerouting","handle":1,"bytes":3886,"packets":36,"table":"mangle","family":"ip","use":1,"type":"filter","hooknum":"prerouting","prio":0,"policy":"accept"}},{"rule":{"family":"ip","table":"mangle","chain":"prerouting","handle":2,"expr":[{"type":"meta","dreg":1,"key":"l4proto"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":13,"len":1,"base":"transport"},{"type":"cmp","sreg":1,"op":"neq","data":{"reg":{"type":"value","len":1,"data0":"0x00000002"}}},{"type":"counter","pkts":6,"bytes":770}]}}]}]}
diff --git a/tests/json/rules_ipv6_daddr_udp_dport_counter.json b/tests/json/rules_ipv6_daddr_udp_dport_counter.json
new file mode 100644
index 000000000000..78bf12071042
--- /dev/null
+++ b/tests/json/rules_ipv6_daddr_udp_dport_counter.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"ip6","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"bytes":93,"packets":1,"table":"x","family":"ip6","use":1,"type":"nat","hooknum":"postrouting","prio":0,"policy":"accept"}},{"rule":{"family":"ip6","table":"x","chain":"y","handle":8,"expr":[{"type":"payload","dreg":1,"offset":24,"len":16,"base":"network"},{"type":"cmp","sreg":1,"op":"gte","data":{"reg":{"type":"value","len":16,"data0":"0x000000fe","data1":"0x00000000","data2":"0x00000000","data3":"0x01000000"}}},{"type":"cmp","sreg":1,"op":"lte","data":{"reg":{"type":"value","len":16,"data0":"0x000000fe","data1":"0x00000000","data2":"0x00000000","data3":"0x00020000"}}},{"type":"meta","dreg":1,"key":"l4proto"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"
 data0":"0x00000011"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00003500"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}]}
diff --git a/tests/json/rules_ipv6_daddr_udp_dport_counter_masquerade.json b/tests/json/rules_ipv6_daddr_udp_dport_counter_masquerade.json
new file mode 100644
index 000000000000..8eda8f4ce1c9
--- /dev/null
+++ b/tests/json/rules_ipv6_daddr_udp_dport_counter_masquerade.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"ip6","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"bytes":0,"packets":0,"table":"x","family":"ip6","use":1,"type":"nat","hooknum":"postrouting","prio":0,"policy":"accept"}},{"rule":{"family":"ip6","table":"x","chain":"y","handle":2,"expr":[{"type":"payload","dreg":1,"offset":24,"len":16,"base":"network"},{"type":"cmp","sreg":1,"op":"gte","data":{"reg":{"type":"value","len":16,"data0":"0x000000fe","data1":"0x00000000","data2":"0x00000000","data3":"0x01000000"}}},{"type":"cmp","sreg":1,"op":"lte","data":{"reg":{"type":"value","len":16,"data0":"0x000000fe","data1":"0x00000000","data2":"0x00000000","data3":"0x00020000"}}},{"type":"meta","dreg":1,"key":"l4proto"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"d
 ata0":"0x00000011"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00003500"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"masq"}]}}]}]}
diff --git a/tests/json/rules_ipv6_icmpv6_id.json b/tests/json/rules_ipv6_icmpv6_id.json
new file mode 100644
index 000000000000..19804c21ee3d
--- /dev/null
+++ b/tests/json/rules_ipv6_icmpv6_id.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"ip6","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"bytes":0,"packets":0,"table":"x","family":"ip6","use":1,"type":"nat","hooknum":"postrouting","prio":0,"policy":"accept"}},{"rule":{"family":"ip6","table":"x","chain":"y","handle":2,"expr":[{"type":"meta","dreg":1,"key":"l4proto"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x0000003a"}}},{"type":"payload","dreg":1,"offset":4,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"gte","data":{"reg":{"type":"value","len":2,"data0":"0x00002100"}}},{"type":"cmp","sreg":1,"op":"lte","data":{"reg":{"type":"value","len":2,"data0":"0x00002d00"}}}]}}]}]}
diff --git a/tests/json/rules_ipv6_iifname_ct_state_tcp_dport_vmap_masquerade.json b/tests/json/rules_ipv6_iifname_ct_state_tcp_dport_vmap_masquerade.json
new file mode 100644
index 000000000000..5245041ed619
--- /dev/null
+++ b/tests/json/rules_ipv6_iifname_ct_state_tcp_dport_vmap_masquerade.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"ip6","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"bytes":0,"packets":0,"table":"x","family":"ip6","use":1,"type":"nat","hooknum":"postrouting","prio":0,"policy":"accept"}},{"set":{"name":"__map0","table":"x","flags":11,"family":"ip6","key_type":13,"key_len":2,"data_type":4294967040,"data_len":16,"desc_size":2,"set_elem":[{"key":{"reg":{"type":"value","len":2,"data0":"0x00001600"}},"data":{"reg":{"type":"verdict","verdict":"drop"}}},{"key":{"reg":{"type":"value","len":2,"data0":"0x0000de00"}},"data":{"reg":{"type":"verdict","verdict":"drop"}}}]}},{"rule":{"family":"ip6","table":"x","chain":"y","handle":2,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0"
 :"0x6e616c77","data1":"0x00000030","data2":"0x00000000","data3":"0x00000000"}}},{"type":"ct","dreg":1,"key":"state"},{"type":"bitwise","sreg":1,"dreg":1,"len":4,"mask":{"reg":{"type":"value","len":4,"data0":"0x0000000a"}},"xor":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"cmp","sreg":1,"op":"neq","data":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"meta","dreg":1,"key":"l4proto"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"lookup","set":"__map0","sreg":1,"dreg":0,"flags":0},{"type":"masq"}]}}]}]}
diff --git a/tests/json/rules_ipv6_l4proto_tcp_masquerade.json b/tests/json/rules_ipv6_l4proto_tcp_masquerade.json
new file mode 100644
index 000000000000..c190d7eaa0b6
--- /dev/null
+++ b/tests/json/rules_ipv6_l4proto_tcp_masquerade.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"ip6","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"bytes":0,"packets":0,"table":"x","family":"ip6","use":1,"type":"nat","hooknum":"postrouting","prio":0,"policy":"accept"}},{"rule":{"family":"ip6","table":"x","chain":"y","handle":2,"expr":[{"type":"meta","dreg":1,"key":"l4proto"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"immediate","dreg":1,"data":{"reg":{"type":"value","len":2,"data0":"0x00000004"}}},{"type":"masq","sreg_proto_min":1,"sreg_proto_max":1}]}}]}]}
diff --git a/tests/json/rules_ipv6_tcp_dport_ssh_daddr_mapping_ether_saddr_accept.json b/tests/json/rules_ipv6_tcp_dport_ssh_daddr_mapping_ether_saddr_accept.json
new file mode 100644
index 000000000000..9768b770f441
--- /dev/null
+++ b/tests/json/rules_ipv6_tcp_dport_ssh_daddr_mapping_ether_saddr_accept.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"table":{"name":"x","family":"ip6","flags":0,"use":1}},{"chain":{"name":"y","handle":1,"bytes":0,"packets":0,"table":"x","family":"ip6","use":1,"type":"nat","hooknum":"postrouting","prio":0,"policy":"accept"}},{"rule":{"family":"ip6","table":"x","chain":"y","handle":2,"expr":[{"type":"meta","dreg":1,"key":"l4proto"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"payload","dreg":1,"offset":24,"len":16,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0":"0x00000100","data1":"0x00000000","data2":"0x00000000","d
 ata3":"0x02000000"}}},{"type":"meta","dreg":1,"key":"iiftype"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00000001"}}},{"type":"payload","dreg":1,"offset":6,"len":6,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":6,"data0":"0x0c540f00","data1":"0x00000411"}}},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"accept"}}}]}}]}]}
-- 
1.9.1

