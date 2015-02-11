From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC PATCH 2/2] netfilter: nf_tables: add nft_tee expression
Date: Wed, 11 Feb 2015 19:39:08 +0100
Message-ID: <20150211183908.5040.51423.stgit@nfdev.cica.es>
References: <20150211183902.5040.52479.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:56985 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753057AbbBKSjT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2015 13:39:19 -0500
In-Reply-To: <20150211183902.5040.52479.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new expression uses the nf_tee engine to redirect packets
to a given gateway.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/net/netfilter/nft_tee.h          |   22 ++++++++
 include/uapi/linux/netfilter/nf_tables.h |   14 +++++
 net/ipv4/netfilter/Kconfig               |    8 +++
 net/ipv4/netfilter/Makefile              |    1 
 net/ipv4/netfilter/nft_tee_ipv4.c        |   65 +++++++++++++++++++++++
 net/ipv6/netfilter/Kconfig               |    8 +++
 net/ipv6/netfilter/Makefile              |    1 
 net/ipv6/netfilter/nft_tee_ipv6.c        |   65 +++++++++++++++++++++++
 net/netfilter/Kconfig                    |    8 +++
 net/netfilter/Makefile                   |    1 
 net/netfilter/nft_tee.c                  |   85 ++++++++++++++++++++++++++++++
 11 files changed, 278 insertions(+)
 create mode 100644 include/net/netfilter/nft_tee.h
 create mode 100644 net/ipv4/netfilter/nft_tee_ipv4.c
 create mode 100644 net/ipv6/netfilter/nft_tee_ipv6.c
 create mode 100644 net/netfilter/nft_tee.c

