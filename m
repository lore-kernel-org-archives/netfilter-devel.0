From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: add notrack support
Date: Thu, 20 Oct 2016 18:07:16 +0200
Message-ID: <1476979636-1314-3-git-send-email-pablo@netfilter.org>
References: <1476979636-1314-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49696 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932213AbcJTQHa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 12:07:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5BD4E80F7
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 18:07:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A799BAC27
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 18:07:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0896BBAC27
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 18:07:26 +0200 (CEST)
In-Reply-To: <1476979636-1314-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the notrack statement, to skip connection tracking for
certain packets.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/ct.h              |  3 +++
 include/statement.h       |  2 ++
 src/ct.c                  | 16 ++++++++++++++++
 src/evaluate.c            |  1 +
 src/netlink_delinearize.c |  8 ++++++++
 src/netlink_linearize.c   | 11 +++++++++++
 src/parser_bison.y        |  6 ++++++
 src/scanner.l             |  2 ++
 8 files changed, 49 insertions(+)

diff --git a/include/ct.h b/include/ct.h
index 945fcc4d829d..8c006588ef3b 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -29,4 +29,7 @@ extern void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr);
 
 extern struct error_record *ct_dir_parse(const struct location *loc,
 					 const char *str, int8_t *dir);
+
+extern struct stmt *notrack_stmt_alloc(const struct location *loc);
+
 #endif /* NFTABLES_CT_H */
diff --git a/include/statement.h b/include/statement.h
index e278b70637c4..fe83717f0697 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -208,6 +208,7 @@ extern struct stmt *xt_stmt_alloc(const struct location *loc);
  * @STMT_FWD:		forward statement
  * @STMT_XT:		XT statement
  * @STMT_QUOTA:		quota statement
+ * @STMT_NOTRACK:	notrack statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -230,6 +231,7 @@ enum stmt_types {
 	STMT_FWD,
 	STMT_XT,
 	STMT_QUOTA,
+	STMT_NOTRACK,
 };
 
 /**
diff --git a/src/ct.c b/src/ct.c
index a68293896ed6..a05cb0bdec42 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -379,6 +379,22 @@ struct stmt *ct_stmt_alloc(const struct location *loc, enum nft_ct_keys key,
 	return stmt;
 }
 
+static void notrack_stmt_print(const struct stmt *stmt)
+{
+	printf("notrack");
+}
+
+static const struct stmt_ops notrack_stmt_ops = {
+	.type		= STMT_NOTRACK,
+	.name		= "notrack",
+	.print		= notrack_stmt_print,
+};
+
+struct stmt *notrack_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &notrack_stmt_ops);
+}
+
 static void __init ct_init(void)
 {
 	datatype_register(&ct_state_type);
diff --git a/src/evaluate.c b/src/evaluate.c
index 45af3298537c..208bbdba69c1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2443,6 +2443,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	case STMT_COUNTER:
 	case STMT_LIMIT:
 	case STMT_QUOTA:
+	case STMT_NOTRACK:
 		return 0;
 	case STMT_EXPRESSION:
 		return stmt_evaluate_expr(ctx, stmt);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index d8d1d7d7aaa7..978ef51c4ad9 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -601,6 +601,13 @@ static void netlink_parse_numgen(struct netlink_parse_ctx *ctx,
 	netlink_set_register(ctx, dreg, expr);
 }
 
+static void netlink_parse_notrack(struct netlink_parse_ctx *ctx,
+				  const struct location *loc,
+				  const struct nftnl_expr *nle)
+{
+	ctx->stmt = notrack_stmt_alloc(loc);
+}
+
 static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
 				  const struct nftnl_expr *nle)
@@ -1092,6 +1099,7 @@ static const struct {
 	{ .name = "range",	.parse = netlink_parse_range },
 	{ .name = "reject",	.parse = netlink_parse_reject },
 	{ .name = "nat",	.parse = netlink_parse_nat },
+	{ .name = "notrack",	.parse = netlink_parse_notrack },
 	{ .name = "masq",	.parse = netlink_parse_masq },
 	{ .name = "redir",	.parse = netlink_parse_redir },
 	{ .name = "dup",	.parse = netlink_parse_dup },
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 0072dca091ea..0af144f37016 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1063,6 +1063,15 @@ static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_notrack_stmt(struct netlink_linearize_ctx *ctx,
+				     const struct stmt *stmt)
+{
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("notrack");
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
@@ -1158,6 +1167,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		nle = netlink_gen_stmt_stateful(ctx, stmt);
 		nftnl_rule_add_expr(ctx->nlr, nle);
 		break;
+	case STMT_NOTRACK:
+		return netlink_gen_notrack_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index baf0a539efa0..4108dff7e228 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -420,6 +420,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token XML			"xml"
 %token JSON			"json"
 
+%token NOTRACK			"notrack"
+
 %type <string>			identifier type_identifier string comment_spec
 %destructor { xfree($$); }	identifier type_identifier string comment_spec
 
@@ -2534,6 +2536,10 @@ ct_stmt			:	CT	ct_key		SET	expr
 			{
 				$$ = ct_stmt_alloc(&@$, $2, $4);
 			}
+			|	NOTRACK
+			{
+				$$ = notrack_stmt_alloc(&@$);
+			}
 			;
 
 payload_stmt		:	payload_expr		SET	expr
diff --git a/src/scanner.l b/src/scanner.l
index 8b5a383bd095..29e7502d6cda 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -477,6 +477,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "dup"			{ return DUP; }
 "fwd"			{ return FWD; }
 
+"notrack"		{ return NOTRACK; }
+
 "xml"			{ return XML; }
 "json"			{ return JSON; }
 
-- 
2.1.4

