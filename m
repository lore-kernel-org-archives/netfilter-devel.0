Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4523C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbiDDMar (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345283AbiDDMao (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:30:44 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C2ED82
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Dltlwb9S9ZFvK19sBOOmtTCnPwRhQI4mGh+QwboWuAk=; b=DsEVph/RmZ8q4ZadUjIBbdQWj0
        2XqSxD1EWA1O13PM1K05yogGM2sCtSFVjpvd6r0cvnelQYpwDe+A98dQgY33+PXwXXjPm/iy3zyHN
        miguWVG03BOYaPbM6KcASSVgII44OQAVi9amkgstCJW++2gNP3tCEUPpoDD6pYTnyO0IVLoG8ehIv
        dIGA6uH6mCwwgtEvN7mf0xm5Qu6LbQANdDpAg2iapA6aTatyE7w8r9fW3aS6l48p+CLM+4FWY25aU
        5dy+MP5eleWOnuCCzYUmDKJveuDoE3ex/jMws/hoS9etmyiqMaQ7/VdE0ssNWNqAFPpW08UfOhYr0
        ldN95MKA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbL-007FTC-3q; Mon, 04 Apr 2022 13:14:31 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 28/32] netlink: support (de)linearization of new bitwise boolean operations
Date:   Mon,  4 Apr 2022 13:14:06 +0100
Message-Id: <20220404121410.188509-29-jeremy@azazel.net>
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

Hitherto, all boolean bitwise operationss have been converted to the
form:

  dst = (src & mask) ^ xor

and constant values have been required for `xor` and `mask`.  This has
meant that the right-hand operand of a boolean binop must be constant.
The kernel now supports performing AND, OR and XOR operations directly,
on one register and an immediate value or on two registers, so we need
to be able to generate and parse bitwise boolean expressions of this
form.

If a boolean operation has a constant RHS, we continue to send a
mask-and-xor expression to the kernel.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 50 ++++++++++++++++++++++++++++++++++-----
 src/netlink_linearize.c   | 48 +++++++++++++++++++++++++++++++++++--
 2 files changed, 90 insertions(+), 8 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 63f6febb457d..73b95cc52763 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -522,10 +522,43 @@ netlink_parse_bitwise_mask_xor(struct netlink_parse_ctx *ctx,
 	return expr;
 }
 
+static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
+					       const struct location *loc,
+					       const struct nftnl_expr *nle,
+					       enum nft_bitwise_ops op,
+					       enum nft_registers sreg,
+					       struct expr *left)
+{
+	enum nft_registers sreg2;
+	struct expr *right, *expr;
+	unsigned nbits;
+
+	sreg2 = netlink_parse_register(nle, NFTNL_EXPR_BITWISE_SREG2);
+	right = netlink_get_register(ctx, loc, sreg2);
+	if (right == NULL) {
+		netlink_error(ctx, loc,
+			      "Bitwise expression has no right-hand expression");
+		return NULL;
+	}
+
+	expr = binop_expr_alloc(loc,
+				op == NFT_BITWISE_XOR ? OP_XOR :
+				op == NFT_BITWISE_AND ? OP_AND : OP_OR,
+				left, right);
+
+	nbits = nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_NBITS);
+	if (nbits > 0)
+		expr->len = nbits;
+	else if (left->len > 0)
+		expr->len = left->len;
+
+	return expr;
+}
+
 static struct expr *netlink_parse_bitwise_shift(struct netlink_parse_ctx *ctx,
 						const struct location *loc,
 						const struct nftnl_expr *nle,
-						enum ops op,
+						enum nft_bitwise_ops op,
 						enum nft_registers sreg,
 						struct expr *left)
 {
@@ -536,7 +569,9 @@ static struct expr *netlink_parse_bitwise_shift(struct netlink_parse_ctx *ctx,
 	right = netlink_alloc_value(loc, &nld);
 	right->byteorder = BYTEORDER_HOST_ENDIAN;
 
-	expr = binop_expr_alloc(loc, op, left, right);
+	expr = binop_expr_alloc(loc,
+				op == NFT_BITWISE_LSHIFT ? OP_LSHIFT : OP_RSHIFT,
+				left, right);
 	expr->len = nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_LEN) * BITS_PER_BYTE;
 
 	return expr;
@@ -564,12 +599,15 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 		expr = netlink_parse_bitwise_mask_xor(ctx, loc, nle, sreg,
 						      left);
 		break;
-	case NFT_BITWISE_LSHIFT:
-		expr = netlink_parse_bitwise_shift(ctx, loc, nle, OP_LSHIFT,
-						   sreg, left);
+	case NFT_BITWISE_XOR:
+	case NFT_BITWISE_AND:
+	case NFT_BITWISE_OR:
+		expr = netlink_parse_bitwise_bool(ctx, loc, nle, op,
+						  sreg, left);
 		break;
+	case NFT_BITWISE_LSHIFT:
 	case NFT_BITWISE_RSHIFT:
-		expr = netlink_parse_bitwise_shift(ctx, loc, nle, OP_RSHIFT,
+		expr = netlink_parse_bitwise_shift(ctx, loc, nle, op,
 						   sreg, left);
 		break;
 	default:
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 478bad073c82..7292c42eda8b 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -640,7 +640,8 @@ static void netlink_gen_bitwise_mask_xor(struct netlink_linearize_ctx *ctx,
 
 	binops[n++] = left = (struct expr *) expr;
 	while (left->etype == EXPR_BINOP && left->left != NULL &&
-	       (left->op == OP_AND || left->op == OP_OR || left->op == OP_XOR))
+	       (left->op == OP_AND || left->op == OP_OR || left->op == OP_XOR) &&
+	       expr_is_constant(left->right))
 		binops[n++] = left = left->left;
 	n--;
 
@@ -693,6 +694,46 @@ static void netlink_gen_bitwise_mask_xor(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
+static void netlink_gen_bitwise_bool(struct netlink_linearize_ctx *ctx,
+				     const struct expr *expr,
+				     enum nft_registers dreg)
+{
+	enum nft_registers sreg2;
+	struct nftnl_expr *nle;
+	unsigned int len;
+
+	nle = alloc_nft_expr("bitwise");
+
+	switch (expr->op) {
+	case OP_XOR:
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_XOR);
+		break;
+	case OP_AND:
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_AND);
+		break;
+	case OP_OR:
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_OR);
+		break;
+	default:
+		BUG("invalid binary operation %u\n", expr->op);
+	}
+
+	netlink_gen_expr(ctx, expr->left, dreg);
+	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, dreg);
+	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, dreg);
+
+	sreg2 = get_register(ctx, expr->right);
+	netlink_gen_expr(ctx, expr->right, sreg2);
+	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG2, sreg2);
+
+	len = div_round_up(expr->len, BITS_PER_BYTE);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
+	if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_NBITS, expr->len);
+
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 			      const struct expr *expr,
 			      enum nft_registers dreg)
@@ -703,7 +744,10 @@ static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 		netlink_gen_bitwise_shift(ctx, expr, dreg);
 		break;
 	default:
-		netlink_gen_bitwise_mask_xor(ctx, expr, dreg);
+		if (expr_is_constant(expr->right))
+			netlink_gen_bitwise_mask_xor(ctx, expr, dreg);
+		else
+			netlink_gen_bitwise_bool(ctx, expr, dreg);
 		break;
 	}
 }
-- 
2.35.1

