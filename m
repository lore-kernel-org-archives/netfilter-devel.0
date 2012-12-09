From: Willem de Bruijn <willemb@google.com>
Subject: [PATCH] netfilter: add xt_skbuff xtables match
Date: Sun,  9 Dec 2012 15:28:20 -0500
Message-ID: <1355084900-12966-1-git-send-email-willemb@google.com>
References: <CA+FuTSdfR97kDd8xhnMTpy4umtrxBoP-xSaD77iTCZn9y-ZTiw@mail.gmail.com>
Cc: Willem de Bruijn <willemb@google.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:46391 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758925Ab2LIU23 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2012 15:28:29 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so249339ghb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Dec 2012 12:28:29 -0800 (PST)
In-Reply-To: <CA+FuTSdfR97kDd8xhnMTpy4umtrxBoP-xSaD77iTCZn9y-ZTiw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add an iptables match based on skb fields, such as mark, priority,
input interface and rxhash. The match supports range based matching
on one field, with optional inversion and masking.

v2: switches from xt_priority to xt_skbuff. Pablo, is this what
you had in mind? It doesn't perfectly duplicate the values from
nftables xt_meta. Needs more testing to cover the field-specific
codepaths.

Tested by inserting

iptables -t mangle -A PREROUTING -s $SRC -j MARK --set-mark 10
iptables -A INPUT -m skbuff --min 10 --max 10 -j TRACE

The userspace tool needs work, too. For one, I just hardcoded the
field_id to be skb_field_mark for this test. That's why it's missing
from the command line.

Change-Id: Ib855409fb940acc9eccc87e2a550a875d9b19fd1
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/netfilter/xt_skbuff.h |   36 +++++++++
 net/netfilter/Kconfig               |    9 ++
 net/netfilter/Makefile              |    1 +
 net/netfilter/xt_skbuff.c           |  141 +++++++++++++++++++++++++++++++++++
 4 files changed, 187 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_skbuff.h
 create mode 100644 net/netfilter/xt_skbuff.c

