From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH] netfilter: nf_tables: add new nft_masq expression
Date: Mon, 08 Sep 2014 13:45:00 +0200
Message-ID: <20140908114434.19694.17538.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47892 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753582AbaIHLpJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:45:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nft_masq expression is intended to perform NAT in the masquerade flavour.

We decided to have the masquerade functionality in a separated expression other
than nft_nat.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
Note: this patch applies on top of the previously sent series regarding masquerade.

 include/net/netfilter/nft_masq.h         |   16 +++++
 include/uapi/linux/netfilter/nf_tables.h |   12 ++++
 net/ipv4/netfilter/Kconfig               |    6 ++
 net/ipv4/netfilter/Makefile              |    1 
 net/ipv4/netfilter/nft_masq_ipv4.c       |   92 ++++++++++++++++++++++++++++++
 net/ipv6/netfilter/Kconfig               |    6 ++
 net/ipv6/netfilter/Makefile              |    1 
 net/ipv6/netfilter/nft_masq_ipv6.c       |   92 ++++++++++++++++++++++++++++++
 net/netfilter/Kconfig                    |    9 +++
 net/netfilter/Makefile                   |    1 
 net/netfilter/nft_masq.c                 |   60 ++++++++++++++++++++
 11 files changed, 296 insertions(+)
 create mode 100644 include/net/netfilter/nft_masq.h
 create mode 100644 net/ipv4/netfilter/nft_masq_ipv4.c
 create mode 100644 net/ipv6/netfilter/nft_masq_ipv6.c
 create mode 100644 net/netfilter/nft_masq.c

diff --git a/include/net/netfilter/nft_masq.h b/include/net/netfilter/nft_masq.h
new file mode 100644
index 0000000..c72729f
--- /dev/null
+++ b/include/net/netfilter/nft_masq.h
@@ -0,0 +1,16 @@
+#ifndef _NFT_MASQ_H_
+#define _NFT_MASQ_H_
+
+struct nft_masq {
+	u32	flags;
+};
+
+extern const struct nla_policy nft_masq_policy[];
+
+int nft_masq_init(const struct nft_ctx *ctx,
+		  const struct nft_expr *expr,
+		  const struct nlattr * const tb[]);
+
+int nft_masq_dump(struct sk_buff *skb, const struct nft_expr *expr);
+
+#endif /* _NFT_MASQ_H_ */
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 62ea48d..9bbcb7b 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -800,4 +800,16 @@ enum nft_nat_attributes {
 };
 #define NFTA_NAT_MAX		(__NFTA_NAT_MAX - 1)
 
+/**
+ * enum nft_masq_attributes - nf_tables masquerade expression attributes
+ *
+ * @NFTA_MASQ_FLAGS: additional masquerade configuration (NF_NAT_RANGE_*) (NLA_U32)
+ */
+enum nft_masq_attributes {
+	NFTA_MASQ_FLAGS,
+	__NFTA_MASQ_MAX
+};
+#define NFTA_MASQ_MAX		(__NFTA_MASQ_MAX - 1)
+
+
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 4be3e54..a297e29 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -190,6 +190,12 @@ config NF_NAT_MASQUERADE_IPV4
 	This is the kernel functionality to provide NAT in the masquerade
 	flavour (automatic source address selection).
 
+config NFT_MASQ_IPV4
+	tristate "nft_masq IPv4 support"
+	depends on NF_TABLES_IPV4
+	depends on NFT_MASQ
+	select NF_NAT_MASQUERADE_IPV4
+
 config IP_NF_TARGET_MASQUERADE
 	tristate "MASQUERADE target support"
 	select NF_NAT_MASQUERADE_IPV4
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 42056b2..7d019ae 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_NF_TABLES_IPV4) += nf_tables_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
 obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
+obj-$(CONFIG_NFT_MASQ_IPV4) += nft_masq_ipv4.o
 obj-$(CONFIG_NF_TABLES_ARP) += nf_tables_arp.o
 
 # generic IP tables 
