From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] src: add redirect support
Date: Wed, 15 Oct 2014 09:47:56 +0200
Message-ID: <20141015074756.30515.90161.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43593 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751261AbaJOHsI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:48:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds redirect support for nft.

The syntax is:

 % nft add rule nat prerouting redirect [port|nat_flags]

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/statement.h       |   10 +++++++++
 src/evaluate.c            |   42 ++++++++++++++++++++++++++++++++++++
 src/netlink_delinearize.c |   52 +++++++++++++++++++++++++++++++++++++++++++++
 src/netlink_linearize.c   |   49 ++++++++++++++++++++++++++++++++++++++++++
 src/parser.y              |   23 ++++++++++++++++++--
 src/scanner.l             |    1 +
 src/statement.c           |   29 +++++++++++++++++++++++++
 7 files changed, 204 insertions(+), 2 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 35c1b7a..d143121 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -79,6 +79,13 @@ struct masq_stmt {
 
 extern struct stmt *masq_stmt_alloc(const struct location *loc);
 
+struct redir_stmt {
+	struct expr		*proto;
+	uint32_t		flags;
+};
+
+extern struct stmt *redir_stmt_alloc(const struct location *loc);
+
 struct queue_stmt {
 	struct expr		*queue;
 	uint16_t		flags;
@@ -110,6 +117,7 @@ extern struct stmt *ct_stmt_alloc(const struct location *loc,
  * @STMT_REJECT:	REJECT statement
  * @STMT_NAT:		NAT statement
  * @STMT_MASQ:		masquerade statement
+ * @STMT_REDIR:		redirect statement
  * @STMT_QUEUE:		QUEUE statement
  * @STMT_CT:		conntrack statement
  */
@@ -124,6 +132,7 @@ enum stmt_types {
 	STMT_REJECT,
 	STMT_NAT,
 	STMT_MASQ,
+	STMT_REDIR,
 	STMT_QUEUE,
 	STMT_CT,
 };
@@ -172,6 +181,7 @@ struct stmt {
 		struct reject_stmt	reject;
 		struct nat_stmt		nat;
 		struct masq_stmt	masq;
+		struct redir_stmt	redir;
 		struct queue_stmt	queue;
 		struct ct_stmt		ct;
 	};
diff --git a/src/evaluate.c b/src/evaluate.c
index 108248a..6a2c724 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1375,6 +1375,46 @@ out:
 	return 0;
 }
 
+static int stmt_evaluate_redir(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	int err;
+	struct proto_ctx *pctx = &ctx->pctx;
+
+	if (!pctx)
+		goto out;
+
+	switch (pctx->family) {
+	case AF_INET:
+		expr_set_context(&ctx->ectx, &ipaddr_type,
+				4 * BITS_PER_BYTE);
+		break;
+	case AF_INET6:
+		expr_set_context(&ctx->ectx, &ip6addr_type,
+				 16 * BITS_PER_BYTE);
+		break;
+	default:
+		return stmt_error(ctx, stmt, "ip and ip6 support only");
+	}
+
+	if (stmt->redir.proto != NULL) {
+		if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL)
+			return stmt_binary_error(ctx, stmt->redir.proto, stmt,
+						 "transport protocol mapping "
+						 "is only valid after "
+						 "transport protocol match");
+
+		expr_set_context(&ctx->ectx, &inet_service_type,
+				 2 * BITS_PER_BYTE);
+		err = expr_evaluate(ctx, &stmt->redir.proto);
+		if (err < 0)
+			return err;
+	}
+
+out:
+	stmt->flags |= STMT_F_TERMINAL;
+	return 0;
+}
+
 static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	expr_set_context(&ctx->ectx, stmt->ct.tmpl->dtype,
@@ -1437,6 +1477,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_nat(ctx, stmt);
 	case STMT_MASQ:
 		return stmt_evaluate_masq(ctx, stmt);
+	case STMT_REDIR:
+		return stmt_evaluate_redir(ctx, stmt);
 	case STMT_QUEUE:
 		return stmt_evaluate_queue(ctx, stmt);
 	case STMT_CT:
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 38618ee..2d104db 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -583,6 +583,52 @@ static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
+static void netlink_parse_redir(struct netlink_parse_ctx *ctx,
+				const struct location *loc,
+				const struct nft_rule_expr *nle)
+{
+	struct stmt *stmt;
+	struct expr *proto;
+	enum nft_registers reg1, reg2;
+	uint32_t flags;
+
+	stmt = redir_stmt_alloc(loc);
+
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_REDIR_FLAGS)) {
+		flags = nft_rule_expr_get_u32(nle, NFT_EXPR_REDIR_FLAGS);
+		stmt->redir.flags = flags;
+	}
+
+	reg1 = nft_rule_expr_get_u32(nle, NFT_EXPR_REDIR_REG_PROTO_MIN);
+	if (reg1) {
+		proto = netlink_get_register(ctx, loc, reg1);
+		if (proto == NULL)
+			return netlink_error(ctx, loc,
+					     "REDIRECT statement has no proto "
+					     "expression");
+
+		expr_set_type(proto, &inet_service_type, BYTEORDER_BIG_ENDIAN);
+		stmt->redir.proto = proto;
+	}
+
+	reg2 = nft_rule_expr_get_u32(nle, NFT_EXPR_REDIR_REG_PROTO_MAX);
+	if (reg2 && reg2 != reg1) {
+		proto = netlink_get_register(ctx, loc, reg2);
+		if (proto == NULL)
+			return netlink_error(ctx, loc,
+					     "REDIRECT statement has no proto "
+					     "expression");
+
+		expr_set_type(proto, &inet_service_type, BYTEORDER_BIG_ENDIAN);
+		if (stmt->redir.proto != NULL)
+			proto = range_expr_alloc(loc, stmt->redir.proto,
+						 proto);
+		stmt->redir.proto = proto;
+	}
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
 static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
 			      const struct nft_rule_expr *nle)
