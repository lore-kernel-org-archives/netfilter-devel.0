From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH nf-next v2 2/2] netfilter: nft_hash: support of symmetric hash
Date: Tue, 28 Feb 2017 18:38:26 +0100
Message-ID: <20170228173826.e2lx4f2yrbn7aegn@nevthink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33615 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdB1Rjx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2017 12:39:53 -0500
Received: by mail-wm0-f65.google.com with SMTP id v77so3502984wmv.0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 09:38:30 -0800 (PST)
Received: from nevthink ([91.126.74.89])
        by smtp.gmail.com with ESMTPSA id 63sm1889297wmp.9.2017.02.28.09.38.28
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Feb 2017 09:38:28 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch provides symmetric hash support according to source
ip address and port, and destination ip address and port.

For this purpose, the __skb_get_hash_symmetric() is used to
identify the flow as it uses FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL
flag by default.

The new attribute NFTA_HASH_TYPE has been included to support
different types of hashing functions. Currently supported
NFT_HASH_JENKINS through jhash and NFT_HASH_SYM through symhash.

The main difference between both types are:
 - jhash requires an expression with sreg, symhash doesn't.
 - symhash supports modulus and offset, but not seed.

Examples:

 nft add rule ip nat prerouting ct mark set jhash ip saddr mod 2
 nft add rule ip nat prerouting ct mark set symhash mod 2

Signed-off-by: Laura Garcia Liebana <laura.garcia@zevenet.com>
---
v2:
	- Avoid warning due to 'const' from symhash eval skb

 include/uapi/linux/netfilter/nf_tables.h | 13 +++++
 net/netfilter/nft_hash.c                 | 98 +++++++++++++++++++++++++++++++-
 2 files changed, 110 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 7b730cab99bd..a444a63a9eee 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -793,6 +793,17 @@ enum nft_rt_keys {
 };
 
 /**
+ * enum nft_hash_types - nf_tables hash expression types
+ *
+ * @NFT_HASH_JENKINS: Jenkins Hash
+ * @NFT_HASH_SYM: Symmetric Hash
+ */
+enum nft_hash_types {
+	NFT_HASH_JENKINS,
+	NFT_HASH_SYM,
+};
+
+/**
  * enum nft_hash_attributes - nf_tables hash expression netlink attributes
  *
  * @NFTA_HASH_SREG: source register (NLA_U32)
@@ -801,6 +812,7 @@ enum nft_rt_keys {
  * @NFTA_HASH_MODULUS: modulus value (NLA_U32)
  * @NFTA_HASH_SEED: seed value (NLA_U32)
  * @NFTA_HASH_OFFSET: add this offset value to hash result (NLA_U32)
+ * @NFTA_HASH_TYPE: hash operation (NLA_U32: nft_hash_types)
  */
 enum nft_hash_attributes {
 	NFTA_HASH_UNSPEC,
@@ -810,6 +822,7 @@ enum nft_hash_attributes {
 	NFTA_HASH_MODULUS,
 	NFTA_HASH_SEED,
 	NFTA_HASH_OFFSET,
+	NFTA_HASH_TYPE,
 	__NFTA_HASH_MAX,
 };
 #define NFTA_HASH_MAX	(__NFTA_HASH_MAX - 1)
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index ccb834ef049b..8eaf3d25b970 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -38,6 +38,25 @@ static void nft_jhash_eval(const struct nft_expr *expr,
 	regs->data[priv->dreg] = h + priv->offset;
 }
 
+struct nft_symhash {
+	enum nft_registers      dreg:8;
+	u32			modulus;
+	u32			offset;
+};
+
+static void nft_symhash_eval(const struct nft_expr *expr,
+			     struct nft_regs *regs,
+			     const struct nft_pktinfo *pkt)
+{
+	struct nft_symhash *priv = nft_expr_priv(expr);
+	struct sk_buff *skb = pkt->skb;
+	u32 h;
+
+	h = reciprocal_scale(__skb_get_hash_symmetric(skb), priv->modulus);
+
+	regs->data[priv->dreg] = h + priv->offset;
+}
+
 static const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
 	[NFTA_HASH_SREG]	= { .type = NLA_U32 },
 	[NFTA_HASH_DREG]	= { .type = NLA_U32 },
@@ -45,6 +64,7 @@ static const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
 	[NFTA_HASH_MODULUS]	= { .type = NLA_U32 },
 	[NFTA_HASH_SEED]	= { .type = NLA_U32 },
 	[NFTA_HASH_OFFSET]	= { .type = NLA_U32 },
+	[NFTA_HASH_TYPE]	= { .type = NLA_U32 },
 };
 
 static int nft_jhash_init(const struct nft_ctx *ctx,
@@ -92,6 +112,32 @@ static int nft_jhash_init(const struct nft_ctx *ctx,
 					   NFT_DATA_VALUE, sizeof(u32));
 }
 
