From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] port physdev to ip6tables
Date: Sat, 11 Sep 2004 12:59:28 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409111259.28468.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QqtQBTzimoGGzlj"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--Boundary-00=_QqtQBTzimoGGzlj
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Attached are 2 patches, one against kernel 2.6.8.1 and the other against the 
iptables userspace CVS. They add the physdev module to ip6tables. The physdev 
module is quite essential for people wanting to filter bridged IPv6 frames.

cheers,
Bart

--Boundary-00=_QqtQBTzimoGGzlj
Content-Type: text/x-diff; charset="us-ascii"; name="physdevipv6kernel.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="physdevipv6kernel.diff"

--- linux-2.6.8.1/net/ipv6/netfilter/Makefile.old	2004-09-11 12:31:12.000000000 +0200
+++ linux-2.6.8.1/net/ipv6/netfilter/Makefile	2004-09-11 12:34:30.000000000 +0200
@@ -16,6 +16,7 @@ obj-$(CONFIG_IP6_NF_MATCH_AHESP) += ip6t
 obj-$(CONFIG_IP6_NF_MATCH_EUI64) += ip6t_eui64.o
 obj-$(CONFIG_IP6_NF_MATCH_MULTIPORT) += ip6t_multiport.o
 obj-$(CONFIG_IP6_NF_MATCH_OWNER) += ip6t_owner.o
+obj-$(CONFIG_IP6_NF_MATCH_PHYSDEV) += ip6t_physdev.o
 obj-$(CONFIG_IP6_NF_FILTER) += ip6table_filter.o
 obj-$(CONFIG_IP6_NF_MANGLE) += ip6table_mangle.o
 obj-$(CONFIG_IP6_NF_TARGET_MARK) += ip6t_MARK.o
--- linux-2.6.8.1/net/ipv6/netfilter/Kconfig.old	2004-09-11 12:24:02.000000000 +0200
+++ linux-2.6.8.1/net/ipv6/netfilter/Kconfig	2004-09-11 12:36:30.000000000 +0200
@@ -158,6 +158,15 @@ config IP6_NF_MATCH_EUI64
 
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
--- /dev/null	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.8.1/net/ipv6/netfilter/ip6t_physdev.c	2004-09-11 12:40:41.000000000 +0200
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
--- /dev/null	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.8.1/include/linux/netfilter_ipv6/ip6t_physdev.h	2004-09-11 12:31:01.000000000 +0200
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

--Boundary-00=_QqtQBTzimoGGzlj
Content-Type: text/x-diff; charset="us-ascii"; name="physdevipv6user.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="physdevipv6user.diff"

--- iptables/extensions/Makefile.old	2004-09-09 23:52:37.000000000 +0200
+++ iptables/extensions/Makefile	2004-09-09 23:52:50.000000000 +0200
@@ -6,7 +6,7 @@
 # package (HW)
 #
 PF_EXT_SLIB:=ah addrtype connlimit connmark conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
-PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner standard tcp udp HL LOG MARK TRACE
+PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner physdev standard tcp udp HL LOG MARK TRACE
 
 # Optionals
 PF_EXT_SLIB_OPTS:=$(foreach T,$(wildcard extensions/.*-test),$(shell KERNEL_DIR=$(KERNEL_DIR) $(T)))
