From: Florian Westphal <fw@strlen.de>
Subject: [RFC nft] meta: deprecate unqualified meta statements
Date: Wed, 27 Jul 2016 04:17:33 +0200
Message-ID: <1469585853-6207-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60878 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbcG0CRV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 22:17:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

During NFWS we discussed reducing the number of keywords in nftables.

Obviously keywords are required for the parser to know what to expect.

But always requiring the 'meta' keyword would allow us to handle
iif, oif, iifname etc without defining them in the scanner, i.e. we
could later use 'meta STRING' and resolve/map the keyword at run time
based on the meta template pseudo-header.

Note that this change does not yet reject 'iif eth0', this only makes
nft always print the 'meta' keyword when listing and updates the test
cases as required.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml                        |  17 +---
 src/meta.c                         |  25 +----
 tests/py/any/ct.t                  |   4 +-
 tests/py/any/ct.t.payload          |   4 +-
 tests/py/any/meta.t                | 194 ++++++++++++++++++-------------------
 tests/py/inet/udp.t                |   4 +-
 tests/py/inet/udp.t.payload.inet   |   4 +-
 tests/py/inet/udp.t.payload.ip     |   4 +-
 tests/py/inet/udp.t.payload.ip6    |   4 +-
 tests/py/inet/udp.t.payload.netdev |   4 +-
 tests/py/ip/dnat.t                 |   8 +-
 tests/py/ip/dnat.t.payload.ip      |   8 +-
 tests/py/ip/ip.t                   |   6 +-
 tests/py/ip/ip.t.payload           |   6 +-
 tests/py/ip/ip.t.payload.inet      |   6 +-
 tests/py/ip/ip.t.payload.netdev    |   6 +-
 tests/py/ip/snat.t                 |  12 +--
 tests/py/ip/snat.t.payload         |   8 +-
 tests/py/ip6/ip6.t                 |   4 +-
 tests/py/ip6/ip6.t.payload.inet    |   4 +-
 tests/py/ip6/ip6.t.payload.ip6     |   4 +-
 21 files changed, 150 insertions(+), 186 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index ea47e2b..fc6faa4 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -956,7 +956,7 @@ filter output ip6 daddr ::1
 			datum from a packet's payload, meta data or a stateful module. 
 		</para>
 		<refsect2>
-			<title>Meta expressions</title>
+			<title>Meta expression</title>
 			<para>
 				<cmdsynopsis>
 					<command>meta</command>
@@ -966,11 +966,6 @@ filter output ip6 daddr ::1
 						<arg>l4proto</arg>
 						<arg>protocol</arg>
 						<arg>priority</arg>
-					</group>
-				</cmdsynopsis>
-				<cmdsynopsis>
-					<arg choice="opt">meta</arg>
-					<group choice="req">
 						<arg>mark</arg>
 						<arg>iif</arg>
 						<arg>iifname</arg>
@@ -996,12 +991,6 @@ filter output ip6 daddr ::1
 				A meta expression refers to meta data associated with a packet.
 			</para>
 			<para>
-				There are two types of meta expressions: unqualified and qualified meta expressions.
-				Qualified meta expressions require the <command>meta</command> keyword before the
-				meta key, unqualified meta expressions can be specified by using the meta key directly
-				or as qualified meta expressions.
-			</para>
-			<para>
 				<table frame="all">
 					<title>Meta expression types</title>
 					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
@@ -1195,11 +1184,7 @@ filter output ip6 daddr ::1
 				<example>
 					<title>Using meta expressions</title>
 					<programlisting>
-# qualified meta expression
 filter output meta oif eth0
-
-# unqualified meta expression
-filter output oif eth0
 					</programlisting>
 				</example>
 			</para>
diff --git a/src/meta.c b/src/meta.c
index 9dd91de..498117c 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -423,27 +423,9 @@ static const struct meta_template meta_templates[] = {
 						BYTEORDER_BIG_ENDIAN), /* avoid conversion; doesn't have endianess */
 };
 
