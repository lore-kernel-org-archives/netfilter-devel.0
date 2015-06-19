From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3] segtree: pass element expression as parameter to set_to_intervals()
Date: Fri, 19 Jun 2015 15:15:17 +0200
Message-ID: <1434719718-10371-2-git-send-email-pablo@netfilter.org>
References: <1434719718-10371-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, admin@rollinix.net, niels@kristensen.io,
	tom@compton.nu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48052 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbbFSNKE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 09:10:04 -0400
In-Reply-To: <1434719718-10371-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So we can reuse this code from set declarations.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |    3 ++-
 src/rule.c           |    2 +-
 src/segtree.c        |   15 ++++++++-------
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 010cb95..bc17762 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -362,7 +362,8 @@ extern struct expr *concat_expr_alloc(const struct location *loc);
 extern struct expr *list_expr_alloc(const struct location *loc);
 
 extern struct expr *set_expr_alloc(const struct location *loc);
-extern int set_to_intervals(struct list_head *msgs, struct set *set);
+extern int set_to_intervals(struct list_head *msgs, struct set *set,
+			    struct expr *init);
 
 extern struct expr *mapping_expr_alloc(const struct location *loc,
 				       struct expr *from, struct expr *to);
diff --git a/src/rule.c b/src/rule.c
index a4c685c..495aebc 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -704,7 +704,7 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		return -1;
 	if (set->init != NULL) {
 		if (set->flags & SET_F_INTERVAL &&
-		    set_to_intervals(ctx->msgs, set) < 0)
+		    set_to_intervals(ctx->msgs, set, set->init) < 0)
 			return -1;
 		if (netlink_add_setelems(ctx, &set->handle, set->init) < 0)
 			return -1;
diff --git a/src/segtree.c b/src/segtree.c
index 060951c..429d35e 100644
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
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
