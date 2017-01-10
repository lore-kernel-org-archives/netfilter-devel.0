From: Phil Sutter <phil@nwl.cc>
Subject: RFC: nftables: Boolean operation, two alternatives
Date: Tue, 10 Jan 2017 15:17:33 +0100
Message-ID: <20170110141733.GD6774@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:43685 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032565AbdAJORf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Jan 2017 09:17:35 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I have spent a while tinkering with support for a boolean comparison in
nftables syntax. Originally this is a requirement for my upcoming IPv6
extension header existence match, but as Florian pointed out it would
make sense for fib expression, too: Currently, we may do rpath filtering
by making sure an incoming packet has a route on that interface like so:

| fib daddr oif != 0

This works because 'fib daddr oif' returns an ifindex of 0 if lookup
failed. A more convenient/readable solution is the introduction of
'exists' and 'missing' keywords, so the above could be written as:

| fib daddr oif exists

Attached you will find two possible implementations allowing this:

The first one implements a number of such boolean keywords as simple
aliases for relational '== 0' (for 'false') and '!= 0' (for 'true')
expressions. While this approach is really simplistic and does not
require an additional kernel patch, it has an obvious downside: When
listing rules, there is no way to distinguish between an intentional
comparison against zero or an implicit one via the alias. So although
one may say 'fib daddr oif exists', when listing the rule nft would
always say 'fib daddr oif != 0'.

To overcome this ugly asymmetry between input and output, I proceeded
with a second implementation which introduces a new (yet only implicit)
relational op 'OP_BOOL'. This obviously requires a kernel patch, but
OTOH nft_cmp.c now knows it's only a boolean comparison and therefore
might be optimized. I tried to go further by distinguishing between
flavors of boolean keywords, so e.g. fib on LHS always turns the boolean
on RHS into 'exists'/'missing' instead of 'yes'/'no' (or whatever may be
added). Sadly I'm not really happy with the implementation in that
regard: Since there is no context sensitive evaluation step when parsing
the ruleset returned from kernel (as there is on input side), boolean
expression does not have full access to LHS and therefore can only refer
to expr->dtype to decide how to present itself to the user. Furthermore,
this decision is completely unrelated to what was given on input side -
so a user may still say:

| fib daddr oif yes

and it will turn into:

| fib daddr oif exists

I would appreciate if you could review the two patches and state which
one you would prefer and how I could improve them (especially regarding
the asymmetry issue detailed above).

Thanks, Phil

--d6Gm4EdcadzBjdND
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-implement-boolean-as-simple-alias-for-relational-EQ-.patch"

>From 9bf08b916f9b6148cf3b61d4a7b6b25fc3dc4add Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Fri, 23 Dec 2016 17:53:03 +0100
Subject: [nft PATCH] implement boolean as simple alias for relational EQ/NEQ 0

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_bison.y | 13 +++++++++++++
 src/scanner.l      |  7 +++++++
 2 files changed, 20 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index deaaf06fa1c6c..438f3d81a8fbb 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -424,6 +424,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token NOTRACK			"notrack"
 
+%token BOOLEAN_TRUE		"boolean true"
+%token BOOLEAN_FALSE		"boolean false"
+
 %type <string>			identifier type_identifier string comment_spec
 %destructor { xfree($$); }	identifier type_identifier string comment_spec
 
@@ -2298,6 +2301,16 @@ relational_expr		:	expr	/* implicit */	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@2, $2, $1, $4);
 			}
+			|	expr	BOOLEAN_TRUE
+			{
+				$$ = relational_expr_alloc(&@$, OP_NEQ, $1,
+					symbol_expr_alloc(&@$, SYMBOL_VALUE, current_scope(state), "0"));
+			}
+			|	expr	BOOLEAN_FALSE
+			{
+				$$ = relational_expr_alloc(&@$, OP_EQ, $1,
+					symbol_expr_alloc(&@$, SYMBOL_VALUE, current_scope(state), "0"));
+			}
 			;
 
 list_rhs_expr		:	basic_rhs_expr		COMMA		basic_rhs_expr
diff --git a/src/scanner.l b/src/scanner.l
index 625023f5257c1..e34730a74fad4 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -475,6 +475,13 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "xml"			{ return XML; }
 "json"			{ return JSON; }
 
