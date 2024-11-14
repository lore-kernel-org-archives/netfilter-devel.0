Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F019A1AE00C
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 21:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731618838; cv=none; b=JDNiSQUD80MHAwnJ78U3um8IxUrj7YtynHvYCvlWoVtxdNEjgsWPdwKKK1Vw4vAbxYGpcN962QS+Rxt0VAEFNwb5fqmeQUEYtAYiGARHWSER50s81ogxxjz6iZfcrttDSazisFTr1k/KQslV7d43YX/vpsABrbCjrKdkigwnoXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731618838; c=relaxed/simple;
	bh=3hIq8Q+Ds9BxjWwaoWOAqwcOJiRP4shGY0/QrkV823s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=grMdq5at5GV+mJsmUgxAPiFa3fp8cswIHpeA/WAK17ybgXkG6q4DMqD83Jk0HyXVUoD51VuDzQDmVP+fbuTIQMtzfYA4EEZE6qJ/dib2V9IpmxZhZUjsCXeb9wdfgLwXLoy4PBf0A/UJ509utFseKQvn3gDUiUu0K6CDbIQdMmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jeremy@azazel.net
Subject: [PATCH nf-next 1/2] netfilter: bitwise: rename some boolean operation functions
Date: Thu, 14 Nov 2024 22:13:46 +0100
Message-Id: <20241114211347.24700-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241114211347.24700-1-pablo@netfilter.org>
References: <20241114211347.24700-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeremy Sowden <jeremy@azazel.net>

In the next patch we add support for doing AND, OR and XOR operations
directly in the kernel, so rename some functions and an enum constant
related to mask-and-xor boolean operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 10 ++++---
 net/netfilter/nft_bitwise.c              | 34 ++++++++++++------------
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 9e9079321380..487542234ccd 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -564,16 +564,20 @@ enum nft_immediate_attributes {
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
index 7de95674fd8c..7f6a4f800537 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -25,8 +25,8 @@ struct nft_bitwise {
 	struct nft_data		data;
 };
 
-static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
-				  const struct nft_bitwise *priv)
+static void nft_bitwise_eval_mask_xor(u32 *dst, const u32 *src,
+				      const struct nft_bitwise *priv)
 {
 	unsigned int i;
 
@@ -68,8 +68,8 @@ void nft_bitwise_eval(const struct nft_expr *expr,
 	u32 *dst = &regs->data[priv->dreg];
 
 	switch (priv->op) {
-	case NFT_BITWISE_BOOL:
-		nft_bitwise_eval_bool(dst, src, priv);
+	case NFT_BITWISE_MASK_XOR:
+		nft_bitwise_eval_mask_xor(dst, src, priv);
 		break;
 	case NFT_BITWISE_LSHIFT:
 		nft_bitwise_eval_lshift(dst, src, priv);
@@ -90,8 +90,8 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 	[NFTA_BITWISE_DATA]	= { .type = NLA_NESTED },
 };
 
-static int nft_bitwise_init_bool(struct nft_bitwise *priv,
-				 const struct nlattr *const tb[])
+static int nft_bitwise_init_mask_xor(struct nft_bitwise *priv,
+				     const struct nlattr *const tb[])
 {
 	struct nft_data_desc mask = {
 		.type	= NFT_DATA_VALUE,
@@ -185,7 +185,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_BITWISE_OP]) {
 		priv->op = ntohl(nla_get_be32(tb[NFTA_BITWISE_OP]));
 		switch (priv->op) {
-		case NFT_BITWISE_BOOL:
+		case NFT_BITWISE_MASK_XOR:
 		case NFT_BITWISE_LSHIFT:
 		case NFT_BITWISE_RSHIFT:
 			break;
@@ -193,12 +193,12 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 			return -EOPNOTSUPP;
 		}
 	} else {
-		priv->op = NFT_BITWISE_BOOL;
+		priv->op = NFT_BITWISE_MASK_XOR;
 	}
 
 	switch(priv->op) {
-	case NFT_BITWISE_BOOL:
-		err = nft_bitwise_init_bool(priv, tb);
+	case NFT_BITWISE_MASK_XOR:
+		err = nft_bitwise_init_mask_xor(priv, tb);
 		break;
 	case NFT_BITWISE_LSHIFT:
 	case NFT_BITWISE_RSHIFT:
@@ -209,8 +209,8 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	return err;
 }
 
-static int nft_bitwise_dump_bool(struct sk_buff *skb,
-				 const struct nft_bitwise *priv)
+static int nft_bitwise_dump_mask_xor(struct sk_buff *skb,
+				     const struct nft_bitwise *priv)
 {
 	if (nft_data_dump(skb, NFTA_BITWISE_MASK, &priv->mask,
 			  NFT_DATA_VALUE, priv->len) < 0)
@@ -248,8 +248,8 @@ static int nft_bitwise_dump(struct sk_buff *skb,
 		return -1;
 
 	switch (priv->op) {
-	case NFT_BITWISE_BOOL:
-		err = nft_bitwise_dump_bool(skb, priv);
+	case NFT_BITWISE_MASK_XOR:
+		err = nft_bitwise_dump_mask_xor(skb, priv);
 		break;
 	case NFT_BITWISE_LSHIFT:
 	case NFT_BITWISE_RSHIFT:
@@ -269,7 +269,7 @@ static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
 
-	if (priv->op != NFT_BITWISE_BOOL)
+	if (priv->op != NFT_BITWISE_MASK_XOR)
 		return -EOPNOTSUPP;
 
 	if (memcmp(&priv->xor, &zero, sizeof(priv->xor)) ||
@@ -406,7 +406,7 @@ nft_bitwise_fast_dump(struct sk_buff *skb,
 		return -1;
 	if (nla_put_be32(skb, NFTA_BITWISE_LEN, htonl(sizeof(u32))))
 		return -1;
-	if (nla_put_be32(skb, NFTA_BITWISE_OP, htonl(NFT_BITWISE_BOOL)))
+	if (nla_put_be32(skb, NFTA_BITWISE_OP, htonl(NFT_BITWISE_MASK_XOR)))
 		return -1;
 
 	data.data[0] = priv->mask;
@@ -501,7 +501,7 @@ nft_bitwise_select_ops(const struct nft_ctx *ctx,
 		return &nft_bitwise_ops;
 
 	if (tb[NFTA_BITWISE_OP] &&
-	    ntohl(nla_get_be32(tb[NFTA_BITWISE_OP])) != NFT_BITWISE_BOOL)
+	    ntohl(nla_get_be32(tb[NFTA_BITWISE_OP])) != NFT_BITWISE_MASK_XOR)
 		return &nft_bitwise_ops;
 
 	return &nft_bitwise_fast_ops;
-- 
2.30.2

