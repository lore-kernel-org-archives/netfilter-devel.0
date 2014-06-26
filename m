From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [linux PATCH 5/5] netfilter: nft_nat: add masquerade support
Date: Thu, 26 Jun 2014 14:20:16 +0200
Message-ID: <20140626122016.3985.11292.stgit@nfdev.cica.es>
References: <20140626121823.3985.22905.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42673 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757194AbaFZMUT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:20:19 -0400
In-Reply-To: <20140626121823.3985.22905.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds masquerade support to nft_nat.

Note that enum nf_nat_manip_type is replaced by enum nft_nat_types in order
to support masquerade.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/net/netfilter/nft_nat.h          |    2 +
 include/uapi/linux/netfilter/nf_tables.h |    5 ++-
 net/ipv4/netfilter/nft_nat_ipv4.c        |   52 ++++++++++++++++++++++--------
 net/ipv6/netfilter/nft_nat_ipv6.c        |   52 ++++++++++++++++++++++--------
 net/netfilter/nft_nat.c                  |    8 ++---
 5 files changed, 84 insertions(+), 35 deletions(-)

diff --git a/include/net/netfilter/nft_nat.h b/include/net/netfilter/nft_nat.h
index d809156..18e3497 100644
--- a/include/net/netfilter/nft_nat.h
+++ b/include/net/netfilter/nft_nat.h
@@ -6,7 +6,7 @@ struct nft_nat {
 	enum nft_registers      sreg_addr_max:8;
 	enum nft_registers      sreg_proto_min:8;
 	enum nft_registers      sreg_proto_max:8;
-	enum nf_nat_manip_type  type:8;
+	enum nft_nat_types	type:8;
 	u8			family;
 	u32			flags;
 };
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 92c211b..f4df5cc 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -754,14 +754,17 @@ enum nft_reject_attributes {
 #define NFTA_REJECT_MAX		(__NFTA_REJECT_MAX - 1)
 
 /**
- * enum nft_nat_types - nf_tables nat expression NAT types
+ * enum nft_nat_types - nf_tables nat expression NAT types.
+ *			must match enum nf_nat_manip_type.
  *
  * @NFT_NAT_SNAT: source NAT
  * @NFT_NAT_DNAT: destination NAT
+ * @NFT_NAT_MASQUERADE: masquerade NAT
  */
 enum nft_nat_types {
 	NFT_NAT_SNAT,
 	NFT_NAT_DNAT,
+	NFT_NAT_MASQUERADE,
 };
 
 /**
diff --git a/net/ipv4/netfilter/nft_nat_ipv4.c b/net/ipv4/netfilter/nft_nat_ipv4.c
index cfbd8ae..01728f9 100644
--- a/net/ipv4/netfilter/nft_nat_ipv4.c
+++ b/net/ipv4/netfilter/nft_nat_ipv4.c
@@ -37,6 +37,7 @@ static void nft_nat_ipv4_eval(const struct nft_expr *expr,
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(pkt->skb, &ctinfo);
 	struct nf_nat_range range;
+	unsigned int verdict;
 
 	memset(&range, 0, sizeof(range));
 	if (priv->sreg_addr_min) {
@@ -59,25 +60,21 @@ static void nft_nat_ipv4_eval(const struct nft_expr *expr,
 
 	range.flags |= priv->flags;
 
-	data[NFT_REG_VERDICT].verdict =
-				nf_nat_setup_info(ct, &range, priv->type);
+	if (priv->type == NFT_NAT_MASQUERADE)
+		verdict = nf_nat_masquerade_ipv4(pkt->skb, pkt->ops->hooknum,
+						 &range, pkt->out);
+	else
+		verdict = nf_nat_setup_info(ct, &range, priv->type);
+
+	data[NFT_REG_VERDICT].verdict = verdict;
 }
 
 static int nft_nat_ipv4_dump(struct sk_buff *skb, const struct nft_expr *expr)
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
 	if (nla_put_be32(skb, NFTA_NAT_FAMILY, htonl(NFPROTO_IPV4)))
 		goto nla_put_failure;
 	if (nla_put_be32(skb,
@@ -104,12 +101,39 @@ nla_put_failure:
 	return -1;
 }
 
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
+}
+
 static struct nft_expr_type nft_nat_ipv4_type;
 static const struct nft_expr_ops nft_nat_ipv4_ops = {
 	.type           = &nft_nat_ipv4_type,
 	.size           = NFT_EXPR_SIZE(sizeof(struct nft_nat)),
 	.eval           = nft_nat_ipv4_eval,
-	.init           = nft_nat_init,
+	.init           = nft_nat_ipv4_init,
+	.destroy	= nft_nat_ipv4_destroy,
 	.dump           = nft_nat_ipv4_dump,
 };
 
diff --git a/net/ipv6/netfilter/nft_nat_ipv6.c b/net/ipv6/netfilter/nft_nat_ipv6.c
index b50afc1..7c90ce7 100644
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
@@ -59,25 +61,20 @@ static void nft_nat_ipv6_eval(const struct nft_expr *expr,
 
 	range.flags |= priv->flags;
 
-	data[NFT_REG_VERDICT].verdict =
-				nf_nat_setup_info(ct, &range, priv->type);
+	if (priv->type == NFT_NAT_MASQUERADE)
+		verdict = nf_nat_masquerade_ipv6(pkt->skb, &range, pkt->out);
+	else
+		verdict = nf_nat_setup_info(ct, &range, priv->type);
+
+	data[NFT_REG_VERDICT].verdict = verdict;
 }
 
 static int nft_nat_ipv6_dump(struct sk_buff *skb, const struct nft_expr *expr)
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
+	if (nla_put_be32(skb, NFTA_NAT_TYPE, priv->type))
+		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_NAT_FAMILY, htonl(NFPROTO_IPV6)))
 		goto nla_put_failure;
 	if (nla_put_be32(skb,
@@ -104,12 +101,39 @@ nla_put_failure:
 	return -1;
 }
 
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
+}
+
 static struct nft_expr_type nft_nat_ipv6_type;
 static const struct nft_expr_ops nft_nat_ipv6_ops = {
 	.type           = &nft_nat_ipv6_type,
 	.size           = NFT_EXPR_SIZE(sizeof(struct nft_nat)),
 	.eval           = nft_nat_ipv6_eval,
-	.init           = nft_nat_init,
+	.init           = nft_nat_ipv6_init,
+	.destroy	= nft_nat_ipv6_destroy,
 	.dump           = nft_nat_ipv6_dump,
 };
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 9a5d2da..5c14a6c 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -43,18 +43,16 @@ int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		 const struct nlattr * const tb[])
 {
 	struct nft_nat *priv = nft_expr_priv(expr);
-	u32 family;
 	int err;
 
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