diff --git a/net/ipv4/netfilter/nft_masq_ipv4.c b/net/ipv4/netfilter/nft_masq_ipv4.c
new file mode 100644
index 0000000..39b2c71
--- /dev/null
+++ b/net/ipv4/netfilter/nft_masq_ipv4.c
@@ -0,0 +1,92 @@
+/*
+ * Copyright (c) 2014 - Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nft_masq.h>
+#include <net/netfilter/ipv4/nf_nat_masquerade_ipv4.h>
+
+static void nft_masq_ipv4_eval(const struct nft_expr *expr,
+			       struct nft_data data[NFT_REG_MAX + 1],
+			       const struct nft_pktinfo *pkt)
+{
+	struct nft_masq *priv = nft_expr_priv(expr);
+	struct nf_nat_range range;
+	unsigned int verdict;
+
+	range.flags = priv->flags;
+
+	verdict = nf_nat_masquerade_ipv4(pkt->skb, pkt->ops->hooknum,
+					 &range, pkt->out);
+
+	data[NFT_REG_VERDICT].verdict = verdict;
+}
+
+static int nft_masq_ipv4_init(const struct nft_ctx *ctx,
+			      const struct nft_expr *expr,
+			      const struct nlattr * const tb[])
+{
+	int err;
+
+	err = nft_masq_init(ctx, expr, tb);
+	if (err < 0)
+		goto out;
+
+	nf_nat_masquerade_ipv4_register_notifier();
+
+out:
+	return err;
+}
+
+static void nft_masq_ipv4_destroy(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr)
+{
+	nf_nat_masquerade_ipv4_unregister_notifier();
+}
+
+static struct nft_expr_type nft_masq_ipv4_type;
+static const struct nft_expr_ops nft_masq_ipv4_ops = {
+	.type		= &nft_masq_ipv4_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_masq)),
+	.eval		= nft_masq_ipv4_eval,
+	.init		= nft_masq_ipv4_init,
+	.destroy	= nft_masq_ipv4_destroy,
+	.dump		= nft_masq_dump,
+};
+
+static struct nft_expr_type nft_masq_ipv4_type __read_mostly = {
+	.family		= NFPROTO_IPV4,
+	.name		= "masq",
+	.ops		= &nft_masq_ipv4_ops,
+	.policy		= nft_masq_policy,
+	.maxattr	= NFTA_MASQ_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_masq_ipv4_module_init(void)
+{
+	return nft_register_expr(&nft_masq_ipv4_type);
+}
+
+static void __exit nft_masq_ipv4_module_exit(void)
+{
+	nft_unregister_expr(&nft_masq_ipv4_type);
+}
+
+module_init(nft_masq_ipv4_module_init);
+module_exit(nft_masq_ipv4_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "masq");
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 6c8cfec..17578a8 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -252,6 +252,12 @@ config NF_NAT_MASQUERADE_IPV6
 	 This is the kernel functionality to provide NAT in the masquerade
 	 flavour (automatic source address selection) for IPv6.
 
+config NFT_MASQ_IPV6
+	tristate "nft_masq IPv6 support"
+	depends on NF_TABLES_IPV6
+	depends on NFT_MASQ
+	select NF_NAT_MASQUERADE_IPV6
+
 config IP6_NF_TARGET_MASQUERADE
 	tristate "MASQUERADE target support"
 	select NF_NAT_MASQUERADE_IPV6
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 89a0bd7..482c4df 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_NF_TABLES_IPV6) += nf_tables_ipv6.o
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV6) += nft_chain_route_ipv6.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV6) += nft_chain_nat_ipv6.o
 obj-$(CONFIG_NFT_REJECT_IPV6) += nft_reject_ipv6.o
+obj-$(CONFIG_NFT_MASQ_IPV6) += nft_masq_ipv6.o
 
 # matches
 obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
diff --git a/net/ipv6/netfilter/nft_masq_ipv6.c b/net/ipv6/netfilter/nft_masq_ipv6.c
new file mode 100644
index 0000000..5c46e7e
--- /dev/null
+++ b/net/ipv6/netfilter/nft_masq_ipv6.c
@@ -0,0 +1,92 @@
+/*
+ * Copyright (c) 2014 - Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nft_masq.h>
+#include <net/netfilter/ipv6/nf_nat_masquerade_ipv6.h>
+
+static void nft_masq_ipv6_eval(const struct nft_expr *expr,
+			       struct nft_data data[NFT_REG_MAX + 1],
+			       const struct nft_pktinfo *pkt)
+{
+	struct nft_masq *priv = nft_expr_priv(expr);
+	struct nf_nat_range range;
+	unsigned int verdict;
+
+	range.flags = priv->flags;
+
+	verdict = nf_nat_masquerade_ipv6(pkt->skb, &range, pkt->out);
+
+	data[NFT_REG_VERDICT].verdict = verdict;
+}
+
+static int nft_masq_ipv6_init(const struct nft_ctx *ctx,
+			      const struct nft_expr *expr,
+			      const struct nlattr * const tb[])
+{
+	int err;
+
+	err = nft_masq_init(ctx, expr, tb);
+	if (err < 0)
+		goto out;
+
+	nf_nat_masquerade_ipv6_register_notifier();
+
+out:
+	return err;
+}
+
+static void nft_masq_ipv6_destroy(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr)
+{
+	nf_nat_masquerade_ipv6_unregister_notifier();
+}
+
+static struct nft_expr_type nft_masq_ipv6_type;
+static const struct nft_expr_ops nft_masq_ipv6_ops = {
+	.type		= &nft_masq_ipv6_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_masq)),
+	.eval		= nft_masq_ipv6_eval,
+	.init		= nft_masq_ipv6_init,
+	.destroy	= nft_masq_ipv6_destroy,
+	.dump		= nft_masq_dump,
+};
+
+static struct nft_expr_type nft_masq_ipv6_type __read_mostly = {
+	.family		= NFPROTO_IPV6,
+	.name		= "masq",
+	.ops		= &nft_masq_ipv6_ops,
+	.policy		= nft_masq_policy,
+	.maxattr	= NFTA_MASQ_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_masq_ipv6_module_init(void)
+{
+	return nft_register_expr(&nft_masq_ipv6_type);
+}
+
+static void __exit nft_masq_ipv6_module_exit(void)
+{
+	nft_unregister_expr(&nft_masq_ipv6_type);
+}
+
+module_init(nft_masq_ipv6_module_init);
+module_exit(nft_masq_ipv6_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "masq");
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ad751fe..33003e4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -528,6 +528,15 @@ config NFT_REJECT_INET
 	default NFT_REJECT
 	tristate
 
+config NFT_MASQ
+	depends on NF_TABLES
+	depends on NF_CONNTRACK
+	depends on NF_NAT
+	tristate "Netfilter nf_tables masquerade support"
+	help
+	  This options adds the "masquerade" expression that you can use
+	  to perform NAT in the masquerade flavour.
+
 config NFT_COMPAT
 	depends on NF_TABLES
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 8308624..0637792 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -87,6 +87,7 @@ obj-$(CONFIG_NFT_RBTREE)	+= nft_rbtree.o
 obj-$(CONFIG_NFT_HASH)		+= nft_hash.o
 obj-$(CONFIG_NFT_COUNTER)	+= nft_counter.o
 obj-$(CONFIG_NFT_LOG)		+= nft_log.o
+obj-$(CONFIG_NFT_MASQ)		+= nft_masq.o
 
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
new file mode 100644
index 0000000..62f55a2
--- /dev/null
+++ b/net/netfilter/nft_masq.c
@@ -0,0 +1,60 @@
+/*
+ * Copyright (c) 2014 - Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nft_masq.h>
+
+const struct nla_policy nft_masq_policy[NFTA_MASQ_MAX + 1] = {
+	[NFTA_MASQ_FLAGS]		= { .type = NLA_U32 },
+};
+EXPORT_SYMBOL_GPL(nft_masq_policy);
+
+int nft_masq_init(const struct nft_ctx *ctx,
+		  const struct nft_expr *expr,
+		  const struct nlattr * const tb[])
+{
+	struct nft_masq *priv = nft_expr_priv(expr);
+
+	if (tb[NFTA_MASQ_FLAGS] == NULL)
+		return 0;
+
+	priv->flags = ntohl(nla_get_be32(tb[NFTA_MASQ_FLAGS]));
+	if (priv->flags & ~NF_NAT_RANGE_MASK)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nft_masq_init);
+
+int nft_masq_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_masq *priv = nft_expr_priv(expr);
+
+	if (priv->flags == 0)
+		return 0;
+
+	if (nla_put_be32(skb, NFTA_MASQ_FLAGS, htonl(priv->flags)))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+EXPORT_SYMBOL_GPL(nft_masq_dump);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");

