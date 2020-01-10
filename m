Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6041C33CA4
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A811520838
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="IgsF+v2p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgAJMiK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 07:38:10 -0500
Received: from kadath.azazel.net ([81.187.231.250]:39864 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728214AbgAJMiI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 07:38:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a1+ue9GuYvdbFq3OfZWKyTa0SrMV5st5AgrCo/RwFCU=; b=IgsF+v2p2DKpJ3SjDoYFZOfeyW
        hrtV+XDEtaFpCMCM5+yWdb7FgtGgUS+pQMzYqLQeJ0AlFM4DT0YF0bIZmU4YpF1K9+l5ERUtQwozW
        vbJWAPRYwNHom7+sLIC1clZJykcZ7sNF1mTolN+9dtSHJuhfHpVM69B7kuqGfPFdoDYN1dCjOVNM4
        D8ZATXGfpSPcOylK2GoegNcUXRrNHrf1L0D2AUPgepRse9NC0MskQ9eN+bkbOmm9y4n/MXZ8iyGsf
        Mixf5KNUxgFOKBTb7vgifClpmYi0FuZbeVy0ijCkdt6ZhTM55EcW71diEJM7Q877T5pb/E5LxdmGn
        6UjC50tg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iptYF-0003im-FI
        for netfilter-devel@vger.kernel.org; Fri, 10 Jan 2020 12:38:07 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 6/7] netlink: add support for handling shift expressions.
Date:   Fri, 10 Jan 2020 12:38:05 +0000
Message-Id: <20200110123806.106546-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110123806.106546-1-jeremy@azazel.net>
References: <20200110123806.106546-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The kernel supports bitwise shift operations, so add support to the
netlink linearization and delinearization code.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/nf_tables.h |  4 +++
 src/netlink_delinearize.c           | 19 +++++++++++++
 src/netlink_linearize.c             | 42 ++++++++++++++++++++++++++---
 3 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index c556ccd3dbf7..12dbb2adbbdf 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -490,6 +490,8 @@ enum nft_immediate_attributes {
  * @NFTA_BITWISE_LEN: length of operands (NLA_U32)
  * @NFTA_BITWISE_MASK: mask value (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_XOR: xor value (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_LSHIFT: left shift value (NLA_U32)
+ * @NFTA_BITWISE_RSHIFT: right shift value (NLA_U32)
  *
  * The bitwise expression performs the following operation:
  *
@@ -510,6 +512,8 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_LEN,
 	NFTA_BITWISE_MASK,
 	NFTA_BITWISE_XOR,
+	NFTA_BITWISE_LSHIFT,
+	NFTA_BITWISE_RSHIFT,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 8f2a5dfacd3e..a45ad924b216 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -372,6 +372,24 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 				     "Bitwise expression has no left "
 				     "hand side");
 
+	nld.value = nftnl_expr_get(nle, NFTNL_EXPR_BITWISE_LSHIFT, &nld.len);
+	if (nld.value != NULL) {
+		struct expr *right = netlink_alloc_value(loc, &nld);
+
+		expr = binop_expr_alloc(loc, OP_LSHIFT, left, right);
+		expr->len = left->len;
+		goto dreg;
+	}
+
+	nld.value = nftnl_expr_get(nle, NFTNL_EXPR_BITWISE_RSHIFT, &nld.len);
+	if (nld.value != NULL) {
+		struct expr *right = netlink_alloc_value(loc, &nld);
+
+		expr = binop_expr_alloc(loc, OP_RSHIFT, left, right);
+		expr->len = left->len;
+		goto dreg;
+	}
+
 	expr = left;
 
 	nld.value = nftnl_expr_get(nle, NFTNL_EXPR_BITWISE_MASK, &nld.len);
@@ -423,6 +441,7 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 	mpz_clear(x);
 	mpz_clear(o);
 
+dreg:
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_BITWISE_DREG);
 	netlink_set_register(ctx, dreg, expr);
 }
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index d5e177d5e75c..19a513021fcb 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -545,9 +545,29 @@ static void combine_binop(mpz_t mask, mpz_t xor, const mpz_t m, const mpz_t x)
 	mpz_and(mask, mask, m);
 }
 
-static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
+static void netlink_gen_shift(struct netlink_linearize_ctx *ctx,
 			      const struct expr *expr,
 			      enum nft_registers dreg)
+{
+	enum nft_bitwise_attributes shift_attr = expr->op == OP_LSHIFT ?
+		NFTNL_EXPR_BITWISE_LSHIFT : NFTNL_EXPR_BITWISE_RSHIFT;
+	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
+	struct nftnl_expr *nle;
+
+	netlink_gen_expr(ctx, expr->left, dreg);
+
+	nle = alloc_nft_expr("bitwise");
+	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, dreg);
+	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, dreg);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
+	nftnl_expr_set_u32(nle, shift_attr, mpz_get_uint32(expr->right->value));
+
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
+static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
+				const struct expr *expr,
+				enum nft_registers dreg)
 {
 	struct nftnl_expr *nle;
 	struct nft_data_linearize nld;
@@ -562,8 +582,9 @@ static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 	mpz_init(val);
 	mpz_init(tmp);
 
-	binops[n++] = left = (void *)expr;
-	while (left->etype == EXPR_BINOP && left->left != NULL)
+	binops[n++] = left = (struct expr *) expr;
+	while (left->etype == EXPR_BINOP && left->left != NULL &&
+	       (left->op == OP_AND || left->op == OP_OR || left->op == OP_XOR))
 		binops[n++] = left = left->left;
 	n--;
 
@@ -613,6 +634,21 @@ static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
+			      const struct expr *expr,
+			      enum nft_registers dreg)
+{
+	switch(expr->op) {
+	case OP_LSHIFT:
+	case OP_RSHIFT:
+		netlink_gen_shift(ctx, expr, dreg);
+		break;
+	default:
+		netlink_gen_bitwise(ctx, expr, dreg);
+		break;
+	}
+}
+
 static enum nft_byteorder_ops netlink_gen_unary_op(enum ops op)
 {
 	switch (op) {
-- 
2.24.1

