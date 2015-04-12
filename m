From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 10/10] nftables: add set statement
Date: Sun, 12 Apr 2015 13:16:18 +0100
Message-ID: <1428840978-27226-11-git-send-email-kaber@trash.net>
References: <1428840978-27226-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58920 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbbDLMQb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 08:16:31 -0400
In-Reply-To: <1428840978-27226-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The set statement is used to dynamically add or update elements in a set.

Syntax:

# nft filter input set add tcp dport @myset
# nft filter input set add ip saddr timeout 10s @myset
# nft filter input set update ip saddr timeout 10s @myset

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/linux/netfilter/nf_tables.h | 27 ++++++++++++++++++++++++++
 include/statement.h                 | 11 +++++++++++
 src/evaluate.c                      | 28 ++++++++++++++++++++++++++-
 src/netlink_delinearize.c           | 38 +++++++++++++++++++++++++++++++++++++
 src/netlink_linearize.c             | 24 +++++++++++++++++++++++
 src/parser_bison.y                  | 18 ++++++++++++++++++
 src/scanner.l                       |  1 +
 src/statement.c                     | 31 ++++++++++++++++++++++++++++++
 8 files changed, 177 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 334b389..0e96443 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -516,6 +516,33 @@ enum nft_lookup_attributes {
 };
 #define NFTA_LOOKUP_MAX		(__NFTA_LOOKUP_MAX - 1)
 
