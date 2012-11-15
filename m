From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nf-next:nf_tables-experiments PATCH 1/4] nf_tables: Change NFTA_NAT_ attributes to better semantic significance
Date: Thu, 15 Nov 2012 11:15:49 +0200
Message-ID: <1352970952-3447-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1352970952-3447-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1854 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435Ab2KOJP7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:15:59 -0500
In-Reply-To: <1352970952-3447-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/linux/netfilter/nf_tables.h     |  8 +++----
 net/ipv4/netfilter/nft_chain_nat_ipv4.c | 42 ++++++++++++++++++++-------------
 2 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 1242e62..f42cc9d 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -395,10 +395,10 @@ enum nft_nat_types {
 enum nft_nat_attributes {
 	NFTA_NAT_UNSPEC,
 	NFTA_NAT_TYPE,
-	NFTA_NAT_ADDR_MIN,
-	NFTA_NAT_ADDR_MAX,
-	NFTA_NAT_PROTO_MIN,
-	NFTA_NAT_PROTO_MAX,
+	NFTA_NAT_REG_ADDR_MIN,
+	NFTA_NAT_REG_ADDR_MAX,
+	NFTA_NAT_REG_PROTO_MIN,
+	NFTA_NAT_REG_PROTO_MAX,
 	__NFTA_NAT_MAX
 };
 #define NFTA_NAT_MAX		(__NFTA_NAT_MAX - 1)
diff --git a/net/ipv4/netfilter/nft_chain_nat_ipv4.c b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
index cd28630..95b265b 100644
--- a/net/ipv4/netfilter/nft_chain_nat_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
@@ -61,11 +61,11 @@ static void nft_nat_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_nat_policy[NFTA_NAT_MAX + 1] = {
-	[NFTA_NAT_ADDR_MIN]	= { .type = NLA_U32 },
-	[NFTA_NAT_ADDR_MAX]	= { .type = NLA_U32 },
-	[NFTA_NAT_PROTO_MIN]	= { .type = NLA_U32 },
-	[NFTA_NAT_PROTO_MAX]	= { .type = NLA_U32 },
-	[NFTA_NAT_TYPE]		= { .type = NLA_U32 },
+	[NFTA_NAT_TYPE]          = { .type = NLA_U32 },
+	[NFTA_NAT_REG_ADDR_MIN]  = { .type = NLA_U32 },
+	[NFTA_NAT_REG_ADDR_MAX]  = { .type = NLA_U32 },
+	[NFTA_NAT_REG_PROTO_MIN] = { .type = NLA_U32 },
+	[NFTA_NAT_REG_PROTO_MAX] = { .type = NLA_U32 },
 };
 
 static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
@@ -88,30 +88,34 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return -EINVAL;
 	}
 
-	if (tb[NFTA_NAT_ADDR_MIN]) {
-		priv->sreg_addr_min = ntohl(nla_get_be32(tb[NFTA_NAT_ADDR_MIN]));
+	if (tb[NFTA_NAT_REG_ADDR_MIN]) {
+		priv->sreg_addr_min = ntohl(nla_get_be32(
+						tb[NFTA_NAT_REG_ADDR_MIN]));
 		err = nft_validate_input_register(priv->sreg_addr_min);
 		if (err < 0)
 			return err;
 	}
 
-	if (tb[NFTA_NAT_ADDR_MAX]) {
-		priv->sreg_addr_max = ntohl(nla_get_be32(tb[NFTA_NAT_ADDR_MAX]));
+	if (tb[NFTA_NAT_REG_ADDR_MAX]) {
+		priv->sreg_addr_max = ntohl(nla_get_be32(
+						tb[NFTA_NAT_REG_ADDR_MAX]));
 		err = nft_validate_input_register(priv->sreg_addr_max);
 		if (err < 0)
 			return err;
 	} else
 		priv->sreg_addr_max = priv->sreg_addr_min;
 
-	if (tb[NFTA_NAT_PROTO_MIN]) {
-		priv->sreg_proto_min = ntohl(nla_get_be32(tb[NFTA_NAT_PROTO_MIN]));
+	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
+		priv->sreg_proto_min = ntohl(nla_get_be32(
+						tb[NFTA_NAT_REG_PROTO_MIN]));
 		err = nft_validate_input_register(priv->sreg_proto_min);
 		if (err < 0)
 			return err;
 	}
 
-	if (tb[NFTA_NAT_PROTO_MAX]) {
-		priv->sreg_proto_max = ntohl(nla_get_be32(tb[NFTA_NAT_PROTO_MAX]));
+	if (tb[NFTA_NAT_REG_PROTO_MAX]) {
+		priv->sreg_proto_max = ntohl(nla_get_be32(
+						tb[NFTA_NAT_REG_PROTO_MAX]));
 		err = nft_validate_input_register(priv->sreg_proto_max);
 		if (err < 0)
 			return err;
@@ -136,13 +140,17 @@ static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		break;
 	}
 
-	if (nla_put_be32(skb, NFTA_NAT_ADDR_MIN, htonl(priv->sreg_addr_min)))
+	if (nla_put_be32(skb,
+			 NFTA_NAT_REG_ADDR_MIN, htonl(priv->sreg_addr_min)))
 		goto nla_put_failure;
-	if (nla_put_be32(skb, NFTA_NAT_ADDR_MAX, htonl(priv->sreg_addr_max)))
+	if (nla_put_be32(skb,
+			 NFTA_NAT_REG_ADDR_MAX, htonl(priv->sreg_addr_max)))
 		goto nla_put_failure;
-	if (nla_put_be32(skb, NFTA_NAT_PROTO_MIN, htonl(priv->sreg_proto_min)))
+	if (nla_put_be32(skb,
+			 NFTA_NAT_REG_PROTO_MIN, htonl(priv->sreg_proto_min)))
 		goto nla_put_failure;
-	if (nla_put_be32(skb, NFTA_NAT_PROTO_MAX, htonl(priv->sreg_proto_max)))
+	if (nla_put_be32(skb,
+			 NFTA_NAT_REG_PROTO_MAX, htonl(priv->sreg_proto_max)))
 		goto nla_put_failure;
 	return 0;
 
-- 
1.8.0

