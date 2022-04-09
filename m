Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2326DC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 13:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242274AbiDINyj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 09:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242262AbiDINyb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 09:54:31 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FA53DDC2
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 06:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lTYqgS1rg5MjHI+nOxdp+1XIqHVW7aLKYZJC4/XoIQo=; b=K0ESf/ZdUZLinTiSMYFPitad4d
        4ZOAhF0OiwIAeRWrQv3xbu356N7xdEZz9qZ4Uwtd6cL6D9OCNx5ERt4AP5Gdc9kgbKSy4OuLKWOuh
        83pp2Tv/k/l7S7U0Gj3AAgNLuCkgHjXjDFMOJIbjUqCvxCm9y2IEHgTolnaq0UYxlnn6Mt2MUB+yh
        cvmmXEKjUwc2tKprjywKrLjekuQtUGpaWmq5c8h7nQDxAFj9k5loSf+9vndmDPnPiZYN7JxMagCNG
        guwtIWN/QvGmwgrfPOyMuEQep0oSk5OXxhuPiQz0b7WLg/nbjWY3XWqQ/0B2FQyytEKQOs2GlN73F
        z6MYooJQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ndBVk-00CMwq-0S
        for netfilter-devel@vger.kernel.org; Sat, 09 Apr 2022 14:52:20 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nf-next PATCH v3 3/3] netfilter: bitwise: add support for doing AND, OR and XOR directly
Date:   Sat,  9 Apr 2022 14:52:13 +0100
Message-Id: <20220409135213.1450058-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220409135213.1450058-1-jeremy@azazel.net>
References: <20220409135213.1450058-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hitherto, these operations have been converted in user space to
mask-and-xor operations on one register and two immediate values, and it
is the latter which have been evaluated by the kernel.  We add support
for evaluating these operations directly in kernel space on one register
and either an immediate value or a second register.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h |  11 +-
 net/netfilter/nft_bitwise.c              | 128 +++++++++++++++++++++--
 2 files changed, 128 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 1c118a316381..cd3e9e4ac646 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -543,14 +543,21 @@ enum nft_immediate_attributes {
  *                        and XOR boolean operations
  * @NFT_BITWISE_LSHIFT: left-shift operation
  * @NFT_BITWISE_RSHIFT: right-shift operation
+ * @NFT_BITWISE_AND: and operation
+ * @NFT_BITWISE_OR: or operation
+ * @NFT_BITWISE_XOR: xor operation
  */
 enum nft_bitwise_ops {
 	NFT_BITWISE_MASK_XOR,
 	NFT_BITWISE_LSHIFT,
 	NFT_BITWISE_RSHIFT,
+	NFT_BITWISE_AND,
+	NFT_BITWISE_OR,
+	NFT_BITWISE_XOR,
 };
 /*
- * Old name for NFT_BITWISE_MASK_XOR.  Retained for backwards-compatibility.
+ * Old name for NFT_BITWISE_MASK_XOR, predating the addition of NFT_BITWISE_AND,
+ * NFT_BITWISE_OR and NFT_BITWISE_XOR.  Retained for backwards-compatibility.
  */
 #define NFT_BITWISE_BOOL NFT_BITWISE_MASK_XOR
 
@@ -566,6 +573,7 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_DATA: argument for non-boolean operations
  *                     (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_NBITS: length of operation in bits (NLA_U32)
+ * @NFTA_BITWISE_SREG2: second source register (NLA_U32: nft_registers)
  *
  * The bitwise expression supports boolean and shift operations.  It implements
  * the boolean operations by performing the following operation:
@@ -590,6 +598,7 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_OP,
 	NFTA_BITWISE_DATA,
 	NFTA_BITWISE_NBITS,
+	NFTA_BITWISE_SREG2,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index c50f4340a21e..6c79ffa09338 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -17,6 +17,7 @@
 
 struct nft_bitwise {
 	u8			sreg;
+	u8			sreg2;
 	u8			dreg;
 	enum nft_bitwise_ops	op:8;
 	u8			len;
@@ -61,28 +62,72 @@ static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
 	}
 }
 
+static void nft_bitwise_eval_and(u32 *dst, const u32 *src, const u32 *src2,
+				 const struct nft_bitwise *priv)
+{
+	unsigned int i, n;
+
+	for (i = 0, n = DIV_ROUND_UP(priv->len, sizeof(u32)); i < n; i++)
+		dst[i] = src[i] & src2[i];
+}
+
+static void nft_bitwise_eval_or(u32 *dst, const u32 *src, const u32 *src2,
+				const struct nft_bitwise *priv)
+{
+	unsigned int i, n;
+
+	for (i = 0, n = DIV_ROUND_UP(priv->len, sizeof(u32)); i < n; i++)
+		dst[i] = src[i] | src2[i];
+}
+
+static void nft_bitwise_eval_xor(u32 *dst, const u32 *src, const u32 *src2,
+				 const struct nft_bitwise *priv)
+{
+	unsigned int i, n;
+
+	for (i = 0, n = DIV_ROUND_UP(priv->len, sizeof(u32)); i < n; i++)
+		dst[i] = src[i] ^ src2[i];
+}
+
 void nft_bitwise_eval(const struct nft_expr *expr,
 		      struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
-	const u32 *src = &regs->data[priv->sreg];
+	const u32 *src = &regs->data[priv->sreg], *src2;
 	u32 *dst = &regs->data[priv->dreg];
 
-	switch (priv->op) {
-	case NFT_BITWISE_MASK_XOR:
+	if (priv->op == NFT_BITWISE_MASK_XOR) {
 		nft_bitwise_eval_mask_xor(dst, src, priv);
-		break;
-	case NFT_BITWISE_LSHIFT:
+		return;
+	}
+	if (priv->op == NFT_BITWISE_LSHIFT) {
 		nft_bitwise_eval_lshift(dst, src, priv);
-		break;
-	case NFT_BITWISE_RSHIFT:
+		return;
+	}
+	if (priv->op == NFT_BITWISE_RSHIFT) {
 		nft_bitwise_eval_rshift(dst, src, priv);
-		break;
+		return;
+	}
+
+	src2 = priv->sreg2 ? &regs->data[priv->sreg2] : priv->data.data;
+
+	if (priv->op == NFT_BITWISE_AND) {
+		nft_bitwise_eval_and(dst, src, src2, priv);
+		return;
+	}
+	if (priv->op == NFT_BITWISE_OR) {
+		nft_bitwise_eval_or(dst, src, src2, priv);
+		return;
+	}
+	if (priv->op == NFT_BITWISE_XOR) {
+		nft_bitwise_eval_xor(dst, src, src2, priv);
+		return;
 	}
 }
 
 static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 	[NFTA_BITWISE_SREG]	= { .type = NLA_U32 },
+	[NFTA_BITWISE_SREG2]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_DREG]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_LEN]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_MASK]	= { .type = NLA_NESTED },
@@ -98,7 +143,8 @@ static int nft_bitwise_init_mask_xor(struct nft_bitwise *priv,
 	struct nft_data_desc mask, xor;
 	int err;
 
-	if (tb[NFTA_BITWISE_DATA])
+	if (tb[NFTA_BITWISE_DATA] ||
+	    tb[NFTA_BITWISE_SREG2])
 		return -EINVAL;
 
 	if (!tb[NFTA_BITWISE_MASK] ||
@@ -139,7 +185,8 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
 	int err;
 
 	if (tb[NFTA_BITWISE_MASK] ||
-	    tb[NFTA_BITWISE_XOR])
+	    tb[NFTA_BITWISE_XOR]  ||
+	    tb[NFTA_BITWISE_SREG2])
 		return -EINVAL;
 
 	if (!tb[NFTA_BITWISE_DATA])
@@ -158,6 +205,40 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
 	return 0;
 }
 
