From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 4/6] src: flow offload support
Date: Tue, 23 Jan 2018 13:16:20 +0100
Message-ID: <20180123121622.16287-4-pablo@netfilter.org>
References: <20180123121622.16287-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44794 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751394AbeAWMQd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jan 2018 07:16:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E4BE82519A2
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2479DA811
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF159DA86B
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:29 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 862C241E4817
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:29 +0100 (CET)
In-Reply-To: <20180123121622.16287-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows us to refer to existing flowtables:

 # nft add rule x x flow offload @m

Packets matching this rule create an entry in the flow table 'm', hence,
follow up packets that get to the flowtable at ingress bypass the
classic forwarding path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/ct.h              |  2 ++
 include/statement.h       |  9 +++++++++
 src/ct.c                  | 23 +++++++++++++++++++++++
 src/evaluate.c            |  1 +
 src/netlink_delinearize.c | 11 +++++++++++
 src/netlink_linearize.c   | 13 +++++++++++++
 src/parser_bison.y        |  5 +++++
 src/scanner.l             |  1 +
 8 files changed, 65 insertions(+)

diff --git a/include/ct.h b/include/ct.h
index ec5d55d85dd0..2c3392d36c94 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -29,6 +29,8 @@ extern struct expr *ct_expr_alloc(const struct location *loc,
 extern void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr);
 
 extern struct stmt *notrack_stmt_alloc(const struct location *loc);
+extern struct stmt *flow_offload_stmt_alloc(const struct location *loc,
+					    const char *table_name);
 
 extern const struct datatype ct_dir_type;
 extern const struct datatype ct_state_type;
diff --git a/include/statement.h b/include/statement.h
index 23a551b67f2b..993727c933f2 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -10,6 +10,12 @@ extern struct stmt *expr_stmt_alloc(const struct location *loc,
 extern struct stmt *verdict_stmt_alloc(const struct location *loc,
 				       struct expr *expr);
 
+struct flow_stmt {
+	const char		*table_name;
+};
+
+struct stmt *flow_stmt_alloc(const struct location *loc, const char *name);
+
 struct objref_stmt {
 	uint32_t		type;
 	struct expr		*expr;
@@ -229,6 +235,7 @@ struct xt_stmt {
  * @STMT_NOTRACK:	notrack statement
  * @STMT_OBJREF:	stateful object reference statement
  * @STMT_EXTHDR:	extension header statement
+ * @STMT_FLOW_OFFLOAD:	flow offload statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -254,6 +261,7 @@ enum stmt_types {
 	STMT_NOTRACK,
 	STMT_OBJREF,
 	STMT_EXTHDR,
+	STMT_FLOW_OFFLOAD,
 };
 
 /**
@@ -314,6 +322,7 @@ struct stmt {
 		struct fwd_stmt		fwd;
 		struct xt_stmt		xt;
 		struct objref_stmt	objref;
+		struct flow_stmt	flow;
 	};
 };
 
diff --git a/src/ct.c b/src/ct.c
index d5347974bd0d..fb908531862b 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -456,3 +456,26 @@ struct stmt *notrack_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &notrack_stmt_ops);
 }
+
+static void flow_offload_stmt_print(const struct stmt *stmt,
+				    struct output_ctx *octx)
+{
+	printf("flow offload @%s", stmt->flow.table_name);
+}
+
+static const struct stmt_ops flow_offload_stmt_ops = {
+	.type		= STMT_FLOW_OFFLOAD,
+	.name		= "flow_offload",
+	.print		= flow_offload_stmt_print,
+};
+
+struct stmt *flow_offload_stmt_alloc(const struct location *loc,
+				     const char *table_name)
+{
+	struct stmt *stmt;
+
+	stmt = stmt_alloc(loc, &flow_offload_stmt_ops);
+	stmt->flow.table_name	= table_name;
+
+	return stmt;
+}
diff --git a/src/evaluate.c b/src/evaluate.c
index 892d1e0c8c5b..14fadd538850 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2773,6 +2773,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	case STMT_LIMIT:
 	case STMT_QUOTA:
 	case STMT_NOTRACK:
+	case STMT_FLOW_OFFLOAD:
 		return 0;
 	case STMT_EXPRESSION:
 		return stmt_evaluate_expr(ctx, stmt);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 2637f4baaec4..bbc9ccead1bf 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -677,6 +677,16 @@ static void netlink_parse_notrack(struct netlink_parse_ctx *ctx,
 	ctx->stmt = notrack_stmt_alloc(loc);
 }
 
+static void netlink_parse_flow_offload(struct netlink_parse_ctx *ctx,
+				       const struct location *loc,
+				       const struct nftnl_expr *nle)
+{
+	const char *table_name;
+
+	table_name = xstrdup(nftnl_expr_get_str(nle, NFTNL_EXPR_FLOW_TABLE_NAME));
+	ctx->stmt = flow_offload_stmt_alloc(loc, table_name);
+}
+
 static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
 				  const struct nftnl_expr *nle)
@@ -1252,6 +1262,7 @@ static const struct {
 	{ .name = "hash",	.parse = netlink_parse_hash },
 	{ .name = "fib",	.parse = netlink_parse_fib },
 	{ .name = "tcpopt",	.parse = netlink_parse_exthdr },
+	{ .name = "flow_offload", .parse = netlink_parse_flow_offload },
 };
 
 static int netlink_parse_expr(const struct nftnl_expr *nle,
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 99a4dde22adb..a6eb3aaf1c6b 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1201,6 +1201,17 @@ static void netlink_gen_notrack_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_flow_offload_stmt(struct netlink_linearize_ctx *ctx,
+					  const struct stmt *stmt)
+{
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("flow_offload");
+	nftnl_expr_set_str(nle, NFTNL_EXPR_FLOW_TABLE_NAME,
+			   stmt->flow.table_name);
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
@@ -1300,6 +1311,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		break;
 	case STMT_NOTRACK:
 		return netlink_gen_notrack_stmt(ctx, stmt);
+	case STMT_FLOW_OFFLOAD:
+		return netlink_gen_flow_offload_stmt(ctx, stmt);
 	case STMT_OBJREF:
 		return netlink_gen_objref_stmt(ctx, stmt);
 	default:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0623cd12aeb5..c9796acf7539 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -247,6 +247,7 @@ int nft_lex(void *, void *, void *);
 %token SIZE			"size"
 
 %token FLOW			"flow"
+%token OFFLOAD			"offload"
 %token METER			"meter"
 %token METERS			"meters"
 
@@ -3378,6 +3379,10 @@ meta_stmt		:	META	meta_key	SET	stmt_expr
 			{
 				$$ = notrack_stmt_alloc(&@$);
 			}
+			|	FLOW	OFFLOAD	AT string
+			{
+				$$ = flow_offload_stmt_alloc(&@$, $4);
+			}
 			;
 
 offset_opt		:	/* empty */	{ $$ = 0; }
diff --git a/src/scanner.l b/src/scanner.l
index ca74650cdd1f..f51687bd2929 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -295,6 +295,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "memory"		{ return MEMORY; }
 
 "flow"			{ return FLOW; }
+"offload"		{ return OFFLOAD; }
 "meter"			{ return METER; }
 "meters"		{ return METERS; }
 
-- 
2.11.0

