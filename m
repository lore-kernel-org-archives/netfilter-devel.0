From: Ana Rey <anarey@gmail.com>
Subject: [v3 nft 7/7] tests: Add any folder with test files.
Date: Thu, 18 Sep 2014 12:39:21 +0200
Message-ID: <1411036761-26825-8-git-send-email-anarey@gmail.com>
References: <1411036761-26825-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:45683 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbaIRKhL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2014 06:37:11 -0400
Received: by mail-we0-f175.google.com with SMTP id w61so664793wes.6
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Sep 2014 03:37:09 -0700 (PDT)
In-Reply-To: <1411036761-26825-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"any" folder contains the test files that are executed in ipv4, ipv6,
inet, arp, bridge family of tables.

These test files are executed with nft-tests.py

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/regression/any/ct.t    |  105 +++++++++++++++++++++++++++
 tests/regression/any/frag.t  |   64 +++++++++++++++++
 tests/regression/any/limit.t |   12 ++++
 tests/regression/any/log.t   |   27 +++++++
 tests/regression/any/meta.t  |  160 ++++++++++++++++++++++++++++++++++++++++++
 tests/regression/any/queue.t |   15 ++++
 6 files changed, 383 insertions(+)
 create mode 100644 tests/regression/any/ct.t
 create mode 100644 tests/regression/any/frag.t
 create mode 100644 tests/regression/any/limit.t
 create mode 100644 tests/regression/any/log.t
 create mode 100644 tests/regression/any/meta.t
 create mode 100644 tests/regression/any/queue.t

