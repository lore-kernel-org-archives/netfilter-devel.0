From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 7/7] nft: add flow statement
Date: Wed, 27 Apr 2016 12:29:50 +0100
Message-ID: <1461756590-22880-8-git-send-email-kaber@trash.net>
References: <1461756590-22880-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33539 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbcD0LaF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 07:30:05 -0400
In-Reply-To: <1461756590-22880-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The flow statement allows to instantiate per flow statements for user
defined flows. This can so far be used for per flow accounting or limiting,
similar to what the iptables hashlimit provides. Flows can be aged using
the timeout option.

Examples:

# nft filter input flow ip saddr . tcp dport limit rate 10/second
# nft filter input flow table acct iif . ip saddr timeout 60s counter

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h      |  1 +
 include/netlink.h         |  3 +++
 include/rule.h            |  1 +
 include/statement.h       | 12 ++++++++++
 src/evaluate.c            | 37 ++++++++++++++++++++++++++++++
 src/expression.c          | 16 ++++++++++---
 src/netlink.c             |  6 +++++
 src/netlink_delinearize.c | 49 +++++++++++++++++++++++++++++++++++-----
 src/netlink_linearize.c   | 40 +++++++++++++++++++++++++++++----
 src/parser_bison.y        | 57 +++++++++++++++++++++++++++++++++++++++++++++++
 src/scanner.l             |  2 ++
 src/statement.c           | 33 +++++++++++++++++++++++++++
 12 files changed, 245 insertions(+), 12 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 72b6f69..6f1bf4a 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -237,6 +237,7 @@ struct expr {
 			uint64_t		timeout;
 			uint64_t		expiration;
 			const char		*comment;
+			struct stmt		*stmt;
 		};
 		struct {
 			/* EXPR_UNARY */
diff --git a/include/netlink.h b/include/netlink.h
index 6ea017c..8f9b7c1 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -142,6 +142,9 @@ extern int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h,
 extern int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 			   const struct location *loc);
 
+extern struct stmt *netlink_parse_set_expr(const struct set *set,
+					   const struct nftnl_expr *nle);
+
 extern int netlink_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 				const struct expr *expr);
 extern int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
