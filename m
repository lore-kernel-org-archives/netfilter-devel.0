Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280D4C43219
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbiDDMGb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236604AbiDDMGa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:06:30 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D661535872
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jiJqigmJDVSP9AHta+pR2/aLS2KaWcAgr53r8Ow5C+Y=; b=HPLdsZKznbQe1qWaTF1HU9jMKE
        eJpgiVEA8nnFeXzRTrjq4oTOtnKmQA4NahqKZJQmSH3/hglJIvPB66polbNqbA5xDM4FhO1uBiEVe
        boP2ZQQj7MduL6c3jppwb5bYtmkF3mSawFuoMGXkoEFyijUqS+smlpvYWGzM7vS1NpD+CB0sj75RL
        5r4/8g/GU1o0jTfE+LBqJh6tL3HsK1pFyO9Vno8VCFLTW/xXY/7WW1oywjyBSEA4sl41o9nc4vtq1
        UDthZ3PbgxkdtblkmbTA8FyWyq4LMALzudgRbdnQhGg8IQzQU10Ae/N4oqPiU5cwQRBaUXlfIao13
        IxE5UG3Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLRe-007FLB-Ps
        for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2022 13:04:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nf-next PATCH v2 4/5] netfilter: bitwise: rename some boolean operation functions
Date:   Mon,  4 Apr 2022 13:04:16 +0100
Message-Id: <20220404120417.188410-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404120417.188410-1-jeremy@azazel.net>
References: <20220404120417.188410-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In the next patch we add support for doing AND, OR and XOR operations
directly in the kernel, so rename some functions and an enum constant
related to mask-and-xor boolean operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h | 10 ++++---
 net/netfilter/nft_bitwise.c              | 34 ++++++++++++------------
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index f3dcc4a34ff1..1c118a316381 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -539,16 +539,20 @@ enum nft_immediate_attributes {
 /**
  * enum nft_bitwise_ops - nf_tables bitwise operations
  *
- * @NFT_BITWISE_BOOL: mask-and-xor operation used to implement NOT, AND, OR and
- *                    XOR boolean operations
+ * @NFT_BITWISE_MASK_XOR: mask-and-xor operation used to implement NOT, AND, OR
+ *                        and XOR boolean operations
  * @NFT_BITWISE_LSHIFT: left-shift operation
  * @NFT_BITWISE_RSHIFT: right-shift operation
  */
 enum nft_bitwise_ops {
-	NFT_BITWISE_BOOL,
+	NFT_BITWISE_MASK_XOR,
 	NFT_BITWISE_LSHIFT,
 	NFT_BITWISE_RSHIFT,
 };
+/*
+ * Old name for NFT_BITWISE_MASK_XOR.  Retained for backwards-compatibility.
+ */
+#define NFT_BITWISE_BOOL NFT_BITWISE_MASK_XOR
 
 /**
  * enum nft_bitwise_attributes - nf_tables bitwise expression netlink attributes
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 9d3039a4ffa3..dad39a2f4433 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -26,8 +26,8 @@ struct nft_bitwise {
 	u8                      nbits;
 };
 
-static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
-				  const struct nft_bitwise *priv)
+static void nft_bitwise_eval_mask_xor(u32 *dst, const u32 *src,
+				      const struct nft_bitwise *priv)
 {
 	unsigned int i;
 
@@ -69,8 +69,8 @@ void nft_bitwise_eval(const struct nft_expr *expr,
 	u32 *dst = &regs->data[priv->dreg];
 
 	switch (priv->op) {
-	case NFT_BITWISE_BOOL:
-		nft_bitwise_eval_bool(dst, src, priv);
+	case NFT_BITWISE_MASK_XOR:
+		nft_bitwise_eval_mask_xor(dst, src, priv);
 		break;
 	case NFT_BITWISE_LSHIFT:
 		nft_bitwise_eval_lshift(dst, src, priv);
@@ -92,8 +92,8 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 	[NFTA_BITWISE_NBITS]	= { .type = NLA_U32 },
 };
 
-static int nft_bitwise_init_bool(struct nft_bitwise *priv,
-				 const struct nlattr *const tb[])
+static int nft_bitwise_init_mask_xor(struct nft_bitwise *priv,
+				     const struct nlattr *const tb[])
 {
 	struct nft_data_desc mask, xor;
 	int err;
@@ -186,7 +186,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_BITWISE_OP]) {
 		priv->op = ntohl(nla_get_be32(tb[NFTA_BITWISE_OP]));
 		switch (priv->op) {
-		case NFT_BITWISE_BOOL:
+		case NFT_BITWISE_MASK_XOR:
 		case NFT_BITWISE_LSHIFT:
 		case NFT_BITWISE_RSHIFT:
 			break;
@@ -194,14 +194,14 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 			return -EOPNOTSUPP;
 		}
 	} else {
-		priv->op = NFT_BITWISE_BOOL;
+		priv->op = NFT_BITWISE_MASK_XOR;
 	}
 	if (tb[NFTA_BITWISE_NBITS])
 		priv->nbits = ntohl(nla_get_be32(tb[NFTA_BITWISE_NBITS]));
 
 	switch(priv->op) {
-	case NFT_BITWISE_BOOL:
-		err = nft_bitwise_init_bool(priv, tb);
+	case NFT_BITWISE_MASK_XOR:
+		err = nft_bitwise_init_mask_xor(priv, tb);
 		break;
 	case NFT_BITWISE_LSHIFT:
 	case NFT_BITWISE_RSHIFT:
@@ -212,8 +212,8 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	return err;
 }
 
-static int nft_bitwise_dump_bool(struct sk_buff *skb,
-				 const struct nft_bitwise *priv)
+static int nft_bitwise_dump_mask_xor(struct sk_buff *skb,
+				     const struct nft_bitwise *priv)
 {
 	if (nft_data_dump(skb, NFTA_BITWISE_MASK, &priv->mask,
 			  NFT_DATA_VALUE, priv->len) < 0)
@@ -252,8 +252,8 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		return -1;
 
 	switch (priv->op) {
-	case NFT_BITWISE_BOOL:
-		err = nft_bitwise_dump_bool(skb, priv);
+	case NFT_BITWISE_MASK_XOR:
+		err = nft_bitwise_dump_mask_xor(skb, priv);
 		break;
 	case NFT_BITWISE_LSHIFT:
 	case NFT_BITWISE_RSHIFT:
@@ -273,7 +273,7 @@ static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
 
-	if (priv->op != NFT_BITWISE_BOOL)
+	if (priv->op != NFT_BITWISE_MASK_XOR)
 		return -EOPNOTSUPP;
 
 	if (memcmp(&priv->xor, &zero, sizeof(priv->xor)) ||
@@ -410,7 +410,7 @@ nft_bitwise_fast_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		return -1;
 	if (nla_put_be32(skb, NFTA_BITWISE_LEN, htonl(sizeof(u32))))
 		return -1;
-	if (nla_put_be32(skb, NFTA_BITWISE_OP, htonl(NFT_BITWISE_BOOL)))
+	if (nla_put_be32(skb, NFTA_BITWISE_OP, htonl(NFT_BITWISE_MASK_XOR)))
 		return -1;
 
 	data.data[0] = priv->mask;
@@ -505,7 +505,7 @@ nft_bitwise_select_ops(const struct nft_ctx *ctx,
 		return &nft_bitwise_ops;
 
 	if (tb[NFTA_BITWISE_OP] &&
-	    ntohl(nla_get_be32(tb[NFTA_BITWISE_OP])) != NFT_BITWISE_BOOL)
+	    ntohl(nla_get_be32(tb[NFTA_BITWISE_OP])) != NFT_BITWISE_MASK_XOR)
 		return &nft_bitwise_ops;
 
 	return &nft_bitwise_fast_ops;
-- 
2.35.1

