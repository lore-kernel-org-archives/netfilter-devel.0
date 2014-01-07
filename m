From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH netfilter: nft] netfilter: nf_tables Add set op to nft_ct module
Date: Tue,  7 Jan 2014 16:15:19 +0100
Message-ID: <1389107719-24280-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:52883 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaAGPP1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:15:27 -0500
Received: by mail-ee0-f51.google.com with SMTP id b15so140213eek.10
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jan 2014 07:15:26 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

This patch adds kernel support for setting properties of tracked connections.
Currently, only connmark is supported. One use-case for this feature is to
provide the same functionality as -j CONNMARK --save-mark in iptables.

Some restructuring was needed to implement the set op. The new structure follows
that of nft_meta.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/nft_ct.c                   | 161 +++++++++++++++++++++++++------
 2 files changed, 132 insertions(+), 31 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index aa86a152..ead57b1 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -605,12 +605,14 @@ enum nft_ct_keys {
  * @NFTA_CT_DREG: destination register (NLA_U32)
  * @NFTA_CT_KEY: conntrack data item to load (NLA_U32: nft_ct_keys)
  * @NFTA_CT_DIRECTION: direction in case of directional keys (NLA_U8)
+ * @NFTA_CT_SREG: source register (NLA_U32)
  */
 enum nft_ct_attributes {
 	NFTA_CT_UNSPEC,
 	NFTA_CT_DREG,
 	NFTA_CT_KEY,
 	NFTA_CT_DIRECTION,
+	NFTA_CT_SREG,
 	__NFTA_CT_MAX
 };
 #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 955f4e6..814c4fa 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -18,17 +18,21 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 
 struct nft_ct {
 	enum nft_ct_keys	key:8;
 	enum ip_conntrack_dir	dir:8;
-	enum nft_registers	dreg:8;
+	union{
+		enum nft_registers	dreg:8;
+		enum nft_registers	sreg:8;
+	};
 	uint8_t			family;
 };
 
-static void nft_ct_eval(const struct nft_expr *expr,
-			struct nft_data data[NFT_REG_MAX + 1],
-			const struct nft_pktinfo *pkt)
+static void nft_ct_get_eval(const struct nft_expr *expr,
+			    struct nft_data data[NFT_REG_MAX + 1],
+			    const struct nft_pktinfo *pkt)
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
 	struct nft_data *dest = &data[priv->dreg];
@@ -123,24 +127,43 @@ err:
 	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
 
+static void nft_ct_set_eval(const struct nft_expr *expr,
+			    struct nft_data data[NFT_REG_MAX + 1],
+			    const struct nft_pktinfo *pkt)
+{
+	const struct nft_ct *priv = nft_expr_priv(expr);
+	struct sk_buff *skb = pkt->skb;
+	u32 value = data[priv->sreg].data[0];
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+
+	if (ct == NULL)
+		return;
+
+	switch (priv->key) {
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	case NFT_CT_MARK:
+		ct->mark = value;
+		nf_conntrack_event_cache(IPCT_MARK, ct);
+		break;
+#endif
+	}
+}
+
 static const struct nla_policy nft_ct_policy[NFTA_CT_MAX + 1] = {
 	[NFTA_CT_DREG]		= { .type = NLA_U32 },
 	[NFTA_CT_KEY]		= { .type = NLA_U32 },
 	[NFTA_CT_DIRECTION]	= { .type = NLA_U8 },
+	[NFTA_CT_SREG]		= { .type = NLA_U32 },
 };
 
-static int nft_ct_init(const struct nft_ctx *ctx,
-		       const struct nft_expr *expr,
-		       const struct nlattr * const tb[])
+static int nft_ct_init_validate_get(const struct nft_expr *expr,
+				    const struct nlattr * const tb[])
 {
 	struct nft_ct *priv = nft_expr_priv(expr);
-	int err;
-
-	if (tb[NFTA_CT_DREG] == NULL ||
-	    tb[NFTA_CT_KEY] == NULL)
-		return -EINVAL;
 
-	priv->key = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
 	if (tb[NFTA_CT_DIRECTION] != NULL) {
 		priv->dir = nla_get_u8(tb[NFTA_CT_DIRECTION]);
 		switch (priv->dir) {
@@ -179,24 +202,56 @@ static int nft_ct_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	err = nf_ct_l3proto_try_module_get(ctx->afi->family);
-	if (err < 0)
-		return err;
+	return 0;
+}
+
+static int nft_ct_init_validate_set(uint32_t key) {
+	switch (key) {
+	case NFT_CT_MARK:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int nft_ct_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
+		       const struct nlattr * const tb[])
+{
+	struct nft_ct *priv = nft_expr_priv(expr);
+	int err;
+
+	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
 	priv->family = ctx->afi->family;
 
-	priv->dreg = ntohl(nla_get_be32(tb[NFTA_CT_DREG]));
-	err = nft_validate_output_register(priv->dreg);
-	if (err < 0)
-		goto err1;
+	if (tb[NFTA_CT_DREG]) {
+		err = nft_ct_init_validate_get(expr, tb);
+		if (err < 0)
+			return err;
+
+		priv->dreg = ntohl(nla_get_be32(tb[NFTA_CT_DREG]));
+		err = nft_validate_output_register(priv->dreg);
+		if (err < 0)
+			return err;
+
+		err = nft_validate_data_load(ctx, priv->dreg, NULL,
+					     NFT_DATA_VALUE);
+		if (err < 0)
+			return err;
+	} else {
+		err = nft_ct_init_validate_set(priv->key);
+		if (err < 0)
+			return err;
+
+		priv->sreg = ntohl(nla_get_be32(tb[NFTA_CT_SREG]));
+	}
 
-	err = nft_validate_data_load(ctx, priv->dreg, NULL, NFT_DATA_VALUE);
+	err = nf_ct_l3proto_try_module_get(ctx->afi->family);
 	if (err < 0)
-		goto err1;
-	return 0;
+		return err;
 
-err1:
-	nf_ct_l3proto_module_put(ctx->afi->family);
-	return err;
+	return 0;
 }
 
 static void nft_ct_destroy(const struct nft_expr *expr)
@@ -206,7 +261,7 @@ static void nft_ct_destroy(const struct nft_expr *expr)
 	nf_ct_l3proto_module_put(priv->family);
 }
 
-static int nft_ct_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
 
@@ -222,19 +277,63 @@ nla_put_failure:
 	return -1;
 }
 
+static int nft_ct_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_ct *priv = nft_expr_priv(expr);
+
+	if (nla_put_be32(skb, NFTA_CT_SREG, htonl(priv->sreg)))
+		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_CT_KEY, htonl(priv->key)))
+		goto nla_put_failure;
+	if (nla_put_u8(skb, NFTA_CT_DIRECTION, priv->dir))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
 static struct nft_expr_type nft_ct_type;
