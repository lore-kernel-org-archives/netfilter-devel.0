From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/5, nft] rule: allow dynamic updates for intervals in set declarations
Date: Tue, 19 Jan 2016 18:52:56 +0100
Message-ID: <1453225976-23749-5-git-send-email-pablo@netfilter.org>
References: <1453225976-23749-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, ast@fiberby.dk
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56878 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741AbcASRxX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2016 12:53:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0794223166F
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ED048DA809
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A33A4DA7E0
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:18 +0100 (CET)
In-Reply-To: <1453225976-23749-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For example:

 # nft add table test
 # nft add set test myset { type ipv4_addr\; flags interval\; }
 # nft add element test myset { 1.2.3.0/24 }
 ... later on ...
 # nft add element test myset { 1.2.4.0/24 }

Then the listing shows:

 set myset2 {
         type ipv4_addr
         flags interval
         elements = { 1.2.3.0/24, 1.2.4.0/24}
 }

If the set contains at least one element, this skips the non-matching
segment 0.0.0.0, otherwise the kernel returns -EEXIST when updating the
extsing set definition with (more) new elements.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=994
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c    | 13 ++++++++++++-
 src/segtree.c |  9 ++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 8549c2b..a32b697 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -860,10 +860,21 @@ static int do_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 }
 
 static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			   const struct expr *expr)
+			   struct expr *expr)
 {
+	struct table *table;
+	struct set *set;
+
+	table = table_lookup(h);
+	set = set_lookup(table, h->set);
+
+	if (set->flags & SET_F_INTERVAL &&
+	    set_to_intervals(ctx->msgs, set, expr) < 0)
+		return -1;
+
 	if (netlink_add_setelems(ctx, h, expr) < 0)
 		return -1;
+
 	return 0;
 }
 
diff --git a/src/segtree.c b/src/segtree.c
index 5b1cd29..c05eead 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -345,7 +345,8 @@ static int set_to_segtree(struct list_head *msgs, struct expr *set,
 	return 0;
 }
 
-static void segtree_linearize(struct list_head *list, struct seg_tree *tree)
+static void segtree_linearize(struct list_head *list, struct seg_tree *tree,
+			      bool needs_first_segment)
 {
 	struct rb_node *node, *next;
 	struct elementary_interval *ei, *nei, *prev = NULL;
@@ -366,7 +367,7 @@ static void segtree_linearize(struct list_head *list, struct seg_tree *tree)
 			 * If the first segment doesn't begin at zero, insert a
 			 * non-matching segment to cover [0, first_left).
 			 */
-			if (mpz_cmp_ui(ei->left, 0)) {
+			if (needs_first_segment && mpz_cmp_ui(ei->left, 0)) {
 				mpz_set_ui(p, 0);
 				mpz_sub_ui(q, ei->left, 1);
 				nei = ei_alloc(p, q, NULL, EI_F_INTERVAL_END);
@@ -441,7 +442,9 @@ int set_to_intervals(struct list_head *errs, struct set *set, struct expr *init)
 	seg_tree_init(&tree, set, init);
 	if (set_to_segtree(errs, init, &tree) < 0)
 		return -1;
-	segtree_linearize(&list, &tree);
+	segtree_linearize(&list, &tree,
+			  (set->flags & SET_F_ANONYMOUS) ?
+				true : set->init && set->init->size == 0);
 
 	list_for_each_entry_safe(ei, next, &list, list) {
 		if (segtree_debug()) {
-- 
2.1.4

