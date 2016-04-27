From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 3/7] set: explicitly supply name to implicit set declarations
Date: Wed, 27 Apr 2016 12:29:46 +0100
Message-ID: <1461756590-22880-4-git-send-email-kaber@trash.net>
References: <1461756590-22880-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33527 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbcD0L35 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 07:29:57 -0400
In-Reply-To: <1461756590-22880-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support explicitly names implicitly declared sets.

Also change the template names for literal sets and maps to use identifiers
that can not clash with user supplied identifiers.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 9c8add3..aa9fa43 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -87,6 +87,7 @@ static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 }
 
 static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
+					     const char *name,
 					     const struct datatype *keytype,
 					     unsigned int keylen,
 					     struct expr *expr)
@@ -97,7 +98,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 
 	set = set_alloc(&expr->location);
 	set->flags	= SET_F_ANONYMOUS | expr->set_flags;
-	set->handle.set = xstrdup(set->flags & SET_F_MAP ? "map%d" : "set%d");
+	set->handle.set = xstrdup(name),
 	set->keytype 	= keytype;
 	set->keylen	= keylen;
 	set->init	= expr;
@@ -988,7 +989,8 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 
 	switch (map->mappings->ops->type) {
 	case EXPR_SET:
-		mappings = implicit_set_declaration(ctx, ctx->ectx.dtype,
+		mappings = implicit_set_declaration(ctx, "__map%d",
+						    ctx->ectx.dtype,
 						    ctx->ectx.len, mappings);
 		mappings->set->datatype = ectx.dtype;
 		mappings->set->datalen  = ectx.len;
@@ -1199,7 +1201,9 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		/* A literal set expression implicitly declares the set */
 		if (right->ops->type == EXPR_SET)
 			right = rel->right =
-				implicit_set_declaration(ctx, left->dtype, left->len, right);
+				implicit_set_declaration(ctx, "__set%d",
+							 left->dtype,
+							 left->len, right);
 		else if (!datatype_equal(left->dtype, right->dtype))
 			return expr_binary_error(ctx->msgs, right, left,
 						 "datatype mismatch, expected %s, "
-- 
2.5.5

