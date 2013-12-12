From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nftables kernel PATCH v2] netfilter: nf_tables: fix nft_meta_target
	module
Date: Thu, 12 Dec 2013 12:12:01 +0100
Message-ID: <20131212111201.4462.9945.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tomasz.bursztyka@linux.intel.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:50855 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751423Ab3LLLMG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:12:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds kernel support for the meta expression in target flavour.
Indicates that a given packet has to be set with a property, currently one
of mark, priority, nftrace or secmark.

In case of nftrace, the value is always 1. Such behaviour is copied
from net/netfilter/xt_TRACE.c

In case of secmark, the intention is to make the translation between the
security_ctx and security_id in userspace.
Otherwise, a string is needed to be passed from the userpsace to kernel as
part of the attribute set, breaking the KEY,VALUE pair approach.
This is different from net/netfilter/xt_SECMARK.c. There, the context
is translated in kernel side.

NFTA_META_DREG and NFTA_META_VALUE attributes are mutually exclusives.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |    2 
 net/netfilter/nft_meta.c                 |  156 +++++++++++++++++++++++++-----
 2 files changed, 132 insertions(+), 26 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 256d36b..a21665d 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -552,11 +552,13 @@ enum nft_meta_keys {
  * enum nft_meta_attributes - nf_tables meta expression netlink attributes
  *
  * @NFTA_META_DREG: destination register (NLA_U32)
+ * @NFTA_META_VALUE: source data to load (NLA_U32)
  * @NFTA_META_KEY: meta data item to load (NLA_U32: nft_meta_keys)
  */
 enum nft_meta_attributes {
 	NFTA_META_UNSPEC,
 	NFTA_META_DREG,
+	NFTA_META_VALUE,
 	NFTA_META_KEY,
 	__NFTA_META_MAX
 };
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 8c28220..8fce64b 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -21,12 +21,15 @@
 
 struct nft_meta {
 	enum nft_meta_keys	key:8;
-	enum nft_registers	dreg:8;
+	union {
+		enum nft_registers	dreg:8;
+		u32			value;
+	};
 };
 
-static void nft_meta_eval(const struct nft_expr *expr,
-			  struct nft_data data[NFT_REG_MAX + 1],
-			  const struct nft_pktinfo *pkt)
+static void nft_meta_match_eval(const struct nft_expr *expr,
+				struct nft_data data[NFT_REG_MAX + 1],
+				const struct nft_pktinfo *pkt)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
@@ -132,23 +135,57 @@ err:
 	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
 
+static void nft_meta_target_eval(const struct nft_expr *expr,
+				 struct nft_data data[NFT_REG_MAX + 1],
+				 const struct nft_pktinfo *pkt)
+{
+	const struct nft_meta *meta = nft_expr_priv(expr);
+	struct sk_buff *skb = pkt->skb;
+
+	switch (meta->key) {
+	case NFT_META_MARK:
+		skb->mark = meta->value;
+		break;
+	case NFT_META_PRIORITY:
+		skb->priority = meta->value;
+		break;
+	case NFT_META_NFTRACE:
+		skb->nf_trace = 1;
+		break;
+#ifdef CONFIG_NETWORK_SECMARK
+	case NFT_META_SECMARK:
+		skb->secmark = meta->value;
+		break;
+#endif
+	default:
+		WARN_ON(1);
+	}
+}
+
 static const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
 	[NFTA_META_DREG]	= { .type = NLA_U32 },
+	[NFTA_META_VALUE]	= { .type = NLA_U32 },
 	[NFTA_META_KEY]		= { .type = NLA_U32 },
 };
 
-static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
-			 const struct nlattr * const tb[])
+static int nft_meta_init_validate_target(uint32_t key)
 {
-	struct nft_meta *priv = nft_expr_priv(expr);
-	int err;
-
-	if (tb[NFTA_META_DREG] == NULL ||
-	    tb[NFTA_META_KEY] == NULL)
-		return -EINVAL;
+	switch (key) {
+	case NFT_META_MARK:
+	case NFT_META_PRIORITY:
+	case NFT_META_NFTRACE:
+#ifdef CONFIG_NETWORK_SECMARK
+	case NFT_META_SECMARK:
+#endif
+		return 0;
+	default:
+		return -1;
+	}
+}
 
