Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 362C5C11D2F
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 12:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E88AB2072D
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 12:49:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="qesjMnA9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgBXMte (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 07:49:34 -0500
Received: from kadath.azazel.net ([81.187.231.250]:57310 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbgBXMte (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 07:49:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sacfy0xBabJUrrCg0wNriP2/q9wC7A3SAWS3ChUk5w8=; b=qesjMnA9T6WaVn8AawDssAIFHm
        jmJ/5UVQSe03PTFioFQwUqiJstNXBqVUZjtc7g4l4OUINYSHqKcwOb9+tZEUE4siSya8b3UajfBpR
        MZZsNzHifl9QgBlPjzv1acZ/8PuN4L1L62efweGxgR/ybO6PYMMC5HS4hzrdqXkFvzptCLsiiXCWz
        JeGoKmd+HcQhRdcdCLt6G0hPZlGcP5q0FzuqeYfZLo2XtKmDWctkfa31cThYA+kuKgpeXn2HbLDuJ
        Ht13bn9pWFRc6cObYeRi7/44JL/sNR6R1CtvyDEOxyZDaUQTf8iE+X0SjWmU/23ZrqJesMxd71IUW
        bWlUMCjg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j6DAy-0001eE-EG; Mon, 24 Feb 2020 12:49:32 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 2/2] netfilter: bitwise: add support for passing mask and xor values in registers.
Date:   Mon, 24 Feb 2020 12:49:31 +0000
Message-Id: <20200224124931.512416-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224124931.512416-1-jeremy@azazel.net>
References: <20200224124931.512416-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently bitwise boolean operations can only have one variable operand
because the mask and xor values have to be passed as immediate data.
Support operations with two variable operands by allowing the mask and
xor to be passed in registers.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h |   4 +
 net/netfilter/nft_bitwise.c              | 118 +++++++++++++++++------
 2 files changed, 93 insertions(+), 29 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 9c3d2d04d6a1..bd48b5358890 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -526,6 +526,8 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
  * @NFTA_BITWISE_DATA: argument for non-boolean operations
  *                     (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_MREG: mask register (NLA_U32: nft_registers)
+ * @NFTA_BITWISE_XREG: xor register (NLA_U32: nft_registers)
  *
  * The bitwise expression supports boolean and shift operations.  It implements
  * the boolean operations by performing the following operation:
@@ -549,6 +551,8 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_XOR,
 	NFTA_BITWISE_OP,
 	NFTA_BITWISE_DATA,
+	NFTA_BITWISE_MREG,
+	NFTA_BITWISE_XREG,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index bc37d6c59db4..8877b50fed78 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -15,23 +15,47 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_offload.h>
 
+enum nft_bitwise_flags {
+	NFT_BITWISE_MASK_REG = 1,
+	NFT_BITWISE_XOR_REG,
+};
+
 struct nft_bitwise {
 	enum nft_registers	sreg:8;
 	enum nft_registers	dreg:8;
 	enum nft_bitwise_ops	op:8;
 	u8			len;
-	struct nft_data		mask;
-	struct nft_data		xor;
+	enum nft_bitwise_flags	flags;
 	struct nft_data		data;
+	union {
+		struct nft_data         data;
+		enum nft_registers      reg:8;
+	} mask;
+	union {
+		struct nft_data         data;
+		enum nft_registers      reg:8;
+	} xor;
 };
 
 static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
-				  const struct nft_bitwise *priv)
+				  const struct nft_bitwise *priv,
+				  struct nft_regs *regs)
 {
+	const u32 *mask, *xor;
 	unsigned int i;
 
+	if (priv->flags & NFT_BITWISE_MASK_REG)
+		mask = &regs->data[priv->mask.reg];
+	else
+		mask = priv->mask.data.data;
+
+	if (priv->flags & NFT_BITWISE_XOR_REG)
+		xor = &regs->data[priv->xor.reg];
+	else
+		xor = priv->xor.data.data;
+
 	for (i = 0; i < DIV_ROUND_UP(priv->len, 4); i++)
-		dst[i] = (src[i] & priv->mask.data[i]) ^ priv->xor.data[i];
+		dst[i] = (src[i] & mask[i]) ^ xor[i];
 }
 
 static void nft_bitwise_eval_lshift(u32 *dst, const u32 *src,
@@ -69,7 +93,7 @@ void nft_bitwise_eval(const struct nft_expr *expr,
 
 	switch (priv->op) {
 	case NFT_BITWISE_BOOL:
-		nft_bitwise_eval_bool(dst, src, priv);
+		nft_bitwise_eval_bool(dst, src, priv, regs);
 		break;
 	case NFT_BITWISE_LSHIFT:
 		nft_bitwise_eval_lshift(dst, src, priv);
@@ -88,6 +112,8 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 	[NFTA_BITWISE_XOR]	= { .type = NLA_NESTED },
 	[NFTA_BITWISE_OP]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_DATA]	= { .type = NLA_NESTED },
+	[NFTA_BITWISE_MREG]	= { .type = NLA_U32 },
+	[NFTA_BITWISE_XREG]	= { .type = NLA_U32 },
 };
 
 static int nft_bitwise_init_bool(struct nft_bitwise *priv,
@@ -99,33 +125,57 @@ static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 	if (tb[NFTA_BITWISE_DATA])
 		return -EINVAL;
 
-	if (!tb[NFTA_BITWISE_MASK] ||
-	    !tb[NFTA_BITWISE_XOR])
+	if ((!tb[NFTA_BITWISE_MASK] && !tb[NFTA_BITWISE_MREG]) ||
+	    (tb[NFTA_BITWISE_MASK] && tb[NFTA_BITWISE_MREG]))
 		return -EINVAL;
 
-	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &mask,
-			    tb[NFTA_BITWISE_MASK]);
-	if (err < 0)
-		return err;
-	if (mask.type != NFT_DATA_VALUE || mask.len != priv->len) {
-		err = -EINVAL;
-		goto err1;
+	if ((!tb[NFTA_BITWISE_XOR] && !tb[NFTA_BITWISE_XREG]) ||
+	    (tb[NFTA_BITWISE_XOR] && tb[NFTA_BITWISE_XREG]))
+		return -EINVAL;
+
+	if (tb[NFTA_BITWISE_MASK]) {
+		err = nft_data_init(NULL, &priv->mask.data,
+				    sizeof(priv->mask.data), &mask,
+				    tb[NFTA_BITWISE_MASK]);
+		if (err < 0)
+			return err;
+		if (mask.type != NFT_DATA_VALUE || mask.len != priv->len) {
+			err = -EINVAL;
+			goto err1;
+		}
+	} else {
+		priv->mask.reg = nft_parse_register(tb[NFTA_BITWISE_MREG]);
+		err = nft_validate_register_load(priv->mask.reg, priv->len);
+		if (err < 0)
+			return err;
+		priv->flags |= NFT_BITWISE_MASK_REG;
 	}
 
-	err = nft_data_init(NULL, &priv->xor, sizeof(priv->xor), &xor,
-			    tb[NFTA_BITWISE_XOR]);
-	if (err < 0)
-		goto err1;
-	if (xor.type != NFT_DATA_VALUE || xor.len != priv->len) {
-		err = -EINVAL;
-		goto err2;
+	if (tb[NFTA_BITWISE_XOR]) {
+		err = nft_data_init(NULL, &priv->xor.data,
+				    sizeof(priv->xor.data), &xor,
+				    tb[NFTA_BITWISE_XOR]);
+		if (err < 0)
+			goto err1;
+		if (xor.type != NFT_DATA_VALUE || xor.len != priv->len) {
+			err = -EINVAL;
+			goto err2;
+		}
+	} else {
+		priv->xor.reg = nft_parse_register(tb[NFTA_BITWISE_XREG]);
+		err = nft_validate_register_load(priv->xor.reg, priv->len);
+		if (err < 0)
+			return err;
+		priv->flags |= NFT_BITWISE_XOR_REG;
 	}
 
 	return 0;
 err2:
-	nft_data_release(&priv->xor, xor.type);
+	if (tb[NFTA_BITWISE_XOR])
+		nft_data_release(&priv->xor.data, xor.type);
 err1:
-	nft_data_release(&priv->mask, mask.type);
+	if (tb[NFTA_BITWISE_MASK])
+		nft_data_release(&priv->mask.data, mask.type);
 	return err;
 }
 
@@ -215,13 +265,23 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 static int nft_bitwise_dump_bool(struct sk_buff *skb,
 				 const struct nft_bitwise *priv)
 {
-	if (nft_data_dump(skb, NFTA_BITWISE_MASK, &priv->mask,
-			  NFT_DATA_VALUE, priv->len) < 0)
-		return -1;
+	if (priv->flags & NFT_BITWISE_MASK_REG) {
+		if (nft_dump_register(skb, NFTA_BITWISE_MREG, priv->mask.reg))
+			return -1;
+	} else {
+		if (nft_data_dump(skb, NFTA_BITWISE_MASK, &priv->mask.data,
+				  NFT_DATA_VALUE, priv->len) < 0)
+			return -1;
+	}
 
-	if (nft_data_dump(skb, NFTA_BITWISE_XOR, &priv->xor,
-			  NFT_DATA_VALUE, priv->len) < 0)
-		return -1;
+	if (priv->flags & NFT_BITWISE_XOR_REG) {
+		if (nft_dump_register(skb, NFTA_BITWISE_XREG, priv->xor.reg))
+			return -1;
+	} else {
+		if (nft_data_dump(skb, NFTA_BITWISE_XOR, &priv->xor.data,
+				  NFT_DATA_VALUE, priv->len) < 0)
+			return -1;
+	}
 
 	return 0;
 }
-- 
2.25.0

