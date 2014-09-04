From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH v4 4/5] netfilter: nft_nat: split code in AF parts
Date: Thu, 04 Sep 2014 14:07:04 +0200
Message-ID: <20140904120654.5971.51667.stgit@nfdev.cica.es>
References: <20140904120518.5971.77791.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:56167 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753774AbaIDMHT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:07:19 -0400
In-Reply-To: <20140904120518.5971.77791.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch refactorices the nft_nat code into AF specific parts,
allowing further work in the AF specific zones, like adding masquerade support.

While at it, fix coding style in several places.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: no changes.
v3: flags is u16. This also applies to the patch 1/5. Common _dump() function.
v4: nf-next rebased.

 include/net/netfilter/nft_nat.h   |   22 ++++++
 net/ipv4/netfilter/Kconfig        |    7 ++
 net/ipv4/netfilter/Makefile       |    1 
 net/ipv4/netfilter/nft_nat_ipv4.c |   98 ++++++++++++++++++++++++++++
 net/ipv6/netfilter/Kconfig        |    7 ++
 net/ipv6/netfilter/Makefile       |    1 
 net/ipv6/netfilter/nft_nat_ipv6.c |   98 ++++++++++++++++++++++++++++
 net/netfilter/nft_nat.c           |  129 +++++++------------------------------
 8 files changed, 260 insertions(+), 103 deletions(-)
 create mode 100644 include/net/netfilter/nft_nat.h
 create mode 100644 net/ipv4/netfilter/nft_nat_ipv4.c
 create mode 100644 net/ipv6/netfilter/nft_nat_ipv6.c

diff --git a/include/net/netfilter/nft_nat.h b/include/net/netfilter/nft_nat.h
new file mode 100644
index 0000000..0ac1546
--- /dev/null
+++ b/include/net/netfilter/nft_nat.h
@@ -0,0 +1,22 @@
+#ifndef _NFT_NAT_H_
+#define _NFT_NAT_H_
+
+struct nft_nat {
+	enum nft_registers      sreg_addr_min:8;
+	enum nft_registers      sreg_addr_max:8;
+	enum nft_registers      sreg_proto_min:8;
+	enum nft_registers      sreg_proto_max:8;
+	enum nf_nat_manip_type  type:8;
+	u8			family;
+	u16			flags;
+};
+
+extern const struct nla_policy nft_nat_policy[];
+
+int nft_nat_init(const struct nft_ctx *ctx,
+		 const struct nft_expr *expr,
+		 const struct nlattr * const tb[]);
+
+int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr);
+
+#endif /* _NFT_NAT_H_ */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 4be3e54..8167f31 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -190,6 +190,13 @@ config NF_NAT_MASQUERADE_IPV4
 	This is the kernel functionality to provide NAT in the masquerade
 	flavour (automatic source address selection).
 
+config NFT_NAT_IPV4
+	tristate "nft_nat IPv4 support"
+	depends on NFT_NAT
+	select NF_NAT_MASQUERADE_IPV4
+	help
+	  This is the nftables expression that handles NAT in IPv4.
+
 config IP_NF_TARGET_MASQUERADE
 	tristate "MASQUERADE target support"
 	select NF_NAT_MASQUERADE_IPV4
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 42056b2..4ad0a40 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_NF_TABLES_IPV4) += nf_tables_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
 obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
+obj-$(CONFIG_NFT_NAT_IPV4) += nft_nat_ipv4.o
 obj-$(CONFIG_NF_TABLES_ARP) += nf_tables_arp.o
 
 # generic IP tables 
