From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nft 3/7] tests/py/ip: Unmark negative set lookup tests
Date: Thu, 24 Nov 2016 15:16:22 +0100
Message-ID: <7e886008966633758fbc6bcc0e75fe5da06ad566.1479994191.git.anatole@rezel.net>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:59144 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965702AbcKXOW7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 09:22:59 -0500
In-Reply-To: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
In-Reply-To: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Anatole Denis <anatole@rezel.net>
---
 tests/py/ip/dnat.t                |   6 +-
 tests/py/ip/dnat.t.payload.ip     |  14 ++++
 tests/py/ip/icmp.t                |  42 ++++-------
 tests/py/ip/icmp.t.payload.ip     | 152 ++++++++++++++++++++++++++++++++++++++
 tests/py/ip/ip.t                  |  31 ++++----
 tests/py/ip/ip.t.payload          | 115 ++++++++++++++++++++++++++++
 tests/py/ip/ip.t.payload.inet     | 143 +++++++++++++++++++++++++++++++++++
 tests/py/ip/ip.t.payload.netdev   | 143 +++++++++++++++++++++++++++++++++++
 tests/py/ip/sets.t                |   3 +
 tests/py/ip/sets.t.payload.inet   |  16 ++++
 tests/py/ip/sets.t.payload.ip     |  12 +++
 tests/py/ip/sets.t.payload.netdev |  16 ++++
 tests/py/ip/snat.t                |   5 +-
 tests/py/ip/snat.t.payload        |  14 ++++
 14 files changed, 659 insertions(+), 53 deletions(-)

diff --git a/tests/py/ip/dnat.t b/tests/py/ip/dnat.t
index d1ffdd7..da00106 100644
--- a/tests/py/ip/dnat.t
+++ b/tests/py/ip/dnat.t
@@ -5,11 +5,7 @@
 iifname "eth0" tcp dport 80-90 dnat to 192.168.3.2;ok
 iifname "eth0" tcp dport != 80-90 dnat to 192.168.3.2;ok
 iifname "eth0" tcp dport {80, 90, 23} dnat to 192.168.3.2;ok
-- iifname "eth0" tcp dport != {80, 90, 23} dnat to 192.168.3.2;ok
-- iifname "eth0" tcp dport != {80, 90, 23} dnat to 192.168.3.2;ok
-# BUG: invalid expression type set
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
-
+iifname "eth0" tcp dport != {80, 90, 23} dnat to 192.168.3.2;ok
 iifname "eth0" tcp dport != 23-34 dnat to 192.168.3.2;ok
 
 dnat to ct mark map { 0x00000014 : 1.2.3.4};ok
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index 6caa2c1..6692699 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -35,6 +35,20 @@ ip test-ip4 prerouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
+# iifname "eth0" tcp dport != {80, 90, 23} dnat to 192.168.3.2
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00005000  : 0 [end]	element 00005a00  : 0 [end]	element 00001700  : 0 [end]
+ip test-ip4 prerouting
+  [ meta load iifname => reg 1 ]
+  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 1 0x0203a8c0 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+
 # iifname "eth0" tcp dport != 23-34 dnat to 192.168.3.2
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
diff --git a/tests/py/ip/icmp.t b/tests/py/ip/icmp.t
index a6a4261..5a7ce7e 100644
--- a/tests/py/ip/icmp.t
+++ b/tests/py/ip/icmp.t
@@ -20,34 +20,25 @@ icmp type address-mask-reply accept;ok
 icmp type router-advertisement accept;ok
 icmp type router-solicitation accept;ok
 icmp type {echo-reply, destination-unreachable, source-quench, redirect, echo-request, time-exceeded, parameter-problem, timestamp-request, timestamp-reply, info-request, info-reply, address-mask-request, address-mask-reply, router-advertisement, router-solicitation} accept;ok