@@ -630,6 +676,7 @@ static const struct {
 	{ .name = "reject",	.parse = netlink_parse_reject },
 	{ .name = "nat",	.parse = netlink_parse_nat },
 	{ .name = "masq",	.parse = netlink_parse_masq },
+	{ .name = "redir",	.parse = netlink_parse_redir },
 	{ .name = "queue",	.parse = netlink_parse_queue },
 };
 
@@ -1010,6 +1057,11 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 			if (stmt->nat.proto != NULL)
 				expr_postprocess(&rctx, stmt, &stmt->nat.proto);
 			break;
+		case STMT_REDIR:
+			if (stmt->redir.proto != NULL)
+				expr_postprocess(&rctx, stmt,
+						 &stmt->redir.proto);
+			break;
 		case STMT_REJECT:
 			stmt_reject_postprocess(rctx, stmt);
 			break;
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 62155cc..de338cb 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -701,6 +701,53 @@ static void netlink_gen_masq_stmt(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_redir_stmt(struct netlink_linearize_ctx *ctx,
+				   const struct stmt *stmt)
+{
+	struct nft_rule_expr *nle;
+	enum nft_registers pmin_reg, pmax_reg;
+	int registers = 0;
+
+	nle = alloc_nft_expr("redir");
+
+	if (stmt->redir.flags != 0)
+		nft_rule_expr_set_u32(nle, NFT_EXPR_REDIR_FLAGS,
+				      stmt->redir.flags);
+
+	if (stmt->redir.proto) {
+		pmin_reg = get_register(ctx);
+		registers++;
+
+		if (stmt->redir.proto->ops->type == EXPR_RANGE) {
+			pmax_reg = get_register(ctx);
+			registers++;
+
+			netlink_gen_expr(ctx, stmt->redir.proto->left,
+					 pmin_reg);
+			netlink_gen_expr(ctx, stmt->redir.proto->right,
+					 pmax_reg);
+			nft_rule_expr_set_u32(nle,
+					      NFT_EXPR_REDIR_REG_PROTO_MIN,
+					      pmin_reg);
+			nft_rule_expr_set_u32(nle,
+					      NFT_EXPR_REDIR_REG_PROTO_MAX,
+					      pmax_reg);
+		} else {
+			netlink_gen_expr(ctx, stmt->redir.proto, pmin_reg);
+			nft_rule_expr_set_u32(nle,
+					      NFT_EXPR_REDIR_REG_PROTO_MIN,
+					      pmin_reg);
+		}
+	}
+
+	while (registers > 0) {
+		release_register(ctx);
+		registers--;
+	}
+
+	nft_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
@@ -767,6 +814,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_nat_stmt(ctx, stmt);
 	case STMT_MASQ:
 		return netlink_gen_masq_stmt(ctx, stmt);
+	case STMT_REDIR:
+		return netlink_gen_redir_stmt(ctx, stmt);
 	case STMT_QUEUE:
 		return netlink_gen_queue_stmt(ctx, stmt);
 	case STMT_CT:
diff --git a/src/parser.y b/src/parser.y
index 9e9a839..6209e9e 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -375,6 +375,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token SNAT			"snat"
 %token DNAT			"dnat"
 %token MASQUERADE		"masquerade"
+%token REDIRECT			"redirect"
 %token RANDOM			"random"
 %token RANDOM_FULLY		"random-fully"
 %token PERSISTENT		"persistent"
@@ -440,8 +441,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <val>			time_unit
 %type <stmt>			reject_stmt reject_stmt_alloc
 %destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
-%type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc
-%destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc
+%type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
+%destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
 %type <val>			nf_nat_flags nf_nat_flag
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
@@ -1186,6 +1187,7 @@ stmt			:	verdict_stmt
 			|	queue_stmt
 			|	ct_stmt
 			|	masq_stmt
+			|	redir_stmt
 			;
 
 verdict_stmt		:	verdict_expr
@@ -1420,6 +1422,23 @@ masq_stmt		:	masq_stmt_alloc
 masq_stmt_alloc		:	MASQUERADE 	{ $$ = masq_stmt_alloc(&@$); }
 			;
 
+redir_stmt		:	redir_stmt_alloc	redir_stmt_arg
+			|	redir_stmt_alloc
+			;
+
+redir_stmt_alloc	:	REDIRECT	{ $$ = redir_stmt_alloc(&@$); }
+			;
+
+redir_stmt_arg		:	COLON	expr
+			{
+				$<stmt>0->redir.proto = $2;
+			}
+			|	nf_nat_flags
+			{
+				$<stmt>0->redir.flags = $1;
+			}
+			;
+
 nf_nat_flags		:	nf_nat_flag
 			|	nf_nat_flags	COMMA	nf_nat_flag
 			{
diff --git a/src/scanner.l b/src/scanner.l
index 32e59d9..e36c3b1 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -317,6 +317,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "snat"			{ return SNAT; }
 "dnat"			{ return DNAT; }
 "masquerade"		{ return MASQUERADE; }
+"redirect"		{ return REDIRECT; }
 "random"		{ return RANDOM; }
 "random-fully"		{ return RANDOM_FULLY; }
 "persistent"		{ return PERSISTENT; }
diff --git a/src/statement.c b/src/statement.c
index 0ae616a..2587d27 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -348,3 +348,32 @@ struct stmt *masq_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &masq_stmt_ops);
 }
+
+static void redir_stmt_print(const struct stmt *stmt)
+{
+	printf("redirect");
+
+	if (stmt->redir.proto) {
+		printf(" :");
+		expr_print(stmt->redir.proto);
+	}
+
+	print_nf_nat_flags(stmt->redir.flags);
+}
+
+static void redir_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->redir.proto);
+}
+
+static const struct stmt_ops redir_stmt_ops = {
+	.type		= STMT_REDIR,
+	.name		= "redir",
+	.print		= redir_stmt_print,
+	.destroy	= redir_stmt_destroy,
+};
+
+struct stmt *redir_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &redir_stmt_ops);
+}

