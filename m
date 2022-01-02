Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0D8C433FE
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Jan 2022 22:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiABWPG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Jan 2022 17:15:06 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56144 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiABWPD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Jan 2022 17:15:03 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 608F16427F
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Jan 2022 23:12:19 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables,v2 6/7] optimize: merge same selector with different verdict into verdict map
Date:   Sun,  2 Jan 2022 23:14:51 +0100
Message-Id: <20220102221452.86469-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220102221452.86469-1-pablo@netfilter.org>
References: <20220102221452.86469-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Transform:

  ct state invalid drop
  ct state established,related accept

into:

  ct state vmap { established : accept, related : accept, invalid : drop }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 162 ++++++++++++++++--
 .../optimizations/dumps/merge_stmts_vmap.nft  |   5 +
 .../testcases/optimizations/merge_stmts_vmap  |  12 ++
 3 files changed, 164 insertions(+), 15 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_stmts_vmap

diff --git a/src/optimize.c b/src/optimize.c
index aaf29c88af75..1ca5e25e4337 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -90,19 +90,6 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
 	case STMT_NOTRACK:
 		break;
 	case STMT_VERDICT:
-		expr_a = stmt_a->expr;
-		expr_b = stmt_b->expr;
-		if (expr_a->verdict != expr_b->verdict)
-			return false;
-		if (expr_a->chain && expr_b->chain) {
-			if (expr_a->chain->etype != expr_b->chain->etype)
-				return false;
-			if (expr_a->chain->etype == EXPR_VALUE &&
-			    strcmp(expr_a->chain->identifier, expr_b->chain->identifier))
-				return false;
-		} else if (expr_a->chain || expr_b->chain) {
-			return false;
-		}
 		break;
 	case STMT_LIMIT:
 		if (stmt_a->limit.rate != stmt_b->limit.rate ||
@@ -141,6 +128,29 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
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
+	if (expr_a->verdict != expr_b->verdict)
+		return false;
+	if (expr_a->chain && expr_b->chain) {
+		if (expr_a->chain->etype != expr_b->chain->etype)
+			return false;
+		if (expr_a->chain->etype == EXPR_VALUE &&
+		    strcmp(expr_a->chain->identifier, expr_b->chain->identifier))
+			return false;
+	} else if (expr_a->chain || expr_b->chain) {
+		return false;
+	}
+
+	return true;
+}
+
 static bool stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
 {
 	if (!stmt_a && !stmt_b)
@@ -229,6 +239,20 @@ static void rule_build_stmt_matrix_stmts(struct optimize_ctx *ctx,
 	ctx->rule[(*i)++] = rule;
 }
 
+static int stmt_verdict_find(const struct optimize_ctx *ctx)
+{
+	uint32_t i;
+
+	for (i = 0; i < ctx->num_stmts; i++) {
+		if (ctx->stmt[i]->ops->type != STMT_VERDICT)
+			continue;
+
+		return i;
+	}
+
+	return -1;
+}
+
 struct merge {
 	/* interval of rules to be merged */
 	uint32_t	rule_from;
@@ -308,6 +332,105 @@ static void merge_concat_stmts(const struct optimize_ctx *ctx,
 	}
 }
 
+static void build_verdict_map(struct expr *expr, struct stmt *verdict, struct expr *set)
+{
+	struct expr *item, *elem, *mapping;
+
+	if (expr->etype == EXPR_LIST) {
+		list_for_each_entry(item, &expr->expressions, list) {
+			elem = set_elem_expr_alloc(&internal_location, expr_get(item));
+			mapping = mapping_expr_alloc(&internal_location, elem,
+						     expr_get(verdict->expr));
+			compound_expr_add(set, mapping);
+		}
+	} else {
+		elem = set_elem_expr_alloc(&internal_location, expr_get(expr));
+		mapping = mapping_expr_alloc(&internal_location, elem,
+					     expr_get(verdict->expr));
+		compound_expr_add(set, mapping);
+	}
+}
+
+static void remove_counter(const struct optimize_ctx *ctx, uint32_t from)
+{
+	struct stmt *stmt;
+	uint32_t i;
+
+	/* remove counter statement */
+	for (i = 0; i < ctx->num_stmts; i++) {
+		stmt = ctx->stmt_matrix[from][i];
+		if (!stmt)
+			continue;
+
+		if (stmt->ops->type == STMT_COUNTER) {
+			list_del(&stmt->list);
+			stmt_free(stmt);
+		}
+	}
+}
+
+static void merge_stmts_vmap(const struct optimize_ctx *ctx,
+			     uint32_t from, uint32_t to,
+			     const struct merge *merge)
+{
+	struct stmt *stmt_a = ctx->stmt_matrix[from][merge->stmt[0]];
+	struct stmt *stmt_b, *verdict_a, *verdict_b, *stmt;
+	struct expr *expr_a, *expr_b, *expr, *left, *set;
+	uint32_t i;
+	int k;
+
+	k = stmt_verdict_find(ctx);
+	assert(k >= 0);
+
+	verdict_a = ctx->stmt_matrix[from][k];
+	set = set_expr_alloc(&internal_location, NULL);
+	set->set_flags |= NFT_SET_ANONYMOUS;
+
+	expr_a = stmt_a->expr->right;
+	build_verdict_map(expr_a, verdict_a, set);
+	for (i = from + 1; i <= to; i++) {
+		stmt_b = ctx->stmt_matrix[i][merge->stmt[0]];
+		expr_b = stmt_b->expr->right;
+		verdict_b = ctx->stmt_matrix[i][k];
+
+		build_verdict_map(expr_b, verdict_b, set);
+	}
+
+	left = expr_get(stmt_a->expr->left);
+	expr = map_expr_alloc(&internal_location, left, set);
+	stmt = verdict_stmt_alloc(&internal_location, expr);
+
+	remove_counter(ctx, from);
+	list_add(&stmt->list, &stmt_a->list);
+	list_del(&stmt_a->list);
+	stmt_free(stmt_a);
+	list_del(&verdict_a->list);
+	stmt_free(verdict_a);
+}
+
+static bool stmt_verdict_cmp(const struct optimize_ctx *ctx,
+			     uint32_t from, uint32_t to)
+{
+	struct stmt *stmt_a, *stmt_b;
+	uint32_t i;
+	int k;
+
+	k = stmt_verdict_find(ctx);
+	if (k < 0)
+		return true;
+
+	for (i = from; i + 1 <= to; i++) {
+		stmt_a = ctx->stmt_matrix[i][k];
+		stmt_b = ctx->stmt_matrix[i + 1][k];
+		if (!stmt_a && !stmt_b)
+			return true;
+		if (stmt_verdict_eq(stmt_a, stmt_b))
+			return true;
+	}
+
+	return false;
+}
+
 static void rule_optimize_print(struct output_ctx *octx,
 				const struct rule *rule)
 {
@@ -346,12 +469,21 @@ static void merge_rules(const struct optimize_ctx *ctx,
 			const struct merge *merge,
 			struct output_ctx *octx)
 {
+	bool same_verdict;
 	uint32_t i;
 
+	same_verdict = stmt_verdict_cmp(ctx, from, to);
+
 	if (merge->num_stmts > 1) {
-		merge_concat_stmts(ctx, from, to, merge);
+		if (same_verdict)
+			merge_concat_stmts(ctx, from, to, merge);
+		else
+			return;
 	} else {
-		merge_stmts(ctx, from, to, merge);
+		if (same_verdict)
+			merge_stmts(ctx, from, to, merge);
+		else
+			merge_stmts_vmap(ctx, from, to, merge);
 	}
 
 	fprintf(octx->error_fp, "Merging:\n");
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
new file mode 100644
index 000000000000..9fa19afcb783
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
@@ -0,0 +1,5 @@
+table ip x {
+	chain y {
+		ct state vmap { invalid : drop, established : accept, related : accept }
+	}
+}
diff --git a/tests/shell/testcases/optimizations/merge_stmts_vmap b/tests/shell/testcases/optimizations/merge_stmts_vmap
new file mode 100755
index 000000000000..f838fcfed70b
--- /dev/null
+++ b/tests/shell/testcases/optimizations/merge_stmts_vmap
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+	chain y {
+		ct state invalid drop
+		ct state established,related accept
+	}
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

