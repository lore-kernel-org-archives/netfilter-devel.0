From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 04/10] tests: fix up meta l4proto change for ip6 family
Date: Tue,  9 May 2017 17:51:16 +0200
Message-ID: <20170509155122.26356-5-fw@strlen.de>
References: <20170509155122.26356-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44554 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755701AbdEIPvT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2017 11:51:19 -0400
In-Reply-To: <20170509155122.26356-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After previous commit nft generates meta l4proto for ipv6 dependencies
instead of checking the (first) nexthdr value.

This fixes up all tests cases accordingly except one which fails with

ip6/reject.t: ... 12: 'ip6 nexthdr 6 reject with tcp reset' mismatches 'meta l4proto 6 reject with tcp reset'
This will be fixed by removing the implicit dependency in a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/bridge/icmpX.t.payload       |   4 +-
 tests/py/inet/ah.t.payload.ip6        |  60 +++++++-------
 tests/py/inet/comp.t.payload.ip6      |  34 ++++----
 tests/py/inet/dccp.t.payload.ip6      |  36 ++++----
 tests/py/inet/esp.t.payload.ip6       |  30 +++----
 tests/py/inet/ether.t.payload.ip6     |   6 +-
 tests/py/inet/icmpX.t.payload         |   4 +-
 tests/py/inet/sctp.t.payload.ip6      |  64 +++++++-------
 tests/py/inet/tcp.t.payload.ip6       | 152 +++++++++++++++++-----------------
 tests/py/inet/udp.t.payload.ip6       |  72 ++++++++--------
 tests/py/inet/udplite.t.payload.ip6   |  52 ++++++------
 tests/py/ip6/dnat.t.payload.ip6       |   6 +-
 tests/py/ip6/ether.t.payload          |   6 +-
 tests/py/ip6/icmpv6.t.payload.ip6     | 132 ++++++++++++++---------------
 tests/py/ip6/masquerade.t.payload.ip6 |  28 +++----
 tests/py/ip6/redirect.t.payload.ip6   |  38 ++++-----
 tests/py/ip6/reject.t.payload.ip6     |   2 +-
 tests/py/ip6/snat.t.payload.ip6       |   4 +-
 tests/py/ip6/tcpopt.t.payload         |  52 ++++++------
 19 files changed, 389 insertions(+), 393 deletions(-)

diff --git a/tests/py/bridge/icmpX.t.payload b/tests/py/bridge/icmpX.t.payload
index 19efdd85c43b..b351f7b008b7 100644
--- a/tests/py/bridge/icmpX.t.payload
+++ b/tests/py/bridge/icmpX.t.payload
@@ -27,9 +27,7 @@ bridge test-bridge input
 
 # icmpv6 type echo-request
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0000dd86 ]
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000080 ]
diff --git a/tests/py/inet/ah.t.payload.ip6 b/tests/py/inet/ah.t.payload.ip6
index f12f0a0dd2c2..4d5df6368da4 100644
--- a/tests/py/inet/ah.t.payload.ip6
+++ b/tests/py/inet/ah.t.payload.ip6
@@ -1,6 +1,6 @@
 # ah hdrlength 11-23
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ cmp gte reg 1 0x0000000b ]
@@ -8,7 +8,7 @@ ip6 test-ip6 input
 
 # ah hdrlength != 11-23
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ range neq reg 1 0x0000000b 0x00000017 ]
@@ -18,7 +18,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -28,7 +28,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -38,7 +38,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -48,28 +48,28 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ah reserved 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # ah reserved != 233
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # ah reserved 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -77,7 +77,7 @@ ip6 test-ip6 input
 
 # ah reserved != 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -87,7 +87,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00001700  : 0 [end]	element 00006400  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -97,7 +97,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00001700  : 0 [end]	element 00006400  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -107,7 +107,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -117,28 +117,28 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ah spi 111
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x6f000000 ]
 
 # ah spi != 111
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp neq reg 1 0x6f000000 ]
 
 # ah spi 111-222
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x6f000000 ]
@@ -146,7 +146,7 @@ ip6 test-ip6 input
 
 # ah spi != 111-222
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x6f000000 0xde000000 ]
@@ -156,7 +156,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -166,7 +166,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -176,7 +176,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -186,21 +186,21 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ah sequence 123
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ cmp eq reg 1 0x7b000000 ]
 
 # ah sequence != 123
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ cmp neq reg 1 0x7b000000 ]
@@ -210,7 +210,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -220,7 +220,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -230,7 +230,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -240,14 +240,14 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ah sequence 23-33
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ cmp gte reg 1 0x17000000 ]
@@ -255,7 +255,7 @@ ip6 test-ip6 input
 
 # ah sequence != 23-33
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ range neq reg 1 0x17000000 0x21000000 ]
diff --git a/tests/py/inet/comp.t.payload.ip6 b/tests/py/inet/comp.t.payload.ip6
index a325d8cdc9ad..3048d822d3f7 100644
--- a/tests/py/inet/comp.t.payload.ip6
+++ b/tests/py/inet/comp.t.payload.ip6
@@ -1,27 +1,27 @@
 # comp nexthdr != esp
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000032 ]
 
 # comp flags 0x0
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # comp flags != 0x23
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ cmp neq reg 1 0x00000023 ]
 
 # comp flags 0x33-0x45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000033 ]
