From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nf-next] netfilter: nf_tables: add fwd expression to the netdev family
Date: Wed, 25 Nov 2015 13:39:38 +0100
Message-ID: <1448455178-21414-2-git-send-email-pablo@netfilter.org>
References: <1448455178-21414-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33317 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbbKYMjr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 07:39:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0E15E1324C6
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:39:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F0489DA80C
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:39:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EC826DA80C
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:39:43 +0100 (CET)
In-Reply-To: <1448455178-21414-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

You can use this to forward packets from ingress to the egress path of
the specified interface. This provides a fast path to bounce packets
from one interface to another specific destination interface.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This one looks very similar to dup, but it just drops the original packet.
I preferred to follow this path since I expect these two expressions to decouple
them so we have the freedom to make them evolve differently in the future.

I'll be sending the userspace code asap if no concern on this extension and the
previous one.

 include/uapi/linux/netfilter/nf_tables.h | 12 ++++
 net/netfilter/Kconfig                    |  6 ++
 net/netfilter/Makefile                   |  1 +
 net/netfilter/nft_fwd_netdev.c           | 98 ++++++++++++++++++++++++++++++++
 4 files changed, 117 insertions(+)
 create mode 100644 net/netfilter/nft_fwd_netdev.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index d8c8a7c..dd6e551 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -959,6 +959,18 @@ enum nft_dup_attributes {
 #define NFTA_DUP_MAX		(__NFTA_DUP_MAX - 1)
 
 /**
+ * enum nft_fwd_attributes - nf_tables fwd expression netlink attributes
+ *
+ * @NFTA_FWD_SREG_DEV: source register of output interface (NLA_U32: nft_register)
+ */
+enum nft_fwd_attributes {
+	NFTA_FWD_UNSPEC,
+	NFTA_FWD_SREG_DEV,
+	__NFTA_FWD_MAX
+};
+#define NFTA_FWD_MAX	(__NFTA_FWD_MAX - 1)
+
+/**
  * enum nft_gen_attributes - nf_tables ruleset generation attributes
  *
  * @NFTA_GEN_ID: Ruleset generation ID (NLA_U32)
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 8514cc4..8c067e6 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -577,6 +577,12 @@ config NFT_DUP_NETDEV
 	help
 	  This option enables packet duplication for the "netdev" family.
 
+config NFT_FWD_NETDEV
+	tristate "Netfilter nf_tables netdev packet forwarding support"
+	select NF_DUP_NETDEV
+	help
+	  This option enables packet forwarding for the "netdev" family.
+
 endif # NF_TABLES_NETDEV
 
 endif # NF_TABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 06fc0d60..2bf1225 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -95,6 +95,7 @@ obj-$(CONFIG_NFT_REDIR)		+= nft_redir.o
 
 # nf_tables netdev
 obj-$(CONFIG_NFT_DUP_NETDEV)	+= nft_dup_netdev.o
+obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
 
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
new file mode 100644
index 0000000..763ebc3
--- /dev/null
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -0,0 +1,98 @@
+/*
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
+#include <net/netfilter/nf_dup_netdev.h>
+
+struct nft_fwd_netdev {
+	enum nft_registers	sreg_dev:8;
+};
+
+static void nft_fwd_netdev_eval(const struct nft_expr *expr,
+				struct nft_regs *regs,
+				const struct nft_pktinfo *pkt)
+{
+	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
+	int oif = regs->data[priv->sreg_dev];
+
+	nf_dup_netdev_egress(pkt, oif);
+	regs->verdict.code = NF_DROP;
+}
+
+static const struct nla_policy nft_fwd_netdev_policy[NFTA_FWD_MAX + 1] = {
+	[NFTA_FWD_SREG_DEV]	= { .type = NLA_U32 },
+};
+
+static int nft_fwd_netdev_init(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nlattr * const tb[])
+{
+	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
+
+	if (tb[NFTA_FWD_SREG_DEV] == NULL)
+		return -EINVAL;
+
+	priv->sreg_dev = nft_parse_register(tb[NFTA_FWD_SREG_DEV]);
+	return nft_validate_register_load(priv->sreg_dev, sizeof(int));
+}
+
+static const struct nft_expr_ops nft_fwd_netdev_ingress_ops;
+
+static int nft_fwd_netdev_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
+
+	if (nft_dump_register(skb, NFTA_FWD_SREG_DEV, priv->sreg_dev))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nft_expr_type nft_fwd_netdev_type;
+static const struct nft_expr_ops nft_fwd_netdev_ops = {
+	.type		= &nft_fwd_netdev_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_fwd_netdev)),
+	.eval		= nft_fwd_netdev_eval,
+	.init		= nft_fwd_netdev_init,
+	.dump		= nft_fwd_netdev_dump,
+};
+
+static struct nft_expr_type nft_fwd_netdev_type __read_mostly = {
+	.family		= NFPROTO_NETDEV,
+	.name		= "fwd",
+	.ops		= &nft_fwd_netdev_ops,
+	.policy		= nft_fwd_netdev_policy,
+	.maxattr	= NFTA_FWD_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_fwd_netdev_module_init(void)
+{
+	return nft_register_expr(&nft_fwd_netdev_type);
+}
+
+static void __exit nft_fwd_netdev_module_exit(void)
+{
+	nft_unregister_expr(&nft_fwd_netdev_type);
+}
+
+module_init(nft_fwd_netdev_module_init);
+module_exit(nft_fwd_netdev_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_ALIAS_NFT_AF_EXPR(5, "fwd");
-- 
2.1.4

