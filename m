From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/20] netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer
Date: Sat,  2 Jun 2018 02:22:57 +0200
Message-ID: <20180602002259.4024-19-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This allows us to forward packets from the netdev family via neighbour
layer, so you don't need an explicit link-layer destination when using
this expression from rules. The ttl/hop_limit field is decremented.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |   4 +
 net/netfilter/nft_fwd_netdev.c           | 146 ++++++++++++++++++++++++++++++-
 2 files changed, 149 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 5c7eb9b9f6d6..a089af092a29 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1260,10 +1260,14 @@ enum nft_dup_attributes {
  * enum nft_fwd_attributes - nf_tables fwd expression netlink attributes
  *
  * @NFTA_FWD_SREG_DEV: source register of output interface (NLA_U32: nft_register)
+ * @NFTA_FWD_SREG_ADDR: source register of destination address (NLA_U32: nft_register)
+ * @NFTA_FWD_NFPROTO: layer 3 family of source register address (NLA_U32: enum nfproto)
  */
 enum nft_fwd_attributes {
 	NFTA_FWD_UNSPEC,
 	NFTA_FWD_SREG_DEV,
+	NFTA_FWD_SREG_ADDR,
+	NFTA_FWD_NFPROTO,
 	__NFTA_FWD_MAX
 };
 #define NFTA_FWD_MAX	(__NFTA_FWD_MAX - 1)
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index ce13a50b9189..8abb9891cdf2 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -12,8 +12,12 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_dup_netdev.h>
+#include <net/neighbour.h>
+#include <net/ip.h>
 
 struct nft_fwd_netdev {
 	enum nft_registers	sreg_dev:8;
@@ -32,6 +36,8 @@ static void nft_fwd_netdev_eval(const struct nft_expr *expr,
 
 static const struct nla_policy nft_fwd_netdev_policy[NFTA_FWD_MAX + 1] = {
 	[NFTA_FWD_SREG_DEV]	= { .type = NLA_U32 },
+	[NFTA_FWD_SREG_ADDR]	= { .type = NLA_U32 },
+	[NFTA_FWD_NFPROTO]	= { .type = NLA_U32 },
 };
 
 static int nft_fwd_netdev_init(const struct nft_ctx *ctx,
@@ -62,7 +68,133 @@ static int nft_fwd_netdev_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+struct nft_fwd_neigh {
+	enum nft_registers	sreg_dev:8;
+	enum nft_registers	sreg_addr:8;
+	u8			nfproto;
+};
+
+static void nft_fwd_neigh_eval(const struct nft_expr *expr,
+			      struct nft_regs *regs,
+			      const struct nft_pktinfo *pkt)
+{
+	struct nft_fwd_neigh *priv = nft_expr_priv(expr);
+	void *addr = &regs->data[priv->sreg_addr];
+	int oif = regs->data[priv->sreg_dev];
+	unsigned int verdict = NF_STOLEN;
+	struct sk_buff *skb = pkt->skb;
+	struct net_device *dev;
+	int neigh_table;
+
+	switch (priv->nfproto) {
+	case NFPROTO_IPV4: {
+		struct iphdr *iph;
+
+		if (skb->protocol != htons(ETH_P_IP)) {
+			verdict = NFT_BREAK;
+			goto out;
+		}
+		if (skb_try_make_writable(skb, sizeof(*iph))) {
+			verdict = NF_DROP;
+			goto out;
+		}
+		iph = ip_hdr(skb);
+		ip_decrease_ttl(iph);
+		neigh_table = NEIGH_ARP_TABLE;
+		break;
+		}
+	case NFPROTO_IPV6: {
+		struct ipv6hdr *ip6h;
+
+		if (skb->protocol != htons(ETH_P_IPV6)) {
+			verdict = NFT_BREAK;
+			goto out;
+		}
+		if (skb_try_make_writable(skb, sizeof(*ip6h))) {
+			verdict = NF_DROP;
+			goto out;
+		}
+		ip6h = ipv6_hdr(skb);
+		ip6h->hop_limit--;
+		neigh_table = NEIGH_ND_TABLE;
+		break;
+		}
+	default:
+		verdict = NFT_BREAK;
+		goto out;
+	}
+
+	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
+	if (dev == NULL)
+		return;
+
+	skb->dev = dev;
+	neigh_xmit(neigh_table, dev, addr, skb);
+out:
+	regs->verdict.code = verdict;
+}
+
+static int nft_fwd_neigh_init(const struct nft_ctx *ctx,
+			      const struct nft_expr *expr,
+			      const struct nlattr * const tb[])
+{
+	struct nft_fwd_neigh *priv = nft_expr_priv(expr);
+	unsigned int addr_len;
+	int err;
+
+	if (!tb[NFTA_FWD_SREG_DEV] ||
+	    !tb[NFTA_FWD_SREG_ADDR] ||
+	    !tb[NFTA_FWD_NFPROTO])
+		return -EINVAL;
+
+	priv->sreg_dev = nft_parse_register(tb[NFTA_FWD_SREG_DEV]);
+	priv->sreg_addr = nft_parse_register(tb[NFTA_FWD_SREG_ADDR]);
+	priv->nfproto = ntohl(nla_get_be32(tb[NFTA_FWD_NFPROTO]));
+
+	switch (priv->nfproto) {
+	case NFPROTO_IPV4:
+		addr_len = sizeof(struct in_addr);
+		break;
+	case NFPROTO_IPV6:
+		addr_len = sizeof(struct in6_addr);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	err = nft_validate_register_load(priv->sreg_dev, sizeof(int));
+	if (err < 0)
+		return err;
+
+	return nft_validate_register_load(priv->sreg_addr, addr_len);
+}
+
+static const struct nft_expr_ops nft_fwd_netdev_ingress_ops;
+
+static int nft_fwd_neigh_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	struct nft_fwd_neigh *priv = nft_expr_priv(expr);
+
+	if (nft_dump_register(skb, NFTA_FWD_SREG_DEV, priv->sreg_dev) ||
+	    nft_dump_register(skb, NFTA_FWD_SREG_ADDR, priv->sreg_addr) ||
+	    nla_put_be32(skb, NFTA_FWD_NFPROTO, htonl(priv->nfproto)))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
 static struct nft_expr_type nft_fwd_netdev_type;
+static const struct nft_expr_ops nft_fwd_neigh_netdev_ops = {
+	.type		= &nft_fwd_netdev_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_fwd_neigh)),
+	.eval		= nft_fwd_neigh_eval,
+	.init		= nft_fwd_neigh_init,
+	.dump		= nft_fwd_neigh_dump,
+};
+
 static const struct nft_expr_ops nft_fwd_netdev_ops = {
 	.type		= &nft_fwd_netdev_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_fwd_netdev)),
@@ -71,10 +203,22 @@ static const struct nft_expr_ops nft_fwd_netdev_ops = {
 	.dump		= nft_fwd_netdev_dump,
 };
 
+static const struct nft_expr_ops *
+nft_fwd_select_ops(const struct nft_ctx *ctx,
+		   const struct nlattr * const tb[])
+{
+	if (tb[NFTA_FWD_SREG_ADDR])
+		return &nft_fwd_neigh_netdev_ops;
+	if (tb[NFTA_FWD_SREG_DEV])
+		return &nft_fwd_netdev_ops;
+
+        return ERR_PTR(-EOPNOTSUPP);
+}
+
 static struct nft_expr_type nft_fwd_netdev_type __read_mostly = {
 	.family		= NFPROTO_NETDEV,
 	.name		= "fwd",
-	.ops		= &nft_fwd_netdev_ops,
+	.select_ops	= nft_fwd_select_ops,
 	.policy		= nft_fwd_netdev_policy,
 	.maxattr	= NFTA_FWD_MAX,
 	.owner		= THIS_MODULE,
-- 
2.11.0
