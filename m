From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: rename pr_debug() to pr_gmp_debug() and use printf() whenever possible
Date: Thu,  8 Jan 2015 13:38:58 +0100
Message-ID: <1420720738-4953-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52409 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756534AbbAHMgW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:36:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rename pr_debug() to pr_gmp_debug() so the new function name reminds
us the explicit dependency with libgmp, as suggested by Patrick.

Moreover, use printf() instead of pr_debug() if no mpz_t types are
used, so we get debugging information for proto-ctx as well.

pr_gmp_debug() is disabled with --with-mini-gmp since it relies on the
gmp_printf(), which is not available in the mini-gmp implementation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/utils.h           |    4 ++--
 src/netlink_delinearize.c |    2 --
 src/proto.c               |   14 +++++++-------
 src/segtree.c             |   14 +++++++-------
 4 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index dcefc6b..afe468c 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -14,9 +14,9 @@
 #define BITS_PER_BYTE	8
 
 #if defined(DEBUG) && defined(HAVE_LIBGMP)
-#define pr_debug(fmt, arg...) gmp_printf(fmt, ##arg)
+#define pr_gmp_debug(fmt, arg...) gmp_printf(fmt, ##arg)
 #else
-#define pr_debug(fmt, arg...) ({ if (false) {}; 0; })
+#define pr_gmp_debug(fmt, arg...) ({ if (false) {}; 0; })
 #endif
 
 #define __fmtstring(x, y)	__attribute__((format(printf, x, y)))
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e9a04dd..b34d586 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -915,8 +915,6 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 {
 	struct expr *expr = *exprp, *i;
 
-	//pr_debug("%s len %u\n", expr->ops->name, expr->len);
-
 	switch (expr->ops->type) {
 	case EXPR_MAP:
 		expr_postprocess(ctx, stmt, &expr->map);
diff --git a/src/proto.c b/src/proto.c
index 7dc7b3e..6a12ee8 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -137,15 +137,15 @@ static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base)
 	if (!(debug_level & DEBUG_PROTO_CTX))
 		return;
 
-	pr_debug("update %s protocol context:\n", proto_base_names[base]);
+	printf("update %s protocol context:\n", proto_base_names[base]);
 	for (i = PROTO_BASE_LL_HDR; i <= PROTO_BASE_MAX; i++) {
-		pr_debug(" %-20s: %s%s\n",
-			 proto_base_names[i],
-			 ctx->protocol[i].desc ? ctx->protocol[i].desc->name :
-						 "none",
-			 i == base ? " <-" : "");
+		printf(" %-20s: %s%s\n",
+		       proto_base_names[i],
+		       ctx->protocol[i].desc ? ctx->protocol[i].desc->name :
+					       "none",
+		       i == base ? " <-" : "");
 	}
-	pr_debug("\n");
+	printf("\n");
 #endif
 }
 
diff --git a/src/segtree.c b/src/segtree.c
index 753d8b8..a72e6b8 100644
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
 
@@ -220,7 +220,7 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 			 * [lei_left, new_left)[new_left, new_right]
 			 */
 			if (segtree_debug()) {
-				pr_debug("adjust left [%Zx %Zx]\n",
+				pr_gmp_debug("adjust left [%Zx %Zx]\n",
 					 lei->left, lei->right);
 			}
 
@@ -238,7 +238,7 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 			 * [new_left, new_right](new_right, rei_right]
 			 */
 			if (segtree_debug()) {
-				pr_debug("adjust right [%Zx %Zx]\n",
+				pr_gmp_debug("adjust right [%Zx %Zx]\n",
 					 rei->left, rei->right);
 			}
 
@@ -358,7 +358,7 @@ static void segtree_linearize(struct list_head *list, struct seg_tree *tree)
 	 */
 	rb_for_each_entry_safe(ei, node, next, &tree->root, rb_node) {
 		if (segtree_debug())
-			pr_debug("iter: [%Zx %Zx]\n", ei->left, ei->right);
+			pr_gmp_debug("iter: [%Zx %Zx]\n", ei->left, ei->right);
 
 		if (prev == NULL) {
 			/*
@@ -443,7 +443,7 @@ int set_to_intervals(struct list_head *errs, struct set *set)
 
 	list_for_each_entry_safe(ei, next, &list, list) {
 		if (segtree_debug()) {
-			pr_debug("list: [%.*Zx %.*Zx]\n",
+			pr_gmp_debug("list: [%.*Zx %.*Zx]\n",
 				 2 * tree.keylen / BITS_PER_BYTE, ei->left,
 				 2 * tree.keylen / BITS_PER_BYTE, ei->right);
 		}
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