@@ -29,7 +29,7 @@ ip6 test-ip6 input
 
 # comp flags != 0x33-0x45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ range neq reg 1 0x00000033 0x00000045 ]
@@ -39,7 +39,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -49,7 +49,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -59,7 +59,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -69,28 +69,28 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # comp cpi 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # comp cpi != 233
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # comp cpi 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -98,7 +98,7 @@ ip6 test-ip6 input
 
 # comp cpi != 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -108,7 +108,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -118,7 +118,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -128,7 +128,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -138,7 +138,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
diff --git a/tests/py/inet/dccp.t.payload.ip6 b/tests/py/inet/dccp.t.payload.ip6
index 0f8aab11d69d..0fa441043a7a 100644
--- a/tests/py/inet/dccp.t.payload.ip6
+++ b/tests/py/inet/dccp.t.payload.ip6
@@ -1,6 +1,6 @@
 # dccp sport 21-35
 ip test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp gte reg 1 0x00001500 ]
@@ -8,7 +8,7 @@ ip test-ip6 input
 
 # dccp sport != 21-35
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ range neq reg 1 0x00001500 0x00002300 ]
@@ -18,7 +18,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -28,7 +28,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -38,7 +38,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -48,14 +48,14 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dccp sport ftp-data - re-mail-ck
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp gte reg 1 0x00001400 ]
@@ -63,7 +63,7 @@ ip6 test-ip6 input
 
 # dccp sport 20-50
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp gte reg 1 0x00001400 ]
@@ -74,7 +74,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -84,7 +84,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -94,7 +94,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -104,7 +104,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -114,7 +114,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -124,7 +124,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -134,7 +134,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
@@ -145,7 +145,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
@@ -153,7 +153,7 @@ ip6 test-ip6 input
 
 # dccp type request
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
@@ -161,7 +161,7 @@ ip6 test-ip6 input
 
 # dccp type != request
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
diff --git a/tests/py/inet/esp.t.payload.ip6 b/tests/py/inet/esp.t.payload.ip6
index 47584921af09..a9ed233c8f5d 100644
--- a/tests/py/inet/esp.t.payload.ip6
+++ b/tests/py/inet/esp.t.payload.ip6
@@ -1,20 +1,20 @@
 # esp spi 100
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x64000000 ]
 
 # esp spi != 100
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ cmp neq reg 1 0x64000000 ]
 
 # esp spi 111-222
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ cmp gte reg 1 0x6f000000 ]
@@ -22,7 +22,7 @@ ip6 test-ip6 input
 
 # esp spi != 111-222
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ range neq reg 1 0x6f000000 0xde000000 ]
@@ -32,7 +32,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 64000000  : 0 [end]	element 66000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -42,7 +42,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 64000000  : 0 [end]	element 66000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -52,7 +52,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -62,21 +62,21 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # esp sequence 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x16000000 ]
 
 # esp sequence 22-24
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x16000000 ]
@@ -84,7 +84,7 @@ ip6 test-ip6 input
 
 # esp sequence != 22-24
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x16000000 0x18000000 ]
@@ -94,7 +94,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 16000000  : 0 [end]	element 18000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -104,7 +104,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 16000000  : 0 [end]	element 18000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -114,7 +114,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -124,7 +124,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
diff --git a/tests/py/inet/ether.t.payload.ip6 b/tests/py/inet/ether.t.payload.ip6
index 9065952d2646..a3a8905e6372 100644
--- a/tests/py/inet/ether.t.payload.ip6
+++ b/tests/py/inet/ether.t.payload.ip6
@@ -1,6 +1,6 @@
 # tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 meta nfproto ipv4 accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
@@ -14,7 +14,7 @@ ip6 test-ip6 input
 
 # tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
@@ -26,7 +26,7 @@ ip6 test-ip6 input
 
 # tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