-static const struct nft_expr_ops nft_ct_ops = {
+static const struct nft_expr_ops nft_ct_get_ops = {
+	.type		= &nft_ct_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
+	.eval		= nft_ct_get_eval,
+	.init		= nft_ct_init,
+	.destroy	= nft_ct_destroy,
+	.dump		= nft_ct_get_dump,
+};
+
+static const struct nft_expr_ops nft_ct_set_ops = {
 	.type		= &nft_ct_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
-	.eval		= nft_ct_eval,
+	.eval		= nft_ct_set_eval,
 	.init		= nft_ct_init,
 	.destroy	= nft_ct_destroy,
-	.dump		= nft_ct_dump,
+	.dump		= nft_ct_set_dump,
 };
 
+static const struct nft_expr_ops *
+nft_ct_select_ops(const struct nft_ctx *ctx,
+		    const struct nlattr * const tb[])
+{
+	if (tb[NFTA_CT_KEY] == NULL)
+		return ERR_PTR(-EINVAL);
+
+	if (tb[NFTA_CT_DREG] && tb[NFTA_CT_SREG])
+		return ERR_PTR(-EINVAL);
+
+	if (tb[NFTA_CT_DREG])
+		return &nft_ct_get_ops;
+
+	if (tb[NFTA_CT_SREG])
+		return &nft_ct_set_ops;
+
+	return ERR_PTR(-EINVAL);
+}
+
 static struct nft_expr_type nft_ct_type __read_mostly = {
 	.name		= "ct",
-	.ops		= &nft_ct_ops,
+	.select_ops	= &nft_ct_select_ops,
 	.policy		= nft_ct_policy,
 	.maxattr	= NFTA_CT_MAX,
 	.owner		= THIS_MODULE,
-- 
1.8.3.2