diff --git a/include/rule.h b/include/rule.h
index 09b3ff7..bfe398d 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -206,6 +206,7 @@ enum set_flags {
 	SET_F_INTERVAL		= 0x4,
 	SET_F_MAP		= 0x8,
 	SET_F_TIMEOUT		= 0x10,
+	SET_F_EVAL		= 0x20,
 };
 
 /**
diff --git a/include/statement.h b/include/statement.h
index a6a86f9..e9313ca 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -138,12 +138,22 @@ struct set_stmt {
 
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
  * @STMT_PAYLOAD:	payload statement
  * @STMT_META:		meta statement
@@ -163,6 +173,7 @@ enum stmt_types {
 	STMT_INVALID,
 	STMT_EXPRESSION,
 	STMT_VERDICT,
+	STMT_FLOW,
 	STMT_COUNTER,
 	STMT_PAYLOAD,
 	STMT_META,
@@ -217,6 +228,7 @@ struct stmt {
 
 	union {
 		struct expr		*expr;
+		struct flow_stmt	flow;
 		struct counter_stmt	counter;
 		struct payload_stmt	payload;
 		struct meta_stmt	meta;
diff --git a/src/evaluate.c b/src/evaluate.c
index aa9fa43..d86ee05 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1436,6 +1436,41 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 				 &stmt->payload.val);
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
+	if (stmt->flow.key->comment)
+		return expr_error(ctx->msgs, stmt->flow.key,
+				  "Flow key expression can not contain comments");
+
+	/* Declare an empty set */
+	key = stmt->flow.key;
+	set = set_expr_alloc(&key->location);
+	set->set_flags |= SET_F_EVAL;
+	if (key->timeout)
+		set->set_flags |= SET_F_TIMEOUT;
+
+	setref = implicit_set_declaration(ctx, stmt->flow.table ?: "__ft%d",
+					  key->dtype, key->len, set);
+
+	stmt->flow.set = setref;
+
+	if (stmt_evaluate(ctx, stmt->flow.stmt) < 0)
+		return -1;
+	if (!(stmt->flow.stmt->flags & STMT_F_STATEFUL))
+		return stmt_binary_error(ctx, stmt->flow.stmt, stmt,
+					 "Per-flow statement must be stateful");
+
+	return 0;
+}
+
 static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	return stmt_evaluate_arg(ctx, stmt,
@@ -2055,6 +2090,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_verdict(ctx, stmt);
 	case STMT_PAYLOAD:
 		return stmt_evaluate_payload(ctx, stmt);
+	case STMT_FLOW:
+		return stmt_evaluate_flow(ctx, stmt);
 	case STMT_META:
 		return stmt_evaluate_meta(ctx, stmt);
 	case STMT_CT:
diff --git a/src/expression.c b/src/expression.c
index ab195e5..a10af5d 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -16,6 +16,7 @@
 #include <limits.h>
 
 #include <expression.h>
+#include <statement.h>
 #include <datatype.h>
 #include <rule.h>
 #include <gmputil.h>
@@ -852,10 +853,14 @@ struct expr *map_expr_alloc(const struct location *loc, struct expr *arg,
 
 static void set_ref_expr_print(const struct expr *expr)
 {
-	if (expr->set->flags & SET_F_ANONYMOUS)
-		expr_print(expr->set->init);
-	else
+	if (expr->set->flags & SET_F_ANONYMOUS) {
+		if (expr->set->flags & SET_F_EVAL)
+			printf("table %s", expr->set->handle.set);
+		else
+			expr_print(expr->set->init);
+	} else {
 		printf("@%s", expr->set->handle.set);
+	}
 }
 
 static void set_ref_expr_clone(struct expr *new, const struct expr *expr)
@@ -899,6 +904,11 @@ static void set_elem_expr_print(const struct expr *expr)
 	}
 	if (expr->comment)
 		printf(" comment \"%s\"", expr->comment);
+
+	if (expr->stmt) {
+		printf(" : ");
+		stmt_print(expr->stmt);
+	}
 }
 
 static void set_elem_expr_destroy(struct expr *expr)
diff --git a/src/netlink.c b/src/netlink.c
index 13fb82f..c617ad0 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1460,6 +1460,12 @@ static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 		expr->comment = xmalloc(len);
 		memcpy((char *)expr->comment, data, len);
 	}
+	if (nftnl_set_elem_is_set(nlse, NFT_SET_ELEM_ATTR_EXPR)) {
+		const struct nftnl_expr *nle;
+
+		nle = nftnl_set_elem_get(nlse, NFT_SET_ELEM_ATTR_EXPR, NULL);
+		expr->stmt = netlink_parse_set_expr(set, nle);
+	}
 
 	if (flags & NFT_SET_ELEM_INTERVAL_END) {
 		expr->flags |= EXPR_F_INTERVAL_END;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index d046d1f..0e601f3 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -35,6 +35,9 @@ struct netlink_parse_ctx {
 	struct expr		*registers[1 + NFT_REG32_15 - NFT_REG32_00 + 1];
 };
 
+static int netlink_parse_expr(const struct nftnl_expr *nle,
+			      struct netlink_parse_ctx *ctx);
+
 static void __fmtstring(3, 4) netlink_error(struct netlink_parse_ctx *ctx,
 					    const struct location *loc,
 					    const char *fmt, ...)
@@ -910,8 +913,9 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
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
@@ -938,10 +942,28 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 	expr = set_elem_expr_alloc(&expr->location, expr);
 	expr->timeout = nftnl_expr_get_u64(nle, NFTNL_EXPR_DYNSET_TIMEOUT);
 
-	stmt = set_stmt_alloc(loc);
-	stmt->set.set = set_ref_expr_alloc(loc, set);
-	stmt->set.op  = nftnl_expr_get_u32(nle, NFTNL_EXPR_DYNSET_OP);
-	stmt->set.key = expr;
+	dstmt = NULL;
+	dnle = nftnl_expr_get(nle, NFTNL_EXPR_DYNSET_EXPR, NULL);
+	if (dnle != NULL) {
+		if (netlink_parse_expr(dnle, ctx) < 0)
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
+		stmt->set.set   = set_ref_expr_alloc(loc, set);
+		stmt->set.op    = nftnl_expr_get_u32(nle, NFTNL_EXPR_DYNSET_OP);
+		stmt->set.key   = expr;
+	}
 
 	ctx->stmt = stmt;
 }
