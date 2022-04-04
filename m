Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66DEC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344658AbiDDMby (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344853AbiDDMbx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:31:53 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F4F25281
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LFdwA9QZ+BfGCS3iw8+7OE1WK/yS0qVi1cLOIJs2mCo=; b=qnb3sH1vJS0JRpPFJI2536zrEh
        /1h1hQH90OS67TIOx1r06NJ7YYfYNyXUsN62ayo2EyLUkpcNmZjwvqlZ6eO5Uz5k3Ba3U7+9KZgsI
        DsiQdJRKODodNidH057qYNPjU8eWif+7nOqBIz8Mb82myGDvcZIO0XyqZE2lHcz/HyjdjTitdwJ1l
        UfxEe/ia/BAVI+AZCijmmtJWi8NIwphvFFfaHaehPtjIpYzuuiGY6+J8k5tiBTAMcEejGW001jThz
        QstKrMJ4navG/QzhV/KpleOD8rAng3ITgoG+672zt/qilYt9c2l7WiCaq/x9/HsT/YHtFmbPwpZYR
        XUE1RIGQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbK-007FTC-VJ; Mon, 04 Apr 2022 13:14:31 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 26/32] netlink_delinearize: add support for processing variable payload statement arguments
Date:   Mon,  4 Apr 2022 13:14:04 +0100
Message-Id: <20220404121410.188509-27-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a user uses a variable payload expression in a payload statement, the
structure of the statement value is not handled by the existing
statement postprocessing function, so we need to extend it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 85 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 79 insertions(+), 6 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 4036646d57ac..e7042d6ae940 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2862,7 +2862,7 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
 	}
 }
 
-static bool stmt_payload_binop_postprocess_i(struct rule_pp_ctx *ctx)
+static bool stmt_payload_binop_postprocess_i_a(struct rule_pp_ctx *ctx)
 {
 	struct expr *expr, *binop, *payload, *value, *mask;
 	struct stmt *stmt = ctx->stmt;
@@ -2916,6 +2916,67 @@ static bool stmt_payload_binop_postprocess_i(struct rule_pp_ctx *ctx)
 	return true;
 }
 
+static bool stmt_payload_binop_postprocess_i_b(struct rule_pp_ctx *ctx)
+{
+	struct expr *expr, *payload, *mask, *xor;
+	struct stmt *stmt = ctx->stmt;
+	unsigned int shift;
+	mpz_t tmp, bitmask;
+
+	expr = stmt->payload.val;
+
+	if (expr->op != OP_XOR)
+		return false;
+
+	if (expr->left->etype != EXPR_BINOP)
+		return false;
+
+	if (expr->left->op != OP_AND)
+		return false;
+
+	if (expr->right->etype == EXPR_UNARY) {
+		/*
+		 * If the payload value was originally in a different byte-order
+		 * from the payload expression, there will be a byte-order
+		 * conversion to remove.
+		 */
+		xor = expr_get(expr->right->arg);
+		expr_free(expr->right);
+		expr->right = xor;
+	} else
+		xor = expr->right;
+
+	mask    = expr->left->right;
+	payload = expr->left->left;
+
+	mpz_init(tmp);
+	mpz_set(tmp, mask->value);
+
+	mpz_init_bitmask(bitmask, payload->len);
+	mpz_xor(bitmask, bitmask, mask->value);
+	mpz_set(mask->value, bitmask);
+	mpz_clear(bitmask);
+
+	if (payload_expr_trim(payload, mask, &ctx->pctx, &shift))
+		payload_match_postprocess(ctx, expr->left, payload);
+
+	if (!payload_is_known(payload)) {
+		mpz_set(mask->value, tmp);
+	} else {
+		if (shift) {
+			expr->right = expr_get(xor->left);
+			expr_free(xor);
+		}
+		expr_free(stmt->payload.expr);
+		stmt->payload.expr = expr_get(payload);
+		stmt->payload.val = expr_get(expr->right);
+		expr_free(expr);
+	}
+
+	mpz_clear(tmp);
+	return true;
+}
+
 static bool stmt_payload_binop_postprocess_ii(struct rule_pp_ctx *ctx)
 {
 	struct expr *expr, *payload, *value;
@@ -2983,21 +3044,30 @@ static bool stmt_payload_binop_postprocess_ii(struct rule_pp_ctx *ctx)
  * and a mask to clear the real payload offset/length.
  *
  * So check if we have one of the following binops:
- * I)
+ *
+ * Ia)
  *           binop (|)
  *       binop(&)   value/set
  * payload   value(mask)
  *
- * This is the normal case, the | RHS is the value the user wants
- * to set, the & RHS is the mask value that discards bits we need
+ * This is the normal constant case, the | RHS is the value the user
+ * wants to set, the & RHS is the mask value that discards bits we need
  * to clear but retains everything unrelated to the set operation.
  *
+ * Ib)
+ *         binop (^)
+ *       binop(&)   value/set
+ * payload   value(mask)
+ *
+ * The user wants to set a variable payload argument.  The ^ RHS is the
+ * variable expression.  The mask is as above.
+ *
  * IIa)
  *     binop (&)
  * payload   mask
  *
  * User specified a zero set value -- netlink bitwise decoding
- * discarded the redundant "| 0" part.  This is identical to I),
+ * discarded the redundant "| 0" part.  This is identical to Ia),
  * we can just set value to 0 after we inferred the real payload size.
  *
  * IIb)
@@ -3020,7 +3090,10 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 
 	switch (expr->left->etype) {
 	case EXPR_BINOP: /* I? */
-		if (stmt_payload_binop_postprocess_i(ctx))
+		if (stmt_payload_binop_postprocess_i_a(ctx))
+			return;
+
+		if (stmt_payload_binop_postprocess_i_b(ctx))
 			return;
 
 		break;
-- 
2.35.1