+static int nft_symhash_init(const struct nft_ctx *ctx,
+			    const struct nft_expr *expr,
+			    const struct nlattr * const tb[])
+{
+	struct nft_symhash *priv = nft_expr_priv(expr);
+
+	if (!tb[NFTA_HASH_DREG]    ||
+	    !tb[NFTA_HASH_MODULUS])
+		return -EINVAL;
+
+	if (tb[NFTA_HASH_OFFSET])
+		priv->offset = ntohl(nla_get_be32(tb[NFTA_HASH_OFFSET]));
+
+	priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);
+
+	priv->modulus = ntohl(nla_get_be32(tb[NFTA_HASH_MODULUS]));
+	if (priv->modulus <= 1)
+		return -ERANGE;
+
+	if (priv->offset + priv->modulus - 1 < priv->offset)
+		return -EOVERFLOW;
+
+	return nft_validate_register_store(ctx, priv->dreg, NULL,
+					   NFT_DATA_VALUE, sizeof(u32));
+}
+
 static int nft_jhash_dump(struct sk_buff *skb,
 			  const struct nft_expr *expr)
 {
@@ -110,6 +156,28 @@ static int nft_jhash_dump(struct sk_buff *skb,
 	if (priv->offset != 0)
 		if (nla_put_be32(skb, NFTA_HASH_OFFSET, htonl(priv->offset)))
 			goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_HASH_TYPE, htonl(NFT_HASH_JENKINS)))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static int nft_symhash_dump(struct sk_buff *skb,
+			    const struct nft_expr *expr)
+{
+	const struct nft_symhash *priv = nft_expr_priv(expr);
+
+	if (nft_dump_register(skb, NFTA_HASH_DREG, priv->dreg))
+		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_HASH_MODULUS, htonl(priv->modulus)))
+		goto nla_put_failure;
+	if (priv->offset != 0)
+		if (nla_put_be32(skb, NFTA_HASH_OFFSET, htonl(priv->offset)))
+			goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_HASH_TYPE, htonl(NFT_HASH_SYM)))
+		goto nla_put_failure;
 	return 0;
 
 nla_put_failure:
@@ -125,9 +193,37 @@ static const struct nft_expr_ops nft_jhash_ops = {
 	.dump		= nft_jhash_dump,
 };
 
+static const struct nft_expr_ops nft_symhash_ops = {
+	.type		= &nft_hash_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_symhash)),
+	.eval		= nft_symhash_eval,
+	.init		= nft_symhash_init,
+	.dump		= nft_symhash_dump,
+};
+
+static const struct nft_expr_ops *
+nft_hash_select_ops(const struct nft_ctx *ctx,
+		    const struct nlattr * const tb[])
+{
+	u32 type;
+
+	if (!tb[NFTA_HASH_TYPE])
+		return ERR_PTR(-EINVAL);
+
+	type = ntohl(nla_get_be32(tb[NFTA_HASH_TYPE]));
+
+	switch (type) {
+	case NFT_HASH_SYM:
+		return &nft_symhash_ops;
+	case NFT_HASH_JENKINS:
+	default:
+		return &nft_jhash_ops;
+	}
+}
+
 static struct nft_expr_type nft_hash_type __read_mostly = {
 	.name		= "hash",
-	.ops		= &nft_jhash_ops,
+	.select_ops	= &nft_hash_select_ops,
 	.policy		= nft_hash_policy,
 	.maxattr	= NFTA_HASH_MAX,
 	.owner		= THIS_MODULE,
-- 
2.11.0