diff --git a/tests/py/inet/icmpX.t.payload b/tests/py/inet/icmpX.t.payload
index 81ca7744c4e4..4df15d7fb28c 100644
--- a/tests/py/inet/icmpX.t.payload
+++ b/tests/py/inet/icmpX.t.payload
@@ -27,9 +27,7 @@ inet test-inet input
 
 # icmpv6 type echo-request
 inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000080 ]
diff --git a/tests/py/inet/sctp.t.payload.ip6 b/tests/py/inet/sctp.t.payload.ip6
index 5c63d2adf64c..9775804d55ef 100644
--- a/tests/py/inet/sctp.t.payload.ip6
+++ b/tests/py/inet/sctp.t.payload.ip6
@@ -1,20 +1,20 @@
 # sctp sport 23
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00001700 ]
 
 # sctp sport != 23
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp neq reg 1 0x00001700 ]
 
 # sctp sport 23-44
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp gte reg 1 0x00001700 ]
@@ -22,7 +22,7 @@ ip6 test-ip6 input
 
 # sctp sport != 23-44
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ range neq reg 1 0x00001700 0x00002c00 ]
@@ -32,7 +32,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -42,7 +42,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -52,7 +52,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -62,28 +62,28 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # sctp dport 23
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001700 ]
 
 # sctp dport != 23
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp neq reg 1 0x00001700 ]
 
 # sctp dport 23-44
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00001700 ]
@@ -91,7 +91,7 @@ ip6 test-ip6 input
 
 # sctp dport != 23-44
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00001700 0x00002c00 ]
@@ -101,7 +101,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -111,7 +111,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -121,7 +121,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -131,28 +131,28 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # sctp checksum 1111
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ cmp eq reg 1 0x57040000 ]
 
 # sctp checksum != 11
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ cmp neq reg 1 0x0b000000 ]
 
 # sctp checksum 21-333
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ cmp gte reg 1 0x15000000 ]
@@ -160,7 +160,7 @@ ip6 test-ip6 input
 
 # sctp checksum != 32-111
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ range neq reg 1 0x20000000 0x6f000000 ]
@@ -170,7 +170,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -180,7 +180,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -190,7 +190,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -200,28 +200,28 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # sctp vtag 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x16000000 ]
 
 # sctp vtag != 233
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp neq reg 1 0xe9000000 ]
 
 # sctp vtag 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x21000000 ]
@@ -229,7 +229,7 @@ ip6 test-ip6 input
 
 # sctp vtag != 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x21000000 0x2d000000 ]
@@ -239,7 +239,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -249,7 +249,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -259,7 +259,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -269,7 +269,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
diff --git a/tests/py/inet/tcp.t.payload.ip6 b/tests/py/inet/tcp.t.payload.ip6
index b1b361ec77f5..a335f594cbc2 100644
--- a/tests/py/inet/tcp.t.payload.ip6
+++ b/tests/py/inet/tcp.t.payload.ip6
@@ -1,20 +1,20 @@
 # tcp dport 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # tcp dport != 233
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # tcp dport 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -22,7 +22,7 @@ ip6 test-ip6 input
 
 # tcp dport != 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -32,7 +32,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -42,7 +42,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -52,7 +52,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -62,7 +62,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -72,7 +72,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00001700  : 0 [end]	element 00005000  : 0 [end]	element 0000bb01  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -83,7 +83,7 @@ __map%d test-ip6 b
 __map%d test-ip6 0
 	element 00001600  : 0 [end]	element 00001700  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -93,7 +93,7 @@ __map%d test-ip6 b
 __map%d test-ip6 0
 	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -103,7 +103,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -113,28 +113,28 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # tcp sport 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # tcp sport != 233
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # tcp sport 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -142,7 +142,7 @@ ip6 test-ip6 input
 
 # tcp sport != 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -152,7 +152,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -162,7 +162,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -172,7 +172,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -182,7 +182,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -192,14 +192,14 @@ __map%d test-ip6 b
 __map%d test-ip6 0
 	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # tcp sport 8080 drop
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x0000901f ]
@@ -207,21 +207,21 @@ ip6 test-ip6 input
 
 # tcp sport 1024 tcp dport 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x16000004 ]
 
 # tcp sport 1024 tcp dport 22 tcp sequence 0
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 8b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x16000004 0x00000000 ]
 
 # tcp sequence 0 tcp sport 1024 tcp dport 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 8b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x16000004 0x00000000 ]
@@ -231,7 +231,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000004  : 0 [end]	element 0000fe03  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -240,21 +240,21 @@ ip6 test-ip6 input
 
 # tcp sequence 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x16000000 ]
 
 # tcp sequence != 233
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp neq reg 1 0xe9000000 ]
 
 # tcp sequence 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x21000000 ]
