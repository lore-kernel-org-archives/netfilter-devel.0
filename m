From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next, v2 3/3] netfilter: nf_tables: add nft_tee expression
Date: Thu, 18 Jun 2015 20:13:59 +0200
Message-ID: <1434651239-6953-3-git-send-email-pablo@netfilter.org>
References: <1434651239-6953-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45075 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756900AbbFRSIp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Jun 2015 14:08:45 -0400
In-Reply-To: <1434651239-6953-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new expression uses the nf_tee engine to clone packets to a given gateway.

It should be possible to reduce memory consumption a bit through select_ops(),
but this would make it more complicated to share code with x_tables though.  I
expect little rules using this expression, so I think it's fine to start with
this approach.

Based on original work from Arturo Borrero Gonzalez, although this patch has
diverted quite a bit from this initial effort due to the change to support maps.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: This includes support for maps.

 include/net/netfilter/nft_tee.h          |   11 +++
 include/uapi/linux/netfilter/nf_tables.h |   14 ++++
 net/ipv4/netfilter/Kconfig               |    7 ++
 net/ipv4/netfilter/Makefile              |    1 +
 net/ipv4/netfilter/nft_tee_ipv4.c        |  120 ++++++++++++++++++++++++++++++
 net/ipv6/netfilter/Kconfig               |    7 ++
 net/ipv6/netfilter/Makefile              |    1 +
 net/ipv6/netfilter/nft_tee_ipv6.c        |  119 +++++++++++++++++++++++++++++
 8 files changed, 280 insertions(+)
 create mode 100644 include/net/netfilter/nft_tee.h
 create mode 100644 net/ipv4/netfilter/nft_tee_ipv4.c
 create mode 100644 net/ipv6/netfilter/nft_tee_ipv6.c

