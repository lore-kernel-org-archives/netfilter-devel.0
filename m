Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A235DC4167D
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Nov 2023 11:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjKFLp6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Nov 2023 06:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjKFLp5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2023 06:45:57 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DF61EA
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2023 03:45:53 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, davidson.brian@gmail.com
Subject: [PATCH nft,v2 1/2] evaluate: reset statement length context only for set mappings
Date:   Mon,  6 Nov 2023 12:45:47 +0100
Message-Id: <20231106114548.14637-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

map expression (which is used a key to look up for the mapping) needs to
consider the statement length context, otherwise incorrect bytecode is
generated when {ct,meta} statement is generated.

 # nft -f - <<EOF
 add table ip6 t
 add chain ip6 t c
 add map ip6 t mapv6 { typeof ip6 dscp : meta mark; }
 EOF

 # nft -d netlink add rule ip6 t c meta mark set ip6 dscp map @mapv6
 ip6 t c
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   ... missing byteorder conversion here before shift ...
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ lookup reg 1 set mapv6 dreg 1 ]
   [ meta set mark with reg 1 ]

Reset statement length context only for the mapping side for the
elements in the set.

Fixes: edecd58755a8 ("evaluate: support shifts larger than the width of the left operand")
Reported-by: Brian Davidson <davidson.brian@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: extend coverage for tests/py.

 src/evaluate.c                  |  2 +-
 tests/py/ip6/ip6.t              |  5 +++
 tests/py/ip6/ip6.t.json         | 58 +++++++++++++++++++++++++++++++++
 tests/py/ip6/ip6.t.payload.inet | 23 +++++++++++++
 tests/py/ip6/ip6.t.payload.ip6  | 19 +++++++++++
 5 files changed, 106 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 894987df7895..65e4cef9c147 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1918,13 +1918,13 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	}
 
 	expr_set_context(&ctx->ectx, NULL, 0);
-	ctx->stmt_len = 0;
 	if (expr_evaluate(ctx, &map->map) < 0)
 		return -1;
 	if (expr_is_constant(map->map))
 		return expr_error(ctx->msgs, map->map,
 				  "Map expression can not be constant");
 
+	ctx->stmt_len = 0;
 	mappings = map->mappings;
 	mappings->set_flags |= NFT_SET_MAP;
 
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index 2ffe318e1e6d..60ea22333057 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -17,6 +17,11 @@ ip6 dscp != 0x20;ok;ip6 dscp != cs4
 ip6 dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef};ok
 ip6 dscp vmap { 0x04 : accept, 0x3f : continue } counter;ok
 
+!map1 type dscp : mark;ok
+meta mark set ip6 dscp map @map1;ok
+!map2 type dscp . ipv6_addr : mark;ok
+meta mark set ip6 dscp . ip6 daddr map @map2;ok
+
 ip6 flowlabel 22;ok
 ip6 flowlabel != 233;ok
 - ip6 flowlabel 33-45;ok
diff --git a/tests/py/ip6/ip6.t.json b/tests/py/ip6/ip6.t.json
index cf802175b792..5411190d6bb3 100644
--- a/tests/py/ip6/ip6.t.json
+++ b/tests/py/ip6/ip6.t.json
@@ -135,6 +135,64 @@
     }
 ]
 
+# meta mark set ip6 dscp map @map1
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "map": {
+                    "data": "@map1",
+                    "key": {
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip6"
+                        }
+                    }
+                }
+            }
+        }
+    }
+]
+
+# meta mark set ip6 dscp . ip6 daddr map @map2
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "map": {
+                    "data": "@map2",
+                    "key": {
+                        "concat": [
+                            {
+                                "payload": {
+                                    "field": "dscp",
+                                    "protocol": "ip6"
+                                }
+                            },
+                            {
+                                "payload": {
+                                    "field": "daddr",
+                                    "protocol": "ip6"
+                                }
+                            }
+                        ]
+                    }
+                }
+            }
+        }
+    }
+]
+
 # ip6 flowlabel 22
 [
     {
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index 20dfe5497367..214a0ed9f90f 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -53,6 +53,29 @@ ip6 test-ip6 input
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
+# meta mark set ip6 dscp map @map1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ lookup reg 1 set map1 dreg 1 ]
+  [ meta set mark with reg 1 ]
+
+# meta mark set ip6 dscp . ip6 daddr map @map2
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ payload load 16b @ network header + 24 => reg 9 ]
+  [ lookup reg 1 set map2 dreg 1 ]
+  [ meta set mark with reg 1 ]
+
 # ip6 flowlabel 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index f8e3ca3cb622..428b8ea41278 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -41,6 +41,25 @@ ip6 test-ip6 input
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
+# meta mark set ip6 dscp map @map1
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ lookup reg 1 set map1 dreg 1 ]
+  [ meta set mark with reg 1 ]
+
+# meta mark set ip6 dscp . ip6 daddr map @map2
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ payload load 16b @ network header + 24 => reg 9 ]
+  [ lookup reg 1 set map2 dreg 1 ]
+  [ meta set mark with reg 1 ]
+
 # ip6 flowlabel 22
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-- 
2.30.2