@@ -262,7 +262,7 @@ ip6 test-ip6 input
 
 # tcp sequence != 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x21000000 0x2d000000 ]
@@ -272,7 +272,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -282,7 +282,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -292,7 +292,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -302,14 +302,14 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # tcp ackseq 42949672 drop
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ cmp eq reg 1 0x285c8f02 ]
@@ -317,21 +317,21 @@ ip6 test-ip6 input
 
 # tcp ackseq 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ cmp eq reg 1 0x16000000 ]
 
 # tcp ackseq != 233
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ cmp neq reg 1 0xe9000000 ]
 
 # tcp ackseq 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ cmp gte reg 1 0x21000000 ]
@@ -339,7 +339,7 @@ ip6 test-ip6 input
 
 # tcp ackseq != 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ range neq reg 1 0x21000000 0x2d000000 ]
@@ -349,7 +349,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -359,7 +359,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -369,7 +369,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -379,7 +379,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -389,7 +389,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000008  : 0 [end]	element 00000010  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -400,7 +400,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000001  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -408,7 +408,7 @@ ip6 test-ip6 input
 
 # tcp flags cwr
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000080 ) ^ 0x00000000 ]
@@ -416,14 +416,14 @@ ip6 test-ip6 input
 
 # tcp flags != cwr
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
   [ cmp neq reg 1 0x00000080 ]
 
 # tcp 'flags & (syn|fin) == (syn|fin)'
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000003 ) ^ 0x00000000 ]
@@ -431,28 +431,28 @@ ip6 test-ip6 input
 
 # tcp window 22222
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ cmp eq reg 1 0x0000ce56 ]
 
 # tcp window 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # tcp window != 233
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # tcp window 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -460,7 +460,7 @@ ip6 test-ip6 input
 
 # tcp window != 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -470,7 +470,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -480,7 +480,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -490,7 +490,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -500,28 +500,28 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # tcp checksum 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # tcp checksum != 233
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # tcp checksum 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -529,7 +529,7 @@ ip6 test-ip6 input
 
 # tcp checksum != 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -539,7 +539,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -549,7 +549,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -559,7 +559,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -569,14 +569,14 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # tcp urgptr 1234 accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ cmp eq reg 1 0x0000d204 ]
@@ -584,21 +584,21 @@ ip6 test-ip6 input
 
 # tcp urgptr 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # tcp urgptr != 233
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # tcp urgptr 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -606,7 +606,7 @@ ip6 test-ip6 input
 
 # tcp urgptr != 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -616,7 +616,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -626,7 +626,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -636,7 +636,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -646,14 +646,14 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # tcp doff 8
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 12 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
diff --git a/tests/py/inet/udp.t.payload.ip6 b/tests/py/inet/udp.t.payload.ip6
index d16e0075f8ee..8edcff4faa29 100644
--- a/tests/py/inet/udp.t.payload.ip6
+++ b/tests/py/inet/udp.t.payload.ip6
@@ -1,6 +1,6 @@
 # udp sport 80 accept
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00005000 ]
@@ -8,7 +8,7 @@ ip6 test-ip6 input
 
 # udp sport != 60 accept
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp neq reg 1 0x00003c00 ]
@@ -16,7 +16,7 @@ ip6 test-ip6 input
 
 # udp sport 50-70 accept
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp gte reg 1 0x00003200 ]
@@ -25,7 +25,7 @@ ip6 test-ip6 input
 
 # udp sport != 50-60 accept
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ range neq reg 1 0x00003200 0x00003c00 ]
@@ -36,7 +36,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -47,7 +47,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -58,7 +58,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -68,14 +68,14 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000d00  : 0 [end]	element 00001900  : 1 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # udp dport 80 accept
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00005000 ]
@@ -83,7 +83,7 @@ ip6 test-ip6 input
 
 # udp dport != 60 accept
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp neq reg 1 0x00003c00 ]
@@ -91,7 +91,7 @@ ip6 test-ip6 input
 
 # udp dport 70-75 accept
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00004600 ]
@@ -100,7 +100,7 @@ ip6 test-ip6 input
 
 # udp dport != 50-60 accept
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00003200 0x00003c00 ]
@@ -111,7 +111,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -122,7 +122,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -133,7 +133,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -144,7 +144,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00003200  : 0 [end]	element 00003d00  : 1 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -152,21 +152,21 @@ ip6 test-ip6 input
 
 # udp length 6666
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x00000a1a ]
 
 # udp length != 6666
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp neq reg 1 0x00000a1a ]
 
 # udp length 50-65 accept
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x00003200 ]
@@ -175,7 +175,7 @@ ip6 test-ip6 input
 
 # udp length != 50-65 accept
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x00003200 0x00004100 ]
@@ -186,7 +186,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00003200  : 0 [end]	element 00004100  : 0 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -197,7 +197,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00003200  : 0 [end]	element 00004100  : 0 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -208,7 +208,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -218,14 +218,14 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # udp checksum 6666 drop
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000a1a ]
@@ -236,7 +236,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -244,21 +244,21 @@ ip6 test-ip6 input
 
 # udp checksum 22
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # udp checksum != 233
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # udp checksum 33-45
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -266,7 +266,7 @@ ip6 test-ip6 input
 
 # udp checksum != 33-45
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -276,7 +276,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -286,7 +286,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -296,7 +296,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -306,7 +306,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -315,7 +315,7 @@ ip6 test-ip6 input
 ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ immediate reg 1 0x00000000 ]
   [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 csum_flags 0x0 ]
