From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 10/12] nft: support listing expressions that use non-byte header fields
Date: Sun, 16 Aug 2015 21:05:53 +0200
Message-ID: <1439751955-31190-11-git-send-email-fw@strlen.de>
References: <1439751955-31190-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34751 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695AbbHPTGP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 15:06:15 -0400
In-Reply-To: <1439751955-31190-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows to list rules that check fields that are not aligned on byte
boundary, and allows decoding vlan headers, which reside on top of eth header
and need the expr->payload.offset adjusted accordingly.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/payload.h         |  3 ++
 src/evaluate.c            |  6 ++++
 src/netlink_delinearize.c | 80 ++++++++++++++++++++++++++++++++++++++------
 src/payload.c             | 84 +++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 160 insertions(+), 13 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index 95364af..ca9b013 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -19,7 +19,10 @@ extern bool payload_is_adjacent(const struct expr *e1, const struct expr *e2);
 extern struct expr *payload_expr_join(const struct expr *e1,
 				      const struct expr *e2);
 
+bool payload_expr_trim(struct expr *expr, struct expr *mask,
+		       const struct proto_ctx *ctx);
 extern void payload_expr_expand(struct list_head *list, struct expr *expr,
+				struct expr *mask,
 				const struct proto_ctx *ctx);
 extern void payload_expr_complete(struct expr *expr,
 				  const struct proto_ctx *ctx);
diff --git a/src/evaluate.c b/src/evaluate.c
index c95d154..7ff94c0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -332,8 +332,13 @@ static bool resolve_protocol_conflict(struct eval_ctx *ctx,
 		const struct proto_desc *next = ctx->pctx.protocol[base + 1].desc;
 
 		if (payload->payload.desc == next) {
+			ctx->pctx.protocol[base + 1].desc = NULL;
+			ctx->pctx.protocol[base].desc = next;
+			ctx->pctx.protocol[base].offset += desc->length;
 			payload->payload.offset += desc->length;
 			return true;
+		} else if (next) {
+			return false;
 		}
 	}
 
@@ -343,6 +348,7 @@ static bool resolve_protocol_conflict(struct eval_ctx *ctx,
 
 	payload->payload.offset += ctx->pctx.protocol[base].offset;
 	list_add_tail(&nstmt->list, &ctx->stmt->list);
+	ctx->pctx.protocol[base + 1].desc = NULL;
 
 	return true;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 76c07c5..537e34c 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -918,16 +918,20 @@ static void integer_type_postprocess(struct expr *expr)
 	}
 }
 
-static void payload_match_expand(struct rule_pp_ctx *ctx, struct expr *expr)
+static void payload_match_expand(struct rule_pp_ctx *ctx,
+				 struct expr *expr,
+				 struct expr *payload,
+				 struct expr *mask)
 {
-	struct expr *left = expr->left, *right = expr->right, *tmp;
+	struct expr *left = payload, *right = expr->right, *tmp;
 	struct list_head list = LIST_HEAD_INIT(list);
 	struct stmt *nstmt;
 	struct expr *nexpr = NULL;
 	enum proto_bases base = left->payload.base;
 	const struct expr_ops *payload_ops = left->ops;
 
-	payload_expr_expand(&list, left, &ctx->pctx);
+	payload_expr_expand(&list, left, mask, &ctx->pctx);
+
 	list_for_each_entry(left, &list, list) {
 		tmp = constant_expr_splice(right, left->len);
 		expr_set_type(tmp, left->dtype, left->byteorder);
@@ -981,10 +985,11 @@ static void payload_match_expand(struct rule_pp_ctx *ctx, struct expr *expr)
 }
 
 static void payload_match_postprocess(struct rule_pp_ctx *ctx,
-				      struct expr *expr)
+				      struct expr *expr,
+				      struct expr *payload,
+				      struct expr *mask)
 {
-	enum proto_bases base = expr->left->payload.base;
-	struct expr *payload = expr->left;
+	enum proto_bases base = payload->payload.base;
 
 	assert(payload->payload.offset >= ctx->pctx.protocol[base].offset);
 	payload->payload.offset -= ctx->pctx.protocol[base].offset;
@@ -993,7 +998,7 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 	case OP_EQ:
 	case OP_NEQ:
 		if (expr->right->ops->type == EXPR_VALUE) {
-			payload_match_expand(ctx, expr);
+			payload_match_expand(ctx, expr, payload, mask);
 			break;
 		}
 		/* Fall through */
@@ -1074,7 +1079,7 @@ static struct expr *binop_tree_to_list(struct expr *list, struct expr *expr)
 	return list;
 }
 
