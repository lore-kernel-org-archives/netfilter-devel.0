From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] segtree: add new segtree debugging option
Date: Wed, 15 Jan 2014 13:25:04 +0100
Message-ID: <1389788704-21079-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39301 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaAOM2G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:28:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, nft displays the debugging information if it's compiled with
--enable-debug (which seems a good idea) and when intervals are used
in maps. Add a new option to enable debugging to segtree, so we only
get this information when explicitly requested.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
We need this in master to avoid inconditional display of the
debugging information when --enable-debug is passed at configuration
/ compilation time. I'm aware this patch conflicts with next-3.14,
that conflict should be easy to resolve.

 include/nftables.h |    1 +
 src/main.c         |    6 +++++-
 src/segtree.c      |   43 +++++++++++++++++++++++++++++++++----------
 3 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 12f3c49..f989161 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -17,6 +17,7 @@ enum debug_level {
 	DEBUG_PARSER		= 0x2,
 	DEBUG_EVALUATION	= 0x4,
 	DEBUG_NETLINK		= 0x8,
+	DEBUG_SEGTREE		= 0x10,
 };
 
 #define INCLUDE_PATHS_MAX	16
diff --git a/src/main.c b/src/main.c
index e8be423..d78eea7 100644
--- a/src/main.c
+++ b/src/main.c
@@ -111,7 +111,7 @@ static void show_help(const char *name)
 "  -a/--handle			Output rule handle.\n"
 "  -I/--includepath <directory>	Add <directory> to the paths searched for include files.\n"
 #ifdef DEBUG
-"  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, all)\n"
+"  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, segtree, all)\n"
 #endif
 "\n",
 	name);
@@ -139,6 +139,10 @@ static const struct {
 		.level		= DEBUG_NETLINK,
 	},
 	{
+		.name		= "segtree",
+		.level		= DEBUG_SEGTREE,
+	},
+	{
 		.name		= "all",
 		.level		= ~0,
 	},
diff --git a/src/segtree.c b/src/segtree.c
index 356a8b7..5426e24 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -157,6 +157,15 @@ static void __ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 	rb_insert_color(&new->rb_node, &tree->root);
 }
 
+static bool segtree_debug(void)
+{
+#ifdef DEBUG
+	if (debug_level & DEBUG_SEGTREE)
+		return true;
+#endif
+	return false;
+}
+
 /**
  * ei_insert - insert an elementary interval into the tree
  *
@@ -180,7 +189,8 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 	lei = ei_lookup(tree, new->left);
 	rei = ei_lookup(tree, new->right);
 
-	pr_debug("insert: [%Zx %Zx]\n", new->left, new->right);
+	if (segtree_debug())
+		pr_debug("insert: [%Zx %Zx]\n", new->left, new->right);
 
 	if (lei != NULL && rei != NULL && lei == rei) {
 		/*
@@ -189,7 +199,8 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 		 *
 		 * [lei_left, new_left) and (new_right, rei_right]
 		 */
-		pr_debug("split [%Zx %Zx]\n", lei->left, lei->right);
+		if (segtree_debug())
+			pr_debug("split [%Zx %Zx]\n", lei->left, lei->right);
 
 		ei_remove(tree, lei);
 
@@ -208,7 +219,10 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 			 *
 			 * [lei_left, new_left)[new_left, new_right]
 			 */
-			pr_debug("adjust left [%Zx %Zx]\n", lei->left, lei->right);
+			if (segtree_debug()) {
+				pr_debug("adjust left [%Zx %Zx]\n",
+					 lei->left, lei->right);
+			}
 
 			mpz_sub_ui(lei->right, new->left, 1);
 			mpz_sub(lei->size, lei->right, lei->left);
@@ -223,7 +237,10 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 			 *
 			 * [new_left, new_right](new_right, rei_right]
 			 */
-			pr_debug("adjust right [%Zx %Zx]\n", rei->left, rei->right);
+			if (segtree_debug()) {
+				pr_debug("adjust right [%Zx %Zx]\n",
+					 rei->left, rei->right);
+			}
 
 			mpz_add_ui(rei->left, new->right, 1);
 			mpz_sub(rei->size, rei->right, rei->left);
@@ -350,7 +367,7 @@ static void set_to_segtree(struct expr *set, struct seg_tree *tree)
 	for (n = 0; n < set->size; n++) {
 		if (n < set->size - 1 &&
 		    interval_conflict(intervals[n], intervals[n+1]))
-			printf("conflict\n");
+			pr_debug("conflict\n");
 		ei_insert(tree, intervals[n]);
 	}
 
@@ -371,7 +388,8 @@ static void segtree_linearize(struct list_head *list, struct seg_tree *tree)
 	 * Convert the tree of open intervals to half-closed map expressions.
 	 */
 	rb_for_each_entry_safe(ei, node, next, &tree->root, rb_node) {
-		pr_debug("iter: [%Zx %Zx]\n", ei->left, ei->right);
+		if (segtree_debug())
+			pr_debug("iter: [%Zx %Zx]\n", ei->left, ei->right);
 
 		if (prev == NULL) {
 			/*
@@ -454,14 +472,19 @@ void set_to_intervals(struct set *set)
 	segtree_linearize(&list, &tree);
 
 	list_for_each_entry_safe(ei, next, &list, list) {
-		pr_debug("list: [%.*Zx %.*Zx]\n",
-			 2 * tree.keylen / BITS_PER_BYTE, ei->left,
-			 2 * tree.keylen / BITS_PER_BYTE, ei->right);
+		if (segtree_debug()) {
+			pr_debug("list: [%.*Zx %.*Zx]\n",
+				 2 * tree.keylen / BITS_PER_BYTE, ei->left,
+				 2 * tree.keylen / BITS_PER_BYTE, ei->right);
+		}
 		set_insert_interval(set->init, &tree, ei);
 		ei_destroy(ei);
 	}
 
-	expr_print(set->init); printf("\n");
+	if (segtree_debug()) {
+		expr_print(set->init);
+		pr_debug("\n");
+	}
 }
 
 static bool range_is_prefix(const mpz_t range)
-- 
1.7.10.4