@@ -1011,6 +1033,20 @@ static int netlink_parse_rule_expr(struct nftnl_expr *nle, void *arg)
 	return 0;
 }
 
+struct stmt *netlink_parse_set_expr(const struct set *set,
+				    const struct nftnl_expr *nle)
+{
+	struct netlink_parse_ctx ctx, *pctx = &ctx;
+
+	pctx->rule = rule_alloc(&netlink_location, &set->handle);
+	pctx->table = table_lookup(&set->handle);
+	assert(pctx->table != NULL);
+
+	if (netlink_parse_expr(nle, pctx) < 0)
+		return NULL;
+	return pctx->stmt;
+}
+
 struct rule_pp_ctx {
 	struct proto_ctx	pctx;
 	struct payload_dep_ctx	pdctx;
@@ -1669,6 +1705,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 				      stmt->payload.expr->byteorder);
 			expr_postprocess(&rctx, &stmt->payload.val);
 			break;
+		case STMT_FLOW:
+			expr_postprocess(&rctx, &stmt->flow.key);
+			break;
 		case STMT_META:
 			if (stmt->meta.expr != NULL)
 				expr_postprocess(&rctx, &stmt->meta.expr);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 28feecf..0f2c2a9 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1116,6 +1116,7 @@ static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
 static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
+	struct set *set = stmt->flow.set->set;
 	struct nftnl_expr *nle;
 	enum nft_registers sreg_key;
 
@@ -1128,10 +1129,39 @@ static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u64(nle, NFTNL_EXPR_DYNSET_TIMEOUT,
 			   stmt->set.key->timeout);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_OP, stmt->set.op);
