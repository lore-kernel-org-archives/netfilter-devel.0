From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/3] Implement boolean comparison in relational expression
Date: Tue, 17 Jan 2017 23:10:05 +0100
Message-ID: <20170117221007.14951-2-phil@nwl.cc>
References: <20170117221007.14951-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:57473 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751166AbdAQWHh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 17:07:37 -0500
In-Reply-To: <20170117221007.14951-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This works by introducing OP_BOOL which allows to properly display the
boolean statement when listing rules. Apart from that, in kernel space
it is this way possible to optimize the comparison instead of having to
live with EQ/NEQ zero checks.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expression.h                |  9 +++++++++
 include/linux/netfilter/nf_tables.h |  1 +
 include/netlink.h                   |  2 ++
 src/evaluate.c                      | 13 +++++++++++++
 src/expression.c                    | 38 +++++++++++++++++++++++++++++++++++++
 src/netlink.c                       | 20 +++++++++++++++++++
 src/netlink_delinearize.c           |  8 +++++++-
 src/netlink_linearize.c             |  3 +++
 src/parser_bison.y                  | 18 ++++++++++++++++++
 src/scanner.l                       |  5 +++++
 10 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/include/expression.h b/include/expression.h
index ec90265b5f926..fa1587639621e 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -62,6 +62,7 @@ enum expr_types {
 	EXPR_HASH,
 	EXPR_RT,
 	EXPR_FIB,
+	EXPR_BOOLEAN,
 };
 
 enum ops {
@@ -89,6 +90,8 @@ enum ops {
 	OP_FLAGCMP,
 	/* Set lookup */
 	OP_LOOKUP,
+	/* boolean comparison */
+	OP_BOOL,
 	__OP_MAX
 };
 #define OP_MAX		(__OP_MAX - 1)
@@ -217,6 +220,10 @@ struct expr {
 	enum ops		op;
 	union {
 		struct {
+			/* EXPR_BOOLEAN */
+			bool			boolean;
+		};
+		struct {
 			/* EXPR_SYMBOL */
 			const struct scope	*scope;
 			const char		*identifier;
@@ -421,4 +428,6 @@ extern struct expr *set_elem_expr_alloc(const struct location *loc,
 extern void range_expr_value_low(mpz_t rop, const struct expr *expr);
 extern void range_expr_value_high(mpz_t rop, const struct expr *expr);
 
+extern struct expr *boolean_expr_alloc(const struct location *loc,
+				       bool val);
 #endif /* NFTABLES_EXPRESSION_H */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b00a05d1ee566..075894657aecd 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -543,6 +543,7 @@ enum nft_cmp_ops {
 	NFT_CMP_LTE,
 	NFT_CMP_GT,
 	NFT_CMP_GTE,
+	NFT_CMP_BOOL,
 };
 
 /**
diff --git a/include/netlink.h b/include/netlink.h
index 450aba571a979..6b0a72a846d59 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -94,6 +94,8 @@ extern struct expr *netlink_alloc_value(const struct location *loc,
 extern struct expr *netlink_alloc_data(const struct location *loc,
 				       const struct nft_data_delinearize *nld,
 				       enum nft_registers dreg);
+extern struct expr *netlink_alloc_boolean(const struct location *loc,
+					  const struct nft_data_delinearize *nld);
 
 extern void netlink_linearize_rule(struct netlink_ctx *ctx,
 				   struct nftnl_rule *nlr,
diff --git a/src/evaluate.c b/src/evaluate.c
index bcbced1e3dfa6..6a65ec16c36f3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1444,6 +1444,9 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		case EXPR_LIST:
 			rel->op = OP_FLAGCMP;
 			break;
+		case EXPR_BOOLEAN:
+			rel->op = OP_BOOL;
+			break;
 		default:
 			if (right->dtype->basetype != NULL &&
 			    right->dtype->basetype->type == TYPE_BITMASK)
@@ -1605,6 +1608,8 @@ range:
 		if (byteorder_conversion(ctx, &right->right, BYTEORDER_BIG_ENDIAN) < 0)
 			return -1;
 		break;
+	case OP_BOOL:
+		break;
 	default:
 		BUG("invalid relational operation %u\n", rel->op);
 	}
@@ -1615,6 +1620,12 @@ range:
 	return 0;
 }
 
+static int expr_evaluate_boolean(struct eval_ctx *ctx, struct expr **expr)
+{
+	(*expr)->len = ctx->ectx.len;
+	return 0;
+}
+
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 {
 #ifdef DEBUG
@@ -1671,6 +1682,8 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return expr_evaluate_numgen(ctx, expr);
 	case EXPR_HASH:
 		return expr_evaluate_hash(ctx, expr);
+	case EXPR_BOOLEAN:
+		return expr_evaluate_boolean(ctx, expr);
 	default:
 		BUG("unknown expression type %s\n", (*expr)->ops->name);
 	}
diff --git a/src/expression.c b/src/expression.c
index 1567870c631b6..8842a7836fc07 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -456,6 +456,7 @@ const char *expr_op_symbols[] = {
 	[OP_GTE]	= ">=",
 	[OP_RANGE]	= "within range",
 	[OP_LOOKUP]	= NULL,
+	[OP_BOOL]	= NULL,
 };
 
 static void unary_expr_print(const struct expr *expr)
@@ -990,3 +991,40 @@ void range_expr_value_high(mpz_t rop, const struct expr *expr)
 		BUG("invalid range expression type %s\n", expr->ops->name);
 	}
 }
+
+static void boolean_expr_clone(struct expr *new, const struct expr *expr)
+{
+	new->boolean = expr->boolean;
+}
+
+static void boolean_expr_print(const struct expr *expr)
+{
+	switch (expr->dtype->type) {
+	case TYPE_FIB_ADDR:		/* fib expr */
+	case TYPE_IFINDEX:		/* fib expr */
+		printf(expr->boolean ? "exists" : "missing");
+		break;
+	default:
+		printf(expr->boolean ? "true" : "false");
+	}
+}
+
+static const struct expr_ops boolean_expr_ops = {
+	.type	= EXPR_BOOLEAN,
+	.name	= "boolean",
+	.clone	= boolean_expr_clone,
+	.print	= boolean_expr_print,
+};
+
+struct expr *boolean_expr_alloc(const struct location *loc,
+				bool val)
+{
+	struct expr *expr;
+
+	expr = expr_alloc(loc, &boolean_expr_ops,
+			  &invalid_type, BYTEORDER_INVALID, 0);
+	expr->boolean = val;
+	expr->flags = EXPR_F_CONSTANT | EXPR_F_SINGLETON;
+
+	return expr;
+}
diff --git a/src/netlink.c b/src/netlink.c
index 4135f2517a09b..7fed893d3af26 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -375,6 +375,14 @@ static void netlink_gen_verdict(const struct expr *expr,
 	}
 }
 
+static void netlink_gen_boolean(const struct expr *expr,
+				struct nft_data_linearize *data)
+{
+	data->len = div_round_up(expr->len, BITS_PER_BYTE);
+	memset(data->value, 0, sizeof(data->value));
+	data->value[0] = expr->boolean;
+}
+
 void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data)
 {
 	switch (expr->ops->type) {
@@ -384,6 +392,8 @@ void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data)
 		return netlink_gen_concat_data(expr, data);
 	case EXPR_VERDICT:
 		return netlink_gen_verdict(expr, data);
+	case EXPR_BOOLEAN:
+		return netlink_gen_boolean(expr, data);
 	default:
 		BUG("invalid data expression type %s\n", expr->ops->name);
 	}
