Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C0BC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jan 2022 22:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiAZWdX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 17:33:23 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58152 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiAZWdW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 17:33:22 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0FC3460676
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:30:18 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables 2/4] optimize: merge verdict maps with same lookup key
Date:   Wed, 26 Jan 2022 23:33:12 +0100
Message-Id: <20220126223314.297735-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126223314.297735-1-pablo@netfilter.org>
References: <20220126223314.297735-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Merge two consecutive verdict maps with the same lookup key.

For instance, merge the following:

 table inet x {
        chain filter_in_tcp {
                tcp dport vmap {
                           80 : accept,
                           81 : accept,
                          443 : accept,
                          931 : accept,
                         5001 : accept,
                         5201 : accept,
                }
                tcp dport vmap {
                         6800-6999  : accept,
                        33434-33499 : accept,
                }
        }
 }

into:

 table inet x {
        chain filter_in_tcp {
                tcp dport vmap {
                           80 : accept,
                           81 : accept,
                          443 : accept,
                          931 : accept,
                         5001 : accept,
                         5201 : accept,
                         6800-6999  : accept,
                        33434-33499 : accept,
                }
	}
 }

This patch updates statement comparison routine to inspect the verdict
expression type to detect possible merger.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 105 ++++++++++++++++--
 .../optimizations/dumps/merge_vmaps.nft       |  12 ++
 .../shell/testcases/optimizations/merge_vmaps |  25 +++++
 3 files changed, 130 insertions(+), 12 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_vmaps.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_vmaps

diff --git a/src/optimize.c b/src/optimize.c
index c52966a86e2c..9a93e3b8d296 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -101,6 +101,15 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
 	case STMT_NOTRACK:
 		break;
 	case STMT_VERDICT:
+		expr_a = stmt_a->expr;
+		expr_b = stmt_b->expr;
+
+		if (expr_a->etype != expr_b->etype)
+			return false;
+
+		if (expr_a->etype == EXPR_MAP &&
+		    expr_b->etype == EXPR_MAP)
+			return __expr_cmp(expr_a->map, expr_b->map);
 		break;
 	case STMT_LIMIT:
 		if (stmt_a->limit.rate != stmt_b->limit.rate ||
@@ -139,14 +148,8 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
 	return true;
 }
 
