From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [linux PATCH v3 5/5] netfilter: nft_nat: add masquerade support
Date: Tue, 01 Jul 2014 18:33:06 +0200
Message-ID: <20140701163241.2847.36080.stgit@nfdev.cica.es>
References: <20140701162801.2847.14389.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48393 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758139AbaGAQdQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:33:16 -0400
In-Reply-To: <20140701162801.2847.14389.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds masquerade support to nft_nat.

Note that enum nf_nat_manip_type is replaced by enum nft_nat_types in order
to support masquerade.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: fix missing htonl() conversion for NFTA_NAT_TYPE in _ipv6_dump().
v3: no changes.

 include/net/netfilter/nft_nat.h          |    2 +-
 include/uapi/linux/netfilter/nf_tables.h |    8 ++++--
 net/ipv4/netfilter/nft_nat_ipv4.c        |   40 ++++++++++++++++++++++++++++--
 net/ipv6/netfilter/nft_nat_ipv6.c        |   39 +++++++++++++++++++++++++++--
 net/netfilter/nft_nat.c                  |   20 ++++-----------
 5 files changed, 84 insertions(+), 25 deletions(-)

diff --git a/include/net/netfilter/nft_nat.h b/include/net/netfilter/nft_nat.h
index 0ac1546..f5e108c 100644
--- a/include/net/netfilter/nft_nat.h
+++ b/include/net/netfilter/nft_nat.h
@@ -6,7 +6,7 @@ struct nft_nat {
 	enum nft_registers      sreg_addr_max:8;
 	enum nft_registers      sreg_proto_min:8;
 	enum nft_registers      sreg_proto_max:8;
-	enum nf_nat_manip_type  type:8;
+	enum nft_nat_types	type:8;
 	u8			family;
 	u16			flags;
 };
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 92c211b..ce75cb7 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -754,14 +754,16 @@ enum nft_reject_attributes {
 #define NFTA_REJECT_MAX		(__NFTA_REJECT_MAX - 1)
 
 /**
- * enum nft_nat_types - nf_tables nat expression NAT types
+ * enum nft_nat_types - nf_tables nat expression NAT types.
  *
  * @NFT_NAT_SNAT: source NAT
  * @NFT_NAT_DNAT: destination NAT
+ * @NFT_NAT_MASQUERADE: masquerade NAT
  */
 enum nft_nat_types {
-	NFT_NAT_SNAT,
-	NFT_NAT_DNAT,
+	NFT_NAT_SNAT,		/* NF_NAT_MANIP_SRC */
+	NFT_NAT_DNAT,		/* NF_NAT_MANIP_DST */
+	NFT_NAT_MASQUERADE,
 };
 
 /**
diff --git a/net/ipv4/netfilter/nft_nat_ipv4.c b/net/ipv4/netfilter/nft_nat_ipv4.c
index eea3cd9..d246eb3 100644
--- a/net/ipv4/netfilter/nft_nat_ipv4.c
+++ b/net/ipv4/netfilter/nft_nat_ipv4.c
@@ -37,6 +37,7 @@ static void nft_nat_ipv4_eval(const struct nft_expr *expr,
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(pkt->skb, &ctinfo);
 	struct nf_nat_range range;
+	unsigned int verdict;
 
 	memset(&range, 0, sizeof(range));
 	if (priv->sreg_addr_min) {
@@ -59,8 +60,40 @@ static void nft_nat_ipv4_eval(const struct nft_expr *expr,
 
 	range.flags |= priv->flags;
 
-	data[NFT_REG_VERDICT].verdict =
-				nf_nat_setup_info(ct, &range, priv->type);
+	if (priv->type == NFT_NAT_MASQUERADE) {
+		verdict = nf_nat_masquerade_ipv4(pkt->skb, pkt->ops->hooknum,
+						 &range, pkt->out);
+	} else {
+		verdict = nf_nat_setup_info(ct, &range, priv->type);
+	}
+
+	data[NFT_REG_VERDICT].verdict = verdict;
+}
+
+static int nft_nat_ipv4_init(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nlattr * const tb[])
+{
+	int ret;
+	struct nft_nat *priv = nft_expr_priv(expr);
+
+	ret = nft_nat_init(ctx, expr, tb);
+	if (ret < 0)
+		goto out;
+
+	if (priv->type == NFT_NAT_MASQUERADE)
+		nf_nat_masquerade_ipv4_register_notifier();
+out:
+	return ret;
+}
+
+static void nft_nat_ipv4_destroy(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr)
+{
+	struct nft_nat *priv = nft_expr_priv(expr);
+
+	if (priv->type == NFT_NAT_MASQUERADE)
+		nf_nat_masquerade_ipv4_unregister_notifier();
 }
 
 static struct nft_expr_type nft_nat_ipv4_type;
@@ -68,7 +101,8 @@ static const struct nft_expr_ops nft_nat_ipv4_ops = {
 	.type           = &nft_nat_ipv4_type,
 	.size           = NFT_EXPR_SIZE(sizeof(struct nft_nat)),
 	.eval           = nft_nat_ipv4_eval,
-	.init           = nft_nat_init,
+	.init           = nft_nat_ipv4_init,
+	.destroy	= nft_nat_ipv4_destroy,
 	.dump           = nft_nat_dump,
 };
 
diff --git a/net/ipv6/netfilter/nft_nat_ipv6.c b/net/ipv6/netfilter/nft_nat_ipv6.c
index bf1498a..0e4f277 100644
--- a/net/ipv6/netfilter/nft_nat_ipv6.c
+++ b/net/ipv6/netfilter/nft_nat_ipv6.c
@@ -27,6 +27,7 @@
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/ip.h>
 #include <net/netfilter/nft_nat.h>
+#include <net/netfilter/ipv6/nf_nat_masquerade_ipv6.h>
 
 static void nft_nat_ipv6_eval(const struct nft_expr *expr,
 			      struct nft_data data[NFT_REG_MAX + 1],
@@ -36,6 +37,7 @@ static void nft_nat_ipv6_eval(const struct nft_expr *expr,
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(pkt->skb, &ctinfo);
 	struct nf_nat_range range;
+	unsigned int verdict;
 
 	memset(&range, 0, sizeof(range));
 	if (priv->sreg_addr_min) {
@@ -59,8 +61,38 @@ static void nft_nat_ipv6_eval(const struct nft_expr *expr,
 
 	range.flags |= priv->flags;
 
-	data[NFT_REG_VERDICT].verdict =
-				nf_nat_setup_info(ct, &range, priv->type);
+	if (priv->type == NFT_NAT_MASQUERADE)
+		verdict = nf_nat_masquerade_ipv6(pkt->skb, &range, pkt->out);
+	else
+		verdict = nf_nat_setup_info(ct, &range, priv->type);
+
+	data[NFT_REG_VERDICT].verdict = verdict;
+}
+
+static int nft_nat_ipv6_init(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nlattr * const tb[])
+{
+	int ret;
+	struct nft_nat *priv = nft_expr_priv(expr);
+
+	ret = nft_nat_init(ctx, expr, tb);
+	if (ret < 0)
+		goto out;
+
+	if (priv->type == NFT_NAT_MASQUERADE)
+		nf_nat_masquerade_ipv6_register_notifier();
+out:
+	return ret;
+}
+
+static void nft_nat_ipv6_destroy(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr)
+{
+	struct nft_nat *priv = nft_expr_priv(expr);
+
+	if (priv->type == NFT_NAT_MASQUERADE)
+		nf_nat_masquerade_ipv6_unregister_notifier();
 }
 
 static struct nft_expr_type nft_nat_ipv6_type;
@@ -68,7 +100,8 @@ static const struct nft_expr_ops nft_nat_ipv6_ops = {
 	.type           = &nft_nat_ipv6_type,
 	.size           = NFT_EXPR_SIZE(sizeof(struct nft_nat)),
 	.eval           = nft_nat_ipv6_eval,
-	.init           = nft_nat_init,
+	.init           = nft_nat_ipv6_init,
+	.destroy	= nft_nat_ipv6_destroy,
 	.dump           = nft_nat_dump,
 };
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index ec9c283..d603acb 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -49,12 +49,11 @@ int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (tb[NFTA_NAT_TYPE] == NULL)
 		return -EINVAL;
 
-	switch (ntohl(nla_get_be32(tb[NFTA_NAT_TYPE]))) {
+	priv->type = ntohl(nla_get_be32(tb[NFTA_NAT_TYPE]));
+	switch (priv->type) {
 	case NFT_NAT_SNAT:
-		priv->type = NF_NAT_MANIP_SRC;
-		break;
 	case NFT_NAT_DNAT:
-		priv->type = NF_NAT_MANIP_DST;
+	case NFT_NAT_MASQUERADE:
 		break;
 	default:
 		return -EINVAL;
@@ -122,17 +121,8 @@ int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_nat *priv = nft_expr_priv(expr);
 
-	switch (priv->type) {
-	case NF_NAT_MANIP_SRC:
-		if (nla_put_be32(skb, NFTA_NAT_TYPE, htonl(NFT_NAT_SNAT)))
-			goto nla_put_failure;
-		break;
-	case NF_NAT_MANIP_DST:
-		if (nla_put_be32(skb, NFTA_NAT_TYPE, htonl(NFT_NAT_DNAT)))
-			goto nla_put_failure;
-		break;
-	}
-
+	if (nla_put_be32(skb, NFTA_NAT_TYPE, htonl(priv->type)))
+		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_NAT_FAMILY, htonl(priv->family)))
 		goto nla_put_failure;
 	if (nla_put_be32(skb,

