From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nft] tests/py: enable tests for dccp types
Date: Mon,  7 Mar 2016 13:37:48 +0100
Message-ID: <1457354268-11240-2-git-send-email-pablo@netfilter.org>
References: <1457354268-11240-1-git-send-email-pablo@netfilter.org>
Cc: shivanib134@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53845 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbcCGMia (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 07:38:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8C6724B0F8
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 13:38:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7C1B5DA38A
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 13:38:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 459CC28D22C
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 13:38:25 +0100 (CET)
In-Reply-To: <1457354268-11240-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch make sure we test dccp type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/inet/dccp.t                |  7 +++----
 tests/py/inet/dccp.t.payload.inet   | 27 +++++++++++++++++++++++++++
 tests/py/inet/dccp.t.payload.ip     | 27 +++++++++++++++++++++++++++
 tests/py/inet/dccp.t.payload.ip6    | 27 +++++++++++++++++++++++++++
 tests/py/inet/dccp.t.payload.netdev | 27 +++++++++++++++++++++++++++
 5 files changed, 111 insertions(+), 4 deletions(-)

diff --git a/tests/py/inet/dccp.t b/tests/py/inet/dccp.t
index 4eef58f..f5f8b67 100644
--- a/tests/py/inet/dccp.t
+++ b/tests/py/inet/dccp.t
@@ -29,8 +29,7 @@ dccp dport {23, 24, 25};ok
 dccp dport { 20-50};ok
 # dccp dport != {27-34};ok
 
-# BUG dccp type
-# dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack};ok
+dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack};ok
 # dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack};ok
-# dccp type request;ok
-# dccp type != request;ok
+dccp type request;ok
+dccp type != request;ok
diff --git a/tests/py/inet/dccp.t.payload.inet b/tests/py/inet/dccp.t.payload.inet
index ecd8863..11f5aaf 100644
--- a/tests/py/inet/dccp.t.payload.inet
+++ b/tests/py/inet/dccp.t.payload.inet
@@ -80,3 +80,30 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
+set%d test-inet 3
+set%d test-inet 0
+	element 00000000  : 0 [end]     element 00000001  : 0 [end]     element 00000002  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000006  : 0 [end]     element 00000007  : 0 [end]     element 00000008  : 0 [end]     element 00000009  : 0 [end]
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+
+# dccp type request
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# dccp type != request
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
diff --git a/tests/py/inet/dccp.t.payload.ip b/tests/py/inet/dccp.t.payload.ip
index 9e1cc2e..fbf441a 100644
--- a/tests/py/inet/dccp.t.payload.ip
+++ b/tests/py/inet/dccp.t.payload.ip
@@ -80,3 +80,30 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
+set%d test-ip4 3
+set%d test-ip4 0
+	element 00000000  : 0 [end]     element 00000001  : 0 [end]     element 00000002  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000006  : 0 [end]     element 00000007  : 0 [end]     element 00000008  : 0 [end]     element 00000009  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+
+# dccp type request
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# dccp type != request
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
diff --git a/tests/py/inet/dccp.t.payload.ip6 b/tests/py/inet/dccp.t.payload.ip6
index c0e1d70..b323c06 100644
--- a/tests/py/inet/dccp.t.payload.ip6
+++ b/tests/py/inet/dccp.t.payload.ip6
@@ -80,3 +80,30 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
+set%d test-ip6 3
+set%d test-ip6 0
+        element 00000000  : 0 [end]     element 00000001  : 0 [end]     element 00000002  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000006  : 0 [end]     element 00000007  : 0 [end]     element 00000008  : 0 [end]     element 00000009  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+
+# dccp type request
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# dccp type != request
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
diff --git a/tests/py/inet/dccp.t.payload.netdev b/tests/py/inet/dccp.t.payload.netdev
index ecd8863..5a8c873 100644
--- a/tests/py/inet/dccp.t.payload.netdev
+++ b/tests/py/inet/dccp.t.payload.netdev
@@ -80,3 +80,30 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
+set%d test-netdev 3
+set%d test-netdev 0
+	element 00000000  : 0 [end]     element 00000001  : 0 [end]     element 00000002  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000006  : 0 [end]     element 00000007  : 0 [end]     element 00000008  : 0 [end]     element 00000009  : 0 [end]
+netdev test-netdev ingress
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+
+# dccp type request
+netdev test-netdev ingress
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# dccp type != request
+netdev test-netdev ingress
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000021 ]
+  [ payload load 1b @ transport header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
-- 
2.1.4

