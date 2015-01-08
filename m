From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: modify pr_debug() to use printf and introduce to pr_gmp_debug()
Date: Thu,  8 Jan 2015 13:56:06 +0100
Message-ID: <1420721766-12130-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57643 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbbAHMx0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:53:26 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Modify pr_debug() to use printf so we get debugging traces for
proto-ctx with --with-mini-gmp is enabled.

Add pr_gmp_debug(), this is disabled with --with-mini-gmp since it
relies on the gmp_printf(), which is not available in the mini-gmp
implementation.

Suggested by Patrick.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/utils.h |   10 ++++++++--
 src/segtree.c   |   22 +++++++++++-----------
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index dcefc6b..397c197 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -13,12 +13,18 @@
 
 #define BITS_PER_BYTE	8
 
-#if defined(DEBUG) && defined(HAVE_LIBGMP)
-#define pr_debug(fmt, arg...) gmp_printf(fmt, ##arg)
+#if defined(DEBUG)
+#define pr_debug(fmt, arg...) printf(fmt, ##arg)
 #else
 #define pr_debug(fmt, arg...) ({ if (false) {}; 0; })
 #endif
 
+#if defined(DEBUG) && defined(HAVE_LIBGMP)
+#define pr_gmp_debug(fmt, arg...) gmp_printf(fmt, ##arg)
+#else
+#define pr_gmp_debug(fmt, arg...) ({ if (false) {}; 0; })
+#endif
+
 #define __fmtstring(x, y)	__attribute__((format(printf, x, y)))
 #if 0
 #define __gmp_fmtstring(x, y)	__fmtstring(x, y)
diff --git a/src/segtree.c b/src/segtree.c
index 753d8b8..65221e9 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -190,7 +190,7 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 	rei = ei_lookup(tree, new->right);
 
 	if (segtree_debug())
-		pr_debug("insert: [%Zx %Zx]\n", new->left, new->right);
+		pr_gmp_debug("insert: [%Zx %Zx]\n", new->left, new->right);
 
 	if (lei != NULL && rei != NULL && lei == rei) {
 		/*
@@ -200,7 +200,7 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 		 * [lei_left, new_left) and (new_right, rei_right]
 		 */
 		if (segtree_debug())
-			pr_debug("split [%Zx %Zx]\n", lei->left, lei->right);
+			pr_gmp_debug("split [%Zx %Zx]\n", lei->left, lei->right);
 
 		ei_remove(tree, lei);
 
@@ -220,8 +220,8 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 			 * [lei_left, new_left)[new_left, new_right]
 			 */
 			if (segtree_debug()) {
-				pr_debug("adjust left [%Zx %Zx]\n",
-					 lei->left, lei->right);
+				pr_gmp_debug("adjust left [%Zx %Zx]\n",
+					     lei->left, lei->right);
 			}
 
 			mpz_sub_ui(lei->right, new->left, 1);
@@ -238,8 +238,8 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 			 * [new_left, new_right](new_right, rei_right]
 			 */
 			if (segtree_debug()) {
-				pr_debug("adjust right [%Zx %Zx]\n",
-					 rei->left, rei->right);
+				pr_gmp_debug("adjust right [%Zx %Zx]\n",
+					     rei->left, rei->right);
 			}
 
 			mpz_add_ui(rei->left, new->right, 1);
@@ -358,7 +358,7 @@ static void segtree_linearize(struct list_head *list, struct seg_tree *tree)
 	 */
 	rb_for_each_entry_safe(ei, node, next, &tree->root, rb_node) {
 		if (segtree_debug())
-			pr_debug("iter: [%Zx %Zx]\n", ei->left, ei->right);
+			pr_gmp_debug("iter: [%Zx %Zx]\n", ei->left, ei->right);
 
 		if (prev == NULL) {
 			/*
@@ -443,9 +443,9 @@ int set_to_intervals(struct list_head *errs, struct set *set)
 
 	list_for_each_entry_safe(ei, next, &list, list) {
 		if (segtree_debug()) {
-			pr_debug("list: [%.*Zx %.*Zx]\n",
-				 2 * tree.keylen / BITS_PER_BYTE, ei->left,
-				 2 * tree.keylen / BITS_PER_BYTE, ei->right);
+			pr_gmp_debug("list: [%.*Zx %.*Zx]\n",
+				     2 * tree.keylen / BITS_PER_BYTE, ei->left,
+				     2 * tree.keylen / BITS_PER_BYTE, ei->right);
 		}
 		set_insert_interval(set->init, &tree, ei);
 		ei_destroy(ei);
@@ -453,7 +453,7 @@ int set_to_intervals(struct list_head *errs, struct set *set)
 
 	if (segtree_debug()) {
 		expr_print(set->init);
-		pr_debug("\n");
+		pr_gmp_debug("\n");
 	}
 	return 0;
 }
-- 
1.7.10.4

