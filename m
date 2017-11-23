From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: deprecate "flow table" syntax, replace it by "meter"
Date: Thu, 23 Nov 2017 15:23:22 +0100
Message-ID: <20171123142322.6444-1-pablo@netfilter.org>
Cc: rwhite@pobox.com, neal.p.murphy@alum.wpi.edu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58628 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752020AbdKWOXd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Nov 2017 09:23:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 282FF303D13
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2017 15:23:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 12149DA86B
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2017 15:23:32 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

According to bugzilla 1137: "flow tables" should not be syntactically
unique.

"Flow tables are always named, but they don't conform to the way sets,
maps, and dictionaries work in terms of "add" and "delete" and all that.

They are also "flow tables" instead of one word like "flows" or
"throttle" or something.

It seems weird to just have these break the syntactic expectations."

Personally, I never liked the reference to "table" since we have very
specific semantics in terms of what a "table" is netfilter for long
time.

This patch promotes "meter" as the new keyword. The former syntax is
still accepted for a while, just to reduce chances of breaking things.
At some point the former syntax will just be removed.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1137
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h                                     |  6 +-
 include/statement.h                                | 12 ++--
 src/evaluate.c                                     | 36 ++++++------
 src/netlink_delinearize.c                          | 12 ++--
 src/netlink_linearize.c                            | 26 ++++-----
 src/parser_bison.y                                 | 68 ++++++++++++++--------
 src/rule.c                                         | 10 ++--
 src/scanner.l                                      |  2 +
 src/statement.c                                    | 34 +++++------
 tests/py/ip/flowtable.t                            |  2 +-
 tests/py/ip/flowtable.t.payload                    |  2 +-
 tests/py/ip6/flowtable.t                           |  4 +-
 tests/py/ip6/flowtable.t.payload                   |  4 +-
 .../testcases/sets/0022type_selective_flush_0      |  6 +-
 14 files changed, 125 insertions(+), 99 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index c59bcea75210..4912aa168357 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -361,6 +361,8 @@ enum cmd_ops {
  * @CMD_OBJ_EXPR:	expression
  * @CMD_OBJ_MONITOR:	monitor
  * @CMD_OBJ_EXPORT:	export
+ * @CMD_OBJ_METER:	meter
+ * @CMD_OBJ_METERS:	meters
  * @CMD_OBJ_COUNTER:	counter
  * @CMD_OBJ_COUNTERS:	multiple counters
  * @CMD_OBJ_QUOTA:	quota
@@ -381,8 +383,8 @@ enum cmd_obj {
 	CMD_OBJ_EXPR,
 	CMD_OBJ_MONITOR,
 	CMD_OBJ_EXPORT,
-	CMD_OBJ_FLOWTABLE,
-	CMD_OBJ_FLOWTABLES,
+	CMD_OBJ_METER,
+	CMD_OBJ_METERS,
 	CMD_OBJ_MAP,
 	CMD_OBJ_MAPS,
 	CMD_OBJ_COUNTER,
diff --git a/include/statement.h b/include/statement.h
index 2f702c3c5d36..23a551b67f2b 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -165,14 +165,14 @@ struct set_stmt {
 
 extern struct stmt *set_stmt_alloc(const struct location *loc);
 
-struct flow_stmt {
+struct meter_stmt {
 	struct expr		*set;
 	struct expr		*key;
 	struct stmt		*stmt;
-	const char		*table;
+	const char		*name;
 };
 
-extern struct stmt *flow_stmt_alloc(const struct location *loc);
+extern struct stmt *meter_stmt_alloc(const struct location *loc);
 
 /**
  * enum nft_xt_type - xtables statement types
@@ -209,7 +209,7 @@ struct xt_stmt {
  * @STMT_INVALID:	uninitialised
  * @STMT_EXPRESSION:	expression statement (relational)
  * @STMT_VERDICT:	verdict statement
- * @STMT_FLOW:		flow statement
+ * @STMT_METER:		meter statement
  * @STMT_COUNTER:	counters
  * @STMT_PAYLOAD:	payload statement
  * @STMT_META:		meta statement
@@ -234,7 +234,7 @@ enum stmt_types {
 	STMT_INVALID,
 	STMT_EXPRESSION,
 	STMT_VERDICT,
-	STMT_FLOW,
+	STMT_METER,
 	STMT_COUNTER,
 	STMT_PAYLOAD,
 	STMT_META,
@@ -296,7 +296,7 @@ struct stmt {
 	union {
 		struct expr		*expr;
 		struct exthdr_stmt	exthdr;
-		struct flow_stmt	flow;
+		struct meter_stmt	meter;
 		struct counter_stmt	counter;
 		struct payload_stmt	payload;
 		struct meta_stmt	meta;
diff --git a/src/evaluate.c b/src/evaluate.c
index fd61e7530d2e..3d4824ff80d6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2021,37 +2021,37 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 	return expr_evaluate(ctx, &stmt->payload.val);
 }
 
-static int stmt_evaluate_flow(struct eval_ctx *ctx, struct stmt *stmt)
+static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct expr *key, *set, *setref;
 
 	expr_set_context(&ctx->ectx, NULL, 0);
-	if (expr_evaluate(ctx, &stmt->flow.key) < 0)
+	if (expr_evaluate(ctx, &stmt->meter.key) < 0)
 		return -1;
-	if (expr_is_constant(stmt->flow.key))
-		return expr_error(ctx->msgs, stmt->flow.key,
+	if (expr_is_constant(stmt->meter.key))
+		return expr_error(ctx->msgs, stmt->meter.key,
 				  "Flow key expression can not be constant");
-	if (stmt->flow.key->comment)
-		return expr_error(ctx->msgs, stmt->flow.key,
+	if (stmt->meter.key->comment)
+		return expr_error(ctx->msgs, stmt->meter.key,
 				  "Flow key expression can not contain comments");
 
 	/* Declare an empty set */
-	key = stmt->flow.key;
+	key = stmt->meter.key;
 	set = set_expr_alloc(&key->location, NULL);
 	set->set_flags |= NFT_SET_EVAL;
 	if (key->timeout)
 		set->set_flags |= NFT_SET_TIMEOUT;
 
-	setref = implicit_set_declaration(ctx, stmt->flow.table ?: "__ft%d",
+	setref = implicit_set_declaration(ctx, stmt->meter.name ?: "__mt%d",
 					  key, set);
 
-	stmt->flow.set = setref;
+	stmt->meter.set = setref;
 
-	if (stmt_evaluate(ctx, stmt->flow.stmt) < 0)
+	if (stmt_evaluate(ctx, stmt->meter.stmt) < 0)
 		return -1;
-	if (!(stmt->flow.stmt->flags & STMT_F_STATEFUL))
-		return stmt_binary_error(ctx, stmt->flow.stmt, stmt,
-					 "Per-flow statement must be stateful");
+	if (!(stmt->meter.stmt->flags & STMT_F_STATEFUL))
+		return stmt_binary_error(ctx, stmt->meter.stmt, stmt,
+					 "meter statement must be stateful");
 
 	return 0;
 }
@@ -2782,8 +2782,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_payload(ctx, stmt);
 	case STMT_EXTHDR:
 		return stmt_evaluate_exthdr(ctx, stmt);
-	case STMT_FLOW:
-		return stmt_evaluate_flow(ctx, stmt);
+	case STMT_METER:
+		return stmt_evaluate_meter(ctx, stmt);
 	case STMT_META:
 		return stmt_evaluate_meta(ctx, stmt);
 	case STMT_CT:
@@ -3151,7 +3151,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return cmd_error(ctx, "Could not process rule: Set '%s' does not exist",
 					 cmd->handle.set);
 		return 0;
-	case CMD_OBJ_FLOWTABLE:
+	case CMD_OBJ_METER:
 		table = table_lookup(&cmd->handle, ctx->cache);
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
@@ -3201,7 +3201,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		return 0;
 	case CMD_OBJ_CHAINS:
 	case CMD_OBJ_RULESET:
-	case CMD_OBJ_FLOWTABLES:
+	case CMD_OBJ_METERS:
 	case CMD_OBJ_MAPS:
 		return 0;
 	default:
@@ -3276,7 +3276,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 			return cmd_error(ctx, "Could not process rule: Map '%s' does not exist",
 					 cmd->handle.set);
 		return 0;
-	case CMD_OBJ_FLOWTABLE:
+	case CMD_OBJ_METER:
 		table = table_lookup(&cmd->handle, ctx->cache);
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 44328879ebb8..67dbd27dd7a7 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1143,10 +1143,10 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 	}
 
 	if (dstmt != NULL) {
-		stmt = flow_stmt_alloc(loc);
-		stmt->flow.set  = set_ref_expr_alloc(loc, set);
-		stmt->flow.key  = expr;
-		stmt->flow.stmt = dstmt;
+		stmt = meter_stmt_alloc(loc);
+		stmt->meter.set  = set_ref_expr_alloc(loc, set);
+		stmt->meter.key  = expr;
+		stmt->meter.stmt = dstmt;
 	} else {
 		stmt = set_stmt_alloc(loc);
 		stmt->set.set   = set_ref_expr_alloc(loc, set);
@@ -2209,8 +2209,8 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		case STMT_PAYLOAD:
 			stmt_payload_postprocess(&rctx);
 			break;
-		case STMT_FLOW:
-			expr_postprocess(&rctx, &stmt->flow.key);
+		case STMT_METER:
+			expr_postprocess(&rctx, &stmt->meter.key);
 			break;
 		case STMT_META:
 			if (stmt->meta.expr != NULL)
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index fb2d2501ce9b..cf6ffdb05ebf 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1204,7 +1204,7 @@ static void netlink_gen_notrack_stmt(struct netlink_linearize_ctx *ctx,
 static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
-	struct set *set = stmt->flow.set->set;
+	struct set *set = stmt->meter.set->set;
 	struct nftnl_expr *nle;
 	enum nft_registers sreg_key;
 
@@ -1223,34 +1223,34 @@ static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
-static void netlink_gen_flow_stmt(struct netlink_linearize_ctx *ctx,
-				  const struct stmt *stmt)
+static void netlink_gen_meter_stmt(struct netlink_linearize_ctx *ctx,
+				   const struct stmt *stmt)
 {
 	struct nftnl_expr *nle;
 	enum nft_registers sreg_key;
 	enum nft_dynset_ops op;
 	struct set *set;
 
-	sreg_key = get_register(ctx, stmt->flow.key->key);
-	netlink_gen_expr(ctx, stmt->flow.key->key, sreg_key);
-	release_register(ctx, stmt->flow.key->key);
+	sreg_key = get_register(ctx, stmt->meter.key->key);
+	netlink_gen_expr(ctx, stmt->meter.key->key, sreg_key);
+	release_register(ctx, stmt->meter.key->key);
 
-	set = stmt->flow.set->set;
-	if (stmt->flow.key->timeout)
+	set = stmt->meter.set->set;
+	if (stmt->meter.key->timeout)
 		op = NFT_DYNSET_OP_UPDATE;
 	else
 		op = NFT_DYNSET_OP_ADD;
 
 	nle = alloc_nft_expr("dynset");
 	netlink_put_register(nle, NFTNL_EXPR_DYNSET_SREG_KEY, sreg_key);
-	if (stmt->flow.key->timeout)
+	if (stmt->meter.key->timeout)
 		nftnl_expr_set_u64(nle, NFTNL_EXPR_DYNSET_TIMEOUT,
-				   stmt->flow.key->timeout);
+				   stmt->meter.key->timeout);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_OP, op);
 	nftnl_expr_set_str(nle, NFTNL_EXPR_DYNSET_SET_NAME, set->handle.set);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_SET_ID, set->handle.set_id);
 	nftnl_expr_set(nle, NFTNL_EXPR_DYNSET_EXPR,
-		       netlink_gen_stmt_stateful(ctx, stmt->flow.stmt), 0);
+		       netlink_gen_stmt_stateful(ctx, stmt->meter.stmt), 0);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
@@ -1264,8 +1264,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_expr(ctx, stmt->expr, NFT_REG_VERDICT);
 	case STMT_VERDICT:
 		return netlink_gen_verdict_stmt(ctx, stmt);
-	case STMT_FLOW:
-		return netlink_gen_flow_stmt(ctx, stmt);
+	case STMT_METER:
+		return netlink_gen_meter_stmt(ctx, stmt);
 	case STMT_EXTHDR:
 		return netlink_gen_exthdr_stmt(ctx, stmt);
 	case STMT_PAYLOAD:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index c64c3979eb04..6610b9dccc3c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -243,6 +243,8 @@ int nft_lex(void *, void *, void *);
 %token SIZE			"size"
 
 %token FLOW			"flow"
+%token METER			"meter"
+%token METERS			"meters"
 
 %token <val> NUM		"number"
 %token <string> STRING		"string"
@@ -555,8 +557,8 @@ int nft_lex(void *, void *, void *);
 %type <stmt>			set_stmt
 %destructor { stmt_free($$); }	set_stmt
 %type <val>			set_stmt_op
-%type <stmt>			flow_stmt flow_stmt_alloc
-%destructor { stmt_free($$); }	flow_stmt flow_stmt_alloc
+%type <stmt>			meter_stmt meter_stmt_alloc
+%destructor { stmt_free($$); }	meter_stmt meter_stmt_alloc
 
 %type <expr>			symbol_expr verdict_expr integer_expr variable_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr
@@ -606,8 +608,8 @@ int nft_lex(void *, void *, void *);
 %type <expr>			set_elem_expr_stmt set_elem_expr_stmt_alloc
 %destructor { expr_free($$); }	set_elem_expr_stmt set_elem_expr_stmt_alloc
 
-%type <expr>			flow_key_expr flow_key_expr_alloc
-%destructor { expr_free($$); }	flow_key_expr flow_key_expr_alloc
+%type <expr>			meter_key_expr meter_key_expr_alloc
+%destructor { expr_free($$); }	meter_key_expr meter_key_expr_alloc
 
 %type <expr>			expr initializer_expr keyword_expr
 %destructor { expr_free($$); }	expr initializer_expr keyword_expr
@@ -1084,11 +1086,19 @@ list_cmd		:	TABLE		table_spec
 			}
 			|	FLOW TABLES	ruleset_spec
 			{
-				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_FLOWTABLES, &$3, &@$, NULL);
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_METERS, &$3, &@$, NULL);
 			}
 			|	FLOW TABLE	set_spec
 			{
-				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_FLOWTABLE, &$3, &@$, NULL);
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_METER, &$3, &@$, NULL);
+			}
+			|	METERS		ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_METERS, &$2, &@$, NULL);
+			}
+			|	METER		set_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_METER, &$2, &@$, NULL);
 			}
 			|	MAPS		ruleset_spec
 			{
@@ -1152,7 +1162,11 @@ flush_cmd		:	TABLE		table_spec
 			}
 			|	FLOW TABLE	set_spec
 			{
-				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_FLOWTABLE, &$3, &@$, NULL);
+				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_METER, &$3, &@$, NULL);
+			}
+			|	METER		set_spec
+			{
+				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_METER, &$2, &@$, NULL);
 			}
 			|	RULESET		ruleset_spec
 			{
@@ -1782,7 +1796,7 @@ stmt_list		:	stmt
 
 stmt			:	verdict_stmt
 			|	match_stmt
-			|	flow_stmt
+			|	meter_stmt
 			|	counter_stmt
 			|	payload_stmt
 			|	meta_stmt
@@ -2468,38 +2482,46 @@ set_stmt_op		:	ADD	{ $$ = NFT_DYNSET_OP_ADD; }
 			|	UPDATE	{ $$ = NFT_DYNSET_OP_UPDATE; }
 			;
 
-flow_stmt		:	flow_stmt_alloc		flow_stmt_opts	'{' flow_key_expr stmt '}'
+meter_stmt		:	meter_stmt_alloc		meter_stmt_opts	'{' meter_key_expr stmt '}'
 			{
-				$1->flow.key  = $4;
-				$1->flow.stmt = $5;
+				$1->meter.key  = $4;
+				$1->meter.stmt = $5;
 				$$->location  = @$;
 				$$ = $1;
 			}
-			|	flow_stmt_alloc		'{' flow_key_expr stmt '}'
+			|	meter_stmt_alloc		'{' meter_key_expr stmt '}'
 			{
-				$1->flow.key  = $3;
-				$1->flow.stmt = $4;
+				$1->meter.key  = $3;
+				$1->meter.stmt = $4;
 				$$->location  = @$;
 				$$ = $1;
 			}
 			;
 
-flow_stmt_alloc		:	FLOW
+meter_stmt_alloc	:	FLOW
+			{
+				$$ = meter_stmt_alloc(&@$);
+			}
+			|	METER
 			{
-				$$ = flow_stmt_alloc(&@$);
+				$$ = meter_stmt_alloc(&@$);
 			}
 			;
 
-flow_stmt_opts		:	flow_stmt_opt
+meter_stmt_opts		:	meter_stmt_opt
 			{
 				$<stmt>$	= $<stmt>0;
 			}
-			|	flow_stmt_opts		flow_stmt_opt
+			|	meter_stmt_opts		meter_stmt_opt
 			;
 
-flow_stmt_opt		:	TABLE			identifier
+meter_stmt_opt		:	TABLE			identifier
+			{
+				$<stmt>0->meter.name = $2;
+			}
+			|	NAME			identifier
 			{
-				$<stmt>0->flow.table = $2;
+				$<stmt>0->meter.name = $2;
 			}
 			;
 
@@ -2738,15 +2760,15 @@ set_list_member_expr	:	opt_newline	set_expr	opt_newline
 			}
 			;
 