-static bool meta_key_is_qualified(enum nft_meta_keys key)
-{
-	switch (key) {
-	case NFT_META_LEN:
-	case NFT_META_NFPROTO:
-	case NFT_META_L4PROTO:
-	case NFT_META_PROTOCOL:
-	case NFT_META_PRIORITY:
-	case NFT_META_PRANDOM:
-		return true;
-	default:
-		return false;
-	}
-}
-
 static void meta_expr_print(const struct expr *expr)
 {
-	if (meta_key_is_qualified(expr->meta.key))
-		printf("meta %s", meta_templates[expr->meta.key].token);
-	else
-		printf("%s", meta_templates[expr->meta.key].token);
+	printf("meta %s", meta_templates[expr->meta.key].token);
 }
 
 static bool meta_expr_cmp(const struct expr *e1, const struct expr *e2)
@@ -560,10 +542,7 @@ struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
 
 static void meta_stmt_print(const struct stmt *stmt)
 {
-	if (meta_key_is_qualified(stmt->meta.key))
-		printf("meta %s set ", meta_templates[stmt->meta.key].token);
-	else
-		printf("%s set ", meta_templates[stmt->meta.key].token);
+	printf("meta %s set ", meta_templates[stmt->meta.key].token);
 
 	expr_print(stmt->meta.expr);
 }
diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 4d13213..28d13c3 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -55,8 +55,8 @@ ct mark set 0x11 xor 0x1331;ok;ct mark set 0x00001320
 ct mark set 0x11333 and 0x11;ok;ct mark set 0x00000011
 ct mark set 0x12 or 0x11;ok;ct mark set 0x00000013
 ct mark set 0x11;ok;ct mark set 0x00000011
