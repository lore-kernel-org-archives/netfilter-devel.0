From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nf-next] netfilter: nf_tables: add packet duplication to the netdev family
Date: Wed, 25 Nov 2015 13:39:37 +0100
Message-ID: <1448455178-21414-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33315 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbbKYMjq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 07:39:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 078091324C5
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:39:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CA42DDA807
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:39:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8E87FDA863
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:39:42 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

You can use this to duplicate packets and inject them at the egress path
of the specified interface. This duplication allows you to inspect
traffic from the dummy or any other interface dedicated to this purpose.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I have a patch here to add a new NFTA_DATA_IFACE type and an infrastructure to
keep track of the interface indexes so we can avoid the interface lookup from
the packet path. This allows us to pass pointers between expressions, but such
change would require however that we perform a bit more validation at per rule.

I think we'll need similar specific datatype objects in the kernel to pass
information that does fit into our registers, eg. we've been recently discussing
that the new cgroup infrastructure may require a PATH_MAX (ie. 4096) class ID.
Another possibility is to allow passing immediates to the expressions to avoid
one extra indirection (Patrick already mentioned this last time we talked about
this, it would also get things faster).

Last time I discussed this with Patrick, we agreed on postponing this
infrastructure until the optimized representation for constant rulesets is
clear, but I'm afraid adding this infrastructure later on will be require a new
attribute for the immediate expression two pass two different
NFTA_IMMEDIATE_DATA and NFTA_IMMEDIATE_DATA2 to retain backward compatibility,
one with the raw value useing NFTA_DATA_VALUE and another with NFTA_DATA_IFACE.

Another important aspect to keep in mind if we ever get egress support is that
this expression can lead to deadlock if you duplicate traffic to your own
device due. But that doesn't affect us at this stage.

BTW, this is using the NFTA_DUP_SREG_DEV register but from userspace the syntax
looks like:

	... dup to eth0

which looks like a more natural way to express this to me.

Note that I have moved the nf_dup_netdev_egress() code into a separated module
so this can be reuses by the follow up 'fwd' expression.

Let me know, thanks!

 include/net/netfilter/nf_dup_netdev.h |  6 +++
 net/netfilter/Kconfig                 | 16 ++++++
 net/netfilter/Makefile                |  6 +++
 net/netfilter/nf_dup_netdev.c         | 40 +++++++++++++++
 net/netfilter/nft_dup_netdev.c        | 97 +++++++++++++++++++++++++++++++++++
 5 files changed, 165 insertions(+)
 create mode 100644 include/net/netfilter/nf_dup_netdev.h
 create mode 100644 net/netfilter/nf_dup_netdev.c
 create mode 100644 net/netfilter/nft_dup_netdev.c

diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
new file mode 100644
index 0000000..397dcae
--- /dev/null
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -0,0 +1,6 @@
+#ifndef _NF_DUP_NETDEV_H_
+#define _NF_DUP_NETDEV_H_
+
+void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
+
+#endif
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 4692782..8514cc4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -563,6 +563,22 @@ config NFT_COMPAT
 	  x_tables match/target extensions over the nf_tables
 	  framework.
 
+if NF_TABLES_NETDEV
+
+config NF_DUP_NETDEV
+	tristate "Netfilter packet duplication support"
+	help
+	  This option enables the generic packet duplication infrastructure
+	  for Netfilter.
+
+config NFT_DUP_NETDEV
+	tristate "Netfilter nf_tables netdev packet duplication support"
+	select NF_DUP_NETDEV
+	help
+	  This option enables packet duplication for the "netdev" family.
+
+endif # NF_TABLES_NETDEV
+
 endif # NF_TABLES
 
 config NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 7638c36..06fc0d60 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -66,6 +66,9 @@ obj-$(CONFIG_NF_NAT_TFTP) += nf_nat_tftp.o
 # SYNPROXY
 obj-$(CONFIG_NETFILTER_SYNPROXY) += nf_synproxy_core.o
 
+# generic packet duplication from netdev family
+obj-$(CONFIG_NF_DUP_NETDEV)	+= nf_dup_netdev.o
+
 # nf_tables
 nf_tables-objs += nf_tables_core.o nf_tables_api.o
 nf_tables-objs += nft_immediate.o nft_cmp.o nft_lookup.o nft_dynset.o
