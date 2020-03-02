Return-Path: <SRS0=hj4T=4T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5A0C3F2CD
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 22:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92F0421739
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 22:19:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="kM8Qf1n1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgCBWTV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 17:19:21 -0500
Received: from kadath.azazel.net ([81.187.231.250]:41504 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbgCBWTT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 17:19:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hYmVNCOJPmdBphAbm5Q2iMPUwRhgLi6uVMEyB34r8bs=; b=kM8Qf1n152LmwHsWlBpF5S/CKj
        5U8VjQxXq4yYCLPLoZMwdN1MJ1mXAo0gLEPqDl1DGvE0KS3S2ua3rGlPNWfON53PcoSN8Z4kbaALf
        Ex/370KTU4wPp23SXnY/XexNGPan5Ap98JSHIi5HZYzUOGwuR5NZSna4qo3EsbpB0AmjDu2LD/igo
        4PYQ8jBn2/ptA75aAOwVHEMtNxzvT866PGCYkEgssNv1TbB2TXECyJ3jNkObbHS26kQ/dMnWtke6j
        BJ08DCDP5mYQyyK292faV+eDgxA4vSw/0QFxod97Di00GQQTDKXJzg9+XKF/aXVPPvNeJb3AAgbe7
        UozErgdw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j8tPB-0000Sg-Fy; Mon, 02 Mar 2020 22:19:17 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v2 09/18] src: support (de)linearization of bitwise op's with variable right operands.
Date:   Mon,  2 Mar 2020 22:19:07 +0000
Message-Id: <20200302221916.1005019-10-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200302221916.1005019-1-jeremy@azazel.net>
References: <20200302221916.1005019-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hitherto, the kernel has required constant values for the xor and mask
attributes of boolean bitwise expressions.  This has meant that the
righthand argument of a boolean binop must be constant.  Now the kernel
supports passing mask and xor via registers, we need to be able to
generate and parse bitwise boolean expressions that do this.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 83 +++++++++++++++++++++++++++++++---
 src/netlink_linearize.c   | 95 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 167 insertions(+), 11 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 79efda123c14..4fc7b764d7a9 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -363,11 +363,12 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 	ctx->stmt = expr_stmt_alloc(loc, expr);
 }
 
-static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
-					       const struct location *loc,
-					       const struct nftnl_expr *nle,
-					       enum nft_registers sreg,
-					       struct expr *left)
+static struct expr *
+netlink_parse_bitwise_bool_constant(struct netlink_parse_ctx *ctx,
+				    const struct location *loc,
+				    const struct nftnl_expr *nle,
+				    enum nft_registers sreg,
+				    struct expr *left)
 
 {
 	struct nft_data_delinearize nld;
@@ -428,6 +429,69 @@ static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
 	return expr;
 }
 
