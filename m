From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nft 7/7] tests/py/{udp,udplite}: Unmark inverted set lookup
Date: Thu, 24 Nov 2016 15:16:26 +0100
Message-ID: <1f0babc283a65c362d68640542aa1c86748ecf3e.1479994191.git.anatole@rezel.net>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:59142 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965011AbcKXOW7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 09:22:59 -0500
In-Reply-To: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
In-Reply-To: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Anatole Denis <anatole@rezel.net>
---
 tests/py/inet/udp.t                    | 24 ++++-----
 tests/py/inet/udp.t.payload.inet       | 95 ++++++++++++++++++++++++++++++++++
 tests/py/inet/udp.t.payload.ip         | 95 ++++++++++++++++++++++++++++++++++
 tests/py/inet/udp.t.payload.ip6        | 95 ++++++++++++++++++++++++++++++++++
 tests/py/inet/udp.t.payload.netdev     | 95 ++++++++++++++++++++++++++++++++++
 tests/py/inet/udplite.t                | 14 ++---
 tests/py/inet/udplite.t.payload.inet   | 74 ++++++++++++++++++++++++++
 tests/py/inet/udplite.t.payload.ip     | 74 ++++++++++++++++++++++++++
 tests/py/inet/udplite.t.payload.ip6    | 74 ++++++++++++++++++++++++++
 tests/py/inet/udplite.t.payload.netdev | 74 ++++++++++++++++++++++++++
 10 files changed, 692 insertions(+), 22 deletions(-)

diff --git a/tests/py/inet/udp.t b/tests/py/inet/udp.t
index 060985c..2f16e6a 100644
--- a/tests/py/inet/udp.t
+++ b/tests/py/inet/udp.t
@@ -11,45 +11,39 @@ udp sport != 60 accept;ok
 udp sport 50-70 accept;ok
 udp sport != 50-60 accept;ok
 udp sport { 49, 50} drop;ok
-- udp sport != { 50, 60} accept;ok
-# BUG: invalid expression type set
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+udp sport != { 50, 60} accept;ok
 udp sport { 12-40};ok
-- udp sport != { 13-24};ok
+udp sport != { 13-24};ok
 
 udp dport 80 accept;ok
 udp dport != 60 accept;ok
 udp dport 70-75 accept;ok
 udp dport != 50-60 accept;ok
 udp dport { 49, 50} drop;ok
-- udp dport != { 50, 60} accept;ok
-# BUG: invalid expression type set
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+udp dport != { 50, 60} accept;ok
 udp dport { 70-75} accept;ok
-- udp dport != { 50-60} accept;ok
+udp dport != { 50-60} accept;ok
 
 udp length 6666;ok
 udp length != 6666;ok
 udp length 50-65 accept;ok
 udp length != 50-65 accept;ok
 udp length { 50, 65} accept;ok
-- udp length != { 50, 65} accept;ok
+udp length != { 50, 65} accept;ok
 udp length { 35-50};ok
-- udp length != { 35-50};ok
+udp length != { 35-50};ok
 
 udp checksum 6666 drop;ok
-- udp checksum != { 444, 555} accept;ok
-# BUG: invalid expression type set
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+udp checksum != { 444, 555} accept;ok
 
 udp checksum 22;ok
 udp checksum != 233;ok
 udp checksum 33-45;ok
 udp checksum != 33-45;ok
 udp checksum { 33, 55, 67, 88};ok
-- udp checksum != { 33, 55, 67, 88};ok
+udp checksum != { 33, 55, 67, 88};ok
 udp checksum { 33-55};ok
-- udp checksum != { 33-55};ok
+udp checksum != { 33-55};ok
 
 # limit impact to lo
 iif "lo" udp checksum set 0;ok
