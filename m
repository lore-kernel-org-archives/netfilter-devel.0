From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/5 nft] segtree: pass element expression as parameter to set_to_intervals()
Date: Tue, 19 Jan 2016 18:52:55 +0100
Message-ID: <1453225976-23749-4-git-send-email-pablo@netfilter.org>
References: <1453225976-23749-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, ast@fiberby.dk
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56875 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932666AbcASRxX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2016 12:53:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BE927231672
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AF84EDA814
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BC72ADA843
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:17 +0100 (CET)
In-Reply-To: <1453225976-23749-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the existing set element definition to build the segment tree, so we
skip the elements that we already have defined in the kernel (that we
have in the set->init expression list).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |  3 ++-
 src/rule.c           |  2 +-
 src/segtree.c        | 15 ++++++++-------
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index eacbb2d..55af734 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -363,7 +363,8 @@ extern struct expr *concat_expr_alloc(const struct location *loc);
 extern struct expr *list_expr_alloc(const struct location *loc);
 
 extern struct expr *set_expr_alloc(const struct location *loc);
-extern int set_to_intervals(struct list_head *msgs, struct set *set);
+extern int set_to_intervals(struct list_head *msgs, struct set *set,
+			    struct expr *init);
 
 extern struct expr *mapping_expr_alloc(const struct location *loc,
 				       struct expr *from, struct expr *to);
diff --git a/src/rule.c b/src/rule.c
index 1295228..8549c2b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -874,7 +874,7 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		return -1;
 	if (set->init != NULL) {
 		if (set->flags & SET_F_INTERVAL &&
-		    set_to_intervals(ctx->msgs, set) < 0)
+		    set_to_intervals(ctx->msgs, set, set->init) < 0)
 			return -1;
 		if (netlink_add_setelems(ctx, &set->handle, set->init) < 0)
 			return -1;
diff --git a/src/segtree.c b/src/segtree.c
index 86c37b4..5b1cd29 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -64,11 +64,12 @@ struct elementary_interval {
 	struct expr			*expr;
 };
 
-static void seg_tree_init(struct seg_tree *tree, const struct set *set)
+static void seg_tree_init(struct seg_tree *tree, const struct set *set,
+			  struct expr *init)
 {
 	struct expr *first;
 
-	first = list_entry(set->init->expressions.next, struct expr, list);
+	first = list_entry(init->expressions.next, struct expr, list);
 	tree->root	= RB_ROOT;
 	tree->keytype	= set->keytype;
 	tree->keylen	= set->keylen;
@@ -431,14 +432,14 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 	compound_expr_add(set, expr);
 }
 
-int set_to_intervals(struct list_head *errs, struct set *set)
+int set_to_intervals(struct list_head *errs, struct set *set, struct expr *init)
 {
 	struct elementary_interval *ei, *next;
 	struct seg_tree tree;
 	LIST_HEAD(list);
 
-	seg_tree_init(&tree, set);
-	if (set_to_segtree(errs, set->init, &tree) < 0)
+	seg_tree_init(&tree, set, init);
+	if (set_to_segtree(errs, init, &tree) < 0)
 		return -1;
 	segtree_linearize(&list, &tree);
 
@@ -448,12 +449,12 @@ int set_to_intervals(struct list_head *errs, struct set *set)
 				     2 * tree.keylen / BITS_PER_BYTE, ei->left,
 				     2 * tree.keylen / BITS_PER_BYTE, ei->right);
 		}
-		set_insert_interval(set->init, &tree, ei);
+		set_insert_interval(init, &tree, ei);
 		ei_destroy(ei);
 	}
 
 	if (segtree_debug()) {
-		expr_print(set->init);
+		expr_print(init);
 		pr_gmp_debug("\n");
 	}
 	return 0;
-- 
2.1.4

