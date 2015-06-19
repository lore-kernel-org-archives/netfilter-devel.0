From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: add tee statement
Date: Fri, 19 Jun 2015 12:26:34 +0200
Message-ID: <1434709594-6460-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37675 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbbFSKVQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 06:21:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows you to clone packets to some destination, eg.

... tee gateway 172.20.0.2
... tee oifname tap0 gateway ip saddr map { 192.168.0.2 : 172.20.0.2, ... }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/statement.h       |    9 +++++++++
 src/evaluate.c            |   21 +++++++++++++++++++--
 src/netlink_delinearize.c |   39 +++++++++++++++++++++++++++++++++++++++
 src/netlink_linearize.c   |   21 +++++++++++++++++++++
 src/parser_bison.y        |   18 ++++++++++++++++++
 src/scanner.l             |    2 ++
 src/statement.c           |   29 +++++++++++++++++++++++++++++
 7 files changed, 137 insertions(+), 2 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 48e6130..5c8e08d 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -103,6 +103,12 @@ struct ct_stmt {
 extern struct stmt *ct_stmt_alloc(const struct location *loc,
 				  enum nft_ct_keys key,
 				  struct expr *expr);
+struct tee_stmt {
+	struct expr		*gw;
+	const char		*oifname;
+};
+
+struct stmt *tee_stmt_alloc(const struct location *loc);
 
 struct set_stmt {
 	struct expr		*set;
@@ -129,6 +135,7 @@ extern struct stmt *set_stmt_alloc(const struct location *loc);
  * @STMT_QUEUE:		QUEUE statement
  * @STMT_CT:		conntrack statement
  * @STMT_SET:		set statement
+ * @STMT_TEE:		tee statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -145,6 +152,7 @@ enum stmt_types {
 	STMT_QUEUE,
 	STMT_CT,
 	STMT_SET,
+	STMT_TEE,
 };
 
 /**
@@ -195,6 +203,7 @@ struct stmt {
 		struct queue_stmt	queue;
 		struct ct_stmt		ct;
 		struct set_stmt		set;
+		struct tee_stmt		tee;
 	};
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index d99b38f..f29c716 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1557,7 +1557,7 @@ static int nat_evaluate_family(struct eval_ctx *ctx, struct stmt *stmt)
 	}
 }
 
-static int nat_evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
+static int evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
 			     struct expr **expr)
 {
 	struct proto_ctx *pctx = &ctx->pctx;
@@ -1599,7 +1599,7 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 		return err;
 
 	if (stmt->nat.addr != NULL) {
-		err = nat_evaluate_addr(ctx, stmt, &stmt->nat.addr);
+		err = evaluate_addr(ctx, stmt, &stmt->nat.addr);
 		if (err < 0)
 			return err;
 	}
@@ -1643,6 +1643,21 @@ static int stmt_evaluate_redir(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_tee(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	int err;
+
+	err = nat_evaluate_family(ctx, stmt);
+	if (err < 0)
+		return err;
+
+	err = evaluate_addr(ctx, stmt, &stmt->tee.gw);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
 static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	if (stmt->queue.queue != NULL) {
@@ -1726,6 +1741,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_redir(ctx, stmt);
 	case STMT_QUEUE:
 		return stmt_evaluate_queue(ctx, stmt);
+	case STMT_TEE:
+		return stmt_evaluate_tee(ctx, stmt);
 	case STMT_SET:
 		return stmt_evaluate_set(ctx, stmt);
 	default:
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 6d60be3..d0f9154 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -747,6 +747,40 @@ static void netlink_parse_redir(struct netlink_parse_ctx *ctx,
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
+static void netlink_parse_tee(struct netlink_parse_ctx *ctx,
+			      const struct location *loc,
+			      const struct nft_rule_expr *nle)
+{
+	struct stmt *stmt;
+	struct expr *addr;
+	enum nft_registers reg1;
+
+	stmt = tee_stmt_alloc(loc);
+
+	reg1 = netlink_parse_register(nle, NFT_EXPR_TEE_SREG_GW);
+	if (reg1) {
+		addr = netlink_get_register(ctx, loc, reg1);
+		if (addr == NULL)
+			return netlink_error(ctx, loc,
+					     "TEE statement has no address "
+					     "expression");
+
+		if (ctx->table->handle.family == NFPROTO_IPV4)
+			expr_set_type(addr, &ipaddr_type, BYTEORDER_BIG_ENDIAN);
+		else
+			expr_set_type(addr, &ip6addr_type,
+				      BYTEORDER_BIG_ENDIAN);
+		stmt->tee.gw = addr;
+	}
+
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_TEE_OIFNAME)) {
+		stmt->tee.oifname =
+			strdup(nft_rule_expr_get_str(nle, NFT_EXPR_TEE_OIFNAME));
+	}
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
 static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
 			      const struct nft_rule_expr *nle)
@@ -835,6 +869,7 @@ static const struct {
 	{ .name = "nat",	.parse = netlink_parse_nat },
 	{ .name = "masq",	.parse = netlink_parse_masq },
 	{ .name = "redir",	.parse = netlink_parse_redir },
+	{ .name = "tee",	.parse = netlink_parse_tee },
 	{ .name = "queue",	.parse = netlink_parse_queue },
 	{ .name = "dynset",	.parse = netlink_parse_dynset },
 };
@@ -1365,6 +1400,10 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		case STMT_SET:
 			expr_postprocess(&rctx, &stmt->set.key);
 			break;
+		case STMT_TEE:
+			if (stmt->tee.gw!= NULL)
+				expr_postprocess(&rctx, &stmt->tee.gw);
+			break;
 		default:
 			break;
 		}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index bf1e56b..2a4f567 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -802,6 +802,25 @@ static void netlink_gen_redir_stmt(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_tee_stmt(struct netlink_linearize_ctx *ctx,
+				 const struct stmt *stmt)
+{
+	struct nft_rule_expr *nle;
+	const char *oifname = stmt->tee.oifname;
+	enum nft_registers sreg_gw;
+
+	nle = alloc_nft_expr("tee");
+
+	sreg_gw = get_register(ctx, stmt->tee.gw);
+	netlink_gen_expr(ctx, stmt->tee.gw, sreg_gw);
+	netlink_put_register(nle, NFT_EXPR_TEE_SREG_GW, sreg_gw);
+	release_register(ctx, stmt->tee.gw);
+
+	if (oifname != NULL)
+		nft_rule_expr_set_str(nle, NFT_EXPR_TEE_OIFNAME, oifname);
+	nft_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
@@ -892,6 +911,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_masq_stmt(ctx, stmt);
 	case STMT_REDIR:
 		return netlink_gen_redir_stmt(ctx, stmt);
+	case STMT_TEE:
+		return netlink_gen_tee_stmt(ctx, stmt);
 	case STMT_QUEUE:
 		return netlink_gen_queue_stmt(ctx, stmt);
 	case STMT_CT:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5c4e272..16c17e6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -390,6 +390,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token BYPASS			"bypass"
 %token FANOUT			"fanout"
 
+%token TEE			"tee"
+
 %token POSITION			"position"
 %token COMMENT			"comment"
 
@@ -457,6 +459,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
 %type <val>			queue_stmt_flags queue_stmt_flag
+%type <stmt>			tee_stmt
+%destructor { stmt_free($$); }	tee_stmt
 %type <stmt>			set_stmt
 %destructor { stmt_free($$); }	set_stmt
 %type <val>			set_stmt_op
@@ -1275,6 +1279,7 @@ stmt			:	verdict_stmt
 			|	ct_stmt
 			|	masq_stmt
 			|	redir_stmt
+			|	tee_stmt
 			|	set_stmt
 			;
 
@@ -1538,6 +1543,19 @@ redir_stmt_arg		:	TO	expr
 			}
 			;
 
+tee_stmt		:	TEE	GATEWAY	expr
+			{
+				$$ = tee_stmt_alloc(&@$);
+				$$->tee.gw = $3;
+			}
+			|	TEE	OIFNAME	string	GATEWAY expr
+			{
+				$$ = tee_stmt_alloc(&@$);
+				$$->tee.oifname = strdup($3);
+				$$->tee.gw = $5;
+			}
+			;
+
 nf_nat_flags		:	nf_nat_flag
 			|	nf_nat_flags	COMMA	nf_nat_flag
 			{
diff --git a/src/scanner.l b/src/scanner.l
index 985ea2a..d4f706f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -454,6 +454,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "proto-dst"		{ return PROTO_DST; }
 "label"			{ return LABEL; }
 
+"tee"			{ return TEE; }
+
 "xml"			{ return XML; }
 "json"			{ return JSON; }
 
diff --git a/src/statement.c b/src/statement.c
index 9ebc593..267be5e 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -408,3 +408,32 @@ struct stmt *set_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &set_stmt_ops);
 }
+
+static void tee_stmt_print(const struct stmt *stmt)
+{
+	printf("tee");
+	if (stmt->tee.oifname != NULL)
+		printf(" oifname %s", stmt->tee.oifname);
+
+	printf(" gateway ");
+	expr_print(stmt->tee.gw);
+}
+
+static void tee_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->tee.gw);
+	if (stmt->tee.oifname != NULL)
+		xfree(stmt->tee.oifname);
+}
+
+static const struct stmt_ops tee_stmt_ops = {
+	.type		= STMT_TEE,
+	.name		= "tee",
+	.print		= tee_stmt_print,
+	.destroy	= tee_stmt_destroy,
+};
+
+struct stmt *tee_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &tee_stmt_ops);
+}
-- 
1.7.10.4