-- icmp type != {echo-reply, destination-unreachable, source-quench};ok
-# BUG: icmp type != {echo-reply, destination-unreachable, source-quench}
-# BUG: invalid expression type set
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+icmp type != {echo-reply, destination-unreachable, source-quench};ok
 
 icmp code 111 accept;ok
 icmp code != 111 accept;ok
 icmp code 33-55;ok
 icmp code != 33-55;ok
 icmp code { 33-55};ok
-- icmp code != { 33-55};ok
+icmp code != { 33-55};ok
 icmp code { 2, 4, 54, 33, 56};ok
-- icmp code != { 2, 4, 54, 33, 56};ok
-# $ sudo nft add rule ip test input icmp code != {2, 4, 54, 33, 56}
-# BUG: invalid expression type set
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+icmp code != { 2, 4, 54, 33, 56};ok
 
 icmp checksum 12343 accept;ok
 icmp checksum != 12343 accept;ok
 icmp checksum 11-343 accept;ok
 icmp checksum != 11-343 accept;ok
 icmp checksum { 11-343} accept;ok
-- icmp checksum != { 11-343} accept;ok
+icmp checksum != { 11-343} accept;ok
 icmp checksum { 1111, 222, 343} accept;ok
-- icmp checksum != { 1111, 222, 343} accept;ok
-# BUG: invalid expression type set
-# icmp checksum != { 1111, 222, 343} accept;ok
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+icmp checksum != { 1111, 222, 343} accept;ok
 
 icmp id 1245 log;ok
 icmp id 22;ok
@@ -55,42 +46,39 @@ icmp id != 233;ok
 icmp id 33-45;ok
 icmp id != 33-45;ok
 icmp id { 33-55};ok
-- icmp id != { 33-55};ok
+icmp id != { 33-55};ok
 icmp id { 22, 34, 333};ok
-- icmp id != { 22, 34, 333};ok
-# BUG: invalid expression type set
-# icmp id != { 22, 34, 333}
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+icmp id != { 22, 34, 333};ok
 
 icmp sequence 22;ok
 icmp sequence != 233;ok
 icmp sequence 33-45;ok
 icmp sequence != 33-45;ok
 icmp sequence { 33, 55, 67, 88};ok
-- icmp sequence != { 33, 55, 67, 88};ok
+icmp sequence != { 33, 55, 67, 88};ok
 icmp sequence { 33-55};ok
-- icmp sequence != { 33-55};ok
+icmp sequence != { 33-55};ok
 
 icmp mtu 33;ok
 icmp mtu 22-33;ok
 icmp mtu { 22-33};ok
-- icmp mtu != { 22-33};ok
+icmp mtu != { 22-33};ok
 icmp mtu 22;ok
 icmp mtu != 233;ok
 icmp mtu 33-45;ok
 icmp mtu != 33-45;ok
 icmp mtu { 33, 55, 67, 88};ok
-- icmp mtu != { 33, 55, 67, 88};ok
+icmp mtu != { 33, 55, 67, 88};ok
 icmp mtu { 33-55};ok
-- icmp mtu != { 33-55};ok
+icmp mtu != { 33-55};ok
 
 icmp gateway 22;ok
 icmp gateway != 233;ok
 icmp gateway 33-45;ok
 icmp gateway != 33-45;ok
 icmp gateway { 33, 55, 67, 88};ok
-- icmp gateway != { 33, 55, 67, 88};ok
+icmp gateway != { 33, 55, 67, 88};ok
 icmp gateway { 33-55};ok
-- icmp gateway != { 33-55};ok
+icmp gateway != { 33-55};ok
 icmp gateway != 34;ok
