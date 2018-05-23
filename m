From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/18] netfilter: nft_hash: add map lookups for hashing operations
Date: Wed, 23 May 2018 20:42:40 +0200
Message-ID: <20180523184254.22599-5-pablo@netfilter.org>
References: <20180523184254.22599-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523184254.22599-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Laura Garcia Liebana <nevola@gmail.com>

This patch creates new attributes to accept a map as argument and
then perform the lookup with the generated hash accordingly.

Both current hash functions are supported: Jenkins and Symmetric Hash.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |   4 +
 net/netfilter/nft_hash.c                 | 131 ++++++++++++++++++++++++++++++-
 2 files changed, 134 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index ce031cf72288..9c71f024f9cc 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -856,6 +856,8 @@ enum nft_hash_types {
  * @NFTA_HASH_SEED: seed value (NLA_U32)
  * @NFTA_HASH_OFFSET: add this offset value to hash result (NLA_U32)
  * @NFTA_HASH_TYPE: hash operation (NLA_U32: nft_hash_types)
+ * @NFTA_HASH_SET_NAME: name of the map to lookup (NLA_STRING)
+ * @NFTA_HASH_SET_ID: id of the map (NLA_U32)
  */
 enum nft_hash_attributes {
 	NFTA_HASH_UNSPEC,
@@ -866,6 +868,8 @@ enum nft_hash_attributes {
 	NFTA_HASH_SEED,
 	NFTA_HASH_OFFSET,
 	NFTA_HASH_TYPE,
+	NFTA_HASH_SET_NAME,
+	NFTA_HASH_SET_ID,
 	__NFTA_HASH_MAX,
 };
 #define NFTA_HASH_MAX	(__NFTA_HASH_MAX - 1)
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index e235c17f1b8b..f0fc21f88775 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -25,6 +25,7 @@ struct nft_jhash {
 	u32			modulus;
 	u32			seed;
 	u32			offset;
+	struct nft_set		*map;
 };
 
 static void nft_jhash_eval(const struct nft_expr *expr,
@@ -35,14 +36,39 @@ static void nft_jhash_eval(const struct nft_expr *expr,
 	const void *data = &regs->data[priv->sreg];
 	u32 h;
 
-	h = reciprocal_scale(jhash(data, priv->len, priv->seed), priv->modulus);
+	h = reciprocal_scale(jhash(data, priv->len, priv->seed),
+			     priv->modulus);
+
 	regs->data[priv->dreg] = h + priv->offset;
 }
 
+static void nft_jhash_map_eval(const struct nft_expr *expr,
+			       struct nft_regs *regs,
+			       const struct nft_pktinfo *pkt)
+{
+	struct nft_jhash *priv = nft_expr_priv(expr);
+	const void *data = &regs->data[priv->sreg];
+	const struct nft_set *map = priv->map;
+	const struct nft_set_ext *ext;
+	u32 result;
+	bool found;
+
+	result = reciprocal_scale(jhash(data, priv->len, priv->seed),
+					priv->modulus) + priv->offset;
+
+	found = map->ops->lookup(nft_net(pkt), map, &result, &ext);
+	if (!found)
+		return;
+
+	nft_data_copy(&regs->data[priv->dreg],
+		      nft_set_ext_data(ext), map->dlen);
+}
+
 struct nft_symhash {
 	enum nft_registers      dreg:8;
 	u32			modulus;
 	u32			offset;
+	struct nft_set		*map;
 };
 
 static void nft_symhash_eval(const struct nft_expr *expr,
@@ -58,6 +84,28 @@ static void nft_symhash_eval(const struct nft_expr *expr,
 	regs->data[priv->dreg] = h + priv->offset;
 }
 
+static void nft_symhash_map_eval(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt)
+{
+	struct nft_symhash *priv = nft_expr_priv(expr);
+	struct sk_buff *skb = pkt->skb;
+	const struct nft_set *map = priv->map;
+	const struct nft_set_ext *ext;
+	u32 result;
+	bool found;
+
+	result = reciprocal_scale(__skb_get_hash_symmetric(skb),
+				  priv->modulus) + priv->offset;
+
+	found = map->ops->lookup(nft_net(pkt), map, &result, &ext);
+	if (!found)
+		return;
+
+	nft_data_copy(&regs->data[priv->dreg],
+		      nft_set_ext_data(ext), map->dlen);
+}
+
 static const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
 	[NFTA_HASH_SREG]	= { .type = NLA_U32 },
 	[NFTA_HASH_DREG]	= { .type = NLA_U32 },
@@ -66,6 +114,9 @@ static const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
 	[NFTA_HASH_SEED]	= { .type = NLA_U32 },
 	[NFTA_HASH_OFFSET]	= { .type = NLA_U32 },
 	[NFTA_HASH_TYPE]	= { .type = NLA_U32 },
+	[NFTA_HASH_SET_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_SET_MAXNAMELEN - 1 },
+	[NFTA_HASH_SET_ID]	= { .type = NLA_U32 },
 };
 
 static int nft_jhash_init(const struct nft_ctx *ctx,
@@ -115,6 +166,23 @@ static int nft_jhash_init(const struct nft_ctx *ctx,
 					   NFT_DATA_VALUE, sizeof(u32));
 }
 
+static int nft_jhash_map_init(const struct nft_ctx *ctx,
+			      const struct nft_expr *expr,
+			      const struct nlattr * const tb[])
+{
+	struct nft_jhash *priv = nft_expr_priv(expr);
+	u8 genmask = nft_genmask_next(ctx->net);
+
+	nft_jhash_init(ctx, expr, tb);
+	priv->map = nft_set_lookup_global(ctx->net, ctx->table,
+					  tb[NFTA_HASH_SET_NAME],
+					  tb[NFTA_HASH_SET_ID], genmask);
+	if (IS_ERR(priv->map))
+		return PTR_ERR(priv->map);
+
+	return 0;
+}
+
 static int nft_symhash_init(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nlattr * const tb[])
@@ -141,6 +209,23 @@ static int nft_symhash_init(const struct nft_ctx *ctx,
 					   NFT_DATA_VALUE, sizeof(u32));
 }
 
+static int nft_symhash_map_init(const struct nft_ctx *ctx,
+				const struct nft_expr *expr,
+				const struct nlattr * const tb[])
+{
+	struct nft_jhash *priv = nft_expr_priv(expr);
+	u8 genmask = nft_genmask_next(ctx->net);
+
+	nft_symhash_init(ctx, expr, tb);
+	priv->map = nft_set_lookup_global(ctx->net, ctx->table,
+					  tb[NFTA_HASH_SET_NAME],
+					  tb[NFTA_HASH_SET_ID], genmask);
+	if (IS_ERR(priv->map))
+		return PTR_ERR(priv->map);
+
+	return 0;
+}
+
 static int nft_jhash_dump(struct sk_buff *skb,
 			  const struct nft_expr *expr)
 {
@@ -168,6 +253,18 @@ static int nft_jhash_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_jhash_map_dump(struct sk_buff *skb,
+			       const struct nft_expr *expr)
+{
+	const struct nft_jhash *priv = nft_expr_priv(expr);
+
+	if (nft_jhash_dump(skb, expr) ||
+	    nla_put_string(skb, NFTA_HASH_SET_NAME, priv->map->name))
+		return -1;
+
+	return 0;
+}
+
 static int nft_symhash_dump(struct sk_buff *skb,
 			    const struct nft_expr *expr)
 {
@@ -188,6 +285,18 @@ static int nft_symhash_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_symhash_map_dump(struct sk_buff *skb,
+				const struct nft_expr *expr)
+{
+	const struct nft_symhash *priv = nft_expr_priv(expr);
+
+	if (nft_symhash_dump(skb, expr) ||
+	    nla_put_string(skb, NFTA_HASH_SET_NAME, priv->map->name))
+		return -1;
+
+	return 0;
+}
+
 static struct nft_expr_type nft_hash_type;
 static const struct nft_expr_ops nft_jhash_ops = {
 	.type		= &nft_hash_type,
@@ -197,6 +306,14 @@ static const struct nft_expr_ops nft_jhash_ops = {
 	.dump		= nft_jhash_dump,
 };
 
+static const struct nft_expr_ops nft_jhash_map_ops = {
+	.type		= &nft_hash_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_jhash)),
+	.eval		= nft_jhash_map_eval,
+	.init		= nft_jhash_map_init,
+	.dump		= nft_jhash_map_dump,
+};
+
 static const struct nft_expr_ops nft_symhash_ops = {
 	.type		= &nft_hash_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_symhash)),
@@ -205,6 +322,14 @@ static const struct nft_expr_ops nft_symhash_ops = {
 	.dump		= nft_symhash_dump,
 };
 
+static const struct nft_expr_ops nft_symhash_map_ops = {
+	.type		= &nft_hash_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_symhash)),
+	.eval		= nft_symhash_map_eval,
+	.init		= nft_symhash_map_init,
+	.dump		= nft_symhash_map_dump,
+};
+
 static const struct nft_expr_ops *
 nft_hash_select_ops(const struct nft_ctx *ctx,
 		    const struct nlattr * const tb[])
@@ -217,8 +342,12 @@ nft_hash_select_ops(const struct nft_ctx *ctx,
 	type = ntohl(nla_get_be32(tb[NFTA_HASH_TYPE]));
 	switch (type) {
 	case NFT_HASH_SYM:
+		if (tb[NFTA_HASH_SET_NAME])
+			return &nft_symhash_map_ops;
 		return &nft_symhash_ops;
 	case NFT_HASH_JENKINS:
+		if (tb[NFTA_HASH_SET_NAME])
+			return &nft_jhash_map_ops;
 		return &nft_jhash_ops;
 	default:
 		break;
-- 
2.11.0
