From: Ana Rey <anarey@gmail.com>
Subject: [PATCH 4/6] [nft] tests: Add any folder with test files.
Date: Thu, 31 Jul 2014 11:08:09 +0200
Message-ID: <1406797691-1080-5-git-send-email-anarey@gmail.com>
References: <1406797691-1080-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:43740 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbaGaJIf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:08:35 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so9021162wib.9
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2014 02:08:32 -0700 (PDT)
In-Reply-To: <1406797691-1080-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"any" folder contains the test files that are executed in ipv4, ipv6,
inet, arp, bridge family of tables.

These test files are executed with nft-tests.py

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/any/ct.t    | 113 +++++++++++++++++++++++++++++++++++++++
 tests/any/frag.t  |  69 ++++++++++++++++++++++++
 tests/any/limit.t |  13 +++++
 tests/any/log.t   |  14 +++++
 tests/any/meta.t  | 157 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/any/queue.t |  15 ++++++
 6 files changed, 381 insertions(+)
 create mode 100644 tests/any/ct.t
 create mode 100644 tests/any/frag.t
 create mode 100644 tests/any/limit.t
 create mode 100644 tests/any/log.t
 create mode 100644 tests/any/meta.t
 create mode 100644 tests/any/queue.t

diff --git a/tests/any/ct.t b/tests/any/ct.t
new file mode 100644
index 0000000..e2f1f53
--- /dev/null
+++ b/tests/any/ct.t
@@ -0,0 +1,113 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+# ct expresion is not supported in arp type table yet.
+-*arp;test-arp
+-*bridge;test-bridge
+
+:output;type filter hook output priority 0
+
+ct state new,established, related, untracked;ok;ct state established,related,new,untracked
+ct state != related;ok
+ct state {new,established, related, untracked};ok
+-ct state != {new,established, related, untracked};ok
+ct state invalid drop;ok
+ct state established accept;ok
+
+ct direction original;ok
+ct direction != original;ok
+ct direction reply;ok
+ct direction != reply;ok
+ct direction {reply, original};ok
+-ct direction != {reply, original};ok
+
+ct status expected;ok
+ct status != expected;ok
+ct status seen-reply;ok
+ct status != seen-reply;ok
+ct status {expected, seen-reply, assured, confirmed, dying};ok
+
+# BUG:
+# SYMBOL("snat", IPS_SRC_NAT)
+# SYMBOL("dnat", IPS_DST_NAT),
+-ct status snat;ok
+-ct status dnat;ok
+
+ct mark 0;ok
+ct mark or 0x23 == 0x11;ok
+ct mark or 0x3 != 0x1;ok
+ct mark and 0x23 == 0x11;ok
+ct mark and 0x3 != 0x1;ok
+ct mark xor 0x23 == 0x11;ok
+ct mark xor 0x3 != 0x1;ok
+
+ct mark 0x32;ok
+ct mark != 0x32;ok
+ct mark 0x32-0x45;ok
+ct mark != 0x32-0x43;ok
+ct mark {0x32, 0x2222, 0x42de3};ok
+- ct mark != {0x32, 0x2222, 0x42de3};ok
+
+# ct mark != {0x32, 0x2222, 0x42de3};ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+ct mark set 0x11 xor 0x1331;ok
+ct mark set 0x11333 and 0x11;ok
+ct mark set 0x12 or 0x11;ok
+ct mark set 0x11;ok
+
+ct expiration 30;ok
+ct expiration 22;ok
+ct expiration != 233;ok
+ct expiration 33-45;ok
+# BUG: ct expiration 33-45;ok
+# BUG to list ct expiration >= "33s" ct expiration <= "9709d53m20s"
+ct expiration != 33-45;ok
+ct expiration {33, 55, 67, 88};ok
+-ct expiration != {33, 55, 67, 88};ok
+ct expiration {33-55};ok
+# BUG:  ct expiration {33-55};ok
+# BUG to list ct expiration { "4271d23h25m52s"-"8738d3h11m59s" }
+-ct expiration != {33-55};ok
+
+ct helper "ftp";ok
+#ct helper "12345678901234567";fail
+
+-ct l3proto ?? "Layer  3 protocol of the connection";ok
+
+# If table is ip6 or inet or bridge, It is failed. I can not test it
+-ct saddr 1.2.3.4;ok
+
+
+# ct saddr 192.168.3.4
+# <cmdline>:1:1-43: Error: Could not process rule: Invalid argument
+# add rule ip test input ct saddr 192.168.3.4
+# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+# If table is ip6 or inet or bridge, It is failed. I can not test it
+-ct daddr 1.3.4.4;ok
+
+# There is a bug in bridge and inet tables.
+# ct protocol tcp;ok
+-ct protocol tcp;ok
+
+# ct daddr x.x.x.x;ok
+# ct protocol tcp;ok
+# <cmdline>:1:1-38: Error: Could not process rule: Invalid argument
+# add rule ip test input ct protocol tcp
+# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+-ct proto-src udp;ok
+
+# ct proto-src udp
+# <cmdline>:1:37-39: Error: datatype mismatch, expected invalid, expression has type Internet protocol
+# add rule ip test input ct proto-src udp
+#                       ~~~~~~~~~~~~ ^^^
+
+-ct proto-dst udp;ok
+
+# ct proto-dst udp
+# <cmdline>:1:37-39: Error: datatype mismatch, expected invalid, expression has type Internet protocol
+# add rule ip test input ct proto-dst udp
+#                        ~~~~~~~~~~~~ ^^^
diff --git a/tests/any/frag.t b/tests/any/frag.t
new file mode 100644
index 0000000..599d26a
--- /dev/null
+++ b/tests/any/frag.t
@@ -0,0 +1,69 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+*arp;test-arp
+*bridge;test-bridge
+
+:output;type filter hook output priority 0
+
+frag nexthdr tcp;ok
+frag nexthdr != icmp;ok
+frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok
+-frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok
+frag nexthdr esp;ok
+frag nexthdr ah;ok
+
+frag reserved 22;ok
+frag reserved != 233;ok
+frag reserved 33-45;ok;frag reserved >= 33 frag reserved <= 45
+frag reserved != 33-45;ok;frag reserved < 33 frag reserved > 45
+frag reserved { 33, 55, 67, 88};ok;frag reserved { 88, 33, 67, 55}
+-frag reserved != { 33, 55, 67, 88};ok
+frag reserved { 33-55};ok
+-frag reserved != { 33-55};ok
+
+# netlink: Error: Relational expression size mismatch
+# bug: frag frag-off 22 =>
+# If we list it:
+# netlink: Error: Relational expression size mismatch
+
+frag frag-off 22;ok
+-frag frag-off 0;ok
+-frag frag-off 22;ok
+-frag frag-off != 233;ok
+-frag frag-off 33-45;ok
+-frag frag-off != 33-45;ok
+-frag frag-off { 33, 55, 67, 88};ok
+-frag frag-off != { 33, 55, 67, 88};ok
+-frag frag-off { 33-55};ok
+-frag frag-off != { 33-55};ok
+
+#BUG reserved2
+#$ sudo nft add rule ip test input frag reserved2 33
+#<cmdline>:1:39-40: Error: Value 33 exceeds valid range 0-3
+# add rule ip test input frag reserved2 33
+#                                      ^^
+#sudo nft add rule ip test input frag reserved2 1
+#<cmdline>:1:1-39: Error: Could not process rule: Invalid argument
+#add rule ip test input frag reserved2 1
+#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+# BUG more-fragments
+# frag more-fragments 1
+# <cmdline>:1:1-44: Error: Could not process rule: Invalid argument
+# add rule ip test input frag more-fragments 1
+# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+# $ sudo nft add rule ip test input frag more-fragments 4
+#<cmdline>:1:44-44: Error: Value 4 exceeds valid range 0-1
+# add rule ip test input frag more-fragments 4
+#                                           ^
+
+frag id 1;ok
+frag id 22;ok
+frag id != 33;ok
+frag id 33-45;ok;frag id >= 33 frag id <= 45
+frag id != 33-45;ok;frag id < 33 frag id > 45
+frag id { 33, 55, 67, 88};ok
+-frag id != { 33, 55, 67, 88};ok
+frag id { 33-55};ok
+-frag id != { 33-55};ok
diff --git a/tests/any/limit.t b/tests/any/limit.t
new file mode 100644
index 0000000..b2c8dfb
--- /dev/null
+++ b/tests/any/limit.t
@@ -0,0 +1,13 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+*arp;test-arp
+*bridge;test-bridge
+
+:output;type filter hook output priority 0
+
+limit rate 400/minute;ok
+limit rate 20/second;ok
+limit rate 400/hour;ok
+limit rate 400/week;ok
+limit rate 40/day;ok
diff --git a/tests/any/log.t b/tests/any/log.t
new file mode 100644
index 0000000..3bd52f8
--- /dev/null
+++ b/tests/any/log.t
@@ -0,0 +1,14 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+-*arp;test-arp
+*bridge;test-bridge
+:output;type filter hook output priority 0
+
+# Bug in bridge family
+-ct direction original log;ok
+log;ok
+udp dport 200 log group 2 prefix aaaaa-aaaaaa snaplen 33;ok
+# BUG log qthreshold
+- log qthreshold ;ok
+tcp dport 300 log group 2 prefix \"IPTABLES-NFT SSH\";ok
diff --git a/tests/any/meta.t b/tests/any/meta.t
new file mode 100644
index 0000000..76259d1
--- /dev/null
+++ b/tests/any/meta.t
@@ -0,0 +1,157 @@
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
+#meta length != 33-45;ok
+meta length { 33, 55, 67, 88};ok
+#meta length != { 33, 55, 67, 88};ok
+meta length { 33-55};ok
+# BUG to list meta length { 738197504, 553648128 }
+-meta length != { 33-55};ok
+
+-meta protocol { ip, arp, ip6, vlan };ok
+# BUG Do not list this set
+# <cmdline>:1:40-41: Evaluate
+# add rule ip test input meta protocol { ip, arp, ip6, vlan }
+
+-meta protocol != {ip, arp, ip6, vlan};ok
+-meta protocol ip;ok
+-meta protocol != ip;ok
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
+-meta l4proto != { 33, 55, 67, 88};ok
+meta l4proto { 33-55};ok
+-meta l4proto != { 33-55};ok
+
+meta priority 22;ok
+meta priority 22;ok
+meta priority != 233;ok
+meta priority 33-45;ok
+# BUG list meta priority >= 7f68:0034 meta priority <= 5500:ff7f
+
+meta priority != 33-45;ok
+meta priority { 33, 55, 67, 88};ok
+#meta priority { 4400:ff7f, 5500:ff7f, 3400:887f };ok
+-meta priority != { 33, 55, 67, 88};ok
+meta priority { 33-55};ok
+-meta priority != { 33-55};ok
+
+# mark
+meta mark 0x4;ok
+meta mark 0x32;ok
+meta mark and 0x03 == 0x01;ok
+meta mark and 0x03 != 0x01;ok
+meta mark 0x10;ok
+meta mark != 0x10;ok
+
+meta mark or 0x03 == 0x01;ok
+meta mark or 0x03 != 0x01;ok
+meta mark xor 0x03 == 0x01;ok
+meta mark xor 0x03 != 0x01;ok
+
+meta iif wlan0 accept;ok
+meta iif eth0 accept;ok
+meta iif != wlan0 accept;ok
+meta iif != eth0 accept;ok
+
+meta iifname "eth0";ok
+meta iifname != "eth0";ok
+meta iifname {"eth0", "wlan0"};ok
+- meta iifname != {"eth0", "wlan0"};ok
+# BUG to list iifname { "", "" }
+
+meta iiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
+-meta iiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
+meta iiftype != ether;ok
+meta iiftype ether;ok
+meta iiftype != ppp;ok
+meta iiftype ppp;ok
+
+meta oif lo accept;ok
+meta oif != lo accept;ok
+meta oif {wlan0, eth0, lo} accept;ok
+-meta oif != {wlan0, eth0, lo} accept;ok
+
+meta oifname "eth0";ok
+meta oifname != "eth0";ok
+meta oifname { "eth0", "wlan0"};ok
+- meta iifname != {"eth0", "wlan0"};ok
+# BUG to list iifname { "", "" }
+
+meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
+-meta oiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
+meta oiftype != ether;ok;oiftype != ether
+meta oiftype ether;ok;oiftype ether
+
+meta skuid {man, root, backup} accept;ok
+-meta skuid != {man, root, backup} accept;ok
+meta skuid man;ok;skuid man
+meta skuid != man;ok;skuid != man
+meta skuid lt 3000 accept;ok
+meta skuid gt 3000 accept;ok
+meta skuid eq 3000 accept;ok
+meta skuid 3001-3005 accept;ok;ok;skuid >= 3001 skuid <= -1123352576 accept
+# BUG to list skuid >= Debian-exim skuid <= 1761607680 accept
+- meta skuid != 2001-2005 accept;ok;skuid < 2001 skuid > -720961536 accept
+meta skuid { 2001-2005} accept;ok
+# BUG skuid { 1694498816-1778384895 } accept
+- meta skuid != { 2001-2005} accept;ok
+
+meta skgid {man, root, backup} accept;ok
+-meta skgid != {man, root, backup} accept;ok
+meta skgid man;ok;skgid man
+meta skgid != man;ok;skgid != man
+meta skgid lt 3000 accept;ok
+meta skgid gt 3000 accept;ok
+meta skgid eq 3000 accept;ok
+-meta skgid 2001-2005 accept;ok;skgid >= 2001 skgid <= 3574005760 accept
+# BUG to list skgid >= libuuid skgid <= 1761607680 accept;ok
+-meta skgid != 2001-2005 accept;ok;skgid < 2001 skgid > 3574005760 accept
+meta skgid { 2001-2005} accept;ok
+# BUG skgid { 1694498816-1778384895 } accept
+# meta skgid != { 2001-2005} accept
+
+# BUG nftrace
+# $ sudo nft add rule ip test input meta nftrace 2
+#<cmdline>:1:37-37: Error: Value 2 exceeds valid range 0-1
+#add rule ip test input meta nftrace 2
+#                                    ^
+#$ sudo nft add rule ip test input meta nftrace 1
+#<cmdline>:1:1-37: Error: Could not process rule: Operation not supported
+#add rule ip test input meta nftrace 1
+#-^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+meta rtclassid cosmos;ok;rtclassid cosmos
+
+meta mark set 0xffffffc8 xor 0x16;ok
+meta mark set 0x16 and 0x16;ok
+meta mark set 0xffffffe9 or 0x16;ok
+meta mark set 0xffffffde and 0x16;ok
+meta mark set 0xf045ffde or 0x10;ok
+meta mark set 0xffffffde or 0x16;ok
+meta mark set 0x32 or 0xfffff;ok
+meta mark set 0xfffe xor 0x16;ok
+
+meta iif lo;ok;iif lo
+meta oif lo;ok;oif lo
+meta oifname "eth2" accept;ok
+meta skuid 3000;ok;skuid 3000
+meta skgid 3000;ok;skgid 3000
+-meta nftrace 1;ok
+meta rtclassid cosmos;ok;rtclassid cosmos
diff --git a/tests/any/queue.t b/tests/any/queue.t
new file mode 100644
index 0000000..8307411
--- /dev/null
+++ b/tests/any/queue.t
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
2.0.0

