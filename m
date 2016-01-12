From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3 nft] tests/py: netdev family with ingress chain
Date: Tue, 12 Jan 2016 23:40:38 +0100
Message-ID: <1452638438-19193-3-git-send-email-pablo@netfilter.org>
References: <1452638438-19193-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55864 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767AbcALWlD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2016 17:41:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EA11E2791A7
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 23:41:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A6055DA85D
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 23:41:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5A3CBDA807
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 23:40:54 +0100 (CET)
In-Reply-To: <1452638438-19193-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/any/frag.t                     |   2 +
 tests/py/any/limit.t                    |   2 +
 tests/py/any/meta.t                     |   2 +
 tests/py/arp/arp.t                      |   2 +
 tests/py/arp/arp.t.payload.netdev       | 293 ++++++++++++++++
 tests/py/inet/ah.t                      |   2 +
 tests/py/inet/ah.t.payload.netdev       | 186 ++++++++++
 tests/py/inet/comp.t                    |   2 +
 tests/py/inet/comp.t.payload.netdev     | 107 ++++++
 tests/py/inet/dccp.t                    |   2 +
 tests/py/inet/dccp.t.payload.netdev     |  82 +++++
 tests/py/inet/esp.t                     |   2 +
 tests/py/inet/esp.t.payload.netdev      |  93 +++++
 tests/py/inet/ether-ip.t                |   2 +
 tests/py/inet/ether-ip.t.payload.netdev |  44 +++
 tests/py/inet/ether.t                   |   2 +
 tests/py/inet/ip.t                      |   2 +
 tests/py/inet/ip.t.payload.netdev       |  14 +
 tests/py/inet/sctp.t                    |   2 +
 tests/py/inet/sctp.t.payload.netdev     | 200 +++++++++++
 tests/py/inet/tcp.t                     |   2 +
 tests/py/inet/tcp.t.payload.netdev      | 507 +++++++++++++++++++++++++++
 tests/py/inet/udp.t                     |   2 +
 tests/py/inet/udp.t.payload.netdev      | 222 ++++++++++++
 tests/py/inet/udplite.t                 |   2 +
 tests/py/inet/udplite.t.payload.netdev  | 169 +++++++++
 tests/py/ip/ip.t                        |   2 +
 tests/py/ip/ip.t.payload.netdev         | 600 ++++++++++++++++++++++++++++++++
 tests/py/ip/sets.t                      |   2 +
 tests/py/ip/sets.t.payload.netdev       |  16 +
 tests/py/ip6/sets.t                     |   2 +
 tests/py/ip6/sets.t.payload.netdev      |   8 +
 tests/py/ip6/vmap.t                     |   2 +
 tests/py/ip6/vmap.t.payload.netdev      | 420 ++++++++++++++++++++++
 34 files changed, 2999 insertions(+)
 create mode 100644 tests/py/arp/arp.t.payload.netdev
 create mode 100644 tests/py/inet/ah.t.payload.netdev
 create mode 100644 tests/py/inet/comp.t.payload.netdev
 create mode 100644 tests/py/inet/dccp.t.payload.netdev
 create mode 100644 tests/py/inet/esp.t.payload.netdev
 create mode 100644 tests/py/inet/ether-ip.t.payload.netdev
 create mode 100644 tests/py/inet/ip.t.payload.netdev
 create mode 100644 tests/py/inet/sctp.t.payload.netdev
 create mode 100644 tests/py/inet/tcp.t.payload.netdev
 create mode 100644 tests/py/inet/udp.t.payload.netdev
 create mode 100644 tests/py/inet/udplite.t.payload.netdev
 create mode 100644 tests/py/ip/ip.t.payload.netdev
 create mode 100644 tests/py/ip/sets.t.payload.netdev
 create mode 100644 tests/py/ip6/sets.t.payload.netdev
 create mode 100644 tests/py/ip6/vmap.t.payload.netdev

diff --git a/tests/py/any/frag.t b/tests/py/any/frag.t
index 9138637..8b5e34a 100644
--- a/tests/py/any/frag.t
+++ b/tests/py/any/frag.t
@@ -1,10 +1,12 @@
 :output;type filter hook output priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;output
 *ip6;test-ip6;output
 *inet;test-inet;output
 *arp;test-arp;output
 *bridge;test-bridge;output
+*netdev;test-netdev;ingress
 
 frag nexthdr tcp;ok;frag nexthdr 6
 frag nexthdr != icmp;ok;frag nexthdr != 1
diff --git a/tests/py/any/limit.t b/tests/py/any/limit.t
index 2dcab81..358b5ab 100644
--- a/tests/py/any/limit.t
+++ b/tests/py/any/limit.t
@@ -1,10 +1,12 @@
 :output;type filter hook output priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;output
 *ip6;test-ip6;output
 *inet;test-inet;output
 *arp;test-arp;output
 *bridge;test-bridge;output
+*netdev;test-netdev;ingress
 
 limit rate 400/minute;ok
 limit rate 20/second;ok
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 245f0ec..c10297a 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -1,10 +1,12 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
 *arp;test-arp;input
 *bridge;test-bridge;input
+*netdev;test-netdev;ingress
 
 meta length 1000;ok
 meta length 22;ok