--- /dev/null	1970-01-01 01:00:00.000000000 +0100
+++ iptables/extensions/libip6t_physdev.c	2004-09-11 12:30:22.000000000 +0200
@@ -0,0 +1,232 @@
+/* Shared library add-on to iptables to add bridge port matching support. */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ctype.h>
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6t_physdev.h>
+#if defined(__GLIBC__) && __GLIBC__ == 2
+#include <net/ethernet.h>
+#else
+#include <linux/if_ether.h>
+#endif
+
+static void
+help(void)
+{
+	printf(
+"physdev v%s options:\n"
+" --physdev-in [!] input name[+]		bridge port name ([+] for wildcard)\n"
+" --physdev-out [!] output name[+]	bridge port name ([+] for wildcard)\n"
+" [!] --physdev-is-in			arrived on a bridge device\n"
+" [!] --physdev-is-out			will leave on a bridge device\n"
+" [!] --physdev-is-bridged		it's a bridged packet\n"
+"\n", IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "physdev-in", 1, 0, '1' },
+	{ "physdev-out", 1, 0, '2' },
+	{ "physdev-is-in", 0, 0, '3' },
+	{ "physdev-is-out", 0, 0, '4' },
+	{ "physdev-is-bridged", 0, 0, '5' },
+	{0}
+};
+
+/* copied from iptables.c */
+static void
+parse_interface(const char *arg, char *vianame, unsigned char *mask)
+{
+	int vialen = strlen(arg);
+	unsigned int i;
+
+	memset(mask, 0, IFNAMSIZ);
+	memset(vianame, 0, IFNAMSIZ);
+
+	if (vialen + 1 > IFNAMSIZ)
+		exit_error(PARAMETER_PROBLEM,
+			   "interface name `%s' must be shorter than IFNAMSIZ"
+			   " (%i)", arg, IFNAMSIZ-1);
+
+	strcpy(vianame, arg);
+	if (vialen == 0)
+		memset(mask, 0, IFNAMSIZ);
+	else if (vianame[vialen - 1] == '+') {
+		memset(mask, 0xFF, vialen - 1);
+		memset(mask + vialen - 1, 0, IFNAMSIZ - vialen + 1);
+		/* Don't remove `+' here! -HW */
+	} else {
+		/* Include nul-terminator in match */
+		memset(mask, 0xFF, vialen + 1);
+		memset(mask + vialen + 1, 0, IFNAMSIZ - vialen - 1);
+		for (i = 0; vianame[i]; i++) {
+			if (!isalnum(vianame[i])
+			    && vianame[i] != '_'
+			    && vianame[i] != '.') {
+				printf("Warning: wierd character in interface"
+				       " `%s' (No aliases, :, ! or *).\n",
+				       vianame);
+				break;
+			}
+		}
+	}
+}
+
+static void
+init(struct ip6t_entry_match *m, unsigned int *nfcache)
+{
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      unsigned int *nfcache,
+      struct ip6t_entry_match **match)
+{
+	struct ip6t_physdev_info *info =
+		(struct ip6t_physdev_info*)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & IP6T_PHYSDEV_OP_IN)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_interface(argv[optind-1], info->physindev, info->in_mask);
+		if (invert)
+			info->invert |= IP6T_PHYSDEV_OP_IN;
+		info->bitmask |= IP6T_PHYSDEV_OP_IN;
+		*flags |= IP6T_PHYSDEV_OP_IN;
+		break;
+
+	case '2':
+		if (*flags & IP6T_PHYSDEV_OP_OUT)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_interface(argv[optind-1], info->physoutdev,
+				info->out_mask);
+		if (invert)
+			info->invert |= IP6T_PHYSDEV_OP_OUT;
+		info->bitmask |= IP6T_PHYSDEV_OP_OUT;
+		*flags |= IP6T_PHYSDEV_OP_OUT;
+		break;
+
+	case '3':
+		if (*flags & IP6T_PHYSDEV_OP_ISIN)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		info->bitmask |= IP6T_PHYSDEV_OP_ISIN;
+		if (invert)
+			info->invert |= IP6T_PHYSDEV_OP_ISIN;
+		*flags |= IP6T_PHYSDEV_OP_ISIN;
+		break;
+
+	case '4':
+		if (*flags & IP6T_PHYSDEV_OP_ISOUT)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		info->bitmask |= IP6T_PHYSDEV_OP_ISOUT;
+		if (invert)
+			info->invert |= IP6T_PHYSDEV_OP_ISOUT;
+		*flags |= IP6T_PHYSDEV_OP_ISOUT;
+		break;
+
+	case '5':
+		if (*flags & IP6T_PHYSDEV_OP_BRIDGED)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			info->invert |= IP6T_PHYSDEV_OP_BRIDGED;
+		*flags |= IP6T_PHYSDEV_OP_BRIDGED;
+		info->bitmask |= IP6T_PHYSDEV_OP_BRIDGED;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+multiple_use:
+	exit_error(PARAMETER_PROBLEM,
+	   "multiple use of the same physdev option is not allowed");
+
+}
+
+static void final_check(unsigned int flags)
+{
+	if (flags == 0)
+		exit_error(PARAMETER_PROBLEM, "PHYSDEV: no physdev option specified");
+}
+
+static void
+print(const struct ip6t_ip6 *ip,
+      const struct ip6t_entry_match *match,
+      int numeric)
+{
+	struct ip6t_physdev_info *info =
+		(struct ip6t_physdev_info*)match->data;
+
+	printf("PHYSDEV match");
+	if (info->bitmask & IP6T_PHYSDEV_OP_ISIN)
+		printf("%s --physdev-is-in",
+		       info->invert & IP6T_PHYSDEV_OP_ISIN ? " !":"");
+	if (info->bitmask & IP6T_PHYSDEV_OP_IN)
+		printf("%s --physdev-in %s",
+		(info->invert & IP6T_PHYSDEV_OP_IN) ? " !":"", info->physindev);
+
+	if (info->bitmask & IP6T_PHYSDEV_OP_ISOUT)
+		printf("%s --physdev-is-out",
+		       info->invert & IP6T_PHYSDEV_OP_ISOUT ? " !":"");
+	if (info->bitmask & IP6T_PHYSDEV_OP_OUT)
+		printf("%s --physdev-out %s",
+		(info->invert & IP6T_PHYSDEV_OP_OUT) ? " !":"", info->physoutdev);
+	if (info->bitmask & IP6T_PHYSDEV_OP_BRIDGED)
+		printf("%s --physdev-is-bridged",
+		       info->invert & IP6T_PHYSDEV_OP_BRIDGED ? " !":"");
+	printf(" ");
+}
+
+static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+{
+	struct ip6t_physdev_info *info =
+		(struct ip6t_physdev_info*)match->data;
+
+	if (info->bitmask & IP6T_PHYSDEV_OP_ISIN)
+		printf("%s --physdev-is-in",
+		       info->invert & IP6T_PHYSDEV_OP_ISIN ? " !":"");
+	if (info->bitmask & IP6T_PHYSDEV_OP_IN)
+		printf("%s --physdev-in %s",
+		(info->invert & IP6T_PHYSDEV_OP_IN) ? " !":"", info->physindev);
+
+	if (info->bitmask & IP6T_PHYSDEV_OP_ISOUT)
+		printf("%s --physdev-is-out",
+		       info->invert & IP6T_PHYSDEV_OP_ISOUT ? " !":"");
+	if (info->bitmask & IP6T_PHYSDEV_OP_OUT)
+		printf("%s --physdev-out %s",
+		(info->invert & IP6T_PHYSDEV_OP_OUT) ? " !":"", info->physoutdev);
+	if (info->bitmask & IP6T_PHYSDEV_OP_BRIDGED)
+		printf("%s --physdev-is-bridged",
+		       info->invert & IP6T_PHYSDEV_OP_BRIDGED ? " !":"");
+	printf(" ");
+}
+
+static
+struct ip6tables_match physdev
+= { NULL,
+    "physdev",
+    IPTABLES_VERSION,
+    IP6T_ALIGN(sizeof(struct ip6t_physdev_info)),
+    IP6T_ALIGN(sizeof(struct ip6t_physdev_info)),
+    &help,
+    &init,
+    &parse,
+    &final_check,
+    &print,
+    &save,
+    opts
+};
+
+void _init(void)
+{
+	register_match6(&physdev);
+}
--- /dev/null	1970-01-01 01:00:00.000000000 +0100
+++ iptables/include/linux/netfilter_ipv6/ip6t_physdev.h	2004-09-11 12:44:11.000000000 +0200
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
--- /dev/null	1970-01-01 01:00:00.000000000 +0100
+++ iptables/extensions/libip6t_physdev.man	2004-09-09 23:27:20.000000000 +0200
@@ -0,0 +1,42 @@
+This module matches on the bridge port input and output devices enslaved
+to a bridge device. This module is a part of the infrastructure that enables
+a transparent bridging IP firewall and is only useful for kernel versions
+above version 2.5.44.
+.TP
+.B --physdev-in name
+Name of a bridge port via which a packet is received (only for
+packets entering the
+.BR INPUT ,
+.B FORWARD
+and
+.B PREROUTING
+chains). If the interface name ends in a "+", then any
+interface which begins with this name will match. If the packet didn't arrive
+through a bridge device, this packet won't match this option, unless '!' is used.
+.TP
+.B --physdev-out name
+Name of a bridge port via which a packet is going to be sent (for packets
+entering the
+.BR FORWARD ,
+.B OUTPUT
+and
+.B POSTROUTING
+chains).  If the interface name ends in a "+", then any
+interface which begins with this name will match. Note that in the
+.BR nat " and " mangle
+.B OUTPUT
+chains one cannot match on the bridge output port, however one can in the
+.B "filter OUTPUT"
+chain. If the packet won't leave by a bridge device or it is yet unknown what
+the output device will be, then the packet won't match this option, unless
+'!' is used.
+.TP
+.B --physdev-is-in
+Matches if the packet has entered through a bridge interface.
+.TP
+.B --physdev-is-out
+Matches if the packet will leave through a bridge interface.
+.TP
+.B --physdev-is-bridged
+Matches if the packet is being bridged and therefore is not being routed.
+This is only useful in the FORWARD and POSTROUTING chains.

--Boundary-00=_QqtQBTzimoGGzlj--
