Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85081C71153
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 17:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbjH2Rso (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 13:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238197AbjH2Rs3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 13:48:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97D89113
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 10:48:19 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] tests: py: extend ip frag-off coverage
Date:   Tue, 29 Aug 2023 19:48:12 +0200
Message-Id: <20230829174812.158595-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230829174812.158595-1-pablo@netfilter.org>
References: <20230829174812.158595-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cover matching on DF and MF bits and fragments.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/ip.t                |  3 ++
 tests/py/ip/ip.t.json           | 63 +++++++++++++++++++++++++++++++++
 tests/py/ip/ip.t.payload        | 18 ++++++++++
 tests/py/ip/ip.t.payload.bridge | 24 +++++++++++++
 tests/py/ip/ip.t.payload.inet   | 24 +++++++++++++
 tests/py/ip/ip.t.payload.netdev | 24 +++++++++++++
 6 files changed, 156 insertions(+)

diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 309faad40b52..a8f0d8202400 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -54,6 +54,9 @@ ip frag-off 0x21-0x2d;ok
 ip frag-off != 0x21-0x2d;ok
 ip frag-off { 0x21, 0x37, 0x43, 0x58};ok
 ip frag-off != { 0x21, 0x37, 0x43, 0x58};ok
+ip frag-off & 0x1fff != 0x0;ok
+ip frag-off & 0x2000 != 0x0;ok
+ip frag-off & 0x4000 != 0x0;ok
 
 ip ttl 0 drop;ok
 ip ttl 233;ok
diff --git a/tests/py/ip/ip.t.json b/tests/py/ip/ip.t.json
index faf18fef05f1..2f46ebcc3654 100644
--- a/tests/py/ip/ip.t.json
+++ b/tests/py/ip/ip.t.json
@@ -501,6 +501,69 @@
     }
 ]
 
+# ip frag-off & 0x1fff != 0x0
+[
+    {
+        "match": {
+            "left": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "frag-off",
+                            "protocol": "ip"
+                        }
+                    },
+                    8191
+                ]
+            },
+            "op": "!=",
+            "right": 0
+        }
+    }
+]
+
+# ip frag-off & 0x2000 != 0x0
+[
+    {
+        "match": {
+            "left": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "frag-off",
+                            "protocol": "ip"
+                        }
+                    },
+                    8192
+                ]
+            },
+            "op": "!=",
+            "right": 0
+        }
+    }
+]
+
+# ip frag-off & 0x4000 != 0x0
+[
+    {
+        "match": {
+            "left": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "frag-off",
+                            "protocol": "ip"
+                        }
+                    },
+                    16384
+                ]
+            },
+            "op": "!=",
+            "right": 0
+        }
+    }
+]
+
 # ip ttl 0 drop
 [
     {
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 1d677669c324..8224d4cd46de 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -162,6 +162,24 @@ ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# ip frag-off & 0x1fff != 0x0
+ip test-ip4 input
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
+# ip frag-off & 0x2000 != 0x0
+ip test-ip4 input
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000020 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
+# ip frag-off & 0x4000 != 0x0
+ip test-ip4 input
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000040 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
 # ip ttl 0 drop
 ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index 11e49540c5f0..25a43fed38f5 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -212,6 +212,30 @@ bridge test-bridge input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# ip frag-off & 0x1fff != 0x0
+bridge test-bridge input 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
+# ip frag-off & 0x2000 != 0x0
+bridge test-bridge input 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000020 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
+# ip frag-off & 0x4000 != 0x0
+bridge test-bridge input 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000040 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
 # ip ttl 0 drop
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 84fa66e92c0c..ba10d4444bb1 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -212,6 +212,30 @@ inet test-inet input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# ip frag-off & 0x1fff != 0x0
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
+# ip frag-off & 0x2000 != 0x0
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000020 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
+# ip frag-off & 0x4000 != 0x0
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000040 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
 # ip ttl 0 drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index f14ff2c21f48..0274d39d0f17 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -146,6 +146,30 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# ip frag-off & 0x1fff != 0x0
+netdev x y
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
+# ip frag-off & 0x2000 != 0x0
+netdev x y
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000020 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
+# ip frag-off & 0x4000 != 0x0
+netdev x y
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000040 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
 # ip ttl 0 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-- 
2.30.2

