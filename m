From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] addrtype match
Date: Tue, 08 Apr 2003 18:02:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E92F28B.2020401@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090807060708040807080008"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------090807060708040807080008
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds a new match "addrtype" which can be used to match
the result of inet_addr_type, which is what routing thinks of an address.
We use it for automatic generated rules where DNAT rules can be
generated with just an interface match because the local ip may be
unknown at rule generation time. The match is then used to exclude
local addresses from DNAT. Please consider for inclusion.

Bye,
Patrick

--------------090807060708040807080008
Content-Type: text/plain;
 name="nf-addrtype.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nf-addrtype.diff"

diff -urN a/patch-o-matic/extra/addrtype.patch b/patch-o-matic/extra/addrtype.patch
--- a/patch-o-matic/extra/addrtype.patch	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic/extra/addrtype.patch	2003-04-08 16:50:05.000000000 +0200
@@ -0,0 +1,145 @@
+diff -urN a/include/linux/netfilter_ipv4/ipt_addrtype.h b/include/linux/netfilter_ipv4/ipt_addrtype.h
+--- a/include/linux/netfilter_ipv4/ipt_addrtype.h	1970-01-01 01:00:00.000000000 +0100
++++ b/include/linux/netfilter_ipv4/ipt_addrtype.h	2003-04-08 13:38:02.000000000 +0200
+@@ -0,0 +1,26 @@
++#ifndef _IPT_ADDRTYPE_H
++#define _IPT_ADDRTYPE_H
++
++/* from linux/rtnetlink.h */
++
++#define IPT_ADDRTYPE_RTN_UNSPEC		0x0001
++#define IPT_ADDRTYPE_RTN_UNICAST	0x0002
++#define IPT_ADDRTYPE_RTN_LOCAL		0x0004
++#define IPT_ADDRTYPE_RTN_BROADCAST	0x0008
++#define IPT_ADDRTYPE_RTN_ANYCAST	0x0010
++#define IPT_ADDRTYPE_RTN_MULTICAST	0x0020
++#define IPT_ADDRTYPE_RTN_BLACKHOLE	0x0040
++#define IPT_ADDRTYPE_RTN_UNREACHABLE	0x0080
++#define IPT_ADDRTYPE_RTN_PROHIBIT	0x0100
++#define IPT_ADDRTYPE_RTN_THROW		0x0200
++#define IPT_ADDRTYPE_RTN_NAT		0x0400
++#define IPT_ADDRTYPE_RTN_XRESOLVE	0x0800
++
++struct ipt_addrtype_info {
++	u_int16_t	source;
++	u_int16_t	dest;
++	int		invert_source;	/* -m addtype ! --source .. */
++	int		invert_dest;	/* -m addrtype ! --dest .. */
++};
++
++#endif
+diff -urN a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
+--- a/net/ipv4/netfilter/ipt_addrtype.c	1970-01-01 01:00:00.000000000 +0100
++++ b/net/ipv4/netfilter/ipt_addrtype.c	2003-04-08 15:41:05.000000000 +0200
+@@ -0,0 +1,111 @@
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/netdevice.h>
++
++#include <net/route.h>
++
++#include <linux/netfilter_ipv4/ipt_addrtype.h>
++#include <linux/netfilter_ipv4/ip_tables.h>
++
++MODULE_LICENSE("GPL");
++
++static int match_type(u_int32_t addr, u_int16_t types)
++{
++	unsigned type = inet_addr_type(addr);
++
++	switch(type) {
++		case RTN_UNSPEC:
++			if (types&IPT_ADDRTYPE_RTN_UNSPEC)
++				return 1;
++			break;
++		case RTN_UNICAST:
++			if (types&IPT_ADDRTYPE_RTN_UNICAST)
++				return 1;
++			break;
++		case RTN_LOCAL:
++			if (types&IPT_ADDRTYPE_RTN_LOCAL)
++				return 1;
++			break;
++		case RTN_BROADCAST:
++			if (type&IPT_ADDRTYPE_RTN_BROADCAST)
++				return 1;
++			break;
++		case RTN_ANYCAST:
++			if (types&IPT_ADDRTYPE_RTN_ANYCAST)
++				return 1;
++			break;
++		case RTN_MULTICAST:
++			if (types&IPT_ADDRTYPE_RTN_MULTICAST)
++				return 1;
++			break;
++		case RTN_BLACKHOLE:
++			if (types&IPT_ADDRTYPE_RTN_BLACKHOLE)
++				return 1;
++			break;
++		case RTN_UNREACHABLE:
++			if (types&IPT_ADDRTYPE_RTN_UNREACHABLE)
++				return 1;
++			break;
++		case RTN_PROHIBIT:
++			if (types&IPT_ADDRTYPE_RTN_PROHIBIT)
++				return 1;
++			break;
++		case RTN_THROW:
++			if (types&IPT_ADDRTYPE_RTN_THROW)
++				return 1;
++			break;
++		case RTN_NAT:
++			if (types&IPT_ADDRTYPE_RTN_NAT)
++				return 1;
++			break;
++		case RTN_XRESOLVE:
++			if (types&IPT_ADDRTYPE_RTN_XRESOLVE)
++				return 1;
++			break;
++	}
++	return 0;
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
++	if (matchsize != IPT_ALIGN(sizeof(struct ipt_addrtype_info)))
++		return 0;
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
+++ b/patch-o-matic/extra/addrtype.patch.config.in	2003-04-08 16:50:05.000000000 +0200
@@ -0,0 +1,2 @@
+  dep_tristate '  TTL match support' CONFIG_IP_NF_MATCH_TTL $CONFIG_IP_NF_IPTABLES
+  dep_tristate '  address type match support' CONFIG_IP_NF_MATCH_ADDRTYPE $CONFIG_IP_NF_IPTABLES
diff -urN a/patch-o-matic/extra/addrtype.patch.help b/patch-o-matic/extra/addrtype.patch.help
--- a/patch-o-matic/extra/addrtype.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic/extra/addrtype.patch.help	2003-04-08 16:50:05.000000000 +0200
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
+	-m addrtype --source type[,type..] --dest type[,type..]
+
+Example:
+
+	iptables ... -m addrtype --source LOCAL ...
+	iptables ... -m addrtype --dest ANYCAST ...
+
+
diff -urN a/patch-o-matic/extra/addrtype.patch.makefile b/patch-o-matic/extra/addrtype.patch.makefile
--- a/patch-o-matic/extra/addrtype.patch.makefile	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic/extra/addrtype.patch.makefile	2003-04-08 16:50:05.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_MATCH_TCPMSS) += ipt_tcpmss.o
+obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
diff -urN a/userspace/extensions/.addrtype-test b/userspace/extensions/.addrtype-test
--- a/userspace/extensions/.addrtype-test	1970-01-01 01:00:00.000000000 +0100
+++ b/userspace/extensions/.addrtype-test	2003-04-08 16:50:05.000000000 +0200
@@ -0,0 +1,5 @@
+#!/bin/bash
+
+if test -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_addrtype.h; then
+	echo "addrtype"
+fi
diff -urN a/userspace/extensions/libipt_addrtype.c b/userspace/extensions/libipt_addrtype.c
--- a/userspace/extensions/libipt_addrtype.c	1970-01-01 01:00:00.000000000 +0100
+++ b/userspace/extensions/libipt_addrtype.c	2003-04-08 16:50:24.000000000 +0200
@@ -0,0 +1,245 @@
+/* Shared library add-on to iptables to add TTL matching support 
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
+static void help(void) 
+{
+	printf(
+"Address type match v%s options:\n"
+" [!] --source type[,...]"
+"                       Match source address type\n"
+" [!] --dest type[,...]"
+"                       Match destination address type\n"
+"\n"
+"Valid types:           UNSPEC,UNICAST,LOCAL,BROADCAST,ANYCAST,MULTICAST,\n"
+"                       BLACKHOLE,UNREACHABLE,PROHIBIT,THROW,NAT,XRESOLVE\n"
+, IPTABLES_VERSION);
+}
+
+static void init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+	/* caching not yet implemented */
+	*nfcache |= NFC_UNKNOWN;
+}
+
+static int
+parse_type(const char *type, size_t strlen, u_int16_t *i)
+{
+	if (strncasecmp(type, "UNSPEC", strlen) == 0)
+		*i |= IPT_ADDRTYPE_RTN_UNSPEC;
+	else if (strncasecmp(type, "UNICAST", strlen) == 0)
+		*i |= IPT_ADDRTYPE_RTN_UNICAST;
+	else if (strncasecmp(type, "LOCAL", strlen) == 0)
+		*i |= IPT_ADDRTYPE_RTN_LOCAL;
+	else if (strncasecmp(type, "BROADCAST", strlen) == 0)
+		*i |= IPT_ADDRTYPE_RTN_BROADCAST;
+	else if (strncasecmp(type, "ANYCAST", strlen) == 0)
+		*i |= IPT_ADDRTYPE_RTN_ANYCAST;
+	else if (strncasecmp(type, "MULTICAST", strlen) == 0)
+		*i |= IPT_ADDRTYPE_RTN_MULTICAST;
+	else if (strncasecmp(type, "BLACKHOLE", strlen) == 0)
+		*i |= IPT_ADDRTYPE_RTN_BLACKHOLE;
+	else if (strncasecmp(type, "UNREACHABLE", strlen) == 0)
+		*i |= IPT_ADDRTYPE_RTN_UNREACHABLE;
+	else if (strncasecmp(type, "PROHIBIT", strlen) == 0)
+		*i |= IPT_ADDRTYPE_RTN_PROHIBIT;
+	else if (strncasecmp(type, "THROW", strlen) == 0)
+		*i |= IPT_ADDRTYPE_RTN_THROW;
+	else if (strncasecmp(type, "NAT", strlen) == 0)
+		*i |= IPT_ADDRTYPE_RTN_NAT;
+	else if (strncasecmp(type, "XRESOLVE", strlen) == 0)
+		*i |= IPT_ADDRTYPE_RTN_XRESOLVE;
+	else
+		return 0;
+	return 1;
+}
+
+static void parse_types(const char *arg, u_int16_t *i)
+{
+	const char *comma;
+
+	while ((comma = strchr(arg, ',')) != NULL) {
+		if (comma == arg || !parse_type(arg, comma-arg, i))
+			exit_error(PARAMETER_PROBLEM, "Bad type `%s'", arg);
+		arg = comma + 1;
+	}
+
+	if (strlen(arg) == 0 || !parse_type(arg, strlen(arg), i))
+		exit_error(PARAMETER_PROBLEM, "Bad type `%s'", arg);
+}
+	
+#define IPT_ADDRTYPE_OPT_SOURCE	0x1
+#define IPT_ADDRTYPE_OPT_DEST	0x2
+
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+		const struct ipt_entry *entry, unsigned int *nfcache,
+		struct ipt_entry_match **match)
+{
+	struct ipt_addrtype_info *info =
+		(struct ipt_addrtype_info *) (*match)->data;
+
+	switch (c) {
+		case '1':
+			if (*flags&IPT_ADDRTYPE_OPT_SOURCE)
+				exit_error(PARAMETER_PROBLEM,
+					   "Can't specify source twice");
+
+			check_inverse(optarg, &invert, &optind, 0);
+			parse_types(argv[optind-1], &info->source);
+			if (invert)
+				info->invert_source = 1;
+			*flags |= IPT_ADDRTYPE_OPT_SOURCE;
+			break;
+		case '2':
+			if (*flags&IPT_ADDRTYPE_OPT_DEST)
+				exit_error(PARAMETER_PROBLEM,
+					   "Can't specify dest twice");
+
+			check_inverse(optarg, &invert, &optind, 0);
+			parse_types(argv[optind-1], &info->dest);
+			if (invert)
+				info->invert_dest = 1;
+			*flags |= IPT_ADDRTYPE_OPT_DEST;
+			break;
+		default:
+			return 0;
+	}
+	
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!(flags&(IPT_ADDRTYPE_OPT_SOURCE|IPT_ADDRTYPE_OPT_DEST)))
+		exit_error(PARAMETER_PROBLEM,
+			   "addrtype: you must specify --source or --dest");
+}
+
+static void print_type(u_int16_t types) {
+	const char *sep = "";
+	if (types&IPT_ADDRTYPE_RTN_UNSPEC) {
+		printf("%sUNSPEC", sep);
+		sep = ",";
+	}
+	if (types&IPT_ADDRTYPE_RTN_UNICAST) {
+		printf("%sUNICAST", sep);
+		sep = ",";
+	}
+	if (types&IPT_ADDRTYPE_RTN_LOCAL) {
+		printf("%sLOCAL", sep);
+		sep = ",";
+	}
+	if (types&IPT_ADDRTYPE_RTN_BROADCAST) {
+		printf("%sBROADCAST", sep);
+		sep = ",";
+	}
+	if (types&IPT_ADDRTYPE_RTN_ANYCAST) {
+		printf("%sANYCAST", sep);
+		sep = ",";
+	}
+	if (types&IPT_ADDRTYPE_RTN_MULTICAST) {
+		printf("%sMULTICAST", sep);
+		sep = ",";
+	}
+	if (types&IPT_ADDRTYPE_RTN_BLACKHOLE) {
+		printf("%sBLACKHOLE", sep);
+		sep = ",";
+	}
+	if (types&IPT_ADDRTYPE_RTN_UNREACHABLE) {
+		printf("%sUNREACHABLE", sep);
+		sep = ",";
+	}
+	if (types&IPT_ADDRTYPE_RTN_PROHIBIT) {
+		printf("%sPROHIBIT", sep);
+		sep = ",";
+	}
+	if (types&IPT_ADDRTYPE_RTN_THROW) {
+		printf("%sTHROW", sep);
+		sep = ",";
+	}
+	if (types&IPT_ADDRTYPE_RTN_XRESOLVE) {
+		printf("%sXRESOLVE", sep);
+		sep = ",";
+	}
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
+
+	if (info->source) {
+		printf("source ");
+		if (info->invert_source)
+			printf("!");
+		print_type(info->source);
+	}
+	if (info->dest) {
+		printf("dest ");
+		if (info->invert_dest)
+			printf("!");
+		print_type(info->dest);
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
+		printf("--source ");
+		if (info->invert_source)
+			printf("! ");
+		print_type(info->source);
+	}
+	if (info->dest) {
+		printf("--dest ");
+		if (info->invert_dest)
+			printf("! ");
+		print_type(info->dest);
+	}
+}
+
+static struct option opts[] = {
+	{ "source", 1, 0, '1' },
+	{ "dest", 1, 0, '2' },
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

--------------090807060708040807080008--
