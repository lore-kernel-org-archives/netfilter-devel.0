From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/4] src: support zone set statement with optional direction
Date: Tue, 28 Feb 2017 01:03:47 +0100
Message-ID: <1488240228-1536-3-git-send-email-pablo@netfilter.org>
References: <1488240228-1536-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36448 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751470AbdB1CAn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 21:00:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C5BECE635
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:04:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE3BADA7F7
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:04:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B9AEDA80C
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:03:54 +0100 (CET)
In-Reply-To: <1488240228-1536-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

nft automatically understands 'ct zone set 1' but when a direction is
specified too we get a parser error since they are currently only
allowed for plain ct expressions.

This permits the existing syntax ('ct original zone') for all tokens with
an optional direction also for set statements.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Just a rebase on top of series to store byteorder for set data in
NFTA_SET_USERDATA.

 include/statement.h       |  2 ++
 src/ct.c                  |  7 +++++--
 src/netlink_delinearize.c |  6 +++++-
 src/netlink_linearize.c   |  4 ++++
 src/parser_bison.y        | 17 +++++++++++++++--
 5 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 8f874c881bd9..317d53e26140 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -127,10 +127,12 @@ struct ct_stmt {
 	enum nft_ct_keys		key;
 	const struct ct_template	*tmpl;
 	struct expr			*expr;
+	int8_t				direction;
 };
 
 extern struct stmt *ct_stmt_alloc(const struct location *loc,
 				  enum nft_ct_keys key,
+				  int8_t direction,
 				  struct expr *expr);
 struct dup_stmt {
 	struct expr		*to;
diff --git a/src/ct.c b/src/ct.c
index 3a6a4e574d69..83fceff67139 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -404,7 +404,8 @@ void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 
 static void ct_stmt_print(const struct stmt *stmt)
 {
-	printf("ct %s set ", ct_templates[stmt->ct.key].token);
+	ct_print(stmt->ct.key, stmt->ct.direction);
+	printf(" set ");
 	expr_print(stmt->ct.expr);
 }
 
@@ -415,7 +416,7 @@ static const struct stmt_ops ct_stmt_ops = {
 };
 
 struct stmt *ct_stmt_alloc(const struct location *loc, enum nft_ct_keys key,
-			     struct expr *expr)
+			   int8_t direction, struct expr *expr)
 {
 	struct stmt *stmt;
 
@@ -423,6 +424,8 @@ struct stmt *ct_stmt_alloc(const struct location *loc, enum nft_ct_keys key,
 	stmt->ct.key	= key;
 	stmt->ct.tmpl	= &ct_templates[key];
 	stmt->ct.expr	= expr;
+	stmt->ct.direction = direction;
+
 	return stmt;
 }
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 57b8fa5127e5..39347e01ed1c 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -659,6 +659,7 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 	uint32_t key;
 	struct stmt *stmt;
 	struct expr *expr;
+	int8_t dir = -1;
 
 	sreg = netlink_parse_register(nle, NFTNL_EXPR_CT_SREG);
 	expr = netlink_get_register(ctx, loc, sreg);
@@ -666,8 +667,11 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 		return netlink_error(ctx, loc,
 				     "ct statement has no expression");
 
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_CT_DIR))
+		dir = nftnl_expr_get_u8(nle, NFTNL_EXPR_CT_DIR);
+
 	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_CT_KEY);
-	stmt = ct_stmt_alloc(loc, key, expr);
+	stmt = ct_stmt_alloc(loc, key, dir, expr);
 	expr_set_type(expr, stmt->ct.tmpl->dtype, stmt->ct.tmpl->byteorder);
 
 	ctx->stmt = stmt;
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 8849b0e47268..48f34c25acda 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1151,6 +1151,10 @@ static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("ct");
 	netlink_put_register(nle, NFTNL_EXPR_CT_SREG, sreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_CT_KEY, stmt->ct.key);
+	if (stmt->ct.direction >= 0)
+		nftnl_expr_set_u8(nle, NFTNL_EXPR_CT_DIR,
+				  stmt->ct.direction);
+
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 80ac2bd03d39..36d4605021a3 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2977,7 +2977,7 @@ ct_key_dir_optional	:	BYTES		{ $$ = NFT_CT_BYTES; }
 
 ct_stmt			:	CT	ct_key		SET	expr
 			{
-				$$ = ct_stmt_alloc(&@$, $2, $4);
+				$$ = ct_stmt_alloc(&@$, $2, -1, $4);
 			}
 			|	CT	STRING		SET	expr
 			{
@@ -2990,7 +2990,20 @@ ct_stmt			:	CT	ct_key		SET	expr
 					YYERROR;
 				}
 
-				$$ = ct_stmt_alloc(&@$, key, $4);
+				$$ = ct_stmt_alloc(&@$, key, -1, $4);
+			}
+			|	CT	STRING	ct_key_dir_optional SET	expr
+			{
+				struct error_record *erec;
+				int8_t direction;
+
+				erec = ct_dir_parse(&@$, $2, &direction);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				$$ = ct_stmt_alloc(&@$, $3, direction, $5);
 			}
 			;
 
-- 
2.1.4

