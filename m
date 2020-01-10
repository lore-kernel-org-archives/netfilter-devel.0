Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F637C33CA3
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BE9720721
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="bgH59dJ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgAJMdP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 07:33:15 -0500
Received: from kadath.azazel.net ([81.187.231.250]:39620 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728167AbgAJMdO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 07:33:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uSXwKy0oWacwCwhuSMJXlxhNs2bhC3dQ0qzNJKdKzgM=; b=bgH59dJ6q9dzNb2x6jp8b3dXeV
        zXBMvvETGd1ZfI8nkTPA/Haqx0dGqpgSe95iy838y1CsJ631dl4qa8SThgbT54vYthSbjokUP9lli
        ri92Xs1lMlNFrBj4sX5x554IEcbwm5XNblLrSgridaPFhJY6sLdNF7ua9tgGNpW1BdFYhIIDb+ocv
        A8rNOU+lm8S59s18F82RkOPr48XToeV8XnXJXN4PvLi/7rkY4Dq17QoczaSgFmUJiYqYrn6rAg9b5
        mLiqEBLiPxqgt+zxdP4ocS/yvwn/VPCTIrF+T5WmOnAa7YWbfWr5OBhXPHMJbkDAjHsoN41SFVvxm
        qRp6wMaA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iptTV-0003by-AZ
        for netfilter-devel@vger.kernel.org; Fri, 10 Jan 2020 12:33:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 3/3] netfilter: bitwise: add support for shifts.
