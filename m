From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 8/9] netlink_delinearize: handle relational and lookup concat expressions
Date: Fri,  5 Jun 2015 15:42:50 +0200
Message-ID: <1433511771-4620-9-git-send-email-kaber@trash.net>
References: <1433511771-4620-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59948 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbbFENm4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 09:42:56 -0400
In-Reply-To: <1433511771-4620-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When the RHS length differs from the LHS length (which is only the
first expression), both expressions are assumed to be concat expressions.

The LHS concat expression is reconstructed from the available register
values, advancing by the number of registers required by the subexpressions'
register space, until the RHS length has been reached.

The RHS concat expression is reconstructed by splitting the data value
into multiple subexpressions based on the LHS concat expressions types.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink_delinearize.c | 113 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 104 insertions(+), 9 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 91da859..08fd580 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -104,6 +104,63 @@ static void netlink_release_registers(struct netlink_parse_ctx *ctx)
 		expr_free(ctx->registers[i]);
 }
 
+static struct expr *netlink_parse_concat_expr(struct netlink_parse_ctx *ctx,
+					      const struct location *loc,
+					      unsigned int reg,
+					      unsigned int len)
+{
+	struct expr *concat, *expr;
+
+	concat = concat_expr_alloc(loc);
+	while (len > 0) {
+		expr = netlink_get_register(ctx, loc, reg);
+		if (expr == NULL) {
+			netlink_error(ctx, loc,
+				      "Relational expression size mismatch");
+			goto err;
+		}
+		compound_expr_add(concat, expr);
+
+		len -= netlink_padded_len(expr->len);
+		reg += netlink_register_space(expr->len);
+	}
+	return concat;
+
+err:
+	expr_free(concat);
+	return NULL;
+}
+
+static struct expr *netlink_parse_concat_data(struct netlink_parse_ctx *ctx,
+					      const struct location *loc,
+					      unsigned int reg,
+					      unsigned int len,
+					      struct expr *data)
+{
+	struct expr *concat, *expr, *i;
+
+	concat = concat_expr_alloc(loc);
+	while (len > 0) {
+		expr = netlink_get_register(ctx, loc, reg);
+		if (expr == NULL) {
+			netlink_error(ctx, loc,
+				      "Relational expression size mismatch");
+			goto err;
+		}
+		i = constant_expr_splice(data, expr->len);
+		data->len -= netlink_padding_len(expr->len);
+		compound_expr_add(concat, i);
+
+		len -= netlink_padded_len(expr->len);
+		reg += netlink_register_space(expr->len);
+	}
+	return concat;
+
+err:
+	expr_free(concat);
+	return NULL;
+}
+
 static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
 				    const struct location *loc,
 				    const struct nft_rule_expr *nle)
@@ -175,9 +232,18 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 	nld.value = nft_rule_expr_get(nle, NFT_EXPR_CMP_DATA, &nld.len);
 	right = netlink_alloc_value(loc, &nld);
 
-	if (left->len != right->len)
-		return netlink_error(ctx, loc,
-				     "Relational expression size mismatch");
+	if (left->len != right->len) {
+		if (left->len > right->len)
+			return netlink_error(ctx, loc,
+					     "Relational expression size "
+					     "mismatch");
+		left = netlink_parse_concat_expr(ctx, loc, sreg, right->len);
+		if (left == NULL)
+			return;
+		right = netlink_parse_concat_data(ctx, loc, sreg, right->len, right);
+		if (right == NULL)
+			return;
+	}
 
 	expr = relational_expr_alloc(loc, op, left, right);
 	stmt = expr_stmt_alloc(loc, expr);
@@ -194,12 +260,6 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 	struct expr *expr, *left, *right;
 	struct set *set;
 
-	sreg = netlink_parse_register(nle, NFT_EXPR_LOOKUP_SREG);
-	left = netlink_get_register(ctx, loc, sreg);
-	if (left == NULL)
-		return netlink_error(ctx, loc,
-				     "Lookup expression has no left hand side");
-
 	name = nft_rule_expr_get_str(nle, NFT_EXPR_LOOKUP_SET);
 	set  = set_lookup(ctx->table, name);
 	if (set == NULL)
@@ -207,6 +267,18 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 				     "Unknown set '%s' in lookup expression",
 				     name);
 
+	sreg = netlink_parse_register(nle, NFT_EXPR_LOOKUP_SREG);
+	left = netlink_get_register(ctx, loc, sreg);
+	if (left == NULL)
+		return netlink_error(ctx, loc,
+				     "Lookup expression has no left hand side");
+
+	if (left->len < set->keylen) {
+		left = netlink_parse_concat_expr(ctx, loc, sreg, set->keylen);
+		if (left == NULL)
+			return;
+	}
+
 	right = set_ref_expr_alloc(loc, set);
 
 	if (nft_rule_expr_is_set(nle, NFT_EXPR_LOOKUP_DREG)) {
@@ -724,6 +796,12 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 		return netlink_error(ctx, loc,
 				     "Dynset statement has no key expression");
 
+	if (expr->len < set->keylen) {
+		expr = netlink_parse_concat_expr(ctx, loc, sreg, set->keylen);
+		if (expr == NULL)
+			return;
+	}
+
 	expr = set_elem_expr_alloc(&expr->location, expr);
 	expr->timeout = nft_rule_expr_get_u64(nle, NFT_EXPR_DYNSET_TIMEOUT);
 
@@ -1000,6 +1078,23 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 		list_for_each_entry(i, &expr->expressions, list)
 			expr_postprocess(ctx, stmt, &i);
 		break;
+	case EXPR_CONCAT: {
+		unsigned int type = expr->dtype->type, ntype = 0;
+		int off = expr->dtype->subtypes;
+		const struct datatype *dtype;
+
+		list_for_each_entry(i, &expr->expressions, list) {
+			if (type) {
+				dtype = concat_subtype_lookup(type, --off);
+				expr_set_type(i, dtype, dtype->byteorder);
+			}
+			expr_postprocess(ctx, stmt, &i);
+
+			ntype = concat_subtype_add(ntype, i->dtype->type);
+		}
+		expr->dtype = concat_type_alloc(ntype);
+		break;
+	}
 	case EXPR_UNARY:
 		expr_postprocess(ctx, stmt, &expr->arg);
 		expr_set_type(expr->arg, expr->arg->dtype, !expr->arg->byteorder);
-- 
2.1.0

