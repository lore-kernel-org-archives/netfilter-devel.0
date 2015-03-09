From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] src: add tee statement support
Date: Mon, 09 Mar 2015 20:38:20 +0100
Message-ID: <20150309193820.6763.36920.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39424 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753029AbbCITib (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Mar 2015 15:38:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The syntax is:
 tee gw <addr> [oifname <str>]

Only valid in IPv4/IPv6 families. No inet/bridge/arp support by now.
No limits regarding chain hooks.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/statement.h       |    9 +++++++++
 src/evaluate.c            |   30 +++++++++++++++++++++++++++---
 src/netlink_delinearize.c |   32 ++++++++++++++++++++++++++++++++
 src/netlink_linearize.c   |   17 +++++++++++++++++
 src/parser_bison.y        |   25 +++++++++++++++++++++++++
 src/scanner.l             |    3 +++
 src/statement.c           |   27 +++++++++++++++++++++++++++
 7 files changed, 140 insertions(+), 3 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index d143121..759883d 100644
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
 
 /**
  * enum stmt_types - statement types
@@ -120,6 +126,7 @@ extern struct stmt *ct_stmt_alloc(const struct location *loc,
  * @STMT_REDIR:		redirect statement
  * @STMT_QUEUE:		QUEUE statement
  * @STMT_CT:		conntrack statement
+ * @STMT_TEE:		tee statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -135,6 +142,7 @@ enum stmt_types {
 	STMT_REDIR,
 	STMT_QUEUE,
 	STMT_CT,
+	STMT_TEE,
 };
 
 /**
@@ -184,6 +192,7 @@ struct stmt {
 		struct redir_stmt	redir;
 		struct queue_stmt	queue;
 		struct ct_stmt		ct;
+		struct tee_stmt		tee;
 	};
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index a3484c6..b2e85e7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1535,8 +1535,8 @@ static int nat_evaluate_family(struct eval_ctx *ctx, struct stmt *stmt)
 	}
 }
 
-static int nat_evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
-			     struct expr **expr)
+static int evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
+			 struct expr **expr)
 {
 	struct proto_ctx *pctx = &ctx->pctx;
 	const struct datatype *dtype;
@@ -1577,7 +1577,7 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 		return err;
 
 	if (stmt->nat.addr != NULL) {
-		err = nat_evaluate_addr(ctx, stmt, &stmt->nat.addr);
+		err = evaluate_addr(ctx, stmt, &stmt->nat.addr);
 		if (err < 0)
 			return err;
 	}
@@ -1646,6 +1646,28 @@ static int stmt_evaluate_log(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_tee(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	int err;
+
+	switch (ctx->pctx.family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		break;
+	default:
+		return stmt_error(ctx, stmt, "tee only supported in ip,ip6");
+	}
+
+	if (stmt->tee.gw == NULL)
+		return stmt_error(ctx, stmt, "tee requires gw parameter");
+
+	err = evaluate_addr(ctx, stmt, &stmt->tee.gw);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
 int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 {
 #ifdef DEBUG
@@ -1680,6 +1702,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_redir(ctx, stmt);
 	case STMT_QUEUE:
 		return stmt_evaluate_queue(ctx, stmt);
+	case STMT_TEE:
+		return stmt_evaluate_tee(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 387bb67..ff01e61 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -694,6 +694,20 @@ static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
+static void netlink_parse_tee(struct netlink_parse_ctx *ctx,
+			      const struct location *loc,
+			      const struct nft_rule_expr *nle)
+{
+	struct nft_data_delinearize nld;
+	struct stmt *stmt;
+
+	stmt = tee_stmt_alloc(loc);
+	nld.value = nft_rule_expr_get(nle, NFT_EXPR_TEE_GW, &nld.len);
+	stmt->tee.gw = netlink_alloc_value(loc, &nld);
+	stmt->tee.oifname = nft_rule_expr_get_str(nle, NFT_EXPR_TEE_OIF);
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
 static const struct {
 	const char	*name;
 	void		(*parse)(struct netlink_parse_ctx *ctx,
@@ -717,6 +731,7 @@ static const struct {
 	{ .name = "masq",	.parse = netlink_parse_masq },
 	{ .name = "redir",	.parse = netlink_parse_redir },
 	{ .name = "queue",	.parse = netlink_parse_queue },
+	{ .name = "tee",	.parse = netlink_parse_tee },
 };
 
 static int netlink_parse_expr(struct nft_rule_expr *nle, void *arg)
@@ -1102,6 +1117,20 @@ static void stmt_reject_postprocess(struct rule_pp_ctx rctx, struct stmt *stmt)
 	}
 }
 
+static void stmt_tee_postprocess(struct rule_pp_ctx rctx, struct stmt *stmt)
+{
+	switch (rctx.pctx.family) {
+	case NFPROTO_IPV4:
+		stmt->tee.gw->dtype = &ipaddr_type;
+		break;
+	case NFPROTO_IPV6:
+		stmt->tee.gw->dtype = &ip6addr_type;
+		break;
+	default:
+		break;
+	}
+}
+
 static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *rule)
 {
 	struct rule_pp_ctx rctx;
@@ -1137,6 +1166,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		case STMT_REJECT:
 			stmt_reject_postprocess(rctx, stmt);
 			break;
+		case STMT_TEE:
+			stmt_tee_postprocess(rctx, stmt);
+			break;
 		default:
 			break;
 		}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 9bef67b..260f4b6 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -798,6 +798,21 @@ static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_tee_stmt(struct netlink_linearize_ctx *ctx,
+				 const struct stmt *stmt)
+{
+	struct nft_rule_expr *nle;
+	struct nft_data_linearize nld;
+	const char *oifname = stmt->tee.oifname;
+
+	nle = alloc_nft_expr("tee");
+	netlink_gen_data(stmt->tee.gw, &nld);
+	nft_rule_expr_set(nle, NFT_EXPR_TEE_GW, nld.value, nld.len);
+	if (oifname != NULL)
+		nft_rule_expr_set_str(nle, NFT_EXPR_TEE_OIF, oifname);
+	nft_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 			     const struct stmt *stmt)
 {
@@ -826,6 +841,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_queue_stmt(ctx, stmt);
 	case STMT_CT:
 		return netlink_gen_ct_stmt(ctx, stmt);
+	case STMT_TEE:
+		return netlink_gen_tee_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fd2407c..11535ad 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -390,6 +390,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token POSITION			"position"
 %token COMMENT			"comment"
 
+%token TEE			"tee"
+%token GW			"gw"
+
 %token XML			"xml"
 %token JSON			"json"
 
@@ -452,6 +455,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
 %type <val>			queue_stmt_flags queue_stmt_flag
+%type <stmt>			tee_stmt tee_stmt_alloc
+%destructor { stmt_free($$); }	tee_stmt tee_stmt_alloc
 
 %type <expr>			symbol_expr verdict_expr integer_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr
@@ -1207,6 +1212,7 @@ stmt			:	verdict_stmt
 			|	ct_stmt
 			|	masq_stmt
 			|	redir_stmt
+			|	tee_stmt
 			;
 
 verdict_stmt		:	verdict_expr
@@ -1526,6 +1532,25 @@ match_stmt		:	relational_expr
 			}
 			;
 
+tee_stmt		:	tee_stmt_alloc	tee_stmt_opt
+			;
+
+tee_stmt_alloc		:	TEE
+			{
+				$$ = tee_stmt_alloc(&@$);
+			}
+			;
+
+tee_stmt_opt		:	GW		expr
+			{
+				$<stmt>0->tee.gw = $2;
+			}
+			|	OIFNAME		STRING
+			{
+				$<stmt>0->tee.oifname = strdup($2);
+			}
+			;
+
 symbol_expr		:	string
 			{
 				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
diff --git a/src/scanner.l b/src/scanner.l
index 73c4f8b..ecd9c41 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -449,6 +449,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "proto-dst"		{ return PROTO_DST; }
 "label"			{ return LABEL; }
 
+"tee"			{ return TEE; }
+"gw"			{ return GW; }
+
 "xml"			{ return XML; }
 "json"			{ return JSON; }
 
diff --git a/src/statement.c b/src/statement.c
index d72c6e9..e05cb32 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -377,3 +377,30 @@ struct stmt *redir_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &redir_stmt_ops);
 }
+
+static void tee_stmt_print(const struct stmt *stmt)
+{
+	printf("tee gw ");
+	expr_print(stmt->tee.gw);
+	if (stmt->tee.oifname != NULL)
+		printf(" oifname %s", stmt->tee.oifname);
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