-ct mark set mark;ok;ct mark set mark
-ct mark set mark map { 1 : 10, 2 : 20, 3 : 30 };ok;ct mark set mark map { 0x00000003 : 0x0000001e, 0x00000002 : 0x00000014, 0x00000001 : 0x0000000a}
+ct mark set meta mark;ok
+ct mark set meta mark map { 1 : 10, 2 : 20, 3 : 30 };ok;ct mark set meta mark map { 0x00000003 : 0x0000001e, 0x00000002 : 0x00000014, 0x00000001 : 0x0000000a}
 
 ct expiration 30;ok;ct expiration 30s
 ct expiration 22;ok;ct expiration 22s
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index e64ce2f..dea698f 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -282,12 +282,12 @@ ip test-ip4 output
   [ ct load mark => reg 9 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
-# ct mark set mark
+# ct mark set meta mark
 ip test-ip4 output
   [ meta load mark => reg 1 ]
   [ ct set mark with reg 1 ]
 
-# ct mark set mark map { 1 : 10, 2 : 20, 3 : 30 }
+# ct mark set meta mark map { 1 : 10, 2 : 20, 3 : 30 }
 __map%d test-ip4 b
 __map%d test-ip4 0
         element 00000001  : 0000000a 0 [end]    element 00000002  : 00000014 0 [end]    element 00000003  : 0000001e 0 [end]
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 909de8b..b20588c 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -49,77 +49,77 @@ meta l4proto { 33-55};ok
 - meta priority {bcad:dada, bcad:dadc, aaaa:bbbb};ok
 - meta priority != {bcad:dada, bcad:dadc, aaaa:bbbb};ok
 
-meta mark 0x4;ok;mark 0x00000004
-meta mark 0x32;ok;mark 0x00000032
-meta mark and 0x03 == 0x01;ok;mark & 0x00000003 == 0x00000001
-meta mark and 0x03 != 0x01;ok;mark & 0x00000003 != 0x00000001
-meta mark 0x10;ok;mark 0x00000010
-meta mark != 0x10;ok;mark != 0x00000010
-
-meta mark or 0x03 == 0x01;ok;mark | 0x00000003 == 0x00000001
-meta mark or 0x03 != 0x01;ok;mark | 0x00000003 != 0x00000001
-meta mark xor 0x03 == 0x01;ok;mark 0x00000002
-meta mark xor 0x03 != 0x01;ok;mark != 0x00000002
-
-meta iif eth0 accept;ok;iif eth0 accept
-meta iif eth0 accept;ok;iif eth0 accept
-meta iif != eth0 accept;ok;iif != eth0 accept
-meta iif != eth0 accept;ok;iif != eth0 accept
-
-meta iifname "eth0";ok;iifname "eth0"
-meta iifname != "eth0";ok;iifname != "eth0"
+meta mark 0x4;ok;meta mark 0x00000004
+meta mark 0x32;ok;meta mark 0x00000032
+meta mark and 0x03 == 0x01;ok;meta mark & 0x00000003 == 0x00000001
+meta mark and 0x03 != 0x01;ok;meta mark & 0x00000003 != 0x00000001
+meta mark 0x10;ok;meta mark 0x00000010
+meta mark != 0x10;ok;meta mark != 0x00000010
+
+meta mark or 0x03 == 0x01;ok;meta mark | 0x00000003 == 0x00000001
+meta mark or 0x03 != 0x01;ok;meta mark | 0x00000003 != 0x00000001
+meta mark xor 0x03 == 0x01;ok;meta mark 0x00000002
+meta mark xor 0x03 != 0x01;ok;meta mark != 0x00000002
+
+meta iif eth0 accept;ok
+meta iif eth0 accept;ok
+meta iif != eth0 accept;ok
+meta iif != eth0 accept;ok
+
+meta iifname "eth0";ok;meta iifname "eth0"
+meta iifname != "eth0";ok;meta iifname != "eth0"
 meta iifname {"eth0", "lo"};ok
 - meta iifname != {"eth0", "lo"};ok
-meta iifname "eth*";ok;iifname "eth*"
-meta iifname "eth\*";ok;iifname "eth\*"
+meta iifname "eth*";ok
+meta iifname "eth\*";ok
 
 meta iiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 - meta iiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
-meta iiftype != ether;ok;iiftype != ether
-meta iiftype ether;ok;iiftype ether
-meta iiftype != ppp;ok;iiftype != ppp
-meta iiftype ppp;ok;iiftype ppp
+meta iiftype != ether;ok
+meta iiftype ether;ok
+meta iiftype != ppp;ok
+meta iiftype ppp;ok
 
-meta oif lo accept;ok;oif lo accept
-meta oif != lo accept;ok;oif != lo accept
+meta oif lo accept;ok
+meta oif != lo accept;ok
 meta oif {eth0, lo} accept;ok
 - meta oif != {eth0, lo} accept;ok
 
-meta oifname "eth0";ok;oifname "eth0"
-meta oifname != "eth0";ok;oifname != "eth0"
+meta oifname "eth0";ok
+meta oifname != "eth0";ok
 meta oifname { "eth0", "lo"};ok
 - meta iifname != {"eth0", "lo"};ok
-meta oifname "eth*";ok;oifname "eth*"
-meta oifname "eth\*";ok;oifname "eth\*"
+meta oifname "eth*";ok
+meta oifname "eth\*";ok
 
 meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 - meta oiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
-meta oiftype != ether;ok;oiftype != ether
-meta oiftype ether;ok;oiftype ether
+meta oiftype != ether;ok
+meta oiftype ether;ok
 
 meta skuid {bin, root, daemon} accept;ok;skuid { 0, 1, 2} accept
 - meta skuid != {bin, root, daemon} accept;ok
-meta skuid root;ok;skuid 0
-meta skuid != root;ok;skuid != 0
-meta skuid lt 3000 accept;ok;skuid < 3000 accept
-meta skuid gt 3000 accept;ok;skuid > 3000 accept
-meta skuid eq 3000 accept;ok;skuid 3000 accept
-meta skuid 3001-3005 accept;ok;skuid 3001-3005 accept
-meta skuid != 2001-2005 accept;ok;skuid != 2001-2005 accept
-meta skuid { 2001-2005} accept;ok;skuid { 2001-2005} accept
+meta skuid root;ok;meta skuid 0
+meta skuid != root;ok;meta skuid != 0
+meta skuid lt 3000 accept;ok;meta skuid < 3000 accept
+meta skuid gt 3000 accept;ok;meta skuid > 3000 accept
+meta skuid eq 3000 accept;ok;meta skuid 3000 accept
+meta skuid 3001-3005 accept;ok
+meta skuid != 2001-2005 accept;ok
+meta skuid { 2001-2005} accept;ok
 - meta skuid != { 2001-2005} accept;ok
 
-meta skgid {bin, root, daemon} accept;ok;skgid { 0, 1, 2} accept
+meta skgid {bin, root, daemon} accept;ok;meta skgid { 0, 1, 2} accept
 - meta skgid != {bin, root, daemon} accept;ok
-meta skgid root;ok;skgid 0
-meta skgid != root;ok;skgid != 0
-meta skgid lt 3000 accept;ok;skgid < 3000 accept
-meta skgid gt 3000 accept;ok;skgid > 3000 accept
-meta skgid eq 3000 accept;ok;skgid 3000 accept
-meta skgid 2001-2005 accept;ok;skgid 2001-2005 accept
-meta skgid != 2001-2005 accept;ok;skgid != 2001-2005 accept
-meta skgid { 2001-2005} accept;ok;skgid { 2001-2005} accept
-- meta skgid != { 2001-2005} accept;ok;skgid != { 2001-2005} accept
+meta skgid root;ok;meta skgid 0
+meta skgid != root;ok;meta skgid != 0
+meta skgid lt 3000 accept;ok;meta skgid < 3000 accept
+meta skgid gt 3000 accept;ok;meta skgid > 3000 accept
+meta skgid eq 3000 accept;ok;meta skgid 3000 accept
+meta skgid 2001-2005 accept;ok
+meta skgid != 2001-2005 accept;ok
+meta skgid { 2001-2005} accept;ok
+- meta skgid != { 2001-2005} accept;ok
 
 # BUG: meta nftrace 2 and meta nftrace 1
 # $ sudo nft add rule ip test input meta nftrace 2
@@ -131,71 +131,71 @@ meta skgid { 2001-2005} accept;ok;skgid { 2001-2005} accept
 # add rule ip test input meta nftrace 1
 # -^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-meta mark set 0xffffffc8 xor 0x16;ok;mark set 0xffffffde
-meta mark set 0x16 and 0x16;ok;mark set 0x00000016
-meta mark set 0xffffffe9 or 0x16;ok;mark set 0xffffffff
-meta mark set 0xffffffde and 0x16;ok;mark set 0x00000016
-meta mark set 0xf045ffde or 0x10;ok;mark set 0xf045ffde
-meta mark set 0xffffffde or 0x16;ok;mark set 0xffffffde
-meta mark set 0x32 or 0xfffff;ok;mark set 0x000fffff
-meta mark set 0xfffe xor 0x16;ok;mark set 0x0000ffe8
-
-meta iif lo;ok;iif lo
-meta oif lo;ok;oif lo
-meta oifname "eth2" accept;ok;oifname "eth2" accept
-meta skuid 3000;ok;skuid 3000
-meta skgid 3000;ok;skgid 3000
+meta mark set 0xffffffc8 xor 0x16;ok;meta mark set 0xffffffde
+meta mark set 0x16 and 0x16;ok;meta mark set 0x00000016
+meta mark set 0xffffffe9 or 0x16;ok;meta mark set 0xffffffff
+meta mark set 0xffffffde and 0x16;ok;meta mark set 0x00000016
+meta mark set 0xf045ffde or 0x10;ok;meta mark set 0xf045ffde
+meta mark set 0xffffffde or 0x16;ok;meta mark set 0xffffffde
+meta mark set 0x32 or 0xfffff;ok;meta mark set 0x000fffff
+meta mark set 0xfffe xor 0x16;ok;meta mark set 0x0000ffe8
+
+meta iif lo;ok
+meta oif lo;ok
+meta oifname "eth2" accept;ok
+meta skuid 3000;ok
+meta skgid 3000;ok
 # BUG:  meta nftrace 1;ok
 # <cmdline>:1:1-37: Error: Could not process rule: Operation not supported
 - meta nftrace 1;ok
-meta rtclassid cosmos;ok;rtclassid cosmos
-
-meta pkttype broadcast;ok;pkttype broadcast
-meta pkttype unicast;ok;pkttype unicast
-meta pkttype multicast;ok;pkttype multicast
-meta pkttype != broadcast;ok;pkttype != broadcast
-meta pkttype != unicast;ok;pkttype != unicast
-meta pkttype != multicast;ok;pkttype != multicast
+meta rtclassid cosmos;ok
+
+meta pkttype broadcast;ok
+meta pkttype unicast;ok
+meta pkttype multicast;ok
+meta pkttype != broadcast;ok
+meta pkttype != unicast;ok
+meta pkttype != multicast;ok
 meta pkttype broadcastttt;fail
 meta pkttype { broadcast, multicast} accept;ok
 
-meta cpu 1;ok;cpu 1
-meta cpu != 1;ok;cpu != 1
-meta cpu 1-3;ok;cpu 1-3
-meta cpu != 1-2;ok;cpu != 1-2
-meta cpu { 2,3};ok;cpu { 2,3}
+meta cpu 1;ok
+meta cpu != 1;ok
+meta cpu 1-3;ok
+meta cpu != 1-2;ok
+meta cpu { 2,3};ok
 meta cpu { 2-3, 5-7};ok
--meta cpu != { 2,3};ok; cpu != { 2,3}
+-meta cpu != { 2,3};ok
 
-meta iifgroup 0;ok;iifgroup default
-meta iifgroup != 0;ok;iifgroup != default
-meta iifgroup default;ok;iifgroup default
-meta iifgroup != default;ok;iifgroup != default
-meta iifgroup {default};ok;iifgroup {default}
+meta iifgroup 0;ok;meta iifgroup default
+meta iifgroup != 0;ok;meta iifgroup != default
+meta iifgroup default;ok
+meta iifgroup != default;ok
+meta iifgroup {default};ok
 - meta iifgroup != {default};ok
 meta iifgroup { 11,33};ok
 meta iifgroup {11-33};ok
 - meta iifgroup != {11,33};ok
 - meta iifgroup != {11-33};ok
-meta oifgroup 0;ok;oifgroup default
-meta oifgroup != 0;ok;oifgroup != default
-meta oifgroup default;ok;oifgroup default
-meta oifgroup != default;ok;oifgroup != default
-meta oifgroup {default};ok;oifgroup {default}
+meta oifgroup 0;ok;meta oifgroup default
+meta oifgroup != 0;ok;meta oifgroup != default
+meta oifgroup default;ok
+meta oifgroup != default;ok
+meta oifgroup {default};ok
 - meta oifgroup != {default};ok
 meta oifgroup { 11,33};ok
 meta oifgroup {11-33};ok
 - meta oifgroup != {11,33};ok
 - meta oifgroup != {11-33};ok
 
-meta cgroup 1048577;ok;cgroup 1048577
-meta cgroup != 1048577;ok;cgroup != 1048577
-meta cgroup { 1048577, 1048578 };ok;cgroup { 1048577, 1048578}
-# meta cgroup != { 1048577, 1048578};ok;cgroup != { 1048577, 1048578}
-meta cgroup 1048577-1048578;ok;cgroup 1048577-1048578
-meta cgroup != 1048577-1048578;ok;cgroup != 1048577-1048578
-meta cgroup {1048577-1048578};ok;cgroup { 1048577-1048578}
-# meta cgroup != { 1048577-1048578};ok;cgroup != { 1048577-1048578}
+meta cgroup 1048577;ok
+meta cgroup != 1048577;ok
+meta cgroup { 1048577, 1048578 };ok
+# meta cgroup != { 1048577, 1048578};ok
+meta cgroup 1048577-1048578;ok
+meta cgroup != 1048577-1048578;ok
+meta cgroup {1048577-1048578};ok
+# meta cgroup != { 1048577-1048578};ok
 
 meta iif . meta oif { lo . eth0 };ok
 meta iif . meta oif . meta mark { lo . eth0 . 0x0000000a };ok
diff --git a/tests/py/inet/udp.t b/tests/py/inet/udp.t
index ea9c87b..6b74def 100644
--- a/tests/py/inet/udp.t
+++ b/tests/py/inet/udp.t
@@ -52,5 +52,5 @@ udp checksum { 33-55};ok
 - udp checksum != { 33-55};ok
 
 # limit impact to lo
-iif lo udp checksum set 0;ok
-iif lo udp dport set 65535;ok
+meta iif lo udp checksum set 0;ok
+meta iif lo udp dport set 65535;ok
diff --git a/tests/py/inet/udp.t.payload.inet b/tests/py/inet/udp.t.payload.inet
index 1f49438..56295fe 100644
--- a/tests/py/inet/udp.t.payload.inet
+++ b/tests/py/inet/udp.t.payload.inet
@@ -220,7 +220,7 @@ inet test-inet input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# iif lo udp checksum set 0
+# meta iif lo udp checksum set 0
 inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -229,7 +229,7 @@ inet test-inet input
   [ immediate reg 1 0x00000000 ]
   [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 ]
 
-# iif lo udp dport set 65535
+# meta iif lo udp dport set 65535
 inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
diff --git a/tests/py/inet/udp.t.payload.ip b/tests/py/inet/udp.t.payload.ip
index 8b4550d..2328687 100644
--- a/tests/py/inet/udp.t.payload.ip
+++ b/tests/py/inet/udp.t.payload.ip
@@ -220,7 +220,7 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# iif lo udp checksum set 0
+# meta iif lo udp checksum set 0
 ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -229,7 +229,7 @@ ip test-ip4 input
   [ immediate reg 1 0x00000000 ]
   [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 ]
 
-# iif lo udp dport set 65535
+# meta iif lo udp dport set 65535
 ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
diff --git a/tests/py/inet/udp.t.payload.ip6 b/tests/py/inet/udp.t.payload.ip6
index 86204f6..a9897bb 100644
--- a/tests/py/inet/udp.t.payload.ip6
+++ b/tests/py/inet/udp.t.payload.ip6
@@ -220,7 +220,7 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# iif lo udp checksum set 0
+# meta iif lo udp checksum set 0
 ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -229,7 +229,7 @@ ip6 test-ip6 input
   [ immediate reg 1 0x00000000 ]
   [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 ]
 
-# iif lo udp dport set 65535
+# meta iif lo udp dport set 65535
 ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
diff --git a/tests/py/inet/udp.t.payload.netdev b/tests/py/inet/udp.t.payload.netdev
index 2eb2a76..3f32d6f 100644
--- a/tests/py/inet/udp.t.payload.netdev
+++ b/tests/py/inet/udp.t.payload.netdev
@@ -220,7 +220,7 @@ inet test-inet input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# iif lo udp checksum set 0
+# meta iif lo udp checksum set 0
 netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -229,7 +229,7 @@ netdev test-netdev ingress
   [ immediate reg 1 0x00000000 ]
   [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 ]
 
-# iif lo udp dport set 65535
+# meta iif lo udp dport set 65535
 netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
diff --git a/tests/py/ip/dnat.t b/tests/py/ip/dnat.t
index 28e658d..c45a524 100644
--- a/tests/py/ip/dnat.t
+++ b/tests/py/ip/dnat.t
@@ -2,15 +2,15 @@
 
 *ip;test-ip4;prerouting
 
-iifname "eth0" tcp dport 80-90 dnat 192.168.3.2;ok
-iifname "eth0" tcp dport != 80-90 dnat 192.168.3.2;ok
-iifname "eth0" tcp dport {80, 90, 23} dnat 192.168.3.2;ok
+meta iifname "eth0" tcp dport 80-90 dnat 192.168.3.2;ok
+meta iifname "eth0" tcp dport != 80-90 dnat 192.168.3.2;ok
+meta iifname "eth0" tcp dport {80, 90, 23} dnat 192.168.3.2;ok
 - iifname "eth0" tcp dport != {80, 90, 23} dnat 192.168.3.2;ok
 - iifname "eth0" tcp dport != {80, 90, 23} dnat 192.168.3.2;ok
 # BUG: invalid expression type set
 # nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
 
-iifname "eth0" tcp dport != 23-34 dnat 192.168.3.2;ok
+meta iifname "eth0" tcp dport != 23-34 dnat 192.168.3.2;ok
 
 dnat ct mark map { 0x00000014 : 1.2.3.4};ok
 dnat ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};ok
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index bf972c6..b87eec0 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -1,4 +1,4 @@
-# iifname "eth0" tcp dport 80-90 dnat 192.168.3.2
+# meta iifname "eth0" tcp dport 80-90 dnat 192.168.3.2
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
@@ -10,7 +10,7 @@ ip test-ip4 prerouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
-# iifname "eth0" tcp dport != 80-90 dnat 192.168.3.2
+# meta iifname "eth0" tcp dport != 80-90 dnat 192.168.3.2
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
@@ -22,7 +22,7 @@ ip test-ip4 prerouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
-# iifname "eth0" tcp dport {80, 90, 23} dnat 192.168.3.2
+# meta iifname "eth0" tcp dport {80, 90, 23} dnat 192.168.3.2
 __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00005000  : 0 [end]	element 00005a00  : 0 [end]	element 00001700  : 0 [end]