diff --git a/net/ipv4/netfilter/nft_nat_ipv4.c b/net/ipv4/netfilter/nft_nat_ipv4.c
new file mode 100644
index 0000000..feba0eb
--- /dev/null
+++ b/net/ipv4/netfilter/nft_nat_ipv4.c
@@ -0,0 +1,98 @@
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
+#include <linux/string.h>
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
+#include <net/netfilter/nft_nat.h>
+#include <net/netfilter/ipv4/nf_nat_masquerade_ipv4.h>
+
+static void nft_nat_ipv4_eval(const struct nft_expr *expr,
+			      struct nft_data data[NFT_REG_MAX + 1],
+			      const struct nft_pktinfo *pkt)
+{
+	const struct nft_nat *priv = nft_expr_priv(expr);
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(pkt->skb, &ctinfo);
+	struct nf_nat_range range;
+
+	memset(&range, 0, sizeof(range));
+	if (priv->sreg_addr_min) {
+		range.min_addr.ip =
+			(__force __be32)data[priv->sreg_addr_min].data[0];
+		range.max_addr.ip =
+			(__force __be32)data[priv->sreg_addr_max].data[0];
+
+		range.flags |= NF_NAT_RANGE_MAP_IPS;
+	}
+
+	if (priv->sreg_proto_min) {
+		range.min_proto.all =
+			(__force __be16)data[priv->sreg_proto_min].data[0];
+		range.max_proto.all =
+			(__force __be16)data[priv->sreg_proto_max].data[0];
+
+		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+	}
+
+	range.flags |= priv->flags;
+
+	data[NFT_REG_VERDICT].verdict =
+				nf_nat_setup_info(ct, &range, priv->type);
+}
+
+static struct nft_expr_type nft_nat_ipv4_type;
+static const struct nft_expr_ops nft_nat_ipv4_ops = {
+	.type           = &nft_nat_ipv4_type,
+	.size           = NFT_EXPR_SIZE(sizeof(struct nft_nat)),
+	.eval           = nft_nat_ipv4_eval,
+	.init           = nft_nat_init,
+	.dump           = nft_nat_dump,
+};
+
+static struct nft_expr_type nft_nat_ipv4_type __read_mostly = {
+	.family		= NFPROTO_IPV4,
+	.name           = "nat",
+	.ops            = &nft_nat_ipv4_ops,
+	.policy         = nft_nat_policy,
+	.maxattr        = NFTA_NAT_MAX,
+	.owner          = THIS_MODULE,
+};
+
+static int __init nft_nat_ipv4_module_init(void)
+{
+	return nft_register_expr(&nft_nat_ipv4_type);
+}
+
+static void __exit nft_nat_ipv4_module_exit(void)
+{
+	nft_unregister_expr(&nft_nat_ipv4_type);
+}
+
+module_init(nft_nat_ipv4_module_init);
+module_exit(nft_nat_ipv4_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "nat");
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 6c8cfec..c8f1daf 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -252,6 +252,13 @@ config NF_NAT_MASQUERADE_IPV6
 	 This is the kernel functionality to provide NAT in the masquerade
 	 flavour (automatic source address selection) for IPv6.
 
+config NFT_NAT_IPV6
+	tristate "nft_nat IPv6 support"
+	depends on NFT_NAT
+	select NF_NAT_MASQUERADE_IPV6
+	help
+	 This is the nftables expression that handles NAT in IPv6.
+
 config IP6_NF_TARGET_MASQUERADE
 	tristate "MASQUERADE target support"
 	select NF_NAT_MASQUERADE_IPV6
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 89a0bd7..43dc399 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_NF_TABLES_IPV6) += nf_tables_ipv6.o
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV6) += nft_chain_route_ipv6.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV6) += nft_chain_nat_ipv6.o
 obj-$(CONFIG_NFT_REJECT_IPV6) += nft_reject_ipv6.o
+obj-$(CONFIG_NFT_NAT_IPV6) += nft_nat_ipv6.o
 
 # matches
 obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