-	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
-	switch (priv->key) {
+static int nft_meta_init_validate_match(uint32_t key)
+{
+	switch (key) {
 	case NFT_META_LEN:
 	case NFT_META_PROTOCOL:
 	case NFT_META_PRIORITY:
@@ -167,26 +204,66 @@ static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
 #endif
-		break;
+		return 0;
 	default:
-		return -EOPNOTSUPP;
+		return -1;
+	}
+
+}
+
+static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
+			 const struct nlattr * const tb[])
+{
+	struct nft_meta *priv = nft_expr_priv(expr);
+	int err;
+
+	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
+
+	if (tb[NFTA_META_DREG]) {
+		if (nft_meta_init_validate_match(priv->key) != 0)
+			return -EOPNOTSUPP;
+
+		priv->dreg = ntohl(nla_get_be32(tb[NFTA_META_DREG]));
+		err = nft_validate_output_register(priv->dreg);
+		if (err < 0)
+			return err;
+		return nft_validate_data_load(ctx, priv->dreg, NULL,
+					      NFT_DATA_VALUE);
 	}
 
-	priv->dreg = ntohl(nla_get_be32(tb[NFTA_META_DREG]));
-	err = nft_validate_output_register(priv->dreg);
-	if (err < 0)
-		return err;
-	return nft_validate_data_load(ctx, priv->dreg, NULL, NFT_DATA_VALUE);
+	if (nft_meta_init_validate_target(priv->key) != 0)
+		return -EOPNOTSUPP;
+
+	priv->value = ntohl(nla_get_be32(tb[NFTA_META_VALUE]));
+
+	return 0;
 }
 
-static int nft_meta_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_meta_match_dump(struct sk_buff *skb,
+			       const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
+	if (nla_put_be32(skb, NFTA_META_KEY, htonl(priv->key)))
+		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_META_DREG, htonl(priv->dreg)))
 		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static int nft_meta_target_dump(struct sk_buff *skb,
+			       const struct nft_expr *expr)
+{
+	const struct nft_meta *priv = nft_expr_priv(expr);
+
 	if (nla_put_be32(skb, NFTA_META_KEY, htonl(priv->key)))
 		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_META_VALUE, htonl(priv->value)))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
@@ -194,17 +271,44 @@ nla_put_failure:
 }
 
 static struct nft_expr_type nft_meta_type;
-static const struct nft_expr_ops nft_meta_ops = {
+static const struct nft_expr_ops nft_meta_match_ops = {
 	.type		= &nft_meta_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
-	.eval		= nft_meta_eval,
+	.eval		= nft_meta_match_eval,
 	.init		= nft_meta_init,
-	.dump		= nft_meta_dump,
+	.dump		= nft_meta_match_dump,
 };
 
+static const struct nft_expr_ops nft_meta_target_ops = {
+	.type		= &nft_meta_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
+	.eval		= nft_meta_target_eval,
+	.init		= nft_meta_init,
+	.dump		= nft_meta_target_dump,
+};
+
+static const struct nft_expr_ops *
+nft_meta_select_ops(const struct nft_ctx *ctx,
+		    const struct nlattr * const tb[])
+{
+	if (!tb[NFTA_META_KEY])
+		return ERR_PTR(-EINVAL);
+
+	if (tb[NFTA_META_DREG] && tb[NFTA_META_VALUE])
+		return ERR_PTR(-EINVAL);
+
+	if (tb[NFTA_META_DREG])
+		return &nft_meta_match_ops;
+
+	if (tb[NFTA_META_VALUE])
+		return &nft_meta_target_ops;
+
+	return ERR_PTR(-EINVAL);
+}
+
 static struct nft_expr_type nft_meta_type __read_mostly = {
 	.name		= "meta",
-	.ops		= &nft_meta_ops,
+	.select_ops	= &nft_meta_select_ops,
 	.policy		= nft_meta_policy,
 	.maxattr	= NFTA_META_MAX,
 	.owner		= THIS_MODULE,

