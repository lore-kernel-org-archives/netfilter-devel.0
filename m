From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH nft 6/6] nft: add flow statement
Date: Fri,  6 Nov 2015 18:34:23 +0000
Message-ID: <1446834863-18610-7-git-send-email-kaber@trash.net>
References: <1446834863-18610-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:47978 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965406AbbKFSea (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 13:34:30 -0500
In-Reply-To: <1446834863-18610-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The flow statement allows to dynmically instantiate stateful statements using
a user defined flow key. On the kernel side, the dynset statement is used and
the flows are maintained within dynamic sets and evaluated during instatiation
or lookup.

This allows f.i. to do something similar to hashlimit by instantiating the
limit statement per (arbitrary defined) flow:

nft filter input tcp dport ssh ct state new \
	flow table ssh ip saddr limit 10/second

Or keep counters for arbitrary flows:

nft filter input flow \
	table uidacct skuid . oid . ip protocol counter

Currently, the flow tables are displayed as normal sets. Before the final
version they will be moved to a more structured format which supports
sorting in multiple ways.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/linux/netfilter/nf_tables.h |  3 +++
 include/rule.h                      |  1 +
 include/statement.h                 | 12 ++++++++++++
 src/evaluate.c                      | 34 +++++++++++++++++++++++++++++++++
 src/netlink_delinearize.c           | 34 ++++++++++++++++++++++++++++-----
 src/netlink_linearize.c             | 35 ++++++++++++++++++++++++++++++++++
 src/parser_bison.y                  | 38 +++++++++++++++++++++++++++++++++++++
 src/scanner.l                       |  2 ++
 src/statement.c                     | 31 ++++++++++++++++++++++++++++++
 9 files changed, 185 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 38ad174..4909998 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -244,6 +244,7 @@ enum nft_set_flags {
 	NFT_SET_INTERVAL		= 0x4,
 	NFT_SET_MAP			= 0x8,
 	NFT_SET_TIMEOUT			= 0x10,
+	NFT_SET_EVAL			= 0x20,
 };
 
 /**
@@ -564,6 +565,7 @@ enum nft_dynset_ops {
  * @NFTA_DYNSET_SREG_KEY: source register of the key (NLA_U32)
  * @NFTA_DYNSET_SREG_DATA: source register of the data (NLA_U32)
  * @NFTA_DYNSET_TIMEOUT: timeout value for the new element (NLA_U64)
+ * @NFTA_DYNSET_EXPR: expression (NLA_NESTED: nft_expr_attributes)
  */
 enum nft_dynset_attributes {
 	NFTA_DYNSET_UNSPEC,
@@ -573,6 +575,7 @@ enum nft_dynset_attributes {
 	NFTA_DYNSET_SREG_KEY,
 	NFTA_DYNSET_SREG_DATA,
 	NFTA_DYNSET_TIMEOUT,
+	NFTA_DYNSET_EXPR,
 	__NFTA_DYNSET_MAX,
 };
 #define NFTA_DYNSET_MAX		(__NFTA_DYNSET_MAX - 1)
diff --git a/include/rule.h b/include/rule.h
index a86f600..393ada8 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -183,6 +183,7 @@ enum set_flags {
 	SET_F_INTERVAL		= 0x4,
 	SET_F_MAP		= 0x8,
 	SET_F_TIMEOUT		= 0x10,
+	SET_F_EVAL		= 0x20,
 };
 
 /**
diff --git a/include/statement.h b/include/statement.h
index 6a1001c..e3f9a1c 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -121,12 +121,22 @@ struct set_stmt {
 
 extern struct stmt *set_stmt_alloc(const struct location *loc);
 
+struct flow_stmt {
+	struct expr		*set;
+	struct expr		*key;
+	struct stmt		*stmt;
+	const char		*table;
+};
+
+extern struct stmt *flow_stmt_alloc(const struct location *loc);
+
 /**
  * enum stmt_types - statement types
  *
  * @STMT_INVALID:	uninitialised
  * @STMT_EXPRESSION:	expression statement (relational)
  * @STMT_VERDICT:	verdict statement
+ * @STMT_FLOW:		flow statement
  * @STMT_COUNTER:	counters
  * @STMT_META:		meta statement
  * @STMT_LIMIT:		limit statement
@@ -144,6 +154,7 @@ enum stmt_types {
 	STMT_INVALID,
 	STMT_EXPRESSION,
 	STMT_VERDICT,
+	STMT_FLOW,
 	STMT_COUNTER,
 	STMT_META,
 	STMT_LIMIT,
@@ -196,6 +207,7 @@ struct stmt {
 
 	union {
 		struct expr		*expr;
+		struct flow_stmt	flow;
 		struct counter_stmt	counter;
 		struct meta_stmt	meta;
 		struct log_stmt		log;
diff --git a/src/evaluate.c b/src/evaluate.c
index 68d6bff..0d8a13a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1348,6 +1348,38 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_flow(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	struct expr *key, *set, *setref;
+
+	expr_set_context(&ctx->ectx, NULL, 0);
+	if (expr_evaluate(ctx, &stmt->flow.key) < 0)
+		return -1;
+	if (expr_is_constant(stmt->flow.key))
+		return expr_error(ctx->msgs, stmt->flow.key,
+				  "Flow key expression can not be constant");
+
+	if (!(stmt->flow.stmt->flags & STMT_F_STATEFUL))
+		return stmt_binary_error(ctx, stmt->flow.stmt, stmt,
+					 "Flow statement can only be used with "
+					 "stateful statements");
+
+	/* Declare an empty set */
+	key = stmt->flow.key;
+	set = set_expr_alloc(&key->location);
+	set->set_flags |= SET_F_EVAL;
+	if (key->timeout)
+		set->set_flags |= SET_F_TIMEOUT;
+	setref = implicit_set_declaration(ctx, stmt->flow.table ?: "__ft%d",
+					  key->dtype, key->len, set);
+
+	stmt->flow.set = setref;
+
+	if (stmt_evaluate(ctx, stmt->flow.stmt) < 0)
+		return -1;
+	return 0;
+}
+
 static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	return stmt_evaluate_arg(ctx, stmt,
@@ -1911,6 +1943,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_expr(ctx, stmt);
 	case STMT_VERDICT:
 		return stmt_evaluate_verdict(ctx, stmt);
+	case STMT_FLOW:
+		return stmt_evaluate_flow(ctx, stmt);
 	case STMT_META:
 		return stmt_evaluate_meta(ctx, stmt);
 	case STMT_CT:
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index adeaccb..a47f7ca 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -34,6 +34,8 @@ struct netlink_parse_ctx {
 	struct expr		*registers[1 + NFT_REG32_15 - NFT_REG32_00 + 1];
 };
 
+static int netlink_parse_expr(struct nftnl_expr *nle, void *arg);
+
 static void __fmtstring(3, 4) netlink_error(struct netlink_parse_ctx *ctx,
 					    const struct location *loc,
 					    const char *fmt, ...)
@@ -824,8 +826,9 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 				 const struct location *loc,
 				 const struct nftnl_expr *nle)
 {
+	const struct nftnl_expr *dnle;
 	struct expr *expr;
-	struct stmt *stmt;
+	struct stmt *stmt, *dstmt;
 	struct set *set;
 	enum nft_registers sreg;
 	const char *name;
@@ -852,10 +855,28 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 	expr = set_elem_expr_alloc(&expr->location, expr);
 	expr->timeout = nftnl_expr_get_u64(nle, NFTNL_EXPR_DYNSET_TIMEOUT);
 
-	stmt = set_stmt_alloc(loc);
-	stmt->set.set = set_ref_expr_alloc(loc, set);
-	stmt->set.op  = nftnl_expr_get_u32(nle, NFTNL_EXPR_DYNSET_OP);
-	stmt->set.key = expr;
+	dstmt = NULL;
+	dnle = nftnl_expr_get(nle, NFT_EXPR_DYNSET_EXPR, NULL);
+	if (dnle != NULL) {
+		if (netlink_parse_expr((void *)dnle, ctx) < 0)
+			return;
+		if (ctx->stmt == NULL)
+			return netlink_error(ctx, loc,
+					     "Could not parse dynset stmt");
+		dstmt = ctx->stmt;
+	}
+
+	if (dstmt != NULL) {
+		stmt = flow_stmt_alloc(loc);
+		stmt->flow.set  = set_ref_expr_alloc(loc, set);
+		stmt->flow.key  = expr;
+		stmt->flow.stmt = dstmt;
+	} else {
+		stmt = set_stmt_alloc(loc);
+		stmt->set.set  = set_ref_expr_alloc(loc, set);
+		stmt->set.op   = nftnl_expr_get_u32(nle, NFTNL_EXPR_DYNSET_OP);
+		stmt->set.key  = expr;
+	}
 
 	ctx->stmt = stmt;
 }
@@ -1604,6 +1625,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		case STMT_SET:
 			expr_postprocess(&rctx, &stmt->set.key);
 			break;
+		case STMT_FLOW:
+			expr_postprocess(&rctx, &stmt->flow.key);
+			break;
 		case STMT_DUP:
 			if (stmt->dup.to != NULL)
 				expr_postprocess(&rctx, &stmt->dup.to);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index adcc559..0f4b31e 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -995,6 +995,39 @@ netlink_gen_stmt_stateful(struct netlink_linearize_ctx *ctx,
 	}
 }
 