diff --git a/tests/py/arp/arp.t b/tests/py/arp/arp.t
index 06b0fe3..70f9a9c 100644
--- a/tests/py/arp/arp.t
+++ b/tests/py/arp/arp.t
@@ -1,7 +1,9 @@
 # filter chains available are: input, output, forward
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *arp;test-arp;input
+*netdev;test-netdev;ingress
 
 arp htype 1;ok
 arp htype != 1;ok
diff --git a/tests/py/arp/arp.t.payload.netdev b/tests/py/arp/arp.t.payload.netdev
new file mode 100644
index 0000000..2085dde
--- /dev/null
+++ b/tests/py/arp/arp.t.payload.netdev
@@ -0,0 +1,293 @@
+# arp htype 1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000100 ]
+
+# arp htype != 1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000100 ]
+
+# arp htype 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# arp htype != 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# arp htype 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# arp htype != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# arp htype { 33, 55, 67, 88}
+set%d test-netdev 3
+set%d test-netdev 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# arp htype { 33-55}
+set%d test-netdev 7
+set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# arp ptype 0x0800
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+
+# arp hlen 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 4 => reg 1 ]
+  [ cmp eq reg 1 0x00000016 ]
+
+# arp hlen != 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 4 => reg 1 ]
+  [ cmp neq reg 1 0x000000e9 ]
+
+# arp hlen 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 4 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x0000002d ]
+
+# arp hlen != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 4 => reg 1 ]
+  [ cmp lt reg 1 0x00000021 ]
+  [ cmp gt reg 1 0x0000002d ]
+
+# arp hlen { 33, 55, 67, 88}
+set%d test-netdev 3
+set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# arp hlen { 33-55}
+set%d test-netdev 7
+set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# arp plen 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 5 => reg 1 ]
+  [ cmp eq reg 1 0x00000016 ]
+
+# arp plen != 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 5 => reg 1 ]
+  [ cmp neq reg 1 0x000000e9 ]
+
+# arp plen 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 5 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x0000002d ]
+
+# arp plen != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 5 => reg 1 ]
+  [ cmp lt reg 1 0x00000021 ]
+  [ cmp gt reg 1 0x0000002d ]
+
+# arp plen { 33, 55, 67, 88}
+set%d test-netdev 3
+set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 5 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# arp plen { 33-55}
+set%d test-netdev 7
+set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 5 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request}
+set%d test-netdev 3
+set%d test-netdev 0
+	element 00000a00  : 0 [end]	element 00000900  : 0 [end]	element 00000800  : 0 [end]	element 00000400  : 0 [end]	element 00000300  : 0 [end]	element 00000200  : 0 [end]	element 00000100  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# arp operation request
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000100 ]
+
+# arp operation reply
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000200 ]
+
+# arp operation rrequest
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000300 ]
+
+# arp operation rreply
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000400 ]
+
+# arp operation inrequest
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000800 ]
+
+# arp operation inreply
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000900 ]
+
+# arp operation nak
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000a00 ]
+
+# arp operation reply
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000200 ]
+
+# arp operation != request
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp neq reg 1 0x00000100 ]
+
+# arp operation != reply
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp neq reg 1 0x00000200 ]
+
+# arp operation != rrequest
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp neq reg 1 0x00000300 ]
+
+# arp operation != rreply
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp neq reg 1 0x00000400 ]
+
+# arp operation != inrequest
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp neq reg 1 0x00000800 ]
+
+# arp operation != inreply
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp neq reg 1 0x00000900 ]
+
+# arp operation != nak
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp neq reg 1 0x00000a00 ]
+
+# arp operation != reply
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp neq reg 1 0x00000200 ]
+
diff --git a/tests/py/inet/ah.t b/tests/py/inet/ah.t
index f3848b7..ef52c2c 100644
--- a/tests/py/inet/ah.t
+++ b/tests/py/inet/ah.t
@@ -1,8 +1,10 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
+*netdev;test-netdev;ingress
 
 # nexthdr Bug to list table.
 
diff --git a/tests/py/inet/ah.t.payload.netdev b/tests/py/inet/ah.t.payload.netdev
new file mode 100644
index 0000000..85c3528
--- /dev/null
+++ b/tests/py/inet/ah.t.payload.netdev
@@ -0,0 +1,186 @@
+# ah hdrlength 11-23
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ cmp gte reg 1 0x0000000b ]
+  [ cmp lte reg 1 0x00000017 ]
+
+# ah hdrlength != 11-23
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ cmp lt reg 1 0x0000000b ]
+  [ cmp gt reg 1 0x00000017 ]
+
+# ah hdrlength { 11-23}
+set%d test-netdev 7
+set%d test-netdev 0
+	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ah hdrlength {11, 23, 44 }
+set%d test-netdev 3
+set%d test-netdev 0
+	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ah reserved 22
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ah reserved != 233
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# ah reserved 33-45
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# ah reserved != 33-45
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# ah reserved {23, 100}
+set%d test-netdev 3
+set%d test-netdev 0
+	element 00001700  : 0 [end]	element 00006400  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ah reserved { 33-55}
+set%d test-netdev 7
+set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ah spi 111
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp eq reg 1 0x6f000000 ]
+
+# ah spi != 111
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp neq reg 1 0x6f000000 ]
+
+# ah spi 111-222
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp gte reg 1 0x6f000000 ]
+  [ cmp lte reg 1 0xde000000 ]
+
+# ah spi != 111-222
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp lt reg 1 0x6f000000 ]
+  [ cmp gt reg 1 0xde000000 ]
+
+# ah spi {111, 122}
+set%d test-netdev 3
+set%d test-netdev 0
+	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ah spi { 111-122}
+set%d test-netdev 7
+set%d test-netdev 0
+	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ah sequence 123
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x7b000000 ]
+
+# ah sequence != 123
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ cmp neq reg 1 0x7b000000 ]
+
+# ah sequence {23, 25, 33}
+set%d test-netdev 3
+set%d test-netdev 0
+	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ah sequence { 23-33}
+set%d test-netdev 7
+set%d test-netdev 0
+	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ah sequence 23-33
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ cmp gte reg 1 0x17000000 ]
+  [ cmp lte reg 1 0x21000000 ]
+
+# ah sequence != 23-33
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ cmp lt reg 1 0x17000000 ]
+  [ cmp gt reg 1 0x21000000 ]
+
diff --git a/tests/py/inet/comp.t b/tests/py/inet/comp.t
index 6396ff3..654e712 100644
--- a/tests/py/inet/comp.t
+++ b/tests/py/inet/comp.t
@@ -1,8 +1,10 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
+*netdev;test-netdev;ingress
 
 # BUG: nft: payload.c:88: payload_expr_pctx_update: Assertion `left->payload.base + 1 <= (__PROTO_BASE_MAX - 1)' failed.
 - comp nexthdr esp;ok;comp nexthdr 50