diff --git a/net/ipv6/netfilter/nft_nat_ipv6.c b/net/ipv6/netfilter/nft_nat_ipv6.c
new file mode 100644
index 0000000..1bcc578
--- /dev/null
+++ b/net/ipv6/netfilter/nft_nat_ipv6.c
@@ -0,0 +1,98 @@
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
+#include <linux/string.h>
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
+#include <net/netfilter/nft_nat.h>
+
+static void nft_nat_ipv6_eval(const struct nft_expr *expr,
+			      struct nft_data data[NFT_REG_MAX + 1],
+			      const struct nft_pktinfo *pkt)
+{
+	const struct nft_nat *priv = nft_expr_priv(expr);
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(pkt->skb, &ctinfo);
+	struct nf_nat_range range;
+
+	memset(&range, 0, sizeof(range));
+	if (priv->sreg_addr_min) {
+		memcpy(range.min_addr.ip6,
+		       data[priv->sreg_addr_min].data,
+		       sizeof(struct nft_data));
+		memcpy(range.max_addr.ip6,
+		       data[priv->sreg_addr_max].data,
+		       sizeof(struct nft_data));
+		range.flags |= NF_NAT_RANGE_MAP_IPS;
+	}
+
+	if (priv->sreg_proto_min) {
+		range.min_proto.all =
+			(__force __be16)data[priv->sreg_proto_min].data[0];
+		range.max_proto.all =
+			(__force __be16)data[priv->sreg_proto_max].data[0];
+
+		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+	}
+
+	range.flags |= priv->flags;
+
+	data[NFT_REG_VERDICT].verdict =
+				nf_nat_setup_info(ct, &range, priv->type);
+}
+
+static struct nft_expr_type nft_nat_ipv6_type;
+static const struct nft_expr_ops nft_nat_ipv6_ops = {
+	.type           = &nft_nat_ipv6_type,
+	.size           = NFT_EXPR_SIZE(sizeof(struct nft_nat)),
+	.eval           = nft_nat_ipv6_eval,
+	.init           = nft_nat_init,
+	.dump           = nft_nat_dump,
+};
+
+static struct nft_expr_type nft_nat_ipv6_type __read_mostly = {
+	.family		= NFPROTO_IPV6,
+	.name           = "nat",
+	.ops            = &nft_nat_ipv6_ops,
+	.policy         = nft_nat_policy,
+	.maxattr        = NFTA_NAT_MAX,
+	.owner          = THIS_MODULE,
+};
+
+static int __init nft_nat_ipv6_module_init(void)
+{
+	return nft_register_expr(&nft_nat_ipv6_type);
+}
+
+static void __exit nft_nat_ipv6_module_exit(void)
+{
+	nft_unregister_expr(&nft_nat_ipv6_type);
+}
+
+module_init(nft_nat_ipv6_module_init);
+module_exit(nft_nat_ipv6_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "nat");
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 799550b..fc3f8c8 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -25,60 +25,9 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/ip.h>
+#include <net/netfilter/nft_nat.h>
 
