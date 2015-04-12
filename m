From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 06/10] expr: add set_elem_expr as container for set element attributes
Date: Sun, 12 Apr 2015 13:16:14 +0100
Message-ID: <1428840978-27226-7-git-send-email-kaber@trash.net>
References: <1428840978-27226-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58909 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbbDLMQ0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 08:16:26 -0400
In-Reply-To: <1428840978-27226-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a new expression type "set_elem_expr" that is used as container for
the key in order to attach different attributes, such as timeout values,
to the key.

The expression hierarchy is as follows:

Sets:

    elem
     |
    key

Maps:

   mapping
   /      \
 elem    data
  |
 key

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h      |  8 +++++++
 src/evaluate.c            | 15 ++++++++++++++
 src/expression.c          | 31 +++++++++++++++++++++++++++
 src/netlink.c             | 53 +++++++++++++++++++++++++++--------------------
 src/netlink_delinearize.c |  3 +++
 src/netlink_linearize.c   |  2 ++
 src/parser_bison.y        | 19 ++++++++++++-----
 src/segtree.c             |  8 +++++--
 8 files changed, 109 insertions(+), 30 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 7477c3e..d481f28 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -27,6 +27,7 @@
  * @EXPR_LIST:		list of expressions
  * @EXPR_SET:		literal set
  * @EXPR_SET_REF:	set reference
+ * @EXPR_SET_ELEM:	set element
  * @EXPR_MAPPING:	a single mapping (key : value)
  * @EXPR_MAP:		map operation (expr map { EXPR_MAPPING, ... })
  * @EXPR_UNARY:		byteorder conversion, generated during evaluation