-	nftnl_expr_set_str(nle, NFTNL_EXPR_DYNSET_SET_NAME,
-			   stmt->set.set->set->handle.set);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_SET_ID,
-			   stmt->set.set->set->handle.set_id);
+	nftnl_expr_set_str(nle, NFTNL_EXPR_DYNSET_SET_NAME, set->handle.set);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_SET_ID, set->handle.set_id);
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
+static void netlink_gen_flow_stmt(struct netlink_linearize_ctx *ctx,
+				  const struct stmt *stmt)
+{
+	struct nftnl_expr *nle;
+	enum nft_registers sreg_key;
+	enum nft_dynset_ops op;
+	struct set *set;
+
+	sreg_key = get_register(ctx, stmt->flow.key);
+	netlink_gen_expr(ctx, stmt->flow.key, sreg_key);
+	release_register(ctx, stmt->flow.key);
+
+	set = stmt->flow.set->set;
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
+	nftnl_expr_set_str(nle, NFT_EXPR_DYNSET_SET_NAME, set->handle.set);
+	nftnl_expr_set_u32(nle, NFT_EXPR_DYNSET_SET_ID, set->handle.set_id);
+	nftnl_expr_set(nle, NFT_EXPR_DYNSET_EXPR,
+		       netlink_gen_stmt_stateful(ctx, stmt->flow.stmt), 0);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
@@ -1145,6 +1175,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_expr(ctx, stmt->expr, NFT_REG_VERDICT);
 	case STMT_VERDICT:
 		return netlink_gen_verdict_stmt(ctx, stmt);
+	case STMT_FLOW:
+		return netlink_gen_flow_stmt(ctx, stmt);
 	case STMT_PAYLOAD:
 		return netlink_gen_payload_stmt(ctx, stmt);
 	case STMT_META:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 444ed4c..b6d5055 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -216,6 +216,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token PERFORMANCE		"performance"
 %token SIZE			"size"
 
+%token FLOW			"flow"
+
 %token <val> NUM		"number"
 %token <string> STRING		"string"
 %token <string> QUOTED_STRING
@@ -483,6 +485,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <stmt>			set_stmt
 %destructor { stmt_free($$); }	set_stmt
 %type <val>			set_stmt_op
+%type <stmt>			flow_stmt flow_stmt_alloc
+%destructor { stmt_free($$); }	flow_stmt flow_stmt_alloc
 
 %type <expr>			symbol_expr verdict_expr integer_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr
@@ -518,6 +522,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			set_elem_expr set_elem_expr_alloc set_lhs_expr set_rhs_expr
 %destructor { expr_free($$); }	set_elem_expr set_elem_expr_alloc set_lhs_expr set_rhs_expr
 
+%type <expr>			flow_key_expr flow_key_expr_alloc
+%destructor { expr_free($$); }	flow_key_expr flow_key_expr_alloc
+
 %type <expr>			expr initializer_expr
 %destructor { expr_free($$); }	expr initializer_expr
 
@@ -1303,6 +1310,7 @@ stmt_list		:	stmt
 
 stmt			:	verdict_stmt
 			|	match_stmt
+			|	flow_stmt
 			|	counter_stmt
 			|	payload_stmt
 			|	meta_stmt
@@ -1754,6 +1762,41 @@ set_stmt_op		:	ADD	{ $$ = NFT_DYNSET_OP_ADD; }
 			|	UPDATE	{ $$ = NFT_DYNSET_OP_UPDATE; }
 			;
 
+flow_stmt		:	flow_stmt_alloc		flow_stmt_opts	flow_key_expr	stmt
+			{
+				$1->flow.key  = $3;
+				$1->flow.stmt = $4;
+				$$->location  = @$;
+				$$ = $1;
+			}
+			|	flow_stmt_alloc		flow_key_expr	stmt
+			{
+				$1->flow.key  = $2;
+				$1->flow.stmt = $3;
+				$$->location  = @$;
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
@@ -1938,6 +1981,20 @@ set_list_member_expr	:	opt_newline	set_expr	opt_newline
 			}
 			;
 
+flow_key_expr		:	flow_key_expr_alloc
+			|	flow_key_expr_alloc		set_elem_options
+			{
+				$$->location = @$;
+				$$ = $1;
+			}
+			;
+
+flow_key_expr_alloc	:	concat_expr
+			{
+				$$ = set_elem_expr_alloc(&@1, $1);
+			}
+			;
+
 set_elem_expr		:	set_elem_expr_alloc
 			|	set_elem_expr_alloc		set_elem_options
 			;
diff --git a/src/scanner.l b/src/scanner.l
index 60b61a5..93e0499 100644
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
index 4149841..988cfeb 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -41,6 +41,8 @@ struct stmt *stmt_alloc(const struct location *loc,
 
 void stmt_free(struct stmt *stmt)
 {
+	if (stmt == NULL)
+		return;
 	if (stmt->ops->destroy)
 		stmt->ops->destroy(stmt);
 	xfree(stmt);
@@ -103,6 +105,37 @@ struct stmt *verdict_stmt_alloc(const struct location *loc, struct expr *expr)
 	return stmt;
 }
 
+static void flow_stmt_print(const struct stmt *stmt)
+{
+	printf("flow ");
+	if (stmt->flow.set) {
+		expr_print(stmt->flow.set);
+		printf(" ");
+	}
+	expr_print(stmt->flow.key);
+	printf(" ");
+	stmt_print(stmt->flow.stmt);
+}
+
+static void flow_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->flow.key);
+	expr_free(stmt->flow.set);
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
2.5.5

