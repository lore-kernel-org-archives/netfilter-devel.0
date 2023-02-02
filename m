Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4103AC05027
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Feb 2023 21:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjBBVEj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Feb 2023 16:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbjBBVEi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Feb 2023 16:04:38 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D4643D90A
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Feb 2023 13:04:37 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] optimize: fix incorrect expansion into concatenation with verdict map
Date:   Thu,  2 Feb 2023 22:04:32 +0100
Message-Id: <20230202210432.106465-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230202210432.106465-1-pablo@netfilter.org>
References: <20230202210432.106465-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # nft -c -o -f ruleset.nft
 Merging:
 ruleset.nft:3:3-53:          meta pkttype broadcast udp dport { 67, 547 } accept
 ruleset.nft:4:17-58:         meta pkttype multicast udp dport 1900 drop
 into:
        meta pkttype . udp dport vmap { broadcast . { 67, 547 } : accept, multicast . 1900 : drop }
 ruleset.nft:3:38-39: Error: invalid data type, expected concatenation of (packet type, internet network service)
                meta pkttype broadcast udp dport { 67, 547 } accept
                                                   ^^

Similar to 187c6d01d357 ("optimize: expand implicit set element when
merging into concatenation") but for verdict maps.

Reported-by: Simon G. Trajkovski <neur0armitage@proton.me>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 33 ++++++++++++-------
 .../dumps/merge_stmts_concat_vmap.nft         |  4 +++
 .../optimizations/merge_stmts_concat_vmap     |  4 +++
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 8cec04c02c4f..5f6e3a64fdd3 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -738,14 +738,32 @@ static void merge_stmts_vmap(const struct optimize_ctx *ctx,
 	stmt_free(verdict_a);
 }
 
+static void __merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
+				      uint32_t i, const struct merge *merge,
+				      struct expr *set, struct stmt *verdict)
+{
+	struct expr *concat, *next, *elem, *mapping;
+	LIST_HEAD(concat_list);
+
+	__merge_concat(ctx, i, merge, &concat_list);
+
+	list_for_each_entry_safe(concat, next, &concat_list, list) {
+		list_del(&concat->list);
+		elem = set_elem_expr_alloc(&internal_location, concat);
+		mapping = mapping_expr_alloc(&internal_location, elem,
+					     expr_get(verdict->expr));
+		compound_expr_add(set, mapping);
+	}
+}
+
 static void merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 				    uint32_t from, uint32_t to,
 				    const struct merge *merge)
 {
 	struct stmt *orig_stmt = ctx->stmt_matrix[from][merge->stmt[0]];
-	struct expr *concat_a, *concat_b, *expr, *set;
-	struct stmt *stmt, *stmt_a, *stmt_b, *verdict;
-	uint32_t i, j;
+	struct stmt *stmt, *stmt_a, *verdict;
+	struct expr *concat_a, *expr, *set;
+	uint32_t i;
 	int k;
 
 	k = stmt_verdict_find(ctx);
@@ -763,15 +781,8 @@ static void merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 	set->set_flags |= NFT_SET_ANONYMOUS;
 
 	for (i = from; i <= to; i++) {
-		concat_b = concat_expr_alloc(&internal_location);
-		for (j = 0; j < merge->num_stmts; j++) {
-			stmt_b = ctx->stmt_matrix[i][merge->stmt[j]];
-			expr = stmt_b->expr->right;
-			compound_expr_add(concat_b, expr_get(expr));
-		}
 		verdict = ctx->stmt_matrix[i][k];
-		build_verdict_map(concat_b, verdict, set);
-		expr_free(concat_b);
+		__merge_concat_stmts_vmap(ctx, i, merge, set, verdict);
 	}
 
 	expr = map_expr_alloc(&internal_location, concat_a, set);
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft
index c0f9ce0ccb6c..780aa09adbe6 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft
@@ -1,4 +1,8 @@
 table ip x {
+	chain x {
+		meta pkttype . udp dport vmap { broadcast . 547 : accept, broadcast . 67 : accept, multicast . 1900 : drop }
+	}
+
 	chain y {
 		ip saddr . ip daddr vmap { 1.1.1.1 . 2.2.2.2 : accept, 2.2.2.2 . 3.3.3.3 : drop, 4.4.4.4 . 5.5.5.5 : accept }
 	}
diff --git a/tests/shell/testcases/optimizations/merge_stmts_concat_vmap b/tests/shell/testcases/optimizations/merge_stmts_concat_vmap
index 5c0ae60caafa..657d0aea2272 100755
--- a/tests/shell/testcases/optimizations/merge_stmts_concat_vmap
+++ b/tests/shell/testcases/optimizations/merge_stmts_concat_vmap
@@ -3,6 +3,10 @@
 set -e
 
 RULESET="table ip x {
+	chain x {
+		meta pkttype broadcast udp dport { 67, 547 } accept
+		meta pkttype multicast udp dport 1900 drop
+	}
 	chain y {
 		ip saddr 1.1.1.1 ip daddr 2.2.2.2 accept
 		ip saddr 4.4.4.4 ip daddr 5.5.5.5 accept
-- 
2.30.2

