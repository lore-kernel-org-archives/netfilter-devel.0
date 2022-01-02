Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F03BC43219
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Jan 2022 22:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiABWPG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Jan 2022 17:15:06 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56142 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiABWPF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Jan 2022 17:15:05 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CBBDA62BD8
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Jan 2022 23:12:19 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables,v2 7/7] optimize: merge several selectors with different verdict into verdict map
Date:   Sun,  2 Jan 2022 23:14:52 +0100
Message-Id: <20220102221452.86469-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220102221452.86469-1-pablo@netfilter.org>
References: <20220102221452.86469-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Transform:

  ip saddr 1.1.1.1 ip daddr 2.2.2.2 accept
  ip saddr 2.2.2.2 ip daddr 3.3.3.3 drop

into:

  ip saddr . ip daddr vmap { 1.1.1.1 . 2.2.2.2 : accept, 2.2.2.2 . 3.3.3.3 : drop }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c                              | 30 +++++++++-
 src/optimize.c                                | 57 ++++++++++++++++++-
 .../dumps/merge_stmts_concat_vmap.nft         |  5 ++
 .../optimizations/merge_stmts_concat_vmap     | 13 +++++
 4 files changed, 102 insertions(+), 3 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_stmts_concat_vmap

diff --git a/src/expression.c b/src/expression.c
index 34e0880be470..ea999f2e546c 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1185,14 +1185,40 @@ struct expr *mapping_expr_alloc(const struct location *loc,
 	return expr;
 }
 
+static bool __set_expr_is_vmap(const struct expr *mappings)
+{
+	const struct expr *mapping;
+
+	if (list_empty(&mappings->expressions))
+		return false;
+
+	mapping = list_first_entry(&mappings->expressions, struct expr, list);
+	if (mapping->etype == EXPR_MAPPING &&
+	    mapping->right->etype == EXPR_VERDICT)
+		return true;
+
+	return false;
+}
+
+static bool set_expr_is_vmap(const struct expr *expr)
+{
+
+	if (expr->mappings->etype == EXPR_SET)
+		return __set_expr_is_vmap(expr->mappings);
+
+	return false;
+}
+
 static void map_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	expr_print(expr->map, octx);
-	if (expr->mappings->etype == EXPR_SET_REF &&
-	    expr->mappings->set->data->dtype->type == TYPE_VERDICT)
+	if ((expr->mappings->etype == EXPR_SET_REF &&
+	     expr->mappings->set->data->dtype->type == TYPE_VERDICT) ||
+	    set_expr_is_vmap(expr))
 		nft_print(octx, " vmap ");
 	else
 		nft_print(octx, " map ");
+
 	expr_print(expr->mappings, octx);
 }
 
diff --git a/src/optimize.c b/src/optimize.c
index 1ca5e25e4337..b16fb5ec1b05 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -408,6 +408,61 @@ static void merge_stmts_vmap(const struct optimize_ctx *ctx,
 	stmt_free(verdict_a);
 }
 
+static void merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
+				    uint32_t from, uint32_t to,
+				    const struct merge *merge)
+{
+	struct stmt *orig_stmt = ctx->stmt_matrix[from][merge->stmt[0]];
+	struct expr *concat_a, *concat_b, *expr, *set;
+	struct stmt *stmt, *stmt_a, *stmt_b, *verdict;
+	uint32_t i, j;
+	int k;
+
+	k = stmt_verdict_find(ctx);
+	assert(k >= 0);
+
+	/* build concatenation of selectors, eg. ifname . ip daddr . tcp dport */
+	concat_a = concat_expr_alloc(&internal_location);
+	for (i = 0; i < merge->num_stmts; i++) {
+		stmt_a = ctx->stmt_matrix[from][merge->stmt[i]];
+		compound_expr_add(concat_a, expr_get(stmt_a->expr->left));
+	}
+
+	/* build set data contenation, eg. { eth0 . 1.1.1.1 . 22 : accept } */
+	set = set_expr_alloc(&internal_location, NULL);
+	set->set_flags |= NFT_SET_ANONYMOUS;
+
+	for (i = from; i <= to; i++) {
+		concat_b = concat_expr_alloc(&internal_location);
+		for (j = 0; j < merge->num_stmts; j++) {
+			stmt_b = ctx->stmt_matrix[i][merge->stmt[j]];
+			expr = stmt_b->expr->right;
+			compound_expr_add(concat_b, expr_get(expr));
+		}
+		verdict = ctx->stmt_matrix[i][k];
+		build_verdict_map(concat_b, verdict, set);
+		expr_free(concat_b);
+	}
+
+	expr = map_expr_alloc(&internal_location, concat_a, set);
+	stmt = verdict_stmt_alloc(&internal_location, expr);
+
+	remove_counter(ctx, from);
+	list_add(&stmt->list, &orig_stmt->list);
+	list_del(&orig_stmt->list);
+	stmt_free(orig_stmt);
+
+	for (i = 1; i < merge->num_stmts; i++) {
+		stmt_a = ctx->stmt_matrix[from][merge->stmt[i]];
+		list_del(&stmt_a->list);
+		stmt_free(stmt_a);
+	}
+
+	verdict = ctx->stmt_matrix[from][k];
+	list_del(&verdict->list);
+	stmt_free(verdict);
+}
+
 static bool stmt_verdict_cmp(const struct optimize_ctx *ctx,
 			     uint32_t from, uint32_t to)
 {
@@ -478,7 +533,7 @@ static void merge_rules(const struct optimize_ctx *ctx,
 		if (same_verdict)
 			merge_concat_stmts(ctx, from, to, merge);
 		else
-			return;
+			merge_concat_stmts_vmap(ctx, from, to, merge);
 	} else {
 		if (same_verdict)
 			merge_stmts(ctx, from, to, merge);
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft
new file mode 100644
index 000000000000..c0f9ce0ccb6c
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft
@@ -0,0 +1,5 @@
+table ip x {
+	chain y {
+		ip saddr . ip daddr vmap { 1.1.1.1 . 2.2.2.2 : accept, 2.2.2.2 . 3.3.3.3 : drop, 4.4.4.4 . 5.5.5.5 : accept }
+	}
+}
diff --git a/tests/shell/testcases/optimizations/merge_stmts_concat_vmap b/tests/shell/testcases/optimizations/merge_stmts_concat_vmap
new file mode 100755
index 000000000000..f1ab0288ab0d
--- /dev/null
+++ b/tests/shell/testcases/optimizations/merge_stmts_concat_vmap
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+	chain y {
+		ip saddr 1.1.1.1 ip daddr 2.2.2.2 accept
+		ip saddr 2.2.2.2 ip daddr 3.3.3.3 drop
+		ip saddr 4.4.4.4 ip daddr 5.5.5.5 accept
+	}
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