@@ -36,7 +36,7 @@ ip test-ip4 prerouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
-# iifname "eth0" tcp dport != 23-34 dnat 192.168.3.2
+# meta iifname "eth0" tcp dport != 23-34 dnat 192.168.3.2
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 90e117a..c5175ec 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -123,6 +123,6 @@ ip hdrlength 15;ok
 ip hdrlength 16;fail
 
 # limit impact to lo
-iif lo ip daddr set 127.0.0.1;ok
-iif lo ip checksum set 0;ok
-iif lo ip id set 0;ok
+meta iif lo ip daddr set 127.0.0.1;ok
+meta iif lo ip checksum set 0;ok
+meta iif lo ip id set 0;ok
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index d6ef540..87375ce 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -416,21 +416,21 @@ ip test-ip4 input
   [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000f ]
 
-# iif lo ip daddr set 127.0.0.1
+# meta iif lo ip daddr set 127.0.0.1
 ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 1 0x0100007f ]
   [ payload write reg 1 => 4b @ network header + 16 csum_type 1 csum_off 10 ]
 
-# iif lo ip checksum set 0
+# meta iif lo ip checksum set 0
 ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 1 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 10 csum_type 1 csum_off 10 ]
 
-# iif lo ip id set 0
+# meta iif lo ip id set 0
 ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 6c78536..2324889 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -548,7 +548,7 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000f ]
 
