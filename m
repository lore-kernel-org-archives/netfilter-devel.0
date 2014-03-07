From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/3] set: abort on interval conflicts
Date: Fri,  7 Mar 2014 10:28:41 +0100
Message-ID: <1394184521-11419-4-git-send-email-kaber@trash.net>
References: <1394184521-11419-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35819 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaCGJ2z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:28:55 -0500
In-Reply-To: <1394184521-11419-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We currently print a debug message (with debugging) and continue. Output
a proper error message and abort.

While at it, make sure we only report a conflict if there actually is one.
This is not the case similar actions, IOW in case of sets, never, in case
of maps, only if the mapping differs.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h |  2 +-
 src/rule.c           |  5 +++--
 src/segtree.c        | 21 +++++++++++++++------
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index d974131..edb6dc5 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -341,7 +341,7 @@ extern struct expr *concat_expr_alloc(const struct location *loc);
 extern struct expr *list_expr_alloc(const struct location *loc);
 
 extern struct expr *set_expr_alloc(const struct location *loc);
-extern void set_to_intervals(struct set *set);
+extern int set_to_intervals(struct list_head *msgs, struct set *set);
 
 extern struct expr *mapping_expr_alloc(const struct location *loc,
 				       struct expr *from, struct expr *to);
diff --git a/src/rule.c b/src/rule.c
index 0e04282..b719040 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -498,8 +498,9 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 	if (netlink_add_set(ctx, h, set) < 0)
 		return -1;
 	if (set->init != NULL) {
-		if (set->flags & SET_F_INTERVAL)
-			set_to_intervals(set);
+		if (set->flags & SET_F_INTERVAL &&
+		    set_to_intervals(ctx->msgs, set) < 0)
+			return -1;
 		if (do_add_setelems(ctx, &set->handle, set->init) < 0)
 			return -1;
 	}
diff --git a/src/segtree.c b/src/segtree.c
index 1a21c6c..c169f8d 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -329,13 +329,15 @@ static bool interval_conflict(const struct elementary_interval *e1,
 {
 	if (mpz_cmp(e1->left, e2->left) <= 0 &&
 	    mpz_cmp(e1->right, e2->left) >= 0 &&
-	    mpz_cmp(e1->size, e2->size) == 0)
+	    mpz_cmp(e1->size, e2->size) == 0 &&
+	    !expr_cmp(e1->expr->right, e2->expr->right))
 		return true;
 	else
 		return false;
 }
 
-static void set_to_segtree(struct expr *set, struct seg_tree *tree)
+static int set_to_segtree(struct list_head *msgs, struct expr *set,
+			  struct seg_tree *tree)
 {
 	struct elementary_interval *intervals[set->size];
 	struct elementary_interval *ei;
@@ -365,14 +367,19 @@ static void set_to_segtree(struct expr *set, struct seg_tree *tree)
 	 * Insert elements into tree
 	 */
 	for (n = 0; n < set->size; n++) {
-		if (n < set->size - 1 &&
+		if (set->set_flags & SET_F_MAP &&
+		    n < set->size - 1 &&
 		    interval_conflict(intervals[n], intervals[n+1]))
-			pr_debug("conflict\n");
+			return expr_binary_error(msgs,
+					intervals[n]->expr,
+					intervals[n+1]->expr,
+					"conflicting intervals specified");
 		ei_insert(tree, intervals[n]);
 	}
 
 	mpz_clear(high);
 	mpz_clear(low);
+	return 0;
 }
 
 static void segtree_linearize(struct list_head *list, struct seg_tree *tree)
@@ -461,14 +468,15 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 	compound_expr_add(set, expr);
 }
 
-void set_to_intervals(struct set *set)
+int set_to_intervals(struct list_head *errs, struct set *set)
 {
 	struct elementary_interval *ei, *next;
 	struct seg_tree tree;
 	LIST_HEAD(list);
 
 	seg_tree_init(&tree, set);
-	set_to_segtree(set->init, &tree);
+	if (set_to_segtree(errs, set->init, &tree) < 0)
+		return -1;
 	segtree_linearize(&list, &tree);
 
 	list_for_each_entry_safe(ei, next, &list, list) {
@@ -485,6 +493,7 @@ void set_to_intervals(struct set *set)
 		expr_print(set->init);
 		pr_debug("\n");
 	}
+	return 0;
 }
 
 static bool range_is_prefix(const mpz_t range)
-- 
1.8.5.3

