Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F9BC4167B
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Nov 2023 11:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjKFLp7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Nov 2023 06:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjKFLp7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2023 06:45:59 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E34E6134
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2023 03:45:54 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, davidson.brian@gmail.com
Subject: [PATCH nft,v2 2/2] evaluate: place byteorder conversion before rshift in payload expressions
Date:   Mon,  6 Nov 2023 12:45:48 +0100
Message-Id: <20231106114548.14637-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231106114548.14637-1-pablo@netfilter.org>
References: <20231106114548.14637-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the key from the evaluation context to perform the byteorder
conversion in case that this expression is used for lookups and updates
on explicit sets.

 # nft --debug=netlink add rule ip6 t output ip6 dscp @mapv6
 ip6 t output
  [ payload load 2b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]   <-------------- this was missing!
  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
  [ lookup reg 1 set mapv6 ]

Also with set statements (updates from packet path):

 # nft --debug=netlink add rule ip6 t output update @mapv6 { ip6 dscp }
 ip6 t output
  [ payload load 2b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]   <------------- also here!
  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
  [ dynset update reg_key 1 set mapv6 ]

Simple matches on values and implicit sets rely on the binary transfer
mechanism to propagate the shift to the constant, no explicit byteorder
is required in such case.

Fixes: 668c18f67203 ("evaluate: place byteorder conversion before rshift in payload statement")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: extend coverage for tests/py and fix concatenations.

 src/evaluate.c                  | 10 +++++++-
 tests/py/ip6/ip6.t              |  4 ++++
 tests/py/ip6/ip6.t.json         | 42 +++++++++++++++++++++++++++++++++
 tests/py/ip6/ip6.t.payload.inet | 21 +++++++++++++++++
 tests/py/ip6/ip6.t.payload.ip6  | 17 +++++++++++++
 5 files changed, 93 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 65e4cef9c147..788cac1fc2b5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -545,7 +545,8 @@ static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 	and->len	= masklen;
 
 	if (shift) {
-		if (ctx->stmt_len > 0 && div_round_up(masklen, BITS_PER_BYTE) > 1) {
+		if ((ctx->ectx.key || ctx->stmt_len > 0) &&
+		    div_round_up(masklen, BITS_PER_BYTE) > 1) {
 			int op = byteorder_conversion_op(expr, BYTEORDER_HOST_ENDIAN);
 			and = unary_expr_alloc(&expr->location, op, and);
 			and->len = masklen;
@@ -574,6 +575,7 @@ static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 
 static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 {
+	const struct expr *key = ctx->ectx.key;
 	struct expr *expr = *exprp;
 
 	if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
@@ -582,6 +584,8 @@ static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 	if (expr_evaluate_primary(ctx, exprp) < 0)
 		return -1;
 
+	ctx->ectx.key = key;
+
 	if (expr->exthdr.offset % BITS_PER_BYTE != 0 ||
 	    expr->len % BITS_PER_BYTE != 0)
 		expr_evaluate_bits(ctx, exprp);
@@ -878,6 +882,7 @@ static bool payload_needs_adjustment(const struct expr *expr)
 
 static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
 {
+	const struct expr *key = ctx->ectx.key;
 	struct expr *expr = *exprp;
 
 	if (expr->payload.evaluated)
@@ -889,6 +894,8 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
 	if (expr_evaluate_primary(ctx, exprp) < 0)
 		return -1;
 
+	ctx->ectx.key = key;
+
 	if (payload_needs_adjustment(expr))
 		expr_evaluate_bits(ctx, exprp);
 
@@ -1508,6 +1515,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		}
 
 		__expr_set_context(&ctx->ectx, tmp, bo, dsize, 0);
+		ctx->ectx.key = i;
 
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index 60ea22333057..430dd5715f97 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -21,6 +21,10 @@ ip6 dscp vmap { 0x04 : accept, 0x3f : continue } counter;ok
 meta mark set ip6 dscp map @map1;ok
 !map2 type dscp . ipv6_addr : mark;ok
 meta mark set ip6 dscp . ip6 daddr map @map2;ok
+!map3 type dscp : mark;ok
+ip6 dscp @map3;ok
+!map4 type dscp . ipv6_addr : mark;ok
+ip6 dscp . ip6 daddr @map4;ok
 
 ip6 flowlabel 22;ok
 ip6 flowlabel != 233;ok
diff --git a/tests/py/ip6/ip6.t.json b/tests/py/ip6/ip6.t.json
index 5411190d6bb3..49e5a2dd6355 100644
--- a/tests/py/ip6/ip6.t.json
+++ b/tests/py/ip6/ip6.t.json
@@ -193,6 +193,48 @@
     }
 ]
 
+# ip6 dscp @map3
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip6"
+                }
+            },
+            "op": "==",
+            "right": "@map3"
+        }
+    }
+]
+
+# ip6 dscp . ip6 daddr @map4
+[
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip6"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip6"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": "@map4"
+        }
+    }
+]
+
 # ip6 flowlabel 22
 [
     {
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index 214a0ed9f90f..dbb430af7ff6 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -76,6 +76,27 @@ inet test-inet input
   [ lookup reg 1 set map2 dreg 1 ]
   [ meta set mark with reg 1 ]
 
+# ip6 dscp @map3
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ lookup reg 1 set map3 ]
+
+# ip6 dscp . ip6 daddr @map4
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ payload load 16b @ network header + 24 => reg 9 ]
+  [ lookup reg 1 set map4 ]
+
 # ip6 flowlabel 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index 428b8ea41278..b1289232f932 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -60,6 +60,23 @@ ip6 test-ip6 input
   [ lookup reg 1 set map2 dreg 1 ]
   [ meta set mark with reg 1 ]
 
+# ip6 dscp @map3
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ lookup reg 1 set map3 ]
+
+# ip6 dscp . ip6 daddr @map4
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ payload load 16b @ network header + 24 => reg 9 ]
+  [ lookup reg 1 set map4 ]
+
 # ip6 flowlabel 22
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-- 
2.30.2

