From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: [PATCH] new 'tcpack' match
Date: Sun, 27 Mar 2005 08:33:12 +0300
Message-ID: <42464598.9040707@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020107000900080103010605"
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

This is a multi-part message in MIME format.
--------------020107000900080103010605
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Matches TCP packets that has no payload, i.e. contains only ACKs.

~  iptables -A INPUT -p tcp -m tcpack --tcpack -j CLASSIFY 1:10

Or match non-ack packets:

~  iptables -A INPUT -p tcp -m tcpack ! --tcpack -j CLASSIFY 1:12

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCRkWWxyF48ZTvn+4RAoPhAJwLrvINY2VnZ5yqwvovQ8Ao1hv+7wCgzBLG
s8lz2LADN8KTr+r38X/oL4s=
=Y+Gd
-----END PGP SIGNATURE-----

--------------020107000900080103010605
Content-Type: text/x-patch;
 name="tcpack-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tcpack-1.patch"

Index: pom-all/tcpack/linux-2.6/include/linux/netfilter_ipv6/ip6t_tcpack.h
===================================================================
--- pom-all/tcpack/linux-2.6/include/linux/netfilter_ipv6/ip6t_tcpack.h	(revision 0)
+++ pom-all/tcpack/linux-2.6/include/linux/netfilter_ipv6/ip6t_tcpack.h	(revision 0)
@@ -0,0 +1,8 @@
+#ifndef _IP6T_TCPACK_H
+#define _IP6T_TCPACK_H
+
+struct ip6t_tcpack_info {
+      u_int8_t invert;
+};
+
+#endif /*_IP6T_TCPACK_H*/
Index: pom-all/tcpack/linux-2.6/include/linux/netfilter_ipv4/ipt_tcpack.h
===================================================================
--- pom-all/tcpack/linux-2.6/include/linux/netfilter_ipv4/ipt_tcpack.h	(revision 0)
+++ pom-all/tcpack/linux-2.6/include/linux/netfilter_ipv4/ipt_tcpack.h	(revision 0)
@@ -0,0 +1,8 @@
+#ifndef _IPT_TCPACK_H
+#define _IPT_TCPACK_H
+
+struct ipt_tcpack_info {
+      u_int8_t invert;
+};
+
+#endif /*_IPT_TCPACK_H*/
Index: pom-all/tcpack/linux-2.6/net/ipv4/netfilter/Makefile.ladd
===================================================================
--- pom-all/tcpack/linux-2.6/net/ipv4/netfilter/Makefile.ladd	(revision 0)
+++ pom-all/tcpack/linux-2.6/net/ipv4/netfilter/Makefile.ladd	(revision 0)
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos.o
+obj-$(CONFIG_IP_NF_MATCH_TCPACK) += ipt_tcpack.o
Index: pom-all/tcpack/linux-2.6/net/ipv4/netfilter/ipt_tcpack.c
===================================================================
--- pom-all/tcpack/linux-2.6/net/ipv4/netfilter/ipt_tcpack.c	(revision 0)
+++ pom-all/tcpack/linux-2.6/net/ipv4/netfilter/ipt_tcpack.c	(revision 0)
@@ -0,0 +1,72 @@
+/* Kernel module to match TCP ACK packets. */
+/* (C) 2005 Jonas Berlin <xkr47@outerspace.dyndns.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+
+#include <linux/netfilter_ipv4/ipt_tcpack.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+MODULE_AUTHOR("Jonas Berlin <xkr47@outerspace.dyndns.org>");
+MODULE_DESCRIPTION("iptables TCP ACK matching module");
+MODULE_LICENSE("GPL");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+	const struct ipt_tcpack_info *info = (const struct ipt_tcpack_info *)matchinfo;
+	u_int16_t ihl = skb->nh.iph->ihl * 4;
+	const struct tcphdr *tcph = (const struct tcphdr *)(skb->nh.raw + ihl);
+	return info->invert ^
+		(tcph->doff * 4 == ntohs(skb->nh.iph->tot_len) - ihl);
+}
+
+static int checkentry(const char *tablename,
+		   const struct ipt_ip *ip,
+		   void *matchinfo,
+		   unsigned int matchsize,
+		   unsigned int hook_mask)
+{
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_tcpack_info)))
+		return 0;
+
+	if (ip->proto != IPPROTO_TCP || (ip->invflags & IPT_INV_PROTO)) {
+		printk("tcpack: not valid for non-tcp\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct ipt_match tcpack_match = {
+	.name		= "tcpack",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	return ipt_register_match(&tcpack_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&tcpack_match);
+}
+
+module_init(init);
+module_exit(fini);
Index: pom-all/tcpack/linux-2.6/net/ipv4/netfilter/Kconfig.ladd
===================================================================
--- pom-all/tcpack/linux-2.6/net/ipv4/netfilter/Kconfig.ladd	(revision 0)
+++ pom-all/tcpack/linux-2.6/net/ipv4/netfilter/Kconfig.ladd	(revision 0)
@@ -0,0 +1,9 @@
+config IP_NF_MATCH_TCPACK
+	tristate  'TCP ACK match support'
+	depends on IP_NF_IPTABLES
+	help
+	  This option adds a `tcpack' match, which allow you to match
+	  TCP packets containg no actual data, just ACKs.
+
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  If unsure, say `N'.
Index: pom-all/tcpack/linux-2.6/net/ipv6/netfilter/Makefile.ladd
===================================================================
--- pom-all/tcpack/linux-2.6/net/ipv6/netfilter/Makefile.ladd	(revision 0)
+++ pom-all/tcpack/linux-2.6/net/ipv6/netfilter/Makefile.ladd	(revision 0)
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
+obj-$(CONFIG_IP6_NF_MATCH_TCPACK) += ip6t_tcpack.o
Index: pom-all/tcpack/linux-2.6/net/ipv6/netfilter/Kconfig.ladd
===================================================================
--- pom-all/tcpack/linux-2.6/net/ipv6/netfilter/Kconfig.ladd	(revision 0)
+++ pom-all/tcpack/linux-2.6/net/ipv6/netfilter/Kconfig.ladd	(revision 0)
@@ -0,0 +1,9 @@
+config IP6_NF_MATCH_TCPACK
+	tristate  'TCP ACK match support'
+	depends on IP6_NF_IPTABLES
+	help
+	  This option adds a `tcpack' match, which allow you to match
+	  TCP packets containg no actual data, just ACKs.
+
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  If unsure, say `N'.
Index: pom-all/tcpack/linux-2.6/net/ipv6/netfilter/ip6t_tcpack.c
===================================================================
--- pom-all/tcpack/linux-2.6/net/ipv6/netfilter/ip6t_tcpack.c	(revision 0)
+++ pom-all/tcpack/linux-2.6/net/ipv6/netfilter/ip6t_tcpack.c	(revision 0)
@@ -0,0 +1,70 @@
+/* Kernel module to match TCP ACK packets. */
+/* (C) 2005 Jonas Berlin <xkr47@outerspace.dyndns.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
+
+#include <linux/netfilter_ipv6/ip6t_tcpack.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+MODULE_AUTHOR("Jonas Berlin <xkr47@outerspace.dyndns.org>");
+MODULE_DESCRIPTION("ip6tables TCP ACK matching module");
+MODULE_LICENSE("GPL");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      int *hotdrop)
+{
+	const struct ip6t_tcpack_info *info = (const struct ip6t_tcpack_info *)matchinfo;
+	const struct tcphdr *tcph = (const struct tcphdr *)(skb->nh.raw + sizeof(struct ipv6hdr));
+	return info->invert ^
+		(tcph->doff * 4 == ntohs(skb->nh.ipv6h->payload_len));
+}
+
+static int checkentry(const char *tablename,
+		   const struct ip6t_ip6 *ip6,
+		   void *matchinfo,
+		   unsigned int matchsize,
+		   unsigned int hook_mask)
+{
+	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_tcpack_info)))
+		return 0;
+
+	if (ip6->proto != IPPROTO_TCP || (ip6->invflags & IP6T_INV_PROTO)) {
+		printk("tcpack: not valid for non-tcp\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct ip6t_match tcpack_match = {
+	.name		= "tcpack",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	return ip6t_register_match(&tcpack_match);
+}
+
+static void __exit fini(void)
+{
+	ip6t_unregister_match(&tcpack_match);
+}
+
+module_init(init);
+module_exit(fini);
Index: pom-all/tcpack/iptables/extensions/libip6t_tcpack.c
===================================================================
--- pom-all/tcpack/iptables/extensions/libip6t_tcpack.c	(revision 0)
+++ pom-all/tcpack/iptables/extensions/libip6t_tcpack.c	(revision 0)
@@ -0,0 +1,88 @@
+/* Shared library add-on to ip6tables to add packet tcpack matching support. */
+#include <stdio.h>
+#include <getopt.h>
+
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6t_tcpack.h>
+
+static void help(void) 
+{
+	printf(
+"tcpack v%s options:\n"
+"  [!] --tcpack  (match tcp ack packets)\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "tcpack", 0, 0, '0'},
+	{ 0 }
+};
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      unsigned int *nfcache,
+      struct ip6t_entry_match **match)
+{
+	struct ip6t_tcpack_info *info = (struct ip6t_tcpack_info *)(*match)->data;
+
+	switch (c)
+	{
+	case '0':
+		if(*flags)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --ssrr twice");
+
+		info->invert = invert;
+		*flags = 1;
+		break;
+
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void
+final_check(unsigned int flags)
+{
+	if (flags == 0)
+		exit_error(PARAMETER_PROBLEM,
+			   "tcpack match: you must specify the [!] --tcpack parameter.");
+}
+
+static void
+print(const struct ip6t_ip6 *ip6,
+      const struct ip6t_entry_match *match,
+      int numeric)
+{
+	const struct ip6t_tcpack_info *info = (const struct ip6t_tcpack_info *)match->data;
+	
+	printf("%stcpack", info->invert ? "!" : "");
+}
+
+static void
+save(const struct ip6t_ip6 *ip6, const struct ip6t_entry_match *match)
+{
+	const struct ip6t_tcpack_info *info = (const struct ip6t_tcpack_info *)match->data;
+
+	printf("%s--tcpack ", info->invert ? "! " : "");
+}
+
+static struct ip6tables_match tcpack = { 
+	.name		= "tcpack",
+	.version	= IPTABLES_VERSION,
+	.size		= IP6T_ALIGN(sizeof(struct ip6t_tcpack_info)),
+	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_tcpack_info)),
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
+	register_match6(&tcpack);
+}
Index: pom-all/tcpack/iptables/extensions/.tcpack-test
===================================================================
--- pom-all/tcpack/iptables/extensions/.tcpack-test	(revision 0)
+++ pom-all/tcpack/iptables/extensions/.tcpack-test	(revision 0)
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_tcpack.h ] && echo tcpack

