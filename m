From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nft 5/7] tests/py{ah,esp,comp}: Unmark inverted set lookup
Date: Thu, 24 Nov 2016 15:16:24 +0100
Message-ID: <6b031bc74227dc83f2541972f10dd280265bffbe.1479994191.git.anatole@rezel.net>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:59146 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965732AbcKXOW7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 09:22:59 -0500
In-Reply-To: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
In-Reply-To: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Anatole Denis <anatole@rezel.net>
---
 tests/py/inet/ah.t                  | 21 ++++------
 tests/py/inet/ah.t.payload.inet     | 80 +++++++++++++++++++++++++++++++++++++
 tests/py/inet/ah.t.payload.ip       | 80 +++++++++++++++++++++++++++++++++++++
 tests/py/inet/ah.t.payload.ip6      | 80 +++++++++++++++++++++++++++++++++++++
 tests/py/inet/ah.t.payload.netdev   | 80 +++++++++++++++++++++++++++++++++++++
 tests/py/inet/comp.t                |  8 ++--
 tests/py/inet/comp.t.payload.inet   | 40 +++++++++++++++++++
 tests/py/inet/comp.t.payload.ip     | 40 +++++++++++++++++++
 tests/py/inet/comp.t.payload.ip6    | 40 +++++++++++++++++++
 tests/py/inet/comp.t.payload.netdev | 40 +++++++++++++++++++
 tests/py/inet/esp.t                 |  8 ++--
 tests/py/inet/esp.t.payload.inet    | 40 +++++++++++++++++++
 tests/py/inet/esp.t.payload.ip      | 40 +++++++++++++++++++
 tests/py/inet/esp.t.payload.ip6     | 40 +++++++++++++++++++
 tests/py/inet/esp.t.payload.netdev  | 40 +++++++++++++++++++
 15 files changed, 655 insertions(+), 22 deletions(-)

diff --git a/tests/py/inet/ah.t b/tests/py/inet/ah.t
index ef52c2c..8544d9d 100644
--- a/tests/py/inet/ah.t
+++ b/tests/py/inet/ah.t
@@ -23,39 +23,34 @@
 ah hdrlength 11-23;ok
 ah hdrlength != 11-23;ok
 ah hdrlength { 11-23};ok
-- ah hdrlength != { 11-23};ok
+ah hdrlength != { 11-23};ok
 ah hdrlength {11, 23, 44 };ok
-- ah hdrlength != {11-23 };ok
+ah hdrlength != {11, 23, 44 };ok
 
 ah reserved 22;ok
 ah reserved != 233;ok
 ah reserved 33-45;ok
 ah reserved != 33-45;ok
 ah reserved {23, 100};ok
-- ah reserved != {33, 55, 67, 88};ok
+ah reserved != {23, 100};ok
 ah reserved { 33-55};ok
-- ah reserved != { 33-55};ok
+ah reserved != { 33-55};ok
 
 ah spi 111;ok
 ah spi != 111;ok
 ah spi 111-222;ok
 ah spi != 111-222;ok
 ah spi {111, 122};ok
-- ah spi != {111, 122};ok
-# BUG: invalid expression type set
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
-
+ah spi != {111, 122};ok
 ah spi { 111-122};ok
-- ah spi != { 111-122};ok
-# BUG: invalid expression type set
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+ah spi != { 111-122};ok
 
 # sequence
 ah sequence 123;ok
 ah sequence != 123;ok
 ah sequence {23, 25, 33};ok
-- ah sequence != {23, 25, 33};ok
+ah sequence != {23, 25, 33};ok
 ah sequence { 23-33};ok
-- ah sequence != { 33-44};ok
+ah sequence != { 23-33};ok
 ah sequence 23-33;ok
 ah sequence != 23-33;ok
diff --git a/tests/py/inet/ah.t.payload.inet b/tests/py/inet/ah.t.payload.inet
index 1e56797..5ec5fba 100644
--- a/tests/py/inet/ah.t.payload.inet
+++ b/tests/py/inet/ah.t.payload.inet
@@ -23,6 +23,16 @@ inet test-inet input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah hdrlength != { 11-23}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah hdrlength {11, 23, 44 }
 __set%d test-inet 3
 __set%d test-inet 0