diff --git a/tests/py/inet/comp.t.payload.netdev b/tests/py/inet/comp.t.payload.netdev
new file mode 100644
index 0000000..c00bcc7
--- /dev/null
+++ b/tests/py/inet/comp.t.payload.netdev
@@ -0,0 +1,107 @@
+# comp nexthdr != esp
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000032 ]
+
+# comp flags 0x0
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# comp flags != 0x23
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ cmp neq reg 1 0x00000023 ]
+
+# comp flags 0x33-0x45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ cmp gte reg 1 0x00000033 ]
+  [ cmp lte reg 1 0x00000045 ]
+
+# comp flags != 0x33-0x45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ cmp lt reg 1 0x00000033 ]
+  [ cmp gt reg 1 0x00000045 ]
+
+# comp flags {0x33, 0x55, 0x67, 0x88}
+set%d test-inet 3
+set%d test-inet 0
+	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# comp flags { 0x33-0x55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# comp cpi 22
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# comp cpi != 233
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# comp cpi 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# comp cpi != 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# comp cpi {33, 55, 67, 88}
+set%d test-inet 3
+set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# comp cpi { 33-55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
diff --git a/tests/py/inet/dccp.t b/tests/py/inet/dccp.t
index 63de1c8..4eef58f 100644
--- a/tests/py/inet/dccp.t
+++ b/tests/py/inet/dccp.t
@@ -1,8 +1,10 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
+*netdev;test-netdev;ingress
 
 dccp sport 21-35;ok
 dccp sport != 21-35;ok
diff --git a/tests/py/inet/dccp.t.payload.netdev b/tests/py/inet/dccp.t.payload.netdev
new file mode 100644
index 0000000..ecd8863
--- /dev/null
+++ b/tests/py/inet/dccp.t.payload.netdev
@@ -0,0 +1,82 @@
+# dccp sport 21-35
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp gte reg 1 0x00001500 ]
+  [ cmp lte reg 1 0x00002300 ]
+
+# dccp sport != 21-35
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp lt reg 1 0x00001500 ]
+  [ cmp gt reg 1 0x00002300 ]
+
+# dccp sport {23, 24, 25}
+set%d test-inet 3
+set%d test-inet 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# dccp sport { 20-50 }
+set%d test-ip4 7
+set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# dccp sport ftp-data - re-mail-ck
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp gte reg 1 0x00001400 ]
+  [ cmp lte reg 1 0x00003200 ]
+
+# dccp sport 20-50
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp gte reg 1 0x00001400 ]
+  [ cmp lte reg 1 0x00003200 ]
+
+# dccp sport { 20-50}
+set%d test-ip4 7
+set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# dccp dport {23, 24, 25}
+set%d test-ip4 3
+set%d test-ip4 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# dccp dport { 20-50}
+set%d test-ip4 7
+set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
diff --git a/tests/py/inet/esp.t b/tests/py/inet/esp.t
index 105acb2..f822da7 100644
--- a/tests/py/inet/esp.t
+++ b/tests/py/inet/esp.t
@@ -1,8 +1,10 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
+*netdev;test-netdev;ingress
 
 esp spi 100;ok
 esp spi != 100;ok
