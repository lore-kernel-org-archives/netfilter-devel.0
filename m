From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH 2/2] netfilter: nf_tables: split nft_log in
	AF-specific modules
Date: Mon, 02 Jun 2014 13:26:20 +0200
Message-ID: <20140602112620.2928.42032.stgit@nfdev.cica.es>
References: <20140602112614.2928.43293.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:37121 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752784AbaFBL0a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:26:30 -0400
In-Reply-To: <20140602112614.2928.43293.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch split the nft_log module in AF-specific modules.
For NFPROTO_INET, it does nothing but dispatch to the AF-specific modules.

Some new symbols are added to Kconfig: NFT_LOG_IPV4, NFT_LOG_IPV6 and
NFT_LOG_INET.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/net/netfilter/ipv4/nft_log_ipv4.h |    8 +++
 include/net/netfilter/ipv6/nft_log_ipv6.h |    8 +++
 include/net/netfilter/nft_log.h           |   16 +++++++
 net/ipv4/netfilter/Kconfig                |    5 ++
 net/ipv4/netfilter/Makefile               |    1 
 net/ipv4/netfilter/nft_log_ipv4.c         |   67 ++++++++++++++++++++++++++++
 net/ipv6/netfilter/Kconfig                |    5 ++
 net/ipv6/netfilter/Makefile               |    1 
 net/ipv6/netfilter/nft_log_ipv6.c         |   67 ++++++++++++++++++++++++++++
 net/netfilter/Kconfig                     |    5 ++
 net/netfilter/Makefile                    |    1 
 net/netfilter/nft_log.c                   |   65 ++++-----------------------
 net/netfilter/nft_log_inet.c              |   70 +++++++++++++++++++++++++++++
 13 files changed, 264 insertions(+), 55 deletions(-)
 create mode 100644 include/net/netfilter/ipv4/nft_log_ipv4.h
 create mode 100644 include/net/netfilter/ipv6/nft_log_ipv6.h
 create mode 100644 include/net/netfilter/nft_log.h
 create mode 100644 net/ipv4/netfilter/nft_log_ipv4.c
 create mode 100644 net/ipv6/netfilter/nft_log_ipv6.c
 create mode 100644 net/netfilter/nft_log_inet.c

diff --git a/include/net/netfilter/ipv4/nft_log_ipv4.h b/include/net/netfilter/ipv4/nft_log_ipv4.h
new file mode 100644
index 0000000..031eabb
--- /dev/null
+++ b/include/net/netfilter/ipv4/nft_log_ipv4.h
@@ -0,0 +1,8 @@
+#ifndef _NFT_LOG_IPV4_H_
+#define _NFT_LOG_IPV4_H_
+
+void nft_log_ipv4_eval(const struct nft_expr *expr,
+		       struct nft_data data[NFT_REG_MAX + 1],
+		       const struct nft_pktinfo *pkt);
+
+#endif /* _NFT_LOG_IPV4_H_ */
diff --git a/include/net/netfilter/ipv6/nft_log_ipv6.h b/include/net/netfilter/ipv6/nft_log_ipv6.h
new file mode 100644
index 0000000..8ed9cd7
--- /dev/null
+++ b/include/net/netfilter/ipv6/nft_log_ipv6.h
@@ -0,0 +1,8 @@
+#ifndef _NFT_LOG_IPV6_H_
+#define _NFT_LOG_IPV6_H_
+
+void nft_log_ipv6_eval(const struct nft_expr *expr,
+		       struct nft_data data[NFT_REG_MAX + 1],
+		       const struct nft_pktinfo *pkt);
+
+#endif /* _NFT_LOG_IPV6_H_ */
diff --git a/include/net/netfilter/nft_log.h b/include/net/netfilter/nft_log.h
new file mode 100644
index 0000000..818c289
--- /dev/null
+++ b/include/net/netfilter/nft_log.h
@@ -0,0 +1,16 @@
+#ifndef _NFT_LOG_H_
+#define _NFT_LOG_H_
+
+struct nft_log {
+	struct nf_loginfo	loginfo;
+	char			*prefix;
+};
+
+extern const struct nla_policy nft_log_policy[];
+
+int nft_log_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
+		 const struct nlattr * const tb[]);
+void nft_log_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr);
+int nft_log_dump(struct sk_buff *skb, const struct nft_expr *expr);
+
+#endif /* _NFT_LOG_H_ */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index e09f364..db32b73 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -66,6 +66,11 @@ config NFT_REJECT_IPV4
 	default NFT_REJECT
 	tristate
 