@@ -426,6 +436,16 @@ struct expr *netlink_alloc_data(const struct location *loc,
 	}
 }
 
+struct expr *netlink_alloc_boolean(const struct location *loc,
+				   const struct nft_data_delinearize *nld)
+{
+	struct expr *expr;
+
+	expr = boolean_expr_alloc(loc, nld->value[0]);
+	expr->len = nld->len * BITS_PER_BYTE;
+	return expr;
+}
+
 int netlink_add_rule_batch(struct netlink_ctx *ctx,
 			   const struct handle *h,
 		           const struct rule *rule, uint32_t flags)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 48968442d9bcc..06823de24d0e7 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -241,6 +241,8 @@ static enum ops netlink_parse_cmp_op(const struct nftnl_expr *nle)
 		return OP_GT;
 	case NFT_CMP_GTE:
 		return OP_GTE;
+	case NFT_CMP_BOOL:
+		return OP_BOOL;
 	default:
 		return OP_INVALID;
 	}
@@ -265,7 +267,10 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 	op = netlink_parse_cmp_op(nle);
 
 	nld.value = nftnl_expr_get(nle, NFTNL_EXPR_CMP_DATA, &nld.len);
-	right = netlink_alloc_value(loc, &nld);
+	if (op == OP_BOOL)
+		right = netlink_alloc_boolean(loc, &nld);
+	else
+		right = netlink_alloc_value(loc, &nld);
 
 	if (left->len > right->len &&
 	    left->dtype != &string_type) {
@@ -1846,6 +1851,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_VERDICT:
 	case EXPR_NUMGEN:
 	case EXPR_FIB:
+	case EXPR_BOOLEAN:
 		break;
 	case EXPR_HASH:
 		expr_postprocess(ctx, &expr->hash.expr);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 5030135cd5d58..aff4f04a36db9 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -300,6 +300,8 @@ static enum nft_cmp_ops netlink_gen_cmp_op(enum ops op)
 		return NFT_CMP_LTE;
 	case OP_GTE:
 		return NFT_CMP_GTE;
+	case OP_BOOL:
+		return NFT_CMP_BOOL;
 	default:
 		BUG("invalid comparison operation %u\n", op);
 	}
