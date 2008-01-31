From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [08/13] [NETFILTER]: ebtables: add ebt_ip6 match
Date: Fri, 1 Feb 2008 00:20:59 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802010020190.4864@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42935 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbYAaXVB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:21:01 -0500
In-Reply-To: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 860c9b7d78d73515e4c3b938e7fc1f78ca21edf8
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sun Jan 27 18:17:55 2008 +0100

    [NETFILTER]: ebtables: add ebt_ip6 match

    Allows to match the basic IPv6 header from within ebtables, much like
    there is ebt_ip for IPv4.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter_bridge/ebt_ip6.h |   21 ++++++
 net/bridge/netfilter/Kconfig             |    7 ++
 net/bridge/netfilter/Makefile            |    1 +
 net/bridge/netfilter/ebt_ip6.c           |   79 ++++++++++++++++++++++
 4 files changed, 108 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter_bridge/ebt_ip6.h
 create mode 100644 net/bridge/netfilter/ebt_ip6.c

diff --git a/include/linux/netfilter_bridge/ebt_ip6.h b/include/linux/netfilter_bridge/ebt_ip6.h
new file mode 100644
index 0000000..76afe72
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_ip6.h
@@ -0,0 +1,21 @@
+#ifndef _LINUX_NETFILTER_BRIDGE_EBT_IP6_H
+#define _LINUX_NETFILTER_BRIDGE_EBT_IP6_H 1
+
+enum {
+	EBT_IP6_SRCADDR  = 1 << 0,
+	EBT_IP6_DSTADDR  = 1 << 1,
+	EBT_IP6_TFCLASS  = 1 << 2,
+	EBT_IP6_FLOWLBL  = 1 << 3,
+	EBT_IP6_NEXTHDR  = 1 << 4,
+	EBT_IP6_HOPLIMIT = 1 << 5,
+};
+
+struct ebt_ip6_mtinfo {
+	struct in6_addr src, dst;
+	uint32_t flow_label;
+	uint8_t tf_class, nexthdr, hop_limit;
+
+	uint8_t match_flags, invert_flags;
+};
+
+#endif /* _LINUX_NETFILTER_BRIDGE_EBT_IP6ADDR_H */
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 4a3e2bf..f42db30 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -83,6 +83,13 @@ config BRIDGE_EBT_IP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config BRIDGE_EBT_IP6
+	tristate 'ebt: "ip6" IPv6 match support'
+	depends on BRIDGE_NF_EBTABLES
+	---help---
+	This option adds the "ip6" match which allows basic IPv6 header
+	field examination.
+
 config BRIDGE_EBT_LIMIT
 	tristate "ebt: limit match support"
 	depends on BRIDGE_NF_EBTABLES
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 905087e..0d8fb54 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_BRIDGE_EBT_802_3) += ebt_802_3.o
 obj-$(CONFIG_BRIDGE_EBT_AMONG) += ebt_among.o
 obj-$(CONFIG_BRIDGE_EBT_ARP) += ebt_arp.o
 obj-$(CONFIG_BRIDGE_EBT_IP) += ebt_ip.o
+obj-$(CONFIG_BRIDGE_EBT_IP6) += ebt_ip6.o
 obj-$(CONFIG_BRIDGE_EBT_LIMIT) += ebt_limit.o
 obj-$(CONFIG_BRIDGE_EBT_MARK) += ebt_mark_m.o
 obj-$(CONFIG_BRIDGE_EBT_PKTTYPE) += ebt_pkttype.o
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
new file mode 100644
index 0000000..5d6065c
--- /dev/null
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -0,0 +1,79 @@
+#include <linux/ipv6.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_ip6.h>
+#include <net/dsfield.h>
+#include <net/ipv6.h>
+
+static inline uint32_t ipv6_get_flowlbl(const struct ipv6hdr *iph)
+{
+	return ((iph->flow_lbl[0] << 16) | (iph->flow_lbl[2] << 8) |
+	       iph->flow_lbl[2]) & 0xFFFFF;
+}
+
+static int ebt_ip6_mt(const struct sk_buff *skb, const struct net_device *in,
+    const struct net_device *out, const void *matchinfo, unsigned int data_len)
+{
+	const struct ebt_ip6_mtinfo *info = matchinfo;
+	const struct ipv6hdr *iph;
+	struct ipv6hdr iphbuf;
+
+	iph = skb_header_pointer(skb, 0, sizeof(iphbuf), &iphbuf);
+	if (iph == NULL)
+		return EBT_NOMATCH;
+
+	if ((info->match_flags & EBT_IP6_TFCLASS) &&
+	    (ipv6_get_dsfield(iph) != info->tf_class) ^
+	    !!(info->invert_flags & EBT_IP6_TFCLASS))
+		return EBT_NOMATCH;
+
+	if ((info->match_flags & EBT_IP6_FLOWLBL) &&
+	    (ipv6_get_flowlbl(iph) != info->flow_label) ^
+	    !!(info->invert_flags & EBT_IP6_FLOWLBL))
+		return EBT_NOMATCH;
+
+	if ((info->match_flags & EBT_IP6_NEXTHDR) &&
+	    (iph->nexthdr != info->nexthdr) ^
+	    !!(info->invert_flags & EBT_IP6_NEXTHDR))
+		return EBT_NOMATCH;
+
+	if ((info->match_flags & EBT_IP6_HOPLIMIT) &&
+	    (iph->hop_limit != info->hop_limit) ^
+	    !!(info->invert_flags & EBT_IP6_HOPLIMIT))
+		return EBT_NOMATCH;
+
+	if ((info->match_flags & EBT_IP6_SRCADDR) &&
+	    (ipv6_addr_cmp(&iph->saddr, &info->src) != 0) ^
+	    !!(info->invert_flags & EBT_IP6_SRCADDR))
+		return EBT_NOMATCH;
+
+	if ((info->match_flags & EBT_IP6_DSTADDR) &&
+	    (ipv6_addr_cmp(&iph->daddr, &info->dst) != 0) ^
+	    !!(info->invert_flags & EBT_IP6_DSTADDR))
+		return EBT_NOMATCH;
+
+	return EBT_MATCH;
+}
+
+static struct ebt_match ebt_ip6_mt_reg = {
+	.name  = "ip6",
+	.match = ebt_ip6_mt,
+	.me    = THIS_MODULE,
+};
+
+static int __init ebt_ip6_mt_init(void)
+{
+	return ebt_register_match(&ebt_ip6_mt_reg);
+}
+
+static void __exit ebt_ip6_mt_exit(void)
+{
+	ebt_unregister_match(&ebt_ip6_mt_reg);
+}
+
+module_init(ebt_ip6_mt_init);
+module_exit(ebt_ip6_mt_exit);
+MODULE_LICENSE("GPL");
