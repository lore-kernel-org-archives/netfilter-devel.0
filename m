Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E3CECAAD4
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Aug 2022 12:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiH2Mzn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Aug 2022 08:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiH2Mz0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Aug 2022 08:55:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A9F4205D0
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2022 05:45:22 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] optimize: expand implicit set element when merging into concatenation
Date:   Mon, 29 Aug 2022 14:45:14 +0200
Message-Id: <20220829124514.444833-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Generalize the existing code to deal with implicit sets. When merging a
ruleset like the following:

	udp dport 128 iifname "foo"		#1
        udp dport { 67, 123 } iifname "bar"	#2

into a concatenation of statements, the following expansion need to
be done for rule #2:

	67 . "bar"
	123 . "bar"

The expansion logic consists of cloning the existing concatenation being
built and then append each element in the implicit set. A list of
ongoing concatenations being built is maintained, so further expansions
are also supported.

Extend test to cover for this use-case.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1628
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: cover EXPR_VALUE case too to remedy a tests/shell assertion being reported.
    Now all tests/shell pass successfully.

 src/optimize.c                                | 62 ++++++++++++++++---
 .../dumps/merge_stmts_concat.nft              | 12 ++++
 .../optimizations/merge_stmts_concat          | 19 ++++++
 3 files changed, 83 insertions(+), 10 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index ea067f80bce0..83fd6ec342ea 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -550,12 +550,60 @@ static void merge_stmts(const struct optimize_ctx *ctx,
 	}
 }
 
+static void __merge_concat_stmts(const struct optimize_ctx *ctx, uint32_t i,
+				 const struct merge *merge, struct expr *set)
+{
+	struct expr *concat, *next, *expr, *concat_clone, *clone, *elem;
+	LIST_HEAD(pending_list);
+	LIST_HEAD(concat_list);
+	struct stmt *stmt_a;
+	uint32_t k;
+
+	concat = concat_expr_alloc(&internal_location);
+	list_add(&concat->list, &concat_list);
+
+	for (k = 0; k < merge->num_stmts; k++) {
+		list_for_each_entry_safe(concat, next, &concat_list, list) {
+			stmt_a = ctx->stmt_matrix[i][merge->stmt[k]];
+			switch (stmt_a->expr->right->etype) {
+			case EXPR_SET:
+				list_for_each_entry(expr, &stmt_a->expr->right->expressions, list) {
+					concat_clone = expr_clone(concat);
+					clone = expr_clone(expr->key);
+					compound_expr_add(concat_clone, clone);
+					list_add_tail(&concat_clone->list, &pending_list);
+				}
+				list_del(&concat->list);
+				expr_free(concat);
+				break;
+			case EXPR_SYMBOL:
+			case EXPR_VALUE:
+				clone = expr_clone(stmt_a->expr->right);
+				compound_expr_add(concat, clone);
+				break;
+			default:
+				assert(0);
+				break;
+			}
+		}
+		list_splice_init(&pending_list, &concat_list);
+	}
+
+	list_for_each_entry_safe(concat, next, &concat_list, list) {
+		list_del(&concat->list);
+		elem = set_elem_expr_alloc(&internal_location, concat);
+		compound_expr_add(set, elem);
+	}
+}
+
 static void merge_concat_stmts(const struct optimize_ctx *ctx,
 			       uint32_t from, uint32_t to,
 			       const struct merge *merge)
 {
-	struct expr *concat, *elem, *set;
 	struct stmt *stmt, *stmt_a;
+	struct expr *concat, *set;
+	LIST_HEAD(pending_list);
+	LIST_HEAD(concat_list);
 	uint32_t i, k;
 
 	stmt = ctx->stmt_matrix[from][merge->stmt[0]];
@@ -573,15 +621,9 @@ static void merge_concat_stmts(const struct optimize_ctx *ctx,
 	set = set_expr_alloc(&internal_location, NULL);
 	set->set_flags |= NFT_SET_ANONYMOUS;
 
-	for (i = from; i <= to; i++) {
-		concat = concat_expr_alloc(&internal_location);
-		for (k = 0; k < merge->num_stmts; k++) {
-			stmt_a = ctx->stmt_matrix[i][merge->stmt[k]];
-			compound_expr_add(concat, expr_get(stmt_a->expr->right));
-		}
-		elem = set_elem_expr_alloc(&internal_location, concat);
-		compound_expr_add(set, elem);
-	}
+	for (i = from; i <= to; i++)
+		__merge_concat_stmts(ctx, i, merge, set);
+
 	expr_free(stmt->expr->right);
 	stmt->expr->right = set;
 
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
index 15cfa7e85c33..5d03cf8d9566 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
@@ -3,4 +3,16 @@ table ip x {
 		iifname . ip saddr . ip daddr { "eth1" . 1.1.1.1 . 2.2.2.3, "eth1" . 1.1.1.2 . 2.2.2.4, "eth2" . 1.1.1.3 . 2.2.2.5 } accept
 		ip protocol . th dport { tcp . 22, udp . 67 }
 	}
+
+	chain c1 {
+		udp dport . iifname { 51820 . "foo", 514 . "bar", 67 . "bar" } accept
+	}
+
+	chain c2 {
+		udp dport . iifname { 100 . "foo", 51820 . "foo", 514 . "bar", 67 . "bar" } accept
+	}
+
+	chain c3 {
+		udp dport . iifname { 100 . "foo", 51820 . "foo", 514 . "bar", 67 . "bar", 100 . "test", 51820 . "test" } accept
+	}
 }
diff --git a/tests/shell/testcases/optimizations/merge_stmts_concat b/tests/shell/testcases/optimizations/merge_stmts_concat
index 623fdff9a649..0bcd95622a98 100755
--- a/tests/shell/testcases/optimizations/merge_stmts_concat
+++ b/tests/shell/testcases/optimizations/merge_stmts_concat
@@ -12,3 +12,22 @@ RULESET="table ip x {
 }"
 
 $NFT -o -f - <<< $RULESET
+
+RULESET="table ip x {
+	chain c1 {
+		udp dport 51820 iifname "foo" accept
+		udp dport { 67, 514 } iifname "bar" accept
+	}
+
+	chain c2 {
+		udp dport { 51820, 100 } iifname "foo" accept
+		udp dport { 67, 514 } iifname "bar" accept
+	}
+
+	chain c3 {
+		udp dport { 51820, 100 } iifname { "foo", "test" } accept
+		udp dport { 67, 514 } iifname "bar" accept
+	}
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

