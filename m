From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 26/33] Revert "netfilter: nft_hash: add map lookups for hashing operations"
Date: Tue, 29 Jan 2019 00:57:43 +0100
Message-ID: <20190128235750.18412-27-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Laura Garcia Liebana <nevola@gmail.com>

A better way to implement this from userspace has been found without
specific code in the kernel side, revert this.

Fixes: b9ccc07e3f31 ("netfilter: nft_hash: add map lookups for hashing operations")
Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |   4 +-
 net/netfilter/nft_hash.c                 | 121 -------------------------------
 2 files changed, 2 insertions(+), 123 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 0ba8f48bdf0b..030302893d96 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -877,8 +877,8 @@ enum nft_hash_attributes {
 	NFTA_HASH_SEED,
 	NFTA_HASH_OFFSET,
 	NFTA_HASH_TYPE,
-	NFTA_HASH_SET_NAME,
-	NFTA_HASH_SET_ID,
+	NFTA_HASH_SET_NAME,	/* deprecated */
+	NFTA_HASH_SET_ID,	/* deprecated */
 	__NFTA_HASH_MAX,
 };
 #define NFTA_HASH_MAX	(__NFTA_HASH_MAX - 1)
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index c2d237144f74..ea658e6c53e3 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -25,7 +25,6 @@ struct nft_jhash {
 	u32			modulus;
 	u32			seed;
 	u32			offset;
-	struct nft_set		*map;
 };
 
 static void nft_jhash_eval(const struct nft_expr *expr,
@@ -42,33 +41,10 @@ static void nft_jhash_eval(const struct nft_expr *expr,
 	regs->data[priv->dreg] = h + priv->offset;
 }
 
-static void nft_jhash_map_eval(const struct nft_expr *expr,
-			       struct nft_regs *regs,
-			       const struct nft_pktinfo *pkt)
-{
-	struct nft_jhash *priv = nft_expr_priv(expr);
-	const void *data = &regs->data[priv->sreg];
-	const struct nft_set *map = priv->map;
-	const struct nft_set_ext *ext;
-	u32 result;
-	bool found;
-
-	result = reciprocal_scale(jhash(data, priv->len, priv->seed),
-					priv->modulus) + priv->offset;
-
-	found = map->ops->lookup(nft_net(pkt), map, &result, &ext);
-	if (!found)
-		return;
-
-	nft_data_copy(&regs->data[priv->dreg],
-		      nft_set_ext_data(ext), map->dlen);
-}
-
 struct nft_symhash {
 	enum nft_registers      dreg:8;
 	u32			modulus;
 	u32			offset;
-	struct nft_set		*map;
 };
 
 static void nft_symhash_eval(const struct nft_expr *expr,
@@ -84,28 +60,6 @@ static void nft_symhash_eval(const struct nft_expr *expr,
 	regs->data[priv->dreg] = h + priv->offset;
 }
 
-static void nft_symhash_map_eval(const struct nft_expr *expr,
-				 struct nft_regs *regs,
-				 const struct nft_pktinfo *pkt)
-{
-	struct nft_symhash *priv = nft_expr_priv(expr);
-	struct sk_buff *skb = pkt->skb;
-	const struct nft_set *map = priv->map;
-	const struct nft_set_ext *ext;
-	u32 result;
-	bool found;
-
-	result = reciprocal_scale(__skb_get_hash_symmetric(skb),
-				  priv->modulus) + priv->offset;
-
-	found = map->ops->lookup(nft_net(pkt), map, &result, &ext);
-	if (!found)
-		return;
-
-	nft_data_copy(&regs->data[priv->dreg],
-		      nft_set_ext_data(ext), map->dlen);
-}
-
 static const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
 	[NFTA_HASH_SREG]	= { .type = NLA_U32 },
 	[NFTA_HASH_DREG]	= { .type = NLA_U32 },
@@ -114,9 +68,6 @@ static const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
 	[NFTA_HASH_SEED]	= { .type = NLA_U32 },
 	[NFTA_HASH_OFFSET]	= { .type = NLA_U32 },
 	[NFTA_HASH_TYPE]	= { .type = NLA_U32 },
-	[NFTA_HASH_SET_NAME]	= { .type = NLA_STRING,
-				    .len = NFT_SET_MAXNAMELEN - 1 },
-	[NFTA_HASH_SET_ID]	= { .type = NLA_U32 },
 };
 
 static int nft_jhash_init(const struct nft_ctx *ctx,
@@ -166,20 +117,6 @@ static int nft_jhash_init(const struct nft_ctx *ctx,
 					   NFT_DATA_VALUE, sizeof(u32));
 }
 
-static int nft_jhash_map_init(const struct nft_ctx *ctx,
-			      const struct nft_expr *expr,
-			      const struct nlattr * const tb[])
-{
-	struct nft_jhash *priv = nft_expr_priv(expr);
-	u8 genmask = nft_genmask_next(ctx->net);
-
-	nft_jhash_init(ctx, expr, tb);
-	priv->map = nft_set_lookup_global(ctx->net, ctx->table,
-					  tb[NFTA_HASH_SET_NAME],
-					  tb[NFTA_HASH_SET_ID], genmask);
-	return PTR_ERR_OR_ZERO(priv->map);
-}
-
 static int nft_symhash_init(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nlattr * const tb[])
@@ -206,20 +143,6 @@ static int nft_symhash_init(const struct nft_ctx *ctx,
 					   NFT_DATA_VALUE, sizeof(u32));
 }
 
