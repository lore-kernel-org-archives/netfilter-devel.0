From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6]: port physdev to ip6tables
Date: Thu, 16 Sep 2004 18:35:43 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4149C0DF.9040204@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040902070604040801070605"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040902070604040801070605
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

at the netfilter workshop Harald and I agreed that it would
be easier if I would submit netfilter patches directly to
you, if you don't mind. I'll try not to clash with Harald.
If you're fine with this, here is the first one:

ChangeSet@1.1902, 2004-09-16 17:45:08+02:00, bdschuym@pandora.be
  [NETFILTER]: port physdev to ip6tables

According to Bart, the physdev module is essential for people
wanting to filter bridged IPv6 frames.

You can also pull the patch from bk://212.42.230.204/net-2.6


--------------040902070604040801070605
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/16 17:45:08+02:00 bdschuym@pandora.be 
#   [NETFILTER]: port physdev to ip6tables
#   
#   Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_physdev.c
#   2004/09/16 17:44:45+02:00 bdschuym@pandora.be +136 -0
# 
# net/ipv6/netfilter/ip6t_physdev.c
#   2004/09/16 17:44:45+02:00 bdschuym@pandora.be +0 -0
#   BitKeeper file /home/kaber/src/net/net-2.6/net/ipv6/netfilter/ip6t_physdev.c
# 
# include/linux/netfilter_ipv6/ip6t_physdev.h
#   2004/09/16 17:44:43+02:00 bdschuym@pandora.be +24 -0
# 
# net/ipv6/netfilter/Makefile
#   2004/09/16 17:44:43+02:00 bdschuym@pandora.be +1 -0
#   [NETFILTER]: port physdev to ip6tables
# 
# net/ipv6/netfilter/Kconfig
#   2004/09/16 17:44:43+02:00 bdschuym@pandora.be +9 -0
#   [NETFILTER]: port physdev to ip6tables
# 
# include/linux/netfilter_ipv6/ip6t_physdev.h
#   2004/09/16 17:44:43+02:00 bdschuym@pandora.be +0 -0
#   BitKeeper file /home/kaber/src/net/net-2.6/include/linux/netfilter_ipv6/ip6t_physdev.h
# 
diff -Nru a/include/linux/netfilter_ipv6/ip6t_physdev.h b/include/linux/netfilter_ipv6/ip6t_physdev.h
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/include/linux/netfilter_ipv6/ip6t_physdev.h	2004-09-16 18:30:22 +02:00
@@ -0,0 +1,24 @@
+#ifndef _IP6T_PHYSDEV_H
+#define _IP6T_PHYSDEV_H
+
+#ifdef __KERNEL__
+#include <linux/if.h>
+#endif
+
+#define IP6T_PHYSDEV_OP_IN		0x01
+#define IP6T_PHYSDEV_OP_OUT		0x02
+#define IP6T_PHYSDEV_OP_BRIDGED		0x04
+#define IP6T_PHYSDEV_OP_ISIN		0x08
+#define IP6T_PHYSDEV_OP_ISOUT		0x10
+#define IP6T_PHYSDEV_OP_MASK		(0x20 - 1)
+
+struct ip6t_physdev_info {
+	char physindev[IFNAMSIZ];
+	char in_mask[IFNAMSIZ];
+	char physoutdev[IFNAMSIZ];
+	char out_mask[IFNAMSIZ];
+	u_int8_t invert;
+	u_int8_t bitmask;
+};
+
+#endif /*_IP6T_PHYSDEV_H*/
diff -Nru a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
--- a/net/ipv6/netfilter/Kconfig	2004-09-16 18:30:22 +02:00
+++ b/net/ipv6/netfilter/Kconfig	2004-09-16 18:30:22 +02:00
@@ -158,6 +158,15 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP6_NF_MATCH_PHYSDEV
+	tristate "Physdev match support"
+	depends on IP6_NF_IPTABLES && BRIDGE_NETFILTER
+	help
+	  Physdev packet matching matches against the physical bridge ports
+	  the IP packet arrived on or will leave by.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 #  dep_tristate '  Multiple port match support' CONFIG_IP6_NF_MATCH_MULTIPORT $CONFIG_IP6_NF_IPTABLES
 #  dep_tristate '  TOS match support' CONFIG_IP6_NF_MATCH_TOS $CONFIG_IP6_NF_IPTABLES
 #  if [ "$CONFIG_IP6_NF_CONNTRACK" != "n" ]; then
diff -Nru a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
--- a/net/ipv6/netfilter/Makefile	2004-09-16 18:30:22 +02:00
+++ b/net/ipv6/netfilter/Makefile	2004-09-16 18:30:22 +02:00
@@ -16,6 +16,7 @@
 obj-$(CONFIG_IP6_NF_MATCH_EUI64) += ip6t_eui64.o
 obj-$(CONFIG_IP6_NF_MATCH_MULTIPORT) += ip6t_multiport.o
 obj-$(CONFIG_IP6_NF_MATCH_OWNER) += ip6t_owner.o
+obj-$(CONFIG_IP6_NF_MATCH_PHYSDEV) += ip6t_physdev.o
 obj-$(CONFIG_IP6_NF_FILTER) += ip6table_filter.o
 obj-$(CONFIG_IP6_NF_MANGLE) += ip6table_mangle.o
 obj-$(CONFIG_IP6_NF_TARGET_MARK) += ip6t_MARK.o
