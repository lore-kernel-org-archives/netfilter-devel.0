From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] addrtype match
Date: Fri, 11 Apr 2003 16:27:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E96D0E6.9030106@trash.net>
References: <Pine.LNX.4.33.0304111158460.31394-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010505010205000503040002"
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0304111158460.31394-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010505010205000503040002
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jozsef,
thanks for applying all the other patches. Here is the addrtype match
again, with configure.help.

Thanks,
Patrick

Jozsef Kadlecsik wrote:

>Before sending the real patch, please add an addrtype.configure.help.
>That was missing from the previous versions.
>
>Best regards,
>Jozsef
>
>  
>

--------------010505010205000503040002
Content-Type: text/plain;
 name="nf-addrtype.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nf-addrtype.diff"

diff -urN a/patch-o-matic/extra/addrtype.patch b/patch-o-matic/extra/addrtype.patch
--- a/patch-o-matic/extra/addrtype.patch	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic/extra/addrtype.patch	2003-04-11 15:59:00.000000000 +0200
@@ -0,0 +1,84 @@
+diff -urN a/include/linux/netfilter_ipv4/ipt_addrtype.h b/include/linux/netfilter_ipv4/ipt_addrtype.h
+--- a/include/linux/netfilter_ipv4/ipt_addrtype.h	1970-01-01 01:00:00.000000000 +0100
++++ b/include/linux/netfilter_ipv4/ipt_addrtype.h	2003-04-09 13:42:03.000000000 +0200
+@@ -0,0 +1,11 @@
++#ifndef _IPT_ADDRTYPE_H
++#define _IPT_ADDRTYPE_H
++
++struct ipt_addrtype_info {
++	u_int16_t	source;		/* source-type mask */
++	u_int16_t	dest;		/* dest-type mask */
++	int		invert_source;
++	int		invert_dest;
++};
++
++#endif
+diff -urN a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
+--- a/net/ipv4/netfilter/ipt_addrtype.c	1970-01-01 01:00:00.000000000 +0100
++++ b/net/ipv4/netfilter/ipt_addrtype.c	2003-04-09 13:43:50.000000000 +0200
+@@ -0,0 +1,65 @@
++/*
++ *  iptables module to match inet_addr_type() of an ip.
++ */
++
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/netdevice.h>
++#include <net/route.h>
++
++#include <linux/netfilter_ipv4/ipt_addrtype.h>
++#include <linux/netfilter_ipv4/ip_tables.h>
++
++MODULE_LICENSE("GPL");
++
++static inline int match_type(u_int32_t addr, u_int16_t mask)
++{
++	return !!(mask & (1 << inet_addr_type(addr)));
++}
++
++static int match(const struct sk_buff *skb, const struct net_device *in,
++		 const struct net_device *out, const void *matchinfo,
++		 int offset, const void *hdr, u_int16_t datalen,
++		 int *hotdrop)
++{
++	const struct ipt_addrtype_info *info = matchinfo;
++	const struct iphdr *iph = skb->nh.iph;
++	int ret = 1;
++
++	if (info->source)
++		ret &= match_type(iph->saddr, info->source)^info->invert_source;
++	if (info->dest)
++		ret &= match_type(iph->daddr, info->dest)^info->invert_dest;
++	
++	return ret;
++}
++
++static int checkentry(const char *tablename, const struct ipt_ip *ip,
++		      void *matchinfo, unsigned int matchsize,
++		      unsigned int hook_mask)
++{
++	if (matchsize != IPT_ALIGN(sizeof(struct ipt_addrtype_info))) {
++		printk(KERN_ERR "ipt_addrtype: invalid size (%u != %u)\n.",
++		       matchsize, IPT_ALIGN(sizeof(struct ipt_addrtype_info)));
++		return 0;
++	}
++
++	return 1;
++}
++
++static struct ipt_match addrtype_match = { { NULL, NULL }, "addrtype", &match,
++		&checkentry, NULL, THIS_MODULE };
++
++static int __init init(void)
++{
++	return ipt_register_match(&addrtype_match);
++}
++
++static void __exit fini(void)
++{
++	ipt_unregister_match(&addrtype_match);
++
++}
++
++module_init(init);
++module_exit(fini);
diff -urN a/patch-o-matic/extra/addrtype.patch.config.in b/patch-o-matic/extra/addrtype.patch.config.in
--- a/patch-o-matic/extra/addrtype.patch.config.in	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic/extra/addrtype.patch.config.in	2003-04-11 15:59:00.000000000 +0200
@@ -0,0 +1,2 @@
+  dep_tristate '  TTL match support' CONFIG_IP_NF_MATCH_TTL $CONFIG_IP_NF_IPTABLES
+  dep_tristate '  address type match support' CONFIG_IP_NF_MATCH_ADDRTYPE $CONFIG_IP_NF_IPTABLES
diff -urN a/patch-o-matic/extra/addrtype.patch.configure.help b/patch-o-matic/extra/addrtype.patch.configure.help
--- a/patch-o-matic/extra/addrtype.patch.configure.help	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic/extra/addrtype.patch.configure.help	2003-04-11 16:17:02.000000000 +0200
@@ -0,0 +1,8 @@
+CONFIG_IP_NF_MATCH_LIMIT
+addrtype match support
+CONFIG_IP_NF_MATCH_ADDRTYPE
+  This option allows you to match what routing thinks of an address,
+  eg. UNICAST, LOCAL, BROADCAST, ...
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
diff -urN a/patch-o-matic/extra/addrtype.patch.help b/patch-o-matic/extra/addrtype.patch.help
--- a/patch-o-matic/extra/addrtype.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic/extra/addrtype.patch.help	2003-04-11 15:59:00.000000000 +0200
@@ -0,0 +1,28 @@
+Author: Patrick McHardy <kaber@trash.net>
+Status: Working
+
+This match allows you to match address types as seen by the routing code.
+Valid types (from include/linux/rtnetlink.h) are:
+
+UNSPEC
+UNICAST
+LOCAL
+BROADCAST
+ANYCAST
+MULTICAST
+BLACKHOLE
+UNREACHABLE
+PROHIBIT
+THROW
+NAT
+XRESOLVE
+
+Usage:
+	-m addrtype --stype type[,type..] --dtype type[,type..]
+
+Example:
+
+	iptables ... -m addrtype --stype LOCAL ...
+	iptables ... -m addrtype --dtype ANYCAST ...
+
+
diff -urN a/patch-o-matic/extra/addrtype.patch.makefile b/patch-o-matic/extra/addrtype.patch.makefile
--- a/patch-o-matic/extra/addrtype.patch.makefile	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic/extra/addrtype.patch.makefile	2003-04-11 15:59:00.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_MATCH_TCPMSS) += ipt_tcpmss.o
+obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
diff -urN a/userspace/extensions/.addrtype-test b/userspace/extensions/.addrtype-test
--- a/userspace/extensions/.addrtype-test	1970-01-01 01:00:00.000000000 +0100
+++ b/userspace/extensions/.addrtype-test	2003-04-11 15:59:00.000000000 +0200
@@ -0,0 +1,5 @@
+#!/bin/bash
+
+if test -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_addrtype.h; then
+	echo "addrtype"
+fi
diff -urN a/userspace/extensions/libipt_addrtype.c b/userspace/extensions/libipt_addrtype.c
--- a/userspace/extensions/libipt_addrtype.c	1970-01-01 01:00:00.000000000 +0100
+++ b/userspace/extensions/libipt_addrtype.c	2003-04-11 16:12:36.000000000 +0200
@@ -0,0 +1,214 @@
+/* Shared library add-on to iptables to add addrtype matching support 
+ * 
+ * This program is released under the terms of GNU GPL */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <iptables.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_addrtype.h>
+
+/* from linux/rtnetlink.h, must match order of enumeration */
+static char *rtn_names[] = {
+	"UNSPEC",
+	"UNICAST",
+	"LOCAL",
+	"BROADCAST",
+	"ANYCAST",
+	"MULTICAST",
+	"BLACKHOLE",
+	"UNREACHABLE",
+	"PROHIBIT",
+	"THROW",
+	"NAT",
+	"XRESOLVE",
+	NULL
+};
+
+static void help_types(void)
+{
+	int i;
+
+	for (i = 0; rtn_names[i]; i++)
+		printf("                                %s\n", rtn_names[i]);
+}
+
+static void help(void) 
+{
+	printf(
+"Address type match v%s options:\n"
+" [!] --stype type[,...]         Match source address type\n"
+" [!] --dtype type[,...]         Match destination address type\n"
+"\n"
+"Valid types:           \n"
+, IPTABLES_VERSION);
+	help_types();
+}
+
+static void init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+	/* caching not yet implemented */
+	*nfcache |= NFC_UNKNOWN;
+}
+
+static int
+parse_type(const char *name, size_t strlen, u_int16_t *mask)
+{
+	int i;
+
+	for (i = 0; rtn_names[i]; i++)
+		if (strncasecmp(name, rtn_names[i], strlen) == 0) {
+			/* build up bitmask for kernel module */
+			*mask |= (1 << i);
+			return 1;
+		}
+
+	return 0;
+}
+
+static void parse_types(const char *arg, u_int16_t *mask)
+{
+	const char *comma;
+
+	while ((comma = strchr(arg, ',')) != NULL) {
+		if (comma == arg || !parse_type(arg, comma-arg, mask))
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: bad type `%s'", arg);
+		arg = comma + 1;
+	}
+
+	if (strlen(arg) == 0 || !parse_type(arg, strlen(arg), mask))
+		exit_error(PARAMETER_PROBLEM, "addrtype: bad type `%s'", arg);
+}
+	
+#define IPT_ADDRTYPE_OPT_STYPE	0x1
+#define IPT_ADDRTYPE_OPT_DTYPE	0x2
+
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+		const struct ipt_entry *entry, unsigned int *nfcache,
+		struct ipt_entry_match **match)
+{
+	struct ipt_addrtype_info *info =
+		(struct ipt_addrtype_info *) (*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags&IPT_ADDRTYPE_OPT_STYPE)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify stype twice");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_types(argv[optind-1], &info->source);
+		if (invert)
+			info->invert_source = 1;
+		*flags |= IPT_ADDRTYPE_OPT_STYPE;
+		break;
+	case '2':
+		if (*flags&IPT_ADDRTYPE_OPT_DTYPE)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify dtype twice");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_types(argv[optind-1], &info->dest);
+		if (invert)
+			info->invert_dest = 1;
+		*flags |= IPT_ADDRTYPE_OPT_DTYPE;
+		break;
+	default:
+		return 0;
+	}
+	
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!(flags & (IPT_ADDRTYPE_OPT_STYPE|IPT_ADDRTYPE_OPT_DTYPE)))
+		exit_error(PARAMETER_PROBLEM,
+			   "addrtype: you must specify --stype or --dtype");
+}
+
+static void print_types(u_int16_t mask)
+{
+	const char *sep = "";
+	int i;
+
+	for (i = 0; rtn_names[i]; i++)
+		if (mask & (1 << i)) {
+			printf("%s%s", sep, rtn_names[i]);
+			sep = ",";
+		}
+
+	printf(" ");
+}
+
+static void print(const struct ipt_ip *ip, 
+		const struct ipt_entry_match *match,
+		int numeric)
+{
+	const struct ipt_addrtype_info *info = 
+		(struct ipt_addrtype_info *) match->data;
+
+	printf("ADDRTYPE match ");
+	if (info->source) {
+		printf("stype ");
+		if (info->invert_source)
+			printf("!");
+		print_types(info->source);
+	}
+	if (info->dest) {
+		printf("dtype ");
+		if (info->invert_dest)
+			printf("!");
+		print_types(info->dest);
+	}
+}
+
+static void save(const struct ipt_ip *ip, 
+		const struct ipt_entry_match *match)
+{
+	const struct ipt_addrtype_info *info =
+		(struct ipt_addrtype_info *) match->data;
+
+	if (info->source) {
+		printf("--stype ");
+		if (info->invert_source)
+			printf("! ");
+		print_types(info->source);
+	}
+	if (info->dest) {
+		printf("--dtype ");
+		if (info->invert_dest)
+			printf("! ");
+		print_types(info->dest);
+	}
+}
+
+static struct option opts[] = {
+	{ "stype", 1, 0, '1' },
+	{ "dtype", 1, 0, '2' },
+	{ 0 }
+};
+
+static
+struct iptables_match addrtype = {
+	NULL,
+	"addrtype",
+	IPTABLES_VERSION,
+	IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
+	IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
+	&help,
+	&init,
+	&parse,
+	&final_check,
+	&print,
+	&save,
+	opts
+};
+
+
+void _init(void) 
+{
+	register_match(&addrtype);
+}

--------------010505010205000503040002--
