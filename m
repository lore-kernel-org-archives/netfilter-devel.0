From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer
Date: Fri, 10 Nov 2017 08:10:46 +0100
Message-ID: <20171110071046.6221-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51842 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750829AbdKJHK5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Nov 2017 02:10:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0E9CA10FB0B
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Nov 2017 08:10:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3036DA86F
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Nov 2017 08:10:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0076DA86F
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Nov 2017 08:10:53 +0100 (CET)
Received: from salvia.here (unknown [121.135.231.177])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 510A2403DF98
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Nov 2017 08:10:51 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows us to forward packets from the netdev family via neighbour
layer, so you don't need an explicit link-layer destination when using
this expression from rules.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |   4 ++
 net/netfilter/nft_fwd_netdev.c           | 114 ++++++++++++++++++++++++++++++-
 2 files changed, 117 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 871afa4871bf..dbea045bdc2d 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1190,10 +1190,14 @@ enum nft_dup_attributes {
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
index ce13a50b9189..4007387aaf9e 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -14,6 +14,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_dup_netdev.h>
+#include <net/neighbour.h>
 
 struct nft_fwd_netdev {
 	enum nft_registers	sreg_dev:8;
@@ -32,6 +33,8 @@ static void nft_fwd_netdev_eval(const struct nft_expr *expr,
 
 static const struct nla_policy nft_fwd_netdev_policy[NFTA_FWD_MAX + 1] = {
 	[NFTA_FWD_SREG_DEV]	= { .type = NLA_U32 },
+	[NFTA_FWD_SREG_ADDR]	= { .type = NLA_U32 },
+	[NFTA_FWD_NFPROTO]	= { .type = NLA_U32 },
 };
 
 static int nft_fwd_netdev_init(const struct nft_ctx *ctx,
@@ -62,7 +65,102 @@ static int nft_fwd_netdev_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+struct nft_fwd_neigh {
+	enum nft_registers	sreg_dev:8;
+	enum nft_registers	sreg_addr:8;
+	u8			neigh_table;
+};
+
+static void nft_fwd_neigh_eval(const struct nft_expr *expr,
+			      struct nft_regs *regs,
+			      const struct nft_pktinfo *pkt)
+{
+	struct nft_fwd_neigh *priv = nft_expr_priv(expr);
+	void *addr = &regs->data[priv->sreg_addr];
+	int oif = regs->data[priv->sreg_dev];
+	struct sk_buff *skb = pkt->skb;
+	struct net_device *dev;
+
+	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
+	if (dev == NULL)
+		return;
+
+	skb->dev = dev;
+	neigh_xmit(priv->neigh_table, dev, addr, skb);
+	regs->verdict.code = NF_STOLEN;
+}
+
+static int nft_fwd_neigh_init(const struct nft_ctx *ctx,
+			      const struct nft_expr *expr,
+			      const struct nlattr * const tb[])
+{
+	struct nft_fwd_neigh *priv = nft_expr_priv(expr);
+	unsigned int addr_len;
+	u8 nfproto;
+	int err;
+
+	priv->sreg_dev = nft_parse_register(tb[NFTA_FWD_SREG_DEV]);
+	priv->sreg_addr = nft_parse_register(tb[NFTA_FWD_SREG_ADDR]);
+	nfproto = ntohl(nla_get_be32(tb[NFTA_FWD_NFPROTO]));
+
+	switch (nfproto) {
+	case NFPROTO_IPV4:
+		addr_len = sizeof(__be32);
+		priv->neigh_table = NEIGH_ARP_TABLE;
+		break;
+	case NFPROTO_IPV6:
+		addr_len = sizeof(struct in6_addr);
+		priv->neigh_table = NEIGH_ND_TABLE;
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
+static int nft_fwd_neigh_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	struct nft_fwd_neigh *priv = nft_expr_priv(expr);
+	u32 nfproto;
+
+	if (nft_dump_register(skb, NFTA_FWD_SREG_DEV, priv->sreg_dev) ||
+	    nft_dump_register(skb, NFTA_FWD_SREG_ADDR, priv->sreg_addr))
+		goto nla_put_failure;
+
+	switch (priv->neigh_table) {
+	case NEIGH_ARP_TABLE:
+		nfproto = NFPROTO_IPV4;
+		break;
+	case NFPROTO_IPV6:
+		nfproto = NFPROTO_IPV6;
+		break;
+	default:
+		return 0;
+	}
+
+	if (nla_put_be32(skb, NFTA_FWD_NFPROTO, htonl(nfproto)))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
 static struct nft_expr_type nft_fwd_netdev_type;
+static const struct nft_expr_ops nft_fwd_neigh_ops = {
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
@@ -71,10 +169,24 @@ static const struct nft_expr_ops nft_fwd_netdev_ops = {
 	.dump		= nft_fwd_netdev_dump,
 };
 
+static const struct nft_expr_ops *
+nft_fwd_select_ops(const struct nft_ctx *ctx,
+		   const struct nlattr * const tb[])
+{
+	if (tb[NFTA_FWD_SREG_ADDR] &&
+	    tb[NFTA_FWD_SREG_DEV] &&
+	    tb[NFTA_FWD_NFPROTO])
+		return &nft_fwd_neigh_ops;
+	else if (tb[NFTA_FWD_SREG_DEV])
+		return &nft_fwd_netdev_ops;
+
+        return ERR_PTR(-EINVAL);
+}
+
 static struct nft_expr_type nft_fwd_netdev_type __read_mostly = {
 	.family		= NFPROTO_NETDEV,
 	.name		= "fwd",
-	.ops		= &nft_fwd_netdev_ops,
+	.select_ops	= &nft_fwd_select_ops,
 	.policy		= nft_fwd_netdev_policy,
 	.maxattr	= NFTA_FWD_MAX,
 	.owner		= THIS_MODULE,
-- 
2.11.0