-struct nft_nat {
-	enum nft_registers      sreg_addr_min:8;
-	enum nft_registers      sreg_addr_max:8;
-	enum nft_registers      sreg_proto_min:8;
-	enum nft_registers      sreg_proto_max:8;
-	enum nf_nat_manip_type  type:8;
-	u8			family;
-	u16			flags;
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
-		if (priv->family == AF_INET) {
-			range.min_addr.ip = (__force __be32)
-					data[priv->sreg_addr_min].data[0];
-			range.max_addr.ip = (__force __be32)
-					data[priv->sreg_addr_max].data[0];
-
-		} else {
-			memcpy(range.min_addr.ip6,
-			       data[priv->sreg_addr_min].data,
-			       sizeof(struct nft_data));
-			memcpy(range.max_addr.ip6,
-			       data[priv->sreg_addr_max].data,
-			       sizeof(struct nft_data));
-		}
-		range.flags |= NF_NAT_RANGE_MAP_IPS;
-	}
-
-	if (priv->sreg_proto_min) {
-		range.min_proto.all = (__force __be16)
-					data[priv->sreg_proto_min].data[0];
-		range.max_proto.all = (__force __be16)
-					data[priv->sreg_proto_max].data[0];
-		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
-	}
-
-	range.flags |= priv->flags;
-
-	data[NFT_REG_VERDICT].verdict =
-		nf_nat_setup_info(ct, &range, priv->type);
-}
-
-static const struct nla_policy nft_nat_policy[NFTA_NAT_MAX + 1] = {
+const struct nla_policy nft_nat_policy[NFTA_NAT_MAX + 1] = {
 	[NFTA_NAT_TYPE]		 = { .type = NLA_U32 },
 	[NFTA_NAT_FAMILY]	 = { .type = NLA_U32 },
 	[NFTA_NAT_REG_ADDR_MIN]	 = { .type = NLA_U32 },
@@ -87,9 +36,10 @@ static const struct nla_policy nft_nat_policy[NFTA_NAT_MAX + 1] = {
 	[NFTA_NAT_REG_PROTO_MAX] = { .type = NLA_U32 },
 	[NFTA_NAT_FLAGS]	 = { .type = NLA_U32 },
 };
+EXPORT_SYMBOL_GPL(nft_nat_policy);
 
-static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
-			const struct nlattr * const tb[])
+int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
+		 const struct nlattr * const tb[])
 {
 	struct nft_nat *priv = nft_expr_priv(expr);
 	u32 family;
@@ -120,16 +70,18 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	priv->family = family;
 
 	if (tb[NFTA_NAT_REG_ADDR_MIN]) {
-		priv->sreg_addr_min = ntohl(nla_get_be32(
-						tb[NFTA_NAT_REG_ADDR_MIN]));
+		priv->sreg_addr_min =
+				ntohl(nla_get_be32(tb[NFTA_NAT_REG_ADDR_MIN]));
+
 		err = nft_validate_input_register(priv->sreg_addr_min);
 		if (err < 0)
 			return err;
 	}
 
 	if (tb[NFTA_NAT_REG_ADDR_MAX]) {
-		priv->sreg_addr_max = ntohl(nla_get_be32(
-						tb[NFTA_NAT_REG_ADDR_MAX]));
+		priv->sreg_addr_max =
+				ntohl(nla_get_be32(tb[NFTA_NAT_REG_ADDR_MAX]));
+
 		err = nft_validate_input_register(priv->sreg_addr_max);
 		if (err < 0)
 			return err;
@@ -137,16 +89,18 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		priv->sreg_addr_max = priv->sreg_addr_min;
 
 	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
-		priv->sreg_proto_min = ntohl(nla_get_be32(
-						tb[NFTA_NAT_REG_PROTO_MIN]));
+		priv->sreg_proto_min =
+			ntohl(nla_get_be32(tb[NFTA_NAT_REG_PROTO_MIN]));
+
 		err = nft_validate_input_register(priv->sreg_proto_min);
 		if (err < 0)
 			return err;
 	}
 
 	if (tb[NFTA_NAT_REG_PROTO_MAX]) {
-		priv->sreg_proto_max = ntohl(nla_get_be32(
-						tb[NFTA_NAT_REG_PROTO_MAX]));
+		priv->sreg_proto_max =
+			ntohl(nla_get_be32(tb[NFTA_NAT_REG_PROTO_MAX]));
+
 		err = nft_validate_input_register(priv->sreg_proto_max);
 		if (err < 0)
 			return err;
@@ -161,8 +115,9 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nft_nat_init);
 
-static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
+int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_nat *priv = nft_expr_priv(expr);
 
@@ -185,14 +140,12 @@ static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (nla_put_be32(skb,
 			 NFTA_NAT_REG_ADDR_MAX, htonl(priv->sreg_addr_max)))
 		goto nla_put_failure;
-	if (priv->sreg_proto_min) {
-		if (nla_put_be32(skb, NFTA_NAT_REG_PROTO_MIN,
-				 htonl(priv->sreg_proto_min)))
-			goto nla_put_failure;
-		if (nla_put_be32(skb, NFTA_NAT_REG_PROTO_MAX,
-				 htonl(priv->sreg_proto_max)))
-			goto nla_put_failure;
-	}
+	if (nla_put_be32(skb,
+			 NFTA_NAT_REG_PROTO_MIN, htonl(priv->sreg_proto_min)))
+		goto nla_put_failure;
+	if (nla_put_be32(skb,
+			 NFTA_NAT_REG_PROTO_MAX, htonl(priv->sreg_proto_max)))
+		goto nla_put_failure;
 
 	if (priv->flags != 0) {
 		if (nla_put_be32(skb, NFTA_NAT_FLAGS, htonl(priv->flags)))
@@ -204,37 +157,7 @@ static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
 nla_put_failure:
 	return -1;
 }
-
-static struct nft_expr_type nft_nat_type;
-static const struct nft_expr_ops nft_nat_ops = {
-	.type           = &nft_nat_type,
-	.size           = NFT_EXPR_SIZE(sizeof(struct nft_nat)),
-	.eval           = nft_nat_eval,
-	.init           = nft_nat_init,
-	.dump           = nft_nat_dump,
-};
-
-static struct nft_expr_type nft_nat_type __read_mostly = {
-	.name           = "nat",
-	.ops            = &nft_nat_ops,
-	.policy         = nft_nat_policy,
-	.maxattr        = NFTA_NAT_MAX,
-	.owner          = THIS_MODULE,
-};
-
-static int __init nft_nat_module_init(void)
-{
-	return nft_register_expr(&nft_nat_type);
-}
-
-static void __exit nft_nat_module_exit(void)
-{
-	nft_unregister_expr(&nft_nat_type);
-}
-
-module_init(nft_nat_module_init);
-module_exit(nft_nat_module_exit);
+EXPORT_SYMBOL_GPL(nft_nat_dump);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>");
-MODULE_ALIAS_NFT_EXPR("nat");

