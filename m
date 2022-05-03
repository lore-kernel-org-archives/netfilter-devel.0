Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B714C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 May 2022 16:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbiECQOA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 May 2022 12:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239216AbiECQN4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 May 2022 12:13:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAA84167DA
        for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2022 09:10:22 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] optimize: merge nat rules with same selectors into map
Date:   Tue,  3 May 2022 18:10:17 +0200
Message-Id: <20220503161017.54258-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220503161017.54258-1-pablo@netfilter.org>
References: <20220503161017.54258-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Verdict and nat are mutually exclusive, no need to support for this
combination.

 # cat ruleset.nft
 table ip x {
        chain y {
		type nat hook postrouting priority srcnat; policy drop;
                ip saddr 1.1.1.1 tcp dport 8000 snat to 4.4.4.4:80
                ip saddr 2.2.2.2 tcp dport 8001 snat to 5.5.5.5:90
        }
 }

 # nft -o -c -f ruleset.nft
 Merging:
 ruleset.nft:4:3-52:                ip saddr 1.1.1.1 tcp dport 8000 snat to 4.4.4.4:80
 ruleset.nft:5:3-52:                ip saddr 2.2.2.2 tcp dport 8001 snat to 5.5.5.5:90
 into:
        snat to ip saddr . tcp dport map { 1.1.1.1 . 8000 : 4.4.4.4 . 80, 2.2.2.2 . 8001 : 5.5.5.5 . 90 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 200 +++++++++++++++++-
 .../optimizations/dumps/merge_nat.nft         |  20 ++
 tests/shell/testcases/optimizations/merge_nat |  39 ++++
 3 files changed, 249 insertions(+), 10 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_nat.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_nat

diff --git a/src/optimize.c b/src/optimize.c
index 13890a63e210..21af9f52971e 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -173,6 +173,22 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
 		    stmt_a->reject.icmp_code != stmt_b->reject.icmp_code)
 			return false;
 		break;
+	case STMT_NAT:
+		if (stmt_a->nat.type != stmt_b->nat.type ||
+		    stmt_a->nat.flags != stmt_b->nat.flags ||
+		    stmt_a->nat.family != stmt_b->nat.family ||
+		    stmt_a->nat.type_flags != stmt_b->nat.type_flags ||
+		    (stmt_a->nat.addr &&
+		     stmt_a->nat.addr->etype != EXPR_SYMBOL) ||
+		    (stmt_b->nat.addr &&
+		     stmt_b->nat.addr->etype != EXPR_SYMBOL) ||
+		    (stmt_a->nat.proto &&
+		     stmt_a->nat.proto->etype != EXPR_SYMBOL) ||
+		    (stmt_b->nat.proto &&
+		     stmt_b->nat.proto->etype != EXPR_SYMBOL))
+			return false;
+
+		return true;
 	default:
 		/* ... Merging anything else is yet unsupported. */
 		return false;
@@ -273,6 +289,16 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 			if (stmt->log.prefix)
 				clone->log.prefix = expr_get(stmt->log.prefix);
 			break;
+		case STMT_NAT:
+			clone->nat.type = stmt->nat.type;
+			clone->nat.family = stmt->nat.family;
+			if (stmt->nat.addr)
+				clone->nat.addr = expr_clone(stmt->nat.addr);
+			if (stmt->nat.proto)
+				clone->nat.proto = expr_clone(stmt->nat.proto);
+			clone->nat.flags = stmt->nat.flags;
+			clone->nat.type_flags = stmt->nat.type_flags;
+			break;
 		default:
 			continue;
 		}
@@ -630,6 +656,129 @@ static bool stmt_verdict_cmp(const struct optimize_ctx *ctx,
 	return true;
 }
 