diff --git a/tests/regression/any/ct.t b/tests/regression/any/ct.t
new file mode 100644
index 0000000..7ce898d
--- /dev/null
+++ b/tests/regression/any/ct.t
@@ -0,0 +1,105 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+# ct expresion is not supported in arp and bridge family yet.
+- *arp;test-arp
+- *bridge;test-bridge
+
+:output;type filter hook output priority 0
+
+ct state new,established, related, untracked;ok;ct state established,related,new,untracked
+ct state != related;ok
+ct state {new,established, related, untracked};ok
+- ct state != {new,established, related, untracked};ok
+ct state invalid drop;ok
+ct state established accept;ok
+
+ct direction original;ok
+ct direction != original;ok
+ct direction reply;ok
+ct direction != reply;ok
+ct direction {reply, original};ok
+- ct direction != {reply, original};ok
+
+ct status expected;ok
+ct status != expected;ok
+ct status seen-reply;ok
+ct status != seen-reply;ok
+ct status {expected, seen-reply, assured, confirmed, dying};ok
+
+# SYMBOL("snat", IPS_SRC_NAT)
+# SYMBOL("dnat", IPS_DST_NAT)
+- ct status snat;ok
+- ct status dnat;ok
+
+ct mark 0;ok;ct mark 0x00000000
+ct mark or 0x23 == 0x11;ok;ct mark | 0x00000023 == 0x00000011
+ct mark or 0x3 != 0x1;ok;ct mark | 0x00000003 != 0x00000001
+ct mark and 0x23 == 0x11;ok;ct mark & 0x00000023 == 0x00000011
+ct mark and 0x3 != 0x1;ok;ct mark & 0x00000003 != 0x00000001
+ct mark xor 0x23 == 0x11;ok;ct mark 0x00000032
+ct mark xor 0x3 != 0x1;ok;ct mark != 0x00000002
+
+ct mark 0x32;ok;ct mark 0x00000032
+ct mark != 0x32;ok;ct mark != 0x00000032
+ct mark 0x32-0x45;ok;ct mark >= 0x00000032 ct mark <= 0x45000000
+ct mark != 0x32-0x43;ok;ct mark < 0x00000032 ct mark > 0x43000000
+ct mark {0x32, 0x2222, 0x42de3};ok;ct mark { 0x00042de3, 0x00002222, 0x00000032}
+- ct mark != {0x32, 0x2222, 0x42de3};ok
+
+# ct mark != {0x32, 0x2222, 0x42de3};ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+ct mark set 0x11 xor 0x1331;ok;ct mark set 0x00001320
+ct mark set 0x11333 and 0x11;ok;ct mark set 0x00000011
+ct mark set 0x12 or 0x11;ok;ct mark set 0x00000013
+ct mark set 0x11;ok;ct mark set 0x00000011
+
+ct expiration 30;ok
+ct expiration 22;ok
+ct expiration != 233;ok
+ct expiration 33-45;ok
+# BUG: ct expiration 33-45 and  ct expiration != 33-45
+# Broken output: ct expiration >= "33s" ct expiration <= "9709d53m20s"
+ct expiration != 33-45;ok
+ct expiration {33, 55, 67, 88};ok
+- ct expiration != {33, 55, 67, 88};ok
+ct expiration {33-55};ok
+# BUG: ct expiration {33-55}
+# Broken output: ct expiration { "4271d23h25m52s"-"8738d3h11m59s" }
+- ct expiration != {33-55};ok
+
+ct helper "ftp";ok
+ct helper "12345678901234567";fail
+
+# BUG: ct l3proto "Layer  3 protocol of the connection"
+# nft add rule ip test input ct l3proto arp
+# <cmdline>:1:35-37: Error: Can t parse symbolic invalid expressions
+
+
+# If table is ip6 or inet or bridge family,, It is failed. I can not test it
+# ct saddr 1.2.3.4;ok
+
+# BUG: ct saddr 192.168.3.4
+# <cmdline>:1:1-43: Error: Could not process rule: Invalid argument
+# add rule ip test input ct saddr 192.168.3.4
+# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+- ct saddr 192.168.3.4;ok
+- ct daddr 192.168.3.4;ok
+
+# BUG: ct protocol tcp
+# <cmdline>:1:1-37: Error: Could not process rule: Invalid argument
+# input ct protocol bgp <cmdline>:1:36-38: Error: Could not resolve protocol name
+# ct protocol tcp;ok
+- ct protocol tcp;ok
+
+- ct proto-src udp;ok
+- ct proto-dst udp;ok
+# BUG: ct proto-src udp and ct proto-dst udp
+# <cmdline>:1:37-39: Error: datatype mismatch, expected invalid, expression has type Internet protocol
+# add rule ip test input ct proto-src udp
+#                       ~~~~~~~~~~~~ ^^^
+# <cmdline>:1:37-39: Error: datatype mismatch, expected invalid, expression has type Internet protocol
+# add rule ip test input ct proto-dst udp
+#                        ~~~~~~~~~~~~ ^^^
diff --git a/tests/regression/any/frag.t b/tests/regression/any/frag.t
new file mode 100644
index 0000000..92caf1e
--- /dev/null
+++ b/tests/regression/any/frag.t
@@ -0,0 +1,64 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+*arp;test-arp
+*bridge;test-bridge
+:output;type filter hook output priority 0
+
+frag nexthdr tcp;ok;frag nexthdr 6
+frag nexthdr != icmp;ok;frag nexthdr != 1
+frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok;frag nexthdr { 51, 136, 132, 6, 108, 50, 17, 33}
+- frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok
+frag nexthdr esp;ok;frag nexthdr 50
+frag nexthdr ah;ok;frag nexthdr 51
+
+frag reserved 22;ok
+frag reserved != 233;ok
+frag reserved 33-45;ok;frag reserved >= 33 frag reserved <= 45
+frag reserved != 33-45;ok;frag reserved < 33 frag reserved > 45
+frag reserved { 33, 55, 67, 88};ok;frag reserved { 88, 33, 67, 55}
+- frag reserved != { 33, 55, 67, 88};ok
+frag reserved { 33-55};ok
+- frag reserved != { 33-55};ok
+
+# BUG: frag frag-off 22 and frag frag-off { 33-55}
+# This breaks table listing: "netlink: Error: Relational expression size mismatch"
+
+- frag frag-off 22;ok
+- frag frag-off != 233;ok
+- frag frag-off 33-45;ok
+- frag frag-off != 33-45;ok
+- frag frag-off { 33, 55, 67, 88};ok
+- frag frag-off != { 33, 55, 67, 88};ok
+- frag frag-off { 33-55};ok
+- frag frag-off != { 33-55};ok
+
+# BUG  frag reserved2 33 and frag reserved2 1
+# $ sudo nft add rule ip test input frag reserved2 33
+# <cmdline>:1:39-40: Error: Value 33 exceeds valid range 0-3
+# add rule ip test input frag reserved2 33
+#                                      ^^
+# sudo nft add rule ip test input frag reserved2 1
+# <cmdline>:1:1-39: Error: Could not process rule: Invalid argument
+# add rule ip test input frag reserved2 1
+# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+# BUG more-fragments 1 and frag more-fragments 4
+# frag more-fragments 1
+# <cmdline>:1:1-44: Error: Could not process rule: Invalid argument
+# add rule ip test input frag more-fragments 1
+# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+# $ sudo nft add rule ip test input frag more-fragments 4
+# <cmdline>:1:44-44: Error: Value 4 exceeds valid range 0-1
+# add rule ip test input frag more-fragments 4
+#                                           ^
+
+frag id 1;ok
+frag id 22;ok
+frag id != 33;ok
+frag id 33-45;ok;frag id >= 33 frag id <= 45
+frag id != 33-45;ok;frag id < 33 frag id > 45
+frag id { 33, 55, 67, 88};ok
+- frag id != { 33, 55, 67, 88};ok
+frag id { 33-55};ok
+- frag id != { 33-55};ok
diff --git a/tests/regression/any/limit.t b/tests/regression/any/limit.t
new file mode 100644
index 0000000..9af1ea8
--- /dev/null
+++ b/tests/regression/any/limit.t
@@ -0,0 +1,12 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+*arp;test-arp
+*bridge;test-bridge
+:output;type filter hook output priority 0
+
+limit rate 400/minute;ok
+limit rate 20/second;ok
+limit rate 400/hour;ok
+limit rate 400/week;ok
+limit rate 40/day;ok
diff --git a/tests/regression/any/log.t b/tests/regression/any/log.t
new file mode 100644
index 0000000..2bc2543
--- /dev/null
+++ b/tests/regression/any/log.t
@@ -0,0 +1,27 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+- *arp;test-arp
+- *bridge;test-bridge
+:output;type filter hook output priority 0
+
+ct direction original log;ok
+log;ok
+log level emerg;ok
+log level alert;ok
+log level crit;ok
+log level err;ok
+log level warn;ok;log
+log level notice;ok
+log level info;ok
+log level debug;ok
+
+log level emerg group 2;fail
+log level alert group 2 prefix "log test2";fail
+
+udp dport 200 log prefix aaaaa-aaaaaa group 2 snaplen 33;ok;udp dport 200 log prefix "aaaaa-aaaaaa" group 2 snaplen 33
+# TODO: Add an exception: 'queue-threshold' attribute needs 'group' attribute
+# The correct rule is log group 2 queue-threshold 2
+log group 2 queue-threshold 2;ok
+log group 2 snaplen 33;ok
+tcp dport 300 log group 2 prefix \"IPTABLES-NFT SSH\";ok;tcp dport 300 log prefix "IPTABLES-NFT SSH" group 2
diff --git a/tests/regression/any/meta.t b/tests/regression/any/meta.t
new file mode 100644
index 0000000..2c2609d
--- /dev/null
+++ b/tests/regression/any/meta.t
@@ -0,0 +1,160 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+*arp;test-arp
+*bridge;test-bridge
+
+:input;type filter hook input priority 0
+
+meta length 1000;ok
+meta length 22;ok
+meta length != 233;ok
+meta length 33-45;ok
+meta length != 33-45;ok
+meta length { 33, 55, 67, 88};ok
+- meta length != { 33, 55, 67, 88};ok
+meta length { 33-55};ok
+- meta length != { 33-55};ok
+
+meta protocol { ip, arp, ip6, vlan };ok;meta protocol { ip6, ip, vlan, arp}
+- meta protocol != {ip, arp, ip6, vlan};ok
+meta protocol ip;ok
+meta protocol != ip;ok
+
+meta nfproto ipv4;ok
+meta nfproto ipv6;ok
+meta nfproto {ipv4, ipv6};ok
+
+meta l4proto 22;ok
+meta l4proto != 233;ok
+meta l4proto 33-45;ok;meta l4proto >= 33 meta l4proto <= 45
+meta l4proto != 33-45;ok;meta l4proto < 33 meta l4proto > 45
+meta l4proto { 33, 55, 67, 88};ok;meta l4proto { 33, 55, 67, 88}
+- meta l4proto != { 33, 55, 67, 88};ok
+meta l4proto { 33-55};ok
+- meta l4proto != { 33-55};ok
+
+- meta priority :aabb;ok
+- meta priority bcad:dadc;ok
+- meta priority aabb:;ok
+- meta priority != :aabb;ok
+- meta priority != bcad:dadc;ok
+- meta priority != aabb:;ok
+- meta priority bcad:dada-bcad:dadc;ok
+- meta priority != bcad:dada-bcad:dadc;ok
+- meta priority {bcad:dada, bcad:dadc, aaaa:bbbb};ok
+- meta priority != {bcad:dada, bcad:dadc, aaaa:bbbb};ok
+
+meta mark 0x4;ok;mark 0x00000004
+meta mark 0x32;ok;mark 0x00000032
+meta mark and 0x03 == 0x01;ok;mark & 0x00000003 == 0x00000001
+meta mark and 0x03 != 0x01;ok;mark & 0x00000003 != 0x00000001
+meta mark 0x10;ok;mark 0x00000010
+meta mark != 0x10;ok;mark != 0x00000010
+
+meta mark or 0x03 == 0x01;ok;mark | 0x00000003 == 0x00000001
+meta mark or 0x03 != 0x01;ok;mark | 0x00000003 != 0x00000001
+meta mark xor 0x03 == 0x01;ok;mark 0x00000002
+meta mark xor 0x03 != 0x01;ok;mark != 0x00000002
+
+meta iif wlan0 accept;ok;iif wlan0 accept
+meta iif eth0 accept;ok;iif eth0 accept
+meta iif != wlan0 accept;ok;iif != wlan0 accept
+meta iif != eth0 accept;ok;iif != eth0 accept
+
+meta iifname "eth0";ok;iifname "eth0"
+meta iifname != "eth0";ok;iifname != "eth0"
+meta iifname {"eth0", "wlan0"};ok
+- meta iifname != {"eth0", "wlan0"};ok
+
+meta iiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
+- meta iiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
+meta iiftype != ether;ok;iiftype != ether
+meta iiftype ether;ok;iiftype ether
+meta iiftype != ppp;ok;iiftype != ppp
+meta iiftype ppp;ok;iiftype ppp
+
+meta oif lo accept;ok;oif lo accept
+meta oif != lo accept;ok;oif != lo accept
+meta oif {wlan0, eth0, lo} accept;ok
+- meta oif != {wlan0, eth0, lo} accept;ok
+
+meta oifname "eth0";ok;oifname "eth0"
+meta oifname != "eth0";ok;oifname != "eth0"
+meta oifname { "eth0", "wlan0"};ok
+- meta iifname != {"eth0", "wlan0"};ok
+
+meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
+- meta oiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
+meta oiftype != ether;ok;oiftype != ether
+meta oiftype ether;ok;oiftype ether
+
+meta skuid {man, root, backup} accept;ok;skuid { 0, 6, 34} accept
+- meta skuid != {man, root, backup} accept;ok
+meta skuid man;ok;skuid 6
+meta skuid != man;ok;skuid != 6
+meta skuid lt 3000 accept;ok;skuid < 3000 accept
+meta skuid gt 3000 accept;ok;skuid > 3000 accept
+meta skuid eq 3000 accept;ok;skuid 3000 accept
+meta skuid 3001-3005 accept;ok
+meta skuid != 2001-2005 accept;ok
+meta skuid { 2001-2005} accept;ok
+- meta skuid != { 2001-2005} accept;ok
+
+meta skgid {man, root, backup} accept;ok;skgid { 34, 12, 0} accept
+- meta skgid != {man, root, backup} accept;ok
+meta skgid man;ok;skgid 12
+meta skgid != man;ok;skgid != 12
+meta skgid lt 3000 accept;ok;skgid < 3000 accept
+meta skgid gt 3000 accept;ok;skgid > 3000 accept
+meta skgid eq 3000 accept;ok;skgid 3000 accept
+meta skgid 2001-2005 accept;ok
+meta skgid != 2001-2005 accept;ok
+meta skgid { 2001-2005} accept;ok
+- meta skgid != { 2001-2005} accept;ok
+
+# BUG: meta nftrace 2 and meta nftrace 1
+# $ sudo nft add rule ip test input meta nftrace 2
+# <cmdline>:1:37-37: Error: Value 2 exceeds valid range 0-1
+# add rule ip test input meta nftrace 2
+#                                    ^
+# $ sudo nft add rule ip test input meta nftrace 1
+# <cmdline>:1:1-37: Error: Could not process rule: Operation not supported
+# add rule ip test input meta nftrace 1
+# -^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+meta mark set 0xffffffc8 xor 0x16;ok;meta mark set 0xffffffde
+meta mark set 0x16 and 0x16;ok;meta mark set 0x00000016
+meta mark set 0xffffffe9 or 0x16;ok;meta mark set 0xffffffff
+meta mark set 0xffffffde and 0x16;ok;meta mark set 0x00000016
+meta mark set 0xf045ffde or 0x10;ok;meta mark set 0xf045ffde
+meta mark set 0xffffffde or 0x16;ok;meta mark set 0xffffffde
+meta mark set 0x32 or 0xfffff;ok;meta mark set 0x000fffff
+meta mark set 0xfffe xor 0x16;ok;meta mark set 0x0000ffe8
+
+meta iif lo;ok;iif lo
+meta oif lo;ok;oif lo
+meta oifname "eth2" accept;ok;oifname "eth2" accept
+meta skuid 3000;ok;skuid 3000
+meta skgid 3000;ok;skgid 3000
+# BUG:  meta nftrace 1;ok
+# <cmdline>:1:1-37: Error: Could not process rule: Operation not supported
+- meta nftrace 1;ok
+meta rtclassid cosmos;ok;rtclassid cosmos
+
+meta pkttype broadcast;ok;pkttype broadcast
+meta pkttype unicast;ok;pkttype unicast
+meta pkttype multicast;ok;pkttype multicast
+meta pkttype != broadcast;ok;pkttype != broadcast
+meta pkttype != unicast;ok;pkttype != unicast
+meta pkttype != multicast;ok;pkttype != multicast
+meta pkttype broadcastttt;fail
+-meta pkttype { broadcast, multicast} accept;ok
+
+meta cpu 1;ok;cpu 1
+meta cpu != 1;ok;cpu != 1
+meta cpu 1-3;ok;cpu >= 1 cpu <= 3
+# BUG: there is not matching of packets with this rule.
+meta cpu != 1-2;ok;cpu < 1 cpu > 2
+meta cpu { 2,3};ok;cpu { 2, 3}
+-meta cpu != { 2,3};ok
diff --git a/tests/regression/any/queue.t b/tests/regression/any/queue.t
new file mode 100644
index 0000000..8307411
--- /dev/null
+++ b/tests/regression/any/queue.t
@@ -0,0 +1,15 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+*arp;test-arp
+*bridge;test-bridge
+
+:output;type filter hook output priority 0
+
+queue;ok;queue num 0
+queue num 2;ok
+queue num 2-3;ok
+- queue num {3, 4, 6};ok
+queue num 4-5 fanout bypass;ok;queue num 4-5 bypass fanout
+queue num 4-5 fanout;ok
+queue num 4-5 bypass;ok
-- 
1.7.10.4