@@ -48,6 +49,7 @@ enum expr_types {
 	EXPR_LIST,
 	EXPR_SET,
 	EXPR_SET_REF,
+	EXPR_SET_ELEM,
 	EXPR_MAPPING,
 	EXPR_MAP,
 	EXPR_UNARY,
@@ -230,6 +232,10 @@ struct expr {
 			struct set		*set;
 		};
 		struct {
+			/* EXPR_SET_ELEM */
+			struct expr		*key;
+		};
+		struct {
 			/* EXPR_UNARY */
 			struct expr		*arg;
 		};
@@ -363,6 +369,8 @@ extern struct expr *map_expr_alloc(const struct location *loc,
 extern struct expr *set_ref_expr_alloc(const struct location *loc,
 				       struct set *set);
 
+extern struct expr *set_elem_expr_alloc(const struct location *loc,
+					struct expr *key);
 
 extern void range_expr_value_low(mpz_t rop, const struct expr *expr);
 extern void range_expr_value_high(mpz_t rop, const struct expr *expr);
diff --git a/src/evaluate.c b/src/evaluate.c
index 7ecb793..37db107 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -675,6 +675,19 @@ static int expr_evaluate_list(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
+{
+	struct expr *elem = *expr;
+
+	if (expr_evaluate(ctx, &elem->key) < 0)
+		return -1;
+
+	elem->dtype = elem->key->dtype;
+	elem->len   = elem->key->len;
+	elem->flags = elem->key->flags;
+	return 0;
+}
+
 static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *set = *expr, *i, *next;
@@ -1100,6 +1113,8 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return expr_evaluate_list(ctx, expr);
 	case EXPR_SET:
 		return expr_evaluate_set(ctx, expr);
+	case EXPR_SET_ELEM:
+		return expr_evaluate_set_elem(ctx, expr);
 	case EXPR_MAP:
 		return expr_evaluate_map(ctx, expr);
 	case EXPR_MAPPING:
diff --git a/src/expression.c b/src/expression.c
index 5b848da..6789396 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -886,6 +886,33 @@ struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
 	return expr;
 }
 
+static void set_elem_expr_print(const struct expr *expr)
+{
+	expr_print(expr->key);
+}
+
+static void set_elem_expr_destroy(struct expr *expr)
+{
+	expr_free(expr->key);
+}
+
+static const struct expr_ops set_elem_expr_ops = {
+	.type		= EXPR_SET_ELEM,
+	.name		= "set element",
+	.print		= set_elem_expr_print,
+	.destroy	= set_elem_expr_destroy,
+};
+
+struct expr *set_elem_expr_alloc(const struct location *loc, struct expr *key)
+{
+	struct expr *expr;
+
+	expr = expr_alloc(loc, &set_elem_expr_ops, key->dtype,
+			  key->byteorder, key->len);
+	expr->key = key;
+	return expr;
+}
+
 void range_expr_value_low(mpz_t rop, const struct expr *expr)
 {
 	switch (expr->ops->type) {
@@ -897,6 +924,8 @@ void range_expr_value_low(mpz_t rop, const struct expr *expr)
 		return range_expr_value_low(rop, expr->left);
 	case EXPR_MAPPING:
 		return range_expr_value_low(rop, expr->left);
+	case EXPR_SET_ELEM:
+		return range_expr_value_low(rop, expr->key);
 	default:
 		BUG("invalid range expression type %s\n", expr->ops->name);
 	}
@@ -919,6 +948,8 @@ void range_expr_value_high(mpz_t rop, const struct expr *expr)
 		return range_expr_value_high(rop, expr->right);
 	case EXPR_MAPPING:
 		return range_expr_value_high(rop, expr->left);
+	case EXPR_SET_ELEM:
+		return range_expr_value_high(rop, expr->key);
 	default:
 		BUG("invalid range expression type %s\n", expr->ops->name);
 	}
diff --git a/src/netlink.c b/src/netlink.c
index f6fd065..75fbb25 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -205,6 +205,7 @@ struct nft_set *alloc_nft_set(const struct handle *h)
 
 static struct nft_set_elem *alloc_nft_setelem(const struct expr *expr)
 {
+	const struct expr *elem, *key, *data;
 	struct nft_set_elem *nlse;
 	struct nft_data_linearize nld;
 
@@ -212,24 +213,28 @@ static struct nft_set_elem *alloc_nft_setelem(const struct expr *expr)
 	if (nlse == NULL)
 		memory_allocation_error();
 
-	if (expr->ops->type == EXPR_VALUE ||
-	    expr->flags & EXPR_F_INTERVAL_END) {
-		netlink_gen_data(expr, &nld);
-		nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_KEY,
-				      &nld.value, nld.len);
+	data = NULL;
+	if (expr->ops->type == EXPR_MAPPING) {
+		elem = expr->left;
+		if (!(expr->flags & EXPR_F_INTERVAL_END))
+			data = expr->right;
 	} else {
-		assert(expr->ops->type == EXPR_MAPPING);
-		netlink_gen_data(expr->left, &nld);
-		nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_KEY,
-				      &nld.value, nld.len);
-		netlink_gen_data(expr->right, &nld);
-		switch (expr->right->ops->type) {
+		elem = expr;
+	}
+	key = elem->key;
+
+	netlink_gen_data(key, &nld);
+	nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_KEY, &nld.value, nld.len);
+
+	if (data != NULL) {
+		netlink_gen_data(data, &nld);
+		switch (data->ops->type) {
 		case EXPR_VERDICT:
 			nft_set_elem_attr_set_u32(nlse, NFT_SET_ELEM_ATTR_VERDICT,
-						  expr->right->verdict);
-			if (expr->chain != NULL)
+						  data->verdict);
+			if (data->chain != NULL)
 				nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_CHAIN,
-						nld.chain, strlen(nld.chain));
+						      nld.chain, strlen(nld.chain));
 			break;
 		case EXPR_VALUE:
 			nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_DATA,
@@ -1089,7 +1094,7 @@ static int netlink_delinearize_setelem(struct nft_set_elem *nlse,
 				       struct set *set)
 {
 	struct nft_data_delinearize nld;
-	struct expr *expr, *data;
+	struct expr *expr, *key, *data;
 	uint32_t flags = 0;
 
 	nld.value =
@@ -1097,17 +1102,19 @@ static int netlink_delinearize_setelem(struct nft_set_elem *nlse,
 	if (nft_set_elem_attr_is_set(nlse, NFT_SET_ELEM_ATTR_FLAGS))
 		flags = nft_set_elem_attr_get_u32(nlse, NFT_SET_ELEM_ATTR_FLAGS);
 
-	expr = netlink_alloc_value(&netlink_location, &nld);
-	expr->dtype	= set->keytype;
-	expr->byteorder	= set->keytype->byteorder;
+	key = netlink_alloc_value(&netlink_location, &nld);
+	key->dtype	= set->keytype;
+	key->byteorder	= set->keytype->byteorder;
 
 	if (!(set->flags & SET_F_INTERVAL) &&
-	    expr->byteorder == BYTEORDER_HOST_ENDIAN)
-		mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
+	    key->byteorder == BYTEORDER_HOST_ENDIAN)
+		mpz_switch_byteorder(key->value, key->len / BITS_PER_BYTE);
+
+	if (key->dtype->basetype != NULL &&
+	    key->dtype->basetype->type == TYPE_BITMASK)
+		key = bitmask_expr_to_binops(key);
 
-	if (expr->dtype->basetype != NULL &&
-	    expr->dtype->basetype->type == TYPE_BITMASK)
-		expr = bitmask_expr_to_binops(expr);
+	expr = set_elem_expr_alloc(&netlink_location, key);
 
 	if (flags & NFT_SET_ELEM_INTERVAL_END) {
 		expr->flags |= EXPR_F_INTERVAL_END;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ec1a964..c564a8a 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1033,6 +1033,9 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 		expr_postprocess(ctx, stmt, &expr->left);
 		expr_postprocess(ctx, stmt, &expr->right);
 		break;
+	case EXPR_SET_ELEM:
+		expr_postprocess(ctx, stmt, &expr->key);
+		break;
 	case EXPR_SET_REF:
 	case EXPR_EXTHDR:
 	case EXPR_META:
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 9bef67b..d1414c1 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -528,6 +528,8 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_meta(ctx, expr, dreg);
 	case EXPR_CT:
 		return netlink_gen_ct(ctx, expr, dreg);
+	case EXPR_SET_ELEM:
+		return netlink_gen_expr(ctx, expr->key, dreg);
 	default:
 		BUG("unknown expression type %s\n", expr->ops->name);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index c934533..9fbc590 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -484,8 +484,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <expr>			set_expr set_list_expr set_list_member_expr
 %destructor { expr_free($$); }	set_expr set_list_expr set_list_member_expr
-%type <expr>			set_lhs_expr set_rhs_expr
-%destructor { expr_free($$); }	set_lhs_expr set_rhs_expr
+%type <expr>			set_elem_expr set_elem_expr_alloc set_lhs_expr set_rhs_expr
+%destructor { expr_free($$); }	set_elem_expr set_elem_expr_alloc set_lhs_expr set_rhs_expr
 
 %type <expr>			expr initializer_expr
 %destructor { expr_free($$); }	expr initializer_expr
@@ -1299,7 +1299,7 @@ verdict_map_list_expr	:	verdict_map_list_member_expr
 			|	verdict_map_list_expr	COMMA	opt_newline
 			;
 
-verdict_map_list_member_expr:	opt_newline	set_lhs_expr	COLON	verdict_expr	opt_newline
+verdict_map_list_member_expr:	opt_newline	set_elem_expr	COLON	verdict_expr	opt_newline
 			{
 				$$ = mapping_expr_alloc(&@$, $2, $4);
 			}
@@ -1755,16 +1755,25 @@ set_list_member_expr	:	opt_newline	set_expr	opt_newline
 			{
 				$$ = $2;
 			}
-			|	opt_newline	set_lhs_expr	opt_newline
+			|	opt_newline	set_elem_expr	opt_newline
 			{
 				$$ = $2;
 			}
-			|	opt_newline	set_lhs_expr	COLON	set_rhs_expr	opt_newline
+			|	opt_newline	set_elem_expr	COLON	set_rhs_expr	opt_newline
 			{
 				$$ = mapping_expr_alloc(&@$, $2, $4);
 			}
 			;
 
+set_elem_expr		:	set_elem_expr_alloc
+			;
+
+set_elem_expr_alloc	:	set_lhs_expr
+			{
+				$$ = set_elem_expr_alloc(&@1, $1);
+			}
+			;
+
 set_lhs_expr		:	concat_expr
 			|	multiton_expr
 			;
diff --git a/src/segtree.c b/src/segtree.c
index 65221e9..060951c 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -419,6 +419,7 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 	expr = constant_expr_alloc(&internal_location, tree->keytype,
 				   tree->byteorder, tree->keylen, NULL);
 	mpz_set(expr->value, ei->left);
+	expr = set_elem_expr_alloc(&internal_location, expr);
 
 	if (ei->expr != NULL && ei->expr->ops->type == EXPR_MAPPING)
 		expr = mapping_expr_alloc(&ei->expr->location, expr,
@@ -473,9 +474,9 @@ extern void interval_map_decompose(struct expr *set);
 static struct expr *expr_value(struct expr *expr)
 {
 	if (expr->ops->type == EXPR_MAPPING)
-		return expr->left;
+		return expr->left->key;
 	else
-		return expr;
+		return expr->key;
 }
 
 static int expr_value_cmp(const void *p1, const void *p2)
@@ -565,6 +566,7 @@ void interval_map_decompose(struct expr *set)
 			mpz_set(tmp->value, range);
 
 			tmp = range_expr_alloc(&low->location, expr_value(low), tmp);
+			tmp = set_elem_expr_alloc(&low->location, tmp);
 			if (low->ops->type == EXPR_MAPPING)
 				tmp = mapping_expr_alloc(&tmp->location, tmp, low->right);
 
@@ -576,6 +578,7 @@ void interval_map_decompose(struct expr *set)
 			prefix_len = expr_value(i)->len - mpz_scan0(range, 0);
 			prefix = prefix_expr_alloc(&low->location, expr_value(low),
 						   prefix_len);
+			prefix = set_elem_expr_alloc(&low->location, prefix);
 			if (low->ops->type == EXPR_MAPPING)
 				prefix = mapping_expr_alloc(&low->location, prefix,
 							    low->right);
@@ -598,6 +601,7 @@ void interval_map_decompose(struct expr *set)
 		mpz_init_bitmask(i->value, i->len);
 
 		i = range_expr_alloc(&low->location, expr_value(low), i);
+		i = set_elem_expr_alloc(&low->location, i);
 		if (low->ops->type == EXPR_MAPPING)
 			i = mapping_expr_alloc(&i->location, i, low->right);
 
-- 
2.1.0

