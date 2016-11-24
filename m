From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nft 6/7] tests/py/{dccp,sctp,tcp}: Unmark inverted lookup
Date: Thu, 24 Nov 2016 15:16:25 +0100
Message-ID: <e83457842c3d7571e85f99705f8fec48abe5d880.1479994191.git.anatole@rezel.net>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:59150 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965730AbcKXOW7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 09:22:59 -0500
In-Reply-To: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
In-Reply-To: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Anatole Denis <anatole@rezel.net>
---
 tests/py/inet/dccp.t                |  15 ++--
 tests/py/inet/dccp.t.payload.inet   |  51 ++++++++++++
 tests/py/inet/dccp.t.payload.ip     |  61 ++++++++++++++
 tests/py/inet/dccp.t.payload.ip6    |  61 ++++++++++++++
 tests/py/inet/dccp.t.payload.netdev |  61 ++++++++++++++
 tests/py/inet/sctp.t                |  18 ++--
 tests/py/inet/sctp.t.payload.inet   |  80 ++++++++++++++++++
 tests/py/inet/sctp.t.payload.ip     |  80 ++++++++++++++++++
 tests/py/inet/sctp.t.payload.ip6    |  80 ++++++++++++++++++
 tests/py/inet/sctp.t.payload.netdev |  80 ++++++++++++++++++
 tests/py/inet/tcp.t                 |  32 +++----
 tests/py/inet/tcp.t.payload.inet    | 161 ++++++++++++++++++++++++++++++++++++
 tests/py/inet/tcp.t.payload.ip      | 161 ++++++++++++++++++++++++++++++++++++
 tests/py/inet/tcp.t.payload.ip6     | 161 ++++++++++++++++++++++++++++++++++++
 tests/py/inet/tcp.t.payload.netdev  | 161 ++++++++++++++++++++++++++++++++++++
 15 files changed, 1227 insertions(+), 36 deletions(-)

diff --git a/tests/py/inet/dccp.t b/tests/py/inet/dccp.t
index f5f8b67..f0dd788 100644
--- a/tests/py/inet/dccp.t
+++ b/tests/py/inet/dccp.t
@@ -9,27 +9,22 @@
 dccp sport 21-35;ok
 dccp sport != 21-35;ok
 dccp sport {23, 24, 25};ok
-- dccp sport != { 27, 34};ok
-# BUG: invalid expression type set
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+dccp sport != {23, 24, 25};ok
 
 dccp sport { 20-50 };ok
 dccp sport ftp-data - re-mail-ck;ok;dccp sport 20-50
 dccp sport 20-50;ok
 dccp sport { 20-50};ok
-- dccp sport != {27-34};ok
-# dccp sport != {27-34};ok
-# BUG: invalid expression type set
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+dccp sport != { 20-50};ok
 
 # dccp dport 21-35;ok
 # dccp dport != 21-35;ok
 dccp dport {23, 24, 25};ok
-# dccp dport != {27, 34};ok
+dccp dport != {23, 24, 25};ok
 dccp dport { 20-50};ok
-# dccp dport != {27-34};ok
+dccp dport != { 20-50};ok
 
 dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack};ok
-# dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack};ok
+dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack};ok
 dccp type request;ok
 dccp type != request;ok
diff --git a/tests/py/inet/dccp.t.payload.inet b/tests/py/inet/dccp.t.payload.inet
index ccba6d0..b5a48f4 100644
--- a/tests/py/inet/dccp.t.payload.inet
+++ b/tests/py/inet/dccp.t.payload.inet
@@ -23,6 +23,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp sport != {23, 24, 25}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp sport { 20-50 }
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -59,6 +69,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp sport != { 20-50}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp dport {23, 24, 25}
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -69,6 +89,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp dport != {23, 24, 25}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp dport { 20-50}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -79,6 +109,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp dport != { 20-50}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
 __set%d test-inet 3
 __set%d test-inet 0
