From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH v2] src: add masquerade support
Date: Mon, 06 Oct 2014 21:51:24 +0200
Message-ID: <20141006195009.17830.37135.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:41711 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751034AbaJFTvf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:51:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds masquerade support for nft.

The syntax is:

 % nft add rule nat postrouting masquerade [flags]

Currently, flags are:
 random, random-fully, persistent

Example:
 % nft add rule nat postrouting masquerade random,persistent

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: fixed typo in header. Use switch in the evaluation stage and report error
    if family is neither ip nor ip6. Requested by Pablo.

 include/statement.h       |    9 +++++++++
 src/evaluate.c            |   28 ++++++++++++++++++++++++++++
 src/netlink_delinearize.c |   16 ++++++++++++++++
 src/netlink_linearize.c   |   15 +++++++++++++++
 src/parser.y              |   18 ++++++++++++++++--
 src/scanner.l             |    1 +
 src/statement.c           |   18 ++++++++++++++++++
 7 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index e04ab7d..a182f74 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -70,6 +70,12 @@ struct nat_stmt {
 
 extern struct stmt *nat_stmt_alloc(const struct location *loc);
 
+struct masq_stmt {
+	uint32_t		flags;
+};
+
+extern struct stmt *masq_stmt_alloc(const struct location *loc);
+
 struct queue_stmt {
 	struct expr		*queue;
 	uint16_t		flags;
@@ -100,6 +106,7 @@ extern struct stmt *ct_stmt_alloc(const struct location *loc,
  * @STMT_LOG:		log statement
  * @STMT_REJECT:	REJECT statement
  * @STMT_NAT:		NAT statement
+ * @STMT_MASQ:		masquerade statement
  * @STMT_QUEUE:		QUEUE statement
  * @STMT_CT:		conntrack statement
  */
@@ -113,6 +120,7 @@ enum stmt_types {
 	STMT_LOG,
 	STMT_REJECT,
 	STMT_NAT,
+	STMT_MASQ,
 	STMT_QUEUE,
 	STMT_CT,
 };
@@ -160,6 +168,7 @@ struct stmt {
 		struct limit_stmt	limit;
 		struct reject_stmt	reject;
 		struct nat_stmt		nat;
+		struct masq_stmt	masq;
 		struct queue_stmt	queue;
 		struct ct_stmt		ct;
 	};
diff --git a/src/evaluate.c b/src/evaluate.c
index 284ee72..ac35bf6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1171,6 +1171,32 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_masq(struct eval_ctx *ctx, struct stmt *stmt)
+{
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
+		return stmt_error(ctx, stmt,
+				  "masquerade family must be ip or ipv6");
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
@@ -1231,6 +1257,8 @@ static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_reject(ctx, stmt);
 	case STMT_NAT:
 		return stmt_evaluate_nat(ctx, stmt);
+	case STMT_MASQ:
+		return stmt_evaluate_masq(ctx, stmt);
 	case STMT_QUEUE:
 		return stmt_evaluate_queue(ctx, stmt);
 	case STMT_CT:
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e2a13d3..7785ce4 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -558,6 +558,21 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
+static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
+			       const struct location *loc,
+			       const struct nft_rule_expr *nle)
+{
+	struct stmt *stmt;
+
+	stmt = masq_stmt_alloc(loc);
+
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_MASQ_FLAGS))
+		stmt->masq.flags = nft_rule_expr_get_u32(nle,
+							 NFT_EXPR_MASQ_FLAGS);
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
 static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
 			      const struct nft_rule_expr *nle)
@@ -604,6 +619,7 @@ static const struct {
 	{ .name = "limit",	.parse = netlink_parse_limit },
 	{ .name = "reject",	.parse = netlink_parse_reject },
 	{ .name = "nat",	.parse = netlink_parse_nat },
+	{ .name = "masq",	.parse = netlink_parse_masq },
 	{ .name = "queue",	.parse = netlink_parse_queue },
 };
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 36b56ff..c5aa0b4 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -685,6 +685,19 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_masq_stmt(struct netlink_linearize_ctx *ctx,
+				  const struct stmt *stmt)
+{
+	struct nft_rule_expr *nle;
+
+	nle = alloc_nft_expr("masq");
+	if (stmt->masq.flags != 0)
+		nft_rule_expr_set_u32(nle, NFT_EXPR_MASQ_FLAGS,
+				      stmt->masq.flags);
+
+	nft_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
@@ -749,6 +762,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_reject_stmt(ctx, stmt);
 	case STMT_NAT:
 		return netlink_gen_nat_stmt(ctx, stmt);
+	case STMT_MASQ:
+		return netlink_gen_masq_stmt(ctx, stmt);
 	case STMT_QUEUE:
 		return netlink_gen_queue_stmt(ctx, stmt);
 	case STMT_CT:
diff --git a/src/parser.y b/src/parser.y
index 9fda571..0a698f0 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -372,6 +372,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token SNAT			"snat"
 %token DNAT			"dnat"
+%token MASQUERADE		"masquerade"
 %token RANDOM			"random"
 %token RANDOM_FULLY		"random-fully"
 %token PERSISTENT		"persistent"
@@ -437,9 +438,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <val>			time_unit
 %type <stmt>			reject_stmt
 %destructor { stmt_free($$); }	reject_stmt
-%type <stmt>			nat_stmt nat_stmt_alloc
-%destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc
+%type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc
+%destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc
 %type <val>			nf_nat_flags nf_nat_flag
+
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
 %type <val>			queue_stmt_flags queue_stmt_flag
@@ -1239,6 +1241,7 @@ stmt			:	verdict_stmt
 			|	nat_stmt
 			|	queue_stmt
 			|	ct_stmt
+			|	masq_stmt
 			;
 
 verdict_stmt		:	verdict_expr
@@ -1419,6 +1422,17 @@ nat_stmt_args		:	expr
 			}
 			;
 
+masq_stmt		:	masq_stmt_alloc
+			|	masq_stmt_alloc	nf_nat_flags
+			{
+				$$ = $1;
+				$$->masq.flags = $2;
+			}
+			;
+
+masq_stmt_alloc		:	MASQUERADE 	{ $$ = masq_stmt_alloc(&@$); }
+			;
+
 nf_nat_flags		:	nf_nat_flag
 			|	nf_nat_flags	COMMA	nf_nat_flag
 			{
diff --git a/src/scanner.l b/src/scanner.l
index 440b0ed..9c957c0 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -316,6 +316,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "snat"			{ return SNAT; }
 "dnat"			{ return DNAT; }
+"masquerade"		{ return MASQUERADE; }
 "random"		{ return RANDOM; }
 "random-fully"		{ return RANDOM_FULLY; }
 "persistent"		{ return PERSISTENT; }
diff --git a/src/statement.c b/src/statement.c
index 1b2c31c..3fa6d66 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -299,3 +299,21 @@ struct stmt *nat_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &nat_stmt_ops);
 }
+
+static void masq_stmt_print(const struct stmt *stmt)
+{
+	printf("masquerade");
+
+	print_nf_nat_flags(stmt->masq.flags);
+}
+
+static const struct stmt_ops masq_stmt_ops = {
+	.type		= STMT_MASQ,
+	.name		= "masq",
+	.print		= masq_stmt_print,
+};
+
+struct stmt *masq_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &masq_stmt_ops);
+}

