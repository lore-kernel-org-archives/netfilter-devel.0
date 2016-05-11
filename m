From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 05/12] evaluate: handle payload matching split in two bytes
Date: Wed, 11 May 2016 23:05:09 +0200
Message-ID: <1463000716-11885-5-git-send-email-pablo@netfilter.org>
References: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40453 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbcEKVF1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 17:05:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 18FC81BD5BB
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 06607CA100
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 088BFCA100
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:24 +0200 (CEST)
In-Reply-To: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When the bits are split between two bytes and the payload field is
smaller than one byte, we need to extend the expression length on both
sides (payload and constant) of the relational expression.

The existing trimming from the delinerization step handles the listing
for us, so no changes on that front.

This patch allows us to match the IPv6 DSCP field which falls into the
case that is described above.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index ab73261..fcd4ecd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -362,7 +362,8 @@ conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
 	return 0;
 }
 
-static uint8_t expr_offset_shift(const struct expr *expr, unsigned int offset)
+static uint8_t expr_offset_shift(const struct expr *expr, unsigned int offset,
+				 unsigned int *extra_len)
 {
 	unsigned int new_offset, len;
 	int shift;
@@ -370,34 +371,38 @@ static uint8_t expr_offset_shift(const struct expr *expr, unsigned int offset)
 	new_offset = offset % BITS_PER_BYTE;
 	len = round_up(expr->len, BITS_PER_BYTE);
 	shift = len - (new_offset + expr->len);
-	assert(shift >= 0);
-
+	while (shift < 0) {
+		shift += BITS_PER_BYTE;
+		*extra_len += BITS_PER_BYTE;
+	}
 	return shift;
 }
 
 static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct expr *expr = *exprp, *and, *mask, *lshift, *off;
-	unsigned masklen;
+	unsigned masklen, len = expr->len, extra_len = 0;
 	uint8_t shift;
 	mpz_t bitmask;
 
 	switch (expr->ops->type) {
 	case EXPR_PAYLOAD:
-		shift = expr_offset_shift(expr, expr->payload.offset);
+		shift = expr_offset_shift(expr, expr->payload.offset,
+					  &extra_len);
 		break;
 	case EXPR_EXTHDR:
-		shift = expr_offset_shift(expr, expr->exthdr.tmpl->offset);
+		shift = expr_offset_shift(expr, expr->exthdr.tmpl->offset,
+					  &extra_len);
 		break;
 	default:
 		BUG("Unknown expression %s\n", expr->ops->name);
 	}
 
-	masklen = expr->len + shift;
+	masklen = len + shift;
 	assert(masklen <= NFT_REG_SIZE * BITS_PER_BYTE);
 
 	mpz_init2(bitmask, masklen);
-	mpz_bitmask(bitmask, expr->len);
+	mpz_bitmask(bitmask, len);
 	mpz_lshift_ui(bitmask, shift);
 
 	mask = constant_expr_alloc(&expr->location, expr_basetype(expr),
@@ -423,6 +428,9 @@ static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 		*exprp = lshift;
 	} else
 		*exprp = and;
+
+	if (extra_len)
+		expr->len += extra_len;
 }
 
 static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
-- 
2.1.4

