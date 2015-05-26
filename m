From: Eddie Linder <eddi@guardicore.com>
Subject: [PATCH 1/1] netfilter: Added vlan matching extension
Date: Tue, 26 May 2015 02:13:43 -0700
Message-ID: <1432631623-44211-1-git-send-email-eddi@guardicore.com>
Cc: Eddie Linder <eddi@guardicore.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37048 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbbEZNS6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2015 09:18:58 -0400
Received: by wifw1 with SMTP id w1so30531448wif.0
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2015 06:18:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eddie Linder <eddi@guardicore.com>
---
 include/uapi/linux/netfilter/Kbuild    |  1 +
 include/uapi/linux/netfilter/xt_vlan.h | 10 ++++
 net/netfilter/Makefile                 |  1 +
 net/netfilter/xt_vlan.c                | 88 ++++++++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+)
 create mode 100644 include/uapi/linux/netfilter/xt_vlan.h
 create mode 100644 net/netfilter/xt_vlan.c

diff --git a/include/uapi/linux/netfilter/Kbuild b/include/uapi/linux/netfilter/Kbuild
index 1d973d2..2ca36db 100644
--- a/include/uapi/linux/netfilter/Kbuild
+++ b/include/uapi/linux/netfilter/Kbuild
@@ -85,3 +85,4 @@ header-y += xt_tcpmss.h
 header-y += xt_tcpudp.h
 header-y += xt_time.h
 header-y += xt_u32.h
+header-y += xt_vlan.h
diff --git a/include/uapi/linux/netfilter/xt_vlan.h b/include/uapi/linux/netfilter/xt_vlan.h
new file mode 100644
index 0000000..71e8089
--- /dev/null
+++ b/include/uapi/linux/netfilter/xt_vlan.h
@@ -0,0 +1,10 @@
+#ifndef _XT_VLAN_H
+#define _XT_VLAN_H
+
+
+struct xt_vlan_info {
+	__u16 vlan_id;
+	__u8 vlan_pcp;
+	__u8 invert;
+};
+#endif /*_XT_VLAN_H */
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index a87d8b8..37ecfb0 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -169,6 +169,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) += xt_time.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_VLAN) += xt_vlan.o
 
 # ipset
 obj-$(CONFIG_IP_SET) += ipset/
diff --git a/net/netfilter/xt_vlan.c b/net/netfilter/xt_vlan.c
new file mode 100644
index 0000000..1441eed
--- /dev/null
+++ b/net/netfilter/xt_vlan.c
@@ -0,0 +1,88 @@
+/* Kernel module to match VLAN tag parameters.
+ * (C) 2015 Eddie Linder <eddi@guardicore.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/if_vlan.h>
+
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
+#include <linux/netfilter/xt_vlan.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Eddie Linder <eddi@guardicore.com>");
+MODULE_DESCRIPTION("Xtables: VLAN tag match");
+MODULE_ALIAS("ipt_vlan");
+MODULE_ALIAS("ip6t_vlan");
+
+static bool parse_vlan(const struct sk_buff *skb, u16 *vlan_tci)
+{
+	struct vlan_hdr *vhdr;
+
+	if (skb->data - VLAN_HLEN < skb->head)
+		return false;
+	vhdr = (struct vlan_hdr *)(skb->data - VLAN_HLEN);
+	*vlan_tci = ntohs(vhdr->h_vlan_TCI);
+	return true;
+}
+
+static bool vlan_mt(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct xt_vlan_info *info = par->matchinfo;
+	u16 vlan_tci = ~VLAN_TAG_PRESENT;
+	bool ret;
+
+	if (skb_vlan_tag_present(skb)) {
+		vlan_tci = skb_vlan_tag_get(skb);
+	} else {
+		if (unlikely(skb->len < VLAN_ETH_HLEN))
+			return false;
+		if (skb->protocol != htons(ETH_P_8021Q))
+			return false;
+		if (unlikely(!parse_vlan(skb, &vlan_tci)))
+			return false;
+	}
+
+	if ((vlan_tci & VLAN_VID_MASK) == info->vlan_id)
+		ret = true;
+
+	ret ^= info->invert;
+
+	if (ret && info->vlan_pcp) {
+		unsigned char vlan_pcp =
+			(vlan_tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+
+		ret &= (vlan_pcp == info->vlan_pcp);
+	}
+
+	return ret;
+}
+
+static struct xt_match vlan_mt_reg __read_mostly = {
+	.name      = "vlan",
+	.revision  = 0,
+	.family    = NFPROTO_UNSPEC,
+	.match     = vlan_mt,
+	.matchsize = sizeof(struct xt_vlan_info),
+	.me        = THIS_MODULE,
+};
+
+static int __init vlan_mt_init(void)
+{
+	return xt_register_match(&vlan_mt_reg);
+}
+
+static void __exit vlan_mt_exit(void)
+{
+	xt_unregister_match(&vlan_mt_reg);
+}
+
+module_init(vlan_mt_init);
+module_exit(vlan_mt_exit);
+
-- 
1.9.1

