Return-Path: <SRS0=+R7G=3E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26DAC32771
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 20:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5D1C2084D
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 20:27:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="u7oJ0Ux1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgAOU1k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 15:27:40 -0500
Received: from kadath.azazel.net ([81.187.231.250]:54194 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgAOU1k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 15:27:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cx9O5Ir1QJzOaGxwRJvHQB3NbcgpD2JGlrpdqyh+Tz0=; b=u7oJ0Ux1jDRn0Ed8aj9DOf9LX2
        U1CR0LaaMKAVPtZV7ZkKqwaUqU9E5Mj5QbwbOJ5t1rJN6OzWeFq3Q5XyIGQhRYSPec98L04Pp2eFB
        MmtfA5PwNiLLatvqwxo9yvFFohyc9Sps6k0sK/xY4+ZPzbLPNIpIfIc6l0LpRqHy8muMa/dBy8XEd
        hS+tzwb4yhTwKWMHb6nV3h8WOM6TA319FFcUpT50crybYaSvs72ycD1SMvtjfpBc/pzRFIZGXFSod
        n91JZCXtIHVT3EGB7oSYfZApXzvFBmcR/9sEcr5C28lQNXu2abAFyMLu9z5WiYFA0BSaJcJVJmOl6
        JqOOVnCg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1irovP-00054b-3P; Wed, 15 Jan 2020 20:05:59 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 10/10] netfilter: bitwise: add support for shifts.
Date:   Wed, 15 Jan 2020 20:05:57 +0000
Message-Id: <20200115200557.26202-11-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115200557.26202-1-jeremy@azazel.net>
References: <20200115200557.26202-1-jeremy@azazel.net>
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
 include/uapi/linux/netfilter/nf_tables.h |  9 ++-
 net/netfilter/nft_bitwise.c              | 75 ++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 0277ebe30c5c..59455e7fec93 100644
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
@@ -506,11 +510,12 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_DATA: argument for non-boolean operations
  *                     (NLA_NESTED: nft_data_attributes)
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
index ba1c0cd332c4..7db8e1c42ac9 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -34,6 +34,32 @@ static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
 		dst[i] = (src[i] & priv->mask.data[i]) ^ priv->xor.data[i];
 }
 
+static void nft_bitwise_eval_lshift(u32 *dst, const u32 *src,
+				    const struct nft_bitwise *priv)
+{
+	u32 shift = priv->data.data[0];
+	unsigned int i;
+	u32 carry = 0;
+
+	for (i = DIV_ROUND_UP(priv->len, sizeof(u32)); i > 0; i--) {
+		dst[i - 1] = (src[i - 1] << shift) | carry;
+		carry = src[i - 1] >> (BITS_PER_TYPE(u32) - shift);
+	}
+}
+
+static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
+				    const struct nft_bitwise *priv)
+{
+	u32 shift = priv->data.data[0];
+	unsigned int i;
+	u32 carry = 0;
+
+	for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
+		dst[i] = carry | (src[i] >> shift);
+		carry = src[i] << (BITS_PER_TYPE(u32) - shift);
+	}
+}
+
 void nft_bitwise_eval(const struct nft_expr *expr,
 		      struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
@@ -45,6 +71,12 @@ void nft_bitwise_eval(const struct nft_expr *expr,
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
 
@@ -97,6 +129,32 @@ static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 	return err;
 }
 
+static int nft_bitwise_init_shift(struct nft_bitwise *priv,
+				  const struct nlattr *const tb[])
+{
+	struct nft_data_desc d;
+	int err;
+
+	if (tb[NFTA_BITWISE_MASK] ||
+	    tb[NFTA_BITWISE_XOR])
+		return -EINVAL;
+
+	if (!tb[NFTA_BITWISE_DATA])
+		return -EINVAL;
+
+	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &d,
+			    tb[NFTA_BITWISE_DATA]);
+	if (err < 0)
+		return err;
+	if (d.type != NFT_DATA_VALUE || d.len != sizeof(u32) ||
+	    priv->data.data[0] >= BITS_PER_TYPE(u32)) {
+		nft_data_release(&priv->data, d.type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int nft_bitwise_init(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nlattr * const tb[])
@@ -131,6 +189,8 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 		priv->op = ntohl(nla_get_be32(tb[NFTA_BITWISE_OP]));
 		switch (priv->op) {
 		case NFT_BITWISE_BOOL:
+		case NFT_BITWISE_LSHIFT:
+		case NFT_BITWISE_RSHIFT:
 			break;
 		default:
 			return -EINVAL;
@@ -142,6 +202,9 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	switch(priv->op) {
 	case NFT_BITWISE_BOOL:
 		return nft_bitwise_init_bool(priv, tb);
+	case NFT_BITWISE_LSHIFT:
+	case NFT_BITWISE_RSHIFT:
+		return nft_bitwise_init_shift(priv, tb);
 	}
 
 	return -EINVAL;
@@ -161,6 +224,15 @@ static int nft_bitwise_dump_bool(struct sk_buff *skb,
 	return 0;
 }
 
+static int nft_bitwise_dump_shift(struct sk_buff *skb,
+				  const struct nft_bitwise *priv)
+{
+	if (nft_data_dump(skb, NFTA_BITWISE_DATA, &priv->data,
+			  NFT_DATA_VALUE, sizeof(u32)) < 0)
+		return -1;
+	return 0;
+}
+
 static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
@@ -177,6 +249,9 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
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

