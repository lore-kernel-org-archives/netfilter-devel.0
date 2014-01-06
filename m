From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH netfilter: nft] add connmark module
Date: Mon,  6 Jan 2014 13:29:12 +0100
Message-ID: <1389011352-11449-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:65247 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaAFM3W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:29:22 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so7816833ead.20
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 04:29:20 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

This patch adds a connmark module to nftables, which enables setting, storing
and restoring the connection mark (ctmark) of a tracked connection. It works in
the same way as xt_CONNMARK.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  35 +++++++
 net/netfilter/Kconfig                    |  10 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_connmark.c             | 169 +++++++++++++++++++++++++++++++
 4 files changed, 215 insertions(+)
 create mode 100644 net/netfilter/nft_connmark.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index aa86a152..ccf9f9f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -682,6 +682,41 @@ enum nft_queue_attributes {
 #define NFT_QUEUE_FLAG_MASK		0x03
 
 /**
+ * enum nft_connmark_types - nf_tables connmark expression types
+ *
+ * @NFT_CONNMARK_SAVE: save connmark
+ * @NFT_CONNMARK_RESTORE: restore connmark
+ * @NFT_CONNMARK_SET: set connmark (iptables set-xmark)
+ */
+enum nft_connmark_types {
+	NFT_CONNMARK_SAVE,
+	NFT_CONNMARK_RESTORE,
+	NFT_CONNMARK_SET
+};
+
+/**
+ * enum nft_connmark_attributes - nf_tables connmark expression netlink
+ * attributes
+ *
+ * @NFTA_CONNMARK_MODE: conntrack action (save, set or restore) (NLA_U8)
+ * @NFTA_CONNMARK_CTMARK: conntrack ctmark (NLA_U32)
+ * @NFTA_CONNMARK_CTMASK: conntrack ctmask (NLA_U32)
+ * @NFTA_CONNMARK_NFMASK: conntrack nfmask (NLA_U32)
+ */
+
+enum nft_connmark_attributes {
+	NFTA_CONNMARK_UNSPEC,
+	NFTA_CONNMARK_MODE,
+	NFTA_CONNMARK_CTMARK,
+	NFTA_CONNMARK_CTMASK,
+	NFTA_CONNMARK_NFMASK,
+	__NFTA_CONNMARK_MAX,
+};
+#define NFTA_CONNMARK_MAX		(__NFTA_CONNMARK_MAX - 1)
+
+#define NFT_CONNMARK_DEFAULT_MASK	0xFFFFFFFF
+
+/**
  * enum nft_reject_types - nf_tables reject expression reject types
  *
  * @NFT_REJECT_ICMP_UNREACH: reject using ICMP unreachable
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 0609514..d3ff630 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -471,6 +471,16 @@ config NFT_COUNTER
 	  This option adds the "counter" expression that you can use to
 	  include packet and byte counters in a rule.
 
+config NFT_CONNMARK
+	depends on NF_TABLES
+	depends on NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
+	select NF_CONNTRACK_MARK
+	tristate "Netfilter nf_tables conntrack module"
+	help
+		This option adds the "connmark" expression that can be used to
+		set, save or restore a mark on a tracked connection.
+
 config NFT_LOG
 	depends on NF_TABLES
 	tristate "Netfilter nf_tables log module"
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 39e4a7b..5097a2f 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -71,6 +71,7 @@ nf_tables-objs += nft_bitwise.o nft_byteorder.o nft_payload.o
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
+obj-$(CONFIG_NFT_CONNMARK)	+= nft_connmark.o
 obj-$(CONFIG_NFT_EXTHDR)	+= nft_exthdr.o
 obj-$(CONFIG_NFT_META)		+= nft_meta.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
diff --git a/net/netfilter/nft_connmark.c b/net/netfilter/nft_connmark.c
new file mode 100644
index 0000000..04d56d1
--- /dev/null
+++ b/net/netfilter/nft_connmark.c
@@ -0,0 +1,169 @@
+/* Copyright (c) 2013 Kristian Evensen <kristian.evensen@gmail.com>
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
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
+
+struct nft_connmark {
+	u32 ctmask;
+	union{
+		u32 ctmark;
+		u32 nfmask;
+	};
+	u8  mode;
+};
+
+static void nft_connmark_eval(const struct nft_expr *expr,
+			   struct nft_data data[NFT_REG_MAX + 1],
+			   const struct nft_pktinfo *pkt)
+{
+	struct nft_connmark *priv = nft_expr_priv(expr);
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	u_int32_t newmark;
+
+	ct = nf_ct_get(pkt->skb, &ctinfo);
+	if (ct == NULL)
+		return;
+
+	switch (priv->mode) {
+	case NFT_CONNMARK_SET:
+		newmark = (ct->mark & ~priv->ctmask) ^ priv->ctmark;
+		if (ct->mark != newmark) {
+			ct->mark = newmark;
+			nf_conntrack_event_cache(IPCT_MARK, ct);
+		}
+		break;
+	case NFT_CONNMARK_SAVE:
+		newmark = (ct->mark & ~priv->ctmask) ^
+			  (pkt->skb->mark & priv->nfmask);
+
+		if (ct->mark != newmark) {
+			ct->mark = newmark;
+			nf_conntrack_event_cache(IPCT_MARK, ct);
+		}
+		break;
+	case NFT_CONNMARK_RESTORE:
+		newmark = (pkt->skb->mark & ~priv->nfmask) ^
+			  (ct->mark & priv->ctmask);
+		pkt->skb->mark = newmark;
+		break;
+	}
+}
+
+static const struct nla_policy nft_connmark_policy[NFTA_CONNMARK_MAX + 1] = {
+	[NFTA_CONNMARK_MODE]	= { .type = NLA_U8 },
+	[NFTA_CONNMARK_CTMARK]	= { .type = NLA_U32 },
+	[NFTA_CONNMARK_CTMASK]	= { .type = NLA_U32 },
+	[NFTA_CONNMARK_NFMASK]  = { .type = NLA_U32 },
+};
+
+static int nft_connmark_init(const struct nft_ctx *ctx,
+			   const struct nft_expr *expr,
+			   const struct nlattr * const tb[])
+{
+	struct nft_connmark *priv = nft_expr_priv(expr);
+
+	if (tb[NFTA_CONNMARK_MODE] == NULL || tb[NFTA_CONNMARK_CTMASK] == NULL)
+		return -EINVAL;
+
+	priv->mode = nla_get_u8(tb[NFTA_CONNMARK_MODE]);
+	priv->ctmask = ntohl(nla_get_be32(tb[NFTA_CONNMARK_CTMASK]));
+
+	switch (priv->mode) {
+	case NFT_CONNMARK_SAVE:
+	case NFT_CONNMARK_RESTORE:
+		if (tb[NFTA_CONNMARK_NFMASK] == NULL)
+			return -EINVAL;
+
+		priv->nfmask = ntohl(nla_get_be32(tb[NFTA_CONNMARK_NFMASK]));
+
+		if (priv->mode == NFT_CONNMARK_RESTORE &&
+		    priv->ctmask != priv->nfmask)
+			return -EINVAL;
+		break;
+	case NFT_CONNMARK_SET:
+		if (tb[NFTA_CONNMARK_CTMARK] == NULL)
+			return -EINVAL;
+
+		priv->ctmark = ntohl(nla_get_be32(tb[NFTA_CONNMARK_CTMARK]));
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int nft_connmark_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_connmark *priv = nft_expr_priv(expr);
+
+	if (nla_put_u8(skb, NFTA_CONNMARK_MODE, priv->mode) ||
+	    nla_put_be32(skb, NFTA_CONNMARK_CTMASK, htonl(priv->ctmask)))
+		goto nla_put_failure;
+
+	switch (priv->mode) {
+	case NFT_CONNMARK_SAVE:
+	case NFT_CONNMARK_RESTORE:
+		if (nla_put_be32(skb, NFTA_CONNMARK_NFMASK,
+				 htonl(priv->nfmask)))
+			goto nla_put_failure;
+		break;
+	case NFT_CONNMARK_SET:
+		if (nla_put_be32(skb, NFTA_CONNMARK_CTMARK,
+				 htonl(priv->ctmark)))
+			goto nla_put_failure;
+		break;
+	}
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nft_expr_type nft_connmark_type;
+static const struct nft_expr_ops nft_connmark_ops = {
+	.type		= &nft_connmark_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_connmark)),
+	.eval		= nft_connmark_eval,
+	.init		= nft_connmark_init,
+	.dump		= nft_connmark_dump,
+};
+
+static struct nft_expr_type nft_connmark_type __read_mostly = {
+	.name		= "connmark",
+	.ops		= &nft_connmark_ops,
+	.policy		= nft_connmark_policy,
+	.maxattr	= NFTA_CONNMARK_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_connmark_module_init(void)
+{
+	return nft_register_expr(&nft_connmark_type);
+}
+
+static void __exit nft_connmark_module_exit(void)
+{
+	nft_unregister_expr(&nft_connmark_type);
+}
+
+module_init(nft_connmark_module_init);
+module_exit(nft_connmark_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kristian Evensen <kristian.evensen@gmail.com>");
+MODULE_ALIAS_NFT_EXPR("connmark");
-- 
1.8.3.2

