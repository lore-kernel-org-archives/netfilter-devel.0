From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH nftables] Add support for masquerade port selection
Date: Sat, 23 Jan 2016 02:25:55 +0530
Message-ID: <20160122205554.GA12691@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35089 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbcAVU4D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jan 2016 15:56:03 -0500
Received: by mail-pa0-f65.google.com with SMTP id gi1so3682193pac.2
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2016 12:56:02 -0800 (PST)
Received: from gmail.com ([106.215.169.87])
        by smtp.gmail.com with ESMTPSA id 20sm11754754pfa.5.2016.01.22.12.55.59
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 22 Jan 2016 12:56:00 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Provide full support for masquerading by allowing port range selection.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 include/statement.h       |  1 +
 src/netlink_delinearize.c | 26 ++++++++++++++++++++++++++
 src/netlink_linearize.c   | 24 ++++++++++++++++++++++++
 src/parser_bison.y        | 23 +++++++++++++++++------
 src/statement.c           | 11 +++++++++++
 5 files changed, 79 insertions(+), 6 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 8b035d3..e310ab4 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -77,6 +77,7 @@ extern struct stmt *nat_stmt_alloc(const struct location *loc);
 
 struct masq_stmt {
 	uint32_t		flags;
+	struct expr		*proto;
 };
 
 extern struct stmt *masq_stmt_alloc(const struct location *loc);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3499d74..bd93702 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -692,6 +692,8 @@ static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
 {
 	struct stmt *stmt;
 	uint32_t flags;
+	struct expr *proto;
+	enum nft_registers reg1, reg2;
 
 	flags = 0;
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_MASQ_FLAGS))
@@ -700,6 +702,30 @@ static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
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
+			proto = range_expr_alloc(loc, stmt->nat.proto, proto);
+		stmt->nat.proto = proto;
+	}
+
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 7c6ef16..7ae7cb7 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -827,11 +827,35 @@ static void netlink_gen_masq_stmt(struct netlink_linearize_ctx *ctx,
 				  const struct stmt *stmt)
 {
 	struct nftnl_expr *nle;
+	enum nft_registers pmin_reg, pmax_reg;
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
index ec1e742..9868bd6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1588,17 +1588,28 @@ nat_stmt_args		:	expr
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
 
+masq_stmt_args		:	TO 	COLON	expr
+			{
+				$<stmt>0->masq.proto = $3;
+			}
+			|	TO 	COLON	expr	nf_nat_flags
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
index 2d1a3e6..1d21c3f 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -382,13 +382,24 @@ static void masq_stmt_print(const struct stmt *stmt)
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
1.9.1

