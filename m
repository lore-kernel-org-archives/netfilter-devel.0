From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH 3/3] netfilter: nf_tables: add new expression
 nft_redir
Date: Tue, 14 Oct 2014 19:22:42 +0200
Message-ID: <20141014172242.5983.11604.stgit@nfdev.cica.es>
References: <20141014172231.5983.37941.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:49181 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753866AbaJNRWv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Oct 2014 13:22:51 -0400
In-Reply-To: <20141014172231.5983.37941.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new expression provides NAT in the redirect flavour, which is to
redirect packets to local machine.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/net/netfilter/nft_redir.h        |   18 ++++++
 include/uapi/linux/netfilter/nf_tables.h |   16 +++++
 net/ipv4/netfilter/Kconfig               |    9 +++
 net/ipv4/netfilter/Makefile              |    1 
 net/ipv4/netfilter/nft_redir_ipv4.c      |   76 +++++++++++++++++++++++++
 net/ipv6/netfilter/Kconfig               |    9 +++
 net/ipv6/netfilter/Makefile              |    1 
 net/netfilter/Kconfig                    |    9 +++
 net/netfilter/Makefile                   |    1 
 net/netfilter/nft_redir.c                |   93 ++++++++++++++++++++++++++++++
 10 files changed, 233 insertions(+)
 create mode 100644 include/net/netfilter/nft_redir.h
 create mode 100644 net/ipv4/netfilter/nft_redir_ipv4.c
 create mode 100644 net/netfilter/nft_redir.c

