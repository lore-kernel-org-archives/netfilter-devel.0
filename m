From: Ana Rey <anarey@gmail.com>
Subject: [v3 nft 2/7] tests: Add ip folder with test files
Date: Thu, 18 Sep 2014 12:39:16 +0200
Message-ID: <1411036761-26825-3-git-send-email-anarey@gmail.com>
References: <1411036761-26825-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40603 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbaIRKhE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2014 06:37:04 -0400
Received: by mail-wi0-f182.google.com with SMTP id e4so909392wiv.9
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Sep 2014 03:37:02 -0700 (PDT)
In-Reply-To: <1411036761-26825-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"ip" folder contains the test files that are executed in ip and inet
family of tables.

These test files are executed with nft-tests.py

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/regression/ip/chains.t |   22 +++++++++
 tests/regression/ip/icmp.t   |   93 ++++++++++++++++++++++++++++++++++++
 tests/regression/ip/ip.t     |  107 ++++++++++++++++++++++++++++++++++++++++++
 tests/regression/ip/nat.t    |   18 +++++++
 tests/regression/ip/reject.t |    5 ++
 tests/regression/ip/sets.t   |   31 ++++++++++++
 6 files changed, 276 insertions(+)
 create mode 100644 tests/regression/ip/chains.t
 create mode 100644 tests/regression/ip/icmp.t
 create mode 100644 tests/regression/ip/ip.t
 create mode 100644 tests/regression/ip/nat.t
 create mode 100644 tests/regression/ip/reject.t
 create mode 100644 tests/regression/ip/sets.t