diff --git a/tests/py/inet/udp.t.payload.inet b/tests/py/inet/udp.t.payload.inet
index 8fdffbf..ca27953 100644
--- a/tests/py/inet/udp.t.payload.inet
+++ b/tests/py/inet/udp.t.payload.inet
@@ -42,6 +42,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udp sport != { 50, 60} accept
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp sport { 12-40}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -52,6 +63,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp sport != { 13-24}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000d00  : 0 [end]	element 00001900  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udp dport 80 accept
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
@@ -96,6 +117,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udp dport != { 50, 60} accept
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp dport { 70-75} accept
 __set%d test-inet 7
 __set%d test-inet 0
@@ -107,6 +139,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# udp dport != { 50-60} accept
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00003200  : 0 [end]	element 00003d00  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp length 6666
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
@@ -149,6 +192,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# udp length != { 50, 65} accept
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00003200  : 0 [end]	element 00004100  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp length { 35-50}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -159,6 +213,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp length != { 35-50}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udp checksum 6666 drop
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
@@ -167,6 +231,17 @@ inet test-inet input
   [ cmp eq reg 1 0x00000a1a ]
   [ immediate reg 0 drop ]
 
+# udp checksum != { 444, 555} accept
+__set%d test-inet 3
+__set%d test-inet 0
+	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp checksum 22
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
@@ -206,6 +281,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp checksum != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udp checksum { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -216,6 +301,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp checksum != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # iif "lo" udp checksum set 0
 inet test-inet input
   [ meta load iif => reg 1 ]
diff --git a/tests/py/inet/udp.t.payload.ip b/tests/py/inet/udp.t.payload.ip
index 1d41017..9f1d0c7 100644
--- a/tests/py/inet/udp.t.payload.ip
+++ b/tests/py/inet/udp.t.payload.ip
@@ -42,6 +42,17 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udp sport != { 50, 60} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp sport { 12-40}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -52,6 +63,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp sport != { 13-24}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00000d00  : 0 [end]	element 00001900  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udp dport 80 accept
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -96,6 +117,17 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udp dport != { 50, 60} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp dport { 70-75} accept
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -107,6 +139,17 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# udp dport != { 50-60} accept
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00003200  : 0 [end]	element 00003d00  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp length 6666
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -149,6 +192,17 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# udp length != { 50, 65} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00003200  : 0 [end]	element 00004100  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp length { 35-50}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -159,6 +213,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp length != { 35-50}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udp checksum 6666 drop
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -167,6 +231,17 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000a1a ]
   [ immediate reg 0 drop ]
 
+# udp checksum != { 444, 555} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp checksum 22
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -206,6 +281,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp checksum != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udp checksum { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -216,6 +301,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp checksum != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # iif "lo" udp checksum set 0
 ip test-ip4 input
   [ meta load iif => reg 1 ]
diff --git a/tests/py/inet/udp.t.payload.ip6 b/tests/py/inet/udp.t.payload.ip6
index 17b6679..af17e1c 100644
--- a/tests/py/inet/udp.t.payload.ip6
+++ b/tests/py/inet/udp.t.payload.ip6
@@ -42,6 +42,17 @@ ip6 test-ip6 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udp sport != { 50, 60} accept
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp sport { 12-40}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -52,6 +63,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp sport != { 13-24}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000d00  : 0 [end]	element 00001900  : 1 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udp dport 80 accept
 ip6 test-ip6 input 
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -96,6 +117,17 @@ ip6 test-ip6 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udp dport != { 50, 60} accept
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp dport { 70-75} accept
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -107,6 +139,17 @@ ip6 test-ip6 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# udp dport != { 50-60} accept
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00003200  : 0 [end]	element 00003d00  : 1 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp length 6666
 ip6 test-ip6 input 
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -149,6 +192,17 @@ ip6 test-ip6 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# udp length != { 50, 65} accept
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00003200  : 0 [end]	element 00004100  : 0 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp length { 35-50}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -159,6 +213,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp length != { 35-50}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udp checksum 6666 drop
 ip6 test-ip6 input 
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -167,6 +231,17 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000a1a ]
   [ immediate reg 0 drop ]
 
