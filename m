From: Amin Azez <azez@ufomechanic.net>
Subject: ipt_vlan
Date: Fri, 18 Aug 2006 14:55:46 +0100
Message-ID: <44E5C6E2.30809@ufomechanic.net>
References: <44E49911.6080007@ufomechanic.net> <44E4A1AB.3000001@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010505050907050702060808"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jesper Dangaard Brouer <hawk@diku.dk>
In-Reply-To: <44E4A1AB.3000001@trash.net>
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

This is a multi-part message in MIME format.
--------------010505050907050702060808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Attached is my ipt_vlan patch for 2.6.17 and 2.6.11, and the iptables
patch to go with it.
It's based on the mac match.

I think the iptables patch is wrong, the way I freak the extension
makefile needs reviewing, but it does compile.

it doesn't require any vlan interfaces to be set up on the box; unless
you want to route (I guess);
I do bridging and get to match on vlan.

Sam


--------------010505050907050702060808
Content-Type: text/x-patch;
 name="vlan.2.6.17.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vlan.2.6.17.patch"

Index: linux-2.6.17.1/include/linux/netfilter_ipv4/ipt_vlan.h
===================================================================
--- /dev/null
+++ linux-2.6.17.1/include/linux/netfilter_ipv4/ipt_vlan.h
@@ -0,0 +1,8 @@
+#ifndef _IPT_VLAN_H
+#define _IPT_VLAN_H
+
+struct ipt_vlan_info {
+    unsigned short vlan;
+    int invert;
+};
+#endif /*_IPT_VLAN_H*/
Index: linux-2.6.17.1/net/ipv4/netfilter/Kconfig
===================================================================
--- linux-2.6.17.1.orig/net/ipv4/netfilter/Kconfig
+++ linux-2.6.17.1/net/ipv4/netfilter/Kconfig
@@ -235,6 +235,15 @@ config IP_NF_IPTABLES
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 # The matches.
+config IP_NF_MATCH_VLAN
+	tristate "VLAN address match support"
+	depends on IP_NF_IPTABLES
+	help
+	  VLAN matching allows you to match packets based on the vlan
+	  tag of the packet, if your switch fowards them
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_MATCH_LAYER7
 	tristate "Layer 7 match support (EXPERIMENTAL)"
 	depends on IP_NF_IPTABLES && IP_NF_CT_ACCT && IP_NF_CONNTRACK && EXPERIMENTAL
Index: linux-2.6.17.1/net/ipv4/netfilter/Makefile
===================================================================
--- linux-2.6.17.1.orig/net/ipv4/netfilter/Makefile
+++ linux-2.6.17.1/net/ipv4/netfilter/Makefile
@@ -64,6 +64,8 @@ obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ip
 
 obj-$(CONFIG_IP_NF_MATCH_LAYER7) += ipt_layer7.o
 
+obj-$(CONFIG_IP_NF_MATCH_VLAN) += ipt_vlan.o
+
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
 obj-$(CONFIG_IP_NF_TARGET_TOS) += ipt_TOS.o
