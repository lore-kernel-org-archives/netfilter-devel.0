From: Eric Leblond <eric@regit.org>
Subject: [PATCH 2/2] netfilter: nft: reject support for IPv6 and TCP reset
Date: Wed, 11 Dec 2013 01:42:34 +0100
Message-ID: <1386722554-4827-3-git-send-email-eric@regit.org>
References: <1386722554-4827-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:45354 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3LKAnG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:43:06 -0500
In-Reply-To: <1386722554-4827-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch moves nft_reject_ipv4 to nft_reject and adds support
for IPv6 protocol. This patch uses functions included in nf_reject.h
to implement reject by TCP reset.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 net/ipv4/netfilter/Kconfig           |   4 -
 net/ipv4/netfilter/Makefile          |   1 -
 net/ipv4/netfilter/nft_reject_ipv4.c | 123 ------------------------------
 net/netfilter/Kconfig                |   4 +
 net/netfilter/Makefile               |   1 +
 net/netfilter/nft_reject.c           | 143 +++++++++++++++++++++++++++++++++++
 6 files changed, 148 insertions(+), 128 deletions(-)
 delete mode 100644 net/ipv4/netfilter/nft_reject_ipv4.c
 create mode 100644 net/netfilter/nft_reject.c

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 40d5607..9d3d69a 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -40,10 +40,6 @@ config NF_TABLES_IPV4
 	depends on NF_TABLES
 	tristate "IPv4 nf_tables support"
 
-config NFT_REJECT_IPV4
-	depends on NF_TABLES_IPV4
-	tristate "nf_tables IPv4 reject support"
-
 config NFT_CHAIN_ROUTE_IPV4
 	depends on NF_TABLES_IPV4
 	tristate "IPv4 nf_tables route chain support"
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 19df72b..c16be9d 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -28,7 +28,6 @@ obj-$(CONFIG_NF_NAT_SNMP_BASIC) += nf_nat_snmp_basic.o
 obj-$(CONFIG_NF_NAT_PROTO_GRE) += nf_nat_proto_gre.o
 
 obj-$(CONFIG_NF_TABLES_IPV4) += nf_tables_ipv4.o
-obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
 obj-$(CONFIG_NF_TABLES_ARP) += nf_tables_arp.o
diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_reject_ipv4.c
deleted file mode 100644
index fff5ba1..0000000
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ /dev/null
@@ -1,123 +0,0 @@
-/*
- * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Development of this code funded by Astaro AG (http://www.astaro.com/)
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/netlink.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
-#include <net/icmp.h>
-
-struct nft_reject {
-	enum nft_reject_types	type:8;
-	u8			icmp_code;
-};
-
-static void nft_reject_eval(const struct nft_expr *expr,
-			      struct nft_data data[NFT_REG_MAX + 1],
-			      const struct nft_pktinfo *pkt)
-{
-	struct nft_reject *priv = nft_expr_priv(expr);
-
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-		icmp_send(pkt->skb, ICMP_DEST_UNREACH, priv->icmp_code, 0);
-		break;
-	case NFT_REJECT_TCP_RST:
-		break;
-	}
-
-	data[NFT_REG_VERDICT].verdict = NF_DROP;
-}
-
-static const struct nla_policy nft_reject_policy[NFTA_REJECT_MAX + 1] = {
-	[NFTA_REJECT_TYPE]		= { .type = NLA_U32 },
-	[NFTA_REJECT_ICMP_CODE]		= { .type = NLA_U8 },
-};
-
-static int nft_reject_init(const struct nft_ctx *ctx,
-			   const struct nft_expr *expr,
-			   const struct nlattr * const tb[])
-{
-	struct nft_reject *priv = nft_expr_priv(expr);
-
-	if (tb[NFTA_REJECT_TYPE] == NULL)
-		return -EINVAL;
-
-	priv->type = ntohl(nla_get_be32(tb[NFTA_REJECT_TYPE]));
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-		if (tb[NFTA_REJECT_ICMP_CODE] == NULL)
-			return -EINVAL;
-		priv->icmp_code = nla_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
-	case NFT_REJECT_TCP_RST:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int nft_reject_dump(struct sk_buff *skb, const struct nft_expr *expr)
-{
-	const struct nft_reject *priv = nft_expr_priv(expr);
-
-	if (nla_put_be32(skb, NFTA_REJECT_TYPE, priv->type))
-		goto nla_put_failure;
-
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-		if (nla_put_u8(skb, NFTA_REJECT_ICMP_CODE, priv->icmp_code))
-			goto nla_put_failure;
-		break;
-	}
-
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
-static struct nft_expr_type nft_reject_type;
-static const struct nft_expr_ops nft_reject_ops = {
-	.type		= &nft_reject_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_reject)),
-	.eval		= nft_reject_eval,
-	.init		= nft_reject_init,
-	.dump		= nft_reject_dump,
-};
-
-static struct nft_expr_type nft_reject_type __read_mostly = {
-	.name		= "reject",
-	.ops		= &nft_reject_ops,
-	.policy		= nft_reject_policy,
-	.maxattr	= NFTA_REJECT_MAX,
-	.owner		= THIS_MODULE,
-};
-
-static int __init nft_reject_module_init(void)
-{
-	return nft_register_expr(&nft_reject_type);
-}
-
-static void __exit nft_reject_module_exit(void)
-{
-	nft_unregister_expr(&nft_reject_type);
-}
-
-module_init(nft_reject_module_init);
-module_exit(nft_reject_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_EXPR("reject");
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 5263605..9482822 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -465,6 +465,10 @@ config NFT_QUEUE
 	  This is required if you intend to use the userspace queueing
 	  infrastructure (also known as NFQUEUE) from nftables.
 
+config NFT_REJECT
+	depends on NF_TABLES
+	tristate "nf_tables reject support"
+
 config NFT_COMPAT
 	depends on NF_TABLES
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index e763746..ba578f6 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_NFT_CT)		+= nft_ct.o
 obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
 obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
 obj-$(CONFIG_NFT_QUEUE)		+= nft_queue.o
+obj-$(CONFIG_NFT_REJECT) 	+= nft_reject.o
 #nf_tables-objs			+= nft_meta_target.o
 obj-$(CONFIG_NFT_RBTREE)	+= nft_rbtree.o
 obj-$(CONFIG_NFT_HASH)		+= nft_hash.o
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
new file mode 100644
index 0000000..002143c
--- /dev/null
+++ b/net/netfilter/nft_reject.c
@@ -0,0 +1,143 @@
+/*
+ * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Development of this code funded by Astaro AG (http://www.astaro.com/)
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/icmp.h>
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+#include <net/ipv6.h>
+#endif
+
+#include <net/netfilter/nf_reject.h>
+
+struct nft_reject {
+	enum nft_reject_types	type:8;
+	u8			icmp_code;
+	u8			family;
+};
+
+static void nft_reject_eval(const struct nft_expr *expr,
+			      struct nft_data data[NFT_REG_MAX + 1],
+			      const struct nft_pktinfo *pkt)
+{
+	struct nft_reject *priv = nft_expr_priv(expr);
+	struct net *net = dev_net((pkt->in != NULL) ? pkt->in : pkt->out);
+
+	switch (priv->type) {
+	case NFT_REJECT_ICMP_UNREACH:
+		if (priv->family == NFPROTO_IPV4)
+			send_unreach(pkt->skb, priv->icmp_code);
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+		else if (priv->family == NFPROTO_IPV6)
+			send_unreach6(net, pkt->skb, priv->icmp_code,
+				      pkt->hooknum);
+#endif
+		break;
+	case NFT_REJECT_TCP_RST:
+		if (priv->family == NFPROTO_IPV4)
+			send_reset(pkt->skb, pkt->hooknum);
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+		else if (priv->family == NFPROTO_IPV6)
+			send_reset6(net, pkt->skb, pkt->hooknum);
+#endif
+		break;
+	}
+
+	data[NFT_REG_VERDICT].verdict = NF_DROP;
+}
+
+static const struct nla_policy nft_reject_policy[NFTA_REJECT_MAX + 1] = {
+	[NFTA_REJECT_TYPE]		= { .type = NLA_U32 },
+	[NFTA_REJECT_ICMP_CODE]		= { .type = NLA_U8 },
+};
+
+static int nft_reject_init(const struct nft_ctx *ctx,
+			   const struct nft_expr *expr,
+			   const struct nlattr * const tb[])
+{
+	struct nft_reject *priv = nft_expr_priv(expr);
+
+	if (tb[NFTA_REJECT_TYPE] == NULL)
+		return -EINVAL;
+
+	priv->family = ctx->afi->family;
+	priv->type = ntohl(nla_get_be32(tb[NFTA_REJECT_TYPE]));
+	switch (priv->type) {
+	case NFT_REJECT_ICMP_UNREACH:
+		if (tb[NFTA_REJECT_ICMP_CODE] == NULL)
+			return -EINVAL;
+		priv->icmp_code = nla_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
+	case NFT_REJECT_TCP_RST:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int nft_reject_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_reject *priv = nft_expr_priv(expr);
+
+	if (nla_put_be32(skb, NFTA_REJECT_TYPE, priv->type))
+		goto nla_put_failure;
+
+	switch (priv->type) {
+	case NFT_REJECT_ICMP_UNREACH:
+		if (nla_put_u8(skb, NFTA_REJECT_ICMP_CODE, priv->icmp_code))
+			goto nla_put_failure;
+		break;
+	}
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nft_expr_type nft_reject_type;
+static const struct nft_expr_ops nft_reject_ops = {
+	.type		= &nft_reject_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_reject)),
+	.eval		= nft_reject_eval,
+	.init		= nft_reject_init,
+	.dump		= nft_reject_dump,
+};
+
+static struct nft_expr_type nft_reject_type __read_mostly = {
+	.name		= "reject",
+	.ops		= &nft_reject_ops,
+	.policy		= nft_reject_policy,
+	.maxattr	= NFTA_REJECT_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_reject_module_init(void)
+{
+	return nft_register_expr(&nft_reject_type);
+}
+
+static void __exit nft_reject_module_exit(void)
+{
+	nft_unregister_expr(&nft_reject_type);
+}
+
+module_init(nft_reject_module_init);
+module_exit(nft_reject_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_ALIAS_NFT_EXPR("reject");
-- 
1.8.5.1

