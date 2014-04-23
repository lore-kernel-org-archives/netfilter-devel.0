From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/5] netfilter: nf_tables: Add meta expression key for
 bridge interface name
Date: Wed, 23 Apr 2014 14:03:25 +0200
Message-ID: <20140423120325.GA7799@localhost>
References: <1397479290-6967-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1397479290-6967-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49978 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbaDWMGt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:06:49 -0400
Content-Disposition: inline
In-Reply-To: <1397479290-6967-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tomasz,

On Mon, Apr 14, 2014 at 03:41:28PM +0300, Tomasz Bursztyka wrote:
> NFT_META_BRI_IIFNAME to get packet input bridge interface name
> NFT_META_BRI_OIFNAME to get packet output bridge interface name

I'm going to take this patchset and enqueue to the nftables tree
(net-next), but before doing so, I'm going to rename
NFT_META_BRI_IIFNAME to NFT_META_IBRIPORT, the original name is a bit
long and I think the proposal to change the name also applies to this.

I'm attaching the mangled patch here.

--qDbXVdCdHGoSgWSk
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_tables-Add-meta-expression-key-for-brid.patch"

>From d3090dfe18931781debfd6596b81b9af84a9b8aa Mon Sep 17 00:00:00 2001
From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Date: Mon, 14 Apr 2014 15:41:28 +0300
Subject: [PATCH] netfilter: nf_tables: Add meta expression key for bridge
 interface name

NFT_META_IBRIPORT to get packet input bridge interface name
NFT_META_OBRIPORT to get packet output bridge interface name

Such meta key are accessible only through NFPROTO_BRIDGE family, on a
dedicated nft meta module: nft_meta_bridge.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |    4 +
 net/bridge/Makefile                      |    2 +-
 net/bridge/netfilter/Kconfig             |   14 ++-
 net/bridge/netfilter/Makefile            |    1 +
 net/bridge/netfilter/nft_meta_bridge.c   |  139 ++++++++++++++++++++++++++++++
 5 files changed, 158 insertions(+), 2 deletions(-)
 create mode 100644 net/bridge/netfilter/nft_meta_bridge.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 1601592..34928c1 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -563,6 +563,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_SECMARK: packet secmark (skb->secmark)
  * @NFT_META_NFPROTO: netfilter protocol
  * @NFT_META_L4PROTO: layer 4 protocol number
