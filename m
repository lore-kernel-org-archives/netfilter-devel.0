From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] tests: py: Test TCP flags match with parentheses
Date: Wed, 30 Nov 2016 22:07:14 +0100
Message-ID: <20161130210714.29530-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:38987 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754392AbcK3VH0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2016 16:07:26 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This should test the fix in commit 7222680eb328b ("parser_bison: Allow
parens on RHS of relational_expr").

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/inet/tcp.t                | 1 +
 tests/py/inet/tcp.t.payload.inet   | 8 ++++++++
 tests/py/inet/tcp.t.payload.ip     | 8 ++++++++
 tests/py/inet/tcp.t.payload.ip6    | 8 ++++++++
 tests/py/inet/tcp.t.payload.netdev | 8 ++++++++
 5 files changed, 33 insertions(+)

diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index 9618e5323acaf..f8600d19d1662 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -74,6 +74,7 @@ tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop;ok
 - tcp flags != { fin, urg, ecn, cwr} drop;ok
 tcp flags cwr;ok
 tcp flags != cwr;ok
+tcp 'flags & (syn|fin) == (syn|fin)';ok;tcp flags & (fin | syn) == fin | syn
 
 tcp window 22222;ok
 tcp window 22;ok
diff --git a/tests/py/inet/tcp.t.payload.inet b/tests/py/inet/tcp.t.payload.inet
index 354d013da8848..0b65e792cc0f8 100644
--- a/tests/py/inet/tcp.t.payload.inet
+++ b/tests/py/inet/tcp.t.payload.inet
@@ -320,6 +320,14 @@ inet test-inet input
   [ payload load 1b @ transport header + 13 => reg 1 ]
   [ cmp neq reg 1 0x00000080 ]
 
+# tcp 'flags & (syn|fin) == (syn|fin)'
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000003 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000003 ]
+
 # tcp window 22222
 inet test-inet input
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/inet/tcp.t.payload.ip b/tests/py/inet/tcp.t.payload.ip
index d70a176a3160c..ae014542c3eb6 100644
--- a/tests/py/inet/tcp.t.payload.ip
+++ b/tests/py/inet/tcp.t.payload.ip
@@ -320,6 +320,14 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 13 => reg 1 ]
   [ cmp neq reg 1 0x00000080 ]
 
+# tcp 'flags & (syn|fin) == (syn|fin)'
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000003 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000003 ]
+
 # tcp window 22222
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
diff --git a/tests/py/inet/tcp.t.payload.ip6 b/tests/py/inet/tcp.t.payload.ip6
index 4e9c4135e4e66..db3de3929a483 100644
--- a/tests/py/inet/tcp.t.payload.ip6
+++ b/tests/py/inet/tcp.t.payload.ip6
@@ -320,6 +320,14 @@ ip6 test-ip6 input
   [ payload load 1b @ transport header + 13 => reg 1 ]
   [ cmp neq reg 1 0x00000080 ]
 
+# tcp 'flags & (syn|fin) == (syn|fin)'
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000003 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000003 ]
+
 # tcp window 22222
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
diff --git a/tests/py/inet/tcp.t.payload.netdev b/tests/py/inet/tcp.t.payload.netdev
index 854f4bbe1f795..c639865bb28f6 100644
--- a/tests/py/inet/tcp.t.payload.netdev
+++ b/tests/py/inet/tcp.t.payload.netdev
@@ -320,6 +320,14 @@ inet test-inet input
   [ payload load 1b @ transport header + 13 => reg 1 ]
   [ cmp neq reg 1 0x00000080 ]
 
+# tcp 'flags & (syn|fin) == (syn|fin)'
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000003 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000003 ]
+
 # tcp window 22222
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-- 
2.10.0

