From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 44/51] netfilter: nft_numgen: add map lookups for numgen statements
Date: Mon,  7 May 2018 00:47:02 +0200
Message-ID: <20180506224709.29100-45-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Laura Garcia Liebana <nevola@gmail.com>

This patch includes a new attribute in the numgen structure to allow
the lookup of an element based on the number generator as a key.

For this purpose, different ops have been included to extend the
current numgen inc functions.

Currently, only supported for numgen incremental operations, but
it will be supported for random in a follow-up patch.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  4 ++
 net/netfilter/nft_numgen.c               | 85 ++++++++++++++++++++++++++++++--
 2 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 6a3d653d5b27..5a5551a580f7 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1450,6 +1450,8 @@ enum nft_trace_types {
  * @NFTA_NG_MODULUS: maximum counter value (NLA_U32)
  * @NFTA_NG_TYPE: operation type (NLA_U32)
  * @NFTA_NG_OFFSET: offset to be added to the counter (NLA_U32)
+ * @NFTA_NG_SET_NAME: name of the map to lookup (NLA_STRING)
+ * @NFTA_NG_SET_ID: id of the map (NLA_U32)
  */
 enum nft_ng_attributes {
 	NFTA_NG_UNSPEC,
@@ -1457,6 +1459,8 @@ enum nft_ng_attributes {
 	NFTA_NG_MODULUS,
 	NFTA_NG_TYPE,
 	NFTA_NG_OFFSET,
+	NFTA_NG_SET_NAME,
+	NFTA_NG_SET_ID,
 	__NFTA_NG_MAX
 };
 #define NFTA_NG_MAX	(__NFTA_NG_MAX - 1)
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 5a3a52c71545..8a64db8f2e69 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -24,13 +24,11 @@ struct nft_ng_inc {
 	u32			modulus;
 	atomic_t		counter;
 	u32			offset;
+	struct nft_set		*map;
 };
 
-static void nft_ng_inc_eval(const struct nft_expr *expr,
-			    struct nft_regs *regs,
-			    const struct nft_pktinfo *pkt)
+static u32 nft_ng_inc_gen(struct nft_ng_inc *priv)
 {
-	struct nft_ng_inc *priv = nft_expr_priv(expr);
 	u32 nval, oval;
 
 	do {
@@ -38,7 +36,36 @@ static void nft_ng_inc_eval(const struct nft_expr *expr,
 		nval = (oval + 1 < priv->modulus) ? oval + 1 : 0;
 	} while (atomic_cmpxchg(&priv->counter, oval, nval) != oval);
 
-	regs->data[priv->dreg] = nval + priv->offset;
+	return nval + priv->offset;
+}
+
+static void nft_ng_inc_eval(const struct nft_expr *expr,
+			    struct nft_regs *regs,
+			    const struct nft_pktinfo *pkt)
+{
+	struct nft_ng_inc *priv = nft_expr_priv(expr);
+
+	regs->data[priv->dreg] = nft_ng_inc_gen(priv);
+}
+
+static void nft_ng_inc_map_eval(const struct nft_expr *expr,
+				struct nft_regs *regs,
+				const struct nft_pktinfo *pkt)
+{
+	struct nft_ng_inc *priv = nft_expr_priv(expr);
+	const struct nft_set *map = priv->map;
+	const struct nft_set_ext *ext;
+	u32 result;
+	bool found;
+
+	result = nft_ng_inc_gen(priv);
+	found = map->ops->lookup(nft_net(pkt), map, &result, &ext);
+
+	if (!found)
+		return;
+
+	nft_data_copy(&regs->data[priv->dreg],
+		      nft_set_ext_data(ext), map->dlen);
 }
 
 static const struct nla_policy nft_ng_policy[NFTA_NG_MAX + 1] = {
@@ -46,6 +73,9 @@ static const struct nla_policy nft_ng_policy[NFTA_NG_MAX + 1] = {
 	[NFTA_NG_MODULUS]	= { .type = NLA_U32 },
 	[NFTA_NG_TYPE]		= { .type = NLA_U32 },
 	[NFTA_NG_OFFSET]	= { .type = NLA_U32 },
+	[NFTA_NG_SET_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_SET_MAXNAMELEN - 1 },
+	[NFTA_NG_SET_ID]	= { .type = NLA_U32 },
 };
 
 static int nft_ng_inc_init(const struct nft_ctx *ctx,
@@ -71,6 +101,25 @@ static int nft_ng_inc_init(const struct nft_ctx *ctx,
 					   NFT_DATA_VALUE, sizeof(u32));
 }
 
+static int nft_ng_inc_map_init(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nlattr * const tb[])
+{
+	struct nft_ng_inc *priv = nft_expr_priv(expr);
+	u8 genmask = nft_genmask_next(ctx->net);
+
+	nft_ng_inc_init(ctx, expr, tb);
+
+	priv->map = nft_set_lookup_global(ctx->net, ctx->table,
+					  tb[NFTA_NG_SET_NAME],
+					  tb[NFTA_NG_SET_ID], genmask);
+
+	if (IS_ERR(priv->map))
+		return PTR_ERR(priv->map);
+
+	return 0;
+}
+
 static int nft_ng_dump(struct sk_buff *skb, enum nft_registers dreg,
 		       u32 modulus, enum nft_ng_types type, u32 offset)
 {
@@ -97,6 +146,22 @@ static int nft_ng_inc_dump(struct sk_buff *skb, const struct nft_expr *expr)
 			   priv->offset);
 }
 
+static int nft_ng_inc_map_dump(struct sk_buff *skb,
+			       const struct nft_expr *expr)
+{
+	const struct nft_ng_inc *priv = nft_expr_priv(expr);
+
+	if (nft_ng_dump(skb, priv->dreg, priv->modulus,
+			NFT_NG_INCREMENTAL, priv->offset) ||
+	    nla_put_string(skb, NFTA_NG_SET_NAME, priv->map->name))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
 struct nft_ng_random {
 	enum nft_registers      dreg:8;
 	u32			modulus;
@@ -156,6 +221,14 @@ static const struct nft_expr_ops nft_ng_inc_ops = {
 	.dump		= nft_ng_inc_dump,
 };
 
+static const struct nft_expr_ops nft_ng_inc_map_ops = {
+	.type		= &nft_ng_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ng_inc)),
+	.eval		= nft_ng_inc_map_eval,
+	.init		= nft_ng_inc_map_init,
+	.dump		= nft_ng_inc_map_dump,
+};
+
 static const struct nft_expr_ops nft_ng_random_ops = {
 	.type		= &nft_ng_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ng_random)),
@@ -178,6 +251,8 @@ nft_ng_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 
 	switch (type) {
 	case NFT_NG_INCREMENTAL:
+		if (tb[NFTA_NG_SET_NAME])
+			return &nft_ng_inc_map_ops;
 		return &nft_ng_inc_ops;
 	case NFT_NG_RANDOM:
 		return &nft_ng_random_ops;
-- 
2.11.0
