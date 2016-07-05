From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] netlink_delinearize, meta: show meta prandom <= value as probability mnemonic
Date: Tue,  5 Jul 2016 09:35:35 +0200
Message-ID: <1467704135-9154-4-git-send-email-fw@strlen.de>
References: <1467704135-9154-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55926 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754189AbcGEHfZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2016 03:35:25 -0400
In-Reply-To: <1467704135-9154-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

During delinearization, check if we're looking at an expression
statement of the form

	  OP_LTE
META_PRANDOM  VALUE

And, if so, delete the expression statement and turn it into a
meta statement, where value expression is stashed inside the
meta statement struct.

We can do this because there is no 'set' support for prandom.
When printing a meta statement, check if the key is PRANDOM
and if so print the expression as a 'floating point' probability value.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/meta.c                | 16 ++++++++++++++++
 src/netlink_delinearize.c | 30 ++++++++++++++++++++++++++----
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 2b0d5f0..bf8a430 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -601,8 +601,24 @@ struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
 	return expr;
 }
 
+static void print_probability(const struct expr *expr)
+{
+	uint64_t value = mpz_get_uint64(expr->value);
+	double d, dividend;
+
+	dividend = (double)UINT_MAX;
+	d = (double)value;
+
+	printf("meta probability " META_PROB_FMT, d / dividend);
+}
+
 static void meta_stmt_print(const struct stmt *stmt)
 {
+	if (stmt->meta.key == NFT_META_PRANDOM) {
+		print_probability(stmt->meta.expr);
+		return;
+	}
+
 	if (meta_key_is_qualified(stmt->meta.key))
 		printf("meta %s set ", meta_templates[stmt->meta.key].token);
 	else
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 7735699..138132a 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1181,19 +1181,41 @@ static void ct_meta_common_postprocess(const struct expr *expr)
 static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 				   const struct expr *expr)
 {
+	struct stmt *nstmt, *stmt = ctx->stmt;
+	struct expr *right = expr->right;
 	struct expr *left = expr->left;
 
 	switch (expr->op) {
+	case OP_LTE: {
+		uint64_t value;
+
+		if (stmt->expr != expr ||
+		    left->meta.key != NFT_META_PRANDOM ||
+		    right->ops->type != EXPR_VALUE)
+			break;
+
+		value = mpz_get_uint64(right->value);
+		if (value < 4 || value > UINT_MAX)
+			break;
+
+		nstmt = meta_stmt_alloc(&stmt->location, NFT_META_PRANDOM,
+					expr_get(expr->right));
+
+		list_add_tail(&nstmt->list, &stmt->list);
+		list_del(&stmt->list);
+		stmt_free(stmt);
+		ctx->stmt = nstmt;
+		break;
+	}
 	case OP_EQ:
-		if (expr->right->ops->type == EXPR_RANGE)
+		if (right->ops->type == EXPR_RANGE)
 			break;
 
-		expr->left->ops->pctx_update(&ctx->pctx, expr);
+		left->ops->pctx_update(&ctx->pctx, expr);
 
 		if (ctx->pdctx.pbase == PROTO_BASE_INVALID &&
 		    left->flags & EXPR_F_PROTOCOL)
-			payload_dependency_store(&ctx->pdctx, ctx->stmt,
-						 left->meta.base);
+			payload_dependency_store(&ctx->pdctx, stmt, left->meta.base);
 		break;
 	default:
 		ct_meta_common_postprocess(expr);
-- 
2.7.3