-- icmp gateway != { 333, 334};ok
+icmp gateway != { 333, 334};ok
diff --git a/tests/py/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
index b740ff8..1130b98 100644
--- a/tests/py/ip/icmp.t.payload.ip
+++ b/tests/py/ip/icmp.t.payload.ip
@@ -113,6 +113,16 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# icmp type != {echo-reply, destination-unreachable, source-quench}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000000  : 0 [end]	element 00000003  : 0 [end]	element 00000004  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmp code 111 accept
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -154,6 +164,16 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmp code != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmp code { 2, 4, 54, 33, 56}
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -164,6 +184,16 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmp code != { 2, 4, 54, 33, 56}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000036  : 0 [end]	element 00000021  : 0 [end]	element 00000038  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmp checksum 12343 accept
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -208,6 +238,17 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# icmp checksum != { 11-343} accept
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # icmp checksum { 1111, 222, 343} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -219,6 +260,17 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# icmp checksum != { 1111, 222, 343} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00005704  : 0 [end]	element 0000de00  : 0 [end]	element 00005701  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # icmp id 1245 log
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -266,6 +318,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmp id != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmp id { 22, 34, 333}
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -276,6 +338,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmp id != { 22, 34, 333}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00001600  : 0 [end]	element 00002200  : 0 [end]	element 00004d01  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmp sequence 22
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -315,6 +387,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmp sequence != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmp sequence { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -325,6 +407,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmp sequence != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmp mtu 33
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -350,6 +442,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmp mtu != { 22-33}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001600  : 0 [end]	element 00002200  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmp mtu 22
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -389,6 +491,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmp mtu != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmp mtu { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -399,6 +511,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmp mtu != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmp gateway 22
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -438,6 +560,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmp gateway != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmp gateway { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -448,6 +580,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmp gateway != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmp gateway != 34
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -455,6 +597,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp neq reg 1 0x22000000 ]
 
+# icmp gateway != { 333, 334}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 4d010000  : 0 [end]	element 4e010000  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmp type router-advertisement accept
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 8ed2e99..f984646 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -29,51 +29,48 @@ ip dscp 0x38;ok;ip dscp cs7
 ip dscp != 0x20;ok;ip dscp != cs4
 ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef};ok
 - ip dscp {0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0x00, 0x0a, 0x0c, 0x0e, 0x12, 0x14, 0x16, 0x1a, 0x1c, 0x1e, 0x22, 0x24, 0x26, 0x2e};ok
-- ip dscp != {CS0, CS3};ok
+ip dscp != {cs0, cs3};ok
 
 ip length 232;ok
 ip length != 233;ok
 ip length 333-435;ok
 ip length != 333-453;ok
 ip length { 333, 553, 673, 838};ok
-- ip length != { 333, 535, 637, 883};ok
+ip length != { 333, 553, 673, 838};ok
 ip length { 333-535};ok
-- ip length != { 333-553};ok
+ip length != { 333-535};ok
 
 ip id 22;ok
 ip id != 233;ok
 ip id 33-45;ok
 ip id != 33-45;ok
 ip id { 33, 55, 67, 88};ok
-- ip id != { 33, 55, 67, 88};ok
+ip id != { 33, 55, 67, 88};ok
 ip id { 33-55};ok
-- ip id != { 33-55};ok
+ip id != { 33-55};ok
 
 ip frag-off 222 accept;ok
 ip frag-off != 233;ok
 ip frag-off 33-45;ok
 ip frag-off != 33-45;ok
 ip frag-off { 33, 55, 67, 88};ok
-- ip frag-off != { 33, 55, 67, 88};ok
+ip frag-off != { 33, 55, 67, 88};ok
 ip frag-off { 33-55};ok
-- ip frag-off != { 33-55};ok
+ip frag-off != { 33-55};ok
 
 ip ttl 0 drop;ok
 ip ttl 233;ok
 ip ttl 33-55;ok
 ip ttl != 45-50;ok
 ip ttl {43, 53, 45 };ok
-- ip ttl != {46, 56, 93 };ok
-# BUG: ip ttl != {46, 56, 93 };ok
-# BUG: invalid expression type set
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+ip ttl != {43, 53, 45 };ok
 ip ttl { 33-55};ok
-- ip ttl != { 33-55};ok
+ip ttl != { 33-55};ok
 
 ip protocol tcp;ok;ip protocol 6
 ip protocol != tcp;ok;ip protocol != 6
 ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept;ok;ip protocol { 33, 136, 17, 51, 50, 6, 132, 1, 108} accept
-- ip protocol != { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept;ok
+ip protocol != { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept;ok;ip protocol != { 33, 136, 17, 51, 50, 6, 132, 1, 108} accept
 
 ip protocol 255;ok
 ip protocol 256;fail
@@ -84,9 +81,9 @@ ip checksum != 233;ok
 ip checksum 33-45;ok
 ip checksum != 33-45;ok
 ip checksum { 33, 55, 67, 88};ok
-- ip checksum != { 33, 55, 67, 88};ok
+ip checksum != { 33, 55, 67, 88};ok
 ip checksum { 33-55};ok
-- ip checksum != { 33-55};ok
+ip checksum != { 33-55};ok
 
 ip saddr 192.168.2.0/24;ok
 ip saddr != 192.168.2.0/24;ok
@@ -99,9 +96,9 @@ ip daddr 172.16.0.0-172.31.255.255;ok
 ip daddr 192.168.3.1-192.168.4.250;ok
 ip daddr != 192.168.0.1-192.168.0.250;ok
 ip daddr { 192.168.0.1-192.168.0.250};ok
-- ip daddr != { 192.168.0.1-192.168.0.250};ok
+ip daddr != { 192.168.0.1-192.168.0.250};ok
 ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept;ok
-- ip daddr != { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept;ok
+ip daddr != { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept;ok
 
 ip daddr 192.168.1.2-192.168.1.55;ok
 ip daddr != 192.168.1.2-192.168.1.55;ok
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index fade387..5038628 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -31,6 +31,15 @@ ip test-ip4 input
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# ip dscp != {cs0, cs3}
+__set%d test-ip4 3
+__set%d test-ip4 0
+        element 00000000  : 0 [end]     element 00000060  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip length 232
 ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
@@ -60,6 +69,14 @@ ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip length != { 333, 553, 673, 838}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
+ip test-ip4 input
+  [ payload load 2b @ network header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip length { 333-535}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -68,6 +85,14 @@ ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip length != { 333-535}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
+ip test-ip4 input
+  [ payload load 2b @ network header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip id 22
 ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
@@ -97,6 +122,14 @@ ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip id != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip test-ip4 input
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip id { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -105,6 +138,14 @@ ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip id != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip frag-off 222 accept
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
@@ -135,6 +176,14 @@ ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip frag-off != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip test-ip4 input
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip frag-off { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -143,6 +192,14 @@ ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip frag-off != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip ttl 0 drop
 ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
@@ -173,6 +230,14 @@ ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip ttl != {43, 53, 45 }
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip ttl { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -181,6 +246,14 @@ ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip ttl != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip protocol tcp
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -200,6 +273,15 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# ip protocol != { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # ip protocol 255
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -240,6 +322,14 @@ ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip checksum != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip test-ip4 input
+  [ payload load 2b @ network header + 10 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip checksum { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -248,6 +338,14 @@ ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip checksum != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 2b @ network header + 10 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip saddr 192.168.2.0/24
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
@@ -312,6 +410,14 @@ ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip daddr != { 192.168.0.1-192.168.0.250}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
+ip test-ip4 input
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -321,6 +427,15 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# ip daddr != { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
+ip test-ip4 input
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # ip daddr 192.168.1.2-192.168.1.55
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index c9469d3..e658a0f 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -41,6 +41,17 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# ip dscp != {cs0, cs3}
+__set%d test-inet 3
+__set%d test-inet 0
+        element 00000000  : 0 [end]     element 00000060  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip length 232
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -80,6 +91,16 @@ inet test-inet input
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip length != { 333, 553, 673, 838}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip length { 333-535}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -90,6 +111,16 @@ inet test-inet input
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip length != { 333-535}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip id 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -129,6 +160,16 @@ inet test-inet input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip id != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip id { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -139,6 +180,16 @@ inet test-inet input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip id != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip frag-off 222 accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -179,6 +230,16 @@ inet test-inet input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip frag-off != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip frag-off { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -189,6 +250,16 @@ inet test-inet input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip frag-off != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip ttl 0 drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -229,6 +300,16 @@ inet test-inet input
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip ttl != {43, 53, 45 }
+__set%d test-inet 3
+__set%d test-inet 0
+	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip ttl { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -239,6 +320,16 @@ inet test-inet input
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip ttl != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip protocol tcp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -264,6 +355,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# ip protocol != { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # ip protocol 255
 ip test-ip4 input
   [ meta load nfproto => reg 1 ]
@@ -318,6 +420,16 @@ inet test-inet input
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip checksum != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 10 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip checksum { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -328,6 +440,16 @@ inet test-inet input
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip checksum != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 10 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip saddr 192.168.2.0/24
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -414,6 +536,16 @@ inet test-inet input
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip daddr != { 192.168.0.1-192.168.0.250}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-inet 3
 __set%d test-inet 0
@@ -425,6 +557,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# ip daddr != { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
+__set%d test-inet 3
+__set%d test-inet 0
+	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # ip daddr 192.168.1.2-192.168.1.55
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 6f2c174..6df41cb 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -37,6 +37,16 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip length != { 333, 553, 673, 838}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip length { 333-535}
 __set%d test-netdev 7
 __set%d test-netdev 0
@@ -47,6 +57,16 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip length != { 333-535}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip id 22
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -86,6 +106,16 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip id != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip id { 33-55}
 __set%d test-netdev 7
 __set%d test-netdev 0
@@ -96,6 +126,16 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip id != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip frag-off 222 accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -136,6 +176,16 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip frag-off { 33-55}
 __set%d test-netdev 7
 __set%d test-netdev 0
@@ -146,6 +196,16 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip ttl 0 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -179,6 +239,16 @@ netdev test-netdev ingress
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip ttl != {43, 53, 45 }
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip ttl { 33-55}
 __set%d test-netdev 7
 __set%d test-netdev 0
@@ -189,6 +259,16 @@ netdev test-netdev ingress
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip ttl != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
 __set%d test-netdev 3
 __set%d test-netdev 0
@@ -200,6 +280,17 @@ netdev test-netdev ingress
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# ip protocol != { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # ip protocol 255
 ip test-ip4 input
   [ meta load protocol => reg 1 ]
@@ -254,6 +345,16 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip checksum != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 10 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip checksum { 33-55}
 __set%d test-netdev 7
 __set%d test-netdev 0
@@ -264,6 +365,16 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip checksum != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 10 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip saddr 192.168.2.0/24
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -343,6 +454,16 @@ netdev test-netdev ingress
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip daddr != { 192.168.0.1-192.168.0.250}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-netdev 3
 __set%d test-netdev 0
@@ -354,6 +475,17 @@ netdev test-netdev ingress
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# ip daddr != { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # ip daddr 192.168.1.2-192.168.1.55
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -640,6 +772,17 @@ netdev test-netdev ingress
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# ip dscp != {cs0, cs3}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000000  : 0 [end]	element 00000060  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # iif "lo" ip daddr set 127.0.0.1
 netdev test-netdev ingress
   [ meta load iif => reg 1 ]
diff --git a/tests/py/ip/sets.t b/tests/py/ip/sets.t
index ee17d99..4cca02b 100644
--- a/tests/py/ip/sets.t
+++ b/tests/py/ip/sets.t
@@ -29,8 +29,11 @@
 ?set2 192.168.3.10 192.168.3.11;ok
 
 ip saddr @set1 drop;ok
+ip saddr != @set1 drop;ok
 ip saddr @set2 drop;ok
+ip saddr != @set2 drop;ok
 ip saddr @set33 drop;fail
+ip saddr != @set33 drop;fail
 
 !set3 type ipv4_addr flags interval;ok
 ?set3 192.168.0.0/16;ok
diff --git a/tests/py/ip/sets.t.payload.inet b/tests/py/ip/sets.t.payload.inet
index f8e97cc..6d8d6bc 100644
--- a/tests/py/ip/sets.t.payload.inet
+++ b/tests/py/ip/sets.t.payload.inet
@@ -6,6 +6,14 @@ inet test-inet input
   [ lookup reg 1 set set1 ]
   [ immediate reg 0 drop ]
 
+# ip saddr != @set1 drop
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set set1 0x1 ]
+  [ immediate reg 0 drop ]
+
 # ip saddr @set2 drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -14,3 +22,11 @@ inet test-inet input
   [ lookup reg 1 set set2 ]
   [ immediate reg 0 drop ]
 
+# ip saddr != @set2 drop
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set set2 0x1 ]
+  [ immediate reg 0 drop ]
+
diff --git a/tests/py/ip/sets.t.payload.ip b/tests/py/ip/sets.t.payload.ip
index ece63d0..858a5e1 100644
--- a/tests/py/ip/sets.t.payload.ip
+++ b/tests/py/ip/sets.t.payload.ip
@@ -4,9 +4,21 @@ ip test-ip4 input
   [ lookup reg 1 set set1 ]
   [ immediate reg 0 drop ]
 
+# ip saddr != @set1 drop
+ip test-ip4 input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set set1 0x1 ]
+  [ immediate reg 0 drop ]
+
 # ip saddr @set2 drop
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set2 ]
   [ immediate reg 0 drop ]
 
+# ip saddr != @set2 drop
+ip test-ip4 input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set set2 0x1 ]
+  [ immediate reg 0 drop ]
+
diff --git a/tests/py/ip/sets.t.payload.netdev b/tests/py/ip/sets.t.payload.netdev
index 0e91afb..87d54a0 100644
--- a/tests/py/ip/sets.t.payload.netdev
+++ b/tests/py/ip/sets.t.payload.netdev
@@ -6,6 +6,14 @@ netdev test-netdev ingress
   [ lookup reg 1 set set1 ]
   [ immediate reg 0 drop ]
 
+# ip saddr != @set1 drop
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set set1 0x1 ]
+  [ immediate reg 0 drop ]
+
 # ip saddr @set2 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -14,3 +22,11 @@ netdev test-netdev ingress
   [ lookup reg 1 set set2 ]
   [ immediate reg 0 drop ]
 
+# ip saddr != @set2 drop
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set set2 0x1 ]
+  [ immediate reg 0 drop ]
+
diff --git a/tests/py/ip/snat.t b/tests/py/ip/snat.t
index ec2df8c..7281bf5 100644
--- a/tests/py/ip/snat.t
+++ b/tests/py/ip/snat.t
@@ -5,9 +5,6 @@
 iifname "eth0" tcp dport 80-90 snat to 192.168.3.2;ok
 iifname "eth0" tcp dport != 80-90 snat to 192.168.3.2;ok
 iifname "eth0" tcp dport {80, 90, 23} snat to 192.168.3.2;ok
-- iifname "eth0" tcp dport != {80, 90, 23} snat to 192.168.3.2;ok
-- iifname "eth0" tcp dport != {80, 90, 23} snat to 192.168.3.2;ok
-# BUG: invalid expression type set
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+iifname "eth0" tcp dport != {80, 90, 23} snat to 192.168.3.2;ok
 
 iifname "eth0" tcp dport != 23-34 snat to 192.168.3.2;ok
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index 3d828a3..25a505c 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -35,6 +35,20 @@ ip test-ip4 postrouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 0 ]
 
+# iifname "eth0" tcp dport != {80, 90, 23} snat to 192.168.3.2
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00005000  : 0 [end]	element 00005a00  : 0 [end]	element 00001700  : 0 [end]
+ip test-ip4 postrouting
+  [ meta load iifname => reg 1 ]
+  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 1 0x0203a8c0 ]
+  [ nat snat ip addr_min reg 1 addr_max reg 0 ]
+
 # iifname "eth0" tcp dport != 23-34 snat to 192.168.3.2
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
-- 
2.11.0.rc2

