From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v3] src: Add support for masquerade port selection
Date: Tue,  1 Mar 2016 20:05:33 +0100
Message-ID: <1456859133-1975-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37656 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbcCATFo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 14:05:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B9B0F80FF
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:05:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 85D2ACA0F9
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:05:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 25B79DA3A1
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:05:38 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Shivani Bhardwaj <shivanib134@gmail.com>

Provide full support for masquerading by allowing port range selection, eg.

 # nft add rule nat postrouting ip protocol tcp masquerade to :1024-10024

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: Don't use stmt->nat.proto from the delinearize step.
    As previous patch, based on original Shivani's work.

 include/statement.h       |  1 +
 src/evaluate.c            |  6 ++++++
 src/netlink_delinearize.c | 29 +++++++++++++++++++++++++++--
 src/netlink_linearize.c   | 24 ++++++++++++++++++++++++
 src/parser_bison.y        | 23 +++++++++++++++++------
 src/statement.c           | 11 +++++++++++
 6 files changed, 86 insertions(+), 8 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 102d95f..e7872b0 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -86,6 +86,7 @@ extern struct stmt *nat_stmt_alloc(const struct location *loc);
 
 struct masq_stmt {
 	uint32_t		flags;
+	struct expr		*proto;
 };
 
 extern struct stmt *masq_stmt_alloc(const struct location *loc);
diff --git a/src/evaluate.c b/src/evaluate.c
index ed78896..3815301 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1849,6 +1849,12 @@ static int stmt_evaluate_masq(struct eval_ctx *ctx, struct stmt *stmt)
 	if (err < 0)
 		return err;
 
+	if (stmt->masq.proto != NULL) {
+		err = nat_evaluate_transport(ctx, stmt, &stmt->masq.proto);
+		if (err < 0)
+			return err;
+	}
+
 	stmt->flags |= STMT_F_TERMINAL;
 	return 0;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ae6abb0..e388b9f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -726,16 +726,41 @@ static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
 			       const struct location *loc,
 			       const struct nftnl_expr *nle)
 {
+	enum nft_registers reg1, reg2;
+	struct expr *proto;
 	struct stmt *stmt;
-	uint32_t flags;
+	uint32_t flags = 0;
 
-	flags = 0;
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_MASQ_FLAGS))
 		flags = nftnl_expr_get_u32(nle, NFTNL_EXPR_MASQ_FLAGS);
 
 	stmt = masq_stmt_alloc(loc);
 	stmt->masq.flags = flags;
 
+	reg1 = netlink_parse_register(nle, NFTNL_EXPR_MASQ_REG_PROTO_MIN);
+	if (reg1) {
+		proto = netlink_get_register(ctx, loc, reg1);
+		if (proto == NULL)
+			return netlink_error(ctx, loc,
+					     "MASQUERADE statement"
+					     "has no proto expression");
+		expr_set_type(proto, &inet_service_type, BYTEORDER_BIG_ENDIAN);
+		stmt->masq.proto = proto;
+	}
+
+	reg2 = netlink_parse_register(nle, NFTNL_EXPR_MASQ_REG_PROTO_MAX);
+	if (reg2 && reg2 != reg1) {
+		proto = netlink_get_register(ctx, loc, reg2);
+		if (proto == NULL)
+			return netlink_error(ctx, loc,
+					     "MASQUERADE statement"
+					     "has no proto expression");
+		expr_set_type(proto, &inet_service_type, BYTEORDER_BIG_ENDIAN);
+		if (stmt->masq.proto != NULL)
+			proto = range_expr_alloc(loc, stmt->masq.proto, proto);
+		stmt->masq.proto = proto;
+	}
+
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 86b49c6..b3dbaca 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -884,12 +884,36 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 static void netlink_gen_masq_stmt(struct netlink_linearize_ctx *ctx,
 				  const struct stmt *stmt)
 {
+	enum nft_registers pmin_reg, pmax_reg;
 	struct nftnl_expr *nle;
+	int registers = 0;
 
 	nle = alloc_nft_expr("masq");
 	if (stmt->masq.flags != 0)
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_MASQ_FLAGS,
 				      stmt->masq.flags);
+	if (stmt->masq.proto) {
+		pmin_reg = get_register(ctx, NULL);
+		registers++;
+
+		if (stmt->masq.proto->ops->type == EXPR_RANGE) {
+			pmax_reg = get_register(ctx, NULL);
+			registers++;
+
+			netlink_gen_expr(ctx, stmt->masq.proto->left, pmin_reg);
+			netlink_gen_expr(ctx, stmt->masq.proto->right, pmax_reg);
+			netlink_put_register(nle, NFTNL_EXPR_MASQ_REG_PROTO_MIN, pmin_reg);
+			netlink_put_register(nle, NFTNL_EXPR_MASQ_REG_PROTO_MAX, pmax_reg);
+		} else {
+			netlink_gen_expr(ctx, stmt->masq.proto, pmin_reg);
+			netlink_put_register(nle, NFTNL_EXPR_MASQ_REG_PROTO_MIN, pmin_reg);
+		}
+	}
+
+	while (registers > 0) {
+		release_register(ctx, NULL);
+		registers--;
+	}
 
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 05ade0f..d41fc0a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1644,17 +1644,28 @@ nat_stmt_args		:	stmt_expr
 			}
 			;
 
-masq_stmt		:	masq_stmt_alloc
-			|	masq_stmt_alloc	nf_nat_flags
-			{
-				$$ = $1;
-				$$->masq.flags = $2;
-			}
+masq_stmt		:	masq_stmt_alloc		masq_stmt_args
+			|	masq_stmt_alloc
 			;
 
 masq_stmt_alloc		:	MASQUERADE 	{ $$ = masq_stmt_alloc(&@$); }
 			;
 
+masq_stmt_args		:	TO 	COLON	stmt_expr
+			{
+				$<stmt>0->masq.proto = $3;
+			}
+			|	TO 	COLON	stmt_expr	nf_nat_flags
+			{
+				$<stmt>0->masq.proto = $3;
+				$<stmt>0->masq.flags = $4;
+			}
+			|	nf_nat_flags
+			{
+				$<stmt>0->masq.flags = $1;
+			}
+			;
+
 redir_stmt		:	redir_stmt_alloc	redir_stmt_arg
 			|	redir_stmt_alloc
 			;
diff --git a/src/statement.c b/src/statement.c
index ca92441..0fd3afe 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -385,13 +385,24 @@ static void masq_stmt_print(const struct stmt *stmt)
 {
 	printf("masquerade");
 
+	if (stmt->masq.proto) {
+		printf(":");
+		expr_print(stmt->masq.proto);
+	}
+
 	print_nf_nat_flags(stmt->masq.flags);
 }
 
+static void masq_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->masq.proto);
+}
+
 static const struct stmt_ops masq_stmt_ops = {
 	.type		= STMT_MASQ,
 	.name		= "masq",
 	.print		= masq_stmt_print,
+	.destroy	= masq_stmt_destroy,
 };
 
 struct stmt *masq_stmt_alloc(const struct location *loc)
-- 
2.1.4

