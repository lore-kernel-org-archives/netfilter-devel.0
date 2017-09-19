From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] evaluate: prepare to store expr key rather than datatype
Date: Tue, 19 Sep 2017 14:49:53 +0200
Message-ID: <20170919124954.26852-2-fw@strlen.de>
References: <20170919124954.26852-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54694 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751687AbdISMtk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2017 08:49:40 -0400
In-Reply-To: <20170919124954.26852-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

currently set definitions store a datatype rather than
an expression.

In order to support use of unqualified data types (string in particular),
this prepares implicit set definition helper to expect an expression instead
of plain data type.  This also has the advantage that we can use EXPR_CONCAT
to retain the original expressions when key concatentation is used, e.g.
'meta iifname . tcp dport'.  The netlink serialization code can use
this info to store individual key lengths independently of data types.

Would also allow later on to store the original names of the
expressions, e.g. "ip daddr", in the kernel to support a future
typeof keyword, e.g. 'type typeof(ip daddr)' instead of 'type ipv4_addr'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index e767542a868e..86159cf55f94 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -62,9 +62,7 @@ static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 
 static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 					     const char *name,
-					     const struct datatype *keytype,
-					     unsigned int keylen,
-					     unsigned int keybyteorder,
+					     struct expr *key,
 					     struct expr *expr)
 {
 	struct cmd *cmd;
@@ -74,8 +72,8 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	set = set_alloc(&expr->location);
 	set->flags	= NFT_SET_ANONYMOUS | expr->set_flags;
 	set->handle.set = xstrdup(name),
-	set->keytype 	= set_datatype_alloc(keytype, keybyteorder);
-	set->keylen	= keylen;
+	set->keytype 	= set_datatype_alloc(key->dtype, key->byteorder);
+	set->keylen	= key->len;
 	set->init	= expr;
 
 	if (ctx->table != NULL)
@@ -1184,6 +1182,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr_ctx ectx = ctx->ectx;
 	struct expr *map = *expr, *mappings;
+	struct expr *key;
 
 	expr_set_context(&ctx->ectx, NULL, 0);
 	if (expr_evaluate(ctx, &map->map) < 0)
@@ -1197,11 +1196,15 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 
 	switch (map->mappings->ops->type) {
 	case EXPR_SET:
+		key = constant_expr_alloc(&map->location,
+				 ctx->ectx.dtype,
+				 ctx->ectx.byteorder,
+				 ctx->ectx.len, NULL);
+
 		mappings = implicit_set_declaration(ctx, "__map%d",
-						    ctx->ectx.dtype,
-						    ctx->ectx.len,
-						    ctx->ectx.byteorder,
+						    key,
 						    mappings);
+		expr_free(key);
 
 		mappings->set->datatype = set_datatype_alloc(ectx.dtype,
 							     ectx.byteorder);
@@ -1539,8 +1542,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		if (right->ops->type == EXPR_SET)
 			right = rel->right =
 				implicit_set_declaration(ctx, "__set%d",
-							 left->dtype, left->len,
-							 left->byteorder, right);
+							 left, right);
 		else if (!datatype_equal(left->dtype, right->dtype))
 			return expr_binary_error(ctx->msgs, right, left,
 						 "datatype mismatch, expected %s, "
@@ -1597,9 +1599,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		case EXPR_SET:
 			assert(rel->op == OP_NEQ);
 			right = rel->right =
-				implicit_set_declaration(ctx, "__set%d",
-							 left->dtype, left->len,
-							 left->byteorder, right);
+				implicit_set_declaration(ctx, "__set%d", left, right);
 			/* fall through */
 		case EXPR_SET_REF:
 			assert(rel->op == OP_NEQ);
@@ -1978,8 +1978,7 @@ static int stmt_evaluate_flow(struct eval_ctx *ctx, struct stmt *stmt)
 		set->set_flags |= NFT_SET_TIMEOUT;
 
 	setref = implicit_set_declaration(ctx, stmt->flow.table ?: "__ft%d",
-					  key->dtype, key->len,
-					  key->dtype->byteorder, set);
+					  key, set);
 
 	stmt->flow.set = setref;
 
@@ -2609,6 +2608,7 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct expr *map = stmt->objref.expr;
 	struct expr *mappings;
+	struct expr *key;
 
 	expr_set_context(&ctx->ectx, NULL, 0);
 	if (expr_evaluate(ctx, &map->map) < 0)
@@ -2622,11 +2622,15 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 
 	switch (map->mappings->ops->type) {
 	case EXPR_SET:
+		key = constant_expr_alloc(&stmt->location,
+					  ctx->ectx.dtype,
+					  ctx->ectx.byteorder,
+					  ctx->ectx.len, NULL);
+
 		mappings = implicit_set_declaration(ctx, "__objmap%d",
-						    ctx->ectx.dtype,
-						    ctx->ectx.len,
-						    ctx->ectx.byteorder,
-						    mappings);
+						    key, mappings);
+		expr_free(key);
+
 		mappings->set->datatype = &string_type;
 		mappings->set->datalen  = NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE;
 		mappings->set->objtype  = stmt->objref.type;
-- 
2.13.5