-# iif lo ip daddr set 127.0.0.1
+# meta iif lo ip daddr set 127.0.0.1
 inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -557,7 +557,7 @@ inet test-inet input
   [ immediate reg 1 0x0100007f ]
   [ payload write reg 1 => 4b @ network header + 16 csum_type 1 csum_off 10 ]
 
-# iif lo ip checksum set 0
+# meta iif lo ip checksum set 0
 inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -566,7 +566,7 @@ inet test-inet input
   [ immediate reg 1 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 10 csum_type 1 csum_off 10 ]
 
-# iif lo ip id set 0
+# meta iif lo ip id set 0
 inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 714b0d2..958da28 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -648,7 +648,7 @@ netdev test-netdev ingress
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
-# iif lo ip daddr set 127.0.0.1
+# meta iif lo ip daddr set 127.0.0.1
 netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -657,7 +657,7 @@ netdev test-netdev ingress
   [ immediate reg 1 0x0100007f ]
   [ payload write reg 1 => 4b @ network header + 16 csum_type 1 csum_off 10 ]
 
-# iif lo ip checksum set 0
+# meta iif lo ip checksum set 0
 netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -666,7 +666,7 @@ netdev test-netdev ingress
   [ immediate reg 1 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 10 csum_type 1 csum_off 10 ]
 
