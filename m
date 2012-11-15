From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nf-next:nf_tables-experiments PATCH - v2 - 2/4] nf_tables: Split IPv4 NAT into NAT expression and IPv4 NAT chain
Date: Thu, 15 Nov 2012 14:25:00 +0200
Message-ID: <1352982302-32402-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1352982302-32402-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24236 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767850Ab2KOOZM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:25:12 -0500
In-Reply-To: <1352982302-32402-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will permit to generalize NAT expression handling for both IPv4 and IPv6.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 net/ipv4/netfilter/Kconfig              |   1 +
 net/ipv4/netfilter/nft_chain_nat_ipv4.c | 162 +-------------------------
 net/netfilter/Kconfig                   |   5 +
 net/netfilter/Makefile                  |   1 +
 net/netfilter/nft_nat.c                 | 198 ++++++++++++++++++++++++++++++++
 5 files changed, 206 insertions(+), 161 deletions(-)
 create mode 100644 net/netfilter/nft_nat.c

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1aefe95..e0ebf2f 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -63,6 +63,7 @@ config NFT_CHAIN_ROUTE_IPV4
 
 config NFT_CHAIN_NAT_IPV4
 	depends on NF_TABLES_IPV4
+	depends on NFT_NAT
 	tristate "IPv4 nf_tables nat chain support"
 
 config IP_NF_IPTABLES
diff --git a/net/ipv4/netfilter/nft_chain_nat_ipv4.c b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
index 95b265b..ce9879e 100644
--- a/net/ipv4/netfilter/nft_chain_nat_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
  * Copyright (c) 2012 Pablo Neira Ayuso <pablo@netfilter.org>
+ * Copyright (c) 2012 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -14,10 +15,8 @@
 #include <linux/list.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
-#include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
-#include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_nat.h>
@@ -26,155 +25,6 @@
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/ip.h>
 
