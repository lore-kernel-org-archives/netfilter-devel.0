From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 10/10] netlink_delinearize: handle extension header templates with odd sizes
Date: Tue,  1 Mar 2016 16:37:50 +0100
Message-ID: <1456846670-28179-11-git-send-email-fw@strlen.de>
References: <1456846670-28179-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49316 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754627AbcCAPiH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 10:38:07 -0500
In-Reply-To: <1456846670-28179-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This enables nft to display
	frag frag-off 33

... by considering a mask during binop postprocess in case
the initial template lookup done when the exthdr expression was
created did not yield a match.

In the above example, kernel netlink data specifies 16bits,
but the frag field is only 13bits wide.

We use the implicit binop mask to re-do the template lookup with
corrected offset and size information.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/exthdr.h          |  2 ++
 src/exthdr.c              | 31 +++++++++++++++++++++++++++++++
 src/netlink_delinearize.c | 12 ++++++++----
 3 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/include/exthdr.h b/include/exthdr.h
index 87c4285..d17841b 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -23,6 +23,8 @@ extern struct expr *exthdr_expr_alloc(const struct location *loc,
 extern void exthdr_init_raw(struct expr *expr, uint8_t type,
 			    unsigned int offset, unsigned int len);
 
+extern bool exthdr_find_template(struct expr *expr, const struct expr *mask,
+				 unsigned int *shift);
 
 enum hbh_hdr_fields {
 	HBHHDR_INVALID,
diff --git a/src/exthdr.c b/src/exthdr.c
index 512de0a..f392cff 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -102,6 +102,37 @@ void exthdr_init_raw(struct expr *expr, uint8_t type,
 	}
 }
 
+static unsigned int mask_length(const struct expr *mask)
+{
+	unsigned long off = mpz_scan1(mask->value, 0);
+
+	return mpz_scan0(mask->value, off + 1);
+}
+
+bool exthdr_find_template(struct expr *expr, const struct expr *mask, unsigned int *shift)
+{
+	unsigned int off, mask_offset, mask_len;
+
+	if (expr->exthdr.tmpl != &exthdr_unknown_template)
+		return false;
+
+	mask_offset = mpz_scan1(mask->value, 0);
+	mask_len = mask_length(mask);
+
+	off = expr->exthdr.offset;
+	off += round_up(mask->len, BITS_PER_BYTE) - mask_len;
+
+	exthdr_init_raw(expr, expr->exthdr.desc->type,
+			off, mask_len - mask_offset);
+
+	/* still failed to find a template... Bug. */
+	if (expr->exthdr.tmpl == &exthdr_unknown_template)
+		return false;
+
+	*shift = mask_offset;
+	return true;
+}
+
 #define HDR_TEMPLATE(__name, __dtype, __type, __member)			\
 	PROTO_HDR_TEMPLATE(__name, __dtype,				\
 			   BYTEORDER_BIG_ENDIAN,			\
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 30c5f62..fae6e33 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1218,7 +1218,9 @@ static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 	unsigned int shift;
 
 	if ((left->ops->type == EXPR_PAYLOAD &&
-	    payload_expr_trim(left, mask, &ctx->pctx, &shift))) {
+	    payload_expr_trim(left, mask, &ctx->pctx, &shift)) ||
+	    (left->ops->type == EXPR_EXTHDR &&
+	     exthdr_find_template(left, mask, &shift))) {
 		/* mask is implicit, binop needs to be removed.
 		 *
 		 * Fix all values of the expression according to the mask
@@ -1226,7 +1228,7 @@ static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 		 * sizes and offsets we're interested in.
 		 *
 		 * Finally, convert the expression to 1) by replacing
-		 * the binop with the binop payload expr.
+		 * the binop with the binop payload/exthdr expression.
 		 */
 		if (value->ops->type == EXPR_VALUE) {
 			assert(value->len >= expr->left->right->len);
@@ -1238,8 +1240,10 @@ static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 		assert(binop->left == left);
 		expr->left = expr_get(left);
 		expr_free(binop);
-
-		payload_match_postprocess(ctx, expr, left);
+		if (left->ops->type == EXPR_PAYLOAD)
+			payload_match_postprocess(ctx, expr, left);
+		else if (left->ops->type == EXPR_EXTHDR)
+			expr_set_type(expr->right, left->dtype, left->byteorder);
 	}
 }
 
-- 
2.4.10