Index: linux-2.6.17.1/net/ipv4/netfilter/ipt_vlan.c
===================================================================
--- /dev/null
+++ linux-2.6.17.1/net/ipv4/netfilter/ipt_vlan.c
@@ -0,0 +1,85 @@
+/* Kernel module to match VLAN parameters based on ipt_mac */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ * (C) UFO Mechanic <azez@ufomechanic.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/if_ether.h>
+#include <linux/if_vlan.h>
+
+#include <linux/netfilter_ipv4/ipt_vlan.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("UFO Mechanic <azez@ufomechanic.net>");
+MODULE_DESCRIPTION("iptables vlan matching module");
+
+#define IS_VLAN_IP (skb->protocol == __constant_htons(ETH_P_8021Q) &&    \
+	hdr->h_vlan_encapsulated_proto == __constant_htons(ETH_P_IP)) /* &&  \ brnf_filter_vlan_tagged) */
+#define IS_VLAN_IPV6 (skb->protocol == __constant_htons(ETH_P_8021Q) &&    \
+	hdr->h_vlan_encapsulated_proto == __constant_htons(ETH_P_IPV6)) /* &&  \ brnf_filter_vlan_tagged) */
+#define IS_VLAN_ARP (skb->protocol == __constant_htons(ETH_P_8021Q) &&   \
+	hdr->h_vlan_encapsulated_proto == __constant_htons(ETH_P_ARP)) /* && \ brnf_filter_vlan_tagged) */
+
+static int
+match(	const struct sk_buff *skb,
+	const struct net_device *in,
+	const struct net_device *out,
+	const struct xt_match *match,
+	const void *matchinfo,
+	int offset,
+	int *hotdrop)
+{
+    const struct ipt_vlan_info *info = matchinfo;
+    struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
+
+/* should we use: static inline int __vlan_get_tag(struct sk_buff *skb, unsigned short *tag) */
+    /* Is it even a VLAN packet? */
+    if ((IS_VLAN_IP || IS_VLAN_IPV6 || IS_VLAN_ARP)) {
+	    /* If so, compare... */
+	    return (( (ntohs(hdr->h_vlan_TCI)==info->vlan) ^ info->invert));
+    }
+    return 0 ^ info->invert;
+}
+
+static int
+ipt_vlan_checkentry(const char *tablename,
+	const struct ipt_ip *ip,
+	const struct xt_match *match,
+	void *matchinfo,
+	unsigned int matchsize,
+	unsigned int hook_mask)
+{
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_vlan_info)))
+		return 0;
+
+	return 1;
+}
+
+static struct ipt_match vlan_match = {
+	.name		= "vlan",
+	.match		= &match,
+	.checkentry	= &ipt_vlan_checkentry,
+	.matchsize	= sizeof(struct ipt_vlan_info),
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	return ipt_register_match(&vlan_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&vlan_match);
+}
+
+module_init(init);
+module_exit(fini);

--------------010505050907050702060808
Content-Type: text/x-patch;
 name="vlan.2.6.11.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vlan.2.6.11.patch"

diff -Nru ../linux-2.6.11.7-reference/include/linux/netfilter_ipv4/ipt_vlan.h ./include/linux/netfilter_ipv4/ipt_vlan.h
--- ../linux-2.6.11.7-reference/include/linux/netfilter_ipv4/ipt_vlan.h	1970-01-01 01:00:00.000000000 +0100
+++ ./include/linux/netfilter_ipv4/ipt_vlan.h	2005-07-13 14:59:24.000000000 +0100
@@ -0,0 +1,8 @@
+#ifndef _IPT_VLAN_H
+#define _IPT_VLAN_H
+
+struct ipt_vlan_info {
+    unsigned short vlan;
+    int invert;
+};
+#endif /*_IPT_VLAN_H*/
diff -Nru ../linux-2.6.11.7-reference/net/ipv4/netfilter/ipt_vlan.c ./net/ipv4/netfilter/ipt_vlan.c
--- ../linux-2.6.11.7-reference/net/ipv4/netfilter/ipt_vlan.c	1970-01-01 01:00:00.000000000 +0100
+++ ./net/ipv4/netfilter/ipt_vlan.c	2005-07-22 09:49:01.000000000 +0100
@@ -0,0 +1,82 @@
+/* Kernel module to match VLAN parameters based on ipt_mac */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ * (C) UFO Mechanic <azez@ufomechanic.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/if_ether.h>
+#include <linux/if_vlan.h>
+
+#include <linux/netfilter_ipv4/ipt_vlan.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("UFO Mechanic <azez@ufomechanic.net>");
+MODULE_DESCRIPTION("iptables vlan matching module");
+
+#define IS_VLAN_IP (skb->protocol == __constant_htons(ETH_P_8021Q) &&    \
+	hdr->h_vlan_encapsulated_proto == __constant_htons(ETH_P_IP)) /* &&  \ brnf_filter_vlan_tagged) */
+#define IS_VLAN_IPV6 (skb->protocol == __constant_htons(ETH_P_8021Q) &&    \
+	hdr->h_vlan_encapsulated_proto == __constant_htons(ETH_P_IPV6)) /* &&  \ brnf_filter_vlan_tagged) */
+#define IS_VLAN_ARP (skb->protocol == __constant_htons(ETH_P_8021Q) &&   \
+	hdr->h_vlan_encapsulated_proto == __constant_htons(ETH_P_ARP)) /* && \ brnf_filter_vlan_tagged) */
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+    const struct ipt_vlan_info *info = matchinfo;
+    struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
+
+/* should we use: static inline int __vlan_get_tag(struct sk_buff *skb, unsigned short *tag) */
+    /* Is it even a VLAN packet? */
+    if ((IS_VLAN_IP || IS_VLAN_IPV6 || IS_VLAN_ARP)) {
+	    /* If so, compare... */
+	    return (( (ntohs(hdr->h_vlan_TCI)==info->vlan) ^ info->invert));
+    }
+    return 0 ^ info->invert;
+}
+
+static int
+ipt_vlan_checkentry(const char *tablename,
+		   const struct ipt_ip *ip,
+		   void *matchinfo,
+		   unsigned int matchsize,
+		   unsigned int hook_mask)
+{
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_vlan_info)))
+		return 0;
+
+	return 1;
+}
+
+static struct ipt_match vlan_match = {
+	.name		= "vlan",
+	.match		= &match,
+	.checkentry	= &ipt_vlan_checkentry,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	return ipt_register_match(&vlan_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&vlan_match);
+}
+
+module_init(init);
+module_exit(fini);
--- kernel/net/ipv4/netfilter/Makefile.orig	2005-07-22 12:12:46.000000000 +0100
+++ kernel/net/ipv4/netfilter/Makefile	2005-07-22 12:13:08.000000000 +0100
@@ -45,6 +45,7 @@
 obj-$(CONFIG_IP_NF_MATCH_SCTP) += ipt_sctp.o
 obj-$(CONFIG_IP_NF_MATCH_MARK) += ipt_mark.o
 obj-$(CONFIG_IP_NF_MATCH_MAC) += ipt_mac.o