@@ -324,7 +324,7 @@ ip6 test-ip6 input
 ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ immediate reg 1 0x0000ffff ]
   [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 6 csum_flags 0x0 ]
diff --git a/tests/py/inet/udplite.t.payload.ip6 b/tests/py/inet/udplite.t.payload.ip6
index 47f25cd291f9..d2f032e905e0 100644
--- a/tests/py/inet/udplite.t.payload.ip6
+++ b/tests/py/inet/udplite.t.payload.ip6
@@ -1,6 +1,6 @@
 # udplite sport 80 accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00005000 ]
@@ -8,7 +8,7 @@ ip6 test-ip6 input
 
 # udplite sport != 60 accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp neq reg 1 0x00003c00 ]
@@ -16,7 +16,7 @@ ip6 test-ip6 input
 
 # udplite sport 50-70 accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp gte reg 1 0x00003200 ]
@@ -25,7 +25,7 @@ ip6 test-ip6 input
 
 # udplite sport != 50-60 accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ range neq reg 1 0x00003200 0x00003c00 ]
@@ -36,7 +36,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -47,7 +47,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -58,7 +58,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -68,14 +68,14 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # udplite dport 80 accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00005000 ]
@@ -83,7 +83,7 @@ ip6 test-ip6 input
 
 # udplite dport != 60 accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp neq reg 1 0x00003c00 ]
@@ -91,7 +91,7 @@ ip6 test-ip6 input
 
 # udplite dport 70-75 accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00004600 ]
@@ -100,7 +100,7 @@ ip6 test-ip6 input
 
 # udplite dport != 50-60 accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00003200 0x00003c00 ]
@@ -111,7 +111,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -122,7 +122,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00003100  : 0 [end]	element 00003200  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -133,7 +133,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -144,7 +144,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -152,7 +152,7 @@ ip6 test-ip6 input
 
 # udplite checksum 6666 drop
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000a1a ]
@@ -163,7 +163,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
 ip6 test-ip6 input 
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -171,21 +171,21 @@ ip6 test-ip6 input
 
 # udplite checksum 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # udplite checksum != 233
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # udplite checksum 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -193,7 +193,7 @@ ip6 test-ip6 input
 
 # udplite checksum != 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -203,7 +203,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -213,7 +213,7 @@ __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -223,7 +223,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -233,7 +233,7 @@ __set%d test-ip4 7
 __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
diff --git a/tests/py/ip6/dnat.t.payload.ip6 b/tests/py/ip6/dnat.t.payload.ip6
index 8bd5819e0360..4d3fafe2bf02 100644
--- a/tests/py/ip6/dnat.t.payload.ip6
+++ b/tests/py/ip6/dnat.t.payload.ip6
@@ -1,6 +1,6 @@
 # tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:80-100
 ip6 test-ip6 prerouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00005000 ]
@@ -13,7 +13,7 @@ ip6 test-ip6 prerouting
 
 # tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:100
 ip6 test-ip6 prerouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00005000 ]
@@ -25,7 +25,7 @@ ip6 test-ip6 prerouting
 
 # tcp dport 80-90 dnat to [2001:838:35f:1::]:80
 ip6 test-ip6 prerouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00005000 ]
diff --git a/tests/py/ip6/ether.t.payload b/tests/py/ip6/ether.t.payload
index c7342cc0c79e..592b4ea0e0bc 100644
--- a/tests/py/ip6/ether.t.payload
+++ b/tests/py/ip6/ether.t.payload
@@ -1,6 +1,6 @@
 # tcp dport 22 iiftype ether ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:4 accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