@@ -90,6 +93,9 @@ obj-$(CONFIG_NFT_LOG)		+= nft_log.o
 obj-$(CONFIG_NFT_MASQ)		+= nft_masq.o
 obj-$(CONFIG_NFT_REDIR)		+= nft_redir.o
 
+# nf_tables netdev
+obj-$(CONFIG_NFT_DUP_NETDEV)	+= nft_dup_netdev.o
+
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
 
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
new file mode 100644
index 0000000..e009408
--- /dev/null
+++ b/net/netfilter/nf_dup_netdev.c
@@ -0,0 +1,40 @@
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
+
+void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif)
+{
+	struct net_device *dev;
+	struct sk_buff *skb;
+
+	dev = dev_get_by_index_rcu(pkt->net, oif);
+	if (dev == NULL)
+		return;
+
+	skb = skb_clone(pkt->skb, GFP_ATOMIC);
+	if (skb == NULL)
+		return;
+
+	if(skb_mac_header_was_set(skb))
+		skb_push(skb, skb->mac_len);
+
+	skb->dev = dev;
+	skb_sender_cpu_clear(skb);
+	dev_queue_xmit(skb);
+}
+EXPORT_SYMBOL_GPL(nf_dup_netdev_egress);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
new file mode 100644
index 0000000..2cc1e0e
--- /dev/null
+++ b/net/netfilter/nft_dup_netdev.c
@@ -0,0 +1,97 @@
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
+struct nft_dup_netdev {
+	enum nft_registers	sreg_dev:8;
+};
+
+static void nft_dup_netdev_eval(const struct nft_expr *expr,
+				struct nft_regs *regs,
+				const struct nft_pktinfo *pkt)
+{
+	struct nft_dup_netdev *priv = nft_expr_priv(expr);
+	int oif = regs->data[priv->sreg_dev];
+
+	nf_dup_netdev_egress(pkt, oif);
+}
+
+static const struct nla_policy nft_dup_netdev_policy[NFTA_DUP_MAX + 1] = {
+	[NFTA_DUP_SREG_DEV]	= { .type = NLA_U32 },
+};
+
+static int nft_dup_netdev_init(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nlattr * const tb[])
+{
+	struct nft_dup_netdev *priv = nft_expr_priv(expr);
+
+	if (tb[NFTA_DUP_SREG_DEV] == NULL)
+		return -EINVAL;
+
+	priv->sreg_dev = nft_parse_register(tb[NFTA_DUP_SREG_DEV]);
+	return nft_validate_register_load(priv->sreg_dev, sizeof(int));
+}
+
+static const struct nft_expr_ops nft_dup_netdev_ingress_ops;
+
+static int nft_dup_netdev_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	struct nft_dup_netdev *priv = nft_expr_priv(expr);
+
+	if (nft_dump_register(skb, NFTA_DUP_SREG_DEV, priv->sreg_dev))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nft_expr_type nft_dup_netdev_type;
+static const struct nft_expr_ops nft_dup_netdev_ops = {
+	.type		= &nft_dup_netdev_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_dup_netdev)),
+	.eval		= nft_dup_netdev_eval,
+	.init		= nft_dup_netdev_init,
+	.dump		= nft_dup_netdev_dump,
+};
+
+static struct nft_expr_type nft_dup_netdev_type __read_mostly = {
+	.family		= NFPROTO_NETDEV,
+	.name		= "dup",
+	.ops		= &nft_dup_netdev_ops,
+	.policy		= nft_dup_netdev_policy,
+	.maxattr	= NFTA_DUP_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_dup_netdev_module_init(void)
+{
+	return nft_register_expr(&nft_dup_netdev_type);
+}
+
+static void __exit nft_dup_netdev_module_exit(void)
+{
+	nft_unregister_expr(&nft_dup_netdev_type);
+}
+
+module_init(nft_dup_netdev_module_init);
+module_exit(nft_dup_netdev_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_ALIAS_NFT_AF_EXPR(5, "dup");
-- 
2.1.4

