From: Amin Azez <azez@ufomechanic.net>
Subject: vlan target for iptables
Date: Mon, 08 Aug 2005 17:18:28 +0100
Message-ID: <dd80kc$n5o$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030503040409020501010306"
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

This is a multi-part message in MIME format.
--------------030503040409020501010306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Please consider this for inclusion in iptables. Should this go in pom?

This adds --vlan target matching for iptables.
Useful when running as a bridge and perhaps in other cases.

I've tested it while bridging packets with vlan headers set.
Anyone trying to use this, realise that in most configurations your
switch does not transmit the vlan headers, and if it does, then realise
that your networked PC's will not generally accept the packets.
The test rig involved a few PC's and some segmented switches.

I'm afraid I had to steal the vlan packet matching code IS_VLAN_* from
one of the  vlan modules as it was private to that module.  I hate
having to do that.

For user-space:

Just add dump libipt_vlan.c extensions and add vlan to PF_EXT_SLIB
definition in extensions/Makefile

I'm not sending a patch for extensions/Makefile that because it's bound
to fail applying with all the PF_EXT_SLIB stuff all on one line.


For kernel-space, apply vlan.patch

Comments? This code is based on the MAC target with minimal changes (and
careful "grep -i mac *" and is naturally GPL licensed too),

Azez

--------------030503040409020501010306
Content-Type: text/x-csrc;
 name="libipt_vlan.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libipt_vlan.c"

/* Shared library add-on to iptables to add VLAN address support. */
#include <stdio.h>
#include <netdb.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>
#if defined(__GLIBC__) && __GLIBC__ == 2
#include <net/ethernet.h>
#else
#include <linux/if_ether.h>
#endif
#include <iptables.h>
#include <linux/netfilter_ipv4/ipt_vlan.h>

/* Function which prints out usage message. */
static void
help(void)
{
	printf(
"VLAN v%s options:\n"
" --vlan [!] <vlan_id>\n"
"				Match source VLAN id\n"
"\n", IPTABLES_VERSION);
}

static struct option opts[] = {
	{ "vlan", 1, 0, '1' },
	{0}
};

/* Function which parses command options; returns true if it
   ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      unsigned int *nfcache,
      struct ipt_entry_match **match)
{
	struct ipt_vlan_info *vlaninfo = (struct ipt_vlan_info *)(*match)->data;

	switch (c) {
	case '1':
		check_inverse(optarg, &invert, &optind, 0);
		vlaninfo->vlan=atoi(argv[optind-1]);
		if (invert)
			vlaninfo->invert = 1;
		*flags = 1;
		break;

	default:
		return 0;
	}

	return 1;
}

/* Final check; must have specified --vlan. */
static void final_check(unsigned int flags)
{
	if (!flags)
		exit_error(PARAMETER_PROBLEM,
			   "You must specify `--vlan'");
}

/* Prints out the matchinfo. */
static void
print(const struct ipt_ip *ip,
      const struct ipt_entry_match *match,
      int numeric)
{
	printf("vlan ");

	if (((struct ipt_vlan_info *)match->data)->invert)
		printf("! ");

	printf("%d ",((struct ipt_vlan_info *)match->data)->vlan);
}

/* Saves the union ipt_matchinfo in parsable form to stdout. */
static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
{
	if (((struct ipt_vlan_info *)match->data)->invert)
		printf("! ");

	printf("--vlan %d ",((struct ipt_vlan_info *)match->data)->vlan);
}

static struct iptables_match vlan = { 
	.next		= NULL,
 	.name		= "vlan",
	.version	= IPTABLES_VERSION,
	.size		= IPT_ALIGN(sizeof(struct ipt_vlan_info)),
	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_vlan_info)),
	.help		= &help,
	.parse		= &parse,
	.final_check	= &final_check,
	.print		= &print,
	.save		= &save,
	.extra_opts	= opts
};

void _init(void)
{
	register_match(&vlan);
}

--------------030503040409020501010306
Content-Type: text/x-patch;
 name="vlan.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vlan.patch"

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

--------------030503040409020501010306--