+static int nft_bitwise_init_bool(struct nft_bitwise *priv,
+				 const struct nlattr *const tb[])
+{
+	struct nft_data_desc d;
+	int err;
+
+	if (tb[NFTA_BITWISE_MASK] ||
+	    tb[NFTA_BITWISE_XOR])
+		return -EINVAL;
+
+	if ((!tb[NFTA_BITWISE_DATA] && !tb[NFTA_BITWISE_SREG2]) ||
+	    (tb[NFTA_BITWISE_DATA] && tb[NFTA_BITWISE_SREG2]))
+		return -EINVAL;
+
+	if (tb[NFTA_BITWISE_DATA]) {
+		err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &d,
+				    tb[NFTA_BITWISE_DATA]);
+		if (err < 0)
+			return err;
+		if (d.type != NFT_DATA_VALUE || d.len != sizeof(u32) ||
+		    priv->data.data[0] >= BITS_PER_TYPE(u32)) {
+			nft_data_release(&priv->data, d.type);
+			return -EINVAL;
+		}
+	} else {
+		err = nft_parse_register_load(tb[NFTA_BITWISE_SREG2],
+					      &priv->sreg2, priv->len);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
 static int nft_bitwise_init(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nlattr * const tb[])
@@ -189,6 +270,9 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 		case NFT_BITWISE_MASK_XOR:
 		case NFT_BITWISE_LSHIFT:
 		case NFT_BITWISE_RSHIFT:
+		case NFT_BITWISE_AND:
+		case NFT_BITWISE_OR:
+		case NFT_BITWISE_XOR:
 			break;
 		default:
 			return -EOPNOTSUPP;
@@ -215,6 +299,11 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	case NFT_BITWISE_RSHIFT:
 		err = nft_bitwise_init_shift(priv, tb);
 		break;
+	case NFT_BITWISE_AND:
+	case NFT_BITWISE_OR:
+	case NFT_BITWISE_XOR:
+		err = nft_bitwise_init_bool(priv, tb);
+		break;
 	}
 
 	return err;
@@ -243,6 +332,19 @@ static int nft_bitwise_dump_shift(struct sk_buff *skb,
 	return 0;
 }
 
+static int nft_bitwise_dump_bool(struct sk_buff *skb,
+				 const struct nft_bitwise *priv)
+{
+	if (nft_dump_register(skb, NFTA_BITWISE_SREG2, priv->sreg2))
+		return -1;
+
+	if (nft_data_dump(skb, NFTA_BITWISE_DATA, &priv->data,
+			  NFT_DATA_VALUE, sizeof(u32)) < 0)
+		return -1;
+
+	return 0;
+}
+
 static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
@@ -267,6 +369,11 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	case NFT_BITWISE_RSHIFT:
 		err = nft_bitwise_dump_shift(skb, priv);
 		break;
+	case NFT_BITWISE_AND:
+	case NFT_BITWISE_OR:
+	case NFT_BITWISE_XOR:
+		err = nft_bitwise_dump_bool(skb, priv);
+		break;
 	}
 
 	return err;
@@ -311,6 +418,7 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 	    track->regs[priv->dreg].bitwise &&
 	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
 	    priv->sreg == bitwise->sreg &&
+	    priv->sreg2 == bitwise->sreg2 &&
 	    priv->dreg == bitwise->dreg &&
 	    priv->op == bitwise->op &&
 	    priv->len == bitwise->len &&
-- 
2.35.1