Property changes on: pom-all/tcpack/iptables/extensions/.tcpack-test
___________________________________________________________________
Name: svn:executable
   + *

Index: pom-all/tcpack/iptables/extensions/libipt_tcpack.man
===================================================================
--- pom-all/tcpack/iptables/extensions/libipt_tcpack.man	(revision 0)
+++ pom-all/tcpack/iptables/extensions/libipt_tcpack.man	(revision 0)
@@ -0,0 +1,7 @@
+Matches TCP packets that has no payload, i.e. contains only ACKs.
+.IP
+iptables -A INPUT -p tcp -m tcpack --tcpack -j CLASSIFY 1:10
+.P
+Or match non-ack packets:
+.IP
+iptables -A INPUT -p tcp -m tcpack ! --tcpack -j CLASSIFY 1:12
Index: pom-all/tcpack/iptables/extensions/.tcpack-test6
===================================================================
--- pom-all/tcpack/iptables/extensions/.tcpack-test6	(revision 0)
+++ pom-all/tcpack/iptables/extensions/.tcpack-test6	(revision 0)
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_tcpack.h ] && echo tcpack

Property changes on: pom-all/tcpack/iptables/extensions/.tcpack-test6
___________________________________________________________________
Name: svn:executable
   + *

Index: pom-all/tcpack/iptables/extensions/libip6t_tcpack.man
===================================================================
--- pom-all/tcpack/iptables/extensions/libip6t_tcpack.man	(revision 0)
+++ pom-all/tcpack/iptables/extensions/libip6t_tcpack.man	(revision 0)
@@ -0,0 +1,10 @@
+Matches TCP packets that has no payload, i.e. contains only ACKs.
+.IP
+ip6tables -A INPUT -p tcp -m tcpack --tcpack -j CLASSIFY 1:10
+.P
+Or match non-ack packets:
+.IP
+ip6tables -A INPUT -p tcp -m tcpack ! --tcpack -j CLASSIFY 1:12
+
+
+
Index: pom-all/tcpack/iptables/extensions/libipt_tcpack.c
===================================================================
--- pom-all/tcpack/iptables/extensions/libipt_tcpack.c	(revision 0)
+++ pom-all/tcpack/iptables/extensions/libipt_tcpack.c	(revision 0)
@@ -0,0 +1,88 @@
+/* Shared library add-on to iptables to add packet tcpack matching support. */
+#include <stdio.h>
+#include <getopt.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_tcpack.h>
+
+static void help(void) 
+{
+	printf(
+"tcpack v%s options:\n"
+"  [!] --tcpack  (match tcp ack packets)\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "tcpack", 0, 0, '0'},
+	{ 0 }
+};
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	struct ipt_tcpack_info *info = (struct ipt_tcpack_info *)(*match)->data;
+
+	switch (c)
+	{
+	case '0':
+		if(*flags)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --ssrr twice");
+
+		info->invert = invert;
+		*flags = 1;
+		break;
+
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void
+final_check(unsigned int flags)
+{
+	if (flags == 0)
+		exit_error(PARAMETER_PROBLEM,
+			   "tcpack match: you must specify the [!] --tcpack parameter.");
+}
+
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+	const struct ipt_tcpack_info *info = (const struct ipt_tcpack_info *)match->data;
+	
+	printf("%stcpack", info->invert ? "!" : "");
+}
+
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	const struct ipt_tcpack_info *info = (const struct ipt_tcpack_info *)match->data;
+
+	printf("%s--tcpack ", info->invert ? "! " : "");
+}
+
+static struct iptables_match tcpack = { 
+	.name		= "tcpack",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct ipt_tcpack_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_tcpack_info)),
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
+	register_match(&tcpack);
+}
Index: pom-all/tcpack/help
===================================================================
--- pom-all/tcpack/help	(revision 0)
+++ pom-all/tcpack/help	(revision 0)
@@ -0,0 +1,7 @@
+Matches TCP packets that has no payload, i.e. contains only ACKs.
+
+  iptables -A INPUT -p tcp -m tcpack --tcpack -j CLASSIFY 1:10
+
+Or match non-ack packets:
+
+  iptables -A INPUT -p tcp -m tcpack ! --tcpack -j CLASSIFY 1:12
Index: pom-all/tcpack/info
===================================================================
--- pom-all/tcpack/info	(revision 0)
+++ pom-all/tcpack/info	(revision 0)
@@ -0,0 +1,4 @@
+Title: Add support for matching TCP packets with only ACKs (no payload)
+Author: Jonas Berlin <xkr47@outerspace.dyndns.org>
+Status: testing
+Repository: extra

--------------020107000900080103010605--