-static int nft_symhash_map_init(const struct nft_ctx *ctx,
-				const struct nft_expr *expr,
-				const struct nlattr * const tb[])
-{
-	struct nft_jhash *priv = nft_expr_priv(expr);
-	u8 genmask = nft_genmask_next(ctx->net);
-
-	nft_symhash_init(ctx, expr, tb);
-	priv->map = nft_set_lookup_global(ctx->net, ctx->table,
-					  tb[NFTA_HASH_SET_NAME],
-					  tb[NFTA_HASH_SET_ID], genmask);
-	return PTR_ERR_OR_ZERO(priv->map);
-}
-
 static int nft_jhash_dump(struct sk_buff *skb,
 			  const struct nft_expr *expr)
 {
@@ -247,18 +170,6 @@ static int nft_jhash_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static int nft_jhash_map_dump(struct sk_buff *skb,
-			       const struct nft_expr *expr)
-{
-	const struct nft_jhash *priv = nft_expr_priv(expr);
-
-	if (nft_jhash_dump(skb, expr) ||
-	    nla_put_string(skb, NFTA_HASH_SET_NAME, priv->map->name))
-		return -1;
-
-	return 0;
-}
-
 static int nft_symhash_dump(struct sk_buff *skb,
 			    const struct nft_expr *expr)
 {
@@ -279,18 +190,6 @@ static int nft_symhash_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static int nft_symhash_map_dump(struct sk_buff *skb,
-				const struct nft_expr *expr)
-{
-	const struct nft_symhash *priv = nft_expr_priv(expr);
-
-	if (nft_symhash_dump(skb, expr) ||
-	    nla_put_string(skb, NFTA_HASH_SET_NAME, priv->map->name))
-		return -1;
-
-	return 0;
-}
-
 static struct nft_expr_type nft_hash_type;
 static const struct nft_expr_ops nft_jhash_ops = {
 	.type		= &nft_hash_type,
@@ -300,14 +199,6 @@ static const struct nft_expr_ops nft_jhash_ops = {
 	.dump		= nft_jhash_dump,
 };
 
-static const struct nft_expr_ops nft_jhash_map_ops = {
-	.type		= &nft_hash_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_jhash)),
-	.eval		= nft_jhash_map_eval,
-	.init		= nft_jhash_map_init,
-	.dump		= nft_jhash_map_dump,
-};
-
 static const struct nft_expr_ops nft_symhash_ops = {
 	.type		= &nft_hash_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_symhash)),
@@ -316,14 +207,6 @@ static const struct nft_expr_ops nft_symhash_ops = {
 	.dump		= nft_symhash_dump,
 };
 
-static const struct nft_expr_ops nft_symhash_map_ops = {
-	.type		= &nft_hash_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_symhash)),
-	.eval		= nft_symhash_map_eval,
-	.init		= nft_symhash_map_init,
-	.dump		= nft_symhash_map_dump,
-};
-
 static const struct nft_expr_ops *
 nft_hash_select_ops(const struct nft_ctx *ctx,
 		    const struct nlattr * const tb[])
@@ -336,12 +219,8 @@ nft_hash_select_ops(const struct nft_ctx *ctx,
 	type = ntohl(nla_get_be32(tb[NFTA_HASH_TYPE]));
 	switch (type) {
 	case NFT_HASH_SYM:
-		if (tb[NFTA_HASH_SET_NAME])
-			return &nft_symhash_map_ops;
 		return &nft_symhash_ops;
 	case NFT_HASH_JENKINS:
-		if (tb[NFTA_HASH_SET_NAME])
-			return &nft_jhash_map_ops;
 		return &nft_jhash_ops;
 	default:
 		break;
-- 
2.11.0
