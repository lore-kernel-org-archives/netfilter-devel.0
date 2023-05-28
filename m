Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B919FC77B7E
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 14:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjE1OBj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 10:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjE1OBf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 10:01:35 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C024BD9
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 07:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Af6orlwf3TxdD+VuimQzl7U9OKtjkotPFDgchLIjpfI=; b=iq16ZO9vLQ3EbwaEu9ianLTtTU
        jkESS0FUTwykTRO1b2LU9cXrPd/pIRCxQgUtFrU10uIwAKUTwvlLamhCuvE0ljHbsAmo/Q1hVGF2/
        qQU1mCLlsy1SxPd1CTlxPAbl4XdT0D6y/gKWGH4rAqnJ2bJXW9XEbs1XK/KurgvBseu4ZwT3xbe48
        VfazUUeQJq5GCfWI9YSl2WheAYIygLoNmJKBB9rYZufHdttIgJs4DhQ8FE/U4fSSt5QHXFm33WnCF
        zEGEF5CODS8dTNXUg0jcgLQ8FUZ6AodLPMQP6KS06hFhQorN+iHEhpdGqNG250yGdXYRrcQiJO/7g
        9R//92SA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3Gxe-008Xe1-Eq; Sun, 28 May 2023 15:01:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH nft v5 6/8] evaluate: allow binop expressions with variable right-hand operands
Date:   Sun, 28 May 2023 15:00:56 +0100
Message-Id: <20230528140058.1218669-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230528140058.1218669-1-jeremy@azazel.net>
References: <20230528140058.1218669-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
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
index 136b4539e828..c98bd578f38b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1369,16 +1369,18 @@ static int expr_evaluate_bitwise(struct eval_ctx *ctx, struct expr **expr)
 	op->byteorder = byteorder;
 	op->len	      = max_len;
 
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
@@ -1419,27 +1421,36 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
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
 	assert(datatype_equal(expr_basetype(left), expr_basetype(right)));
 
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
2.39.2