-# iif lo ip id set 0
+# meta iif lo ip id set 0
 netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
diff --git a/tests/py/ip/snat.t b/tests/py/ip/snat.t
index a8469a3..e9d28d7 100644
--- a/tests/py/ip/snat.t
+++ b/tests/py/ip/snat.t
@@ -2,12 +2,12 @@
 
 *ip;test-ip4;postrouting
 
-iifname "eth0" tcp dport 80-90 snat 192.168.3.2;ok
-iifname "eth0" tcp dport != 80-90 snat 192.168.3.2;ok
-iifname "eth0" tcp dport {80, 90, 23} snat 192.168.3.2;ok
-- iifname "eth0" tcp dport != {80, 90, 23} snat 192.168.3.2;ok
-- iifname "eth0" tcp dport != {80, 90, 23} snat 192.168.3.2;ok
+meta iifname "eth0" tcp dport 80-90 snat 192.168.3.2;ok
+meta iifname "eth0" tcp dport != 80-90 snat 192.168.3.2;ok
+meta iifname "eth0" tcp dport {80, 90, 23} snat 192.168.3.2;ok
+- meta iifname "eth0" tcp dport != {80, 90, 23} snat 192.168.3.2;ok
+- meta iifname "eth0" tcp dport != {80, 90, 23} snat 192.168.3.2;ok
 # BUG: invalid expression type set
 # nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
 
