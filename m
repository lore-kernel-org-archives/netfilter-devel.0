From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nf-next:nf_tables-experiments PATCH - v2 - 3/4] nf_tables: Add support for IPv6 NAT expression
Date: Thu, 15 Nov 2012 14:25:01 +0200
Message-ID: <1352982302-32402-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1352982302-32402-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24236 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767933Ab2KOOZN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:25:13 -0500
In-Reply-To: <1352982302-32402-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nft_nat.c             | 26 ++++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index f42cc9d..fed6835 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -395,6 +395,7 @@ enum nft_nat_types {
 enum nft_nat_attributes {
 	NFTA_NAT_UNSPEC,
 	NFTA_NAT_TYPE,
+	NFTA_NAT_FAMILY,
 	NFTA_NAT_REG_ADDR_MIN,
 	NFTA_NAT_REG_ADDR_MAX,
 	NFTA_NAT_REG_PROTO_MIN,
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index ea9854e..b0b87b2 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
+#include <linux/string.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
@@ -30,6 +31,7 @@ struct nft_nat {
 	enum nft_registers      sreg_addr_max:8;
 	enum nft_registers      sreg_proto_min:8;
 	enum nft_registers      sreg_proto_max:8;
+	int                     family;
 	enum nf_nat_manip_type  type;
 };
 
@@ -44,8 +46,18 @@ static void nft_nat_eval(const struct nft_expr *expr,
 
 	memset(&range, 0, sizeof(range));
 	if (priv->sreg_addr_min) {
-		range.min_addr.ip = data[priv->sreg_addr_min].data[0];
-		range.max_addr.ip = data[priv->sreg_addr_max].data[0];
+		if (priv->family == AF_INET) {
+			range.min_addr.ip = data[priv->sreg_addr_min].data[0];
+			range.max_addr.ip = data[priv->sreg_addr_max].data[0];
+
+		} else {
+			memcpy(range.min_addr.ip6,
+			       data[priv->sreg_addr_min].data,
+			       sizeof(struct nft_data));
+			memcpy(range.max_addr.ip6,
+			       data[priv->sreg_addr_max].data,
+			       sizeof(struct nft_data));
+		}
 		range.flags |= NF_NAT_RANGE_MAP_IPS;
 	}
 
@@ -61,6 +73,7 @@ static void nft_nat_eval(const struct nft_expr *expr,
 
 static const struct nla_policy nft_nat_policy[NFTA_NAT_MAX + 1] = {
 	[NFTA_NAT_TYPE]		 = { .type = NLA_U32 },
+	[NFTA_NAT_FAMILY]	 = { .type = NLA_U32 },
 	[NFTA_NAT_REG_ADDR_MIN]	 = { .type = NLA_U32 },
 	[NFTA_NAT_REG_ADDR_MAX]	 = { .type = NLA_U32 },
 	[NFTA_NAT_REG_PROTO_MIN] = { .type = NLA_U32 },
@@ -87,6 +100,13 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return -EINVAL;
 	}
 
+	if (tb[NFTA_NAT_FAMILY] == NULL)
+		return -EINVAL;
+
+	priv->family = ntohl(nla_get_be32(tb[NFTA_NAT_FAMILY]));
+	if (priv->family != AF_INET && priv->family != AF_INET6)
+		return -EINVAL;
+
 	if (tb[NFTA_NAT_REG_ADDR_MIN]) {
 		priv->sreg_addr_min = ntohl(nla_get_be32(
 						tb[NFTA_NAT_REG_ADDR_MIN]));
@@ -139,6 +159,8 @@ static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		break;
 	}
 
+	if (nla_put_be32(skb, NFTA_NAT_FAMILY, htonl(priv->family)))
+		goto nla_put_failure;
 	if (nla_put_be32(skb,
 			 NFTA_NAT_REG_ADDR_MIN, htonl(priv->sreg_addr_min)))
 		goto nla_put_failure;
-- 
1.8.0

