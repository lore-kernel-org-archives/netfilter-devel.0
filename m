From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/18] netfilter: nft_numgen: add map lookups for numgen random operations
Date: Wed, 23 May 2018 20:42:39 +0200
Message-ID: <20180523184254.22599-4-pablo@netfilter.org>
References: <20180523184254.22599-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523184254.22599-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Laura Garcia Liebana <nevola@gmail.com>

This patch uses the map lookup already included to be applied
for random number generation.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_numgen.c | 76 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 72 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 8a64db8f2e69..cdbc62a53933 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -166,18 +166,43 @@ struct nft_ng_random {
 	enum nft_registers      dreg:8;
 	u32			modulus;
 	u32			offset;
+	struct nft_set		*map;
 };
 
+static u32 nft_ng_random_gen(struct nft_ng_random *priv)
+{
+	struct rnd_state *state = this_cpu_ptr(&nft_numgen_prandom_state);
+
+	return reciprocal_scale(prandom_u32_state(state), priv->modulus) +
+	       priv->offset;
+}
+
 static void nft_ng_random_eval(const struct nft_expr *expr,
 			       struct nft_regs *regs,
 			       const struct nft_pktinfo *pkt)
 {
 	struct nft_ng_random *priv = nft_expr_priv(expr);
-	struct rnd_state *state = this_cpu_ptr(&nft_numgen_prandom_state);
-	u32 val;
 
-	val = reciprocal_scale(prandom_u32_state(state), priv->modulus);
-	regs->data[priv->dreg] = val + priv->offset;
+	regs->data[priv->dreg] = nft_ng_random_gen(priv);
+}
+
+static void nft_ng_random_map_eval(const struct nft_expr *expr,
+				   struct nft_regs *regs,
+				   const struct nft_pktinfo *pkt)
+{
+	struct nft_ng_random *priv = nft_expr_priv(expr);
+	const struct nft_set *map = priv->map;
+	const struct nft_set_ext *ext;
+	u32 result;
+	bool found;
+
+	result = nft_ng_random_gen(priv);
+	found = map->ops->lookup(nft_net(pkt), map, &result, &ext);
+	if (!found)
+		return;
+
+	nft_data_copy(&regs->data[priv->dreg],
+		      nft_set_ext_data(ext), map->dlen);
 }
 
 static int nft_ng_random_init(const struct nft_ctx *ctx,
@@ -204,6 +229,23 @@ static int nft_ng_random_init(const struct nft_ctx *ctx,
 					   NFT_DATA_VALUE, sizeof(u32));
 }
 
+static int nft_ng_random_map_init(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr,
+				  const struct nlattr * const tb[])
+{
+	struct nft_ng_random *priv = nft_expr_priv(expr);
+	u8 genmask = nft_genmask_next(ctx->net);
+
+	nft_ng_random_init(ctx, expr, tb);
+	priv->map = nft_set_lookup_global(ctx->net, ctx->table,
+					  tb[NFTA_NG_SET_NAME],
+					  tb[NFTA_NG_SET_ID], genmask);
+	if (IS_ERR(priv->map))
+		return PTR_ERR(priv->map);
+
+	return 0;
+}
+
 static int nft_ng_random_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_ng_random *priv = nft_expr_priv(expr);
@@ -212,6 +254,22 @@ static int nft_ng_random_dump(struct sk_buff *skb, const struct nft_expr *expr)
 			   priv->offset);
 }
 
+static int nft_ng_random_map_dump(struct sk_buff *skb,
+				  const struct nft_expr *expr)
+{
+	const struct nft_ng_random *priv = nft_expr_priv(expr);
+
+	if (nft_ng_dump(skb, priv->dreg, priv->modulus,
+			NFT_NG_RANDOM, priv->offset) ||
+	    nla_put_string(skb, NFTA_NG_SET_NAME, priv->map->name))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
 static struct nft_expr_type nft_ng_type;
 static const struct nft_expr_ops nft_ng_inc_ops = {
 	.type		= &nft_ng_type,
@@ -237,6 +295,14 @@ static const struct nft_expr_ops nft_ng_random_ops = {
 	.dump		= nft_ng_random_dump,
 };
 
+static const struct nft_expr_ops nft_ng_random_map_ops = {
+	.type		= &nft_ng_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ng_random)),
+	.eval		= nft_ng_random_map_eval,
+	.init		= nft_ng_random_map_init,
+	.dump		= nft_ng_random_map_dump,
+};
+
 static const struct nft_expr_ops *
 nft_ng_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 {
@@ -255,6 +321,8 @@ nft_ng_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 			return &nft_ng_inc_map_ops;
 		return &nft_ng_inc_ops;
 	case NFT_NG_RANDOM:
+		if (tb[NFTA_NG_SET_NAME])
+			return &nft_ng_random_map_ops;
 		return &nft_ng_random_ops;
 	}
 
-- 
2.11.0