-flow_key_expr		:	flow_key_expr_alloc
-			|	flow_key_expr_alloc		set_elem_options
+meter_key_expr		:	meter_key_expr_alloc
+			|	meter_key_expr_alloc		set_elem_options
 			{
 				$$->location = @$;
 				$$ = $1;
 			}
 			;
 
-flow_key_expr_alloc	:	concat_expr
+meter_key_expr_alloc	:	concat_expr
 			{
 				$$ = set_elem_expr_alloc(&@1, $1);
 			}
diff --git a/src/rule.c b/src/rule.c
index 37d99c220047..cbc40e2d101c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -284,7 +284,7 @@ static void set_print_declaration(const struct set *set,
 	if (set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
 		type = "map";
 	else if (set->flags & NFT_SET_EVAL)
-		type = "flow table";
+		type = "meter";
 	else
 		type = "set";
 
@@ -1197,7 +1197,7 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 			    (set->flags & NFT_SET_ANONYMOUS ||
 			    set->flags & NFT_SET_MAP))
 				continue;
-			if (cmd->obj == CMD_OBJ_FLOWTABLES &&
+			if (cmd->obj == CMD_OBJ_METERS &&
 			    !(set->flags & NFT_SET_EVAL))
 				continue;
 			if (cmd->obj == CMD_OBJ_MAPS &&
@@ -1580,9 +1580,9 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_list_set(ctx, cmd, table);
 	case CMD_OBJ_RULESET:
 		return do_list_ruleset(ctx, cmd);
-	case CMD_OBJ_FLOWTABLES:
+	case CMD_OBJ_METERS:
 		return do_list_sets(ctx, cmd);
-	case CMD_OBJ_FLOWTABLE:
+	case CMD_OBJ_METER:
 		return do_list_set(ctx, cmd, table);
 	case CMD_OBJ_MAPS:
 		return do_list_sets(ctx, cmd);
@@ -1650,7 +1650,7 @@ static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 		return netlink_flush_chain(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
-	case CMD_OBJ_FLOWTABLE:
+	case CMD_OBJ_METER:
 		return netlink_flush_setelems(ctx, &cmd->handle,
 					      &cmd->location);
 	case CMD_OBJ_RULESET:
diff --git a/src/scanner.l b/src/scanner.l
index ee09775ebf1d..6f19eec9c11b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -292,6 +292,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "memory"		{ return MEMORY; }
 
 "flow"			{ return FLOW; }
+"meter"			{ return METER; }
+"meters"		{ return METERS; }
 
 "counter"		{ return COUNTER; }
 "name"			{ return NAME; }
diff --git a/src/statement.c b/src/statement.c
index 11d067f82e77..1f93260bd3d5 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -107,42 +107,42 @@ struct stmt *verdict_stmt_alloc(const struct location *loc, struct expr *expr)
 	return stmt;
 }
 
-static void flow_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
+static void meter_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	nft_print(octx, "flow ");
-	if (stmt->flow.set) {
-		expr_print(stmt->flow.set, octx);
+	nft_print(octx, "meter ");
+	if (stmt->meter.set) {
+		expr_print(stmt->meter.set, octx);
 		nft_print(octx, " ");
 	}
 	nft_print(octx, "{ ");
-	expr_print(stmt->flow.key, octx);
+	expr_print(stmt->meter.key, octx);
 	nft_print(octx, " ");
 
 	octx->stateless++;
-	stmt_print(stmt->flow.stmt, octx);
+	stmt_print(stmt->meter.stmt, octx);
 	octx->stateless--;
 
 	nft_print(octx, "} ");
 
 }
 
-static void flow_stmt_destroy(struct stmt *stmt)
+static void meter_stmt_destroy(struct stmt *stmt)
 {
-	expr_free(stmt->flow.key);
-	expr_free(stmt->flow.set);
-	stmt_free(stmt->flow.stmt);
+	expr_free(stmt->meter.key);
+	expr_free(stmt->meter.set);
+	stmt_free(stmt->meter.stmt);
 }
 
-static const struct stmt_ops flow_stmt_ops = {
-	.type		= STMT_FLOW,
-	.name		= "flow",
-	.print		= flow_stmt_print,
-	.destroy	= flow_stmt_destroy,
+static const struct stmt_ops meter_stmt_ops = {
+	.type		= STMT_METER,
+	.name		= "meter",
+	.print		= meter_stmt_print,
+	.destroy	= meter_stmt_destroy,
 };
 
-struct stmt *flow_stmt_alloc(const struct location *loc)
+struct stmt *meter_stmt_alloc(const struct location *loc)
 {
-	return stmt_alloc(loc, &flow_stmt_ops);
+	return stmt_alloc(loc, &meter_stmt_ops);
 }
 
 static void counter_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
diff --git a/tests/py/ip/flowtable.t b/tests/py/ip/flowtable.t
index 41d5d3bb0343..7eaf5731ea22 100644
--- a/tests/py/ip/flowtable.t
+++ b/tests/py/ip/flowtable.t
@@ -2,4 +2,4 @@
 
 *ip;test-ip;input
 
-flow table xyz { ip saddr timeout 30s counter};ok
+meter name xyz { ip saddr timeout 30s counter};ok
diff --git a/tests/py/ip/flowtable.t.payload b/tests/py/ip/flowtable.t.payload
index 591abf2bd06e..4dbd03d01926 100644
--- a/tests/py/ip/flowtable.t.payload
+++ b/tests/py/ip/flowtable.t.payload
@@ -1,4 +1,4 @@
-# flow table xyz { ip saddr timeout 30s counter}
+# meter name xyz { ip saddr timeout 30s counter}
 xyz test-ip 31
 xyz test-ip 0
 ip test-ip input 
diff --git a/tests/py/ip6/flowtable.t b/tests/py/ip6/flowtable.t
index cf0a6068f9c8..7a53f31aa67e 100644
--- a/tests/py/ip6/flowtable.t
+++ b/tests/py/ip6/flowtable.t
@@ -2,5 +2,5 @@
 
 *ip6;test-ip6;input
 
-flow table acct_out { meta iif . ip6 saddr timeout 600s counter };ok;flow table acct_out { iif . ip6 saddr timeout 10m counter}
-flow table acct_out { ip6 saddr . meta iif timeout 600s counter };ok;flow table acct_out { ip6 saddr . iif timeout 10m counter}
+meter name acct_out { meta iif . ip6 saddr timeout 600s counter };ok;meter name acct_out { iif . ip6 saddr timeout 10m counter}
+meter name acct_out { ip6 saddr . meta iif timeout 600s counter };ok;meter name acct_out { ip6 saddr . iif timeout 10m counter}
diff --git a/tests/py/ip6/flowtable.t.payload b/tests/py/ip6/flowtable.t.payload
index d3da5bad6333..cf2de733ca42 100644
--- a/tests/py/ip6/flowtable.t.payload
+++ b/tests/py/ip6/flowtable.t.payload
@@ -1,4 +1,4 @@
-# flow table acct_out { meta iif . ip6 saddr timeout 600s counter }
+# meter name acct_out { meta iif . ip6 saddr timeout 600s counter }
 acct_out test-ip6 31
 acct_out test-ip6 0
 ip6 test-ip6 input
@@ -6,7 +6,7 @@ ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 9 ]
   [ dynset update reg_key 1 set acct_out timeout 600000ms expr [ counter pkts 0 bytes 0 ] ]
 
-# flow table acct_out { ip6 saddr . meta iif timeout 600s counter }
+# meter name acct_out { ip6 saddr . meta iif timeout 600s counter }
 acct_out test-ip6 31
 acct_out test-ip6 0
 ip6 test-ip6 input
diff --git a/tests/shell/testcases/sets/0022type_selective_flush_0 b/tests/shell/testcases/sets/0022type_selective_flush_0
index f8878f7001a6..87a4c7bc4393 100755
--- a/tests/shell/testcases/sets/0022type_selective_flush_0
+++ b/tests/shell/testcases/sets/0022type_selective_flush_0
@@ -1,7 +1,7 @@
 #!/bin/bash
 
 # This tests the selectiveness of flush command on structures that use the
-# generic set infrastructure (sets, maps and flow tables).
+# generic set infrastructure (sets, maps and meters).
 
 tmpfile=$(mktemp)
 if [ ! -w $tmpfile ] ; then
@@ -16,7 +16,7 @@ add table t
 add chain t c
 add set t s {type ipv4_addr;}
 add map t m {type ipv4_addr : inet_service;}
-add rule t c tcp dport 80 flow table f {ip saddr limit rate 10/second}
+add rule t c tcp dport 80 meter name f {ip saddr limit rate 10/second}
 " >$tmpfile
 
 $NFT -f $tmpfile
@@ -26,7 +26,7 @@ $NFT -f $tmpfile
 declare -a cmds=(
 		"flush set t m" "flush set t f"
 		"flush map t s" "flush map t f"
-		"flush flow table t s" "flush flow table t m"
+		"flush meter name t s" "flush meter name t m"
 		)
 
 for i in "${cmds[@]}"
-- 
2.11.0