+config NFT_LOG_IPV4
+	depends on NF_TABLES_IPV4
+	default NFT_LOG
+	tristate
+
 config NF_TABLES_ARP
 	depends on NF_TABLES
 	tristate "ARP nf_tables support"
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index d2f4b29..1f153e5 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_NF_TABLES_IPV4) += nf_tables_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
 obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
+obj-$(CONFIG_NFT_LOG_IPV4) += nft_log_ipv4.o
 obj-$(CONFIG_NF_TABLES_ARP) += nf_tables_arp.o
 
 # generic IP tables 
diff --git a/net/ipv4/netfilter/nft_log_ipv4.c b/net/ipv4/netfilter/nft_log_ipv4.c
new file mode 100644
index 0000000..3b797a3
--- /dev/null
+++ b/net/ipv4/netfilter/nft_log_ipv4.c
@@ -0,0 +1,67 @@
+/*
+ * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
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
+#include <net/netfilter/ipv4/nf_log_ipv4.h>
+#include <linux/netdevice.h>
+#include <net/netfilter/nft_log.h>
+
+void nft_log_ipv4_eval(const struct nft_expr *expr,
+		       struct nft_data data[NFT_REG_MAX + 1],
+		       const struct nft_pktinfo *pkt)
+{
+	const struct nft_log *priv = nft_expr_priv(expr);
+	struct net *net = dev_net(pkt->in ? pkt->in : pkt->out);
+
+	nf_log_ip_packet(net, pkt->ops->pf, pkt->ops->hooknum, pkt->skb,
+			 pkt->in, pkt->out, &priv->loginfo, priv->prefix);
+}
+EXPORT_SYMBOL_GPL(nft_log_ipv4_eval);
+
+static struct nft_expr_type nft_log_ipv4_type;
+static const struct nft_expr_ops nft_log_ipv4_ops = {
+	.type		= &nft_log_ipv4_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_log)),
+	.eval		= nft_log_ipv4_eval,
+	.init		= nft_log_init,
+	.destroy	= nft_log_destroy,
+	.dump		= nft_log_dump,
+};
+
+static struct nft_expr_type nft_log_ipv4_type __read_mostly = {
+	.family		= NFPROTO_IPV4,
+	.name		= "log",
+	.ops		= &nft_log_ipv4_ops,
+	.policy		= nft_log_policy,
+	.maxattr	= NFTA_LOG_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_log_ipv4_module_init(void)
+{
+	return nft_register_expr(&nft_log_ipv4_type);
+}
+
+static void __exit nft_log_ipv4_module_exit(void)
+{
+	nft_unregister_expr(&nft_log_ipv4_type);
+}
+
+module_init(nft_log_ipv4_module_init);
+module_exit(nft_log_ipv4_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "log");
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 4101334..4ee6aa3 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -55,6 +55,11 @@ config NFT_REJECT_IPV6
 	default NFT_REJECT
 	tristate
 
+config NFT_LOG_IPV6
+	depends on NF_TABLES_IPV6
+	default NFT_LOG
+	tristate
+
 config IP6_NF_IPTABLES
 	tristate "IP6 tables support (required for filtering)"
 	depends on INET && IPV6
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 4a5ffc6..047126d 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_NF_TABLES_IPV6) += nf_tables_ipv6.o
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV6) += nft_chain_route_ipv6.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV6) += nft_chain_nat_ipv6.o
 obj-$(CONFIG_NFT_REJECT_IPV6) += nft_reject_ipv6.o
+obj-$(CONFIG_NFT_LOG_IPV6) += nft_log_ipv6.o
 
 # matches
 obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
diff --git a/net/ipv6/netfilter/nft_log_ipv6.c b/net/ipv6/netfilter/nft_log_ipv6.c
new file mode 100644
index 0000000..11a7dbb
--- /dev/null
+++ b/net/ipv6/netfilter/nft_log_ipv6.c
@@ -0,0 +1,67 @@
+/*
+ * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
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
+#include <net/netfilter/ipv6/nf_log_ipv6.h>
+#include <linux/netdevice.h>
+#include <net/netfilter/nft_log.h>
+
+void nft_log_ipv6_eval(const struct nft_expr *expr,
+		       struct nft_data data[NFT_REG_MAX + 1],
+		       const struct nft_pktinfo *pkt)
+{
+	const struct nft_log *priv = nft_expr_priv(expr);
+	struct net *net = dev_net(pkt->in ? pkt->in : pkt->out);
+
+	nf_log_ip6_packet(net, pkt->ops->pf, pkt->ops->hooknum, pkt->skb,
+			  pkt->in, pkt->out, &priv->loginfo, priv->prefix);
+}
+EXPORT_SYMBOL_GPL(nft_log_ipv6_eval);
+
+static struct nft_expr_type nft_log_ipv6_type;
+static const struct nft_expr_ops nft_log_ipv6_ops = {
+	.type		= &nft_log_ipv6_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_log)),
+	.eval		= nft_log_ipv6_eval,
+	.init		= nft_log_init,
+	.destroy	= nft_log_destroy,
+	.dump		= nft_log_dump,
+};
+
+static struct nft_expr_type nft_log_ipv6_type __read_mostly = {
+	.family		= NFPROTO_IPV6,
+	.name		= "log",
+	.ops		= &nft_log_ipv6_ops,
+	.policy		= nft_log_policy,
+	.maxattr	= NFTA_LOG_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_log_ipv6_module_init(void)
+{
+	return nft_register_expr(&nft_log_ipv6_type);
+}
+
+static void __exit nft_log_ipv6_module_exit(void)
+{
+	nft_unregister_expr(&nft_log_ipv6_type);
+}
+
+module_init(nft_log_ipv6_module_init);
+module_exit(nft_log_ipv6_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "log");
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 4133172..701f39d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -532,6 +532,11 @@ config NFT_REJECT_INET
 	default NFT_REJECT
 	tristate
 
+config NFT_LOG_INET
+	depends on NF_TABLES_INET
+	default NFT_LOG
+	tristate
+
 config NFT_COMPAT
 	depends on NF_TABLES
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index d19e961..5ac6480 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -87,6 +87,7 @@ obj-$(CONFIG_NFT_RBTREE)	+= nft_rbtree.o
 obj-$(CONFIG_NFT_HASH)		+= nft_hash.o
 obj-$(CONFIG_NFT_COUNTER)	+= nft_counter.o
 obj-$(CONFIG_NFT_LOG)		+= nft_log.o
+obj-$(CONFIG_NFT_LOG_INET)	+= nft_log_inet.o
 
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 10cfb15..6f2f541 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -17,35 +17,20 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_log.h>
 #include <linux/netdevice.h>
+#include <net/netfilter/nft_log.h>
 
 static const char *nft_log_null_prefix = "";
 
-struct nft_log {
-	struct nf_loginfo	loginfo;
-	char			*prefix;
-};
-
-static void nft_log_eval(const struct nft_expr *expr,
-			 struct nft_data data[NFT_REG_MAX + 1],
-			 const struct nft_pktinfo *pkt)
-{
-	const struct nft_log *priv = nft_expr_priv(expr);
-	struct net *net = dev_net(pkt->in ? pkt->in : pkt->out);
-
-	nf_log_packet(net, pkt->ops->pf, pkt->ops->hooknum, pkt->skb, pkt->in,
-		      pkt->out, &priv->loginfo, "%s", priv->prefix);
-}
-
-static const struct nla_policy nft_log_policy[NFTA_LOG_MAX + 1] = {
+const struct nla_policy nft_log_policy[NFTA_LOG_MAX + 1] = {
 	[NFTA_LOG_GROUP]	= { .type = NLA_U16 },
 	[NFTA_LOG_PREFIX]	= { .type = NLA_STRING },
 	[NFTA_LOG_SNAPLEN]	= { .type = NLA_U32 },
 	[NFTA_LOG_QTHRESHOLD]	= { .type = NLA_U16 },
 };
+EXPORT_SYMBOL_GPL(nft_log_policy);
 
-static int nft_log_init(const struct nft_ctx *ctx,
-			const struct nft_expr *expr,
-			const struct nlattr * const tb[])
+int nft_log_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
+		 const struct nlattr * const tb[])
 {
 	struct nft_log *priv = nft_expr_priv(expr);
 	struct nf_loginfo *li = &priv->loginfo;
@@ -73,17 +58,18 @@ static int nft_log_init(const struct nft_ctx *ctx,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nft_log_init);
 
-static void nft_log_destroy(const struct nft_ctx *ctx,
-			    const struct nft_expr *expr)
+void nft_log_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
 	struct nft_log *priv = nft_expr_priv(expr);
 
 	if (priv->prefix != nft_log_null_prefix)
 		kfree(priv->prefix);
 }
+EXPORT_SYMBOL_GPL(nft_log_destroy);
 
-static int nft_log_dump(struct sk_buff *skb, const struct nft_expr *expr)
+int nft_log_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_log *priv = nft_expr_priv(expr);
 	const struct nf_loginfo *li = &priv->loginfo;
@@ -107,38 +93,7 @@ static int nft_log_dump(struct sk_buff *skb, const struct nft_expr *expr)
 nla_put_failure:
 	return -1;
 }
-
-static struct nft_expr_type nft_log_type;
-static const struct nft_expr_ops nft_log_ops = {
-	.type		= &nft_log_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_log)),
-	.eval		= nft_log_eval,
-	.init		= nft_log_init,
-	.destroy	= nft_log_destroy,
-	.dump		= nft_log_dump,
-};
-
-static struct nft_expr_type nft_log_type __read_mostly = {
-	.name		= "log",
-	.ops		= &nft_log_ops,
-	.policy		= nft_log_policy,
-	.maxattr	= NFTA_LOG_MAX,
-	.owner		= THIS_MODULE,
-};
-
-static int __init nft_log_module_init(void)
-{
-	return nft_register_expr(&nft_log_type);
-}
-
-static void __exit nft_log_module_exit(void)
-{
-	nft_unregister_expr(&nft_log_type);
-}
-
-module_init(nft_log_module_init);
-module_exit(nft_log_module_exit);
+EXPORT_SYMBOL_GPL(nft_log_dump);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_EXPR("log");
diff --git a/net/netfilter/nft_log_inet.c b/net/netfilter/nft_log_inet.c
new file mode 100644
index 0000000..b982df8
--- /dev/null
+++ b/net/netfilter/nft_log_inet.c
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
+ * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
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
+#include <net/netfilter/nf_log.h>
+#include <linux/netdevice.h>
+#include <net/netfilter/nft_log.h>
+#include <net/netfilter/ipv4/nft_log_ipv4.h>
+#include <net/netfilter/ipv6/nft_log_ipv6.h>
+
+static void nft_log_inet_eval(const struct nft_expr *expr,
+			      struct nft_data data[NFT_REG_MAX + 1],
+			      const struct nft_pktinfo *pkt)
+{
+	switch (pkt->ops->pf) {
+	case NFPROTO_IPV4:
+		nft_log_ipv4_eval(expr, data, pkt);
+	case NFPROTO_IPV6:
+		nft_log_ipv6_eval(expr, data, pkt);
+	}
+}
+
+static struct nft_expr_type nft_log_inet_type;
+static const struct nft_expr_ops nft_log_inet_ops = {
+	.type		= &nft_log_inet_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_log)),
+	.eval		= nft_log_inet_eval,
+	.init		= nft_log_init,
+	.destroy	= nft_log_destroy,
+	.dump		= nft_log_dump,
+};
+
+static struct nft_expr_type nft_log_inet_type __read_mostly = {
+	.family		= NFPROTO_INET,
+	.name		= "log",
+	.ops		= &nft_log_inet_ops,
+	.policy		= nft_log_policy,
+	.maxattr	= NFTA_LOG_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_log_inet_module_init(void)
+{
+	return nft_register_expr(&nft_log_inet_type);
+}
+
+static void __exit nft_log_inet_module_exit(void)
+{
+	nft_unregister_expr(&nft_log_inet_type);
+}
+
+module_init(nft_log_inet_module_init);
+module_exit(nft_log_inet_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_ALIAS_NFT_AF_EXPR(1, "log");