-iifname "eth0" tcp dport != 23-34 snat 192.168.3.2;ok
+meta iifname "eth0" tcp dport != 23-34 snat 192.168.3.2;ok
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index cbea641..87a0fd1 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -1,4 +1,4 @@
-# iifname "eth0" tcp dport 80-90 snat 192.168.3.2
+# meta iifname "eth0" tcp dport 80-90 snat 192.168.3.2
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
@@ -10,7 +10,7 @@ ip test-ip4 postrouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 0 ]
 
-# iifname "eth0" tcp dport != 80-90 snat 192.168.3.2
+# meta iifname "eth0" tcp dport != 80-90 snat 192.168.3.2
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
@@ -22,7 +22,7 @@ ip test-ip4 postrouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 0 ]
 
-# iifname "eth0" tcp dport {80, 90, 23} snat 192.168.3.2
+# meta iifname "eth0" tcp dport {80, 90, 23} snat 192.168.3.2
 __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00005000  : 0 [end]	element 00005a00  : 0 [end]	element 00001700  : 0 [end]
@@ -36,7 +36,7 @@ ip test-ip4 postrouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 0 ]
 
-# iifname "eth0" tcp dport != 23-34 snat 192.168.3.2
+# meta iifname "eth0" tcp dport != 23-34 snat 192.168.3.2
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index 0a58fa8..cba4264 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -143,5 +143,5 @@ ip6 saddr ::1 ip6 daddr ::2;ok
 ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234:1234;ok;ip6 daddr != 0:1234:1234:1234:1234:1234:1234:1234-1234:1234:0:1234:1234:1234:1234:1234
 
 # limit impact to lo