diff --git a/tests/py/inet/esp.t.payload.netdev b/tests/py/inet/esp.t.payload.netdev
new file mode 100644
index 0000000..4ba9ea8
--- /dev/null
+++ b/tests/py/inet/esp.t.payload.netdev
@@ -0,0 +1,93 @@
+# esp spi 100
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x64000000 ]
+
+# esp spi != 100
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ cmp neq reg 1 0x64000000 ]
+
+# esp spi 111-222
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ cmp gte reg 1 0x6f000000 ]
+  [ cmp lte reg 1 0xde000000 ]
+
+# esp spi != 111-222
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ cmp lt reg 1 0x6f000000 ]
+  [ cmp gt reg 1 0xde000000 ]
+
+# esp spi { 100, 102}
+set%d test-inet 3
+set%d test-inet 0
+	element 64000000  : 0 [end]	element 66000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# esp spi { 100-102}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# esp sequence 22
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# esp sequence 22-24
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp gte reg 1 0x16000000 ]
+  [ cmp lte reg 1 0x18000000 ]
+
+# esp sequence != 22-24
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp lt reg 1 0x16000000 ]
+  [ cmp gt reg 1 0x18000000 ]
+
+# esp sequence { 22, 24}
+set%d test-inet 3
+set%d test-inet 0
+	element 16000000  : 0 [end]	element 18000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# esp sequence { 22-25}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
diff --git a/tests/py/inet/ether-ip.t b/tests/py/inet/ether-ip.t
index a451588..0c8c7f9 100644
--- a/tests/py/inet/ether-ip.t
+++ b/tests/py/inet/ether-ip.t
@@ -1,6 +1,8 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *inet;test-inet;input
+*netdev;test-netdev;ingress
 
 tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept
 tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04;ok
diff --git a/tests/py/inet/ether-ip.t.payload.netdev b/tests/py/inet/ether-ip.t.payload.netdev
new file mode 100644
index 0000000..16b0921
--- /dev/null
+++ b/tests/py/inet/ether-ip.t.payload.netdev
@@ -0,0 +1,44 @@
+# tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 6b @ link header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+
+# tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 6b @ link header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+
+# tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 8b @ link header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0c540f00 0x00080411 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+  [ immediate reg 0 accept ]
+
diff --git a/tests/py/inet/ether.t b/tests/py/inet/ether.t
index 1659a30..0a88aef 100644
--- a/tests/py/inet/ether.t
+++ b/tests/py/inet/ether.t
@@ -1,9 +1,11 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
 *bridge;test-bridge;input
+*netdev;test-netdev;ingress
 
 tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 meta nfproto ipv4 accept;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 meta nfproto ipv4 accept
 tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept
diff --git a/tests/py/inet/ip.t b/tests/py/inet/ip.t
index ffcb47e..4eb69d7 100644
--- a/tests/py/inet/ip.t
+++ b/tests/py/inet/ip.t
@@ -1,7 +1,9 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;input
 *inet;test-inet;input
 *bridge;test-bridge;input
+*netdev;test-netdev;ingress
 
 ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe };ok
diff --git a/tests/py/inet/ip.t.payload.netdev b/tests/py/inet/ip.t.payload.netdev
new file mode 100644
index 0000000..f278f5b
--- /dev/null
+++ b/tests/py/inet/ip.t.payload.netdev
@@ -0,0 +1,14 @@
+# ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
+set%d test-netdev 3
+set%d test-netdev 0
+	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ payload load 6b @ link header + 6 => reg 10 ]
+  [ lookup reg 1 set set%d ]
+
diff --git a/tests/py/inet/sctp.t b/tests/py/inet/sctp.t
index 75c58b8..9f522b4 100644
--- a/tests/py/inet/sctp.t
+++ b/tests/py/inet/sctp.t
@@ -1,8 +1,10 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
+*netdev;test-netdev;ingress
 
 sctp sport 23;ok
 sctp sport != 23;ok
diff --git a/tests/py/inet/sctp.t.payload.netdev b/tests/py/inet/sctp.t.payload.netdev
new file mode 100644
index 0000000..dd6e275
--- /dev/null
+++ b/tests/py/inet/sctp.t.payload.netdev
@@ -0,0 +1,200 @@
+# sctp sport 23
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00001700 ]
+
+# sctp sport != 23
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00001700 ]
+
+# sctp sport 23-44
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp gte reg 1 0x00001700 ]
+  [ cmp lte reg 1 0x00002c00 ]
+
+# sctp sport != 23-44
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp lt reg 1 0x00001700 ]
+  [ cmp gt reg 1 0x00002c00 ]
+
+# sctp sport { 23, 24, 25}
+set%d test-inet 3
+set%d test-inet 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# sctp sport { 23-44}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# sctp dport 23
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001700 ]
+
+# sctp dport != 23
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp neq reg 1 0x00001700 ]
+
+# sctp dport 23-44
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp gte reg 1 0x00001700 ]
+  [ cmp lte reg 1 0x00002c00 ]
+
+# sctp dport != 23-44
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp lt reg 1 0x00001700 ]
+  [ cmp gt reg 1 0x00002c00 ]
+
+# sctp dport { 23, 24, 25}
+set%d test-inet 3
+set%d test-inet 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# sctp dport { 23-44}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# sctp checksum 1111
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x57040000 ]
+
+# sctp checksum != 11
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ cmp neq reg 1 0x0b000000 ]
+
+# sctp checksum 21-333
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ cmp gte reg 1 0x15000000 ]
+  [ cmp lte reg 1 0x4d010000 ]
+
+# sctp checksum != 32-111
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ cmp lt reg 1 0x20000000 ]
+  [ cmp gt reg 1 0x6f000000 ]
+
+# sctp checksum { 22, 33, 44}
+set%d test-inet 3
+set%d test-inet 0
+	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# sctp checksum { 22-44}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# sctp vtag 22
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# sctp vtag != 233
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp neq reg 1 0xe9000000 ]
+
+# sctp vtag 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# sctp vtag != 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp lt reg 1 0x21000000 ]
+  [ cmp gt reg 1 0x2d000000 ]
+
+# sctp vtag {33, 55, 67, 88}
+set%d test-inet 3
+set%d test-inet 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# sctp vtag { 33-55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index 4a147bc..f99035e 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -1,8 +1,10 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
+*netdev;test-netdev;ingress
 
 tcp dport 22;ok
 tcp dport != 233;ok