+static int stmt_nat_find(const struct optimize_ctx *ctx)
+{
+	uint32_t i;
+
+	for (i = 0; i < ctx->num_stmts; i++) {
+		if (ctx->stmt[i]->ops->type != STMT_NAT)
+			continue;
+
+		return i;
+	}
+
+	return -1;
+}
+
+static struct expr *stmt_nat_expr(struct stmt *nat_stmt)
+{
+	struct expr *nat_expr;
+
+	if (nat_stmt->nat.proto) {
+		nat_expr = concat_expr_alloc(&internal_location);
+		compound_expr_add(nat_expr, expr_get(nat_stmt->nat.addr));
+		compound_expr_add(nat_expr, expr_get(nat_stmt->nat.proto));
+		expr_free(nat_stmt->nat.proto);
+		nat_stmt->nat.proto = NULL;
+	} else {
+		nat_expr = expr_get(nat_stmt->nat.addr);
+	}
+
+	return nat_expr;
+}
+
+static void merge_nat(const struct optimize_ctx *ctx,
+		      uint32_t from, uint32_t to,
+		      const struct merge *merge)
+{
+	struct expr *expr, *set, *elem, *nat_expr, *mapping, *left;
+	struct stmt *stmt, *nat_stmt;
+	uint32_t i;
+	int k;
+
+	k = stmt_nat_find(ctx);
+	assert(k >= 0);
+
+	set = set_expr_alloc(&internal_location, NULL);
+	set->set_flags |= NFT_SET_ANONYMOUS;
+
+	for (i = from; i <= to; i++) {
+		stmt = ctx->stmt_matrix[i][merge->stmt[0]];
+		expr = stmt->expr->right;
+
+		nat_stmt = ctx->stmt_matrix[i][k];
+		nat_expr = stmt_nat_expr(nat_stmt);
+
+		elem = set_elem_expr_alloc(&internal_location, expr_get(expr));
+		mapping = mapping_expr_alloc(&internal_location, elem, nat_expr);
+		compound_expr_add(set, mapping);
+	}
+
+	stmt = ctx->stmt_matrix[from][merge->stmt[0]];
+	left = expr_get(stmt->expr->left);
+	expr = map_expr_alloc(&internal_location, left, set);
+
+	nat_stmt = ctx->stmt_matrix[from][k];
+	expr_free(nat_stmt->nat.addr);
+	nat_stmt->nat.addr = expr;
+
+	remove_counter(ctx, from);
+	list_del(&stmt->list);
+	stmt_free(stmt);
+}
+
+static void merge_concat_nat(const struct optimize_ctx *ctx,
+			     uint32_t from, uint32_t to,
+			     const struct merge *merge)
+{
+	struct expr *expr, *set, *elem, *nat_expr, *mapping, *left, *concat;
+	struct stmt *stmt, *nat_stmt;
+	uint32_t i, j;
+	int k;
+
+	k = stmt_nat_find(ctx);
+	assert(k >= 0);
+
+	set = set_expr_alloc(&internal_location, NULL);
+	set->set_flags |= NFT_SET_ANONYMOUS;
+
+	for (i = from; i <= to; i++) {
+
+		concat = concat_expr_alloc(&internal_location);
+		for (j = 0; j < merge->num_stmts; j++) {
+			stmt = ctx->stmt_matrix[i][merge->stmt[j]];
+			expr = stmt->expr->right;
+			compound_expr_add(concat, expr_get(expr));
+		}
+
+		nat_stmt = ctx->stmt_matrix[i][k];
+		nat_expr = stmt_nat_expr(nat_stmt);
+
+		elem = set_elem_expr_alloc(&internal_location, concat);
+		mapping = mapping_expr_alloc(&internal_location, elem, nat_expr);
+		compound_expr_add(set, mapping);
+	}
+
+	concat = concat_expr_alloc(&internal_location);
+	for (j = 0; j < merge->num_stmts; j++) {
+		stmt = ctx->stmt_matrix[from][merge->stmt[j]];
+		left = stmt->expr->left;
+		compound_expr_add(concat, expr_get(left));
+	}
+	expr = map_expr_alloc(&internal_location, concat, set);
+
+	nat_stmt = ctx->stmt_matrix[from][k];
+	expr_free(nat_stmt->nat.addr);
+	nat_stmt->nat.addr = expr;
+
+	remove_counter(ctx, from);
+	for (j = 0; j < merge->num_stmts; j++) {
+		stmt = ctx->stmt_matrix[from][merge->stmt[j]];
+		list_del(&stmt->list);
+		stmt_free(stmt);
+	}
+}
+
 static void rule_optimize_print(struct output_ctx *octx,
 				const struct rule *rule)
 {
@@ -663,26 +812,57 @@ static void rule_optimize_print(struct output_ctx *octx,
 	fprintf(octx->error_fp, "%s\n", line);
 }
 
+static enum stmt_types merge_stmt_type(const struct optimize_ctx *ctx)
+{
+	uint32_t i;
+
+	for (i = 0; i < ctx->num_stmts; i++) {
+		switch (ctx->stmt[i]->ops->type) {
+		case STMT_VERDICT:
+		case STMT_NAT:
+			return ctx->stmt[i]->ops->type;
+		default:
+			continue;
+		}
+	}
+
+	return STMT_INVALID;
+}
+
 static void merge_rules(const struct optimize_ctx *ctx,
 			uint32_t from, uint32_t to,
 			const struct merge *merge,
 			struct output_ctx *octx)
 {
+	enum stmt_types stmt_type;
 	bool same_verdict;
 	uint32_t i;
 
-	same_verdict = stmt_verdict_cmp(ctx, from, to);
+	stmt_type = merge_stmt_type(ctx);
 
-	if (merge->num_stmts > 1) {
-		if (same_verdict)
-			merge_concat_stmts(ctx, from, to, merge);
-		else
-			merge_concat_stmts_vmap(ctx, from, to, merge);
-	} else {
-		if (same_verdict)
-			merge_stmts(ctx, from, to, merge);
+	switch (stmt_type) {
+	case STMT_VERDICT:
+		same_verdict = stmt_verdict_cmp(ctx, from, to);
+		if (merge->num_stmts > 1) {
+			if (same_verdict)
+				merge_concat_stmts(ctx, from, to, merge);
+			else
+				merge_concat_stmts_vmap(ctx, from, to, merge);
+		} else {
+			if (same_verdict)
+				merge_stmts(ctx, from, to, merge);
+			else
+				merge_stmts_vmap(ctx, from, to, merge);
+		}
+		break;
+	case STMT_NAT:
+		if (merge->num_stmts > 1)
+			merge_concat_nat(ctx, from, to, merge);
 		else
-			merge_stmts_vmap(ctx, from, to, merge);
+			merge_nat(ctx, from, to, merge);
+		break;
+	default:
+		assert(0);
 	}
 
 	fprintf(octx->error_fp, "Merging:\n");
diff --git a/tests/shell/testcases/optimizations/dumps/merge_nat.nft b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
new file mode 100644
index 000000000000..7a6ecb76a934
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
@@ -0,0 +1,20 @@
+table ip test1 {
+	chain y {
+		dnat to ip saddr map { 4.4.4.4 : 1.1.1.1, 5.5.5.5 : 2.2.2.2 }
+	}
+}
+table ip test2 {
+	chain y {
+		dnat ip to tcp dport map { 80 : 1.1.1.1 . 8001, 81 : 2.2.2.2 . 9001 }
+	}
+}
+table ip test3 {
+	chain y {
+		snat to ip saddr . tcp sport map { 1.1.1.1 . 1024-65535 : 3.3.3.3, 2.2.2.2 . 1024-65535 : 4.4.4.4 }
+	}
+}
+table ip test4 {
+	chain y {
+		dnat ip to ip daddr . tcp dport map { 1.1.1.1 . 80 : 4.4.4.4 . 8000, 2.2.2.2 . 81 : 3.3.3.3 . 9000 }
+	}
+}
diff --git a/tests/shell/testcases/optimizations/merge_nat b/tests/shell/testcases/optimizations/merge_nat
new file mode 100755
index 000000000000..290cfcfebe2e
--- /dev/null
+++ b/tests/shell/testcases/optimizations/merge_nat
@@ -0,0 +1,39 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip test1 {
+        chain y {
+                ip saddr 4.4.4.4 dnat to 1.1.1.1
+                ip saddr 5.5.5.5 dnat to 2.2.2.2
+        }
+}"
+
+$NFT -o -f - <<< $RULESET
+
+RULESET="table ip test2 {
+        chain y {
+                tcp dport 80 dnat to 1.1.1.1:8001
+                tcp dport 81 dnat to 2.2.2.2:9001
+        }
+}"
+
+$NFT -o -f - <<< $RULESET
+
+RULESET="table ip test3 {
+        chain y {
+                ip saddr 1.1.1.1 tcp sport 1024-65535 snat to 3.3.3.3
+                ip saddr 2.2.2.2 tcp sport 1024-65535 snat to 4.4.4.4
+        }
+}"
+
+$NFT -o -f - <<< $RULESET
+
+RULESET="table ip test4 {
+        chain y {
+                ip daddr 1.1.1.1 tcp dport 80 dnat to 4.4.4.4:8000
+                ip daddr 2.2.2.2 tcp dport 81 dnat to 3.3.3.3:9000
+        }
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