+enum nft_dynset_ops {
+	NFT_DYNSET_OP_ADD,
+	NFT_DYNSET_OP_UPDATE,
+};
+
+/**
+ * enum nft_dynset_attributes - dynset expression attributes
+ *
+ * @NFTA_DYNSET_SET_NAME: name of set the to add data to (NLA_STRING)
+ * @NFTA_DYNSET_SET_ID: uniquely identifier of the set in the transaction (NLA_U32)
+ * @NFTA_DYNSET_OP: operation (NLA_U32)
+ * @NFTA_DYNSET_SREG_KEY: source register of the key (NLA_U32)
+ * @NFTA_DYNSET_SREG_DATA: source register of the data (NLA_U32)
+ * @NFTA_DYNSET_TIMEOUT: timeout value for the new element (NLA_U64)
+ */
+enum nft_dynset_attributes {
+	NFTA_DYNSET_UNSPEC,
+	NFTA_DYNSET_SET_NAME,
+	NFTA_DYNSET_SET_ID,
+	NFTA_DYNSET_OP,
+	NFTA_DYNSET_SREG_KEY,
+	NFTA_DYNSET_SREG_DATA,
+	NFTA_DYNSET_TIMEOUT,
+	__NFTA_DYNSET_MAX,
+};
+#define NFTA_DYNSET_MAX		(__NFTA_DYNSET_MAX - 1)
+
 /**
  * enum nft_payload_bases - nf_tables payload expression offset bases
  *
diff --git a/include/statement.h b/include/statement.h
index d143121..48e6130 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -104,6 +104,14 @@ extern struct stmt *ct_stmt_alloc(const struct location *loc,
 				  enum nft_ct_keys key,
 				  struct expr *expr);
 
+struct set_stmt {
+	struct expr		*set;
+	struct expr		*key;
+	enum nft_dynset_ops	op;
+};
+
+extern struct stmt *set_stmt_alloc(const struct location *loc);
+
 /**
  * enum stmt_types - statement types
  *
@@ -120,6 +128,7 @@ extern struct stmt *ct_stmt_alloc(const struct location *loc,
  * @STMT_REDIR:		redirect statement
  * @STMT_QUEUE:		QUEUE statement
  * @STMT_CT:		conntrack statement
+ * @STMT_SET:		set statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -135,6 +144,7 @@ enum stmt_types {
 	STMT_REDIR,
 	STMT_QUEUE,
 	STMT_CT,
+	STMT_SET,
 };
 
 /**
@@ -184,6 +194,7 @@ struct stmt {
 		struct redir_stmt	redir;
 		struct queue_stmt	queue;
 		struct ct_stmt		ct;
+		struct set_stmt		set;
 	};
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 04ca08d..e260a80 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -614,7 +614,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 	struct expr *i, *next;
 
 	list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
-		if (dtype && off == 0)
+		if (expr_is_constant(*expr) && dtype && off == 0)
 			return expr_binary_error(ctx->msgs, i, *expr,
 						 "unexpected concat component, "
 						 "expecting %s",
@@ -1661,6 +1661,30 @@ static int stmt_evaluate_log(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	expr_set_context(&ctx->ectx, NULL, 0);
+	if (expr_evaluate(ctx, &stmt->set.set) < 0)
+		return -1;
+	if (stmt->set.set->ops->type != EXPR_SET_REF)
+		return expr_error(ctx->msgs, stmt->set.set,
+				  "Expression does not refer to a set");
+
+	if (stmt_evaluate_arg(ctx, stmt,
+			      stmt->set.set->set->keytype,
+			      stmt->set.set->set->keylen,
+			      &stmt->set.key) < 0)
+		return -1;
+	if (expr_is_constant(stmt->set.key))
+		return expr_error(ctx->msgs, stmt->set.key,
+				  "Key expression can not be constant");
+	if (stmt->set.key->comment != NULL)
+		return expr_error(ctx->msgs, stmt->set.key,
+				  "Key expression comments are not supported");
+
+	return 0;
+}
+
 int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 {
 #ifdef DEBUG
@@ -1695,6 +1719,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_redir(ctx, stmt);
 	case STMT_QUEUE:
 		return stmt_evaluate_queue(ctx, stmt);
+	case STMT_SET:
+		return stmt_evaluate_set(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index c564a8a..89d8522 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -694,6 +694,40 @@ static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
+static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
+				 const struct location *loc,
+				 const struct nft_rule_expr *nle)
+{
+	struct expr *expr;
+	struct stmt *stmt;
+	struct set *set;
+	enum nft_registers sreg;
+	const char *name;
+
+	sreg = netlink_parse_register(nle, NFT_EXPR_DYNSET_SREG_KEY);
+	expr = netlink_get_register(ctx, loc, sreg);
+	if (expr == NULL)
+		return netlink_error(ctx, loc,
+				     "Dynset statement has no key expression");
+
+	expr = set_elem_expr_alloc(&expr->location, expr);
+	expr->timeout = nft_rule_expr_get_u64(nle, NFT_EXPR_DYNSET_TIMEOUT);
+
+	name = nft_rule_expr_get_str(nle, NFT_EXPR_DYNSET_SET_NAME);
+	set  = set_lookup(ctx->table, name);
+	if (set == NULL)
+		return netlink_error(ctx, loc,
+				     "Unknown set '%s' in dynset statement",
+				     name);
+
+	stmt = set_stmt_alloc(loc);
+	stmt->set.set = set_ref_expr_alloc(loc, set);
+	stmt->set.op  = nft_rule_expr_get_u32(nle, NFT_EXPR_DYNSET_OP);
+	stmt->set.key = expr;
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
 static const struct {
 	const char	*name;
 	void		(*parse)(struct netlink_parse_ctx *ctx,
@@ -717,6 +751,7 @@ static const struct {
 	{ .name = "masq",	.parse = netlink_parse_masq },
 	{ .name = "redir",	.parse = netlink_parse_redir },
 	{ .name = "queue",	.parse = netlink_parse_queue },
+	{ .name = "dynset",	.parse = netlink_parse_dynset },
 };
 
 static int netlink_parse_expr(struct nft_rule_expr *nle, void *arg)
@@ -1140,6 +1175,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		case STMT_REJECT:
 			stmt_reject_postprocess(rctx, stmt);
 			break;
+		case STMT_SET:
+			expr_postprocess(&rctx, stmt, &stmt->set.key);
+			break;
 		default:
 			break;
 		}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index d1414c1..09ba2ef 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -800,6 +800,28 @@ static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
+				 const struct stmt *stmt)
+{
+	struct nft_rule_expr *nle;
+	enum nft_registers sreg_key;
+
+	sreg_key = get_register(ctx);
+	netlink_gen_expr(ctx, stmt->set.key, sreg_key);
+	release_register(ctx);
+
+	nle = alloc_nft_expr("dynset");
+	netlink_put_register(nle, NFT_EXPR_DYNSET_SREG_KEY, sreg_key);
+	nft_rule_expr_set_u64(nle, NFT_EXPR_DYNSET_TIMEOUT,
+			      stmt->set.key->timeout);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_DYNSET_OP, stmt->set.op);
+	nft_rule_expr_set_str(nle, NFT_EXPR_DYNSET_SET_NAME,
+			      stmt->set.set->set->handle.set);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_DYNSET_SET_ID,
+			      stmt->set.set->set->handle.set_id);
+	nft_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 			     const struct stmt *stmt)
 {
@@ -828,6 +850,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_queue_stmt(ctx, stmt);
 	case STMT_CT:
 		return netlink_gen_ct_stmt(ctx, stmt);
+	case STMT_SET:
+		return netlink_gen_set_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0f2d71a..eac3fcb 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -181,6 +181,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token INET			"inet"
 
 %token ADD			"add"
+%token UPDATE			"update"
 %token CREATE			"create"
 %token INSERT			"insert"
 %token DELETE			"delete"
@@ -456,6 +457,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
 %type <val>			queue_stmt_flags queue_stmt_flag
+%type <stmt>			set_stmt
+%destructor { stmt_free($$); }	set_stmt
+%type <val>			set_stmt_op
 
 %type <expr>			symbol_expr verdict_expr integer_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr
@@ -1267,6 +1271,7 @@ stmt			:	verdict_stmt
 			|	ct_stmt
 			|	masq_stmt
 			|	redir_stmt
+			|	set_stmt
 			;
 
 verdict_stmt		:	verdict_expr
@@ -1579,6 +1584,19 @@ queue_stmt_flag		:	BYPASS	{ $$ = NFT_QUEUE_FLAG_BYPASS; }
 			|	FANOUT	{ $$ = NFT_QUEUE_FLAG_CPU_FANOUT; }
 			;
 
+set_stmt		:	SET	set_stmt_op	set_elem_expr	symbol_expr
+			{
+				$$ = set_stmt_alloc(&@$);
+				$$->set.op  = $2;
+				$$->set.key = $3;
+				$$->set.set = $4;
+			}
+			;
+
+set_stmt_op		:	ADD	{ $$ = NFT_DYNSET_OP_ADD; }
+			|	UPDATE	{ $$ = NFT_DYNSET_OP_UPDATE; }
+			;
+
 match_stmt		:	relational_expr
 			{
 				$$ = expr_stmt_alloc(&@$, $1);
diff --git a/src/scanner.l b/src/scanner.l
index 4231d27..985ea2a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -257,6 +257,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "inet"			{ return INET; }
 
 "add"			{ return ADD; }
+"update"		{ return UPDATE; }
 "create"		{ return CREATE; }
 "insert"		{ return INSERT; }
 "delete"		{ return DELETE; }
diff --git a/src/statement.c b/src/statement.c
index d72c6e9..9ebc593 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -377,3 +377,34 @@ struct stmt *redir_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &redir_stmt_ops);
 }
+
+static const char * const set_stmt_op_names[] = {
+	[NFT_DYNSET_OP_ADD]	= "add",
+	[NFT_DYNSET_OP_UPDATE]	= "update",
+};
+
+static void set_stmt_print(const struct stmt *stmt)
+{
+	printf("set %s ", set_stmt_op_names[stmt->set.op]);
+	expr_print(stmt->set.key);
+	printf(" ");
+	expr_print(stmt->set.set);
+}
+
+static void set_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->set.key);
+	expr_free(stmt->set.set);
+}
+
+static const struct stmt_ops set_stmt_ops = {
+	.type		= STMT_SET,
+	.name		= "set",
+	.print		= set_stmt_print,
+	.destroy	= set_stmt_destroy,
+};
+
+struct stmt *set_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &set_stmt_ops);
+}
-- 
2.1.0

