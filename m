Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594A9C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345270AbiDDMcE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242129AbiDDMcD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:32:03 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5250C252A1
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZIg/qgA0BkN87jKkkpiPVuIOVNhWWigCe6wBOfcCzQA=; b=a22znbRFhNFhZYwhdm5N5S/cG/
        lxJjaiqRwOcujvkAqsTkb920j4XL/Xm4pPtcITgpnBPQWUIJ5GpPufIieE0fmIEcxkeX5y9pWHkH8
        I4u7TZgwoS/6EYdWMRpc+6/XPcBxzWgZ97px6oemyDF7HZFjX4hqWQ3VrGvfc4zWagDCFQlstqia5
        JtVnj3Rag4K+yJLjzz4AcM8QX7xcjPnAHuYPr9mKCMaALvfxzgdUInO7QvO38ITsvgo1ecBQw/T25
        9UOJP3EC1WOe6U9D7Z26FRROr8kcgEos+KsPQrYXvJuSl2M/cvu43uXR/QWLDvPu8RU7ALPPBqcsW
        1uEdYL3A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbJ-007FTC-Jz; Mon, 04 Apr 2022 13:14:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 13/32] evaluate: support shifts larger than the width of the left operand
Date:   Mon,  4 Apr 2022 13:13:51 +0100
Message-Id: <20220404121410.188509-14-jeremy@azazel.net>
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

If we want to left-shift a value of narrower type and assign the result
to a variable of a wider type, we are constrained to only shifting up to
the width of the narrower type.  Thus:

  add rule t c meta mark set ip dscp << 2

works, but:

  add rule t c meta mark set ip dscp << 8

does not, even though the lvalue is large enough to accommodate the
result.

Evaluation of the left-hand operand of a shift overwrites the `len`
field of the evaluation context when `expr_evaluate_primary` is called.
Instead, preserve the `len` value of the evaluation context for shifts,
and support shifts up to that size, even if they are larger than the
length of the left operand.

Update netlink_delinearize.c to handle the case where the length of a
shift expression does not match that of its left-hand operand.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c            | 23 ++++++++++++++---------
 src/netlink_delinearize.c |  4 ++--
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index be493f85010c..ee4da5a2b889 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1116,14 +1116,18 @@ static int constant_binop_simplify(struct eval_ctx *ctx, struct expr **expr)
 static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *op = *expr, *left = op->left, *right = op->right;
+	unsigned int shift = mpz_get_uint32(right->value);
+	unsigned int op_len = left->len;
 
-	if (mpz_get_uint32(right->value) >= left->len)
-		return expr_binary_error(ctx->msgs, right, left,
-					 "%s shift of %u bits is undefined "
-					 "for type of %u bits width",
-					 op->op == OP_LSHIFT ? "Left" : "Right",
-					 mpz_get_uint32(right->value),
-					 left->len);
+	if (shift >= op_len) {
+		if (shift >= ctx->ectx.len)
+			return expr_binary_error(ctx->msgs, right, left,
+						 "%s shift of %u bits is undefined for type of %u bits width",
+						 op->op == OP_LSHIFT ? "Left" : "Right",
+						 shift,
+						 op_len);
+		op_len = ctx->ectx.len;
+	}
 
 	/* Both sides need to be in host byte order */
 	if (byteorder_conversion(ctx, &op->left, BYTEORDER_HOST_ENDIAN) < 0)
@@ -1134,7 +1138,7 @@ static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
 
 	op->dtype     = &integer_type;
 	op->byteorder = BYTEORDER_HOST_ENDIAN;
-	op->len       = left->len;
+	op->len	      = op_len;
 
 	if (expr_is_constant(left))
 		return constant_binop_simplify(ctx, expr);
@@ -1167,6 +1171,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *op = *expr, *left, *right;
 	const char *sym = expr_op_symbols[op->op];
+	unsigned int ectx_len = ctx->ectx.len;
 
 	if (expr_evaluate(ctx, &op->left) < 0)
 		return -1;
@@ -1174,7 +1179,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 
 	if (op->op == OP_LSHIFT || op->op == OP_RSHIFT)
 		__expr_set_context(&ctx->ectx, &integer_type,
-				   left->byteorder, ctx->ectx.len, 0);
+				   left->byteorder, ectx_len, 0);
 	if (expr_evaluate(ctx, &op->right) < 0)
 		return -1;
 	right = op->right;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index cf5359bf269e..9f6fdee3e92d 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -486,7 +486,7 @@ static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
 		mpz_ior(m, m, o);
 	}
 
-	if (left->len > 0 && mpz_scan0(m, 0) == left->len) {
+	if (left->len > 0 && mpz_scan0(m, 0) >= left->len) {
 		/* mask encompasses the entire value */
 		expr_free(mask);
 	} else {
@@ -536,7 +536,7 @@ static struct expr *netlink_parse_bitwise_shift(struct netlink_parse_ctx *ctx,
 	right->byteorder = BYTEORDER_HOST_ENDIAN;
 
 	expr = binop_expr_alloc(loc, op, left, right);
-	expr->len = left->len;
+	expr->len = nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_LEN) * BITS_PER_BYTE;
 
 	return expr;
 }
-- 
2.35.1