+"true"			{ return BOOLEAN_TRUE; }
+"false"			{ return BOOLEAN_FALSE; }
+"yes"			{ return BOOLEAN_TRUE; }
+"no"			{ return BOOLEAN_FALSE; }
+"exists"		{ return BOOLEAN_TRUE; }
+"missing"		{ return BOOLEAN_FALSE; }
+
 {addrstring}		{
 				yylval->string = xstrdup(yytext);
 				return STRING;
-- 
2.11.0


--d6Gm4EdcadzBjdND
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Implement-boolean-comparison-in-relational-expressio.patch"

>From b78e30a081a45d245c2488c7b51cd4d1ce3e20e5 Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 10 Jan 2017 14:11:23 +0100
Subject: [nft PATCH] Implement boolean comparison in relational expression

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
 src/expression.c                    | 36 ++++++++++++++++++++++++++++++++++++
 src/netlink.c                       | 20 ++++++++++++++++++++
 src/netlink_delinearize.c           |  8 +++++++-
 src/netlink_linearize.c             |  3 +++
 src/parser_bison.y                  | 18 ++++++++++++++++++
 src/scanner.l                       |  5 +++++
 10 files changed, 114 insertions(+), 1 deletion(-)

diff --git a/include/expression.h b/include/expression.h
index 71e9c43ef0e1f..ddf4ba8dea633 100644
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
@@ -420,4 +427,6 @@ extern struct expr *set_elem_expr_alloc(const struct location *loc,
 extern void range_expr_value_low(mpz_t rop, const struct expr *expr);
 extern void range_expr_value_high(mpz_t rop, const struct expr *expr);
 
+extern struct expr *boolean_expr_alloc(const struct location *loc,
+				       bool val);
 #endif /* NFTABLES_EXPRESSION_H */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index f030e59aa2ece..e54f5a278bd55 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -528,6 +528,7 @@ enum nft_cmp_ops {
 	NFT_CMP_LTE,
 	NFT_CMP_GT,
 	NFT_CMP_GTE,
+	NFT_CMP_BOOL,
 };
 
 /**
diff --git a/include/netlink.h b/include/netlink.h
index 363b5251968f3..c598fa16055a4 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -93,6 +93,8 @@ extern struct expr *netlink_alloc_value(const struct location *loc,
 extern struct expr *netlink_alloc_data(const struct location *loc,
 				       const struct nft_data_delinearize *nld,
 				       enum nft_registers dreg);
+extern struct expr *netlink_alloc_boolean(const struct location *loc,
+					  const struct nft_data_delinearize *nld);
 
 extern void netlink_linearize_rule(struct netlink_ctx *ctx,
 				   struct nftnl_rule *nlr,
diff --git a/src/evaluate.c b/src/evaluate.c
index 8a3da54e5b2d5..8947c9d468059 100644
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
index b7403c7009cd0..41b5db8d66016 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -456,6 +456,7 @@ const char *expr_op_symbols[] = {
 	[OP_GTE]	= ">=",
 	[OP_RANGE]	= "within range",
 	[OP_LOOKUP]	= NULL,
+	[OP_BOOL]	= NULL,
 };
 
 static void unary_expr_print(const struct expr *expr)
@@ -990,3 +991,38 @@ void range_expr_value_high(mpz_t rop, const struct expr *expr)
 		BUG("invalid range expression type %s\n", expr->ops->name);
 	}
 }
+
+static void boolean_expr_clone(struct expr *new, const struct expr *expr)
+{
+}
+
+static void boolean_expr_print(const struct expr *expr)
+{
+	if (expr->dtype == datatype_lookup(TYPE_FIB_ADDR) ||
+	    expr->dtype == datatype_lookup(TYPE_IFINDEX))
+		printf(expr->boolean ? "exists" : "missing");
+
+	else
+		printf(expr->boolean ? "true" : "false");
+}
+
+static const struct expr_ops boolean_expr_ops = {
+	.type	= EXPR_BOOLEAN,
+	.name	= "boolean",
+	.clone	= boolean_expr_clone,
+	.print	= boolean_expr_print,
+//	.destroy = boolean_expr_destroy,
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
index d6d00199d746d..802fbb2264f28 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -324,6 +324,14 @@ static void netlink_gen_verdict(const struct expr *expr,
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
@@ -333,6 +341,8 @@ void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data)
 		return netlink_gen_concat_data(expr, data);
 	case EXPR_VERDICT:
 		return netlink_gen_verdict(expr, data);
+	case EXPR_BOOLEAN:
+		return netlink_gen_boolean(expr, data);
 	default:
 		BUG("invalid data expression type %s\n", expr->ops->name);
 	}
@@ -375,6 +385,16 @@ struct expr *netlink_alloc_data(const struct location *loc,
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
index cb0f6ac7b1a21..c3d928c517c8e 100644
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
@@ -1785,6 +1790,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_VERDICT:
 	case EXPR_NUMGEN:
 	case EXPR_FIB:
+	case EXPR_BOOLEAN:
 		break;
 	case EXPR_HASH:
 		expr_postprocess(ctx, &expr->hash.expr);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 0915038fecaef..8afb72e554825 100644
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
index deaaf06fa1c6c..490accc211faf 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -424,6 +424,13 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
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
 
@@ -2046,6 +2053,16 @@ integer_expr		:	NUM
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
@@ -2376,6 +2393,7 @@ concat_rhs_expr		:	basic_rhs_expr
 
 primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 			|	integer_expr		{ $$ = $1; }
+			|	boolean_expr		{ $$ = $1; }
 			|	ETHER
 			{
 				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
diff --git a/src/scanner.l b/src/scanner.l
index 625023f5257c1..05c3633c4bfe4 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -475,6 +475,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "xml"			{ return XML; }
 "json"			{ return JSON; }
 
+"exists"		{ return TRUE; }
+"missing"		{ return FALSE; }
+"yes"			{ return TRUE; }
+"no"			{ return FALSE; }
+
 {addrstring}		{
 				yylval->string = xstrdup(yytext);
 				return STRING;
-- 
2.11.0


--d6Gm4EdcadzBjdND--