+static void netlink_gen_flow_stmt(struct netlink_linearize_ctx *ctx,
+				  const struct stmt *stmt)
+{
+	struct nftnl_expr *nle, *dnle;
+	enum nft_registers sreg_key;
+	enum nft_dynset_ops op;
+
+	sreg_key = get_register(ctx, stmt->flow.key);
+	netlink_gen_expr(ctx, stmt->flow.key, sreg_key);
+	release_register(ctx, stmt->flow.key);
+
+	if (stmt->flow.key->timeout)
+		op = NFT_DYNSET_OP_UPDATE;
+	else
+		op = NFT_DYNSET_OP_ADD;
+
+	nle = alloc_nft_expr("dynset");
+	netlink_put_register(nle, NFT_EXPR_DYNSET_SREG_KEY, sreg_key);
+	if (stmt->flow.key->timeout)
+		nftnl_expr_set_u64(nle, NFT_EXPR_DYNSET_TIMEOUT,
+				   stmt->flow.key->timeout);
+	nftnl_expr_set_u32(nle, NFT_EXPR_DYNSET_OP, op);
+	nftnl_expr_set_str(nle, NFT_EXPR_DYNSET_SET_NAME,
+			   stmt->flow.set->set->handle.set);
+	nftnl_expr_set_u32(nle, NFT_EXPR_DYNSET_SET_ID,
+			   stmt->flow.set->set->handle.set_id);
+
+	dnle = netlink_gen_stmt_stateful(ctx, stmt->flow.stmt);
+	nftnl_expr_set(nle, NFT_EXPR_DYNSET_EXPR, dnle, 0);
+
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 			     const struct stmt *stmt)
 {
@@ -1005,6 +1038,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_expr(ctx, stmt->expr, NFT_REG_VERDICT);
 	case STMT_VERDICT:
 		return netlink_gen_verdict_stmt(ctx, stmt);
+	case STMT_FLOW:
+		return netlink_gen_flow_stmt(ctx, stmt);
 	case STMT_COUNTER:
 	case STMT_LIMIT:
 		nle = netlink_gen_stmt_stateful(ctx, stmt);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ab4524b..8049b4a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -214,6 +214,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token PERFORMANCE		"performance"
 %token SIZE			"size"
 
+%token FLOW			"flow"
+
 %token <val> NUM		"number"
 %token <string> STRING		"string"
 %token <string> QUOTED_STRING
@@ -470,6 +472,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <stmt>			set_stmt
 %destructor { stmt_free($$); }	set_stmt
 %type <val>			set_stmt_op
+%type <stmt>			flow_stmt flow_stmt_alloc
+%destructor { stmt_free($$); }	flow_stmt flow_stmt_alloc
 
 %type <expr>			symbol_expr verdict_expr integer_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr
@@ -1311,6 +1315,7 @@ stmt_list		:	stmt
 
 stmt			:	verdict_stmt
 			|	match_stmt
+			|	flow_stmt
 			|	counter_stmt
 			|	meta_stmt
 			|	log_stmt
@@ -1697,6 +1702,39 @@ set_stmt_op		:	ADD	{ $$ = NFT_DYNSET_OP_ADD; }
 			|	UPDATE	{ $$ = NFT_DYNSET_OP_UPDATE; }
 			;
 
+flow_stmt		:	flow_stmt_alloc		flow_stmt_opts	set_elem_expr	stmt
+			{
+				$1->flow.key  = $3;
+				$1->flow.stmt = $4;
+				$$ = $1;
+			}
+			|	flow_stmt_alloc		set_elem_expr	stmt
+			{
+				$1->flow.key  = $2;
+				$1->flow.stmt = $3;
+				$$ = $1;
+			}
+			;
+
+flow_stmt_alloc		:	FLOW
+			{
+				$$ = flow_stmt_alloc(&@$);
+			}
+			;
+
+flow_stmt_opts		:	flow_stmt_opt
+			{
+				$<stmt>$	= $<stmt>0;
+			}
+			|	flow_stmt_opts		flow_stmt_opt
+			;
+
+flow_stmt_opt		:	TABLE			identifier
+			{
+				$<stmt>0->flow.table = $2;
+			}
+			;
+
 match_stmt		:	relational_expr
 			{
 				$$ = expr_stmt_alloc(&@$, $1);
diff --git a/src/scanner.l b/src/scanner.l
index a98e7b6..4a886d9 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -285,6 +285,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "performance"		{ return PERFORMANCE; }
 "memory"		{ return MEMORY; }
 
+"flow"			{ return FLOW; }
+
 "counter"		{ return COUNTER; }
 "packets"		{ return PACKETS; }
 "bytes"			{ return BYTES; }
diff --git a/src/statement.c b/src/statement.c
index 55c9f15..e721706 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -21,6 +21,7 @@
 #include <netinet/ip_icmp.h>
 #include <netinet/icmp6.h>
 #include <statement.h>
+#include <rule.h>
 #include <utils.h>
 #include <list.h>
 
@@ -41,6 +42,8 @@ struct stmt *stmt_alloc(const struct location *loc,
 
 void stmt_free(struct stmt *stmt)
 {
+	if (stmt == NULL)
+		return;
 	if (stmt->ops->destroy)
 		stmt->ops->destroy(stmt);
 	xfree(stmt);
@@ -103,6 +106,34 @@ struct stmt *verdict_stmt_alloc(const struct location *loc, struct expr *expr)
 	return stmt;
 }
 
+static void flow_stmt_print(const struct stmt *stmt)
+{
+	printf("flow ");
+	if (stmt->flow.set)
+		printf("table %s ", stmt->flow.set->set->handle.set);
+	expr_print(stmt->flow.key);
+	printf(" ");
+	stmt_print(stmt->flow.stmt);
+}
+
+static void flow_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->flow.key);
+	stmt_free(stmt->flow.stmt);
+}
+
+static const struct stmt_ops flow_stmt_ops = {
+	.type		= STMT_FLOW,
+	.name		= "flow",
+	.print		= flow_stmt_print,
+	.destroy	= flow_stmt_destroy,
+};
+
+struct stmt *flow_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &flow_stmt_ops);
+}
+
 static void counter_stmt_print(const struct stmt *stmt)
 {
 	printf("counter packets %" PRIu64 " bytes %" PRIu64,
-- 
2.4.3

