Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6650C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 19:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhLOT4Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 14:56:24 -0500
Received: from mail.netfilter.org ([217.70.188.207]:55876 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhLOT4X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 14:56:23 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 464B1625D1
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Dec 2021 20:53:54 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] optimize: merge same selector with different verdict into verdict map
Date:   Wed, 15 Dec 2021 20:56:15 +0100
Message-Id: <20211215195615.139902-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211215195615.139902-1-pablo@netfilter.org>
References: <20211215195615.139902-1-pablo@netfilter.org>
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
 src/optimize.c | 142 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 124 insertions(+), 18 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 279eabb02152..e26afb6744c9 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -96,19 +96,6 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
 	case STMT_COUNTER:
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
 	default:
 		break;
@@ -117,6 +104,29 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
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
@@ -182,6 +192,20 @@ static void rule_build_stmt_matrix_stmts(struct optimize_ctx *ctx,
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
@@ -197,7 +221,7 @@ static void merge_stmts(const struct optimize_ctx *ctx,
 	struct stmt *stmt_a = ctx->stmt_matrix[from][merge->stmt[0]];
 	struct expr *expr_a, *expr_b, *set, *elem;
 	struct stmt *stmt_b;
-	uint32_t x;
+	uint32_t i;
 
 	assert (stmt_a->ops->type == STMT_EXPRESSION);
 
@@ -206,8 +230,8 @@ static void merge_stmts(const struct optimize_ctx *ctx,
 	elem = set_elem_expr_alloc(&internal_location, expr_get(expr_a));
 	compound_expr_add(set, elem);
 
-	for (x = from + 1; x <= to; x++) {
-		stmt_b = ctx->stmt_matrix[x][merge->stmt[0]];
+	for (i = from + 1; i <= to; i++) {
+		stmt_b = ctx->stmt_matrix[i][merge->stmt[0]];
 		expr_b = stmt_b->expr->right;
 		elem = set_elem_expr_alloc(&internal_location, expr_get(expr_b));
 		compound_expr_add(set, elem);
@@ -258,16 +282,98 @@ static void merge_multi_stmts(const struct optimize_ctx *ctx,
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
+static void merge_stmts_vmap(const struct optimize_ctx *ctx,
+			     uint32_t from, uint32_t to,
+			     const struct merge *merge)
+{
+	struct stmt *stmt_a = ctx->stmt_matrix[from][merge->stmt[0]];
+	struct stmt *stmt_b, *verdict_a, *verdict_b, *stmt;
+	struct expr *expr_a, *expr_b, *expr, *left, *set;
+	uint32_t i, k;
+
+	k = stmt_verdict_find(ctx);
+	assert(k >= 0);
+
+	verdict_a = ctx->stmt_matrix[from][k];
+	expr_a = stmt_a->expr->right;
+	set = set_expr_alloc(&internal_location, NULL);
+
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
+	uint32_t k, i;
+
+	k = stmt_verdict_find(ctx);
+	if (k < 0)
+		return true;
+
+	for (i = from; i + 1 <= to; i++) {
+		stmt_a = ctx->stmt_matrix[i][k];
+		stmt_b = ctx->stmt_matrix[i + 1][k];
+		if (!stmt_verdict_eq(stmt_a, stmt_b))
+			return false;
+	}
+
+	return true;
+}
+
 static void merge_rules(const struct optimize_ctx *ctx,
 			uint32_t from, uint32_t to,
 			const struct merge *merge)
 {
+	bool same_verdict;
 	uint32_t x;
 
+	same_verdict = stmt_verdict_cmp(ctx, from, to);
+
 	if (merge->num_stmts > 1) {
-		merge_multi_stmts(ctx, from, to, merge);
+		if (same_verdict)
+			merge_multi_stmts(ctx, from, to, merge);
 	} else {
-		merge_stmts(ctx, from, to, merge);
+		if (same_verdict)
+			merge_stmts(ctx, from, to, merge);
+		else
+			merge_stmts_vmap(ctx, from, to, merge);
 	}
 	for (x = from + 1; x <= to; x++) {
 		list_del(&ctx->rule[x]->list);
-- 
2.30.2

