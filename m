Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D9FC33C9E
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EFCD24672
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:40:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="McEm7WKU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgANVkJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 16:40:09 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55584 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANVkJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 16:40:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ym8sqFXLNY3HBrdzvtFKICF4HzV+LKme6SyBD8Pxd4g=; b=McEm7WKU8l8b/W/2FDnwQtQve2
        qDvlFzc02cF45/9SNayS0IvWRz7mizLbpY6M0DiTDPn7JyI/yJnO5sMyHhEaruxGbluz7slbAc3Vj
        S54cdPDC/G88RgbPV1O4T89zdAq/MZhHsyaFFlBFjSJA7B0ApBfaSrpQbY6J29TNZTN9+vz5xj/e7
        oQX9OcfeqvuqyLWQidLGeEps0A2dObaGS1fIW8QyuMCu2ZgiUDvqNsxzxBcu9uXizY6ded8zNTGnW
        ck901De6aZ43kJMt1Z5ASgCXJwj640z8zEflXYgXqvAqBbropt16ZpQwyFQPaY5x1htL5UWsgeyV1
        ZAElKV6g==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1irTkW-0001Dh-7w; Tue, 14 Jan 2020 21:29:20 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 10/10] netfilter: bitwise: add support for shifts.
Date:   Tue, 14 Jan 2020 21:29:18 +0000
Message-Id: <20200114212918.134062-11-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114212918.134062-1-jeremy@azazel.net>
References: <20200114212918.134062-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hitherto nft_bitwise has only supported boolean operations: NOT, AND, OR
and XOR.  Extend it to do shifts as well.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h |  9 +++-
 net/netfilter/nft_bitwise.c              | 68 ++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 7cb85fd0d38e..b824ca44150a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -489,9 +489,13 @@ enum nft_immediate_attributes {
  *
  * @NFT_BITWISE_BOOL: mask-and-xor operation used to implement NOT, AND, OR and
  *                    XOR boolean operations
+ * @NFT_BITWISE_LSHIFT: left-shift operation
+ * @NFT_BITWISE_RSHIFT: right-shift operation
  */
 enum nft_bitwise_ops {
 	NFT_BITWISE_BOOL,
+	NFT_BITWISE_LSHIFT,
+	NFT_BITWISE_RSHIFT,
 };
 
 /**
@@ -505,11 +509,12 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
  * @NFTA_BITWISE_DATA: argument for non-boolean operations (NLA_U32)
  *
- * The bitwise expression performs the following operation:
+ * The bitwise expression supports boolean and shift operations.  It implements
+ * the boolean operations by performing the following operation:
  *
  * dreg = (sreg & mask) ^ xor
  *
- * which allow to express all bitwise operations:
+ * with these mask and xor values:
  *
  * 		mask	xor
  * NOT:		1	1
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 72abaa83a8ca..2f55037501fd 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -34,6 +34,30 @@ static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
 		dst[i] = (src[i] & priv->mask.data[i]) ^ priv->xor.data[i];
 }
 
+static void nft_bitwise_eval_lshift(u32 *dst, const u32 *src,
+				    const struct nft_bitwise *priv)
+{
+	unsigned int i;
+	u32 carry = 0;
+
+	for (i = DIV_ROUND_UP(priv->len, sizeof(u32)); i > 0; i--) {
+		dst[i - 1] = (src[i - 1] << priv->data) | carry;
+		carry = src[i - 1] >> (32 - priv->data);
+	}
+}
+
+static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
+				    const struct nft_bitwise *priv)
+{
+	unsigned int i;
+	u32 carry = 0;
+
+	for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
+		dst[i] = carry | (src[i] >> priv->data);
+		carry = src[i] << (32 - priv->data);
+	}
+}
+
 void nft_bitwise_eval(const struct nft_expr *expr,
 		      struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
@@ -45,6 +69,12 @@ void nft_bitwise_eval(const struct nft_expr *expr,
 	case NFT_BITWISE_BOOL:
 		nft_bitwise_eval_bool(dst, src, priv);
 		break;
+	case NFT_BITWISE_LSHIFT:
+		nft_bitwise_eval_lshift(dst, src, priv);
+		break;
+	case NFT_BITWISE_RSHIFT:
+		nft_bitwise_eval_rshift(dst, src, priv);
+		break;
 	}
 }
 
@@ -97,6 +127,28 @@ static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 	return err;
 }
 
+static int nft_bitwise_init_shift(struct nft_bitwise *priv,
+				  const struct nlattr *const tb[])
+{
+	u32 shift;
+	int err;
+
+	if (tb[NFTA_BITWISE_MASK] ||
+	    tb[NFTA_BITWISE_XOR])
+		return -EINVAL;
+
+	if (!tb[NFTA_BITWISE_DATA])
+		return -EINVAL;
+
+	err = nft_parse_u32_check(tb[NFTA_BITWISE_DATA], U8_MAX,
+				  &shift);
+	if (err < 0)
+		return err;
+
+	priv->data = shift;
+	return 0;
+}
+
 static int nft_bitwise_init(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nlattr * const tb[])
@@ -131,6 +183,8 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 		priv->op = ntohl(nla_get_be32(tb[NFTA_BITWISE_OP]));
 		switch (priv->op) {
 		case NFT_BITWISE_BOOL:
+		case NFT_BITWISE_LSHIFT:
+		case NFT_BITWISE_RSHIFT:
 			break;
 		default:
 			return -EINVAL;
@@ -142,6 +196,9 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	switch(priv->op) {
 	case NFT_BITWISE_BOOL:
 		return nft_bitwise_init_bool(priv, tb);
+	case NFT_BITWISE_LSHIFT:
+	case NFT_BITWISE_RSHIFT:
+		return nft_bitwise_init_shift(priv, tb);
 	}
 
 	return -EINVAL;
@@ -161,6 +218,14 @@ static int nft_bitwise_dump_bool(struct sk_buff *skb,
 	return 0;
 }
 
+static int nft_bitwise_dump_shift(struct sk_buff *skb,
+				  const struct nft_bitwise *priv)
+{
+	if (nla_put_be32(skb, NFTA_BITWISE_DATA, htonl(priv->data)))
+		return -1;
+	return 0;
+}
+
 static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
@@ -177,6 +242,9 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	switch (priv->op) {
 	case NFT_BITWISE_BOOL:
 		return nft_bitwise_dump_bool(skb, priv);
+	case NFT_BITWISE_LSHIFT:
+	case NFT_BITWISE_RSHIFT:
+		return nft_bitwise_dump_shift(skb, priv);
 	}
 
 	return -1;
-- 
2.24.1