@@ -33,6 +43,16 @@ inet test-inet input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah hdrlength != {11, 23, 44 }
+__set%d test-inet 3
+__set%d test-inet 0
+	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah reserved 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -72,6 +92,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah reserved != {23, 100}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00001700  : 0 [end]	element 00006400  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah reserved { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -82,6 +112,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah reserved != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah spi 111
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -121,6 +161,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah spi != {111, 122}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah spi { 111-122}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -131,6 +181,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah spi != { 111-122}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah sequence 123
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -155,6 +215,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah sequence != {23, 25, 33}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah sequence { 23-33}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -165,6 +235,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah sequence != { 23-33}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah sequence 23-33
 inet test-inet input
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/inet/ah.t.payload.ip b/tests/py/inet/ah.t.payload.ip
index 5ad0041..594c949 100644
--- a/tests/py/inet/ah.t.payload.ip
+++ b/tests/py/inet/ah.t.payload.ip
@@ -23,6 +23,16 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah hdrlength != { 11-23}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah hdrlength {11, 23, 44 }
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -33,6 +43,16 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah hdrlength != {11, 23, 44 }
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah reserved 22
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -72,6 +92,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah reserved != {23, 100}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00001700  : 0 [end]	element 00006400  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah reserved { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -82,6 +112,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah reserved != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah spi 111
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -121,6 +161,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah spi != {111, 122}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah spi { 111-122}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -131,6 +181,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah spi != { 111-122}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah sequence 123
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -155,6 +215,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah sequence != {23, 25, 33}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah sequence { 23-33}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -165,6 +235,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah sequence != { 23-33}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah sequence 23-33
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
diff --git a/tests/py/inet/ah.t.payload.ip6 b/tests/py/inet/ah.t.payload.ip6
index c57a28a..f12f0a0 100644
--- a/tests/py/inet/ah.t.payload.ip6
+++ b/tests/py/inet/ah.t.payload.ip6
@@ -23,6 +23,16 @@ ip6 test-ip6 input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah hdrlength != { 11-23}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah hdrlength {11, 23, 44 }
 __set%d test-ip6 3
 __set%d test-ip6 0
@@ -33,6 +43,16 @@ ip6 test-ip6 input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah hdrlength != {11, 23, 44 }
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah reserved 22
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -72,6 +92,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah reserved != {23, 100}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00001700  : 0 [end]	element 00006400  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah reserved { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -82,6 +112,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah reserved != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah spi 111
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -121,6 +161,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah spi != {111, 122}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah spi { 111-122}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -131,6 +181,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah spi != { 111-122}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah sequence 123
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -155,6 +215,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah sequence != {23, 25, 33}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah sequence { 23-33}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -165,6 +235,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah sequence != { 23-33}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah sequence 23-33
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
diff --git a/tests/py/inet/ah.t.payload.netdev b/tests/py/inet/ah.t.payload.netdev
index e06811d..af15096 100644
--- a/tests/py/inet/ah.t.payload.netdev
+++ b/tests/py/inet/ah.t.payload.netdev
@@ -23,6 +23,16 @@ netdev test-netdev ingress
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah hdrlength != { 11-23}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah hdrlength {11, 23, 44 }
 __set%d test-netdev 3
 __set%d test-netdev 0
@@ -33,6 +43,16 @@ netdev test-netdev ingress
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah hdrlength != {11, 23, 44 }
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 0000000b  : 0 [end]	element 00000017  : 0 [end]	element 0000002c  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah reserved 22
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
@@ -72,6 +92,16 @@ netdev test-netdev ingress
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah reserved != {23, 100}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00001700  : 0 [end]	element 00006400  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah reserved { 33-55}
 __set%d test-netdev 7
 __set%d test-netdev 0
@@ -82,6 +112,16 @@ netdev test-netdev ingress
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah reserved != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah spi 111
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
@@ -121,6 +161,16 @@ netdev test-netdev ingress
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah spi != {111, 122}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 6f000000  : 0 [end]	element 7a000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah spi { 111-122}
 __set%d test-netdev 7
 __set%d test-netdev 0
@@ -131,6 +181,16 @@ netdev test-netdev ingress
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah spi != { 111-122}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah sequence 123
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
@@ -155,6 +215,16 @@ netdev test-netdev ingress
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah sequence != {23, 25, 33}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 17000000  : 0 [end]	element 19000000  : 0 [end]	element 21000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah sequence { 23-33}
 __set%d test-netdev 7
 __set%d test-netdev 0
@@ -165,6 +235,16 @@ netdev test-netdev ingress
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ah sequence != { 23-33}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ah sequence 23-33
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/inet/comp.t b/tests/py/inet/comp.t
index 654e712..0df1813 100644
--- a/tests/py/inet/comp.t
+++ b/tests/py/inet/comp.t
@@ -19,15 +19,15 @@ comp flags != 0x23;ok
 comp flags 0x33-0x45;ok
 comp flags != 0x33-0x45;ok
 comp flags {0x33, 0x55, 0x67, 0x88};ok
-- comp flags != {0x33, 0x55, 0x67, 0x88};ok
+comp flags != {0x33, 0x55, 0x67, 0x88};ok
 comp flags { 0x33-0x55};ok
-- comp flags != { 0x33-0x55};ok
+comp flags != { 0x33-0x55};ok
 
 comp cpi 22;ok
 comp cpi != 233;ok
 comp cpi 33-45;ok
 comp cpi != 33-45;ok
 comp cpi {33, 55, 67, 88};ok
-- comp cpi != {33, 55, 67, 88};ok
+comp cpi != {33, 55, 67, 88};ok
 comp cpi { 33-55};ok
-- comp cpi != { 33-55};ok
+comp cpi != { 33-55};ok
diff --git a/tests/py/inet/comp.t.payload.inet b/tests/py/inet/comp.t.payload.inet
index cdeba2b..dec38ae 100644
--- a/tests/py/inet/comp.t.payload.inet
+++ b/tests/py/inet/comp.t.payload.inet
@@ -44,6 +44,16 @@ inet test-inet input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp flags != {0x33, 0x55, 0x67, 0x88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # comp flags { 0x33-0x55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -54,6 +64,16 @@ inet test-inet input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp flags != { 0x33-0x55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # comp cpi 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -93,6 +113,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp cpi != {33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # comp cpi { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -103,3 +133,13 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp cpi != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/inet/comp.t.payload.ip b/tests/py/inet/comp.t.payload.ip
index 9da8f94..9a6194e 100644
--- a/tests/py/inet/comp.t.payload.ip
+++ b/tests/py/inet/comp.t.payload.ip
@@ -44,6 +44,16 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp flags != {0x33, 0x55, 0x67, 0x88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # comp flags { 0x33-0x55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -54,6 +64,16 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp flags != { 0x33-0x55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # comp cpi 22
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -93,6 +113,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp cpi != {33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # comp cpi { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -103,3 +133,13 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp cpi != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/inet/comp.t.payload.ip6 b/tests/py/inet/comp.t.payload.ip6
index 69a13ed..a325d8c 100644
--- a/tests/py/inet/comp.t.payload.ip6
+++ b/tests/py/inet/comp.t.payload.ip6
@@ -44,6 +44,16 @@ ip6 test-ip6 input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp flags != {0x33, 0x55, 0x67, 0x88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # comp flags { 0x33-0x55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -54,6 +64,16 @@ ip6 test-ip6 input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp flags != { 0x33-0x55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # comp cpi 22
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -93,6 +113,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp cpi != {33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # comp cpi { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -103,3 +133,13 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp cpi != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/inet/comp.t.payload.netdev b/tests/py/inet/comp.t.payload.netdev
index cdeba2b..dec38ae 100644
--- a/tests/py/inet/comp.t.payload.netdev
+++ b/tests/py/inet/comp.t.payload.netdev
@@ -44,6 +44,16 @@ inet test-inet input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp flags != {0x33, 0x55, 0x67, 0x88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000033  : 0 [end]	element 00000055  : 0 [end]	element 00000067  : 0 [end]	element 00000088  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # comp flags { 0x33-0x55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -54,6 +64,16 @@ inet test-inet input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp flags != { 0x33-0x55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # comp cpi 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -93,6 +113,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp cpi != {33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # comp cpi { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -103,3 +133,13 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# comp cpi != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000006c ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/inet/esp.t b/tests/py/inet/esp.t
index f822da7..e79eead 100644
--- a/tests/py/inet/esp.t
+++ b/tests/py/inet/esp.t
@@ -11,7 +11,7 @@ esp spi != 100;ok
 esp spi 111-222;ok
 esp spi != 111-222;ok
 esp spi { 100, 102};ok
-- esp spi != { 100, 102};ok
+esp spi != { 100, 102};ok
 esp spi { 100-102};ok
 - esp spi {100-102};ok
 
@@ -19,8 +19,6 @@ esp sequence 22;ok
 esp sequence 22-24;ok
 esp sequence != 22-24;ok
 esp sequence { 22, 24};ok
-- esp sequence != { 22, 24};ok
-# BUG: invalid expression type set
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+esp sequence != { 22, 24};ok
 esp sequence { 22-25};ok
-- esp sequence != { 22-25};ok
+esp sequence != { 22-25};ok
diff --git a/tests/py/inet/esp.t.payload.inet b/tests/py/inet/esp.t.payload.inet
index d41f766..ad68530 100644
--- a/tests/py/inet/esp.t.payload.inet
+++ b/tests/py/inet/esp.t.payload.inet
@@ -37,6 +37,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp spi != { 100, 102}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 64000000  : 0 [end]	element 66000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # esp spi { 100-102}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -47,6 +57,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp spi != { 100-102}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # esp sequence 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -79,6 +99,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp sequence != { 22, 24}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 16000000  : 0 [end]	element 18000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # esp sequence { 22-25}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -89,3 +119,13 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp sequence != { 22-25}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/inet/esp.t.payload.ip b/tests/py/inet/esp.t.payload.ip
index 5de41ae..f8ef9ec 100644
--- a/tests/py/inet/esp.t.payload.ip
+++ b/tests/py/inet/esp.t.payload.ip
@@ -37,6 +37,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp spi != { 100, 102}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 64000000  : 0 [end]	element 66000000  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # esp spi { 100-102}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -47,6 +57,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp spi != { 100-102}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # esp sequence 22
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -79,6 +99,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp sequence != { 22, 24}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 16000000  : 0 [end]	element 18000000  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # esp sequence { 22-25}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -89,3 +119,13 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp sequence != { 22-25}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/inet/esp.t.payload.ip6 b/tests/py/inet/esp.t.payload.ip6
index 0bc2e70..4758492 100644
--- a/tests/py/inet/esp.t.payload.ip6
+++ b/tests/py/inet/esp.t.payload.ip6
@@ -37,6 +37,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp spi != { 100, 102}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 64000000  : 0 [end]	element 66000000  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # esp spi { 100-102}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -47,6 +57,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp spi != { 100-102}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # esp sequence 22
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -79,6 +99,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp sequence != { 22, 24}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 16000000  : 0 [end]	element 18000000  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # esp sequence { 22-25}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -89,3 +119,13 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp sequence != { 22-25}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/inet/esp.t.payload.netdev b/tests/py/inet/esp.t.payload.netdev
index d41f766..ad68530 100644
--- a/tests/py/inet/esp.t.payload.netdev
+++ b/tests/py/inet/esp.t.payload.netdev
@@ -37,6 +37,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp spi != { 100, 102}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 64000000  : 0 [end]	element 66000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # esp spi { 100-102}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -47,6 +57,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp spi != { 100-102}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # esp sequence 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -79,6 +99,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp sequence != { 22, 24}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 16000000  : 0 [end]	element 18000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # esp sequence { 22-25}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -89,3 +119,13 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# esp sequence != { 22-25}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
-- 
2.11.0.rc2

