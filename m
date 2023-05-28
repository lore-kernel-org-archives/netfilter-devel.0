Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79395C7EE33
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 14:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjE1OBk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 10:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjE1OBf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 10:01:35 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2635C9
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 07:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=48yAVw3l8xbyZeODy+QjdKnhMuajWlNi2GSf/bI9TtQ=; b=O9yBIXs1hZPxSeXGTuXxXgRG4X
        AJ4Iw2J7LFYCc/EaEYnnut1hVnLCVA/ukWGqlI6RRNmvqvFVaadaQcMm16YVgIMOAqM+ql2CRiNoG
        pCFmmjkS6HZIlfaLJUh3QwEoIPMC2yPgFKWboTGzdfXqI+dXxZDt0ND+HWGrCvKgVOHMtVcm+jIFF
        6M6XU5NjPsqc9LY+20i33TiGH3LNtwh9PnU6ZBaGL2uhxnHVdESLke/mUUXgCX86LTHEJAmcRQn+J
        DlavDsj75RZSCcH5HohGJDWjQRi/q013C05a09W3nxbYBUIpiD54Yv+gzVdyPQeJvmprYNUBZR6Hq
        LGp8g6rw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3Gxe-008Xe1-5m; Sun, 28 May 2023 15:01:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH nft v5 1/8] netlink: support (de)linearization of new bitwise boolean operations
Date:   Sun, 28 May 2023 15:00:51 +0100
Message-Id: <20230528140058.1218669-2-jeremy@azazel.net>
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
 include/linux/netfilter/nf_tables.h | 19 +++++++--
 src/netlink_delinearize.c           | 64 ++++++++++++++++++++++-------
 src/netlink_linearize.c             | 62 +++++++++++++++++++++++-----
 3 files changed, 117 insertions(+), 28 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 9c6f02c26054..2e3a7ede6290 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -555,16 +555,27 @@ enum nft_immediate_attributes {
 /**
  * enum nft_bitwise_ops - nf_tables bitwise operations
  *
- * @NFT_BITWISE_BOOL: mask-and-xor operation used to implement NOT, AND, OR and
- *                    XOR boolean operations
+ * @NFT_BITWISE_MASK_XOR: mask-and-xor operation used to implement NOT, AND, OR
+ *                        and XOR boolean operations
  * @NFT_BITWISE_LSHIFT: left-shift operation
  * @NFT_BITWISE_RSHIFT: right-shift operation
+ * @NFT_BITWISE_AND: and operation
+ * @NFT_BITWISE_OR: or operation
+ * @NFT_BITWISE_XOR: xor operation
  */
 enum nft_bitwise_ops {
-	NFT_BITWISE_BOOL,
+	NFT_BITWISE_MASK_XOR,
 	NFT_BITWISE_LSHIFT,
 	NFT_BITWISE_RSHIFT,
+	NFT_BITWISE_AND,
+	NFT_BITWISE_OR,
+	NFT_BITWISE_XOR,
 };
+/*
+ * Old name for NFT_BITWISE_MASK_XOR, predating the addition of NFT_BITWISE_AND,
+ * NFT_BITWISE_OR and NFT_BITWISE_XOR.  Retained for backwards-compatibility.
+ */
+#define NFT_BITWISE_BOOL NFT_BITWISE_MASK_XOR
 
 /**
  * enum nft_bitwise_attributes - nf_tables bitwise expression netlink attributes
@@ -577,6 +588,7 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
  * @NFTA_BITWISE_DATA: argument for non-boolean operations
  *                     (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_SREG2: second source register (NLA_U32: nft_registers)
  *
  * The bitwise expression supports boolean and shift operations.  It implements
  * the boolean operations by performing the following operation:
@@ -600,6 +612,7 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_XOR,
 	NFTA_BITWISE_OP,
 	NFTA_BITWISE_DATA,
+	NFTA_BITWISE_SREG2,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 935a6667a1c7..bdd3242bf5ec 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -457,12 +457,12 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 	ctx->stmt = expr_stmt_alloc(loc, expr);
 }
 
-static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
-					       const struct location *loc,
-					       const struct nftnl_expr *nle,
-					       enum nft_registers sreg,
-					       struct expr *left)
-
+static struct expr *
+netlink_parse_bitwise_mask_xor(struct netlink_parse_ctx *ctx,
+			       const struct location *loc,
+			       const struct nftnl_expr *nle,
+			       enum nft_registers sreg,
+			       struct expr *left)
 {
 	struct nft_data_delinearize nld;
 	struct expr *expr, *mask, *xor, *or;
@@ -522,10 +522,39 @@ static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
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
+	if (left->len > 0)
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
@@ -536,7 +565,9 @@ static struct expr *netlink_parse_bitwise_shift(struct netlink_parse_ctx *ctx,
 	right = netlink_alloc_value(loc, &nld);
 	right->byteorder = BYTEORDER_HOST_ENDIAN;
 
-	expr = binop_expr_alloc(loc, op, left, right);
+	expr = binop_expr_alloc(loc,
+				op == NFT_BITWISE_LSHIFT ? OP_LSHIFT : OP_RSHIFT,
+				left, right);
 	expr->len = nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_LEN) * BITS_PER_BYTE;
 
 	return expr;
@@ -560,16 +591,19 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 	op = nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_OP);
 
 	switch (op) {
-	case NFT_BITWISE_BOOL:
-		expr = netlink_parse_bitwise_bool(ctx, loc, nle, sreg,
-						  left);
+	case NFT_BITWISE_MASK_XOR:
+		expr = netlink_parse_bitwise_mask_xor(ctx, loc, nle, sreg,
+						      left);
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
index 11cf48a3f9d0..25cff75df585 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -662,9 +662,9 @@ static void combine_binop(mpz_t mask, mpz_t xor, const mpz_t m, const mpz_t x)
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
@@ -689,9 +689,9 @@ static void netlink_gen_shift(struct netlink_linearize_ctx *ctx,
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
@@ -708,7 +708,8 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
 
 	binops[n++] = left = (struct expr *) expr;
 	while (left->etype == EXPR_BINOP && left->left != NULL &&
-	       (left->op == OP_AND || left->op == OP_OR || left->op == OP_XOR))
+	       (left->op == OP_AND || left->op == OP_OR || left->op == OP_XOR) &&
+	       expr_is_constant(left->right))
 		binops[n++] = left = left->left;
 	n--;
 
@@ -743,7 +744,7 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("bitwise");
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, dreg);
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, dreg);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_BOOL);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_MASK_XOR);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
 
 	netlink_gen_raw_data(mask, expr->byteorder, len, &nld);
@@ -759,6 +760,44 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
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
+
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 			      const struct expr *expr,
 			      enum nft_registers dreg)
@@ -766,10 +805,13 @@ static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 	switch(expr->op) {
 	case OP_LSHIFT:
 	case OP_RSHIFT:
-		netlink_gen_shift(ctx, expr, dreg);
+		netlink_gen_bitwise_shift(ctx, expr, dreg);
 		break;
 	default:
-		netlink_gen_bitwise(ctx, expr, dreg);
+		if (expr_is_constant(expr->right))
+			netlink_gen_bitwise_mask_xor(ctx, expr, dreg);
+		else
+			netlink_gen_bitwise_bool(ctx, expr, dreg);
 		break;
 	}
 }
-- 
2.39.2