diff --git a/include/net/netfilter/nft_tee.h b/include/net/netfilter/nft_tee.h
new file mode 100644
index 0000000..8b39b9a
--- /dev/null
+++ b/include/net/netfilter/nft_tee.h
@@ -0,0 +1,11 @@
+#ifndef _NFT_TEE_H_
+#define _NFT_TEE_H_
+
+#include <net/netfilter/nf_tee.h>
+
+struct nft_tee {
+	enum nft_registers	sreg_gw:8;
+	struct nf_tee		tee;
+};
+
+#endif /* _NFT_TEE_H_ */
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index da3b505..28f0e93 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -950,6 +950,20 @@ enum nft_redir_attributes {
 #define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
 
 /**
+ * enum nft_tee_attributes - nf_tables tee expression netlink attributes
+ *
+ * @NFTA_TEE_SREG_GW: source register of gateway address (NLA_NESTED: nft_data_attributes)
+ * @NFTA_TEE_OIFNAME: output interface name (NLA_STRING)
+ */
+enum nft_tee_attributes {
+	NFTA_TEE_UNSPEC,
+	NFTA_TEE_SREG_GW,
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
index 2153bb2..73c3842 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -58,6 +58,13 @@ config NFT_REJECT_IPV4
 	default NFT_REJECT
 	tristate
 
+config NFT_TEE_IPV4
+	tristate "IPv4 tee suport for nf_tables"
+	select NF_TEE
+	select NF_TEE_IPV4
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
index 0000000..a29dceb
--- /dev/null
+++ b/net/ipv4/netfilter/nft_tee_ipv4.c
@@ -0,0 +1,120 @@
+/*
+ * Copyright (c) 2015 Pablo Neira Ayuso <pablo@netfilter.org>
+ * Copyright (c) 2015 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
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
+	struct nft_tee *priv = nft_expr_priv(expr);
+	struct in_addr gw = {
+		.s_addr = regs->data[priv->sreg_gw],
+	};
+
+	nf_tee_ipv4(pkt->skb, &priv->tee, pkt->ops->hooknum, &gw);
+}
+
+static int nft_tee_ipv4_init(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nlattr * const tb[])
+{
+	struct nft_tee *priv = nft_expr_priv(expr);
+	char oifname[IFNAMSIZ];
+	int err;
+
+	if (tb[NFTA_TEE_SREG_GW] == NULL)
+		return -EINVAL;
+
+	priv->sreg_gw = nft_parse_register(tb[NFTA_TEE_SREG_GW]);
+	err = nft_validate_register_load(priv->sreg_gw, sizeof(struct in_addr));
+	if (err < 0)
+		return err;
+
+	memset(oifname, 0, sizeof(oifname));
+	if (tb[NFTA_TEE_OIFNAME] != NULL)
+		nla_strlcpy(oifname, tb[NFTA_TEE_OIFNAME], sizeof(oifname));
+
+	return nf_tee_init(&priv->tee, oifname);
+}
+
+static void nft_tee_ipv4_destroy(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr)
+{
+	struct nft_tee *priv = nft_expr_priv(expr);
+
+	nf_tee_fini(&priv->tee);
+}
+
+static int nft_tee_ipv4_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	struct nft_tee *priv = nft_expr_priv(expr);
+
+	if (nft_dump_register(skb, NFTA_TEE_SREG_GW, priv->sreg_gw))
+		goto nla_put_failure;
+
+	if (priv->tee.oifname[0]) {
+		if (nla_put_string(skb, NFTA_TEE_OIFNAME, priv->tee.oifname))
+			goto nla_put_failure;
+	}
+	return 0;
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
+	.init		= nft_tee_ipv4_init,
+	.destroy	= nft_tee_ipv4_destroy,
+	.dump		= nft_tee_ipv4_dump,
+};
+
+static const struct nla_policy nft_tee_ipv4_policy[NFTA_TEE_MAX + 1] = {
+	[NFTA_TEE_SREG_GW]	= { .type = NLA_U32 },
+	[NFTA_TEE_OIFNAME]	= { .type = NLA_STRING,
+				    .len  = IFNAMSIZ - 1 },
+};
+
+static struct nft_expr_type nft_tee_ipv4_type __read_mostly = {
+	.family		= NFPROTO_IPV4,
+	.name		= "tee",
+	.ops		= &nft_tee_ipv4_ops,
+	.policy		= nft_tee_ipv4_policy,
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
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "tee");
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 92c37bb..ec8ece5 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -47,6 +47,13 @@ config NFT_REJECT_IPV6
 	default NFT_REJECT
 	tristate
 
+config NFT_TEE_IPV6
+	tristate "IPv6 tee support for nf_tables"
+	select NF_TEE
+	select NF_TEE_IPV6
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
index 0000000..e222487
--- /dev/null
+++ b/net/ipv6/netfilter/nft_tee_ipv6.c
@@ -0,0 +1,119 @@
+/*
+ * Copyright (c) 2015 Pablo Neira Ayuso <pablo@netfilter.org>
+ * Copyright (c) 2015 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
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
+	struct nft_tee *priv = nft_expr_priv(expr);
+	struct in6_addr gw;
+
+	memcpy(&gw, &regs->data[priv->sreg_gw], sizeof(struct in6_addr));
+	nf_tee_ipv6(pkt->skb, &priv->tee, pkt->ops->hooknum, &gw);
+}
+
+static int nft_tee_ipv6_init(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nlattr * const tb[])
+{
+	struct nft_tee *priv = nft_expr_priv(expr);
+	char oifname[IFNAMSIZ];
+	int err;
+
+	if (tb[NFTA_TEE_SREG_GW] == NULL)
+		return -EINVAL;
+
+	priv->sreg_gw = nft_parse_register(tb[NFTA_TEE_SREG_GW]);
+	err = nft_validate_register_load(priv->sreg_gw, sizeof(struct in6_addr));
+	if (err < 0)
+		return err;
+
+	memset(oifname, 0, sizeof(oifname));
+	if (tb[NFTA_TEE_OIFNAME] != NULL)
+		nla_strlcpy(oifname, tb[NFTA_TEE_OIFNAME], sizeof(oifname));
+
+	return nf_tee_init(&priv->tee, oifname);
+}
+
+static void nft_tee_ipv6_destroy(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr)
+{
+	struct nft_tee *priv = nft_expr_priv(expr);
+
+	nf_tee_fini(&priv->tee);
+}
+
+static int nft_tee_ipv6_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	struct nft_tee *priv = nft_expr_priv(expr);
+
+	if (nft_dump_register(skb, NFTA_TEE_SREG_GW, priv->sreg_gw))
+		goto nla_put_failure;
+
+	if (priv->tee.oifname[0]) {
+		if (nla_put_string(skb, NFTA_TEE_OIFNAME, priv->tee.oifname))
+			goto nla_put_failure;
+	}
+
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
+	.init		= nft_tee_ipv6_init,
+	.destroy	= nft_tee_ipv6_destroy,
+	.dump		= nft_tee_ipv6_dump,
+};
+
+static const struct nla_policy nft_tee_ipv6_policy[NFTA_TEE_MAX + 1] = {
+	[NFTA_TEE_SREG_GW]	= { .type = NLA_U32 },
+	[NFTA_TEE_OIFNAME]	= { .type = NLA_STRING,
+				    .len  = IFNAMSIZ - 1 },
+};
+
+static struct nft_expr_type nft_tee_ipv6_type __read_mostly = {
+	.family		= NFPROTO_IPV6,
+	.name		= "tee",
+	.ops		= &nft_tee_ipv6_ops,
+	.policy		= nft_tee_ipv6_policy,
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
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "tee");
-- 
1.7.10.4