Date:   Fri, 10 Jan 2020 12:33:12 +0000
Message-Id: <20200110123312.106438-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110123312.106438-1-jeremy@azazel.net>
References: <20200110123312.106438-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently nft_bitwise only supports boolean operations: NOT, AND, OR and
XOR.  Extend it to do shifts as well.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h |  9 ++-
 net/netfilter/nft_bitwise.c              | 84 ++++++++++++++++++++++--
 2 files changed, 86 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index dd4611767933..8f244ada0ad3 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -492,12 +492,15 @@ enum nft_immediate_attributes {
  * @NFTA_BITWISE_LEN: length of operands (NLA_U32)
  * @NFTA_BITWISE_MASK: mask value (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_XOR: xor value (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_LSHIFT: left shift value (NLA_U32)
+ * @NFTA_BITWISE_RSHIFT: right shift value (NLA_U32)
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
@@ -512,6 +515,8 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_LEN,
 	NFTA_BITWISE_MASK,
 	NFTA_BITWISE_XOR,
+	NFTA_BITWISE_LSHIFT,
+	NFTA_BITWISE_RSHIFT,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index d7724250be1f..e4db77057b0e 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -15,12 +15,20 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_offload.h>
 
+enum nft_bitwise_ops {
+	OP_BOOL,
+	OP_LSHIFT,
+	OP_RSHIFT,
+};
+
 struct nft_bitwise {
 	enum nft_registers	sreg:8;
 	enum nft_registers	dreg:8;
+	enum nft_bitwise_ops	op:8;
 	u8			len;
 	struct nft_data		mask;
 	struct nft_data		xor;
+	u8			shift;
 };
 
 void nft_bitwise_eval(const struct nft_expr *expr,
@@ -31,6 +39,26 @@ void nft_bitwise_eval(const struct nft_expr *expr,
 	u32 *dst = &regs->data[priv->dreg];
 	unsigned int i;
 
+	if (priv->op == OP_LSHIFT) {
+		u32 carry = 0;
+
+		for (i = DIV_ROUND_UP(priv->len, sizeof(u32)); i > 0; i--) {
+			dst[i - 1] = (src[i - 1] << priv->shift) | carry;
+			carry = src[i - 1] >> (32 - priv->shift);
+		}
+		return;
+	}
+
+	if (priv->op == OP_RSHIFT) {
+		u32 carry = 0;
+
+		for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
+			dst[i] = carry | (src[i] >> priv->shift);
+			carry = src[i] << (32 - priv->shift);
+		}
+		return;
+	}
+
 	for (i = 0; i < DIV_ROUND_UP(priv->len, 4); i++)
 		dst[i] = (src[i] & priv->mask.data[i]) ^ priv->xor.data[i];
 }
@@ -41,6 +69,8 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 	[NFTA_BITWISE_LEN]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_MASK]	= { .type = NLA_NESTED },
 	[NFTA_BITWISE_XOR]	= { .type = NLA_NESTED },
+	[NFTA_BITWISE_LSHIFT]	= { .type = NLA_U32 },
+	[NFTA_BITWISE_RSHIFT]	= { .type = NLA_U32 },
 };
 
 static int nft_bitwise_init(const struct nft_ctx *ctx,
@@ -52,11 +82,9 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	u32 len;
 	int err;
 
-	if (tb[NFTA_BITWISE_SREG] == NULL ||
-	    tb[NFTA_BITWISE_DREG] == NULL ||
-	    tb[NFTA_BITWISE_LEN] == NULL ||
-	    tb[NFTA_BITWISE_MASK] == NULL ||
-	    tb[NFTA_BITWISE_XOR] == NULL)
+	if (!tb[NFTA_BITWISE_SREG] ||
+	    !tb[NFTA_BITWISE_DREG] ||
+	    !tb[NFTA_BITWISE_LEN])
 		return -EINVAL;
 
 	err = nft_parse_u32_check(tb[NFTA_BITWISE_LEN], U8_MAX, &len);
@@ -76,6 +104,36 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	if (tb[NFTA_BITWISE_LSHIFT]) {
+		u32 shift;
+
+		err = nft_parse_u32_check(tb[NFTA_BITWISE_LSHIFT], U8_MAX,
+					  &shift);
+		if (err < 0)
+			return err;
+
+		priv->shift = shift;
+		priv->op = OP_LSHIFT;
+		return 0;
+	}
+
+	if (tb[NFTA_BITWISE_RSHIFT]) {
+		u32 shift;
+
+		err = nft_parse_u32_check(tb[NFTA_BITWISE_RSHIFT], U8_MAX,
+					  &shift);
+		if (err < 0)
+			return err;
+
+		priv->shift = shift;
+		priv->op = OP_RSHIFT;
+		return 0;
+	}
+
+	if (!tb[NFTA_BITWISE_MASK] ||
+	    !tb[NFTA_BITWISE_XOR])
+		return -EINVAL;
+
 	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &d1,
 			    tb[NFTA_BITWISE_MASK]);
 	if (err < 0)
@@ -94,6 +152,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 		goto err2;
 	}
 
+	priv->op = OP_BOOL;
 	return 0;
 err2:
 	nft_data_release(&priv->xor, d2.type);
@@ -113,6 +172,18 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (nla_put_be32(skb, NFTA_BITWISE_LEN, htonl(priv->len)))
 		return -1;
 
+	if (priv->op == OP_LSHIFT) {
+		if (nla_put_be32(skb, NFTA_BITWISE_LSHIFT, htonl(priv->shift)))
+			return -1;
+		return 0;
+	}
+
+	if (priv->op == OP_RSHIFT) {
+		if (nla_put_be32(skb, NFTA_BITWISE_RSHIFT, htonl(priv->shift)))
+			return -1;
+		return 0;
+	}
+
 	if (nft_data_dump(skb, NFTA_BITWISE_MASK, &priv->mask,
 			  NFT_DATA_VALUE, priv->len) < 0)
 		return -1;
@@ -133,6 +204,9 @@ static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
 
+	if (priv->op != OP_BOOL)
+		return -EOPNOTSUPP;
+
 	if (memcmp(&priv->xor, &zero, sizeof(priv->xor)) ||
 	    priv->sreg != priv->dreg || priv->len != reg->len)
 		return -EOPNOTSUPP;
-- 
2.24.1