@@ -90,6 +130,17 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp type request
 inet test-inet input
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/inet/dccp.t.payload.ip b/tests/py/inet/dccp.t.payload.ip
index a02247f..b8844c5 100644
--- a/tests/py/inet/dccp.t.payload.ip
+++ b/tests/py/inet/dccp.t.payload.ip
@@ -23,6 +23,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp sport != {23, 24, 25}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp sport { 20-50 }
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -33,6 +43,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp sport != { 20-50 }
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp sport ftp-data - re-mail-ck
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -59,6 +79,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp sport != { 20-50}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp dport {23, 24, 25}
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -69,6 +99,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp dport != {23, 24, 25}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp dport { 20-50}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -79,6 +119,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp dport != { 20-50}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -90,6 +140,17 @@ ip test-ip4 input
   [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp type request
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
diff --git a/tests/py/inet/dccp.t.payload.ip6 b/tests/py/inet/dccp.t.payload.ip6
index c81a3a0..0f8aab1 100644
--- a/tests/py/inet/dccp.t.payload.ip6
+++ b/tests/py/inet/dccp.t.payload.ip6
@@ -23,6 +23,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp sport != {23, 24, 25}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp sport { 20-50 }
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -33,6 +43,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp sport != { 20-50 }
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp sport ftp-data - re-mail-ck
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -59,6 +79,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp sport != { 20-50}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp dport {23, 24, 25}
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -69,6 +99,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp dport != {23, 24, 25}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp dport { 20-50}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -79,6 +119,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp dport != { 20-50}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
 __set%d test-ip6 3
 __set%d test-ip6 0
@@ -90,6 +140,17 @@ ip6 test-ip6 input
   [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp type request
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
diff --git a/tests/py/inet/dccp.t.payload.netdev b/tests/py/inet/dccp.t.payload.netdev
index abb1fb9..3136931 100644
--- a/tests/py/inet/dccp.t.payload.netdev
+++ b/tests/py/inet/dccp.t.payload.netdev
@@ -23,6 +23,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp sport != {23, 24, 25}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp sport { 20-50 }
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -33,6 +43,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp sport != { 20-50 }
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp sport ftp-data - re-mail-ck
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -59,6 +79,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp sport != { 20-50}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp dport {23, 24, 25}
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -69,6 +99,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp dport != {23, 24, 25}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp dport { 20-50}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -79,6 +119,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp dport != { 20-50}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
 __set%d test-netdev 3
 __set%d test-netdev 0
@@ -90,6 +140,17 @@ netdev test-netdev ingress
   [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
+netdev test-netdev ingress
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dccp type request
 netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/inet/sctp.t b/tests/py/inet/sctp.t
index 9f522b4..5188b57 100644
--- a/tests/py/inet/sctp.t
+++ b/tests/py/inet/sctp.t
@@ -11,35 +11,33 @@ sctp sport != 23;ok
 sctp sport 23-44;ok
 sctp sport != 23-44;ok
 sctp sport { 23, 24, 25};ok
-- sctp sport != { 23, 24, 25};ok
+sctp sport != { 23, 24, 25};ok
 sctp sport { 23-44};ok
-- sctp sport != { 23-44};ok
-# BUG: invalid expression type set
-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+sctp sport != { 23-44};ok
 
 sctp dport 23;ok
 sctp dport != 23;ok
 sctp dport 23-44;ok
 sctp dport != 23-44;ok
 sctp dport { 23, 24, 25};ok
-- sctp dport != { 23, 24, 25};ok
+sctp dport != { 23, 24, 25};ok
 sctp dport { 23-44};ok
-- sctp dport != { 23-44};ok
+sctp dport != { 23-44};ok
 
 sctp checksum 1111;ok
 sctp checksum != 11;ok
 sctp checksum 21-333;ok
 sctp checksum != 32-111;ok
 sctp checksum { 22, 33, 44};ok
-- sctp checksum != { 22, 33, 44};ok
+sctp checksum != { 22, 33, 44};ok
 sctp checksum { 22-44};ok
-- sctp checksum != { 22-44};ok
+sctp checksum != { 22-44};ok
 
 sctp vtag 22;ok
 sctp vtag != 233;ok
 sctp vtag 33-45;ok
 sctp vtag != 33-45;ok
 sctp vtag {33, 55, 67, 88};ok
-- sctp vtag != {33, 55, 67, 88};ok
+sctp vtag != {33, 55, 67, 88};ok
 sctp vtag { 33-55};ok
-- sctp vtag != { 33-55};ok
+sctp vtag != { 33-55};ok
diff --git a/tests/py/inet/sctp.t.payload.inet b/tests/py/inet/sctp.t.payload.inet
index bc7fe7c..ecfcc72 100644
--- a/tests/py/inet/sctp.t.payload.inet
+++ b/tests/py/inet/sctp.t.payload.inet
@@ -37,6 +37,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp sport != { 23, 24, 25}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp sport { 23-44}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -47,6 +57,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp sport != { 23-44}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp dport 23
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -86,6 +106,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp dport != { 23, 24, 25}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp dport { 23-44}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -96,6 +126,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp dport != { 23-44}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp checksum 1111
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -135,6 +175,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp checksum != { 22, 33, 44}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp checksum { 22-44}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -145,6 +195,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp checksum != { 22-44}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp vtag 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -184,6 +244,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp vtag != {33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp vtag { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -194,3 +264,13 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp vtag != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/inet/sctp.t.payload.ip b/tests/py/inet/sctp.t.payload.ip
index fa6ea43..4d8a724 100644
--- a/tests/py/inet/sctp.t.payload.ip
+++ b/tests/py/inet/sctp.t.payload.ip
@@ -37,6 +37,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp sport != { 23, 24, 25}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp sport { 23-44}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -47,6 +57,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp sport != { 23-44}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp dport 23
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -86,6 +106,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp dport != { 23, 24, 25}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp dport { 23-44}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -96,6 +126,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp dport != { 23-44}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp checksum 1111
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -135,6 +175,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp checksum != { 22, 33, 44}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp checksum { 22-44}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -145,6 +195,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp checksum != { 22-44}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp vtag 22
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -184,6 +244,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp vtag != {33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp vtag { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -194,3 +264,13 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp vtag != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/inet/sctp.t.payload.ip6 b/tests/py/inet/sctp.t.payload.ip6
index 5d11369..5c63d2a 100644
--- a/tests/py/inet/sctp.t.payload.ip6
+++ b/tests/py/inet/sctp.t.payload.ip6
@@ -37,6 +37,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp sport != { 23, 24, 25}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp sport { 23-44}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -47,6 +57,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp sport != { 23-44}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp dport 23
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -86,6 +106,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp dport != { 23, 24, 25}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp dport { 23-44}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -96,6 +126,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp dport != { 23-44}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp checksum 1111
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -135,6 +175,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp checksum != { 22, 33, 44}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp checksum { 22-44}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -145,6 +195,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp checksum != { 22-44}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp vtag 22
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -184,6 +244,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp vtag != {33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp vtag { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -194,3 +264,13 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp vtag != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/inet/sctp.t.payload.netdev b/tests/py/inet/sctp.t.payload.netdev
index bc7fe7c..ecfcc72 100644
--- a/tests/py/inet/sctp.t.payload.netdev
+++ b/tests/py/inet/sctp.t.payload.netdev
@@ -37,6 +37,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp sport != { 23, 24, 25}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp sport { 23-44}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -47,6 +57,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp sport != { 23-44}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp dport 23
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -86,6 +106,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp dport != { 23, 24, 25}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00001700  : 0 [end]	element 00001800  : 0 [end]	element 00001900  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp dport { 23-44}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -96,6 +126,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp dport != { 23-44}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp checksum 1111
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -135,6 +175,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp checksum != { 22, 33, 44}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 16000000  : 0 [end]	element 21000000  : 0 [end]	element 2c000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp checksum { 22-44}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -145,6 +195,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp checksum != { 22-44}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp vtag 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -184,6 +244,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp vtag != {33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # sctp vtag { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -194,3 +264,13 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# sctp vtag != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000084 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index 9618e53..d959284 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -11,14 +11,14 @@ tcp dport != 233;ok
 tcp dport 33-45;ok
 tcp dport != 33-45;ok
 tcp dport { 33, 55, 67, 88};ok
-- tcp dport != { 33, 55, 67, 88};ok
+tcp dport != { 33, 55, 67, 88};ok
 tcp dport { 33-55};ok
-- tcp dport != { 33-55};ok
+tcp dport != { 33-55};ok
 tcp dport {telnet, http, https} accept;ok;tcp dport { 443, 23, 80} accept
 tcp dport vmap { 22 : accept, 23 : drop };ok
 tcp dport vmap { 25:accept, 28:drop };ok
 tcp dport { 22, 53, 80, 110 };ok
-- tcp dport != { 22, 53, 80, 110 };ok
+tcp dport != { 22, 53, 80, 110 };ok
 # BUG: invalid expression type set
 # nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
 
@@ -27,9 +27,9 @@ tcp sport != 233;ok
 tcp sport 33-45;ok
 tcp sport != 33-45;ok
 tcp sport { 33, 55, 67, 88};ok
-- tcp sport != { 33, 55, 67, 88};ok
+tcp sport != { 33, 55, 67, 88};ok
 tcp sport { 33-55};ok
-- tcp sport != { 33-55};ok
+tcp sport != { 33-55};ok
 tcp sport vmap { 25:accept, 28:drop };ok
 
 tcp sport 8080 drop;ok
@@ -44,9 +44,9 @@ tcp sequence != 233;ok
 tcp sequence 33-45;ok
 tcp sequence != 33-45;ok
 tcp sequence { 33, 55, 67, 88};ok
-- tcp sequence != { 33, 55, 67, 88};ok
+tcp sequence != { 33, 55, 67, 88};ok
 tcp sequence { 33-55};ok
-- tcp sequence != { 33-55};ok
+tcp sequence != { 33-55};ok
 
 tcp ackseq 42949672 drop;ok
 tcp ackseq 22;ok
@@ -54,9 +54,9 @@ tcp ackseq != 233;ok
 tcp ackseq 33-45;ok
 tcp ackseq != 33-45;ok
 tcp ackseq { 33, 55, 67, 88};ok
-- tcp ackseq != { 33, 55, 67, 88};ok
+tcp ackseq != { 33, 55, 67, 88};ok
 tcp ackseq { 33-55};ok
-- tcp ackseq != { 33-55};ok
+tcp ackseq != { 33-55};ok
 
 - tcp doff 22;ok
 - tcp doff != 233;ok
@@ -71,7 +71,7 @@ tcp ackseq { 33-55};ok
 # BUG: It is accepted but it is not shown then. tcp reserver
 
 tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop;ok
-- tcp flags != { fin, urg, ecn, cwr} drop;ok
+tcp flags != { fin, urg, ecn, cwr} drop;ok
 tcp flags cwr;ok
 tcp flags != cwr;ok
 
@@ -81,18 +81,18 @@ tcp window != 233;ok
 tcp window 33-45;ok
 tcp window != 33-45;ok
 tcp window { 33, 55, 67, 88};ok
-- tcp window != { 33, 55, 67, 88};ok
+tcp window != { 33, 55, 67, 88};ok
 tcp window { 33-55};ok
-- tcp window != { 33-55};ok
+tcp window != { 33-55};ok
 
 tcp checksum 22;ok
 tcp checksum != 233;ok
 tcp checksum 33-45;ok
 tcp checksum != 33-45;ok
 tcp checksum { 33, 55, 67, 88};ok
-- tcp checksum != { 33, 55, 67, 88};ok
+tcp checksum != { 33, 55, 67, 88};ok
 tcp checksum { 33-55};ok
-- tcp checksum != { 33-55};ok
+tcp checksum != { 33-55};ok
 
 tcp urgptr 1234 accept;ok
 tcp urgptr 22;ok
@@ -100,8 +100,8 @@ tcp urgptr != 233;ok
 tcp urgptr 33-45;ok
 tcp urgptr != 33-45;ok
 tcp urgptr { 33, 55, 67, 88};ok
-- tcp urgptr != { 33, 55, 67, 88};ok
+tcp urgptr != { 33, 55, 67, 88};ok
 tcp urgptr { 33-55};ok
-- tcp urgptr != { 33-55};ok
+tcp urgptr != { 33-55};ok
 
 tcp doff 8;ok
diff --git a/tests/py/inet/tcp.t.payload.inet b/tests/py/inet/tcp.t.payload.inet
index 354d013..583fcd4 100644
--- a/tests/py/inet/tcp.t.payload.inet
+++ b/tests/py/inet/tcp.t.payload.inet
@@ -37,6 +37,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp dport != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp dport { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -47,6 +57,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp dport != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp dport {telnet, http, https} accept
 __set%d test-inet 3
 __set%d test-inet 0
@@ -88,6 +108,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp dport != { 22, 53, 80, 110 }
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sport 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -127,6 +157,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sport != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sport { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -137,6 +177,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sport != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sport vmap { 25:accept, 28:drop }
 __map%d test-inet b
 __map%d test-inet 0
@@ -227,6 +277,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sequence != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sequence { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -237,6 +297,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sequence != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp ackseq 42949672 drop
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -284,6 +354,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp ackseq != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp ackseq { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -294,6 +374,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp ackseq != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
 __set%d test-inet 3
 __set%d test-inet 0
@@ -305,6 +395,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# tcp flags != { fin, urg, ecn, cwr} drop
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000001  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 drop ]
+
 # tcp flags cwr
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -366,6 +467,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp window != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp window { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -376,6 +487,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp window != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp checksum 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -415,6 +536,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp checksum != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp checksum { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -425,6 +556,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp checksum != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp urgptr 1234 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -472,6 +613,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp urgptr != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp urgptr { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -482,6 +633,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp urgptr != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp doff 8
 inet test-inet input
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/inet/tcp.t.payload.ip b/tests/py/inet/tcp.t.payload.ip
index d70a176..065a2b1 100644
--- a/tests/py/inet/tcp.t.payload.ip
+++ b/tests/py/inet/tcp.t.payload.ip
@@ -37,6 +37,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp dport != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp dport { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -47,6 +57,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp dport != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp dport {telnet, http, https} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -88,6 +108,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp dport != { 22, 53, 80, 110 }
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sport 22
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -127,6 +157,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sport != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sport { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -137,6 +177,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sport != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sport vmap { 25:accept, 28:drop }
 __map%d test-ip4 b
 __map%d test-ip4 0
@@ -227,6 +277,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sequence != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sequence { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -237,6 +297,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sequence != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp ackseq 42949672 drop
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -284,6 +354,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp ackseq != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp ackseq { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -294,6 +374,16 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp ackseq != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -305,6 +395,17 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# tcp flags != { fin, urg, ecn, cwr} drop
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000001  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 drop ]
+
 # tcp flags cwr
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -366,6 +467,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp window != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp window { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -376,6 +487,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp window != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp checksum 22
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -415,6 +536,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp checksum != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp checksum { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -425,6 +556,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp checksum != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp urgptr 1234 accept
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -472,6 +613,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp urgptr != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp urgptr { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -482,6 +633,16 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp urgptr != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp doff 8
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
diff --git a/tests/py/inet/tcp.t.payload.ip6 b/tests/py/inet/tcp.t.payload.ip6
index 4e9c413..a4ddc16 100644
--- a/tests/py/inet/tcp.t.payload.ip6
+++ b/tests/py/inet/tcp.t.payload.ip6
@@ -37,6 +37,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp dport != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp dport { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -47,6 +57,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp dport != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp dport {telnet, http, https} accept
 __set%d test-ip6 3
 __set%d test-ip6 0
@@ -88,6 +108,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp dport != { 22, 53, 80, 110 }
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sport 22
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -127,6 +157,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sport != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sport { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -137,6 +177,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sport != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sport vmap { 25:accept, 28:drop }
 __map%d test-ip6 b
 __map%d test-ip6 0
@@ -227,6 +277,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sequence != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sequence { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -237,6 +297,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sequence != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp ackseq 42949672 drop
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -284,6 +354,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp ackseq != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp ackseq { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -294,6 +374,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp ackseq != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
 __set%d test-ip6 3
 __set%d test-ip6 0
@@ -305,6 +395,17 @@ ip6 test-ip6 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# tcp flags != { fin, urg, ecn, cwr} drop
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000001  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 drop ]
+
 # tcp flags cwr
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -366,6 +467,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp window != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp window { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -376,6 +487,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp window != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp checksum 22
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -415,6 +536,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp checksum != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp checksum { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -425,6 +556,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp checksum != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp urgptr 1234 accept
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -472,6 +613,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp urgptr != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp urgptr { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -482,6 +633,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp urgptr != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp doff 8
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
diff --git a/tests/py/inet/tcp.t.payload.netdev b/tests/py/inet/tcp.t.payload.netdev
index 854f4bb..dd79898 100644
--- a/tests/py/inet/tcp.t.payload.netdev
+++ b/tests/py/inet/tcp.t.payload.netdev
@@ -37,6 +37,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp dport != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp dport { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -47,6 +57,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp dport != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp dport {telnet, http, https} accept
 __set%d test-inet 3
 __set%d test-inet 0
@@ -88,6 +108,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp dport != { 22, 53, 80, 110 }
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00001600  : 0 [end]	element 00003500  : 0 [end]	element 00005000  : 0 [end]	element 00006e00  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sport 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -127,6 +157,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sport != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sport { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -137,6 +177,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sport != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sport vmap { 25:accept, 28:drop }
 __map%d test-inet b
 __map%d test-inet 0
@@ -227,6 +277,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sequence != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp sequence { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -237,6 +297,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp sequence != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp ackseq 42949672 drop
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -284,6 +354,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp ackseq != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp ackseq { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -294,6 +374,16 @@ inet test-inet input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp ackseq != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ transport header + 8 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
 __set%d test-inet 3
 __set%d test-inet 0
@@ -305,6 +395,17 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 drop ]
 
+# tcp flags != { fin, urg, ecn, cwr} drop
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000001  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000080  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 drop ]
+
 # tcp flags cwr
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -366,6 +467,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp window != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp window { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -376,6 +487,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp window != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 14 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp checksum 23456 drop
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -423,6 +544,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp checksum != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp checksum { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -433,6 +564,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp checksum != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 16 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp urgptr 1234 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -480,6 +621,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp urgptr != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp urgptr { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -490,6 +641,16 @@ inet test-inet input
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp urgptr != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 18 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # tcp doff 8
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-- 
2.11.0.rc2