diff --git a/tests/regression/ip/chains.t b/tests/regression/ip/chains.t
new file mode 100644
index 0000000..92a1147
--- /dev/null
+++ b/tests/regression/ip/chains.t
@@ -0,0 +1,22 @@
+*ip;test-ip4
+-*inet;test-inet
+
+# filter chains available are: input, output, forward, prerouting, postrouting
+:filter-input;type filter hook input priority 0
+:filter-pre;type filter hook prerouting priority 0
+:filter-forw;type filter hook forward priority 0
+:filter-out;type filter hook output priority 0
+:filter-post;type filter hook postrouting priority 0
+# nat chains available are: input, output, prerouting, postrouting
+:nat-input-t;type nat hook input priority 0
+:nat-pre-t;type nat hook prerouting priority 0
+:nat-out-t;type nat hook output priority 0
+:nat-post-t;type nat hook postrouting priority 0
+# route chain available are: output
+:route-out-t;type route hook output priority 0
+
+#ip daddr 192.168.0.1-192.168.0.250;ok
+#ip daddr 192.168.0.1;ok
+#ip daddr 192.168.0.1 drop;ok
+#ip daddr 192.168.0.2 log;ok
+#ip daddr 192.168.0.2 log;ok
diff --git a/tests/regression/ip/icmp.t b/tests/regression/ip/icmp.t
new file mode 100644
index 0000000..cd43a66
--- /dev/null
+++ b/tests/regression/ip/icmp.t
@@ -0,0 +1,93 @@
+*ip;test-ip4
+# BUG: There is a bug with icmp protocol and inet family.
+- *inet;test-inet
+:input;type filter hook input priority 0
+
+icmp type echo-reply accept;ok
+icmp type destination-unreachable accept;ok
+icmp type source-quench accept;ok
+icmp type redirect accept;ok
+icmp type echo-request accept;ok
+icmp type time-exceeded accept;ok
+icmp type parameter-problem accept;ok
+icmp type timestamp-request accept;ok
+icmp type timestamp-reply accept;ok
+icmp type info-request accept;ok
+icmp type info-reply accept;ok
+icmp type address-mask-request accept;ok
+icmp type address-mask-reply accept;ok
+icmp type {echo-reply, destination-unreachable, source-quench, redirect, echo-request, time-exceeded, parameter-problem, timestamp-request, timestamp-reply, info-request, info-reply, address-mask-request, address-mask-reply} accept;ok
+- icmp type != {echo-reply, destination-unreachable, source-quench};ok
+# BUG: icmp type != {echo-reply, destination-unreachable, source-quench}
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+icmp code 111 accept;ok
+icmp code != 111 accept;ok
+icmp code 33-55;ok;icmp code >= 33 icmp code <= 55
+icmp code != 33-55;ok;icmp code < 33 icmp code > 55
+icmp code { 33-55};ok
+- icmp code != { 33-55};ok
+icmp code { 2, 4, 54, 33, 56};ok
+- icmp code != { 2, 4, 54, 33, 56};ok
+# $ sudo nft add rule ip test input icmp code != {2, 4, 54, 33, 56}
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+icmp checksum 12343 accept;ok
+icmp checksum != 12343 accept;ok
+icmp checksum 11-343 accept;ok;icmp checksum >= 11 icmp checksum <= 343 accept
+icmp checksum != 11-343 accept;ok;icmp checksum < 11 icmp checksum > 343 accept
+icmp checksum { 11-343} accept;ok
+- icmp checksum != { 11-343} accept;ok
+icmp checksum { 1111, 222, 343} accept;ok
+- icmp checksum != { 1111, 222, 343} accept;ok
+# BUG: invalid expression type set
+# icmp checksum != { 1111, 222, 343} accept;ok
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+icmp id 1245 log;ok
+icmp id 22;ok
+icmp id != 233;ok
+icmp id 33-45;ok;icmp id >= 33 icmp id <= 45
+icmp id != 33-45;ok;icmp id < 33 icmp id > 45
+icmp id { 33-55};ok
+- icmp id != { 33-55};ok
+icmp id { 22, 34, 333};ok
+- icmp id != { 22, 34, 333};ok
+# BUG: invalid expression type set
+# icmp id != { 22, 34, 333}
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+icmp sequence 22;ok
+icmp sequence != 233;ok
+icmp sequence 33-45;ok;icmp sequence >= 33 icmp sequence <= 45
+icmp sequence != 33-45;ok;icmp sequence < 33 icmp sequence > 45
+icmp sequence { 33, 55, 67, 88};ok
+- icmp sequence != { 33, 55, 67, 88};ok
+icmp sequence { 33-55};ok
+- icmp sequence != { 33-55};ok
+
+icmp mtu 33;ok
+icmp mtu 22-33;ok
+icmp mtu { 22-33};ok
+- icmp mtu != { 22-33};ok
+icmp mtu 22;ok
+icmp mtu != 233;ok
+icmp mtu 33-45;ok
+icmp mtu != 33-45;ok
+icmp mtu { 33, 55, 67, 88};ok
+- icmp mtu != { 33, 55, 67, 88};ok
+icmp mtu { 33-55};ok
+- icmp mtu != { 33-55};ok
+
+icmp gateway 22;ok
+icmp gateway != 233;ok
+icmp gateway 33-45;ok;icmp gateway >= 33 icmp gateway <= 45
+icmp gateway != 33-45;ok;icmp gateway < 33 icmp gateway > 45
+icmp gateway { 33, 55, 67, 88};ok
+- icmp gateway != { 33, 55, 67, 88};ok
+icmp gateway { 33-55};ok
+- icmp gateway != { 33-55};ok
+icmp gateway != 34;ok
+- icmp gateway != { 333, 334};ok
diff --git a/tests/regression/ip/ip.t b/tests/regression/ip/ip.t
new file mode 100644
index 0000000..a781de5
--- /dev/null
+++ b/tests/regression/ip/ip.t
@@ -0,0 +1,107 @@
+*ip;test-ip4
+*inet;test-inet
+:input;type filter hook input priority 0
+
+- ip version 2;ok
+
+# bug ip hdrlength
+- ip hdrlength 10;ok
+- ip hdrlength != 5;ok
+- ip hdrlength 5-8;ok
+- ip hdrlength != 3-13;ok
+- ip hdrlength {3, 5, 6, 8};ok
+- ip hdrlength != {3, 5, 7, 8};ok
+- ip hdrlength { 3-5};ok
+- ip hdrlength != { 3-59};ok
+# ip hdrlength 12
+# <cmdline>:1:1-38: Error: Could not process rule: Invalid argument
+# add rule ip test input ip hdrlength 12
+# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+# <cmdline>:1:37-38: Error: Value 22 exceeds valid range 0-15
+# add rule ip test input ip hdrlength 22
+
+- ip dscp CS1;ok
+- ip dscp != CS1;ok
+- ip dscp 0x38;ok
+- ip dscp != 0x20;ok
+- ip dscp {CS1, CS2, CS3, CS4, CS5, CS6, CS7, BE, AF11, AF12, AF13, AF21, AF22, AF23, AF31, AF32, AF33, AF41, AF42, AF43, EF};ok
+- ip dscp {0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0x00, 0x0a, 0x0c, 0x0e, 0x12, 0x14, 0x16, 0x1a, 0x1c, 0x1e, 0x22, 0x24, 0x26, 0x2e};ok
+- ip dscp != {CS0, CS3};ok
+
+ip length 232;ok
+ip length != 233;ok
+ip length 333-435;ok;ip length >= 333 ip length <= 435
+ip length != 333-453;ok;ip length < 333 ip length > 453
+ip length { 333, 553, 673, 838};ok
+- ip length != { 333, 535, 637, 883};ok
+ip length { 333-535};ok
+- ip length != { 333-553};ok
+
+ip id 22;ok
+ip id != 233;ok
+ip id 33-45;ok;ip id >= 33 ip id <= 45
+ip id != 33-45;ok;ip id < 33 ip id > 45
+ip id { 33, 55, 67, 88};ok
+- ip id != { 33, 55, 67, 88};ok
+ip id { 33-55};ok
+- ip id != { 33-55};ok
+
+ip frag-off 222 accept;ok
+ip frag-off != 233;ok
+ip frag-off 33-45;ok;ip frag-off >= 33 ip frag-off <= 45
+ip frag-off != 33-45;ok;ip frag-off < 33 ip frag-off > 45
+ip frag-off { 33, 55, 67, 88};ok
+- ip frag-off != { 33, 55, 67, 88};ok
+ip frag-off { 33-55};ok
+- ip frag-off != { 33-55};ok
+
+ip ttl 0 drop;ok
+ip ttl 233 log;ok
+ip ttl 33-55;ok;ip ttl >= 33 ip ttl <= 55
+ip ttl != 45-50;ok;ip ttl < 45 ip ttl > 50
+ip ttl {43, 53, 45 };ok
+- ip ttl != {46, 56, 93 };ok
+# BUG: ip ttl != {46, 56, 93 };ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+ip ttl { 33-55};ok
+- ip ttl != { 33-55};ok
+
+ip protocol tcp log;ok;ip protocol 6 log
+ip protocol != tcp log;ok;ip protocol != 6 log
+ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept;ok;ip protocol { 33, 136, 17, 51, 50, 6, 132, 1, 108} accept
+- ip protocol != { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept;ok
+
+ip checksum 13172 drop;ok
+ip checksum 22;ok
+ip checksum != 233;ok
+ip checksum 33-45;ok;ip checksum >= 33 ip checksum <= 45
+ip checksum != 33-45;ok;ip checksum < 33 ip checksum > 45
+ip checksum { 33, 55, 67, 88};ok
+- ip checksum != { 33, 55, 67, 88};ok
+ip checksum { 33-55};ok
+- ip checksum != { 33-55};ok
+
+ip saddr 192.168.2.0/24;ok
+ip saddr != 192.168.2.0/24;ok
+ip saddr 192.168.3.1 ip daddr 192.168.3.100;ok
+ip saddr != 1.1.1.1 log prefix giuseppe;ok;ip saddr != 1.1.1.1 log prefix "giuseppe"
+ip saddr 1.1.1.1 log prefix example group 1;ok;ip saddr 1.1.1.1 log prefix "example" group 1
+ip daddr 192.168.0.1-192.168.0.250;ok;ip daddr >= 192.168.0.1 ip daddr <= 192.168.0.250
+ip daddr 10.0.0.0-10.255.255.255;ok;ip daddr >= 10.0.0.0 ip daddr <= 10.255.255.255
+ip daddr 172.16.0.0-172.31.255.255;ok;ip daddr >= 172.16.0.0 ip daddr <= 172.31.255.255
+ip daddr 192.168.3.1-192.168.4.250;ok;ip daddr >= 192.168.3.1 ip daddr <= 192.168.4.250
+ip daddr != 192.168.0.1-192.168.0.250;ok;ip daddr < 192.168.0.1 ip daddr > 192.168.0.250
+ip daddr { 192.168.0.1-192.168.0.250};ok
+- ip daddr != { 192.168.0.1-192.168.0.250};ok
+ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept;ok
+- ip daddr != { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept;ok
+
+ip daddr 192.168.1.2-192.168.1.55;ok;ip daddr >= 192.168.1.2 ip daddr <= 192.168.1.55
+ip daddr != 192.168.1.2-192.168.1.55;ok;ip daddr < 192.168.1.2 ip daddr > 192.168.1.55
+ip saddr 192.168.1.3-192.168.33.55;ok;ip saddr >= 192.168.1.3 ip saddr <= 192.168.33.55
+ip saddr != 192.168.1.3-192.168.33.55;ok;ip saddr < 192.168.1.3 ip saddr > 192.168.33.55
+
+ip daddr 192.168.0.1;ok
+ip daddr 192.168.0.1 drop;ok
+ip daddr 192.168.0.2 log;ok
diff --git a/tests/regression/ip/nat.t b/tests/regression/ip/nat.t
new file mode 100644
index 0000000..5afe823
--- /dev/null
+++ b/tests/regression/ip/nat.t
@@ -0,0 +1,18 @@
+*ip;test-ip4
+# bug: Nat tables is not supported yet in inet table.
+-*inet;test-inet
+
+:output;type nat hook output priority 0
+
+iifname eth0 tcp dport 80-90 dnat 192.168.3.2;ok;iifname "eth0" tcp dport >= 80 tcp dport <= 90 dnat 192.168.3.2
+iifname eth0 tcp dport != 80-90 dnat 192.168.3.2;ok;iifname "eth0" tcp dport < 80 tcp dport > 90 dnat 192.168.3.2
+iifname eth0 tcp dport {80, 90, 23} dnat 192.168.3.2;ok
+- iifname eth0 tcp dport != {80, 90, 23} dnat 192.168.3.2;ok
+
+iifname eth0 tcp sport 23-34 snat 192.168.3.2;ok;iifname "eth0" tcp sport >= 23 tcp sport <= 34 snat 192.168.3.2
+
+- iifname eth0 tcp dport != {80, 90, 23} dnat 192.168.3.2;ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+iifname eth0 tcp dport != 23-34 dnat 192.168.3.2;ok;iifname "eth0" tcp dport < 23 tcp dport > 34 dnat 192.168.3.2
diff --git a/tests/regression/ip/reject.t b/tests/regression/ip/reject.t
new file mode 100644
index 0000000..e7fb15b
--- /dev/null
+++ b/tests/regression/ip/reject.t
@@ -0,0 +1,5 @@
+*ip;test-ip4
+*ip;test-inet
+:output;type filter hook output priority 0
+
+reject;ok
diff --git a/tests/regression/ip/sets.t b/tests/regression/ip/sets.t
new file mode 100644
index 0000000..a74d308
--- /dev/null
+++ b/tests/regression/ip/sets.t
@@ -0,0 +1,31 @@
+*ip;test-ip4
+*inet;test-inet
+:input;type filter hook input priority 0
+
+!set_ipv4_add ipv4_addr;ok
+!set_inet inet_proto;ok
+!set_inet_serv inet_service;ok
+!set_time time;ok
+
+!set1 ipv4_addr;ok
+?set1 192.168.3.4;ok
+
+?set1 192.168.3.4;fail
+?set1 192.168.3.5 192.168.3.6;ok
+?set1 192.168.3.5 192.168.3.6;fail
+?set1 192.168.3.8 192.168.3.9;ok
+?set1 192.168.3.10 192.168.3.11;ok
+?set1 1234:1234:1234:1234:1234:1234:1234:1234;fail
+?set2 192.168.3.4;fail
+
+!set2 ipv4_addr;ok
+?set2 192.168.3.4;ok
+?set2 192.168.3.5 192.168.3.6;ok
+?set2 192.168.3.5 192.168.3.6;fail
+?set2 192.168.3.8 192.168.3.9;ok
+?set2 192.168.3.10 192.168.3.11;ok
+
+-ip saddr @set1 drop;ok
+-ip saddr @set2 drop;ok
+-ip saddr @set33 drop;fail
+-ip saddr @set21 drop;fail
-- 
1.7.10.4

