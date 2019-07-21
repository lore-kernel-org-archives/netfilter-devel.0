Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602F5C76191
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 16:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 178D620823
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 16:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfGUQdu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Jul 2019 12:33:50 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:49888 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbfGUQdu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jul 2019 12:33:50 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hpEmS-0005nR-7N; Sun, 21 Jul 2019 18:33:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: evaluate: support prefix expression in statements
Date:   Sun, 21 Jul 2019 18:29:48 +0200
Message-Id: <20190721162948.20221-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft dumps core when a statement contains a prefix expression:
iifname ens3 snat to 10.0.0.0/28

yields:
BUG: unknown expression type prefix
nft: netlink_linearize.c:688: netlink_gen_expr: Assertion `0' failed.

This assertion is correct -- we can't linearize a prefix because kernel
doesn't know what that is.

For LHS, they get converted to a binary 'and' such as
'10.0.0.0 & 255.255.255.240'.  For RHS, we can convert them into a range:

iifname "ens3" snat to 10.0.0.0-10.0.0.15

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1187
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                  | 61 +++++++++++++++++++++++++++++++++
 tests/py/ip6/dnat.t             |  2 ++
 tests/py/ip6/dnat.t.json        | 27 +++++++++++++++
 tests/py/ip6/dnat.t.payload.ip6 | 12 +++++++
 4 files changed, 102 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8c1c82abed4e..d55fe8ebb78e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1933,6 +1933,65 @@ static int stmt_evaluate_expr(struct eval_ctx *ctx, struct stmt *stmt)
 	return expr_evaluate(ctx, &stmt->expr);
 }
 
+static int stmt_prefix_conversion(struct eval_ctx *ctx, struct expr **expr,
+				  enum byteorder byteorder)
+{
+	struct expr *mask, *and, *or, *prefix, *base, *range;
+
+	prefix = *expr;
+	base = prefix->prefix;
+
+	if (base->etype != EXPR_VALUE)
+		return expr_error(ctx->msgs, prefix,
+				  "you cannot specify a prefix here, "
+				  "unknown type %s", base->dtype->name);
+
+	if (!expr_is_constant(base))
+		return expr_error(ctx->msgs, prefix,
+				  "Prefix expression is undefined for "
+				  "non-constant expressions");
+
+	if (expr_basetype(base)->type != TYPE_INTEGER)
+		return expr_error(ctx->msgs, prefix,
+				  "Prefix expression expected integer value");
+
+	mask = constant_expr_alloc(&prefix->location, expr_basetype(base),
+				   BYTEORDER_HOST_ENDIAN, base->len, NULL);
+
+	mpz_prefixmask(mask->value, base->len, prefix->prefix_len);
+	and = binop_expr_alloc(&prefix->location, OP_AND, expr_get(base), mask);
+
+	if (expr_evaluate(ctx, &and) < 0) {
+		expr_free(and);
+		goto err_evaluation;
+	}
+
+	mask = constant_expr_alloc(&prefix->location, expr_basetype(base),
+				   BYTEORDER_HOST_ENDIAN, base->len, NULL);
+	mpz_bitmask(mask->value, prefix->len - prefix->prefix_len);
+	or = binop_expr_alloc(&prefix->location, OP_OR, expr_get(base), mask);
+
+	if (expr_evaluate(ctx, &or) < 0) {
+		expr_free(and);
+		expr_free(or);
+		goto err_evaluation;
+	}
+
+	range = range_expr_alloc(&prefix->location, and, or);
+	if (expr_evaluate(ctx, &range) < 0) {
+		expr_free(range);
+		goto err_evaluation;
+	}
+
+	expr_free(*expr);
+	*expr = range;
+	return 0;
+
+err_evaluation:
+	return expr_error(ctx->msgs, prefix,
+			  "Could not expand prefix expression");
+}
+
 static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 			     const struct datatype *dtype, unsigned int len,
 			     enum byteorder byteorder, struct expr **expr)
@@ -1969,6 +2028,8 @@ static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 					 "unknown value to use");
 	case EXPR_RT:
 		return byteorder_conversion(ctx, expr, byteorder);
+	case EXPR_PREFIX:
+		return stmt_prefix_conversion(ctx, expr, byteorder);
 	default:
 		break;
 	}
diff --git a/tests/py/ip6/dnat.t b/tests/py/ip6/dnat.t
index 78d6d0ad382d..db5fde58e606 100644
--- a/tests/py/ip6/dnat.t
+++ b/tests/py/ip6/dnat.t
@@ -5,3 +5,5 @@
 tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:80-100;ok
 tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:100;ok;tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:100
 tcp dport 80-90 dnat to [2001:838:35f:1::]:80;ok
+dnat to [2001:838:35f:1::]/64;ok;dnat to 2001:838:35f:1::-2001:838:35f:1:ffff:ffff:ffff:ffff
+dnat to 2001:838:35f:1::-2001:838:35f:1:ffff:ffff:ffff:ffff;ok
diff --git a/tests/py/ip6/dnat.t.json b/tests/py/ip6/dnat.t.json
index a5c01fd2d7a1..3419b60f5dd1 100644
--- a/tests/py/ip6/dnat.t.json
+++ b/tests/py/ip6/dnat.t.json
@@ -76,3 +76,30 @@
     }
 ]
 
+# dnat to [2001:838:35f:1::]/64
+[
+    {
+        "dnat": {
+            "addr": {
+                "range": [
+                    "2001:838:35f:1::",
+                    "2001:838:35f:1:ffff:ffff:ffff:ffff"
+                ]
+            }
+        }
+    }
+]
+
+# dnat to 2001:838:35f:1::-2001:838:35f:1:ffff:ffff:ffff:ffff
+[
+    {
+        "dnat": {
+            "addr": {
+                "range": [
+                    "2001:838:35f:1::",
+                    "2001:838:35f:1:ffff:ffff:ffff:ffff"
+                ]
+            }
+        }
+    }
+]
diff --git a/tests/py/ip6/dnat.t.payload.ip6 b/tests/py/ip6/dnat.t.payload.ip6
index 4d3fafe2bf02..985159e209c6 100644
--- a/tests/py/ip6/dnat.t.payload.ip6
+++ b/tests/py/ip6/dnat.t.payload.ip6
@@ -33,3 +33,15 @@ ip6 test-ip6 prerouting
   [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
   [ immediate reg 2 0x00005000 ]
   [ nat dnat ip6 addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 ]
+
+# dnat to [2001:838:35f:1::]/64
+ip6 test-ip6 prerouting
+  [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
+  [ immediate reg 2 0x38080120 0x01005f03 0xffffffff 0xffffffff ]
+  [ nat dnat ip6 addr_min reg 1 addr_max reg 2 ]
+
+# dnat to 2001:838:35f:1::-2001:838:35f:1:ffff:ffff:ffff:ffff
+ip6 test-ip6 prerouting
+  [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
+  [ immediate reg 2 0x38080120 0x01005f03 0xffffffff 0xffffffff ]
+  [ nat dnat ip6 addr_min reg 1 addr_max reg 2 ]
-- 
2.21.0

