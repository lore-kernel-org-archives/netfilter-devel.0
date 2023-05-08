Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1346AC7EE24
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 May 2023 06:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjEHGHd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 May 2023 02:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbjEHGHb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2023 02:07:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27305150E7
        for <netfilter-devel@vger.kernel.org>; Sun,  7 May 2023 23:07:30 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] optimize: do not remove counter in verdict maps
Date:   Mon,  8 May 2023 08:07:20 +0200
Message-Id: <20230508060720.2296-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230508060720.2296-1-pablo@netfilter.org>
References: <20230508060720.2296-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add counter to set element instead of dropping it:

 # nft -c -o -f test.nft
 Merging:
 test.nft:6:3-50:              ip saddr 1.1.1.1 ip daddr 2.2.2.2 counter accept
 test.nft:7:3-48:              ip saddr 1.1.1.2 ip daddr 3.3.3.3 counter drop
 into:
       ip daddr . ip saddr vmap { 2.2.2.2 . 1.1.1.1 counter : accept, 3.3.3.3 . 1.1.1.2 counter : drop }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 50 ++++++++++++++++---
 .../optimizations/dumps/merge_stmts_vmap.nft  |  4 ++
 .../testcases/optimizations/merge_stmts_vmap  |  4 ++
 3 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 22dfbcd92e5e..7ca57ce73873 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -689,7 +689,8 @@ static void merge_concat_stmts(const struct optimize_ctx *ctx,
 	}
 }
 
-static void build_verdict_map(struct expr *expr, struct stmt *verdict, struct expr *set)
+static void build_verdict_map(struct expr *expr, struct stmt *verdict,
+			      struct expr *set, struct stmt *counter)
 {
 	struct expr *item, *elem, *mapping;
 
@@ -697,6 +698,9 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict, struct ex
 	case EXPR_LIST:
 		list_for_each_entry(item, &expr->expressions, list) {
 			elem = set_elem_expr_alloc(&internal_location, expr_get(item));
+			if (counter)
+				list_add_tail(&counter->list, &elem->stmt_list);
+
 			mapping = mapping_expr_alloc(&internal_location, elem,
 						     expr_get(verdict->expr));
 			compound_expr_add(set, mapping);
@@ -705,6 +709,9 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict, struct ex
 	case EXPR_SET:
 		list_for_each_entry(item, &expr->expressions, list) {
 			elem = set_elem_expr_alloc(&internal_location, expr_get(item->key));
+			if (counter)
+				list_add_tail(&counter->list, &elem->stmt_list);
+
 			mapping = mapping_expr_alloc(&internal_location, elem,
 						     expr_get(verdict->expr));
 			compound_expr_add(set, mapping);
@@ -716,6 +723,9 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict, struct ex
 	case EXPR_SYMBOL:
 	case EXPR_CONCAT:
 		elem = set_elem_expr_alloc(&internal_location, expr_get(expr));
+		if (counter)
+			list_add_tail(&counter->list, &elem->stmt_list);
+
 		mapping = mapping_expr_alloc(&internal_location, elem,
 					     expr_get(verdict->expr));
 		compound_expr_add(set, mapping);
@@ -744,6 +754,26 @@ static void remove_counter(const struct optimize_ctx *ctx, uint32_t from)
 	}
 }
 
+static struct stmt *zap_counter(const struct optimize_ctx *ctx, uint32_t from)
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
+			return stmt;
+		}
+	}
+
+	return NULL;
+}
+
 static void merge_stmts_vmap(const struct optimize_ctx *ctx,
 			     uint32_t from, uint32_t to,
 			     const struct merge *merge)
@@ -751,31 +781,33 @@ static void merge_stmts_vmap(const struct optimize_ctx *ctx,
 	struct stmt *stmt_a = ctx->stmt_matrix[from][merge->stmt[0]];
 	struct stmt *stmt_b, *verdict_a, *verdict_b, *stmt;
 	struct expr *expr_a, *expr_b, *expr, *left, *set;
+	struct stmt *counter;
 	uint32_t i;
 	int k;
 
 	k = stmt_verdict_find(ctx);
 	assert(k >= 0);
 
-	verdict_a = ctx->stmt_matrix[from][k];
 	set = set_expr_alloc(&internal_location, NULL);
 	set->set_flags |= NFT_SET_ANONYMOUS;
 
 	expr_a = stmt_a->expr->right;
-	build_verdict_map(expr_a, verdict_a, set);
+	verdict_a = ctx->stmt_matrix[from][k];
+	counter = zap_counter(ctx, from);
+	build_verdict_map(expr_a, verdict_a, set, counter);
+
 	for (i = from + 1; i <= to; i++) {
 		stmt_b = ctx->stmt_matrix[i][merge->stmt[0]];
 		expr_b = stmt_b->expr->right;
 		verdict_b = ctx->stmt_matrix[i][k];
-
-		build_verdict_map(expr_b, verdict_b, set);
+		counter = zap_counter(ctx, i);
+		build_verdict_map(expr_b, verdict_b, set, counter);
 	}
 
 	left = expr_get(stmt_a->expr->left);
 	expr = map_expr_alloc(&internal_location, left, set);
 	stmt = verdict_stmt_alloc(&internal_location, expr);
 
-	remove_counter(ctx, from);
 	list_add(&stmt->list, &stmt_a->list);
 	list_del(&stmt_a->list);
 	stmt_free(stmt_a);
@@ -789,12 +821,17 @@ static void __merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 {
 	struct expr *concat, *next, *elem, *mapping;
 	LIST_HEAD(concat_list);
+	struct stmt *counter;
 
+	counter = zap_counter(ctx, i);
 	__merge_concat(ctx, i, merge, &concat_list);
 
 	list_for_each_entry_safe(concat, next, &concat_list, list) {
 		list_del(&concat->list);
 		elem = set_elem_expr_alloc(&internal_location, concat);
+		if (counter)
+			list_add_tail(&counter->list, &elem->stmt_list);
+
 		mapping = mapping_expr_alloc(&internal_location, elem,
 					     expr_get(verdict->expr));
 		compound_expr_add(set, mapping);
@@ -833,7 +870,6 @@ static void merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 	expr = map_expr_alloc(&internal_location, concat_a, set);
 	stmt = verdict_stmt_alloc(&internal_location, expr);
 
-	remove_counter(ctx, from);
 	list_add(&stmt->list, &orig_stmt->list);
 	list_del(&orig_stmt->list);
 	stmt_free(orig_stmt);
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
index 5a9b3006743b..8ecbd9276fd9 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
@@ -6,4 +6,8 @@ table ip x {
 	chain z {
 		tcp dport vmap { 1 : accept, 2-3 : drop, 4 : accept }
 	}
+
+	chain w {
+		ip saddr vmap { 1.1.1.1 counter packets 0 bytes 0 : accept, 1.1.1.2 counter packets 0 bytes 0 : drop }
+	}
 }
diff --git a/tests/shell/testcases/optimizations/merge_stmts_vmap b/tests/shell/testcases/optimizations/merge_stmts_vmap
index 79350076d6c6..6e0f0762b7bb 100755
--- a/tests/shell/testcases/optimizations/merge_stmts_vmap
+++ b/tests/shell/testcases/optimizations/merge_stmts_vmap
@@ -12,6 +12,10 @@ RULESET="table ip x {
 		tcp dport 2-3 drop
 		tcp dport 4 accept
 	}
+	chain w {
+		ip saddr 1.1.1.1 counter accept
+		ip saddr 1.1.1.2 counter drop
+	}
 }"
 
 $NFT -o -f - <<< $RULESET
-- 
2.30.2

