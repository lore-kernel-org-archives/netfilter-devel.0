From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 16/21] netfilter: nf_tables: match on tunnel metadata
Date: Sun,  5 Aug 2018 23:21:36 +0200
Message-ID: <20180805212141.3033-17-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch allows us to match on the tunnel metadata that is available
of the packet. We can use this to validate if the packet comes from/goes
to tunnel and the corresponding tunnel ID.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  15 +++++
 net/netfilter/nft_tunnel.c               | 112 ++++++++++++++++++++++++++++++-
 2 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 3ee1198eeac1..357862d948de 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1647,4 +1647,19 @@ enum nft_tunnel_key_attributes {
 };
 #define NFTA_TUNNEL_KEY_MAX	(__NFTA_TUNNEL_KEY_MAX - 1)
 
+enum nft_tunnel_keys {
+	NFT_TUNNEL_PATH,
+	NFT_TUNNEL_ID,
+	__NFT_TUNNEL_MAX
+};
+#define NFT_TUNNEL_MAX	(__NFT_TUNNEL_MAX - 1)
+
+enum nft_tunnel_attributes {
+	NFTA_TUNNEL_UNSPEC,
+	NFTA_TUNNEL_KEY,
+	NFTA_TUNNEL_DREG,
+	__NFTA_TUNNEL_MAX
+};
+#define NFTA_TUNNEL_MAX	(__NFTA_TUNNEL_MAX - 1)
+
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 715613d99c20..9332d7933dd5 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -12,6 +12,104 @@
 #include <net/vxlan.h>
 #include <net/erspan.h>
 
+struct nft_tunnel {
+	enum nft_tunnel_keys	key:8;
+	enum nft_registers	dreg:8;
+};
+
+static void nft_tunnel_get_eval(const struct nft_expr *expr,
+				struct nft_regs *regs,
+				const struct nft_pktinfo *pkt)
+{
+	const struct nft_tunnel *priv = nft_expr_priv(expr);
+	u32 *dest = &regs->data[priv->dreg];
+	struct ip_tunnel_info *tun_info;
+
+	tun_info = skb_tunnel_info(pkt->skb);
+
+	switch (priv->key) {
+	case NFT_TUNNEL_PATH:
+		nft_reg_store8(dest, !!tun_info);
+		break;
+	case NFT_TUNNEL_ID:
+		if (!tun_info) {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
+		*dest = ntohl(tunnel_id_to_key32(tun_info->key.tun_id));
+		break;
+	default:
+		WARN_ON(1);
+		regs->verdict.code = NFT_BREAK;
+	}
+}
+
+static const struct nla_policy nft_tunnel_policy[NFTA_TUNNEL_MAX + 1] = {
+	[NFTA_TUNNEL_KEY]	= { .type = NLA_U32 },
+	[NFTA_TUNNEL_DREG]	= { .type = NLA_U32 },
+};
+
+static int nft_tunnel_get_init(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nlattr * const tb[])
+{
+	struct nft_tunnel *priv = nft_expr_priv(expr);
+	u32 len;
+
+	if (!tb[NFTA_TUNNEL_KEY] &&
+	    !tb[NFTA_TUNNEL_DREG])
+		return -EINVAL;
+
+	priv->key = ntohl(nla_get_be32(tb[NFTA_TUNNEL_KEY]));
+	switch (priv->key) {
+	case NFT_TUNNEL_PATH:
+		len = sizeof(u8);
+		break;
+	case NFT_TUNNEL_ID:
+		len = sizeof(u32);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	priv->dreg = nft_parse_register(tb[NFTA_TUNNEL_DREG]);
+
+	return nft_validate_register_store(ctx, priv->dreg, NULL,
+					   NFT_DATA_VALUE, len);
+}
+
+static int nft_tunnel_get_dump(struct sk_buff *skb,
+			       const struct nft_expr *expr)
+{
+	const struct nft_tunnel *priv = nft_expr_priv(expr);
+
+	if (nla_put_be32(skb, NFTA_TUNNEL_KEY, htonl(priv->key)))
+		goto nla_put_failure;
+	if (nft_dump_register(skb, NFTA_TUNNEL_DREG, priv->dreg))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nft_expr_type nft_tunnel_type;
+static const struct nft_expr_ops nft_tunnel_get_ops = {
+	.type		= &nft_tunnel_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_tunnel)),
+	.eval		= nft_tunnel_get_eval,
+	.init		= nft_tunnel_get_init,
+	.dump		= nft_tunnel_get_dump,
+};
+
+static struct nft_expr_type nft_tunnel_type __read_mostly = {
+	.name		= "tunnel",
+	.ops		= &nft_tunnel_get_ops,
+	.policy		= nft_tunnel_policy,
+	.maxattr	= NFTA_TUNNEL_MAX,
+	.owner		= THIS_MODULE,
+};
+
 struct nft_tunnel_opts {
 	union {
 		struct vxlan_metadata	vxlan;
@@ -442,12 +540,23 @@ static struct nft_object_type nft_tunnel_obj_type __read_mostly = {
 
 static int __init nft_tunnel_module_init(void)
 {
-	return nft_register_obj(&nft_tunnel_obj_type);
+	int err;
+
+	err = nft_register_expr(&nft_tunnel_type);
+	if (err < 0)
+		return err;
+
+	err = nft_register_obj(&nft_tunnel_obj_type);
+	if (err < 0)
+		nft_unregister_expr(&nft_tunnel_type);
+
+	return err;
 }
 
 static void __exit nft_tunnel_module_exit(void)
 {
 	nft_unregister_obj(&nft_tunnel_obj_type);
+	nft_unregister_expr(&nft_tunnel_type);
 }
 
 module_init(nft_tunnel_module_init);
@@ -455,4 +564,5 @@ module_exit(nft_tunnel_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_ALIAS_NFT_EXPR("tunnel");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_TUNNEL);
-- 
2.11.0
