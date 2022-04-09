Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC8EC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 13:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242283AbiDINyn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 09:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242271AbiDINyd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 09:54:33 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635F53E0C5
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 06:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FqG5mBD5+bw9glcjYl70RDoIrX+eoCwVP1L3FhFaXHw=; b=rmWaiH0+yi6+WOiacTsOGmdB+7
        V3WmifylRW9/XtX06BHE1z6xzfiIR+tEekCatssyIIzRe6jgthgk9pTEQ/rglhkWAjbc0FazTq0SW
        au9fXjd4lbzTEAMWxNK8EGlqQujC5Ph6DOujin9EKwGraopAQjIwZmLuZFlDkcnEaLDtiaJBHIAGl
        3ES1udQN4FvIMKkfO5Rj4WmaeDGPUfK9Ym2BveU2Jis6IGc9YWUdiQvKjhGN/1LH+nn07Gx/t9Fff
        R55CVwlxJ+KRVhaHOjQetk4Bqc1mA0La2a7q0TnfFHhBXPeDu4xx4dd37em9cDwgKfs7E4CIaUQlD
        iycc0afw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ndBVj-00CMwq-Qd
        for netfilter-devel@vger.kernel.org; Sat, 09 Apr 2022 14:52:19 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nf-next PATCH v3 1/3] netfilter: bitwise: keep track of bit-length of expressions
Date:   Sat,  9 Apr 2022 14:52:11 +0100
Message-Id: <20220409135213.1450058-2-jeremy@azazel.net>
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

Some bitwise operations are generated in user space when munging paylod
expressions.  During delinearization, user space attempts to eliminate
these operations.  However, it does this before deducing the byte-order
or the correct length in bits of the operands, which means that it
doesn't always handle multi-byte host-endian operations correctly.
Therefore, add support for storing the bit-length of the expression,
even though the kernel doesn't use it, in order to be able to pass it
back to user space.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_bitwise.c              | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 466fd3f4447c..f3dcc4a34ff1 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -561,6 +561,7 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
  * @NFTA_BITWISE_DATA: argument for non-boolean operations
  *                     (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_NBITS: length of operation in bits (NLA_U32)
  *
  * The bitwise expression supports boolean and shift operations.  It implements
  * the boolean operations by performing the following operation:
@@ -584,6 +585,7 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_XOR,
 	NFTA_BITWISE_OP,
 	NFTA_BITWISE_DATA,
+	NFTA_BITWISE_NBITS,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 83590afe3768..a120eaadb3e7 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -23,6 +23,7 @@ struct nft_bitwise {
 	struct nft_data		mask;
 	struct nft_data		xor;
 	struct nft_data		data;
+	u16                     nbits;
 };
 
 static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
@@ -88,6 +89,7 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 	[NFTA_BITWISE_XOR]	= { .type = NLA_NESTED },
 	[NFTA_BITWISE_OP]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_DATA]	= { .type = NLA_NESTED },
+	[NFTA_BITWISE_NBITS]	= { .type = NLA_U32 },
 };
 
 static int nft_bitwise_init_bool(struct nft_bitwise *priv,
@@ -194,6 +196,16 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	} else {
 		priv->op = NFT_BITWISE_BOOL;
 	}
+	if (tb[NFTA_BITWISE_NBITS]) {
+		u32 nbits;
+
+		err = nft_parse_u32_check(tb[NFTA_BITWISE_NBITS],
+					  U8_MAX * BITS_PER_BYTE, &nbits);
+		if (err < 0)
+			return err;
+
+		priv->nbits = nbits;
+	}
 
 	switch(priv->op) {
 	case NFT_BITWISE_BOOL:
@@ -244,6 +256,8 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		return -1;
 	if (nla_put_be32(skb, NFTA_BITWISE_OP, htonl(priv->op)))
 		return -1;
+	if (nla_put_be32(skb, NFTA_BITWISE_NBITS, htonl(priv->nbits)))
+		return -1;
 
 	switch (priv->op) {
 	case NFT_BITWISE_BOOL:
-- 
2.35.1

