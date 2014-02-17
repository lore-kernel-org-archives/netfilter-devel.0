From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/4] netlink_delinarize: convert *all* bitmask values into individual bit values
Date: Mon, 17 Feb 2014 17:20:51 +0000
Message-ID: <1392657652-9815-4-git-send-email-kaber@trash.net>
References: <1392657652-9815-1-git-send-email-kaber@trash.net>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51569 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBQRVA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:21:00 -0500
In-Reply-To: <1392657652-9815-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We're currently only converting bitmask types as direct argument to a
relational expression in the form of a flagcmp (expr & mask neq 0) back
into a list of bit values. This means expressions like:

tcp flags & (syn | ack) == syn | ack

won't be shown symbolically. Convert *all* bitmask values back to a sequence
of inclusive or expressions of the individual bits. In case of a flagcmp,
this sequence is further converted to a list (tcp flags syn,ack).

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h      |  6 +++++
 src/expression.c          | 58 +++++++++++++++++++++++++++++++++++++++++++++--
 src/netlink_delinearize.c | 54 +++++++++++++++++++++++++++++--------------
 3 files changed, 99 insertions(+), 19 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 5128a5b..ac6a4f4 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -316,6 +316,12 @@ extern struct expr *constant_expr_join(const struct expr *e1,
 				       const struct expr *e2);
 extern struct expr *constant_expr_splice(struct expr *expr, unsigned int len);
 
+extern struct expr *flag_expr_alloc(const struct location *loc,
+				    const struct datatype *dtype,
+				    enum byteorder byteorder,
+				    unsigned int len, unsigned long n);
+extern struct expr *bitmask_expr_to_binops(struct expr *expr);
+
 extern struct expr *prefix_expr_alloc(const struct location *loc,
 				      struct expr *expr,
 				      unsigned int prefix_len);
diff --git a/src/expression.c b/src/expression.c
index 6cc79b2..adaf6e7 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -13,6 +13,7 @@
 #include <stdio.h>
 #include <stdint.h>
 #include <string.h>
+#include <limits.h>
 
 #include <expression.h>
 #include <datatype.h>
@@ -302,6 +303,59 @@ struct expr *constant_expr_splice(struct expr *expr, unsigned int len)
 	return slice;
 }
 
+/*
+ * Allocate a constant expression with a single bit set at position n.
+ */
+struct expr *flag_expr_alloc(const struct location *loc,
+			     const struct datatype *dtype,
+			     enum byteorder byteorder,
+			     unsigned int len, unsigned long n)
+{
+	struct expr *expr;
+
+	assert(n < len);
+
+	expr = constant_expr_alloc(loc, dtype, byteorder, len, NULL);
+	mpz_set_ui(expr->value, 1);
+	mpz_lshift_ui(expr->value, n);
+
+	return expr;
+}
+
+/*
+ * Convert an expression of basetype TYPE_BITMASK into a series of inclusive
+ * OR binop expressions of the individual flag values.
+ */
+struct expr *bitmask_expr_to_binops(struct expr *expr)
+{
+	struct expr *binop, *flag;
+	unsigned long n;
+
+	assert(expr->ops->type == EXPR_VALUE);
+	assert(expr->dtype->basetype->type == TYPE_BITMASK);
+
+	n = mpz_popcount(expr->value);
+	if (n == 0 || n == 1)
+		return expr;
+
+	binop = NULL;
+	n = 0;
+	while ((n = mpz_scan1(expr->value, n)) != ULONG_MAX) {
+		flag = flag_expr_alloc(&expr->location, expr->dtype,
+				       expr->byteorder, expr->len, n);
+		if (binop != NULL)
+			binop = binop_expr_alloc(&expr->location,
+						 OP_OR, binop, flag);
+		else
+			binop = flag;
+
+		n++;
+	}
+
+	expr_free(expr);
+	return binop;
+}
+
 static void prefix_expr_print(const struct expr *expr)
 {
 	expr_print(expr->prefix);
@@ -467,8 +521,8 @@ struct expr *binop_expr_alloc(const struct location *loc, enum ops op,
 {
 	struct expr *expr;
 
-	expr = expr_alloc(loc, &binop_expr_ops, &invalid_type,
-			  BYTEORDER_INVALID, 0);
+	expr = expr_alloc(loc, &binop_expr_ops, left->dtype,
+			  left->byteorder, 0);
 	expr->left  = left;
 	expr->op    = op;
 	expr->right = right;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 6668308..645bf63 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -692,28 +692,43 @@ next:
 	return k;
 }
 
+/* Convert a series of inclusive OR expressions into a list */
+static struct expr *binop_tree_to_list(struct expr *list, struct expr *expr)
+{
+	if (expr->ops->type == EXPR_BINOP && expr->op == OP_OR) {
+		if (list == NULL)
+			list = list_expr_alloc(&expr->location);
+		list = binop_tree_to_list(list, expr->left);
+		list = binop_tree_to_list(list, expr->right);
+	} else {
+		if (list == NULL)
+			return expr_get(expr);
+		compound_expr_add(list, expr_get(expr));
+	}
+
+	return list;
+}
+
 static void relational_binop_postprocess(struct expr *expr)
 {
-	struct expr *binop = expr->left, *value = expr->right, *i;
-	unsigned long n;
+	struct expr *binop = expr->left, *value = expr->right;
 
 	if (binop->op == OP_AND && expr->op == OP_NEQ &&
-	    expr->right->dtype->basetype->type == TYPE_BITMASK) {
+	    value->dtype->basetype->type == TYPE_BITMASK &&
+	    !mpz_cmp_ui(value->value, 0)) {
+		/* Flag comparison: data & flags != 0
+		 *
+		 * Split the flags into a list of flag values and convert the
+		 * op to OP_FLAGCMP.
+		 */
 		expr_free(expr->right);
-		expr->right = list_expr_alloc(&binop->left->location);
-		n = 0;
-		while ((n = mpz_scan1(binop->right->value, n)) != ULONG_MAX) {
-			i = constant_expr_alloc(&binop->right->location,
-						binop->left->dtype,
-						binop->right->byteorder,
-						binop->right->len, NULL);
-			mpz_set_ui(i->value, 1);
-			mpz_lshift_ui(i->value, n);
-			compound_expr_add(expr->right, i);
-			n++;
-		}
-		expr->left = binop->left;
-		expr->op = OP_FLAGCMP;
+		expr_free(value);
+
+		expr->left  = expr_get(binop->left);
+		expr->right = binop_tree_to_list(NULL, binop->right);
+		expr->op    = OP_FLAGCMP;
+
+		expr_free(binop);
 	} else if ((binop->left->dtype->type == TYPE_IPADDR ||
 		    binop->left->dtype->type == TYPE_IP6ADDR) &&
 		    binop->op == OP_AND) {
@@ -811,6 +826,11 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 			mpz_clear(tmp);
 			expr->len = len;
 		}
+
+		if (expr->dtype->basetype != NULL &&
+		    expr->dtype->basetype->type == TYPE_BITMASK)
+			*exprp = bitmask_expr_to_binops(expr);
+
 		break;
 	case EXPR_RANGE:
 		expr_postprocess(ctx, stmt, &expr->left);
-- 
1.8.5.3

