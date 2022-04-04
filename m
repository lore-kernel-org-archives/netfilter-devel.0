Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C979C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344011AbiDDMaE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344547AbiDDMaD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:30:03 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03183DDC2
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=R65lq9s1pHEKtDag3FfG1pSevLnF4hGMFBW9NJNUYto=; b=b7Xe125+TKY0XxEkzLssOAhMw+
        DPCiV6RFw9DdU1H6aMQkAN8wIOXhX2mtqWGNj7P/jSDumBMXaKc/YyapygKN+gGfBuooqKhvNwiKw
        FuXXmIwxOk6lvw93v5o7zM8MzXCMn7g8+eO877y02awS+Th2aVXxmeiGR+XxOh5aFb9e+DD+CvwIx
        lzDoSnDHUmH0PFZARYUSMH2lpTnNRMdIMBQ/4zgplT/EGLmMFn3GK9vqlJDwwD0UQNBdoyxxx9Jul
        vWaUZSoupRwETyvlXuR4eOsu/de/OeaSQRMCMyQFpeq1JVaNnT+2NRXzdHXl7mbojRowzk+VqqZ9z
        UHKeWeTQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbL-007FTC-1Q; Mon, 04 Apr 2022 13:14:31 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 27/32] netlink: rename bitwise operation functions
Date:   Mon,  4 Apr 2022 13:14:05 +0100
Message-Id: <20220404121410.188509-28-jeremy@azazel.net>
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

In the next few patches we add support for doing AND, OR and XOR
operations directly in the kernel, so rename a couple of functions and
an enum constant related to mask-and-xor boolean operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 17 +++++++++--------
 src/netlink_linearize.c   | 18 +++++++++---------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e7042d6ae940..63f6febb457d 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -446,11 +446,12 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 	ctx->stmt = expr_stmt_alloc(loc, expr);
 }
 
-static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
-					       const struct location *loc,
-					       const struct nftnl_expr *nle,
-					       enum nft_registers sreg,
-					       struct expr *left)
+static struct expr *
+netlink_parse_bitwise_mask_xor(struct netlink_parse_ctx *ctx,
+			       const struct location *loc,
+			       const struct nftnl_expr *nle,
+			       enum nft_registers sreg,
+			       struct expr *left)
 {
 	struct nft_data_delinearize nld;
 	struct expr *expr, *mask, *xor, *or;
@@ -559,9 +560,9 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 	op = nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_OP);
 
 	switch (op) {
-	case NFT_BITWISE_BOOL:
-		expr = netlink_parse_bitwise_bool(ctx, loc, nle, sreg,
-						  left);
+	case NFT_BITWISE_MASK_XOR:
+		expr = netlink_parse_bitwise_mask_xor(ctx, loc, nle, sreg,
+						      left);
 		break;
 	case NFT_BITWISE_LSHIFT:
 		expr = netlink_parse_bitwise_shift(ctx, loc, nle, OP_LSHIFT,
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 4793f3853bee..478bad073c82 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -594,9 +594,9 @@ static void combine_binop(mpz_t mask, mpz_t xor, const mpz_t m, const mpz_t x)
 	mpz_and(mask, mask, m);
 }
 
-static void netlink_gen_shift(struct netlink_linearize_ctx *ctx,
-			      const struct expr *expr,
-			      enum nft_registers dreg)
+static void netlink_gen_bitwise_shift(struct netlink_linearize_ctx *ctx,
+				      const struct expr *expr,
+				      enum nft_registers dreg)
 {
 	enum nft_bitwise_ops op = expr->op == OP_LSHIFT ?
 		NFT_BITWISE_LSHIFT : NFT_BITWISE_RSHIFT;
@@ -621,9 +621,9 @@ static void netlink_gen_shift(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
-static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
-				const struct expr *expr,
-				enum nft_registers dreg)
+static void netlink_gen_bitwise_mask_xor(struct netlink_linearize_ctx *ctx,
+					 const struct expr *expr,
+					 enum nft_registers dreg)
 {
 	struct nftnl_expr *nle;
 	struct nft_data_linearize nld;
@@ -675,7 +675,7 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("bitwise");
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, dreg);
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, dreg);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_BOOL);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_MASK_XOR);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
 	if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_NBITS, expr->len);
@@ -700,10 +700,10 @@ static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 	switch(expr->op) {
 	case OP_LSHIFT:
 	case OP_RSHIFT:
-		netlink_gen_shift(ctx, expr, dreg);
+		netlink_gen_bitwise_shift(ctx, expr, dreg);
 		break;
 	default:
-		netlink_gen_bitwise(ctx, expr, dreg);
+		netlink_gen_bitwise_mask_xor(ctx, expr, dreg);
 		break;
 	}
 }
-- 
2.35.1