-static bool stmt_verdict_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
+static bool expr_verdict_eq(const struct expr *expr_a, const struct expr *expr_b)
 {
-	struct expr *expr_a, *expr_b;
-
-	assert (stmt_a->ops->type == STMT_VERDICT);
-
-	expr_a = stmt_a->expr;
-	expr_b = stmt_b->expr;
 	if (expr_a->verdict != expr_b->verdict)
 		return false;
 	if (expr_a->chain && expr_b->chain) {
@@ -162,6 +165,25 @@ static bool stmt_verdict_eq(const struct stmt *stmt_a, const struct stmt *stmt_b
 	return true;
 }
 
+static bool stmt_verdict_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
+{
+	struct expr *expr_a, *expr_b;
+
+	assert (stmt_a->ops->type == STMT_VERDICT);
+
+	expr_a = stmt_a->expr;
+	expr_b = stmt_b->expr;
+	if (expr_a->etype == EXPR_VERDICT &&
+	    expr_b->etype == EXPR_VERDICT)
+		return expr_verdict_eq(expr_a, expr_b);
+
+	if (expr_a->etype == EXPR_MAP &&
+	    expr_b->etype == EXPR_MAP)
+		return __expr_cmp(expr_a->map, expr_b->map);
+
+	return false;
+}
+
 static bool stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
 {
 	if (!stmt_a && !stmt_b)
@@ -194,6 +216,10 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 		if (stmt_type_find(ctx, stmt))
 			continue;
 
+		if (stmt->ops->type == STMT_VERDICT &&
+		    stmt->expr->etype == EXPR_MAP)
+			continue;
+
 		/* No refcounter available in statement objects, clone it to
 		 * to store in the array of selectors.
 		 */
@@ -273,16 +299,15 @@ struct merge {
 	uint32_t	num_stmts;
 };
 
-static void merge_stmts(const struct optimize_ctx *ctx,
-			uint32_t from, uint32_t to, const struct merge *merge)
+static void merge_expr_stmts(const struct optimize_ctx *ctx,
+			     uint32_t from, uint32_t to,
+			     const struct merge *merge,
+			     struct stmt *stmt_a)
 {
-	struct stmt *stmt_a = ctx->stmt_matrix[from][merge->stmt[0]];
 	struct expr *expr_a, *expr_b, *set, *elem;
 	struct stmt *stmt_b;
 	uint32_t i;
 
-	assert (stmt_a->ops->type == STMT_EXPRESSION);
-
 	set = set_expr_alloc(&internal_location, NULL);
 	set->set_flags |= NFT_SET_ANONYMOUS;
 
@@ -301,6 +326,62 @@ static void merge_stmts(const struct optimize_ctx *ctx,
 	stmt_a->expr->right = set;
 }
 
+static void merge_vmap(const struct optimize_ctx *ctx,
+		       struct stmt *stmt_a, const struct stmt *stmt_b)
+{
+	struct expr *mappings, *mapping, *expr;
+
+	mappings = stmt_b->expr->mappings;
+	list_for_each_entry(expr, &mappings->expressions, list) {
+		mapping = expr_clone(expr);
+		compound_expr_add(stmt_a->expr->mappings, mapping);
+	}
+}
+
+static void merge_verdict_stmts(const struct optimize_ctx *ctx,
+				uint32_t from, uint32_t to,
+				const struct merge *merge,
+				struct stmt *stmt_a)
+{
+	struct stmt *stmt_b;
+	uint32_t i;
+
+	for (i = from + 1; i <= to; i++) {
+		stmt_b = ctx->stmt_matrix[i][merge->stmt[0]];
+		switch (stmt_b->ops->type) {
+		case STMT_VERDICT:
+			switch (stmt_b->expr->etype) {
+			case EXPR_MAP:
+				merge_vmap(ctx, stmt_a, stmt_b);
+				break;
+			default:
+				assert(1);
+			}
+			break;
+		default:
+			assert(1);
+			break;
+		}
+	}
+}
+
+static void merge_stmts(const struct optimize_ctx *ctx,
+			uint32_t from, uint32_t to, const struct merge *merge)
+{
+	struct stmt *stmt_a = ctx->stmt_matrix[from][merge->stmt[0]];
+
+	switch (stmt_a->ops->type) {
+	case STMT_EXPRESSION:
+		merge_expr_stmts(ctx, from, to, merge, stmt_a);
+		break;
+	case STMT_VERDICT:
+		merge_verdict_stmts(ctx, from, to, merge, stmt_a);
+		break;
+	default:
+		assert(1);
+	}
+}
+
 static void merge_concat_stmts(const struct optimize_ctx *ctx,
 			       uint32_t from, uint32_t to,
 			       const struct merge *merge)
diff --git a/tests/shell/testcases/optimizations/dumps/merge_vmaps.nft b/tests/shell/testcases/optimizations/dumps/merge_vmaps.nft
new file mode 100644
index 000000000000..c1c9743b9f8c
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/merge_vmaps.nft
@@ -0,0 +1,12 @@
+table ip x {
+	chain filter_in_tcp {
+	}
+
+	chain filter_in_udp {
+	}
+
+	chain y {
+		tcp dport vmap { 80 : accept, 81 : accept, 443 : accept, 8000-8100 : accept, 24000-25000 : accept }
+		meta l4proto vmap { tcp : goto filter_in_tcp, udp : goto filter_in_udp }
+	}
+}
diff --git a/tests/shell/testcases/optimizations/merge_vmaps b/tests/shell/testcases/optimizations/merge_vmaps
new file mode 100755
index 000000000000..7b7a2723be4b
--- /dev/null
+++ b/tests/shell/testcases/optimizations/merge_vmaps
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+	chain filter_in_tcp {
+	}
+	chain filter_in_udp {
+	}
+	chain y {
+		tcp dport vmap {
+			80 : accept,
+			81 : accept,
+			443 : accept,
+		}
+		tcp dport vmap {
+			8000-8100 : accept,
+			24000-25000 : accept,
+		}
+		meta l4proto tcp goto filter_in_tcp
+		meta l4proto udp goto filter_in_udp
+	}
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