-static void relational_binop_postprocess(struct expr *expr)
+static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 {
 	struct expr *binop = expr->left, *value = expr->right;
 
@@ -1102,6 +1107,61 @@ static void relational_binop_postprocess(struct expr *expr)
 						expr_mask_to_prefix(binop->right));
 		expr_free(value);
 		expr_free(binop);
+	} else if (binop->op == OP_AND &&
+		   binop->left->ops->type == EXPR_PAYLOAD &&
+		   binop->right->ops->type == EXPR_VALUE) {
+		struct expr *payload = expr->left->left;
+		struct expr *mask = expr->left->right;
+
+		/*
+		 * This *might* be a payload match testing header fields that
+		 * have non byte divisible offsets and/or bit lengths.
+		 *
+		 * Thus we need to deal with two different cases.
+		 *
+		 * 1 the simple version:
+		 *        relation
+		 * payload        value|setlookup
+		 *
+		 * expr: relation, left: payload, right: value, e.g.  tcp dport == 22.
+		 *
+		 * 2. The '&' version (this is what we're looking at now).
+		 *            relation
+		 *     binop          value1|setlookup
+		 * payload  value2
+		 *
+		 * expr: relation, left: binop, right: value, e.g.
+		 * ip saddr 10.0.0.0/8
+		 *
+		 * payload_expr_trim will figure out if the mask is needed to match
+		 * templates.
+		 */
+		if (payload_expr_trim(payload, mask, &ctx->pctx)) {
+			/* mask is implicit, binop needs to be removed.
+			 *
+			 * Fix all values of the expression according to the mask
+			 * and then process the payload instruction using the real
+			 * sizes and offsets we're interested in.
+			 *
+			 * Finally, convert the expression to 1) by replacing
+			 * the binop with the binop payload expr.
+			 */
+			if (value->ops->type == EXPR_VALUE) {
+				assert(value->len >= expr->left->right->len);
+				value->len = mask->len;
+			}
+
+			payload->len = mask->len;
+			payload->payload.offset += mpz_scan1(mask->value, 0);
+
+			payload_match_postprocess(ctx, expr, payload, mask);
+
+			assert(expr->left->ops->type == EXPR_BINOP);
+
+			assert(binop->left == payload);
+			expr->left = payload;
+			expr_free(binop);
+		}
 	}
 }
 
@@ -1160,7 +1220,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_RELATIONAL:
 		switch (expr->left->ops->type) {
 		case EXPR_PAYLOAD:
-			payload_match_postprocess(ctx, expr);
+			payload_match_postprocess(ctx, expr, expr->left, NULL);
 			return;
 		default:
 			expr_postprocess(ctx, &expr->left);
@@ -1175,7 +1235,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 			meta_match_postprocess(ctx, expr);
 			break;
 		case EXPR_BINOP:
-			relational_binop_postprocess(expr);
+			relational_binop_postprocess(ctx, expr);
 			break;
 		default:
 			break;
diff --git a/src/payload.c b/src/payload.c
index 372dcec..2ede199 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -296,12 +296,87 @@ void payload_expr_complete(struct expr *expr, const struct proto_ctx *ctx)
 	}
 }
 