diff --git a/include/linux/netfilter/xt_skbuff.h b/include/linux/netfilter/xt_skbuff.h
new file mode 100644
index 0000000..1d7aa63
--- /dev/null
+++ b/include/linux/netfilter/xt_skbuff.h
@@ -0,0 +1,36 @@
+#ifndef _XT_SKBUFF_H
+#define _XT_SKBUFF_H
+
+#include <linux/types.h>
+
+enum xt_skbuff_field_selector {
+	SKB_FIELD_CSUM = 0,
+	SKB_FIELD_HATYPE,
+	SKB_FIELD_IFINDEX,
+	SKB_FIELD_LEN,
+	SKB_FIELD_MARK,
+	SKB_FIELD_PKT_TYPE,
+	SKB_FIELD_PRIORITY,
+	SKB_FIELD_PROTOCOL,
+	SKB_FIELD_QUEUE_MAPPING,
+	SKB_FIELD_RT_CLASSID,
+	SKB_FIELD_RXHASH,
+	SKB_FIELD_SECMARK,
+	SKB_FIELD_SK_UID,
+	SKB_FIELD_SK_GID,
+	SKB_FIELD_TSTAMP,
+	SKB_FIELD_VLAN_TCI,
+
+	/* must be the last element */
+	SKB_FIELD_MAX,
+};
+
+struct xt_skbuff_info {
+	__u16 field_id;		/* an xt_skbuff_field_selector value */
+	__u8  invert;
+	__u64 min;
+	__u64 max;
+	__u64 mask;
+};
+
+#endif /*_XT_SKBUFF_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index fefa514..3a07a86 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1093,6 +1093,15 @@ config NETFILTER_XT_MATCH_PKTTYPE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_SKBUFF
+	tristate '"skbuff" match support'
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds a match based on the value of a chosen sk_buff
+	  field.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_QUOTA
 	tristate '"quota" match support'
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 3259697..9bc95e0 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -129,6 +129,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_RATEEST) += xt_rateest.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_RECENT) += xt_recent.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_SKBUFF) += xt_skbuff.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SOCKET) += xt_socket.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
diff --git a/net/netfilter/xt_skbuff.c b/net/netfilter/xt_skbuff.c
new file mode 100644
index 0000000..bd9ce7c
--- /dev/null
+++ b/net/netfilter/xt_skbuff.c
@@ -0,0 +1,141 @@
+/* Xtables module to match packets based on sk_buff fields.
+ * Copyright 2012 Google Inc.
+ * Written by Willem de Bruijn <willemb@google.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/sock.h>
+
+#include <linux/netfilter/xt_skbuff.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_AUTHOR("Willem de Bruijn <willemb@google.com>");
+MODULE_DESCRIPTION("Xtables: skbuff match");
+MODULE_LICENSE("GPL");
+
+static bool skbuff_mt(const struct sk_buff *skb,
+			struct xt_action_param *par)
+{
+	const struct xt_skbuff_info *info = par->matchinfo;
+	u64 value;
+
+	switch (info->field_id) {
+	case SKB_FIELD_CSUM:
+		if (skb->ip_summed != CHECKSUM_COMPLETE)
+			return false;
+		value = skb->csum;
+		break;
+	case SKB_FIELD_HATYPE:
+		if (!skb->dev)
+			return false;
+		value = skb->dev->type;
+		break;
+	case SKB_FIELD_IFINDEX:
+		if (!skb->dev)
+			return false;
+		value = skb->dev->ifindex;
+		break;
+	case SKB_FIELD_LEN:
+		value = skb->len;
+		break;
+	case SKB_FIELD_MARK:
+		value = skb->mark;
+		break;
+	case SKB_FIELD_PKT_TYPE:
+		value = skb->pkt_type;
+		break;
+	case SKB_FIELD_PRIORITY:
+		value = skb->priority;
+		break;
+	case SKB_FIELD_PROTOCOL:
+		value = skb->protocol;
+		break;
+	case SKB_FIELD_QUEUE_MAPPING:
+		value = skb->queue_mapping;
+		break;
+	case SKB_FIELD_RT_CLASSID:
+#ifdef CONFIG_NET_CLS_ROUTE
+		const struct dst_entry *dst;
+
+		rcu_read_lock();
+		dst = skb_dst(skb);
+		if (dst)
+			value = dst->tclassid;
+		rcu_read_unlock();
+		if (!dst)
+			return false;
+		break;
+#else
+		return false;
+#endif
+	case SKB_FIELD_RXHASH:
+		value = skb->rxhash;
+		break;
+	case SKB_FIELD_SECMARK:
+#ifdef CONFIG_NETWORK_SECMARK
+		value = skb->secmark;
+		break;
+#else
+		return false;
+#endif
+	case SKB_FIELD_SK_UID:
+		if (!skb->sk || !skb->sk->sk_socket || !skb->sk->sk_socket->file)
+			return false;
+		value = skb->sk->sk_socket->file->f_cred->fsuid;
+		break;
+	case SKB_FIELD_SK_GID:
+		if (!skb->sk || !skb->sk->sk_socket || !skb->sk->sk_socket->file)
+			return false;
+		value = skb->sk->sk_socket->file->f_cred->fsgid;
+		break;
+	case SKB_FIELD_TSTAMP:
+		value = skb->tstamp.tv64;
+		break;
+	case SKB_FIELD_VLAN_TCI:
+		value = skb->vlan_tci;
+		break;
+	default:
+		return false;
+	}
+
+	value &= info->mask;
+	return (value >= info->min && value <= info->max) ^ info->invert;
+}
+
+static int skbuff_mt_check(const struct xt_mtchk_param *par)
+{
+	const struct xt_skbuff_info *info = par->matchinfo;
+
+	if (info->field_id >= SKB_FIELD_MAX)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static struct xt_match skbuff_mt_reg __read_mostly = {
+	.name		= "skbuff",
+	.revision	= 0,
+	.family		= NFPROTO_UNSPEC,
+	.match		= skbuff_mt,
+	.matchsize	= sizeof(struct xt_skbuff_info),
+	.checkentry	= skbuff_mt_check,
+	.me		= THIS_MODULE,
+};
+
+static int __init skbuff_mt_init(void)
+{
+	return xt_register_match(&skbuff_mt_reg);
+}
+
+static void __exit skbuff_mt_exit(void)
+{
+	xt_unregister_match(&skbuff_mt_reg);
+}
+
+module_init(skbuff_mt_init);
+module_exit(skbuff_mt_exit);
-- 
1.7.7.3