@@ -14,7 +14,7 @@ ip6 test-ip6 input
 
 # tcp dport 22 ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:04
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
@@ -27,7 +27,7 @@ ip6 test-ip6 input
 
 # tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip6 daddr 1::2
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index 30f58ca3615b..7a630f9f8b09 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -1,6 +1,6 @@
 # icmpv6 type destination-unreachable accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -8,7 +8,7 @@ ip6 test-ip6 input
 
 # icmpv6 type packet-too-big accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
@@ -16,7 +16,7 @@ ip6 test-ip6 input
 
 # icmpv6 type time-exceeded accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000003 ]
@@ -24,7 +24,7 @@ ip6 test-ip6 input
 
 # icmpv6 type echo-request accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000080 ]
@@ -32,7 +32,7 @@ ip6 test-ip6 input
 
 # icmpv6 type echo-reply accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
@@ -40,7 +40,7 @@ ip6 test-ip6 input
 
 # icmpv6 type mld-listener-query accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000082 ]
@@ -48,7 +48,7 @@ ip6 test-ip6 input
 
 # icmpv6 type mld-listener-report accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000083 ]
@@ -56,7 +56,7 @@ ip6 test-ip6 input
 
 # icmpv6 type mld-listener-done accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
@@ -64,7 +64,7 @@ ip6 test-ip6 input
 
 # icmpv6 type mld-listener-reduction accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
@@ -72,7 +72,7 @@ ip6 test-ip6 input
 
 # icmpv6 type nd-router-solicit accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000085 ]
@@ -80,7 +80,7 @@ ip6 test-ip6 input
 
 # icmpv6 type nd-router-advert accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000086 ]
@@ -88,7 +88,7 @@ ip6 test-ip6 input
 
 # icmpv6 type nd-neighbor-solicit accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000087 ]
@@ -96,7 +96,7 @@ ip6 test-ip6 input
 
 # icmpv6 type nd-neighbor-advert accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
@@ -104,7 +104,7 @@ ip6 test-ip6 input
 
 # icmpv6 type nd-redirect accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000089 ]
@@ -112,7 +112,7 @@ ip6 test-ip6 input
 
 # icmpv6 type parameter-problem accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000004 ]
@@ -120,7 +120,7 @@ ip6 test-ip6 input
 
 # icmpv6 type router-renumbering accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x0000008a ]
@@ -128,7 +128,7 @@ ip6 test-ip6 input
 
 # icmpv6 type ind-neighbor-solicit accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x0000008d ]
@@ -136,7 +136,7 @@ ip6 test-ip6 input
 
 # icmpv6 type ind-neighbor-advert accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x0000008e ]
@@ -144,7 +144,7 @@ ip6 test-ip6 input
 
 # icmpv6 type mld2-listener-report accept
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x0000008f ]
@@ -155,7 +155,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000001  : 0 [end]	element 00000003  : 0 [end]	element 00000085  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -166,7 +166,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 0000008a  : 0 [end]	element 00000084  : 0 [end]	element 00000003  : 0 [end]	element 00000085  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -177,7 +177,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000082  : 0 [end]	element 00000003  : 0 [end]	element 00000086  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -188,7 +188,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000082  : 0 [end]	element 00000003  : 0 [end]	element 00000086  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -196,14 +196,14 @@ ip6 test-ip6 input
 
 # icmpv6 code 4
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000004 ]
 
 # icmpv6 code 3-66
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000003 ]
@@ -214,7 +214,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -225,7 +225,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -236,7 +236,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000003  : 0 [end]	element 00000043  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -246,14 +246,14 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000003  : 0 [end]	element 00000043  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmpv6 checksum 2222 log
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000ae08 ]
@@ -261,7 +261,7 @@ ip6 test-ip6 input
 
 # icmpv6 checksum != 2222 log
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp neq reg 1 0x0000ae08 ]
@@ -269,7 +269,7 @@ ip6 test-ip6 input
 
 # icmpv6 checksum 222-226
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x0000de00 ]
@@ -277,7 +277,7 @@ ip6 test-ip6 input
 
 # icmpv6 checksum != 2222 log
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp neq reg 1 0x0000ae08 ]
@@ -288,7 +288,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 0000de00  : 0 [end]	element 0000e200  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -298,7 +298,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 0000de00  : 0 [end]	element 0000e200  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -308,7 +308,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 0000de00  : 0 [end]	element 0000e300  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -318,28 +318,28 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 0000de00  : 0 [end]	element 0000e300  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmpv6 mtu 22
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x16000000 ]
 
 # icmpv6 mtu != 233
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp neq reg 1 0xe9000000 ]
 
 # icmpv6 mtu 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x21000000 ]
@@ -347,7 +347,7 @@ ip6 test-ip6 input
 
 # icmpv6 mtu != 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x21000000 0x2d000000 ]