-struct nft_nat {
-	enum nft_registers	sreg_addr_min:8;
-	enum nft_registers	sreg_addr_max:8;
-	enum nft_registers	sreg_proto_min:8;
-	enum nft_registers	sreg_proto_max:8;
-	enum nf_nat_manip_type	type;
-};
-
-static void nft_nat_eval(const struct nft_expr *expr,
-			 struct nft_data data[NFT_REG_MAX + 1],
-			 const struct nft_pktinfo *pkt)
-{
-	const struct nft_nat *priv = nft_expr_priv(expr);
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct = nf_ct_get(pkt->skb, &ctinfo);
-	struct nf_nat_range range;
-
-	memset(&range, 0, sizeof(range));
-	if (priv->sreg_addr_min) {
-		range.min_addr.ip = data[priv->sreg_addr_min].data[0];
-		range.max_addr.ip = data[priv->sreg_addr_max].data[0];
-		range.flags |= NF_NAT_RANGE_MAP_IPS;
-	}
-
-	if (priv->sreg_proto_min) {
-		range.min_proto.all = data[priv->sreg_proto_min].data[0];
-		range.max_proto.all = data[priv->sreg_proto_max].data[0];
-		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
-	}
-
-	data[NFT_REG_VERDICT].verdict =
-		nf_nat_setup_info(ct, &range, priv->type);
-}
-
-static const struct nla_policy nft_nat_policy[NFTA_NAT_MAX + 1] = {
-	[NFTA_NAT_TYPE]          = { .type = NLA_U32 },
-	[NFTA_NAT_REG_ADDR_MIN]  = { .type = NLA_U32 },
-	[NFTA_NAT_REG_ADDR_MAX]  = { .type = NLA_U32 },
-	[NFTA_NAT_REG_PROTO_MIN] = { .type = NLA_U32 },
-	[NFTA_NAT_REG_PROTO_MAX] = { .type = NLA_U32 },
-};
-
-static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
-			const struct nlattr * const tb[])
-{
-	struct nft_nat *priv = nft_expr_priv(expr);
-	int err;
-
-	if (tb[NFTA_NAT_TYPE] == NULL)
-		return -EINVAL;
-
-	switch (ntohl(nla_get_be32(tb[NFTA_NAT_TYPE]))) {
-	case NFT_NAT_SNAT:
-		priv->type = NF_NAT_MANIP_SRC;
-		break;
-	case NFT_NAT_DNAT:
-		priv->type = NF_NAT_MANIP_DST;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (tb[NFTA_NAT_REG_ADDR_MIN]) {
-		priv->sreg_addr_min = ntohl(nla_get_be32(
-						tb[NFTA_NAT_REG_ADDR_MIN]));
-		err = nft_validate_input_register(priv->sreg_addr_min);
-		if (err < 0)
-			return err;
-	}
-
-	if (tb[NFTA_NAT_REG_ADDR_MAX]) {
-		priv->sreg_addr_max = ntohl(nla_get_be32(
-						tb[NFTA_NAT_REG_ADDR_MAX]));
-		err = nft_validate_input_register(priv->sreg_addr_max);
-		if (err < 0)
-			return err;
-	} else
-		priv->sreg_addr_max = priv->sreg_addr_min;
-
-	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
-		priv->sreg_proto_min = ntohl(nla_get_be32(
-						tb[NFTA_NAT_REG_PROTO_MIN]));
-		err = nft_validate_input_register(priv->sreg_proto_min);
-		if (err < 0)
-			return err;
-	}
-
-	if (tb[NFTA_NAT_REG_PROTO_MAX]) {
-		priv->sreg_proto_max = ntohl(nla_get_be32(
-						tb[NFTA_NAT_REG_PROTO_MAX]));
-		err = nft_validate_input_register(priv->sreg_proto_max);
-		if (err < 0)
-			return err;
-	} else
-		priv->sreg_proto_max = priv->sreg_proto_min;
-
-	return 0;
-}
-
-static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
-{
-	const struct nft_nat *priv = nft_expr_priv(expr);
-
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
-	if (nla_put_be32(skb,
-			 NFTA_NAT_REG_ADDR_MIN, htonl(priv->sreg_addr_min)))
-		goto nla_put_failure;
-	if (nla_put_be32(skb,
-			 NFTA_NAT_REG_ADDR_MAX, htonl(priv->sreg_addr_max)))
-		goto nla_put_failure;
-	if (nla_put_be32(skb,
-			 NFTA_NAT_REG_PROTO_MIN, htonl(priv->sreg_proto_min)))
-		goto nla_put_failure;
-	if (nla_put_be32(skb,
-			 NFTA_NAT_REG_PROTO_MAX, htonl(priv->sreg_proto_max)))
-		goto nla_put_failure;
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
-static struct nft_expr_type nft_nat_type;
-static const struct nft_expr_ops nft_nat_ops = {
-	.type		= &nft_nat_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_nat)),
-	.eval		= nft_nat_eval,
-	.init		= nft_nat_init,
-	.dump		= nft_nat_dump,
-};
-
-static struct nft_expr_type nft_nat_type __read_mostly = {
-	.name		= "nat",
-	.ops		= &nft_nat_ops,
-	.policy		= nft_nat_policy,
-	.maxattr	= NFTA_NAT_MAX,
-	.owner		= THIS_MODULE,
-};
-
 /*
  * NAT chains
  */
@@ -335,20 +185,11 @@ static int __init nft_chain_nat_init(void)
 	if (err < 0)
 		return err;
 
-	err = nft_register_expr(&nft_nat_type);
-	if (err < 0)
-		goto err;
-
 	return 0;
-
-err:
-	nft_unregister_chain_type(&nft_chain_nat_ipv4);
-	return err;
 }
 
 static void __exit nft_chain_nat_exit(void)
 {
-	nft_unregister_expr(&nft_nat_type);
 	nft_unregister_chain_type(&nft_chain_nat_ipv4);
 }
 
