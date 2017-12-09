From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] Fix protocol context update on big-endian systems
Date: Sat,  9 Dec 2017 16:52:29 +0100
Message-ID: <20171209155229.21809-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49408 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbdLIPwl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Dec 2017 10:52:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is an obscure bug on big-endian systems when trying to list a rule
containing the expression 'ct helper tftp' which triggers the assert()
call in mpz_get_type().

Florian identified the cause: ct_expr_pctx_update() is called for the
relational expression which calls mpz_get_uint32() to get RHS value
(assuming it is a protocol number). On big-endian systems, the
misinterpreted value exceeds UINT_MAX.

Expressions' pctx_update() callback should only be called for protocol
matches, so ct_meta_common_postprocess() lacked a check for 'left->flags
& EXPR_F_PROTOCOL' like the one already present in
payload_expr_pctx_update().

In order to fix this in a clean way, this patch introduces a wrapper
relational_expr_pctx_update() to be used instead of directly calling
LHS's pctx_update() callback which unifies the necessary checks (and
adds one more assert):

- assert(expr->ops->type == EXPR_RELATIONAL)
  -> This is new, just to ensure the wrapper is called properly.
- assert(expr->op == OP_EQ)
  -> This was moved from {ct,meta,payload}_expr_pctx_update().
- left->ops->pctx_update != NULL
  -> This was taken from expr_evaluate_relational(), a necessary
     requirement for the introduced wrapper to function at all.
- (left->flags & EXPR_F_PROTOCOL) != 0
  -> The crucial missing check which led to the problem.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expression.h      |  3 +++
 src/ct.c                  |  2 --
 src/evaluate.c            |  6 ++----
 src/expression.c          | 15 +++++++++++++++
 src/meta.c                |  2 --
 src/netlink.c             |  2 +-
 src/netlink_delinearize.c |  4 ++--
 src/payload.c             |  7 +------
 8 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 215cbc98e8d70..915ce0bad04df 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -369,6 +369,9 @@ extern struct expr *binop_expr_alloc(const struct location *loc, enum ops op,
 extern struct expr *relational_expr_alloc(const struct location *loc, enum ops op,
 					  struct expr *left, struct expr *right);
 
+extern void relational_expr_pctx_update(struct proto_ctx *ctx,
+					const struct expr *expr);
+
 extern struct expr *verdict_expr_alloc(const struct location *loc,
 				       int verdict, const char *chain);
 
diff --git a/src/ct.c b/src/ct.c
index 4633127d5ec6d..d5347974bd0d5 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -327,8 +327,6 @@ static void ct_expr_pctx_update(struct proto_ctx *ctx, const struct expr *expr)
 	const struct proto_desc *base = NULL, *desc;
 	uint32_t nhproto;
 
-	assert(expr->op == OP_EQ);
-
 	nhproto = mpz_get_uint32(right->value);
 
 	base = ctx->protocol[left->ct.base].desc;
diff --git a/src/evaluate.c b/src/evaluate.c
index 758e7bbe59393..7fe738d8d590a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -746,7 +746,7 @@ static int ct_gen_nh_dependency(struct eval_ctx *ctx, struct expr *ct)
 				    constant_data_ptr(ct->ct.nfproto, left->len));
 	dep = relational_expr_alloc(&ct->location, OP_EQ, left, right);
 
-	left->ops->pctx_update(&ctx->pctx, dep);
+	relational_expr_pctx_update(&ctx->pctx, dep);
 
 	nstmt = expr_stmt_alloc(&dep->location, dep);
 
@@ -1635,9 +1635,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		 * Update protocol context for payload and meta iiftype
 		 * equality expressions.
 		 */
-		if (left->flags & EXPR_F_PROTOCOL &&
-		    left->ops->pctx_update)
-			left->ops->pctx_update(&ctx->pctx, rel);
+		relational_expr_pctx_update(&ctx->pctx, rel);
 
 		if (left->ops->type == EXPR_CONCAT)
 			return 0;
diff --git a/src/expression.c b/src/expression.c
index 273038e62d2e9..9b521e6c7e673 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -600,6 +600,21 @@ struct expr *relational_expr_alloc(const struct location *loc, enum ops op,
 	return expr;
 }
 
+void relational_expr_pctx_update(struct proto_ctx *ctx,
+				 const struct expr *expr)
+{
+	struct expr *left = expr->left;
+
+	assert(expr->ops->type == EXPR_RELATIONAL);
+	assert(expr->op == OP_EQ);
+
+	if (!left->ops->pctx_update ||
+	    !(left->flags & EXPR_F_PROTOCOL))
+		return;
+
+	left->ops->pctx_update(ctx, expr);
+}
+
 static void range_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	octx->numeric += NFT_NUMERIC_ALL + 1;
diff --git a/src/meta.c b/src/meta.c
index 28aebe396f17e..687de8cda8c35 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -482,8 +482,6 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 	const struct proto_desc *desc;
 	uint8_t protonum;
 
-	assert(expr->op == OP_EQ);
-
 	switch (left->meta.key) {
 	case NFT_META_IIFTYPE:
 		if (h->base < PROTO_BASE_NETWORK_HDR &&
diff --git a/src/netlink.c b/src/netlink.c
index 6735971ac1f39..8653ae6e70c76 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2730,7 +2730,7 @@ restart:
 		list_add_tail(&stmt->list, &unordered);
 
 		desc = ctx->protocol[base].desc;
-		lhs->ops->pctx_update(ctx, rel);
+		relational_expr_pctx_update(ctx, rel);
 	}
 
 	expr_free(rhs);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 67dbd27dd7a70..2637f4baaec4c 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1329,7 +1329,7 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		nexpr = relational_expr_alloc(&expr->location, expr->op,
 					      left, tmp);
 		if (expr->op == OP_EQ)
-			left->ops->pctx_update(&ctx->pctx, nexpr);
+			relational_expr_pctx_update(&ctx->pctx, nexpr);
 
 		nstmt = expr_stmt_alloc(&ctx->stmt->location, nexpr);
 		list_add_tail(&nstmt->list, &ctx->stmt->list);
@@ -1397,7 +1397,7 @@ static void ct_meta_common_postprocess(struct rule_pp_ctx *ctx,
 		if (expr->right->ops->type == EXPR_RANGE)
 			break;
 
-		expr->left->ops->pctx_update(&ctx->pctx, expr);
+		relational_expr_pctx_update(&ctx->pctx, expr);
 
 		if (ctx->pdctx.pbase == PROTO_BASE_INVALID &&
 		    left->flags & EXPR_F_PROTOCOL) {
diff --git a/src/payload.c b/src/payload.c
index aa8a95ad59f1c..60090accbcd8b 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -84,11 +84,6 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 	const struct proto_desc *base, *desc;
 	unsigned int proto = 0;
 
-	if (!(left->flags & EXPR_F_PROTOCOL))
-		return;
-
-	assert(expr->op == OP_EQ);
-
 	/* Export the data in the correct byte order */
 	assert(right->len / BITS_PER_BYTE <= sizeof(proto));
 	mpz_export_data(constant_data_ptr(proto, right->len), right->value,
@@ -240,7 +235,7 @@ static int payload_add_dependency(struct eval_ctx *ctx,
 		return expr_error(ctx->msgs, expr,
 					  "dependency statement is invalid");
 	}
-	left->ops->pctx_update(&ctx->pctx, dep);
+	relational_expr_pctx_update(&ctx->pctx, dep);
 	*res = stmt;
 	return 0;
 }
-- 
2.13.1