-iif lo ip6 daddr set ::1;ok
-iif lo ip6 hoplimit set 1;ok
+meta iif lo ip6 daddr set ::1;ok
+meta iif lo ip6 hoplimit set 1;ok
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index 45bdd09..b99bd49 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -513,7 +513,7 @@ inet test-inet input
   [ cmp lt reg 1 0x34120000 0x34123412 0x34123412 0x34123412 ]
   [ cmp gt reg 1 0x34123412 0x34120000 0x34123412 0x34123412 ]
 
-# iif lo ip6 daddr set ::1
+# meta iif lo ip6 daddr set ::1
 inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -522,7 +522,7 @@ inet test-inet input
   [ immediate reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
   [ payload write reg 1 => 16b @ network header + 24 csum_type 0 csum_off 0 ]
 
-# iif lo ip6 hoplimit set 1
+# meta iif lo ip6 hoplimit set 1
 inet test-inet input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index 7e158a8..4e1f705 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -379,14 +379,14 @@ ip6 test-ip6 input
   [ cmp lt reg 1 0x34120000 0x34123412 0x34123412 0x34123412 ]
   [ cmp gt reg 1 0x34123412 0x34120000 0x34123412 0x34123412 ]
 
-# iif lo ip6 daddr set ::1
+# meta iif lo ip6 daddr set ::1
 ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
   [ payload write reg 1 => 16b @ network header + 24 csum_type 0 csum_off 0 ]
 
-# iif lo ip6 hoplimit set 1
+# meta iif lo ip6 hoplimit set 1
 ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-- 
2.7.3

