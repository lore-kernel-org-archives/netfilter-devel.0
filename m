Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CA4C7EE23
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 13:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjE1NxX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 09:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjE1NxV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 09:53:21 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1300FBE
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 06:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1PsEN000VNsMBuzLy0ENcaTEruyTjgBNPTRfcu2b6S4=; b=n6zsSc55j4CTVJXMC9pUG05w0k
        LvUaKtNaZBJV4a45OEZV8daSY2ou3sKoMaJtK5rx9Q0o4JJGOWXn3jUf1bZN4q/bM4whtluq+Ufjn
        gYCB+Nuh5ZXg3K3w9ctSNijFS/IsWYl3LnZ15tVKZF8V9QM6WSr+Cs1JtsI4pva/j7sfp9jtc1ohC
        yPUgBAJfRjkys6g/O8uET1LlmZJ8pjENF22njxYZrdf1WZQYOzzlaOHgERVdsFiuiFbBEq3GS9Tia
        lHbMs6Fr5MNpIRWTHe17aBFfPfaWMKPdrxNSScvcWYxfyUsChld3qDVtiflrHKnoWNGwesvQtOoxi
        zqz5ugiA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3Gpf-008Wbs-6e
        for netfilter-devel@vger.kernel.org; Sun, 28 May 2023 14:53:15 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v4 2/2] netfilter: bitwise: add support for doing AND, OR and XOR directly
Date:   Sun, 28 May 2023 14:52:59 +0100
Message-Id: <20230528135259.1218169-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230528135259.1218169-1-jeremy@azazel.net>
References: <20230528135259.1218169-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
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
 net/netfilter/nft_bitwise.c              | 132 +++++++++++++++++++++--
 2 files changed, 132 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index a43bdc2a0669..f6dcda26b871 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -559,14 +559,21 @@ enum nft_immediate_attributes {
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
 
@@ -581,6 +588,7 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
  * @NFTA_BITWISE_DATA: argument for non-boolean operations
  *                     (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_SREG2: second source register (NLA_U32: nft_registers)
  *
  * The bitwise expression supports boolean and shift operations.  It implements
  * the boolean operations by performing the following operation:
@@ -604,6 +612,7 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_XOR,
 	NFTA_BITWISE_OP,
 	NFTA_BITWISE_DATA,
+	NFTA_BITWISE_SREG2,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index b9584f840228..dad43e1f1efe 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -17,6 +17,7 @@
 
 struct nft_bitwise {
 	u8			sreg;
+	u8			sreg2;
 	u8			dreg;
 	enum nft_bitwise_ops	op:8;
 	u8			len;
@@ -60,28 +61,72 @@ static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
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
@@ -105,7 +150,8 @@ static int nft_bitwise_init_mask_xor(struct nft_bitwise *priv,
 	};
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
@@ -157,6 +204,44 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
 	return 0;
 }
 
+static int nft_bitwise_init_bool(struct nft_bitwise *priv,
+				 const struct nlattr *const tb[])
+{
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->data),
+		.len	= sizeof(u32),
+	};
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
+		err = nft_data_init(NULL, &priv->data, &desc,
+				    tb[NFTA_BITWISE_DATA]);
+		if (err < 0)
+			return err;
+
+		if (priv->data.data[0] >= BITS_PER_TYPE(u32)) {
+			nft_data_release(&priv->data, desc.type);
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
@@ -188,6 +273,9 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 		case NFT_BITWISE_MASK_XOR:
 		case NFT_BITWISE_LSHIFT:
 		case NFT_BITWISE_RSHIFT:
+		case NFT_BITWISE_AND:
+		case NFT_BITWISE_OR:
+		case NFT_BITWISE_XOR:
 			break;
 		default:
 			return -EOPNOTSUPP;
@@ -204,6 +292,11 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
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
@@ -232,6 +325,19 @@ static int nft_bitwise_dump_shift(struct sk_buff *skb,
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
 static int nft_bitwise_dump(struct sk_buff *skb,
 			    const struct nft_expr *expr, bool reset)
 {
@@ -255,6 +361,11 @@ static int nft_bitwise_dump(struct sk_buff *skb,
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
@@ -299,6 +410,7 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 	    track->regs[priv->dreg].bitwise &&
 	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
 	    priv->sreg == bitwise->sreg &&
+	    priv->sreg2 == bitwise->sreg2 &&
 	    priv->dreg == bitwise->dreg &&
 	    priv->op == bitwise->op &&
 	    priv->len == bitwise->len &&
-- 
2.39.2