diff --git a/tests/py/inet/tcp.t.payload.netdev b/tests/py/inet/tcp.t.payload.netdev
new file mode 100644
index 0000000..6a319df
--- /dev/null
+++ b/tests/py/inet/tcp.t.payload.netdev
@@ -0,0 +1,507 @@
+# tcp dport 22
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# tcp dport != 233
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# tcp dport 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# tcp dport != 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# tcp dport { 33, 55, 67, 88}
+set%d test-inet 3
+set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp dport { 33-55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp dport {telnet, http, https} accept
+set%d test-inet 3
+set%d test-inet 0
+	element 00001700  : 0 [end]	element 00005000  : 0 [end]	element 0000bb01  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 accept ]
+
+# tcp dport vmap { 22 : accept, 23 : drop }
+map%d test-inet b
+map%d test-inet 0
+	element 00001600  : 0 [end]	element 00001700  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# tcp dport vmap { 25:accept, 28:drop }
+map%d test-inet b
+map%d test-inet 0
+	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# tcp dport { 22, 53, 80, 110 }
+set%d test-inet 3
+set%d test-inet 0
+	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp sport 22
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# tcp sport != 233
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# tcp sport 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# tcp sport != 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# tcp sport { 33, 55, 67, 88}
+set%d test-inet 3
+set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp sport { 33-55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp sport vmap { 25:accept, 28:drop }
+map%d test-inet b
+map%d test-inet 0
+	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# tcp sport 8080 drop
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x0000901f ]
+  [ immediate reg 0 drop ]
+
+# tcp sport 1024 tcp dport 22
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x16000004 ]
+
+# tcp sport 1024 tcp dport 22 tcp sequence 0
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 8b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x16000004 0x00000000 ]
+
+# tcp sequence 0 tcp sport 1024 tcp dport 22
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 8b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x16000004 0x00000000 ]
+
+# tcp sequence 0 tcp sport { 1024, 1022} tcp dport 22
+set%d test-inet 3
+set%d test-inet 0
+	element 00000004  : 0 [end]	element 0000fe03  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ payload load 6b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 0x00000000 ]
+
+# tcp sequence 22
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# tcp sequence != 233
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp neq reg 1 0xe9000000 ]
+
+# tcp sequence 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# tcp sequence != 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp lt reg 1 0x21000000 ]
+  [ cmp gt reg 1 0x2d000000 ]
+
+# tcp sequence { 33, 55, 67, 88}
+set%d test-inet 3
+set%d test-inet 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp sequence { 33-55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp ackseq 42949672 drop
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x285c8f02 ]
+  [ immediate reg 0 drop ]
+
+# tcp ackseq 22
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# tcp ackseq != 233
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ cmp neq reg 1 0xe9000000 ]
+
+# tcp ackseq 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# tcp ackseq != 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ cmp lt reg 1 0x21000000 ]
+  [ cmp gt reg 1 0x2d000000 ]
+
+# tcp ackseq { 33, 55, 67, 88}
+set%d test-inet 3
+set%d test-inet 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp ackseq { 33-55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
+set%d test-inet 3
+set%d test-inet 0
+	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000008  : 0 [end]	element 00000010  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 drop ]
+
+# tcp flags cwr
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000080 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
+# tcp flags != cwr
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ cmp neq reg 1 0x00000080 ]
+
+# tcp window 22222
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ cmp eq reg 1 0x0000ce56 ]
+
+# tcp window 22
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# tcp window != 233
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# tcp window 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# tcp window != 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# tcp window { 33, 55, 67, 88}
+set%d test-inet 3
+set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp window { 33-55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp checksum 23456 drop
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x0000a05b ]
+  [ immediate reg 0 drop ]
+
+# tcp checksum 22
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# tcp checksum != 233
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# tcp checksum 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# tcp checksum != 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# tcp checksum { 33, 55, 67, 88}
+set%d test-inet 3
+set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp checksum { 33-55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp urgptr 1234 accept
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ cmp eq reg 1 0x0000d204 ]
+  [ immediate reg 0 accept ]
+
+# tcp urgptr 22
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# tcp urgptr != 233
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# tcp urgptr 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# tcp urgptr != 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# tcp urgptr { 33, 55, 67, 88}
+set%d test-inet 3
+set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp urgptr { 33-55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# tcp doff 8
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 12 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000080 ]
+
diff --git a/tests/py/inet/udp.t b/tests/py/inet/udp.t
index d5b8653..8cff2c6 100644
--- a/tests/py/inet/udp.t
+++ b/tests/py/inet/udp.t
@@ -1,8 +1,10 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
+*netdev;test-netdev;ingress
 
 udp sport 80 accept;ok
 udp sport != 60 accept;ok
