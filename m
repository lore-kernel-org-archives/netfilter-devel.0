From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 03/12] expr: add protocol context update callback
Date: Mon,  6 Jan 2014 17:27:18 +0000
Message-ID: <1389029247-27697-4-git-send-email-kaber@trash.net>
References: <1389029247-27697-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55579 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbaAFR1i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:27:38 -0500
In-Reply-To: <1389029247-27697-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a callback function to the expression ops to update the protocol
context for relational protocol expressions (EXPR_F_PROTOCOL).

Also set the EXPR_F_PROTOCOL flag for IIFTYPE meta expressions to make
sure the callback is invoked when necessary.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h      |  4 ++++
 include/meta.h            |  2 --
 include/payload.h         |  3 ---
 src/evaluate.c            | 18 +++++++----------
 src/meta.c                | 13 +++++++++++-
 src/netlink_delinearize.c |  4 ++--
 src/payload.c             | 50 ++++++++++++++++++++++++-----------------------
 7 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 2b7b379..59b27c0 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -118,7 +118,9 @@ static inline void expr_set_context(struct expr_ctx *ctx,
  * @destroy:	destructor, must release inner expressions
  * @set_type:	function to promote type and byteorder of inner types
  * @print:	function to print the expression
+ * @pctx_update:update protocol context
  */
+struct proto_ctx;
 struct expr_ops {
 	enum expr_types		type;
 	const char		*name;
@@ -128,6 +130,8 @@ struct expr_ops {
 					    const struct datatype *dtype,
 					    enum byteorder byteorder);
 	void			(*print)(const struct expr *expr);
+	void			(*pctx_update)(struct proto_ctx *ctx,
+					       const struct expr *expr);
 };
 
 /**
diff --git a/include/meta.h b/include/meta.h
index 23f78cf..459221f 100644
--- a/include/meta.h
+++ b/include/meta.h
@@ -25,7 +25,5 @@ struct meta_template {
 
 extern struct expr *meta_expr_alloc(const struct location *loc,
 				    enum nft_meta_keys key);
-extern void meta_expr_pctx_update(struct proto_ctx *ctx,
-				  const struct expr *expr);
 
 #endif /* NFTABLES_META_H */
diff --git a/include/payload.h b/include/payload.h
index 54d8d54..d47e564 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -10,9 +10,6 @@ extern struct expr *payload_expr_alloc(const struct location *loc,
 extern void payload_init_raw(struct expr *expr, enum proto_bases base,
 			     unsigned int offset, unsigned int len);
 
-extern void payload_expr_pctx_update(struct proto_ctx *ctx,
-				     const struct expr *expr);
-
 struct eval_ctx;
 extern int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				  struct expr **res);
diff --git a/src/evaluate.c b/src/evaluate.c
index aed2c55..787d04e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -919,18 +919,14 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		 * Update protocol context for payload and meta iiftype
 		 * equality expressions.
 		 */
-		switch (left->ops->type) {
-		case EXPR_PAYLOAD:
-			payload_expr_pctx_update(&ctx->pctx, rel);
-			break;
-		case EXPR_META:
-			meta_expr_pctx_update(&ctx->pctx, rel);
-			break;
-		case EXPR_CONCAT:
+		if (left->flags & EXPR_F_PROTOCOL &&
+		    left->ops->pctx_update)
+			left->ops->pctx_update(&ctx->pctx, rel);
+
+		if (left->ops->type == EXPR_CONCAT)
 			return 0;
-		default:
-			break;
-		}
+
+		/* fall through */
 	case OP_NEQ:
 	case OP_FLAGCMP:
 		if (!datatype_equal(left->dtype, right->dtype))
diff --git a/src/meta.c b/src/meta.c
index 343f9a3..9173c30 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -349,7 +349,8 @@ static void meta_expr_clone(struct expr *new, const struct expr *expr)
  *
  * Update LL protocol context based on IIFTYPE meta match in non-LL hooks.
  */
-void meta_expr_pctx_update(struct proto_ctx *ctx, const struct expr *expr)
+static void meta_expr_pctx_update(struct proto_ctx *ctx,
+				  const struct expr *expr)
 {
 	const struct hook_proto_desc *h = &hook_proto_desc[ctx->family];
 	const struct expr *left = expr->left, *right = expr->right;
@@ -375,6 +376,7 @@ static const struct expr_ops meta_expr_ops = {
 	.name		= "meta",
 	.print		= meta_expr_print,
 	.clone		= meta_expr_clone,
+	.pctx_update	= meta_expr_pctx_update,
 };
 
 struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
@@ -385,6 +387,15 @@ struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
 	expr = expr_alloc(loc, &meta_expr_ops, tmpl->dtype,
 			  tmpl->byteorder, tmpl->len);
 	expr->meta.key = key;
+
+	switch (key) {
+	case NFT_META_IIFTYPE:
+		expr->flags |= EXPR_F_PROTOCOL;
+		break;
+	default:
+		break;
+	}
+
 	return expr;
 }
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e171e04..e9b0514 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -570,7 +570,7 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 
 			nexpr = relational_expr_alloc(&expr->location, expr->op,
 						      left, tmp);
-			payload_expr_pctx_update(&ctx->pctx, nexpr);
+			left->ops->pctx_update(&ctx->pctx, nexpr);
 
 			nstmt = expr_stmt_alloc(&stmt->location, nexpr);
 			list_add_tail(&nstmt->list, &stmt->list);
@@ -602,7 +602,7 @@ static void meta_match_postprocess(struct proto_ctx *ctx,
 {
 	switch (expr->op) {
 	case OP_EQ:
-		meta_expr_pctx_update(ctx, expr);
+		expr->left->ops->pctx_update(ctx, expr);
 		break;
 	default:
 		break;
diff --git a/src/payload.c b/src/payload.c
index 7721b75..426adc3 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -48,11 +48,37 @@ static void payload_expr_clone(struct expr *new, const struct expr *expr)
 	new->payload.offset = expr->payload.offset;
 }
 
+/**
+ * payload_expr_pctx_update - update protocol context based on payload match
+ *
+ * @ctx:	protocol context
+ * @expr:	relational payload expression
+ *
+ * Update protocol context for relational payload expressions.
+ */
+static void payload_expr_pctx_update(struct proto_ctx *ctx,
+				     const struct expr *expr)
+{
+	const struct expr *left = expr->left, *right = expr->right;
+	const struct proto_desc *base, *desc;
+
+	if (!(left->flags & EXPR_F_PROTOCOL))
+		return;
+
+	assert(expr->op == OP_EQ);
+	base = ctx->protocol[left->payload.base].desc;
+	desc = proto_find_upper(base, mpz_get_uint32(right->value));
+
+	ctx->protocol[left->payload.base + 1].location = expr->location;
+	ctx->protocol[left->payload.base + 1].desc = desc;
+}
+
 static const struct expr_ops payload_expr_ops = {
 	.type		= EXPR_PAYLOAD,
 	.name		= "payload",
 	.print		= payload_expr_print,
 	.clone		= payload_expr_clone,
+	.pctx_update	= payload_expr_pctx_update,
 };
 
 struct expr *payload_expr_alloc(const struct location *loc,
@@ -95,30 +121,6 @@ void payload_init_raw(struct expr *expr, enum proto_bases base,
 }
 
 /**
- * payload_expr_pctx_update - update protocol context based on payload match
- *
- * @ctx:	protocol context
- * @expr:	relational payload expression
- *
- * Update protocol context for relational payload expressions.
- */
-void payload_expr_pctx_update(struct proto_ctx *ctx, const struct expr *expr)
-{
-	const struct expr *left = expr->left, *right = expr->right;
-	const struct proto_desc *base, *desc;
-
-	if (!(left->flags & EXPR_F_PROTOCOL))
-		return;
-
-	assert(expr->op == OP_EQ);
-	base = ctx->protocol[left->payload.base].desc;
-	desc = proto_find_upper(base, mpz_get_uint32(right->value));
-
-	ctx->protocol[left->payload.base + 1].location = expr->location;
-	ctx->protocol[left->payload.base + 1].desc = desc;
-}
-
-/**
  * payload_gen_dependency - generate match expression on payload dependency
  *
  * @ctx:	evaluation context
-- 
1.8.4.2