diff --git a/include/net/netfilter/nft_tee.h b/include/net/netfilter/nft_tee.h
new file mode 100644
index 0000000..5a8e70a
--- /dev/null
+++ b/include/net/netfilter/nft_tee.h
@@ -0,0 +1,22 @@
+#ifndef _NFT_TEE_H_
+#define _NFT_TEE_H_
+
+#include <net/netfilter/nf_tee.h>
+
+struct nft_tee {
+	struct nf_tee		*tee;
+	struct nft_data		data; /* gw */
+	u8			dlen; /* gw len */
+};
+
+extern const struct nla_policy nft_tee_policy[];
+
+int nft_tee_init(const struct nft_ctx *ctx,
+		 const struct nft_expr *expr,
+		 const struct nlattr * const tb[]);
+
+void nft_tee_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr);
+
+int nft_tee_dump(struct sk_buff *skb, const struct nft_expr *expr);
+
+#endif /* _NFT_TEE_H_ */
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 832bc46..8dade0a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -856,6 +856,20 @@ enum nft_redir_attributes {
 #define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
 
 /**
+ * enum nft_tee_attributes - nf_tables tee expression netlink attributes
+ *
+ * @NFTA_TEE_GW: tee gateway (NLA_NESTED: nft_data_attributes)
+ * @NFTA_TEE_OIF: tee output interface name (NLA_STRING)
+ */
+enum nft_tee_attributes {
+	NFTA_TEE_UNSPEC,
+	NFTA_TEE_GW,
+	NFTA_TEE_OIF,
+	__NFTA_TEE_MAX
+};
+#define NFTA_TEE_MAX		(__NFTA_TEE_MAX - 1)
+
+/**
  * enum nft_gen_attributes - nf_tables ruleset generation attributes
  *
  * @NFTA_GEN_ID: Ruleset generation ID (NLA_U32)
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index d71dbdf..a21865d 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -130,6 +130,14 @@ config NFT_REDIR_IPV4
 	  This is the expression that provides IPv4 redirect support for
 	  nf_tables.
 
+config NFT_TEE_IPV4
+	tristate "IPv4 tee suport for nf_tables"
+	depends on NF_TABLES_IPV4
+	depends on NFT_TEE
+	select NF_TEE_IPV4
+	help
+	  This is the module that provides IPv4 tee support for nf_tables.
+
 config NF_NAT_SNMP_BASIC
 	tristate "Basic SNMP-ALG support"
 	depends on NF_CONNTRACK_SNMP
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
index 0000000..cfe6286
--- /dev/null
+++ b/net/ipv4/netfilter/nft_tee_ipv4.c
@@ -0,0 +1,65 @@
+/*
+ * Copyright (c) 2015 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+#include <net/netfilter/nft_tee.h>
+#include <net/netfilter/ipv4/nf_tee_ipv4.h>
+
+static void nft_tee_ipv4_eval(const struct nft_expr *expr,
+			      struct nft_data data[NFT_REG_MAX + 1],
+			      const struct nft_pktinfo *pkt)
+{
+	struct nft_tee *priv = nft_expr_priv(expr);
+
+	priv->tee->hooknum = pkt->ops->hooknum;
+
+	nf_tee_ipv4(pkt->skb, priv->tee);
+}
+
+static struct nft_expr_type nft_tee_ipv4_type;
+static const struct nft_expr_ops nft_tee_ipv4_ops = {
+	.type		= &nft_tee_ipv4_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_tee)),
+	.eval		= nft_tee_ipv4_eval,
+	.init		= nft_tee_init,
+	.destroy	= nft_tee_destroy,
+	.dump		= nft_tee_dump,
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
index fefd1bb..2530e2c 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -110,6 +110,14 @@ config NFT_REDIR_IPV6
 
 endif # NF_NAT_IPV6
 
+config NFT_TEE_IPV6
+	tristate "IPv6 tee support for nf_tables"
+	depends on NF_TABLES_IPV6
+	depends on NFT_TEE
+	select NF_TEE_IPV6
+	help
+	  This is the module that provides IPv6 tee support for nf_tables.
+
 config IP6_NF_IPTABLES
 	tristate "IP6 tables support (required for filtering)"
 	depends on INET && IPV6
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
index 0000000..65a5f1d
--- /dev/null
+++ b/net/ipv6/netfilter/nft_tee_ipv6.c
@@ -0,0 +1,65 @@
+/*
+ * Copyright (c) 2015 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+#include <net/netfilter/nft_tee.h>
+#include <net/netfilter/ipv6/nf_tee_ipv6.h>
+
+static void nft_tee_ipv6_eval(const struct nft_expr *expr,
+			      struct nft_data data[NFT_REG_MAX + 1],
+			      const struct nft_pktinfo *pkt)
+{
+	struct nft_tee *priv = nft_expr_priv(expr);
+
+	priv->tee->hooknum = pkt->ops->hooknum;
+
+	nf_tee_ipv6(pkt->skb, priv->tee);
+}
+
+static struct nft_expr_type nft_tee_ipv6_type;
+static const struct nft_expr_ops nft_tee_ipv6_ops = {
+	.type		= &nft_tee_ipv6_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_tee)),
+	.eval		= nft_tee_ipv6_eval,
+	.init		= nft_tee_init,
+	.destroy	= nft_tee_destroy,
+	.dump		= nft_tee_dump,
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
index f0a0712..1606b44 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -562,6 +562,14 @@ config NFT_COMPAT
 	  x_tables match/target extensions over the nf_tables
 	  framework.
 
+config NFT_TEE
+	depends on NF_TABLES
+	depends on NF_TEE
+	tristate "Netfilter nf_tables nf_tee support"
+	help
+	  This option adds the "tee" expression to nf_tables which you can use
+	  to copy and redirect packets to another gateway.
+
 config NF_TEE
 	tristate "Netfilter nf_tee module"
 	help
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 0cd2f03..22a2b77 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_NFT_COUNTER)	+= nft_counter.o
 obj-$(CONFIG_NFT_LOG)		+= nft_log.o
 obj-$(CONFIG_NFT_MASQ)		+= nft_masq.o
 obj-$(CONFIG_NFT_REDIR)		+= nft_redir.o
+obj-$(CONFIG_NFT_TEE)		+= nft_tee.o
 
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
diff --git a/net/netfilter/nft_tee.c b/net/netfilter/nft_tee.c
new file mode 100644
index 0000000..d130140
--- /dev/null
+++ b/net/netfilter/nft_tee.c
@@ -0,0 +1,85 @@
+/*
+ * Copyright (c) 2015 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+#include <net/netfilter/nft_tee.h>
+
+const struct nla_policy nft_tee_policy[NFTA_TEE_MAX + 1] = {
+	[NFTA_TEE_GW]			= { .type = NLA_NESTED },
+	[NFTA_TEE_OIF]			= { .type = NLA_STRING },
+};
+EXPORT_SYMBOL_GPL(nft_tee_policy);
+
+int nft_tee_init(const struct nft_ctx *ctx,
+		 const struct nft_expr *expr,
+		 const struct nlattr * const tb[])
+{
+	struct nft_tee *priv = nft_expr_priv(expr);
+	struct nft_data_desc desc;
+	char oif_str[IFNAMSIZ];
+	union nf_inet_addr gw;
+	int err;
+
+	if (tb[NFTA_TEE_GW] == NULL)
+		return -EINVAL;
+
+	err = nft_data_init(ctx, &priv->data, &desc, tb[NFTA_TEE_GW]);
+	if (err < 0)
+		return err;
+
+	if (desc.type != NFT_DATA_VALUE)
+		return -EINVAL;
+
+	priv->dlen = desc.len;
+	memcpy(&gw, priv->data.data, priv->dlen);
+
+	memset(oif_str, 0, sizeof(oif_str));
+	if (tb[NFTA_TEE_OIF] != NULL)
+		nla_strlcpy(oif_str, tb[NFTA_TEE_OIF], sizeof(oif_str));
+
+	priv->tee = nf_tee_new(gw, oif_str);
+	if (IS_ERR(priv->tee))
+		return PTR_ERR(priv->tee);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nft_tee_init);
+
+void nft_tee_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+{
+	struct nft_tee *priv = nft_expr_priv(expr);
+
+	nf_tee_destroy(priv->tee);
+}
+EXPORT_SYMBOL_GPL(nft_tee_destroy);
+
+int nft_tee_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	struct nft_tee *priv = nft_expr_priv(expr);
+
+	if (priv->tee->oif_str[0])
+		if (nla_put_string(skb, NFTA_TEE_OIF, priv->tee->oif_str))
+			goto nla_put_failure;
+
+	return nft_data_dump(skb, NFTA_TEE_GW, &priv->data,
+			     NFT_DATA_VALUE, priv->dlen);
+
+nla_put_failure:
+	return -1;
+}
+EXPORT_SYMBOL_GPL(nft_tee_dump);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");