diff --git a/tests/py/inet/udp.t.payload.netdev b/tests/py/inet/udp.t.payload.netdev
new file mode 100644
index 0000000..918aca6
--- /dev/null
+++ b/tests/py/inet/udp.t.payload.netdev
@@ -0,0 +1,222 @@
+# udp sport 80 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00005000 ]
+  [ immediate reg 0 accept ]
+
+# udp sport != 60 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udp sport 50-70 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp gte reg 1 0x00003200 ]
+  [ cmp lte reg 1 0x00004600 ]
+  [ immediate reg 0 accept ]
+
+# udp sport != 50-60 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp lt reg 1 0x00003200 ]
+  [ cmp gt reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udp sport { 49, 50} drop
+set%d test-inet 3
+set%d test-inet 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 drop ]
+
+# udp sport { 12-40}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# udp dport 80 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00005000 ]
+  [ immediate reg 0 accept ]
+
+# udp dport != 60 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp neq reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udp dport 70-75 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp gte reg 1 0x00004600 ]
+  [ cmp lte reg 1 0x00004b00 ]
+  [ immediate reg 0 accept ]
+
+# udp dport != 50-60 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp lt reg 1 0x00003200 ]
+  [ cmp gt reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udp dport { 49, 50} drop
+set%d test-inet 3
+set%d test-inet 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 drop ]
+
+# udp dport { 70-75} accept
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 accept ]
+
+# udp length 6666
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ cmp eq reg 1 0x00000a1a ]
+
+# udp length != 6666
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ cmp neq reg 1 0x00000a1a ]
+
+# udp length 50-65 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ cmp gte reg 1 0x00003200 ]
+  [ cmp lte reg 1 0x00004100 ]
+  [ immediate reg 0 accept ]
+
+# udp length != 50-65 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ cmp lt reg 1 0x00003200 ]
+  [ cmp gt reg 1 0x00004100 ]
+  [ immediate reg 0 accept ]
+
+# udp length { 50, 65} accept
+set%d test-inet 3
+set%d test-inet 0
+	element 00003200  : 0 [end]	element 00004100  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 accept ]
+
+# udp length { 35-50}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# udp checksum 6666 drop
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000a1a ]
+  [ immediate reg 0 drop ]
+
+# udp checksum 22
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# udp checksum != 233
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# udp checksum 33-45
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# udp checksum != 33-45
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# udp checksum { 33, 55, 67, 88}
+set%d test-inet 3
+set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# udp checksum { 33-55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
diff --git a/tests/py/inet/udplite.t b/tests/py/inet/udplite.t
index ba01f67..2800036 100644
--- a/tests/py/inet/udplite.t
+++ b/tests/py/inet/udplite.t
@@ -1,8 +1,10 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
+*netdev;test-netdev;ingress
 
 udplite sport 80 accept;ok
 udplite sport != 60 accept;ok
diff --git a/tests/py/inet/udplite.t.payload.netdev b/tests/py/inet/udplite.t.payload.netdev
new file mode 100644
index 0000000..4c57239
--- /dev/null
+++ b/tests/py/inet/udplite.t.payload.netdev
@@ -0,0 +1,169 @@
+# udplite sport 80 accept
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00005000 ]
+  [ immediate reg 0 accept ]
+
+# udplite sport != 60 accept
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udplite sport 50-70 accept
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp gte reg 1 0x00003200 ]
+  [ cmp lte reg 1 0x00004600 ]
+  [ immediate reg 0 accept ]
+
+# udplite sport != 50-60 accept
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp lt reg 1 0x00003200 ]
+  [ cmp gt reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udplite sport { 49, 50} drop
+set%d test-ip4 3
+set%d test-ip4 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 drop ]
+
+# udplite sport { 12-40}
+set%d test-ip4 7
+set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# udplite dport 80 accept
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00005000 ]
+  [ immediate reg 0 accept ]
+
+# udplite dport != 60 accept
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp neq reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udplite dport 70-75 accept
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp gte reg 1 0x00004600 ]
+  [ cmp lte reg 1 0x00004b00 ]
+  [ immediate reg 0 accept ]
+
+# udplite dport != 50-60 accept
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp lt reg 1 0x00003200 ]
+  [ cmp gt reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udplite dport { 49, 50} drop
+set%d test-ip4 3
+set%d test-ip4 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 drop ]
+
+# udplite dport { 70-75} accept
+set%d test-ip4 7
+set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 accept ]
+
+# udplite checksum 6666 drop
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000a1a ]
+  [ immediate reg 0 drop ]
+
+# udplite checksum 22
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# udplite checksum != 233
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# udplite checksum 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# udplite checksum != 33-45
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# udplite checksum { 33, 55, 67, 88}
+set%d test-ip4 3
+set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# udplite checksum { 33-55}
+set%d test-ip4 7
+set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index bb4198a..6dd8fe6 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -1,7 +1,9 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;input
 *inet;test-inet;input
