From: Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 4/7] netlink: decode payload statment
Date: Wed, 27 Jul 2016 02:43:13 +0200
Message-ID: <1469580196-2100-5-git-send-email-fw@strlen.de>
References: <1469580196-2100-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60764 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbcG0BPW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 21:15:22 -0400
In-Reply-To: <1469580196-2100-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows nft to display payload set operations if the
header isn't byte aligned or has non-byte divisible sizes.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 165 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 160 insertions(+), 5 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ae87280..5e28111 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1747,6 +1747,165 @@ static void stmt_expr_postprocess(struct rule_pp_ctx *ctx)
 		expr_postprocess_range(ctx, op);
 }
 
+static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
+{
+	struct expr *payload = binop->left;
+	struct expr *mask = binop->right;
+	unsigned int shift;
+
+	assert(payload->ops->type == EXPR_PAYLOAD);
+	if (payload_expr_trim(payload, mask, &ctx->pctx, &shift)) {
+		__binop_adjust(binop, mask, shift);
+		payload_expr_complete(payload, &ctx->pctx);
+		expr_set_type(mask, payload->dtype,
+			      payload->byteorder);
+	}
+}
+
+static void stmt_payload_postprocess(struct rule_pp_ctx *ctx)
+{
+	struct stmt *stmt = ctx->stmt;
+	struct expr *expr, *binop, *payload, *value, *mask;
+	mpz_t bitmask;
+
+	expr_postprocess(ctx, &stmt->payload.expr);
+
+	expr_set_type(stmt->payload.val,
+		      stmt->payload.expr->dtype,
+		      stmt->payload.expr->byteorder);
+
+	if (payload_is_known(stmt->payload.expr))
+		goto out;
+
+	/*
+	 * expr_postprocess() failed to decode the payload information.
+	 *
+	 * We will now check if payload.val contains a binop that might
+	 * help us to figure it out.  Check if expr is one of the following:
+	 * I)
+	 *           binop (|)
+	 *       binop(&)   value/set
+	 * payload   value(mask)
+	 *
+	 * This is the normal case, the | RHS is the value the user wants
+	 * to set, the & RHS is the mask value that discards bits we need
+	 * to clear but retains everything unrelated to the set operation.
+	 *
+	 * IIa)
+	 *     binop (&)
+	 * payload   mask
+	 *
+	 * User specified a zero set value -- netlink bitwise decoding
+	 * discarded the redundant "| 0" part.
+	 *
+	 * IIb)
+	 *     binop (|)
+	 * payload     value/set
+	 *
+	 * This happens when user wants to set all bits, netlink bitwise
+	 * decoding changed '(payload & mask) ^ bits_to_set' into
+	 * 'payload | bits_to_set', discarding the redundant "& 0xfff...".
+	 */
+	expr = stmt->payload.val;
+	if (expr->ops->type != EXPR_BINOP)
+		goto out;
+
+	switch (expr->left->ops->type) {
+	case EXPR_BINOP: {/* I? */
+		mpz_t tmp;
+
+		if (expr->op != OP_OR)
+			goto out;
+
+		value = expr->right;
+		if (value->ops->type != EXPR_VALUE)
+			goto out;
+
+		binop = expr->left;
+		if (binop->op != OP_AND)
+			goto out;
+
+		payload = binop->left;
+		if (payload->ops->type != EXPR_PAYLOAD)
+			goto out;
+
+		if (!payload->ops->cmp(stmt->payload.expr, payload))
+			goto out;
+
+		mask = binop->right;
+		if (mask->ops->type != EXPR_VALUE)
+			goto out;
+
+		mpz_init(tmp);
+		mpz_set(tmp, mask->value);
+
+		mpz_init_bitmask(bitmask, payload->len);
+		mpz_xor(bitmask, bitmask, mask->value);
+		mpz_xor(bitmask, bitmask, value->value);
+		mpz_set(mask->value, bitmask);
+		mpz_clear(bitmask);
+
+		binop_postprocess(ctx, expr);
+		if (!payload_is_known(payload)) {
+			mpz_set(mask->value, tmp);
+			mpz_clear(tmp);
+			goto out;
+		}
+
+		mpz_clear(tmp);
+		expr_free(stmt->payload.expr);
+		stmt->payload.expr = expr_get(payload);
+		stmt->payload.val = expr_get(expr->right);
+		expr_free(expr);
+		break;
+	}
+	case EXPR_PAYLOAD: /* II? */
+		value = expr->right;
+		if (value->ops->type != EXPR_VALUE)
+			goto out;
+
+		switch (expr->op) {
+		case OP_AND: /* IIa */
+			payload = expr->left;
+			mpz_init_bitmask(bitmask, payload->len);
+			mpz_xor(bitmask, bitmask, value->value);
+			mpz_set(value->value, bitmask);
+			break;
+		case OP_OR: /* IIb */
+			break;
+		default: /* No idea */
+			goto out;
+		}
+
+		stmt_payload_binop_pp(ctx, expr);
+		if (!payload_is_known(expr->left))
+			goto out;
+
+		expr_free(stmt->payload.expr);
+
+		switch (expr->op) {
+		case OP_AND:
+			/* Mask was used to match payload, i.e.
+			 * user asked to set zero value.
+			 */
+			mpz_set_ui(value->value, 0);
+			break;
+		default:
+			break;
+		}
+
+		stmt->payload.expr = expr_get(expr->left);
+		stmt->payload.val = expr_get(expr->right);
+		expr_free(expr);
+		break;
+	default: /* No idea */
+		goto out;
+	}
+
+ out:
+	expr_postprocess(ctx, &stmt->payload.val);
+}
+
 static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *rule)
 {
 	struct rule_pp_ctx rctx;
@@ -1763,11 +1922,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 			stmt_expr_postprocess(&rctx);
 			break;
 		case STMT_PAYLOAD:
-			expr_postprocess(&rctx, &stmt->payload.expr);
-			expr_set_type(stmt->payload.val,
-				      stmt->payload.expr->dtype,
-				      stmt->payload.expr->byteorder);
-			expr_postprocess(&rctx, &stmt->payload.val);
+			stmt_payload_postprocess(&rctx);
 			break;
 		case STMT_FLOW:
 			expr_postprocess(&rctx, &stmt->flow.key);
-- 
2.7.3

