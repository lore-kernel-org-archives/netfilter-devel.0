From: Alex Davis <alex14641@yahoo.com>
Subject: Re: [RFC][1/2] New netfilter match module : kernel patch
Date: Fri, 2 Jun 2006 12:02:38 -0700 (PDT)
Message-ID: <20060602190238.92524.qmail@web50208.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is an update the kernel netfilter patch that allows 
matching the source or destination address of an IP
packet to a network interface.

Instead of hard-coding the dimension of the ifname struct
member, use the IFNAMSIZ macro.




diff -u -Pr linux-2.6.16.16/include/linux/netfilter/xt_ipisforif.h
linux-2.6.16.16-ipisforif/include/linux/netfilter/xt_ipisforif.h
--- linux-2.6.16.16/include/linux/netfilter/xt_ipisforif.h	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.16.16-ipisforif/include/linux/netfilter/xt_ipisforif.h	2006-06-02 10:18:22.000000000
-0400
@@ -0,0 +1,15 @@
+#ifndef _XT_IPISFORIF_H
+#define _XT_IPISFORIF_H
+
+#include <linux/if.h>
+
+#define TYPE_SRC 1
+#define TYPE_DST 2
+
+struct xt_ipisforif_info {
+	int type;
+	int invert;
+	char ifname[IFNAMSIZ];
+};
+
+#endif /*_XT_IPISFORIF_H*/
diff -u -Pr linux-2.6.16.16/include/linux/netfilter_ipv4/ipt_ipisforif.h
linux-2.6.16.16-ipisforif/include/linux/netfilter_ipv4/ipt_ipisforif.h
--- linux-2.6.16.16/include/linux/netfilter_ipv4/ipt_ipisforif.h	1969-12-31 19:00:00.000000000
-0500
+++ linux-2.6.16.16-ipisforif/include/linux/netfilter_ipv4/ipt_ipisforif.h	2006-05-30
02:20:06.000000000 -0400
@@ -0,0 +1,9 @@
+#ifndef _IPT_IPISFORIF_H
+#define _IPT_IPISFORIF_H
+#include <linux/netfilter/xt_ipisforif.h>
+
+/* Backwards compatibility for old userspace */
+
+#define ipt_ipisforif_info xt_ipisforif_info 
+
+#endif /*_IPT_IPISFORIF_H*/
diff -u -Pr linux-2.6.16.16/net/netfilter/Kconfig linux-2.6.16.16-ipisforif/net/netfilter/Kconfig
--- linux-2.6.16.16/net/netfilter/Kconfig	2006-05-29 18:02:43.000000000 -0400
+++ linux-2.6.16.16-ipisforif/net/netfilter/Kconfig	2006-05-29 18:10:06.000000000 -0400
@@ -336,6 +336,15 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_IPISFORIF
+	tristate '"interface ip" match support'
+	depends on NETFILTER_XTABLES
+	help
+	  This matches the source or destination IP address of a packet
+	  against the local address of a network interface.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_STRING
 	tristate  '"string" match support'
 	depends on NETFILTER_XTABLES
diff -u -Pr linux-2.6.16.16/net/netfilter/Makefile
linux-2.6.16.16-ipisforif/net/netfilter/Makefile
--- linux-2.6.16.16/net/netfilter/Makefile	2006-05-29 18:02:43.000000000 -0400
+++ linux-2.6.16.16-ipisforif/net/netfilter/Makefile	2006-05-29 16:33:48.000000000 -0400
@@ -47,3 +47,4 @@
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_IPISFORIF) += xt_ipisforif.o
diff -u -Pr linux-2.6.16.16/net/netfilter/xt_ipisforif.c
linux-2.6.16.16-ipisforif/net/netfilter/xt_ipisforif.c
--- linux-2.6.16.16/net/netfilter/xt_ipisforif.c	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.16.16-ipisforif/net/netfilter/xt_ipisforif.c	2006-05-30 09:43:31.000000000 -0400
@@ -0,0 +1,106 @@
+/* Kernel module to match the source or destination address of a
+ * packet to the IP address of a network interface.
+ *
+ * (C) 2006 Alex Davis
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netdevice.h>
+#include <linux/inetdevice.h>
+#include <net/route.h>
+#include <linux/netfilter/xt_ipisforif.h>
+
+MODULE_AUTHOR("Alex Davis");
+MODULE_DESCRIPTION("Match source or destination address of a packet "
+		   "to a network interface");
+MODULE_ALIAS("ipt_ipisforif");
+MODULE_LICENSE("GPL");
+
+static int match(const struct sk_buff *skb,
+		 const struct net_device *in,
+		 const struct net_device *out,
+		 const void *matchinfo,
+		 int offset,
+		 unsigned int protoff,
+		 int *hotdrop) 
+{
+	const struct xt_ipisforif_info *info = matchinfo;
+	struct in_ifaddr *ifa = NULL;
+	struct in_device *in_dev;
+	struct net_device *dev;
+	int ismatch = 0;
+	
+	rtnl_lock();
+	if ( (dev = __dev_get_by_name(info->ifname)) ) {
+		if ((in_dev = __in_dev_get_rtnl(dev)) != NULL) {
+			for (ifa = in_dev->ifa_list; ifa; ifa = ifa->ifa_next) {
+				if ( ! strcmp(info->ifname, ifa->ifa_label) ) {
+					break;
+				}
+			}
+		}
+	}
+
+	if ( ifa ) {
+		struct iphdr *hdr = skb->nh.iph;
+		switch (info->type ) {
+		case TYPE_SRC:
+			ismatch = ( (hdr->saddr == ifa->ifa_local) &&
+					    ( ! info->invert ) );
+			break;
+
+		case TYPE_DST:
+			ismatch = ( (hdr->daddr == ifa->ifa_local) &&
+					    ( ! info->invert ) );
+			break;
+
+		default:
+			printk(KERN_INFO "ipisforif: invalid type:  %d\n",
+			       info->type);
+		}
+	}
+	rtnl_unlock();
+
+	return ismatch;
+}
+
+static int check(const char *tablename,
+		 const void *pinf,
+		 void *matchinfo,
+		 unsigned int matchsize,
+		 unsigned int hook_mask)
+{
+	const struct ipt_ip *inf = pinf;
+
+	return ((inf->proto == IPPROTO_TCP || inf->proto == IPPROTO_UDP) &&
+		! (inf->invflags & IPT_INV_PROTO)); 
+}
+
+static void destroy(void *matchinfo, unsigned int matchsize) {
+}
+
+static struct xt_match ipisforif_match = {
+	.name		= "ipisforif",
+	.match		= &match,
+	.checkentry	= &check,
+	.destroy	= destroy,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void) {
+	return ipt_register_match(&ipisforif_match);
+}
+
+static void __exit exit(void) {
+	ipt_unregister_match(&ipisforif_match);
+}
+
+module_init(init);
+module_exit(exit);

I code, therefore I am

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
