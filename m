From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] src: Code indent should use tabs wherever possible
Date: Sun,  8 Oct 2017 16:46:04 +0530
Message-ID: <20171008111604.18781-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36044 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751556AbdJHLSQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Oct 2017 07:18:16 -0400
Received: by mail-pg0-f68.google.com with SMTP id u144so5505149pgb.3
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Oct 2017 04:18:16 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove unnecessary spaces and use tabs for code indent.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 src/datatype.c |  2 +-
 src/evaluate.c | 10 +++++-----
 src/gmputil.c  |  4 ++--
 src/meta.c     |  4 ++--
 src/netlink.c  |  6 +++---
 src/segtree.c  |  4 ++--
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 94b1224..d83ecec 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -370,7 +370,7 @@ static void string_type_print(const struct expr *expr, struct output_ctx *octx)
 }
 
 static struct error_record *string_type_parse(const struct expr *sym,
-	      				      struct expr **res)
+					      struct expr **res)
 {
 	*res = constant_expr_alloc(&sym->location, &string_type,
 				   BYTEORDER_HOST_ENDIAN,
diff --git a/src/evaluate.c b/src/evaluate.c
index 193ea1c..79af65c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -132,7 +132,7 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 		return 0;
 	if (expr_basetype(*expr)->type != TYPE_INTEGER)
 		return expr_error(ctx->msgs, *expr,
-			 	  "Byteorder mismatch: expected %s, got %s",
+				  "Byteorder mismatch: expected %s, got %s",
 				  byteorder_names[byteorder],
 				  byteorder_names[(*expr)->byteorder]);
 
@@ -1388,7 +1388,7 @@ static int expr_evaluate_hash(struct eval_ctx *ctx, struct expr **exprp)
 		return -1;
 
 	/* expr_evaluate_primary() sets the context to what to the input
-         * expression to be hashed. Since this input is transformed to a 4 bytes
+	 * expression to be hashed. Since this input is transformed to a 4 bytes
 	 * integer, restore context to the datatype that results from hashing.
 	 */
 	__expr_set_context(&ctx->ectx, expr->dtype, expr->byteorder, expr->len,
@@ -1691,7 +1691,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		case EXPR_CONCAT:
 			return expr_binary_error(ctx->msgs, left, rel,
 					"Relational expression (%s) is undefined "
-				        "for %s expressions",
+					"for %s expressions",
 					expr_op_symbols[rel->op],
 					left->ops->name);
 		default:
@@ -1701,7 +1701,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		if (!expr_is_singleton(right))
 			return expr_binary_error(ctx->msgs, right, rel,
 					"Relational expression (%s) is undefined "
-				        "for %s expressions",
+					"for %s expressions",
 					expr_op_symbols[rel->op],
 					right->ops->name);
 
@@ -1723,7 +1723,7 @@ range:
 		case EXPR_CONCAT:
 			return expr_binary_error(ctx->msgs, left, rel,
 					"Relational expression (%s) is undefined"
-				        "for %s expressions",
+					"for %s expressions",
 					expr_op_symbols[rel->op],
 					left->ops->name);
 		default:
diff --git a/src/gmputil.c b/src/gmputil.c
index 3cc4e61..a817bb8 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -50,11 +50,11 @@ void mpz_rshift_ui(mpz_t rop, unsigned int n)
 
 #define mpz_get_type(type, endian, op)					\
 ({									\
- 	type ret = 0;							\
+	type ret = 0;							\
 	size_t cnt;							\
 	mpz_export(&ret, &cnt, MPZ_LSWF, sizeof(ret), endian, 0, op);	\
 	assert(cnt <= 1);						\
- 	ret;								\
+	ret;								\
  })
 
 uint64_t mpz_get_uint64(const mpz_t op)
diff --git a/src/meta.c b/src/meta.c
index 56b9e29..e387028 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -625,8 +625,8 @@ struct stmt *meta_stmt_meta_iiftype(const struct location *loc, uint16_t type)
 }
 
 struct error_record *meta_key_parse(const struct location *loc,
-                                    const char *str,
-                                    unsigned int *value)
+				    const char *str,
+				    unsigned int *value)
 {
 	int ret, len, offset = 0;
 	const char *sep = "";
diff --git a/src/netlink.c b/src/netlink.c
index d5d410a..c1d0d56 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -445,7 +445,7 @@ struct expr *netlink_alloc_data(const struct location *loc,
 
 int netlink_add_rule_batch(struct netlink_ctx *ctx,
 			   const struct handle *h,
-		           const struct rule *rule, uint32_t flags)
+			   const struct rule *rule, uint32_t flags)
 {
 	struct nftnl_rule *nlr;
 	int err;
@@ -2117,7 +2117,7 @@ out:
 /* returns true if the event should be ignored (i.e. null element) */
 static bool netlink_event_ignore_range_event(struct nftnl_set_elem *nlse)
 {
-        uint32_t flags = 0;
+	uint32_t flags = 0;
 
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_FLAGS))
 		flags = nftnl_set_elem_get_u32(nlse, NFTNL_SET_ELEM_FLAGS);
@@ -2765,7 +2765,7 @@ next:
 }
 
 static void trace_print_packet(const struct nftnl_trace *nlt,
-			        struct output_ctx *octx)
+			       struct output_ctx *octx)
 {
 	struct list_head stmts = LIST_HEAD_INIT(stmts);
 	const struct proto_desc *ll_desc;
diff --git a/src/segtree.c b/src/segtree.c
index f0efd15..1dd8039 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -346,9 +346,9 @@ static bool interval_overlap(const struct elementary_interval *e1,
 		return false;
 
 	return (mpz_cmp(e1->left, e2->left) >= 0 &&
-	        mpz_cmp(e1->left, e2->right) <= 0) ||
+		mpz_cmp(e1->left, e2->right) <= 0) ||
 	       (mpz_cmp(e1->right, e2->left) >= 0 &&
-	        mpz_cmp(e1->right, e2->right) <= 0) ||
+		mpz_cmp(e1->right, e2->right) <= 0) ||
 	       (mpz_cmp(e1->left, e2->left) <= 0 &&
 		mpz_cmp(e1->right, e2->right) >= 0);
 }
-- 
2.11.0

