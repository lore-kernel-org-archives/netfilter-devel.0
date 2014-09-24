From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] expr: make range_low()/range_high() usable outside of segtree
Date: Wed, 24 Sep 2014 14:20:30 +0200
Message-ID: <1411561232-20204-2-git-send-email-kaber@trash.net>
References: <1411561232-20204-1-git-send-email-kaber@trash.net>
Cc: eric@regit.org, arturo.borrero.glez@gmail.com,
	netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56691 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaIXMUg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:20:36 -0400
In-Reply-To: <1411561232-20204-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Their functionality is also needed for set descriptions, move the functions
to expressions.c and give them a more suitable name for global functions.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h |  4 ++++
 src/expression.c     | 38 ++++++++++++++++++++++++++++++++++++++
 src/segtree.c        | 42 ++----------------------------------------
 3 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index edb6dc5..59fa5f3 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -351,4 +351,8 @@ extern struct expr *map_expr_alloc(const struct location *loc,
 extern struct expr *set_ref_expr_alloc(const struct location *loc,
 				       struct set *set);
 
+
+extern void range_expr_value_low(mpz_t rop, const struct expr *expr);
+extern void range_expr_value_high(mpz_t rop, const struct expr *expr);
+
 #endif /* NFTABLES_EXPRESSION_H */
diff --git a/src/expression.c b/src/expression.c
index fa14d99..8ba2e8a 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -879,3 +879,41 @@ struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
 	expr->flags |= EXPR_F_CONSTANT;
 	return expr;
 }
+
+void range_expr_value_low(mpz_t rop, const struct expr *expr)
+{
+	switch (expr->ops->type) {
+	case EXPR_VALUE:
+		return mpz_set(rop, expr->value);
+	case EXPR_PREFIX:
+		return range_expr_value_low(rop, expr->prefix);
+	case EXPR_RANGE:
+		return range_expr_value_low(rop, expr->left);
+	case EXPR_MAPPING:
+		return range_expr_value_low(rop, expr->left);
+	default:
+		BUG("invalid range expression type %s\n", expr->ops->name);
+	}
+}
+
+void range_expr_value_high(mpz_t rop, const struct expr *expr)
+{
+	mpz_t tmp;
+
+	switch (expr->ops->type) {
+	case EXPR_VALUE:
+		return mpz_set(rop, expr->value);
+	case EXPR_PREFIX:
+		range_expr_value_low(rop, expr->prefix);
+		mpz_init_bitmask(tmp, expr->len - expr->prefix_len);
+		mpz_add(rop, rop, tmp);
+		mpz_clear(tmp);
+		return;
+	case EXPR_RANGE:
+		return range_expr_value_high(rop, expr->right);
+	case EXPR_MAPPING:
+		return range_expr_value_high(rop, expr->left);
+	default:
+		BUG("invalid range expression type %s\n", expr->ops->name);
+	}
+}
diff --git a/src/segtree.c b/src/segtree.c
index 1785f64..753d8b8 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -256,44 +256,6 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
 	mpz_clear(p);
 }
 
-static void range_low(mpz_t rop, struct expr *expr)
-{
-	switch (expr->ops->type) {
-	case EXPR_VALUE:
-		return mpz_set(rop, expr->value);
-	case EXPR_PREFIX:
-		return range_low(rop, expr->prefix);
-	case EXPR_RANGE:
-		return range_low(rop, expr->left);
-	case EXPR_MAPPING:
-		return range_low(rop, expr->left);
-	default:
-		BUG("invalid range expression type %s\n", expr->ops->name);
-	}
-}
-
-static void range_high(mpz_t rop, const struct expr *expr)
-{
-	mpz_t tmp;
-
-	switch (expr->ops->type) {
-	case EXPR_VALUE:
-		return mpz_set(rop, expr->value);
-	case EXPR_PREFIX:
-		range_low(rop, expr->prefix);
-		mpz_init_bitmask(tmp, expr->len - expr->prefix_len);
-		mpz_add(rop, rop, tmp);
-		mpz_clear(tmp);
-		return;
-	case EXPR_RANGE:
-		return range_high(rop, expr->right);
-	case EXPR_MAPPING:
-		return range_high(rop, expr->left);
-	default:
-		BUG("invalid range expression type %s\n", expr->ops->name);
-	}
-}
-
 /*
  * Sort intervals according to their priority, which is defined inversely to
  * their size.
@@ -353,8 +315,8 @@ static int set_to_segtree(struct list_head *msgs, struct expr *set,
 	 */
 	n = 0;
 	list_for_each_entry_safe(i, next, &set->expressions, list) {
-		range_low(low, i);
-		range_high(high, i);
+		range_expr_value_low(low, i);
+		range_expr_value_high(high, i);
 		ei = ei_alloc(low, high, i, 0);
 		intervals[n++] = ei;
 
-- 
1.9.3