+*netdev;test-netdev;ingress
 
 - ip version 2;ok
 
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
new file mode 100644
index 0000000..90d6cc8
--- /dev/null
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -0,0 +1,600 @@
+# ip length 232
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x0000e800 ]
+
+# ip length != 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 2 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# ip length 333-435
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 2 => reg 1 ]
+  [ cmp gte reg 1 0x00004d01 ]
+  [ cmp lte reg 1 0x0000b301 ]
+
+# ip length != 333-453
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 2 => reg 1 ]
+  [ cmp lt reg 1 0x00004d01 ]
+  [ cmp gt reg 1 0x0000c501 ]
+
+# ip length { 333, 553, 673, 838}
+set%d test-netdev 3
+set%d test-netdev 0
+	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ip length { 333-535}
+set%d test-netdev 7
+set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ip id 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip id != 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# ip id 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# ip id != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# ip id { 33, 55, 67, 88}
+set%d test-netdev 3
+set%d test-netdev 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ip id { 33-55}
+set%d test-netdev 7
+set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ip frag-off 222 accept
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000de00 ]
+  [ immediate reg 0 accept ]
+
+# ip frag-off != 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# ip frag-off 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# ip frag-off != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# ip frag-off { 33, 55, 67, 88}
+set%d test-netdev 3
+set%d test-netdev 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ip frag-off { 33-55}
+set%d test-netdev 7
+set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ip ttl 0 drop
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+  [ immediate reg 0 drop ]
+
+# ip ttl 33-55
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x00000037 ]
+
+# ip ttl != 45-50
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ cmp lt reg 1 0x0000002d ]
+  [ cmp gt reg 1 0x00000032 ]
+
+# ip ttl {43, 53, 45 }
+set%d test-netdev 3
+set%d test-netdev 0
+	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ip ttl { 33-55}
+set%d test-netdev 7
+set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
+set%d test-netdev 3
+set%d test-netdev 0
+	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 accept ]
+
+# ip checksum 13172 drop
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 10 => reg 1 ]
+  [ cmp eq reg 1 0x00007433 ]
+  [ immediate reg 0 drop ]
+
+# ip checksum 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 10 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip checksum != 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 10 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# ip checksum 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 10 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# ip checksum != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 10 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# ip checksum { 33, 55, 67, 88}
+set%d test-netdev 3
+set%d test-netdev 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 10 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ip checksum { 33-55}
+set%d test-netdev 7
+set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 10 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ip saddr 192.168.2.0/24
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0002a8c0 ]
+
+# ip saddr != 192.168.2.0/24
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x0002a8c0 ]
+
+# ip saddr 192.168.3.1 ip daddr 192.168.3.100
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 8b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0103a8c0 0x6403a8c0 ]
+
+# ip saddr 1.1.1.1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x01010101 ]
+
+# ip daddr 192.168.0.1-192.168.0.250
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp gte reg 1 0x0100a8c0 ]
+  [ cmp lte reg 1 0xfa00a8c0 ]
+
+# ip daddr 10.0.0.0-10.255.255.255
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp gte reg 1 0x0000000a ]
+  [ cmp lte reg 1 0xffffff0a ]
+
+# ip daddr 172.16.0.0-172.31.255.255
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp gte reg 1 0x000010ac ]
+  [ cmp lte reg 1 0xffff1fac ]
+
+# ip daddr 192.168.3.1-192.168.4.250
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp gte reg 1 0x0103a8c0 ]
+  [ cmp lte reg 1 0xfa04a8c0 ]
+
+# ip daddr != 192.168.0.1-192.168.0.250
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp lt reg 1 0x0100a8c0 ]
+  [ cmp gt reg 1 0xfa00a8c0 ]
+
+# ip daddr { 192.168.0.1-192.168.0.250}
+set%d test-netdev 7
+set%d test-netdev 0
+	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
+set%d test-netdev 3
+set%d test-netdev 0
+	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 accept ]
+
+# ip daddr 192.168.1.2-192.168.1.55
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp gte reg 1 0x0201a8c0 ]
+  [ cmp lte reg 1 0x3701a8c0 ]
+
+# ip daddr != 192.168.1.2-192.168.1.55
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp lt reg 1 0x0201a8c0 ]
+  [ cmp gt reg 1 0x3701a8c0 ]
+
+# ip saddr 192.168.1.3-192.168.33.55
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp gte reg 1 0x0301a8c0 ]
+  [ cmp lte reg 1 0x3721a8c0 ]
+
+# ip saddr != 192.168.1.3-192.168.33.55
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp lt reg 1 0x0301a8c0 ]
+  [ cmp gt reg 1 0x3721a8c0 ]
+
+# ip daddr 192.168.0.1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x0100a8c0 ]
+
+# ip daddr 192.168.0.1 drop
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x0100a8c0 ]
+  [ immediate reg 0 drop ]
+
+# ip saddr \& 0xff == 1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0xff000000 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# ip saddr \& 0.0.0.255 \< 0.0.0.127
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0xff000000 ) ^ 0x00000000 ]
+  [ cmp lt reg 1 0x7f000000 ]
+
+# ip saddr \& 0xffff0000 == 0xffff0000
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000ffff ]
+
+# ip version 4 ip hdrlength 5
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000040 ]
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000005 ]
+
+# ip hdrlength 0
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# ip hdrlength 15
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000000f ]
+
+# ip ttl 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x000000e9 ]
+
+# ip protocol tcp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# ip protocol != tcp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp neq reg 1 0x00000006 ]
+
+# ip saddr != 1.1.1.1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp neq reg 1 0x01010101 ]
+
+# ip daddr 192.168.0.2
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x0200a8c0 ]
+
+# ip ttl 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x000000e9 ]
+
+# ip protocol tcp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# ip protocol != tcp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp neq reg 1 0x00000006 ]
+
+# ip saddr != 1.1.1.1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp neq reg 1 0x01010101 ]
+
+# ip daddr 192.168.0.2
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x0200a8c0 ]
+
+# ip ttl 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x000000e9 ]
+
+# ip protocol tcp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# ip protocol != tcp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp neq reg 1 0x00000006 ]
+
+# ip saddr != 1.1.1.1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp neq reg 1 0x01010101 ]
+
+# ip daddr 192.168.0.2
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x0200a8c0 ]
+
+# ip ttl 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x000000e9 ]
+
+# ip protocol tcp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# ip protocol != tcp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp neq reg 1 0x00000006 ]
+
+# ip ttl 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x000000e9 ]
+
+# ip protocol tcp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# ip protocol != tcp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp neq reg 1 0x00000006 ]
+
diff --git a/tests/py/ip/sets.t b/tests/py/ip/sets.t
index d4a72ad..db50b00 100644
--- a/tests/py/ip/sets.t
+++ b/tests/py/ip/sets.t
@@ -1,7 +1,9 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip;test-ip4;input
 *inet;test-inet;input
