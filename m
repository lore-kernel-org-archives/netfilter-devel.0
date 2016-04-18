From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 6/7] segtree: special handling for the first non-matching segment
Date: Mon, 18 Apr 2016 20:14:34 +0200
Message-ID: <1461003275-2330-7-git-send-email-pablo@netfilter.org>
References: <1461003275-2330-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35456 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbcDRSO5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2016 14:14:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 79C9EC107F
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5DF859D0FC
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EF9F59D0F0
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:52 +0200 (CEST)
In-Reply-To: <1461003275-2330-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the first non-matching segment if the set is empty or if we are
deleting the element.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |  2 +-
 src/rule.c           |  4 ++--
 src/segtree.c        | 43 +++++++++++++++++++++++++++++++++++++------
 3 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 62a1e51..d44e804 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -365,7 +365,7 @@ extern struct expr *list_expr_alloc(const struct location *loc);
 
 extern struct expr *set_expr_alloc(const struct location *loc);
 extern int set_to_intervals(struct list_head *msgs, struct set *set,
-			    struct expr *init);
+			    struct expr *init, bool add);
 
 extern struct expr *mapping_expr_alloc(const struct location *loc,
 				       struct expr *from, struct expr *to);
diff --git a/src/rule.c b/src/rule.c
index e2f15ee..049104d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -867,7 +867,7 @@ static int __do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			     struct set *set, struct expr *expr)
 {
 	if (set->flags & SET_F_INTERVAL &&
-	    set_to_intervals(ctx->msgs, set, expr) < 0)
+	    set_to_intervals(ctx->msgs, set, expr, true) < 0)
 		return -1;
 
 	if (netlink_add_setelems(ctx, h, expr) < 0)
@@ -984,7 +984,7 @@ static int do_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	set = set_lookup(table, h->set);
 
 	if (set->flags & SET_F_INTERVAL &&
-	    set_to_intervals(ctx->msgs, set, expr) < 0)
+	    set_to_intervals(ctx->msgs, set, expr, false) < 0)
 		return -1;
 
 	if (netlink_delete_setelems(ctx, h, expr) < 0)
diff --git a/src/segtree.c b/src/segtree.c
index c0a8c28..617fabc 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -345,10 +345,37 @@ static int set_to_segtree(struct list_head *msgs, struct expr *set,
 	return 0;
 }
 
-static void segtree_linearize(struct list_head *list, struct seg_tree *tree)
+static bool segtree_needs_first_segment(const struct set *set,
+					const struct expr *init, bool add)
 {
-	struct rb_node *node, *next;
+	if (add) {
+		/* If we're adding the first element to the set, we have to
+		 * include the first segment too. In case of anonymous sets,
+		 * we always have to add the first non-matching segment.
+		 */
+		if ((set->flags & SET_F_ANONYMOUS) ||
+		    (set->init && set->init->size == 0))
+			return true;
+	} else {
+		/* If the set is empty after the removal, we have to
+		 * remove the first non-matching segment too.
+		 */
+		if (set->init && set->init->size - init->size == 0)
+			return true;
+	}
+	/* This is an update for a set that already contains elements, so don't
+	 * add the first non-matching elements otherwise we hit EEXIST.
+	 */
+	return false;
+}
+
+static void segtree_linearize(struct list_head *list, const struct set *set,
+			      const struct expr *init, struct seg_tree *tree,
+			      bool add)
+{
+	bool needs_first_segment = segtree_needs_first_segment(set, init, add);
 	struct elementary_interval *ei, *nei, *prev = NULL;
+	struct rb_node *node, *next;
 	mpz_t p, q;
 
 	mpz_init2(p, tree->keylen);
@@ -366,7 +393,7 @@ static void segtree_linearize(struct list_head *list, struct seg_tree *tree)
 			 * If the first segment doesn't begin at zero, insert a
 			 * non-matching segment to cover [0, first_left).
 			 */
-			if (mpz_cmp_ui(ei->left, 0)) {
+			if (needs_first_segment && mpz_cmp_ui(ei->left, 0)) {
 				mpz_set_ui(p, 0);
 				mpz_sub_ui(q, ei->left, 1);
 				nei = ei_alloc(p, q, NULL, EI_F_INTERVAL_END);
@@ -383,7 +410,10 @@ static void segtree_linearize(struct list_head *list, struct seg_tree *tree)
 				mpz_sub_ui(q, ei->left, 1);
 				nei = ei_alloc(p, q, NULL, EI_F_INTERVAL_END);
 				list_add_tail(&nei->list, list);
-			} else if (ei->expr->ops->type != EXPR_MAPPING) {
+			} else if (add && ei->expr->ops->type != EXPR_MAPPING) {
+				/* Merge contiguous segments only in case of
+				 * new additions.
+				 */
 				mpz_set(prev->right, ei->right);
 				ei_remove(tree, ei);
 				ei_destroy(ei);
@@ -432,7 +462,8 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 	compound_expr_add(set, expr);
 }
 
-int set_to_intervals(struct list_head *errs, struct set *set, struct expr *init)
+int set_to_intervals(struct list_head *errs, struct set *set,
+		     struct expr *init, bool add)
 {
 	struct elementary_interval *ei, *next;
 	struct seg_tree tree;
@@ -441,7 +472,7 @@ int set_to_intervals(struct list_head *errs, struct set *set, struct expr *init)
 	seg_tree_init(&tree, set, init);
 	if (set_to_segtree(errs, init, &tree) < 0)
 		return -1;
-	segtree_linearize(&list, &tree);
+	segtree_linearize(&list, set, init, &tree, add);
 
 	list_for_each_entry_safe(ei, next, &list, list) {
 		if (segtree_debug()) {
-- 
2.1.4