@@ -358,4 +199,3 @@ module_exit(nft_chain_nat_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_CHAIN(AF_INET, "nat");
-MODULE_ALIAS_NFT_EXPR("nat");
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 95d2907..9ba8d0e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -469,6 +469,11 @@ config NFT_LIMIT
        depends on NF_TABLES
        tristate "Netfilter nf_tables limit module"
 
+config NFT_NAT
+       depends on NF_TABLES
+       depends on NF_CONNTRACK
+       tristate "Netfilter nf_tables nat module"
+
 if NETFILTER_XTABLES
 
 comment "Xtables combined modules"
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 62d1a0f..1e9b653 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_NFT_EXTHDR)	+= nft_exthdr.o
 obj-$(CONFIG_NFT_META)		+= nft_meta.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
 obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
+obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
 #nf_tables-objs			+= nft_meta_target.o
 obj-$(CONFIG_NFT_RBTREE)	+= nft_rbtree.o
 obj-$(CONFIG_NFT_HASH)		+= nft_hash.o
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
new file mode 100644
index 0000000..ea9854e
--- /dev/null
+++ b/net/netfilter/nft_nat.c
@@ -0,0 +1,198 @@
+/*
+ * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
+ * Copyright (c) 2012 Pablo Neira Ayuso <pablo@netfilter.org>
+ * Copyright (c) 2012 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_core.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_nat_l3proto.h>
+#include <net/ip.h>
+
+struct nft_nat {
+	enum nft_registers      sreg_addr_min:8;
+	enum nft_registers      sreg_addr_max:8;
+	enum nft_registers      sreg_proto_min:8;
+	enum nft_registers      sreg_proto_max:8;
+	enum nf_nat_manip_type  type;
+};
+
+static void nft_nat_eval(const struct nft_expr *expr,
+			 struct nft_data data[NFT_REG_MAX + 1],
+			 const struct nft_pktinfo *pkt)
+{
+	const struct nft_nat *priv = nft_expr_priv(expr);
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(pkt->skb, &ctinfo);
+	struct nf_nat_range range;
+
+	memset(&range, 0, sizeof(range));
+	if (priv->sreg_addr_min) {
+		range.min_addr.ip = data[priv->sreg_addr_min].data[0];
+		range.max_addr.ip = data[priv->sreg_addr_max].data[0];
+		range.flags |= NF_NAT_RANGE_MAP_IPS;
+	}
+
+	if (priv->sreg_proto_min) {
+		range.min_proto.all = data[priv->sreg_proto_min].data[0];
+		range.max_proto.all = data[priv->sreg_proto_max].data[0];
+		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+	}
+
+	data[NFT_REG_VERDICT].verdict =
+		nf_nat_setup_info(ct, &range, priv->type);
+}
+
+static const struct nla_policy nft_nat_policy[NFTA_NAT_MAX + 1] = {
+	[NFTA_NAT_TYPE]		 = { .type = NLA_U32 },
+	[NFTA_NAT_REG_ADDR_MIN]	 = { .type = NLA_U32 },
+	[NFTA_NAT_REG_ADDR_MAX]	 = { .type = NLA_U32 },
+	[NFTA_NAT_REG_PROTO_MIN] = { .type = NLA_U32 },
+	[NFTA_NAT_REG_PROTO_MAX] = { .type = NLA_U32 },
+};
+
+static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
+			const struct nlattr * const tb[])
+{
+	struct nft_nat *priv = nft_expr_priv(expr);
+	int err;
+
+	if (tb[NFTA_NAT_TYPE] == NULL)
+		return -EINVAL;
+
+	switch (ntohl(nla_get_be32(tb[NFTA_NAT_TYPE]))) {
+	case NFT_NAT_SNAT:
+		priv->type = NF_NAT_MANIP_SRC;
+		break;
+	case NFT_NAT_DNAT:
+		priv->type = NF_NAT_MANIP_DST;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (tb[NFTA_NAT_REG_ADDR_MIN]) {
+		priv->sreg_addr_min = ntohl(nla_get_be32(
+						tb[NFTA_NAT_REG_ADDR_MIN]));
+		err = nft_validate_input_register(priv->sreg_addr_min);
+		if (err < 0)
+			return err;
+	}
+
+	if (tb[NFTA_NAT_REG_ADDR_MAX]) {
+		priv->sreg_addr_max = ntohl(nla_get_be32(
+						tb[NFTA_NAT_REG_ADDR_MAX]));
+		err = nft_validate_input_register(priv->sreg_addr_max);
+		if (err < 0)
+			return err;
+	} else
+		priv->sreg_addr_max = priv->sreg_addr_min;
+
+	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
+		priv->sreg_proto_min = ntohl(nla_get_be32(
+						tb[NFTA_NAT_REG_PROTO_MIN]));
+		err = nft_validate_input_register(priv->sreg_proto_min);
+		if (err < 0)
+			return err;
+	}
+
+	if (tb[NFTA_NAT_REG_PROTO_MAX]) {
+		priv->sreg_proto_max = ntohl(nla_get_be32(
+						tb[NFTA_NAT_REG_PROTO_MAX]));
+		err = nft_validate_input_register(priv->sreg_proto_max);
+		if (err < 0)
+			return err;
+	} else
+		priv->sreg_proto_max = priv->sreg_proto_min;
+
+	return 0;
+}
+
+static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_nat *priv = nft_expr_priv(expr);
+
+	switch (priv->type) {
+	case NF_NAT_MANIP_SRC:
+		if (nla_put_be32(skb, NFTA_NAT_TYPE, htonl(NFT_NAT_SNAT)))
+			goto nla_put_failure;
+		break;
+	case NF_NAT_MANIP_DST:
+		if (nla_put_be32(skb, NFTA_NAT_TYPE, htonl(NFT_NAT_DNAT)))
+			goto nla_put_failure;
+		break;
+	}
+
+	if (nla_put_be32(skb,
+			 NFTA_NAT_REG_ADDR_MIN, htonl(priv->sreg_addr_min)))
+		goto nla_put_failure;
+	if (nla_put_be32(skb,
+			 NFTA_NAT_REG_ADDR_MAX, htonl(priv->sreg_addr_max)))
+		goto nla_put_failure;
+	if (nla_put_be32(skb,
+			 NFTA_NAT_REG_PROTO_MIN, htonl(priv->sreg_proto_min)))
+		goto nla_put_failure;
+	if (nla_put_be32(skb,
+			 NFTA_NAT_REG_PROTO_MAX, htonl(priv->sreg_proto_max)))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nft_expr_type nft_nat_type;
+static const struct nft_expr_ops nft_nat_ops = {
+	.type           = &nft_nat_type,
+	.size           = NFT_EXPR_SIZE(sizeof(struct nft_nat)),
+	.eval           = nft_nat_eval,
+	.init           = nft_nat_init,
+	.dump           = nft_nat_dump,
+};
+
+static struct nft_expr_type nft_nat_type __read_mostly = {
+	.name           = "nat",
+	.ops            = &nft_nat_ops,
+	.policy         = nft_nat_policy,
+	.maxattr        = NFTA_NAT_MAX,
+	.owner          = THIS_MODULE,
+};
+
+static int __init nft_nat_module_init(void)
+{
+	int err;
+
+	err = nft_register_expr(&nft_nat_type);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static void __exit nft_nat_module_exit(void)
+{
+	nft_unregister_expr(&nft_nat_type);
+}
+
+module_init(nft_nat_module_init);
+module_exit(nft_nat_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>");
+MODULE_ALIAS_NFT_EXPR("nat");
-- 
1.8.0