diff --git a/include/net/netfilter/nft_redir.h b/include/net/netfilter/nft_redir.h
new file mode 100644
index 0000000..b6695da
--- /dev/null
+++ b/include/net/netfilter/nft_redir.h
@@ -0,0 +1,18 @@
+#ifndef _NFT_REDIR_H_
+#define _NFT_REDIR_H_
+
+struct nft_redir {
+	enum nft_registers	sreg_proto_min:8;
+	enum nft_registers	sreg_proto_max:8;
+	u32			flags;
+};
+
+extern const struct nla_policy nft_redir_policy[];
+
+int nft_redir_init(const struct nft_ctx *ctx,
+		   const struct nft_expr *expr,
+		   const struct nlattr * const tb[]);
+
+int nft_redir_dump(struct sk_buff *skb, const struct nft_expr *expr);
+
+#endif /* _NFT_REDIR_H_ */
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c26df67..8a96a36 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -849,4 +849,20 @@ enum nft_gen_attributes {
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
+/**
+ * enum nft_redir_attributes - nf_tables redirect expression netlink attributes
+ *
+ * @NFTA_REDIR_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
+ * @NFTA_REDIR_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
+ * @NFTA_REDIR_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
+ */
+enum nft_redir_attributes {
+	NFTA_REDIR_UNSPEC,
+	NFTA_REDIR_REG_PROTO_MIN,
+	NFTA_REDIR_REG_PROTO_MAX,
+	NFTA_REDIR_FLAGS,
+	__NFTA_REDIR_MAX
+};
+#define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
+
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index a300e2c..8358b2d 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -119,6 +119,15 @@ config NFT_MASQ_IPV4
 	  This is the expression that provides IPv4 masquerading support for
 	  nf_tables.
 
+config NFT_REDIR_IPV4
+	tristate "IPv4 redirect support for nf_tables"
+	depends on NF_TABLES_IPV4
+	depends on NFT_REDIR
+	select NF_NAT_REDIRECT_IPV4
+	help
+	  This is the expression that provides IPv4 redirect support for
+	  nf_tables.
+
 config NF_NAT_SNMP_BASIC
 	tristate "Basic SNMP-ALG support"
 	depends on NF_CONNTRACK_SNMP
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 34e436c..902bcd1 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
 obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
 obj-$(CONFIG_NFT_MASQ_IPV4) += nft_masq_ipv4.o
+obj-$(CONFIG_NFT_REDIR_IPV4) += nft_redir_ipv4.o
 obj-$(CONFIG_NF_TABLES_ARP) += nf_tables_arp.o
 
 # generic IP tables 
diff --git a/net/ipv4/netfilter/nft_redir_ipv4.c b/net/ipv4/netfilter/nft_redir_ipv4.c
new file mode 100644
index 0000000..d48690e
--- /dev/null
+++ b/net/ipv4/netfilter/nft_redir_ipv4.c
@@ -0,0 +1,76 @@
+/*
+ * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+#include <net/netfilter/ipv4/nf_nat_redirect.h>
+#include <net/netfilter/nft_redir.h>
+
+static void nft_redir_ipv4_eval(const struct nft_expr *expr,
+				struct nft_data data[NFT_REG_MAX + 1],
+				const struct nft_pktinfo *pkt)
+{
+	struct nft_redir *priv = nft_expr_priv(expr);
+	struct nf_nat_ipv4_multi_range_compat mr;
+	unsigned int verdict;
+
+	memset(&mr, 0, sizeof(mr));
+	if (priv->sreg_proto_min) {
+		mr.range[0].min.all = (__force __be16)
+					data[priv->sreg_proto_min].data[0];
+		mr.range[0].max.all = (__force __be16)
+					data[priv->sreg_proto_max].data[0];
+		mr.range[0].flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+	}
+
+	mr.range[0].flags |= priv->flags;
+
+	verdict = nf_nat_redirect_ipv4(pkt->skb, &mr, pkt->ops->hooknum);
+	data[NFT_REG_VERDICT].verdict = verdict;
+}
+
+static struct nft_expr_type nft_redir_ipv4_type;
+static const struct nft_expr_ops nft_redir_ipv4_ops = {
+	.type		= &nft_redir_ipv4_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_redir)),
+	.eval		= nft_redir_ipv4_eval,
+	.init		= nft_redir_init,
+	.dump		= nft_redir_dump,
+};
+
+static struct nft_expr_type nft_redir_ipv4_type __read_mostly = {
+	.family		= NFPROTO_IPV4,
+	.name		= "redir",
+	.ops		= &nft_redir_ipv4_ops,
+	.policy		= nft_redir_policy,
+	.maxattr	= NFTA_REDIR_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_redir_ipv4_module_init(void)
+{
+	return nft_register_expr(&nft_redir_ipv4_type);
+}
+
+static void __exit nft_redir_ipv4_module_exit(void)
+{
+	nft_unregister_expr(&nft_redir_ipv4_type);
+}
+
+module_init(nft_redir_ipv4_module_init);
+module_exit(nft_redir_ipv4_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "redir");
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 462eebb..0dbe5c7 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -97,6 +97,15 @@ config NFT_MASQ_IPV6
 	  This is the expression that provides IPv4 masquerading support for
 	  nf_tables.
 
+config NFT_REDIR_IPV6
+	tristate "IPv6 redirect support for nf_tables"
+	depends on NF_TABLES_IPV6
+	depends on NFT_REDIR
+	select NF_NAT_REDIRECT_IPV6
+	help
+	  This is the expression that provides IPv4 redirect support for
+	  nf_tables.
+
 endif # NF_NAT_IPV6
 
 config IP6_NF_IPTABLES
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 6c2baab..d2ac9f5 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV6) += nft_chain_route_ipv6.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV6) += nft_chain_nat_ipv6.o
 obj-$(CONFIG_NFT_REJECT_IPV6) += nft_reject_ipv6.o
 obj-$(CONFIG_NFT_MASQ_IPV6) += nft_masq_ipv6.o
+obj-$(CONFIG_NFT_REDIR_IPV6) += nft_redir_ipv6.o
 
 # matches
 obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 1d0131c..d155799 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -505,6 +505,15 @@ config NFT_MASQ
 	  This option adds the "masquerade" expression that you can use
 	  to perform NAT in the masquerade flavour.
 
+config NFT_REDIR
+	depends on NF_TABLES
+	depends on NF_CONNTRACK
+	depends on NF_NAT
+	tristate "Netfilter nf_tables redirect support"
+	help
+	  This options adds the "redirect" expression that you can use
+	  to perform NAT in the redirect flavour.
+
 config NFT_NAT
 	depends on NF_TABLES
 	depends on NF_CONNTRACK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index a9571be..f3eb468 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -88,6 +88,7 @@ obj-$(CONFIG_NFT_HASH)		+= nft_hash.o
 obj-$(CONFIG_NFT_COUNTER)	+= nft_counter.o
 obj-$(CONFIG_NFT_LOG)		+= nft_log.o
 obj-$(CONFIG_NFT_MASQ)		+= nft_masq.o
+obj-$(CONFIG_NFT_REDIR)		+= nft_redir.o
 
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
new file mode 100644
index 0000000..1d414a7
--- /dev/null
+++ b/net/netfilter/nft_redir.c
@@ -0,0 +1,93 @@
+/*
+ * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nft_redir.h>
+
+const struct nla_policy nft_redir_policy[NFTA_REDIR_MAX + 1] = {
+	[NFTA_REDIR_REG_PROTO_MIN]	= { .type = NLA_U32 },
+	[NFTA_REDIR_REG_PROTO_MAX]	= { .type = NLA_U32 },
+	[NFTA_REDIR_FLAGS]		= { .type = NLA_U32 },
+};
+EXPORT_SYMBOL_GPL(nft_redir_policy);
+
+int nft_redir_init(const struct nft_ctx *ctx,
+		   const struct nft_expr *expr,
+		   const struct nlattr * const tb[])
+{
+	struct nft_redir *priv = nft_expr_priv(expr);
+	int err;
+
+	if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
+		priv->sreg_proto_min = ntohl(nla_get_be32(
+						tb[NFTA_REDIR_REG_PROTO_MIN]));
+		err = nft_validate_input_register(priv->sreg_proto_min);
+		if (err < 0)
+			return err;
+	}
+
+	if (tb[NFTA_REDIR_REG_PROTO_MAX]) {
+		priv->sreg_proto_max = ntohl(nla_get_be32(
+						tb[NFTA_REDIR_REG_PROTO_MAX]));
+		err = nft_validate_input_register(priv->sreg_proto_max);
+		if (err < 0)
+			return err;
+	} else
+		priv->sreg_proto_max = priv->sreg_proto_min;
+
+	if (tb[NFTA_REDIR_FLAGS]) {
+		priv->flags = ntohl(nla_get_be32(tb[NFTA_REDIR_FLAGS]));
+		if (priv->flags & ~NF_NAT_RANGE_MASK)
+			return -EINVAL;
+	}
+
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nft_redir_init);
+
+int nft_redir_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_redir *priv = nft_expr_priv(expr);
+
+	if (priv->sreg_proto_min) {
+		if (nla_put_be32(skb, NFTA_REDIR_REG_PROTO_MIN,
+				 htonl(priv->sreg_proto_min)))
+			goto nla_put_failure;
+		if (nla_put_be32(skb, NFTA_REDIR_REG_PROTO_MAX,
+				 htonl(priv->sreg_proto_max)))
+			goto nla_put_failure;
+	}
+
+	if (priv->flags != 0) {
+		if (nla_put_be32(skb, NFTA_REDIR_FLAGS, htonl(priv->flags)))
+			goto nla_put_failure;
+	}
+
+	if (priv->flags == 0)
+		return 0;
+
+	if (nla_put_be32(skb, NFTA_REDIR_FLAGS, htonl(priv->flags)))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+EXPORT_SYMBOL_GPL(nft_redir_dump);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");

