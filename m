From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 4/6] payload: add payload_is_stacked()
Date: Sun, 24 Apr 2016 22:30:38 +0100
Message-ID: <1461533440-10605-5-git-send-email-kaber@trash.net>
References: <1461533440-10605-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52076 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbcDXVjU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Apr 2016 17:39:20 -0400
In-Reply-To: <1461533440-10605-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add payload_is_stacked() to determine whether a protocol expression match defines
a stacked protocol on the same layer.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/payload.h         |  2 ++
 src/netlink_delinearize.c | 28 +++++-----------------------
 src/payload.c             | 20 ++++++++++++++++++++
 3 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index eb9ff17..b180ff5 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -30,6 +30,8 @@ struct payload_dep_ctx {
 	struct stmt		*prev;
 };
 
+extern bool payload_is_stacked(const struct proto_desc *desc,
+			       const struct expr *expr);
 extern void payload_dependency_store(struct payload_dep_ctx *ctx,
 				     struct stmt *stmt,
 				     enum proto_bases base);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 59e5f3e..84f94fc 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1032,27 +1032,6 @@ static void integer_type_postprocess(struct expr *expr)
 	}
 }
 
-static void payload_dependency_save(struct rule_pp_ctx *ctx, unsigned int base,
-				    struct stmt *nstmt, struct expr *tmp)
-{
-	unsigned int proto = mpz_get_be16(tmp->value);
-	const struct proto_desc *desc, *next;
-	bool stacked_header = false;
-
-	desc = ctx->pctx.protocol[base].desc;
-
-	assert(desc);
-	if (desc) {
-		next = proto_find_upper(desc, proto);
-		stacked_header = next && next->base == base;
-	}
-
-	if (stacked_header)
-		payload_dependency_store(&ctx->pdctx, nstmt, base - 1);
-	else
-		payload_dependency_store(&ctx->pdctx, nstmt, base);
-}
-
 static void payload_match_expand(struct rule_pp_ctx *ctx,
 				 struct expr *expr,
 				 struct expr *payload)
@@ -1063,6 +1042,7 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 	struct expr *nexpr = NULL;
 	enum proto_bases base = left->payload.base;
 	const struct expr_ops *payload_ops = left->ops;
+	bool stacked;
 
 	payload_expr_expand(&list, left, &ctx->pctx);
 
@@ -1084,6 +1064,8 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		assert(left->payload.base);
 		assert(base == left->payload.base);
 
+		stacked = payload_is_stacked(ctx->pctx.protocol[base].desc, nexpr);
+
 		/* Remember the first payload protocol expression to
 		 * kill it later on if made redundant by a higher layer
 		 * payload expression.
@@ -1091,11 +1073,11 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		if (ctx->pdctx.pbase == PROTO_BASE_INVALID &&
 		    expr->op == OP_EQ &&
 		    left->flags & EXPR_F_PROTOCOL) {
-			payload_dependency_save(ctx, base, nstmt, tmp);
+			payload_dependency_store(&ctx->pdctx, nstmt, base - stacked);
 		} else {
 			payload_dependency_kill(&ctx->pdctx, nexpr->left);
 			if (left->flags & EXPR_F_PROTOCOL)
-				payload_dependency_save(ctx, base, nstmt, tmp);
+				payload_dependency_store(&ctx->pdctx, nstmt, base - stacked);
 		}
 	}
 	list_del(&ctx->stmt->list);
diff --git a/src/payload.c b/src/payload.c
index 9dca56b..0bbfb54 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -322,6 +322,26 @@ int exthdr_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 }
 
 /**
+ * payload_is_stacked - return whether a payload protocol match defines a stacked
+ * 			protocol on the same layer
+ *
+ * @desc: current protocol description on this layer
+ * @expr: payload match
+ */
+bool payload_is_stacked(const struct proto_desc *desc, const struct expr *expr)
+{
+	const struct proto_desc *next;
+
+	if (expr->left->ops->type != EXPR_PAYLOAD ||
+	    !(expr->left->flags & EXPR_F_PROTOCOL) ||
+	    expr->op != OP_EQ)
+		return false;
+
+	next = proto_find_upper(desc, mpz_get_be16(expr->right->value));
+	return next && next->base == desc->base;
+}
+
+/**
  * payload_dependency_store - store a possibly redundant protocol match
  *
  * @ctx: payload dependency context
-- 
2.5.5