+ * @NFT_META_IBRIPORT: packet input bridge interface name
+ * @NFT_META_OBRIPORT: packet output bridge interface name
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -582,6 +584,8 @@ enum nft_meta_keys {
 	NFT_META_SECMARK,
 	NFT_META_NFPROTO,
 	NFT_META_L4PROTO,
+	NFT_META_IBRIPORT,
+	NFT_META_OBRIPORT,
 };
 
 /**
diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index e85498b2f..906a18b 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -16,4 +16,4 @@ bridge-$(CONFIG_BRIDGE_IGMP_SNOOPING) += br_multicast.o br_mdb.o
 
 bridge-$(CONFIG_BRIDGE_VLAN_FILTERING) += br_vlan.o
 
-obj-$(CONFIG_BRIDGE_NF_EBTABLES) += netfilter/
+obj-$(CONFIG_BRIDGE_NETFILTER) += netfilter/
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 5ca74a0..3baf29d 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -2,13 +2,25 @@
 # Bridge netfilter configuration
 #
 #
-config NF_TABLES_BRIDGE
+menuconfig NF_TABLES_BRIDGE
 	depends on NF_TABLES
+	select BRIDGE_NETFILTER
 	tristate "Ethernet Bridge nf_tables support"
 
+if NF_TABLES_BRIDGE
+
+config NFT_BRIDGE_META
+	tristate "Netfilter nf_table bridge meta support"
+	depends on NFT_META
+	help
+	  Add support for bridge dedicated meta key.
+
+endif # NF_TABLES_BRIDGE
+
 menuconfig BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
 	depends on BRIDGE && NETFILTER
+	select BRIDGE_NETFILTER
 	select NETFILTER_XTABLES
 	help
 	  ebtables is a general, extensible frame/packet identification
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index ea7629f..6f2f394 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_NF_TABLES_BRIDGE) += nf_tables_bridge.o
+obj-$(CONFIG_NFT_BRIDGE_META)  += nft_meta_bridge.o
 
 obj-$(CONFIG_BRIDGE_NF_EBTABLES) += ebtables.o
 
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
new file mode 100644
index 0000000..63c1b60
--- /dev/null
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -0,0 +1,139 @@
+/*
+ * Copyright (c) 2014 Intel Corporation
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
+#include <net/netfilter/nft_meta.h>
+
+#include "../br_private.h"
+
+static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
+				     struct nft_data data[NFT_REG_MAX + 1],
+				     const struct nft_pktinfo *pkt)
+{
+	const struct nft_meta *priv = nft_expr_priv(expr);
+	const struct net_device *in = pkt->in, *out = pkt->out;
+	struct nft_data *dest = &data[priv->dreg];
+	const struct net_bridge_port *p;
+
+	switch (priv->key) {
+	case NFT_META_IBRIPORT:
+		if (in == NULL || (p = br_port_get_rcu(in)) == NULL)
+			goto err;
+		break;
+	case NFT_META_OBRIPORT:
+		if (out == NULL || (p = br_port_get_rcu(out)) == NULL)
+			goto err;
+		break;
+	default:
+		goto out;
+	}
+
+	strncpy((char *)dest->data, p->br->dev->name, sizeof(dest->data));
+	return;
+out:
+	return nft_meta_get_eval(expr, data, pkt);
+err:
+	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+}
+
+static int nft_meta_bridge_get_init(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr,
+				    const struct nlattr * const tb[])
+{
+	struct nft_meta *priv = nft_expr_priv(expr);
+	int err;
+
+	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
+	switch (priv->key) {
+	case NFT_META_IBRIPORT:
+	case NFT_META_OBRIPORT:
+		break;
+	default:
+		return nft_meta_get_init(ctx, expr, tb);
+	}
+
+	priv->dreg = ntohl(nla_get_be32(tb[NFTA_META_DREG]));
+	err = nft_validate_output_register(priv->dreg);
+	if (err < 0)
+		return err;
+
+	err = nft_validate_data_load(ctx, priv->dreg, NULL, NFT_DATA_VALUE);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static struct nft_expr_type nft_meta_bridge_type;
+static const struct nft_expr_ops nft_meta_bridge_get_ops = {
+	.type		= &nft_meta_bridge_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
+	.eval		= nft_meta_bridge_get_eval,
+	.init		= nft_meta_bridge_get_init,
+	.dump		= nft_meta_get_dump,
+};
+
+static const struct nft_expr_ops nft_meta_bridge_set_ops = {
+	.type		= &nft_meta_bridge_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
+	.eval		= nft_meta_set_eval,
+	.init		= nft_meta_set_init,
+	.dump		= nft_meta_set_dump,
+};
+
+static const struct nft_expr_ops *
+nft_meta_bridge_select_ops(const struct nft_ctx *ctx,
+			   const struct nlattr * const tb[])
+{
+	if (tb[NFTA_META_KEY] == NULL)
+		return ERR_PTR(-EINVAL);
+
+	if (tb[NFTA_META_DREG] && tb[NFTA_META_SREG])
+		return ERR_PTR(-EINVAL);
+
+	if (tb[NFTA_META_DREG])
+		return &nft_meta_bridge_get_ops;
+
+	if (tb[NFTA_META_SREG])
+		return &nft_meta_bridge_set_ops;
+
+	return ERR_PTR(-EINVAL);
+}
+
+static struct nft_expr_type nft_meta_bridge_type __read_mostly = {
+	.family         = NFPROTO_BRIDGE,
+	.name           = "meta",
+	.select_ops     = &nft_meta_bridge_select_ops,
+	.policy         = nft_meta_policy,
+	.maxattr        = NFTA_META_MAX,
+	.owner          = THIS_MODULE,
+};
+
+static int __init nft_meta_bridge_module_init(void)
+{
+	return nft_register_expr(&nft_meta_bridge_type);
+}
+
+static void __exit nft_meta_bridge_module_exit(void)
+{
+	nft_unregister_expr(&nft_meta_bridge_type);
+}
+
+module_init(nft_meta_bridge_module_init);
+module_exit(nft_meta_bridge_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_BRIDGE, "meta");
-- 
1.7.10.4


--qDbXVdCdHGoSgWSk--