@@ -357,7 +357,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -367,7 +367,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -377,7 +377,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -387,14 +387,14 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmpv6 id 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -402,7 +402,7 @@ ip6 test-ip6 input
 
 # icmpv6 id != 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -412,7 +412,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -422,7 +422,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -432,7 +432,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -442,14 +442,14 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmpv6 sequence 2
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000200 ]
@@ -459,7 +459,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -470,7 +470,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -481,7 +481,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000200  : 0 [end]	element 00000400  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -491,14 +491,14 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000200  : 0 [end]	element 00000400  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmpv6 sequence 2-4
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ cmp gte reg 1 0x00000200 ]
@@ -506,7 +506,7 @@ ip6 test-ip6 input
 
 # icmpv6 sequence != 2-4
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ range neq reg 1 0x00000200 0x00000400 ]
@@ -516,7 +516,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000200  : 0 [end]	element 00000500  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -526,14 +526,14 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000200  : 0 [end]	element 00000500  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # icmpv6 max-delay 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -541,7 +541,7 @@ ip6 test-ip6 input
 
 # icmpv6 max-delay != 33-45
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -551,7 +551,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -561,7 +561,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -571,7 +571,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -581,7 +581,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
diff --git a/tests/py/ip6/masquerade.t.payload.ip6 b/tests/py/ip6/masquerade.t.payload.ip6
index 31cedf1ff00c..04f328b8c65e 100644
--- a/tests/py/ip6/masquerade.t.payload.ip6
+++ b/tests/py/ip6/masquerade.t.payload.ip6
@@ -1,6 +1,6 @@
 # udp dport 53 masquerade
 ip6 test-ip6 postrouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -8,7 +8,7 @@ ip6 test-ip6 postrouting
 
 # udp dport 53 masquerade random
 ip6 test-ip6 postrouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -16,7 +16,7 @@ ip6 test-ip6 postrouting
 
 # udp dport 53 masquerade random,persistent
 ip6 test-ip6 postrouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -24,7 +24,7 @@ ip6 test-ip6 postrouting
 
 # udp dport 53 masquerade random,persistent,fully-random
 ip6 test-ip6 postrouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -32,7 +32,7 @@ ip6 test-ip6 postrouting
 
 # udp dport 53 masquerade random,fully-random
 ip6 test-ip6 postrouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -40,7 +40,7 @@ ip6 test-ip6 postrouting
 
 # udp dport 53 masquerade random,fully-random,persistent
 ip6 test-ip6 postrouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -48,7 +48,7 @@ ip6 test-ip6 postrouting
 
 # udp dport 53 masquerade persistent
 ip6 test-ip6 postrouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -56,7 +56,7 @@ ip6 test-ip6 postrouting
 
 # udp dport 53 masquerade persistent,random
 ip6 test-ip6 postrouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -64,7 +64,7 @@ ip6 test-ip6 postrouting
 
 # udp dport 53 masquerade persistent,random,fully-random
 ip6 test-ip6 postrouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -72,7 +72,7 @@ ip6 test-ip6 postrouting
 
 # udp dport 53 masquerade persistent,fully-random
 ip6 test-ip6 postrouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -80,7 +80,7 @@ ip6 test-ip6 postrouting
 
 # udp dport 53 masquerade persistent,fully-random,random
 ip6 test-ip6 postrouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -91,7 +91,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]	element 00000800  : 0 [end]	element 00006500  : 0 [end]	element 0000ca00  : 0 [end]	element 00002f01  : 0 [end]	element 0000e903  : 0 [end]	element 0000d207  : 0 [end]	element 0000bb0b  : 0 [end]
 ip6 test-ip6 postrouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -102,7 +102,7 @@ ip6 test-ip6 postrouting
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ cmp gte reg 1 0x000000fe 0x00000000 0x00000000 0x01000000 ]
   [ cmp lte reg 1 0x000000fe 0x00000000 0x00000000 0x00020000 ]
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -119,7 +119,7 @@ ip6 test-ip6 postrouting
   [ ct load state => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000000a ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
diff --git a/tests/py/ip6/redirect.t.payload.ip6 b/tests/py/ip6/redirect.t.payload.ip6
index f256326acf4b..8731194f729e 100644
--- a/tests/py/ip6/redirect.t.payload.ip6
+++ b/tests/py/ip6/redirect.t.payload.ip6
@@ -4,7 +4,7 @@ ip6 test-ip6 output
 
 # udp dport 954 redirect
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000ba03 ]
@@ -19,7 +19,7 @@ ip6 test-ip6 output
 
 # udp dport 53 redirect random
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -27,7 +27,7 @@ ip6 test-ip6 output
 
 # udp dport 53 redirect random,persistent
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -35,7 +35,7 @@ ip6 test-ip6 output
 
 # udp dport 53 redirect random,persistent,fully-random
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -43,7 +43,7 @@ ip6 test-ip6 output
 
 # udp dport 53 redirect random,fully-random
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -51,7 +51,7 @@ ip6 test-ip6 output
 
 # udp dport 53 redirect random,fully-random,persistent
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -59,7 +59,7 @@ ip6 test-ip6 output
 
 # udp dport 53 redirect persistent
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -67,7 +67,7 @@ ip6 test-ip6 output
 
 # udp dport 53 redirect persistent,random
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -75,7 +75,7 @@ ip6 test-ip6 output
 
 # udp dport 53 redirect persistent,random,fully-random
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -83,7 +83,7 @@ ip6 test-ip6 output
 
 # udp dport 53 redirect persistent,fully-random
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -91,7 +91,7 @@ ip6 test-ip6 output
 
 # udp dport 53 redirect persistent,fully-random,random
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -99,7 +99,7 @@ ip6 test-ip6 output
 
 # udp dport 1234 redirect to :1234
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000d204 ]
@@ -110,7 +110,7 @@ ip6 test-ip6 output
 ip6 test-ip6 output
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ cmp eq reg 1 0x000000fe 0x00000000 0x00000000 0xfeca0000 ]
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000e27 ]
@@ -127,7 +127,7 @@ ip6 test-ip6 output
 
 # tcp dport 39128 redirect to :993
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000d898 ]
@@ -136,7 +136,7 @@ ip6 test-ip6 output
 
 # tcp dport 9128 redirect to :993 random
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
@@ -145,7 +145,7 @@ ip6 test-ip6 output
 
 # tcp dport 9128 redirect to :993 fully-random,persistent
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
@@ -157,7 +157,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]	element 00000800  : 0 [end]	element 00006500  : 0 [end]	element 0000ca00  : 0 [end]	element 00002f01  : 0 [end]	element 0000e903  : 0 [end]	element 0000d207  : 0 [end]	element 0000bb0b  : 0 [end]
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -168,7 +168,7 @@ ip6 test-ip6 output
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ cmp gte reg 1 0x000000fe 0x00000000 0x00000000 0x01000000 ]
   [ cmp lte reg 1 0x000000fe 0x00000000 0x00000000 0x00020000 ]
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
@@ -185,7 +185,7 @@ ip6 test-ip6 output
   [ ct load state => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000000a ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
diff --git a/tests/py/ip6/reject.t.payload.ip6 b/tests/py/ip6/reject.t.payload.ip6
index fcae382b89c6..0ba5f7ee5bfd 100644
--- a/tests/py/ip6/reject.t.payload.ip6
+++ b/tests/py/ip6/reject.t.payload.ip6
@@ -28,7 +28,7 @@ ip6 test-ip6 output
 
 # reject with tcp reset
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ reject type 1 code 0 ]
 