+obj-$(CONFIG_IP_NF_MATCH_VLAN) += ipt_vlan.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) += ipt_iprange.o
 obj-$(CONFIG_IP_NF_MATCH_PKTTYPE) += ipt_pkttype.o
 obj-$(CONFIG_IP_NF_MATCH_MULTIPORT) += ipt_multiport.o
--- kernel/net/ipv4/netfilter/Kconfig.orig	2005-07-22 12:13:18.000000000 +0100
+++ kernel/net/ipv4/netfilter/Kconfig	2005-07-22 12:14:37.000000000 +0100
@@ -183,6 +183,15 @@
 	  Unless you know what you're doing, leave it at the default of 2kB.
 
 
+config IP_NF_MATCH_VLAN
+	tristate "VLAN address match support"
+	depends on IP_NF_IPTABLES
+	help
+	  VLAN matching allows you to match packets based on the vlan
+	  tag of the packet, if your switch fowards them
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_MATCH_PKTTYPE
 	tristate "Packet type match support"
 	depends on IP_NF_IPTABLES

--------------010505050907050702060808
Content-Type: text/x-patch;
 name="iptables.vlan.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables.vlan.patch"

--- extensions/Makefile.orig    2006-06-30 10:41:38.000000000 +0100
+++ extensions/Makefile 2006-06-30 10:42:00.000000000 +0100
@@ -14,2 +14,4 @@

+PF_EXT_SLIB+=vlan
+
 # Optionals
--- extensions/libipt_vlan.c	2005-09-26 14:26:01.000000000 +0100
+++ extensions/libipt_vlan.c	2005-09-26 14:18:17.000000000 +0100
@@ -0,0 +1,105 @@
+/* Shared library add-on to iptables to add VLAN address support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#if defined(__GLIBC__) && __GLIBC__ == 2
+#include <net/ethernet.h>
+#else
+#include <linux/if_ether.h>
+#endif
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_vlan.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"VLAN v%s options:\n"
+" --vlan [!] <vlan_id>\n"
+"				Match source VLAN id\n"
+"\n", IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "vlan", 1, 0, '1' },
+	{0}
+};
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	struct ipt_vlan_info *vlaninfo = (struct ipt_vlan_info *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		check_inverse(optarg, &invert, &optind, 0);
+		vlaninfo->vlan=atoi(argv[optind-1]);
+		if (invert)
+			vlaninfo->invert = 1;
+		*flags = 1;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+/* Final check; must have specified --vlan. */
+static void final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "You must specify `--vlan'");
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+	printf("vlan ");
+
+	if (((struct ipt_vlan_info *)match->data)->invert)
+		printf("! ");
+
+	printf("%d ",((struct ipt_vlan_info *)match->data)->vlan);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	if (((struct ipt_vlan_info *)match->data)->invert)
+		printf("! ");
+
+	printf("--vlan %d ",((struct ipt_vlan_info *)match->data)->vlan);
+}
+
+static struct iptables_match vlan = { 
+	.next		= NULL,
+ 	.name		= "vlan",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct ipt_vlan_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_vlan_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_match(&vlan);
+}

--------------010505050907050702060808--
