From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH nft 2/6] set: explicitly supply name to implicit set declarations
Date: Fri,  6 Nov 2015 18:34:19 +0000
Message-ID: <1446834863-18610-3-git-send-email-kaber@trash.net>
References: <1446834863-18610-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:47970 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751354AbbKFSe1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 13:34:27 -0500
In-Reply-To: <1446834863-18610-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support explicitly named implicitly declared sets.

Also change the template names for literal sets and maps to use identifiers
that can not clash with user supplied identifiers.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index f53ba5e..68d6bff 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -81,6 +81,7 @@ static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 }
 
 static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
+					     const char *name,
 					     const struct datatype *keytype,
 					     unsigned int keylen,
 					     struct expr *expr)
@@ -91,7 +92,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 
 	set = set_alloc(&expr->location);
 	set->flags	= SET_F_ANONYMOUS | expr->set_flags;
-	set->handle.set = xstrdup(set->flags & SET_F_MAP ? "map%d" : "set%d");
+	set->handle.set = xstrdup(name),
 	set->keytype 	= keytype;
 	set->keylen	= keylen;
 	set->init	= expr;
@@ -912,7 +913,8 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 
 	switch (map->mappings->ops->type) {
 	case EXPR_SET:
-		mappings = implicit_set_declaration(ctx, ctx->ectx.dtype,
+		mappings = implicit_set_declaration(ctx, "__map%d",
+						    ctx->ectx.dtype,
 						    ctx->ectx.len, mappings);
 		mappings->set->datatype = ectx.dtype;
 		mappings->set->datalen  = ectx.len;
@@ -1123,7 +1125,9 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
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
2.4.3

