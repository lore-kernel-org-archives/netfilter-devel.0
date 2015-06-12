From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 4/4] netfilter: nf_tables: add nft_tee expression
Date: Fri, 12 Jun 2015 13:59:38 +0200
Message-ID: <1434110378-6284-3-git-send-email-pablo@netfilter.org>
References: <1434110378-6284-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46505 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbbFLLy3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 07:54:29 -0400
In-Reply-To: <1434110378-6284-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new expression uses the nf_tee engine to redirect packets to a
given gateway.

It should be possible to reduce memory consumption using select_ops(),
this would make it more complicated to share code with x_tables though.
Since I expect little rules using this expression, I think it's fine to
start with this approach.

Based on original work from Arturo Borrero Gonzalez.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nft_tee.h          |   12 +++++
 include/uapi/linux/netfilter/nf_tables.h |   14 ++++++
 net/ipv4/netfilter/Kconfig               |    7 +++
 net/ipv4/netfilter/Makefile              |    1 +
 net/ipv4/netfilter/nft_tee_ipv4.c        |   81 ++++++++++++++++++++++++++++++
 net/ipv6/netfilter/Kconfig               |    7 +++
 net/ipv6/netfilter/Makefile              |    1 +
 net/ipv6/netfilter/nft_tee_ipv6.c        |   81 ++++++++++++++++++++++++++++++
 net/netfilter/Kconfig                    |    7 +++
 net/netfilter/Makefile                   |    1 +
 net/netfilter/nft_tee.c                  |   71 ++++++++++++++++++++++++++
 11 files changed, 283 insertions(+)
 create mode 100644 include/net/netfilter/nft_tee.h
 create mode 100644 net/ipv4/netfilter/nft_tee_ipv4.c
 create mode 100644 net/ipv6/netfilter/nft_tee_ipv6.c
 create mode 100644 net/netfilter/nft_tee.c