+static unsigned int mask_to_offset(const struct expr *mask)
+{
+	return mask ? mpz_scan1(mask->value, 0) : 0;
+}
+
+static unsigned int mask_length(const struct expr *mask)
+{
+	unsigned long off;
+
+        off = mask_to_offset(mask);
+
+	return mpz_scan0(mask->value, off + 1);
+}
+
+/**
+ * payload_expr_trim - trim payload expression according to mask
+ *
+ * @expr:	the payload expression
+ * @mask:	mask to use when searching templates
+ * @ctx:	protocol context
+ *
+ * Walk the template list and determine if a match can be found without
+ * using the provided mask.
+ *
+ * If the mask has to be used, trim the mask length accordingly
+ * and return true to let the caller know that the mask is a dependency.
+ */
+bool payload_expr_trim(struct expr *expr, struct expr *mask,
+		       const struct proto_ctx *ctx)
+{
+	unsigned int payload_offset = expr->payload.offset + mask_to_offset(mask);
+	unsigned int mask_len = mask_length(mask);
+	const struct proto_hdr_template *tmpl;
+	unsigned int payload_len = expr->len;
+	const struct proto_desc *desc;
+	unsigned int i, matched_len = mask_to_offset(mask);
+
+	assert(expr->ops->type == EXPR_PAYLOAD);
+
+	desc = ctx->protocol[expr->payload.base].desc;
+	if (desc == NULL)
+		return false;
+
+	assert(desc->base == expr->payload.base);
+
+	if (ctx->protocol[expr->payload.base].offset) {
+		assert(payload_offset >= ctx->protocol[expr->payload.base].offset);
+		payload_offset -= ctx->protocol[expr->payload.base].offset;
+	}
+
+	for (i = 1; i < array_size(desc->templates); i++) {
+		tmpl = &desc->templates[i];
+		if (tmpl->offset != payload_offset)
+			continue;
+
+		if (tmpl->len > payload_len)
+			return false;
+
+		payload_len -= tmpl->len;
+		matched_len += tmpl->len;
+		payload_offset += tmpl->len;
+		if (payload_len == 0)
+			return false;
+
+		if (matched_len == mask_len) {
+			assert(mask->len >= mask_len);
+			mask->len = mask_len;
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /**
  * payload_expr_expand - expand raw merged adjacent payload expressions into its
  * 			 original components
  *
  * @list:	list to append expanded payload expressions to
  * @expr:	the payload expression to expand
+ * @mask:	optional/implicit mask to use when searching templates
  * @ctx:	protocol context
  *
  * Expand a merged adjacent payload expression into its original components
@@ -311,18 +386,21 @@ void payload_expr_complete(struct expr *expr, const struct proto_ctx *ctx)
  * 	 offset order.
  */
 void payload_expr_expand(struct list_head *list, struct expr *expr,
-			 const struct proto_ctx *ctx)
+			 struct expr *mask, const struct proto_ctx *ctx)
 {
-	const struct proto_desc *desc;
+	unsigned int off = mask_to_offset(mask);
 	const struct proto_hdr_template *tmpl;
+	const struct proto_desc *desc;
 	struct expr *new;
 	unsigned int i;
 
 	assert(expr->ops->type == EXPR_PAYLOAD);
+	assert(!mask || mask->len != 0);
 
 	desc = ctx->protocol[expr->payload.base].desc;
 	if (desc == NULL)
 		goto raw;
+
 	assert(desc->base == expr->payload.base);
 
 	for (i = 1; i < array_size(desc->templates); i++) {
@@ -335,7 +413,7 @@ void payload_expr_expand(struct list_head *list, struct expr *expr,
 			list_add_tail(&new->list, list);
 			expr->len	     -= tmpl->len;
 			expr->payload.offset += tmpl->len;
-			if (expr->len == 0)
+			if (expr->len == off)
 				return;
 		} else
 			break;
-- 
2.0.5

