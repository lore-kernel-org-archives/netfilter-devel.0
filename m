Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FA8EB64DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jul 2023 00:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjGSAOw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jul 2023 20:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjGSAOw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2023 20:14:52 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C030130
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 17:14:49 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] meta: stash context statement length when generating payload/meta dependency
Date:   Wed, 19 Jul 2023 02:14:44 +0200
Message-Id: <20230719001444.154070-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

... meta mark set ip dscp

generates an implicit dependency from the inet family to match on meta
nfproto ip.

The length of this implicit expression is incorrectly adjusted to the
statement length, ie. relational to compare meta nfproto takes 4 bytes
instead of 1 byte. The evaluation of 'ip dscp' under the meta mark
statement triggers this implicit dependency which should not consider
the context statement length since it is added before the statement
itself.

This problem shows when listing the ruleset, since netlink_parse_cmp()
where left->len < right->len, hence handling the implicit dependency as
a concatenation, but it is actually a bug in the evaluation step that
leads to incorrect bytecode.

Fixes: 3c64ea7995cb ("evaluate: honor statement length in integer evaluation")
Fixes: edecd58755a8 ("evaluate: support shifts larger than the width of the left operand")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/payload.c                | 13 ++++++
 tests/py/inet/meta.t         |  5 +++
 tests/py/inet/meta.t.json    | 86 ++++++++++++++++++++++++++++++++++++
 tests/py/inet/meta.t.payload | 40 +++++++++++++++++
 4 files changed, 144 insertions(+)

diff --git a/src/payload.c b/src/payload.c
index f67b54078792..7862745b2035 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -409,6 +409,7 @@ static int payload_add_dependency(struct eval_ctx *ctx,
 	const struct proto_hdr_template *tmpl;
 	struct expr *dep, *left, *right;
 	struct proto_ctx *pctx;
+	unsigned int stmt_len;
 	struct stmt *stmt;
 	int protocol;
 
@@ -429,11 +430,16 @@ static int payload_add_dependency(struct eval_ctx *ctx,
 				    constant_data_ptr(protocol, tmpl->len));
 
 	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
+
+	stmt_len = ctx->stmt_len;
+	ctx->stmt_len = 0;
+
 	stmt = expr_stmt_alloc(&dep->location, dep);
 	if (stmt_evaluate(ctx, stmt) < 0) {
 		return expr_error(ctx->msgs, expr,
 					  "dependency statement is invalid");
 	}
+	ctx->stmt_len = stmt_len;
 
 	if (ctx->inner_desc) {
 		if (tmpl->meta_key)
@@ -543,6 +549,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 	const struct hook_proto_desc *h;
 	const struct proto_desc *desc;
 	struct proto_ctx *pctx;
+	unsigned int stmt_len;
 	struct stmt *stmt;
 	uint16_t type;
 
@@ -559,12 +566,18 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 					  "protocol specification is invalid "
 					  "for this family");
 
+		stmt_len = ctx->stmt_len;
+		ctx->stmt_len = 0;
+
 		stmt = meta_stmt_meta_iiftype(&expr->location, type);
 		if (stmt_evaluate(ctx, stmt) < 0) {
 			return expr_error(ctx->msgs, expr,
 					  "dependency statement is invalid");
 		}
 		*res = stmt;
+
+		ctx->stmt_len = stmt_len;
+
 		return 0;
 	}
 
diff --git a/tests/py/inet/meta.t b/tests/py/inet/meta.t
index 374738a701d6..5c062b39b8a9 100644
--- a/tests/py/inet/meta.t
+++ b/tests/py/inet/meta.t
@@ -25,3 +25,8 @@ meta mark set ct mark >> 8;ok
 meta mark . tcp dport { 0x0000000a-0x00000014 . 80-90, 0x00100000-0x00100123 . 100-120 };ok
 ip saddr . meta mark { 1.2.3.4 . 0x00000100 , 1.2.3.6-1.2.3.8 . 0x00000200-0x00000300 };ok
 ip saddr . meta mark { 1.2.3.4 . 0x00000100 , 5.6.7.8 . 0x00000200 };ok
+
+meta mark set ip dscp;ok
+meta mark set ip dscp | 0x40;ok
+meta mark set ip6 dscp;ok
+meta mark set ip6 dscp | 0x40;ok
diff --git a/tests/py/inet/meta.t.json b/tests/py/inet/meta.t.json
index 92a1f9bff373..3ba0fd1dee2a 100644
--- a/tests/py/inet/meta.t.json
+++ b/tests/py/inet/meta.t.json
@@ -440,3 +440,89 @@
     }
 ]
 
+# meta mark set ip dscp
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip"
+                }
+            }
+        }
+    }
+]
+
+# meta mark set ip dscp | 0x40
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip"
+                        }
+                    },
+                    64
+                ]
+            }
+        }
+    }
+]
+
+# meta mark set ip6 dscp
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip6"
+                }
+            }
+        }
+    }
+]
+
+# meta mark set ip6 dscp | 0x40
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip6"
+                        }
+                    },
+                    64
+                ]
+            }
+        }
+    }
+]
+
diff --git a/tests/py/inet/meta.t.payload b/tests/py/inet/meta.t.payload
index ea54090727fa..c53b5077f9a6 100644
--- a/tests/py/inet/meta.t.payload
+++ b/tests/py/inet/meta.t.payload
@@ -133,3 +133,43 @@ inet test-inet input
   [ meta load mark => reg 9 ]
   [ lookup reg 1 set __set%d ]
 
+# meta mark set ip dscp
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ meta set mark with reg 1 ]
+
+# meta mark set ip dscp | 0x40
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffbf ) ^ 0x00000040 ]
+  [ meta set mark with reg 1 ]
+
+# meta mark set ip6 dscp
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ meta set mark with reg 1 ]
+
+# meta mark set ip6 dscp | 0x40
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffbf ) ^ 0x00000040 ]
+  [ meta set mark with reg 1 ]
+
-- 
2.30.2

