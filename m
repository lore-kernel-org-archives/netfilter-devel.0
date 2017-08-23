From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nf-next 3/3] netfilter: nft_limit: add stateful object type
Date: Wed, 23 Aug 2017 22:41:25 +0200
Message-ID: <20170823204125.31427-3-pablombg@gmail.com>
References: <20170823204125.31427-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35717 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754173AbdHWUmS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2017 16:42:18 -0400
Received: by mail-wm0-f67.google.com with SMTP id x79so709117wma.2
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2017 13:42:17 -0700 (PDT)
In-Reply-To: <20170823204125.31427-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Register a new limit stateful object type into the stateful object
infrastructure.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |   3 +-
 net/netfilter/nft_limit.c                | 118 ++++++++++++++++++++++++++++++-
 2 files changed, 119 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index dc7661c293b8..ca5c36876bac 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1278,7 +1278,8 @@ enum nft_ct_helper_attributes {
 #define NFT_OBJECT_COUNTER	1
 #define NFT_OBJECT_QUOTA	2
 #define NFT_OBJECT_CT_HELPER	3
-#define __NFT_OBJECT_MAX	4
+#define NFT_OBJECT_LIMIT	4
+#define __NFT_OBJECT_MAX	5
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index d66b4de5b07c..b6903df21fc4 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -226,14 +226,129 @@ static struct nft_expr_type nft_limit_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+static void nft_limit_obj_pkts_eval(struct nft_object *obj,
+				    struct nft_regs *regs,
+				    const struct nft_pktinfo *pkt)
+{
+	struct nft_limit_pkts *priv = nft_obj_data(obj);
+
+	if (nft_limit_eval(&priv->limit, priv->cost))
+		regs->verdict.code = NFT_BREAK;
+}
+
+static int nft_limit_obj_pkts_init(const struct nft_ctx *ctx,
+				   const struct nlattr * const tb[],
+				   struct nft_object *obj)
+{
+	struct nft_limit_pkts *priv = nft_obj_data(obj);
+	int err;
+
+	err = nft_limit_init(&priv->limit, tb);
+	if (err < 0)
+		return err;
+
+	priv->cost = div64_u64(priv->limit.nsecs, priv->limit.rate);
+	return 0;
+}
+
+static int nft_limit_obj_pkts_dump(struct sk_buff *skb,
+				   struct nft_object *obj,
+				   bool reset)
+{
+	const struct nft_limit_pkts *priv = nft_obj_data(obj);
+
+	return nft_limit_dump(skb, &priv->limit, NFT_LIMIT_PKTS);
+}
+
+static const struct nft_object_ops nft_limit_obj_pkts_ops = {
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_pkts)),
+	.init		= nft_limit_obj_pkts_init,
+	.eval		= nft_limit_obj_pkts_eval,
+	.dump		= nft_limit_obj_pkts_dump,
+};
+
+static void nft_limit_obj_bytes_eval(struct nft_object *obj,
+				     struct nft_regs *regs,
+				     const struct nft_pktinfo *pkt)
+{
+	struct nft_limit *priv = nft_obj_data(obj);
+	u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);
+
+	if (nft_limit_eval(priv, cost))
+		regs->verdict.code = NFT_BREAK;
+}
+
+static int nft_limit_obj_bytes_init(const struct nft_ctx *ctx,
+				    const struct nlattr * const tb[],
+				    struct nft_object *obj)
+{
+	struct nft_limit *priv = nft_obj_data(obj);
+
+	return nft_limit_init(priv, tb);
+}
+
+static int nft_limit_obj_bytes_dump(struct sk_buff *skb,
+				    struct nft_object *obj,
+				    bool reset)
+{
+	const struct nft_limit *priv = nft_obj_data(obj);
+
+	return nft_limit_dump(skb, priv, NFT_LIMIT_BYTES);
+}
+
+static const struct nft_object_ops nft_limit_obj_bytes_ops = {
+	.size		= sizeof(struct nft_limit),
+	.init		= nft_limit_obj_bytes_init,
+	.eval		= nft_limit_obj_bytes_eval,
+	.dump		= nft_limit_obj_bytes_dump,
+};
+
+static const struct nft_object_ops *
+nft_limit_obj_select_ops(const struct nft_ctx *ctx,
+			 const struct nlattr * const tb[])
+{
+	if (!tb[NFTA_LIMIT_TYPE])
+		return &nft_limit_obj_pkts_ops;
+
+	switch (ntohl(nla_get_be32(tb[NFTA_LIMIT_TYPE]))) {
+	case NFT_LIMIT_PKTS:
+		return &nft_limit_obj_pkts_ops;
+	case NFT_LIMIT_BYTES:
+		return &nft_limit_obj_bytes_ops;
+	}
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static struct nft_object_type nft_limit_obj __read_mostly = {
+	.select_ops	= nft_limit_obj_select_ops,
+	.type		= NFT_OBJECT_LIMIT,
+	.maxattr	= NFTA_LIMIT_MAX,
+	.policy		= nft_limit_policy,
+	.owner		= THIS_MODULE,
+};
+
 static int __init nft_limit_module_init(void)
 {
-	return nft_register_expr(&nft_limit_type);
+	int err;
+
+	err = nft_register_obj(&nft_limit_obj);
+	if (err < 0)
+		return err;
+
+	err = nft_register_expr(&nft_limit_type);
+	if (err < 0)
+		goto err1;
+
+	return 0;
+err1:
+	nft_unregister_obj(&nft_limit_obj);
+	return err;
 }
 
 static void __exit nft_limit_module_exit(void)
 {
 	nft_unregister_expr(&nft_limit_type);
+	nft_unregister_obj(&nft_limit_obj);
 }
 
 module_init(nft_limit_module_init);
@@ -242,3 +357,4 @@ module_exit(nft_limit_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_EXPR("limit");
+MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_LIMIT);
-- 
2.14.1

