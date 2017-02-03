From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 8/9] src: support zone set statement with optional direction
Date: Fri,  3 Feb 2017 13:35:55 +0100
Message-ID: <20170203123556.17357-9-fw@strlen.de>
References: <20170203123556.17357-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41984 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752700AbdBCMgF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 07:36:05 -0500
In-Reply-To: <20170203123556.17357-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft automatically understands 'ct zone set 1' but when a direction is
specified too we get a parser error since they are currently only
allowed for plain ct expressions.

This permits the existing syntax ('ct original zone') for all tokens with
an optional direction also for set statements.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
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
index 7e09c5b246b2..2edbdacfca01 100644
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
index 48968442d9bc..fe3c865cab54 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -657,6 +657,7 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 	uint32_t key;
 	struct stmt *stmt;
 	struct expr *expr;
+	int8_t dir = -1;
 
 	sreg = netlink_parse_register(nle, NFTNL_EXPR_CT_SREG);
 	expr = netlink_get_register(ctx, loc, sreg);
@@ -664,8 +665,11 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
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
index 5030135cd5d5..9979b7867715 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1150,6 +1150,10 @@ static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
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
index 14d924810f9a..61ecf08c747e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2969,7 +2969,7 @@ ct_key_dir_optional	:	BYTES		{ $$ = NFT_CT_BYTES; }
 
 ct_stmt			:	CT	ct_key		SET	expr
 			{
-				$$ = ct_stmt_alloc(&@$, $2, $4);
+				$$ = ct_stmt_alloc(&@$, $2, -1, $4);
 			}
 			|	CT	STRING		SET	expr
 			{
@@ -2982,7 +2982,20 @@ ct_stmt			:	CT	ct_key		SET	expr
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
2.10.2