diff -Nru a/net/ipv6/netfilter/ip6t_physdev.c b/net/ipv6/netfilter/ip6t_physdev.c
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/net/ipv6/netfilter/ip6t_physdev.c	2004-09-16 18:30:22 +02:00
@@ -0,0 +1,136 @@
+/* Kernel module to match the bridge port in and
+ * out device for IP packets coming into contact with a bridge. */
+
+/* (C) 2001-2003 Bart De Schuymer <bdschuym@pandora.be>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter_ipv6/ip6t_physdev.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_bridge.h>
+#define MATCH   1
+#define NOMATCH 0
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
+MODULE_DESCRIPTION("iptables bridge physical device match module");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      const void *hdr,
+      u_int16_t datalen,
+      int *hotdrop)
+{
+	int i;
+	static const char nulldevname[IFNAMSIZ];
+	const struct ip6t_physdev_info *info = matchinfo;
+	unsigned int ret;
+	const char *indev, *outdev;
+	struct nf_bridge_info *nf_bridge;
+
+	/* Not a bridged IP packet or no info available yet:
+	 * LOCAL_OUT/mangle and LOCAL_OUT/nat don't know if
+	 * the destination device will be a bridge. */
+	if (!(nf_bridge = skb->nf_bridge)) {
+		/* Return MATCH if the invert flags of the used options are on */
+		if ((info->bitmask & IP6T_PHYSDEV_OP_BRIDGED) &&
+		    !(info->invert & IP6T_PHYSDEV_OP_BRIDGED))
+			return NOMATCH;
+		if ((info->bitmask & IP6T_PHYSDEV_OP_ISIN) &&
+		    !(info->invert & IP6T_PHYSDEV_OP_ISIN))
+			return NOMATCH;
+		if ((info->bitmask & IP6T_PHYSDEV_OP_ISOUT) &&
+		    !(info->invert & IP6T_PHYSDEV_OP_ISOUT))
+			return NOMATCH;
+		if ((info->bitmask & IP6T_PHYSDEV_OP_IN) &&
+		    !(info->invert & IP6T_PHYSDEV_OP_IN))
+			return NOMATCH;
+		if ((info->bitmask & IP6T_PHYSDEV_OP_OUT) &&
+		    !(info->invert & IP6T_PHYSDEV_OP_OUT))
+			return NOMATCH;
+		return MATCH;
+	}
+
+	/* This only makes sense in the FORWARD and POSTROUTING chains */
+	if ((info->bitmask & IP6T_PHYSDEV_OP_BRIDGED) &&
+	    (!!(nf_bridge->mask & BRNF_BRIDGED) ^
+	    !(info->invert & IP6T_PHYSDEV_OP_BRIDGED)))
+		return NOMATCH;
+
+	if ((info->bitmask & IP6T_PHYSDEV_OP_ISIN &&
+	    (!nf_bridge->physindev ^ !!(info->invert & IP6T_PHYSDEV_OP_ISIN))) ||
+	    (info->bitmask & IP6T_PHYSDEV_OP_ISOUT &&
+	    (!nf_bridge->physoutdev ^ !!(info->invert & IP6T_PHYSDEV_OP_ISOUT))))
+		return NOMATCH;
+
+	if (!(info->bitmask & IP6T_PHYSDEV_OP_IN))
+		goto match_outdev;
+	indev = nf_bridge->physindev ? nf_bridge->physindev->name : nulldevname;
+	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned int); i++) {
+		ret |= (((const unsigned int *)indev)[i]
+			^ ((const unsigned int *)info->physindev)[i])
+			& ((const unsigned int *)info->in_mask)[i];
+	}
+
+	if ((ret == 0) ^ !(info->invert & IP6T_PHYSDEV_OP_IN))
+		return NOMATCH;
+
+match_outdev:
+	if (!(info->bitmask & IP6T_PHYSDEV_OP_OUT))
+		return MATCH;
+	outdev = nf_bridge->physoutdev ?
+		 nf_bridge->physoutdev->name : nulldevname;
+	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned int); i++) {
+		ret |= (((const unsigned int *)outdev)[i]
+			^ ((const unsigned int *)info->physoutdev)[i])
+			& ((const unsigned int *)info->out_mask)[i];
+	}
+
+	return (ret != 0) ^ !(info->invert & IP6T_PHYSDEV_OP_OUT);
+}
+
+static int
+checkentry(const char *tablename,
+		       const struct ip6t_ip6 *ip,
+		       void *matchinfo,
+		       unsigned int matchsize,
+		       unsigned int hook_mask)
+{
+	const struct ip6t_physdev_info *info = matchinfo;
+
+	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_physdev_info)))
+		return 0;
+	if (!(info->bitmask & IP6T_PHYSDEV_OP_MASK) ||
+	    info->bitmask & ~IP6T_PHYSDEV_OP_MASK)
+		return 0;
+	return 1;
+}
+
+static struct ip6t_match physdev_match = {
+	.name		= "physdev",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	return ip6t_register_match(&physdev_match);
+}
+
+static void __exit fini(void)
+{
+	ip6t_unregister_match(&physdev_match);
+}
+
+module_init(init);
+module_exit(fini);

--------------040902070604040801070605--