diff --git a/tests/py/ip6/snat.t.payload.ip6 b/tests/py/ip6/snat.t.payload.ip6
index ea403638dd8f..537e6682aa38 100644
--- a/tests/py/ip6/snat.t.payload.ip6
+++ b/tests/py/ip6/snat.t.payload.ip6
@@ -1,6 +1,6 @@
 # tcp dport 80-90 snat to [2001:838:35f:1::]-[2001:838:35f:2::]:80-100
 ip6 test-ip6 postrouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00005000 ]
@@ -13,7 +13,7 @@ ip6 test-ip6 postrouting
 
 # tcp dport 80-90 snat to [2001:838:35f:1::]-[2001:838:35f:2::]:100
 ip6 test-ip6 postrouting
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00005000 ]
diff --git a/tests/py/ip6/tcpopt.t.payload b/tests/py/ip6/tcpopt.t.payload
index 88e277d1c94b..4b1891974c75 100644
--- a/tests/py/ip6/tcpopt.t.payload
+++ b/tests/py/ip6/tcpopt.t.payload
@@ -1,181 +1,181 @@
 # tcp option eol kind 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option noop kind 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option maxseg kind 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option maxseg length 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option maxseg size 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
 
 # tcp option window kind 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option window length 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option window count 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack-permitted kind 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack-permitted length 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack kind 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack length 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack left 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack0 left 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack1 left 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack2 left 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack3 left 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack right 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack0 right 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack1 right 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack2 right 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option sack3 right 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option timestamp kind 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option timestamp length 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option timestamp tsval 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # tcp option timestamp tsecr 1
 ip6 test-ip input
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 8 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
-- 
2.10.2