@@ -489,6 +491,7 @@ static void netlink_gen_relational(struct netlink_linearize_ctx *ctx,
 	case OP_GT:
 	case OP_LTE:
 	case OP_GTE:
+	case OP_BOOL:
 		return netlink_gen_cmp(ctx, expr, dreg);
 	case OP_RANGE:
 		return netlink_gen_range(ctx, expr, dreg);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 4749c9fa87308..3205cc407ffa8 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -428,6 +428,13 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token NOTRACK			"notrack"
 
+%token TRUE			"true"
+%token FALSE			"false"
+
+%type <val>			boolean_spec
+%type <expr>			boolean_expr
+%destructor { expr_free($$); }	boolean_expr
+
 %type <string>			identifier type_identifier string comment_spec
 %destructor { xfree($$); }	identifier type_identifier string comment_spec
 
@@ -2239,6 +2246,16 @@ integer_expr		:	NUM
 			}
 			;
 
+boolean_expr		:	boolean_spec
+			{
+				$$ = boolean_expr_alloc(&@$, $1);
+			}
+			;
+
+boolean_spec		:	TRUE	{ $$ = true; }
+			|	FALSE	{ $$ = false; }
+			;
+
 primary_expr		:	symbol_expr			{ $$ = $1; }
 			|	integer_expr			{ $$ = $1; }
 			|	payload_expr			{ $$ = $1; }
@@ -2616,6 +2633,7 @@ concat_rhs_expr		:	basic_rhs_expr
 
 primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 			|	integer_expr		{ $$ = $1; }
+			|	boolean_expr		{ $$ = $1; }
 			|	ETHER
 			{
 				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
diff --git a/src/scanner.l b/src/scanner.l
index d0d25ea946009..debc18fad37ef 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -482,6 +482,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "xml"			{ return XML; }
 "json"			{ return JSON; }
 
+"exists"		{ return TRUE; }
+"missing"		{ return FALSE; }
+"true"			{ return TRUE; }
+"false"			{ return FALSE; }
+
 {addrstring}		{
 				yylval->string = xstrdup(yytext);
 				return STRING;
-- 
2.11.0