+# udp checksum != { 444, 555} accept
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp checksum 22
 ip6 test-ip6 input 
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -206,6 +281,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp checksum != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udp checksum { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -216,6 +301,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp checksum != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # iif "lo" udp checksum set 0
 ip6 test-ip6 input
   [ meta load iif => reg 1 ]
diff --git a/tests/py/inet/udp.t.payload.netdev b/tests/py/inet/udp.t.payload.netdev
index 9e93ae4..832c913 100644
--- a/tests/py/inet/udp.t.payload.netdev
+++ b/tests/py/inet/udp.t.payload.netdev
@@ -42,6 +42,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udp sport != { 50, 60} accept
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp sport { 12-40}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -52,6 +63,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp sport != { 13-24}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000d00  : 0 [end]	element 00001900  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udp dport 80 accept
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
@@ -96,6 +117,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udp dport != { 50, 60} accept
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00003200  : 0 [end]	element 00003c00  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp dport { 70-75} accept
 __set%d test-inet 7
 __set%d test-inet 0
@@ -107,6 +139,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# udp dport != { 50-60} accept
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00003200  : 0 [end]	element 00003d00  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp length 6666
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
@@ -149,6 +192,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# udp length != { 50, 65} accept
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00003200  : 0 [end]	element 00004100  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp length { 35-50}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -159,6 +213,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp length != { 35-50}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udp checksum 6666 drop
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
@@ -167,6 +231,17 @@ inet test-inet input
   [ cmp eq reg 1 0x00000a1a ]
   [ immediate reg 0 drop ]
 
+# udp checksum != { 444, 555} accept
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udp checksum 22
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
@@ -206,6 +281,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp checksum != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udp checksum { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -216,6 +301,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udp checksum != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # iif "lo" udp checksum set 0
 netdev test-netdev ingress
   [ meta load iif => reg 1 ]
diff --git a/tests/py/inet/udplite.t b/tests/py/inet/udplite.t
index 2800036..7c22acb 100644
--- a/tests/py/inet/udplite.t
+++ b/tests/py/inet/udplite.t
@@ -11,18 +11,18 @@ udplite sport != 60 accept;ok
 udplite sport 50-70 accept;ok
 udplite sport != 50-60 accept;ok
 udplite sport { 49, 50} drop;ok
-- udplite sport != { 50, 60} accept;ok
+udplite sport != { 49, 50} accept;ok
 udplite sport { 12-40};ok
-- udplite sport != { 13-24};ok
+udplite sport != { 12-40};ok
 
 udplite dport 80 accept;ok
 udplite dport != 60 accept;ok
 udplite dport 70-75 accept;ok
 udplite dport != 50-60 accept;ok
 udplite dport { 49, 50} drop;ok
-- udplite dport != { 50, 60} accept;ok
+udplite dport != { 49, 50} accept;ok
 udplite dport { 70-75} accept;ok
-- udplite dport != { 50-60} accept;ok
+udplite dport != { 70-75} accept;ok
 
 - udplite csumcov 6666;ok
 - udplite csumcov != 6666;ok
@@ -34,12 +34,12 @@ udplite dport { 70-75} accept;ok
 - udplite csumcov != { 35-50};ok
 
 udplite checksum 6666 drop;ok
-- udplite checksum != { 444, 555} accept;ok
+udplite checksum != { 444, 555} accept;ok
 udplite checksum 22;ok
 udplite checksum != 233;ok
 udplite checksum 33-45;ok
 udplite checksum != 33-45;ok
 udplite checksum { 33, 55, 67, 88};ok
-- udplite checksum != { 33, 55, 67, 88};ok
+udplite checksum != { 33, 55, 67, 88};ok
 udplite checksum { 33-55};ok
-- udplite checksum != { 33-55};ok
+udplite checksum != { 33-55};ok
diff --git a/tests/py/inet/udplite.t.payload.inet b/tests/py/inet/udplite.t.payload.inet
index ad2c970..eb3dc07 100644
--- a/tests/py/inet/udplite.t.payload.inet
+++ b/tests/py/inet/udplite.t.payload.inet
@@ -42,6 +42,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udplite sport != { 49, 50} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite sport { 12-40}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -52,6 +63,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udplite sport != { 12-40}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udplite dport 80 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -96,6 +117,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udplite dport != { 49, 50} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite dport { 70-75} accept
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -107,6 +139,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# udplite dport != { 70-75} accept
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite checksum 6666 drop
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -115,6 +158,17 @@ inet test-inet input
   [ cmp eq reg 1 0x00000a1a ]
   [ immediate reg 0 drop ]
 
+# udplite checksum != { 444, 555} accept
+__set%d test-inet 3
+__set%d test-inet 0
+	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite checksum 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -154,6 +208,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udplite checksum != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udplite checksum { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -164,3 +228,13 @@ inet test-inet input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udplite checksum != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/inet/udplite.t.payload.ip b/tests/py/inet/udplite.t.payload.ip
index 8321c23..c1ecc9d 100644
--- a/tests/py/inet/udplite.t.payload.ip
+++ b/tests/py/inet/udplite.t.payload.ip
@@ -42,6 +42,17 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udplite sport != { 49, 50} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite sport { 12-40}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -52,6 +63,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udplite sport != { 12-40}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udplite dport 80 accept
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -96,6 +117,17 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udplite dport != { 49, 50} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite dport { 70-75} accept
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -107,6 +139,17 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# udplite dport != { 70-75} accept
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite checksum 6666 drop
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -115,6 +158,17 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000a1a ]
   [ immediate reg 0 drop ]
 
+# udplite checksum != { 444, 555} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
+ip test-ip4 input 
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite checksum 22
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -154,6 +208,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udplite checksum != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udplite checksum { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -164,3 +228,13 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udplite checksum != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/inet/udplite.t.payload.ip6 b/tests/py/inet/udplite.t.payload.ip6
index dce215d..47f25cd 100644
--- a/tests/py/inet/udplite.t.payload.ip6
+++ b/tests/py/inet/udplite.t.payload.ip6
@@ -42,6 +42,17 @@ ip6 test-ip6 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udplite sport != { 49, 50} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite sport { 12-40}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -52,6 +63,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udplite sport != { 12-40}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udplite dport 80 accept
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -96,6 +117,17 @@ ip6 test-ip6 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udplite dport != { 49, 50} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite dport { 70-75} accept
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -107,6 +139,17 @@ ip6 test-ip6 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# udplite dport != { 70-75} accept
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite checksum 6666 drop
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -115,6 +158,17 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000a1a ]
   [ immediate reg 0 drop ]
 
+# udplite checksum != { 444, 555} accept
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite checksum 22
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -154,6 +208,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udplite checksum != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udplite checksum { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -164,3 +228,13 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udplite checksum != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/inet/udplite.t.payload.netdev b/tests/py/inet/udplite.t.payload.netdev
index ad2c970..565935a 100644
--- a/tests/py/inet/udplite.t.payload.netdev
+++ b/tests/py/inet/udplite.t.payload.netdev
@@ -42,6 +42,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udplite sport != { 49, 50} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite sport { 12-40}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -52,6 +63,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udplite sport != { 12-40}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udplite dport 80 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -96,6 +117,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# udplite dport != { 49, 50} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite dport { 70-75} accept
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -107,6 +139,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# udplite dport != { 70-75} accept
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite checksum 6666 drop
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -115,6 +158,17 @@ inet test-inet input
   [ cmp eq reg 1 0x00000a1a ]
   [ immediate reg 0 drop ]
 
+# udplite checksum != { 444, 555} accept
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 0000bc01  : 0 [end]	element 00002b02  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # udplite checksum 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -154,6 +208,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udplite checksum != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # udplite checksum { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -164,3 +228,13 @@ inet test-inet input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# udplite checksum != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
-- 
2.11.0.rc2

