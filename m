Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16EE5C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344356AbiDDMaY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344134AbiDDMaQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:30:16 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFE23DDC2
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pxksjlSgFmhcVHHobIWwZ7RWrN5490ckLGg882wGp/E=; b=WKgZXWZmVUm4mQ5sCgEoClD38o
        9/AehtOVmFhwa6Zm4CSOJZndZy/UEh5jaw/w4pvScelxoarnYLR/tBl1eK+XCtGHyiJ9bIBa/cqri
        xLo6+eYCbtpDImgTkdTLbpamjZy8Y+dNg9IGHaCtMhi+BMXDudaXhsLe0JanzDadNRwEgiQljixKT
        1qXf5pMurdueWdLnWPLjx4yhV0xoe7zy4vnoHf97uEWx0cq3rkchYGFYvbypmDb+ZFixcttwR6b3P
        EjsWrTXSFmy8s3rzKuE2thBVUMPWwhkUBafSQs6IRWzCw5Z8wqxnG4BtfLxNSMwHvFg7CJVxE1c8P
        9wI6vQdA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbL-007FTC-A6; Mon, 04 Apr 2022 13:14:31 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 30/32] evaluate: allow binop expressions with variable right-hand operands
Date:   Mon,  4 Apr 2022 13:14:08 +0100
Message-Id: <20220404121410.188509-31-jeremy@azazel.net>
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

Hitherto, the kernel has required constant values for the `xor` and
`mask` attributes of boolean bitwise expressions.  This has meant that
the right-hand operand of a boolean binop must be constant.  Now the
kernel has support for AND, OR and XOR operations with right-hand
operands passed via registers, we can relax this restriction.  Allow
non-constant right-hand operands if the left-hand operand is not
constant, e.g.:

  ct mark & 0xffff0000 | meta mark & 0xffff

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 02bfde2a2ded..4fff788f45fb 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1162,16 +1162,18 @@ static int expr_evaluate_bitwise(struct eval_ctx *ctx, struct expr **expr)
 	op->byteorder = left->byteorder;
 	op->len	      = op->len ? : left->len;
 
-	if (expr_is_constant(left))
+	if (expr_is_constant(left) && expr_is_constant(op->right))
 		return constant_binop_simplify(ctx, expr);
 	return 0;
 }
 
 /*
- * Binop expression: both sides must be of integer base type. The left
- * hand side may be either constant or non-constant; in case its constant
- * it must be a singleton. The ride hand side must always be a constant
- * singleton.
+ * Binop expression: both sides must be of integer base type. The left-hand side
+ * may be either constant or non-constant; if it is constant, it must be a
+ * singleton.  For bitwise operations, the right-hand side must be constant if
+ * the left-hand side is constant; the right-hand side may be constant or
+ * non-constant, if the left-hand side is non-constant; for shifts, the
+ * right-hand side must be constant; if it is constant, it must be a singleton.
  */
 static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 {
@@ -1207,27 +1209,36 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 					 "for %s expressions",
 					 sym, expr_name(left));
 
-	if (!expr_is_constant(right))
-		return expr_binary_error(ctx->msgs, right, op,
-					 "Right hand side of binary operation "
-					 "(%s) must be constant", sym);
-
-	if (!expr_is_singleton(right))
-		return expr_binary_error(ctx->msgs, left, op,
-					 "Binary operation (%s) is undefined "
-					 "for %s expressions",
-					 sym, expr_name(right));
-
 	/* The grammar guarantees this */
 	assert(expr_basetype(left) == expr_basetype(right));
 
 	switch (op->op) {
 	case OP_LSHIFT:
 	case OP_RSHIFT:
+		if (!expr_is_constant(right))
+			return expr_binary_error(ctx->msgs, right, op,
+						 "Right hand side of binary operation "
+						 "(%s) must be constant", sym);
+
+		if (!expr_is_singleton(right))
+			return expr_binary_error(ctx->msgs, left, op,
+						 "Binary operation (%s) is undefined "
+						 "for %s expressions",
+						 sym, expr_name(right));
 		return expr_evaluate_shift(ctx, expr);
 	case OP_AND:
 	case OP_XOR:
 	case OP_OR:
+		if (expr_is_constant(left) && !expr_is_constant(right))
+			return expr_binary_error(ctx->msgs, right, op,
+						 "Right hand side of binary operation "
+						 "(%s) must be constant", sym);
+
+		if (expr_is_constant(right) && !expr_is_singleton(right))
+			return expr_binary_error(ctx->msgs, left, op,
+						 "Binary operation (%s) is undefined "
+						 "for %s expressions",
+						 sym, expr_name(right));
 		return expr_evaluate_bitwise(ctx, expr);
 	default:
 		BUG("invalid binary operation %u\n", op->op);
-- 
2.35.1