+static struct expr *
+netlink_parse_bitwise_bool_variable(struct netlink_parse_ctx *ctx,
+				    const struct location *loc,
+				    const struct nftnl_expr *nle,
+				    enum nft_registers sreg,
+				    struct expr *left)
+
+{
+	enum nft_registers mreg, xreg;
+	struct expr *mask, *xor;
+
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_BITWISE_MASK)) {
+		/*
+		 * a ^ b = (a & 1) ^ b.
+		 */
+		xreg = netlink_parse_register(nle, NFTNL_EXPR_BITWISE_XREG);
+		xor = netlink_get_register(ctx, loc, xreg);
+		if (xor == NULL) {
+			netlink_error(ctx, loc,
+				      "Bitwise expression has no xor expression");
+			return NULL;
+		}
+		return binop_expr_alloc(loc, OP_XOR, left, xor);
+	}
+
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_BITWISE_XOR)) {
+		/*
+		 * a & b = (a & b) ^ 0.
+		 */
+		mreg = netlink_parse_register(nle, NFTNL_EXPR_BITWISE_MREG);
+		mask = netlink_get_register(ctx, loc, mreg);
+		if (mask == NULL) {
+			netlink_error(ctx, loc,
+				      "Bitwise expression has no mask expression");
+			return NULL;
+		}
+		return binop_expr_alloc(loc, OP_AND, left, mask);
+	}
+
+	/*
+	 * a | b = (a & ~b) ^ b.
+	 */
+	mreg = netlink_parse_register(nle, NFTNL_EXPR_BITWISE_MREG);
+	mask = netlink_get_register(ctx, loc, mreg);
+	if (mask == NULL) {
+		netlink_error(ctx, loc,
+			      "Bitwise expression has no mask expression");
+		return NULL;
+	}
+
+	expr_free(mask);
+
+	xreg = netlink_parse_register(nle, NFTNL_EXPR_BITWISE_XREG);
+	xor = netlink_get_register(ctx, loc, xreg);
+	if (xor == NULL) {
+		netlink_error(ctx, loc,
+			      "Bitwise expression has no xor expression");
+		return NULL;
+	}
+
+	return binop_expr_alloc(loc, OP_OR, left, xor);
+}
+
 static struct expr *netlink_parse_bitwise_shift(struct netlink_parse_ctx *ctx,
 						const struct location *loc,
 						const struct nftnl_expr *nle,
@@ -467,8 +531,13 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 
 	switch (op) {
 	case NFT_BITWISE_BOOL:
-		expr = netlink_parse_bitwise_bool(ctx, loc, nle, sreg,
-						  left);
+		if (nftnl_expr_is_set(nle, NFTNL_EXPR_BITWISE_MASK) &&
+		    nftnl_expr_is_set(nle, NFTNL_EXPR_BITWISE_XOR))
+			expr = netlink_parse_bitwise_bool_constant(ctx, loc, nle,
+								   sreg, left);
+		else
+			expr = netlink_parse_bitwise_bool_variable(ctx, loc, nle,
+								   sreg, left);
 		break;
 	case NFT_BITWISE_LSHIFT:
 		expr = netlink_parse_bitwise_shift(ctx, loc, nle, OP_LSHIFT,
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index de461775a7e1..b2987efbc49f 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -572,9 +572,9 @@ static void netlink_gen_shift(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
-static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
-				const struct expr *expr,
-				enum nft_registers dreg)
+static void netlink_gen_bitwise_constant(struct netlink_linearize_ctx *ctx,
+					 const struct expr *expr,
+					 enum nft_registers dreg)
 {
 	struct nftnl_expr *nle;
 	struct nft_data_linearize nld;
@@ -642,6 +642,89 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_bitwise_variable(struct netlink_linearize_ctx *ctx,
+					 const struct expr *expr,
+					 enum nft_registers dreg)
+{
+	struct nft_data_linearize nld;
+	enum nft_registers mreg, xreg;
+	struct nftnl_expr *nle;
+	unsigned int len;
+	mpz_t m, x;
+
+	netlink_gen_expr(ctx, expr->left, dreg);
+
+	len = div_round_up(expr->len, BITS_PER_BYTE);
+
+	nle = alloc_nft_expr("bitwise");
+
+	switch (expr->op) {
+	case OP_XOR:
+		/*
+		 * a ^ b = (a & 1) ^ b.
+		 */
+		mpz_init_bitmask(m, expr->len);
+		netlink_gen_raw_data(m, expr->byteorder, len, &nld);
+		nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, nld.value, nld.len);
+		mpz_clear(m);
+
+		xreg = get_register(ctx, expr->right);
+		netlink_gen_expr(ctx, expr->right, xreg);
+		netlink_put_register(nle, NFTNL_EXPR_BITWISE_XREG, xreg);
+		break;
+	case OP_AND:
+		/*
+		 * a & b = (a & b) ^ 0.
+		 */
+		mreg = get_register(ctx, expr->right);
+		netlink_gen_expr(ctx, expr->right, mreg);
+		netlink_put_register(nle, NFTNL_EXPR_BITWISE_MREG, mreg);
+
+		mpz_init_set_ui(x, 0);
+		netlink_gen_raw_data(x, expr->byteorder, len, &nld);
+		nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, nld.value, nld.len);
+		mpz_clear(x);
+		break;
+	case OP_OR: {
+		/*
+		 * a | b = (a & ~b)      ^ b
+		 *       = (a & (b ^ 1)) ^ b.
+		 */
+		struct expr *one, *not;
+		unsigned long tmp;
+
+		mpz_init_bitmask(m, expr->right->len);
+		tmp = mpz_get_ui(m);
+		mpz_clear(m);
+
+		one = constant_expr_alloc(&expr->location, &integer_type,
+					  expr->right->byteorder,
+					  expr->right->len, &tmp);
+		not = binop_expr_alloc(&expr->location, OP_XOR,
+				       expr_get(expr->right), one);
+		not->len = expr->right->len;
+		mreg = get_register(ctx, not);
+		netlink_gen_expr(ctx, not, mreg);
+		netlink_put_register(nle, NFTNL_EXPR_BITWISE_MREG, mreg);
+		expr_free(not);
+
+		xreg = get_register(ctx, expr->right);
+		netlink_gen_expr(ctx, expr->right, xreg);
+		netlink_put_register(nle, NFTNL_EXPR_BITWISE_XREG, xreg);
+		break;
+	}
+	default:
+		BUG("invalid binary operation %u\n", expr->op);
+	}
+
+	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, dreg);
+	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, dreg);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_BOOL);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
+
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 			      const struct expr *expr,
 			      enum nft_registers dreg)
@@ -652,7 +735,11 @@ static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 		netlink_gen_shift(ctx, expr, dreg);
 		break;
 	default:
-		netlink_gen_bitwise(ctx, expr, dreg);
+		if (expr_is_constant(expr->right)) {
+			netlink_gen_bitwise_constant(ctx, expr, dreg);
+		} else {
+			netlink_gen_bitwise_variable(ctx, expr, dreg);
+		}
 		break;
 	}
 }
-- 
2.25.1

