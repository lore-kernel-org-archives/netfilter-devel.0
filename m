From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] evaluate: store byteorder for set keys
Date: Sat, 25 Feb 2017 11:53:59 +0100
Message-ID: <1488020040-24025-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57624 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751665AbdBYKyf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Feb 2017 05:54:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F096EA417B
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 11:54:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1836DA807
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 11:54:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9AB2DDA7E0
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 11:54:15 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Selectors that rely on the integer type and expect host endian
byteorder don't work properly.

We need to keep the byteorder around based on the left hand size
expression that provides the context, so store the byteorder when
evaluating the map.

Before this patch.

 # nft --debug=netlink add rule x y meta mark set meta cpu map { 0 : 1, 1 : 2 }
 __map%d x b
 __map%d x 0
        element 00000000  : 00000001 0 [end]    element 01000000  : 00000002 0 [end]
                                                        ^^^^^^^^

This is expressed in network byteorder, because the invalid byteorder
defaults on this.

After this patch:

 # nft --debug=netlink add rule x y meta mark set meta cpu map { 0 : 1, 1 : 2 }
 __map%d x b
 __map%d x 0
        element 00000000  : 00000001 0 [end]    element 00000001  : 00000002 0 [end]
                                                        ^^^^^^^^

This is in host byteorder, as the key selector in the map mandates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h |  4 ++++
 src/datatype.c     | 48 +++++++++++++++++++++++++++++++++++++++++++-----
 src/evaluate.c     | 17 +++++++++++------
 src/rule.c         |  1 +
 4 files changed, 59 insertions(+), 11 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 9f127f2954e3..68fb2a6c2431 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -251,6 +251,10 @@ concat_subtype_lookup(uint32_t type, unsigned int n)
 	return datatype_lookup(concat_subtype_id(type, n));
 }
 
+extern const struct datatype *
+set_keytype_alloc(const struct datatype *orig_dtype, unsigned int byteorder);
+extern void set_keytype_destroy(const struct datatype *dtype);
+
 extern void time_print(uint64_t seconds);
 extern struct error_record *time_parse(const struct location *loc,
 				       const char *c, uint64_t *res);
diff --git a/src/datatype.c b/src/datatype.c
index f1388dc52d96..bfc8817c2b83 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -965,6 +965,28 @@ static struct datatype *dtype_alloc(void)
 	return dtype;
 }
 
+static struct datatype *dtype_clone(const struct datatype *orig_dtype)
+{
+	struct datatype *dtype;
+
+	dtype = xzalloc(sizeof(*dtype));
+	*dtype = *orig_dtype;
+	dtype->name = xstrdup(orig_dtype->name);
+	dtype->desc = xstrdup(orig_dtype->desc);
+	dtype->flags = DTYPE_F_ALLOC;
+
+	return dtype;
+}
+
+static void dtype_free(const struct datatype *dtype)
+{
+	if (dtype->flags & DTYPE_F_ALLOC) {
+		xfree(dtype->name);
+		xfree(dtype->desc);
+		xfree(dtype);
+	}
+}
+
 const struct datatype *concat_type_alloc(uint32_t type)
 {
 	const struct datatype *i;
@@ -1004,11 +1026,27 @@ const struct datatype *concat_type_alloc(uint32_t type)
 
 void concat_type_destroy(const struct datatype *dtype)
 {
-	if (dtype->flags & DTYPE_F_ALLOC) {
-		xfree(dtype->name);
-		xfree(dtype->desc);
-		xfree(dtype);
-	}
+	dtype_free(dtype);
+}
+
+const struct datatype *set_keytype_alloc(const struct datatype *orig_dtype,
+					 unsigned int byteorder)
+{
+	struct datatype *dtype;
+
+	/* Restrict dynamic datatype allocation to generic integer datatype. */
+	if (orig_dtype != &integer_type)
+		return orig_dtype;
+
+	dtype = dtype_clone(orig_dtype);
+	dtype->byteorder = byteorder;
+
+	return dtype;
+}
+
+void set_keytype_destroy(const struct datatype *dtype)
+{
+	dtype_free(dtype);
 }
 
 static struct error_record *time_unit_parse(const struct location *loc,
diff --git a/src/evaluate.c b/src/evaluate.c
index 4817a55c82ef..87da2fd83597 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -63,6 +63,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 					     const char *name,
 					     const struct datatype *keytype,
 					     unsigned int keylen,
+					     unsigned int keybyteorder,
 					     struct expr *expr)
 {
 	struct cmd *cmd;
@@ -72,7 +73,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	set = set_alloc(&expr->location);
 	set->flags	= NFT_SET_ANONYMOUS | expr->set_flags;
 	set->handle.set = xstrdup(name),
-	set->keytype 	= keytype;
+	set->keytype 	= set_keytype_alloc(keytype, keybyteorder);
 	set->keylen	= keylen;
 	set->init	= expr;
 
@@ -1170,7 +1171,9 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	case EXPR_SET:
 		mappings = implicit_set_declaration(ctx, "__map%d",
 						    ctx->ectx.dtype,
-						    ctx->ectx.len, mappings);
+						    ctx->ectx.len,
+						    ctx->ectx.byteorder,
+						    mappings);
 		mappings->set->datatype = ectx.dtype;
 		mappings->set->datalen  = ectx.len;
 
@@ -1505,8 +1508,8 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		if (right->ops->type == EXPR_SET)
 			right = rel->right =
 				implicit_set_declaration(ctx, "__set%d",
-							 left->dtype,
-							 left->len, right);
+							 left->dtype, left->len,
+							 left->byteorder, right);
 		else if (!datatype_equal(left->dtype, right->dtype))
 			return expr_binary_error(ctx->msgs, right, left,
 						 "datatype mismatch, expected %s, "
@@ -1565,7 +1568,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 			right = rel->right =
 				implicit_set_declaration(ctx, "__set%d",
 							 left->dtype, left->len,
-							 right);
+							 left->byteorder, right);
 			/* fall through */
 		case EXPR_SET_REF:
 			assert(rel->op == OP_NEQ);
@@ -1886,7 +1889,8 @@ static int stmt_evaluate_flow(struct eval_ctx *ctx, struct stmt *stmt)
 		set->set_flags |= NFT_SET_TIMEOUT;
 
 	setref = implicit_set_declaration(ctx, stmt->flow.table ?: "__ft%d",
-					  key->dtype, key->len, set);
+					  key->dtype, key->len,
+					  key->dtype->byteorder, set);
 
 	stmt->flow.set = setref;
 
@@ -2518,6 +2522,7 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 		mappings = implicit_set_declaration(ctx, "__objmap%d",
 						    ctx->ectx.dtype,
 						    ctx->ectx.len,
+						    ctx->ectx.byteorder,
 						    mappings);
 		mappings->set->datatype = &string_type;
 		mappings->set->datalen  = NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE;
diff --git a/src/rule.c b/src/rule.c
index 0d58073f7333..b47076f000ee 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -210,6 +210,7 @@ void set_free(struct set *set)
 	if (set->init != NULL)
 		expr_free(set->init);
 	handle_free(&set->handle);
+	set_keytype_destroy(set->keytype);
 	xfree(set);
 }
 
-- 
2.1.4

