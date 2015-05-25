From: Eddie Linder <eddi@guardicore.com>
Subject: [PATCH 1/1] netfilter: Added vlan matching extension
Date: Mon, 25 May 2015 13:37:30 -0700
Message-ID: <1432586250-42147-1-git-send-email-eddi@guardicore.com>
Cc: Eddie Linder <eddi@guardicore.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36724 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbbEYUho (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2015 16:37:44 -0400
Received: by wizk4 with SMTP id k4so57379383wiz.1
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2015 13:37:42 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eddie Linder <eddi@guardicore.com>
---
 include/uapi/linux/netfilter/Kbuild    |  1 +
 include/uapi/linux/netfilter/xt_vlan.h | 11 ++++
 net/netfilter/Makefile                 |  1 +
 net/netfilter/xt_vlan.c                | 91 ++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+)
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
index 0000000..3c31b6b
--- /dev/null
+++ b/include/uapi/linux/netfilter/xt_vlan.h
@@ -0,0 +1,11 @@
+#ifndef _XT_VLAN_H
+#define _XT_VLAN_H
+
+
+struct xt_vlan_info {
+	unsigned short vlan_id;
+	unsigned char vlan_pcp;
+	unsigned char invert;
+};
+#endif /*_XT_VLAN_H */
+
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
index 0000000..c583d48
--- /dev/null
+++ b/net/netfilter/xt_vlan.c
@@ -0,0 +1,91 @@
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
+MODULE_ALIAS("ipt_VLAN");
+MODULE_ALIAS("ip6t_VLAN");
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
+	if (skb->vlan_tci & VLAN_TAG_PRESENT)
+		/* Strip the 4096 bit (invalid vlan) from the vlan tci bits */
+		vlan_tci = skb->vlan_tci;
+	else {
+		if (unlikely(skb->len < VLAN_ETH_HLEN &&
+			     skb->protocol == htons(ETH_P_8021Q)))
+			if (unlikely(!parse_vlan(skb, &vlan_tci)))
+				return false;
+			else
+				return false;
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