+*netdev;test-netdev;ingress
 
 !set_ipv4_add ipv4_addr;ok
 !set_inet inet_proto;ok
diff --git a/tests/py/ip/sets.t.payload.netdev b/tests/py/ip/sets.t.payload.netdev
new file mode 100644
index 0000000..0e91afb
--- /dev/null
+++ b/tests/py/ip/sets.t.payload.netdev
@@ -0,0 +1,16 @@
+# ip saddr @set1 drop
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set set1 ]
+  [ immediate reg 0 drop ]
+
+# ip saddr @set2 drop
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set set2 ]
+  [ immediate reg 0 drop ]
+
diff --git a/tests/py/ip6/sets.t b/tests/py/ip6/sets.t
index e0daa3a..4bfa614 100644
--- a/tests/py/ip6/sets.t
+++ b/tests/py/ip6/sets.t
@@ -1,7 +1,9 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip6;test-ip6;input
 *inet;test-inet;input
+*netdev;test-netdev;ingress
 
 !set_ipv6_add1 ipv6_addr;ok
 !set_inet1 inet_proto;ok
diff --git a/tests/py/ip6/sets.t.payload.netdev b/tests/py/ip6/sets.t.payload.netdev
new file mode 100644
index 0000000..8f432d0
--- /dev/null
+++ b/tests/py/ip6/sets.t.payload.netdev
@@ -0,0 +1,8 @@
+# ip6 saddr @set2 drop
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set set2 ]
+  [ immediate reg 0 drop ]
+
diff --git a/tests/py/ip6/vmap.t b/tests/py/ip6/vmap.t
index 6a3a004..434f5d9 100644
--- a/tests/py/ip6/vmap.t
+++ b/tests/py/ip6/vmap.t
@@ -1,7 +1,9 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *ip6;test-ip6;input
 *inet;test-inet;input
+*netdev;test-netdev;ingress
 
 ip6 saddr vmap { abcd::3 : accept };ok
 ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234:1234;fail
diff --git a/tests/py/ip6/vmap.t.payload.netdev b/tests/py/ip6/vmap.t.payload.netdev
new file mode 100644
index 0000000..3bacb88
--- /dev/null
+++ b/tests/py/ip6/vmap.t.payload.netdev
@@ -0,0 +1,420 @@
+# ip6 saddr vmap { abcd::3 : accept }
+map%d test-netdev b
+map%d test-netdev 0
+	element 0000cdab 00000000 00000000 03000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 34123412 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34120000 34123412 34123412 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234::1234:1234:1234:1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00003412 34123412 34123412 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234::1234:1234:1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34120000 34123412 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234::1234:1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 00003412 34123412 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234:1234::1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 34120000 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234:1234:1234::1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 00003412 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234:1234:1234:1234::1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 34123412 34120000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:: : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 34123412 00003412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00000000 34123412 34123412 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234::1234:1234:1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00003412 34120000 34123412 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234::1234:1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 00000000 34123412 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234::1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 00003412 34120000 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234:1234::1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 00000000 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234:1234:1234::1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 00003412 34120000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:: : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 34123412 00000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { ::1234:1234:1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00000000 34120000 34123412 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234::1234:1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00003412 00000000 34123412 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234::1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 00000000 34120000 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234::1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 00003412 00000000 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234:1234::1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 00000000 34120000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234:1234:1234::  : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 00003412 00000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { ::1234:1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00000000 00000000 34123412 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234::1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00003412 00000000 34120000 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234::1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 00000000 00000000 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234::1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 00003412 00000000 34120000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234:1234:: : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 00000000 00000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { ::1234:1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00000000 00000000 34120000 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234::1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00003412 00000000 00000000 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234::1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 00000000 00000000 34120000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:1234:: : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 00003412 00000000 00000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { ::1234:1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00000000 00000000 00000000 34123412  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234::1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00003412 00000000 00000000 34120000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:1234:: : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 00000000 00000000 00000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { ::1234 : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00000000 00000000 00000000 34120000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { 1234:: : accept}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00003412 00000000 00000000 00000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap { ::/64 : accept}
+map%d test-netdev f
+map%d test-netdev 0
+	element 00000000 00000000 00000000 00000000  : 0 [end]	element 00000000 01000000 00000000 00000000  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:: : accept, ::aaaa : drop}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 aaaa0000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept, ::bbbb : drop}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 bbbb0000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::cccc : drop}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 cccc0000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
+# ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::dddd: drop}
+map%d test-netdev b
+map%d test-netdev 0
+	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 dddd0000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
-- 
2.1.4