diff --git a/include/net/netfilter/nft_tee.h b/include/net/netfilter/nft_tee.h
new file mode 100644
index 0000000..0c06b7c
--- /dev/null
+++ b/include/net/netfilter/nft_tee.h
@@ -0,0 +1,12 @@
+#ifndef _NFT_TEE_H_
+#define _NFT_TEE_H_
+
+extern const struct nla_policy nft_tee_policy[];
+
+int nft_tee_init(const struct nft_ctx *ctx,
+		 const struct nft_expr *expr,
+		 const struct nlattr * const tb[]);
+
+void nft_tee_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr);
+
+#endif /* _NFT_TEE_H_ */
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 89a671e..96b58da 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -936,6 +936,20 @@ enum nft_redir_attributes {
 #define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
 
 /**
+ * enum nft_tee_attributes - nf_tables tee expression netlink attributes
+ *
+ * @NFTA_TEE_GW: gateway address (NLA_NESTED: nft_data_attributes)
+ * @NFTA_TEE_OIFNAME: output interface name (NLA_STRING)
+ */
+enum nft_tee_attributes {
+	NFTA_TEE_UNSPEC,
+	NFTA_TEE_GW,
+	NFTA_TEE_OIFNAME,
+	__NFTA_TEE_MAX
+};
+#define NFTA_TEE_MAX		(__NFTA_TEE_MAX - 1)
+
+/**
  * enum nft_gen_attributes - nf_tables ruleset generation attributes
  *
  * @NFTA_GEN_ID: Ruleset generation ID (NLA_U32)
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 2153bb2..0d450c7 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -58,6 +58,13 @@ config NFT_REJECT_IPV4
 	default NFT_REJECT
 	tristate
 
+config NFT_TEE_IPV4
+	tristate "IPv4 tee suport for nf_tables"
+	select NF_TEE_IPV4
+	default NFT_TEE
+	help
+	  This is the module that provides IPv4 tee support for nf_tables.
+
 endif # NF_TABLES_IPV4
 
 config NF_TABLES_ARP
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 6b492de..08a008c 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
 obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
 obj-$(CONFIG_NFT_MASQ_IPV4) += nft_masq_ipv4.o
 obj-$(CONFIG_NFT_REDIR_IPV4) += nft_redir_ipv4.o
+obj-$(CONFIG_NFT_TEE_IPV4) += nft_tee_ipv4.o
 obj-$(CONFIG_NF_TABLES_ARP) += nf_tables_arp.o
 
 # generic IP tables 
diff --git a/net/ipv4/netfilter/nft_tee_ipv4.c b/net/ipv4/netfilter/nft_tee_ipv4.c
new file mode 100644
index 0000000..067df7b
--- /dev/null
+++ b/net/ipv4/netfilter/nft_tee_ipv4.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright (c) 2015 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Copyright (c) 2015 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nft_tee.h>
+#include <net/netfilter/ipv4/nf_tee_ipv4.h>
+
+static void nft_tee_ipv4_eval(const struct nft_expr *expr,
+			      struct nft_regs *regs,
+			      const struct nft_pktinfo *pkt)
+{
+	struct nf_tee *priv = nft_expr_priv(expr);
+
+	nf_tee_ipv4(pkt->skb, priv, pkt->ops->hooknum);
+}
+
+static int nft_tee_ipv4_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	struct nf_tee *priv = nft_expr_priv(expr);
+	struct nft_data data;
+
+	if (priv->oifname[0]) {
+		if (nla_put_string(skb, NFTA_TEE_OIFNAME, priv->oifname))
+			goto nla_put_failure;
+	}
+
+	memcpy(&data, &priv->gw, sizeof(struct in_addr));
+	return nft_data_dump(skb, NFTA_TEE_GW, &data, NFT_DATA_VALUE,
+			     sizeof(struct in_addr));
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nft_expr_type nft_tee_ipv4_type;
+static const struct nft_expr_ops nft_tee_ipv4_ops = {
+	.type		= &nft_tee_ipv4_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nf_tee)),
+	.eval		= nft_tee_ipv4_eval,
+	.init		= nft_tee_init,
+	.destroy	= nft_tee_destroy,
+	.dump		= nft_tee_ipv4_dump,
+};
+
+static struct nft_expr_type nft_tee_ipv4_type __read_mostly = {
+	.family		= NFPROTO_IPV4,
+	.name		= "tee",
+	.ops		= &nft_tee_ipv4_ops,
+	.policy		= nft_tee_policy,
+	.maxattr	= NFTA_TEE_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_tee_ipv4_module_init(void)
+{
+	return nft_register_expr(&nft_tee_ipv4_type);
+}
+
+static void __exit nft_tee_ipv4_module_exit(void)
+{
+	nft_unregister_expr(&nft_tee_ipv4_type);
+}
+
+module_init(nft_tee_ipv4_module_init);
+module_exit(nft_tee_ipv4_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "tee");
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 92c37bb..cb92c6e 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -47,6 +47,13 @@ config NFT_REJECT_IPV6
 	default NFT_REJECT
 	tristate
 
+config NFT_TEE_IPV6
+	tristate "IPv6 tee support for nf_tables"
+	select NF_TEE_IPV6
+	default NFT_TEE
+	help
+	  This is the module that provides IPv6 tee support for nf_tables.
+
 endif # NF_TABLES_IPV6
 endif # NF_TABLES
 
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index b3a2946..da871e8 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_NFT_CHAIN_NAT_IPV6) += nft_chain_nat_ipv6.o
 obj-$(CONFIG_NFT_REJECT_IPV6) += nft_reject_ipv6.o
 obj-$(CONFIG_NFT_MASQ_IPV6) += nft_masq_ipv6.o
 obj-$(CONFIG_NFT_REDIR_IPV6) += nft_redir_ipv6.o
+obj-$(CONFIG_NFT_TEE_IPV6) += nft_tee_ipv6.o
 
 # matches
 obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
diff --git a/net/ipv6/netfilter/nft_tee_ipv6.c b/net/ipv6/netfilter/nft_tee_ipv6.c
new file mode 100644
index 0000000..c1b56ef
--- /dev/null
+++ b/net/ipv6/netfilter/nft_tee_ipv6.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright (c) 2015 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Copyright (c) 2015 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nft_tee.h>
+#include <net/netfilter/ipv6/nf_tee_ipv6.h>
+
+static void nft_tee_ipv6_eval(const struct nft_expr *expr,
+			      struct nft_regs *regs,
+			      const struct nft_pktinfo *pkt)
+{
+	struct nf_tee *priv = nft_expr_priv(expr);
+
+	nf_tee_ipv6(pkt->skb, priv, pkt->ops->hooknum);
+}
+
+static int nft_tee_ipv6_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	struct nf_tee *priv = nft_expr_priv(expr);
+	struct nft_data data;
+
+	if (priv->oifname[0]) {
+		if (nla_put_string(skb, NFTA_TEE_OIFNAME, priv->oifname))
+			goto nla_put_failure;
+	}
+
+	memcpy(&data, &priv->gw, sizeof(struct in6_addr));
+	return nft_data_dump(skb, NFTA_TEE_GW, &data, NFT_DATA_VALUE,
+			     sizeof(struct in6_addr));
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nft_expr_type nft_tee_ipv6_type;
+static const struct nft_expr_ops nft_tee_ipv6_ops = {
+	.type		= &nft_tee_ipv6_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nf_tee)),
+	.eval		= nft_tee_ipv6_eval,
+	.init		= nft_tee_init,
+	.destroy	= nft_tee_destroy,
+	.dump		= nft_tee_ipv6_dump,
+};
+
+static struct nft_expr_type nft_tee_ipv6_type __read_mostly = {
+	.family		= NFPROTO_IPV6,
+	.name		= "tee",
+	.ops		= &nft_tee_ipv6_ops,
+	.policy		= nft_tee_policy,
+	.maxattr	= NFTA_TEE_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_tee_ipv6_module_init(void)
+{
+	return nft_register_expr(&nft_tee_ipv6_type);
+}
+
+static void __exit nft_tee_ipv6_module_exit(void)
+{
+	nft_unregister_expr(&nft_tee_ipv6_type);
+}
+
+module_init(nft_tee_ipv6_module_init);
+module_exit(nft_tee_ipv6_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "tee");
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index afdba34..af0fe06 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -562,6 +562,13 @@ config NFT_COMPAT
 	  x_tables match/target extensions over the nf_tables
 	  framework.
 
+config NFT_TEE
+	select NF_TEE
+	tristate "Netfilter nf_tables nf_tee support"
+	help
+	  This option adds the "tee" expression to nf_tables which you can use
+	  to copy and redirect packets to another gateway.
+
 endif # NF_TABLES
 
 config NF_TEE
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 9be0e4b..c0b555b 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_NFT_COUNTER)	+= nft_counter.o
 obj-$(CONFIG_NFT_LOG)		+= nft_log.o
 obj-$(CONFIG_NFT_MASQ)		+= nft_masq.o
 obj-$(CONFIG_NFT_REDIR)		+= nft_redir.o
+obj-$(CONFIG_NFT_TEE)		+= nft_tee.o
 
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
diff --git a/net/netfilter/nft_tee.c b/net/netfilter/nft_tee.c
new file mode 100644
index 0000000..15a697c
--- /dev/null
+++ b/net/netfilter/nft_tee.c
@@ -0,0 +1,71 @@
+/*
+ * Copyright (c) 2015 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Copyright (c) 2015 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/seqlock.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tee.h>
+#include <net/netfilter/nft_tee.h>
+
+const struct nla_policy nft_tee_policy[NFTA_TEE_MAX + 1] = {
+	[NFTA_TEE_GW]		= { .type = NLA_NESTED },
+	[NFTA_TEE_OIFNAME]	= { .type = NLA_STRING,
+				    .len  = IFNAMSIZ - 1 },
+};
+EXPORT_SYMBOL_GPL(nft_tee_policy);
+
+int nft_tee_init(const struct nft_ctx *ctx,
+		 const struct nft_expr *expr,
+		 const struct nlattr * const tb[])
+{
+	struct nf_tee *priv = nft_expr_priv(expr);
+	struct nft_data_desc desc;
+	char oifname[IFNAMSIZ];
+	union nf_inet_addr gw;
+	struct nft_data data;
+	int ret;
+
+	if (tb[NFTA_TEE_GW] == NULL)
+		return -EINVAL;
+
+	ret = nft_data_init(ctx, &data, sizeof(data), &desc, tb[NFTA_TEE_GW]);
+	if (ret < 0)
+		return ret;
+	if (desc.type != NFT_DATA_VALUE)
+		return -EINVAL;
+
+	memcpy(&gw, &data, desc.len);
+
+	memset(oifname, 0, sizeof(oifname));
+	if (tb[NFTA_TEE_OIFNAME] != NULL)
+		nla_strlcpy(oifname, tb[NFTA_TEE_OIFNAME], sizeof(oifname));
+
+	ret = nf_tee_init(priv, gw, oifname);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nft_tee_init);
+
+void nft_tee_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+{
+	struct nf_tee *priv = nft_expr_priv(expr);
+
+	nf_tee_fini(priv);
+}
+EXPORT_SYMBOL_GPL(nft_tee_destroy);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
-- 
1.7.10.4

