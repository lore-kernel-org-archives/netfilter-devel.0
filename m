From: Patrick McHardy <kaber@trash.net>
Subject: Re: Corruption on mangle/INPUT when MARKing packets
Date: Wed, 08 Jan 2003 19:23:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1C6CB8.8040800@trash.net>
References: <37584.195.97.5.193.1041644841.squirrel@fs.tsaousis.gr> <20030106125230.GE9467@sunbeam.de.gnumonks.org> <3E19AE4F.5020908@trash.net> <20030108170733.GR9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070806000008010904070901"
Cc: Costa Tsaousis <costa@tsaousis.gr>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030108170733.GR9467@sunbeam.de.gnumonks.org>
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
--------------070806000008010904070901
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Harald Welte wrote:

>On Mon, Jan 06, 2003 at 05:26:55PM +0100, Patrick McHardy wrote:
>  
>
>>I think the problem lies within ip_route_me_harder. It is called on 
>>mangled packets in the INPUT chain
>>and changes skb->dst with new route after setting key.src = 0 if it's 
>>not a local address.
>>    
>>
>
>well spotted. This is exactly the problem.
>
>So the question is: Do we really need to call route_me_harder() in the
>INPUT chain?  We could argue that if somebody wants to do a change
>affecting the routing decision should make that change before the
>routing decison, not after it.  
>
That sound reasonable. Besides, i think it is a rarely used feature anyways.
The difference as far as i can see between doing the change in PRE_ROUTING
and INPUT chain is that in PRE_ROUTING chain you may not know a packet
is addressed to a local address (in case it's a dynamically assigned ip).
I've written a match some time ago to match inet_addr_type
(rtm_types from include/linux/rtnetlink.h). We use it for DNAT to 
distinguish
between packets that are to-be-routed and packets that are addressed at 
a local ip
without having to know the ip in advance (for automatically generated 
rules).
I'm attaching the patch, perhaps you like it.

Regards,
Patrick

>
>If we agree on this change, the solution is easy. Just call
>ipt_route_hook() instead of ipt_local_hook() at NF_IP_LOCAL_IN.
>
>Otherwise we'd need a seperate route_me_harder function for the case of
>non-local packets.  But I don't think this makes sense at all.
>
>Patch attached (and put into 'pending'). 
>
>Thanks.
>
>  
>


--------------070806000008010904070901
Content-Type: text/plain;
 name="addrtype-pom.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="addrtype-pom.diff"

diff -urN patch-o-matic-20020823/extra/addrtype.patch patch-o-matic-addrtype/extra/addrtype.patch
--- patch-o-matic-20020823/extra/addrtype.patch	Thu Jan  1 01:00:00 1970
+++ patch-o-matic-addrtype/extra/addrtype.patch	Wed Sep 18 14:14:50 2002
@@ -0,0 +1,139 @@
+diff -urN -X dontdiff.txt linux-2.4.20-pre5-clean/include/linux/netfilter_ipv4/ipt_addrtype.h linux-2.4.20-pre5/include/linux/netfilter_ipv4/ipt_addrtype.h
+--- linux-2.4.20-pre5-clean/include/linux/netfilter_ipv4/ipt_addrtype.h	Thu Jan  1 01:00:00 1970
++++ linux-2.4.20-pre5/include/linux/netfilter_ipv4/ipt_addrtype.h	Wed Sep 18 12:36:06 2002
+@@ -0,0 +1,28 @@
++#ifndef _IPT_ADDRTYPE_H
++#define _IPT_ADDRTYPE_H
++
++#define IPT_ADDRTYPE_SOURCE	0x1
++#define IPT_ADDRTYPE_DEST	0x2
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
++	u_int16_t	type;
++	u_int8_t	mode;
++	u_int8_t	invert;
++};
++
++#endif
+diff -urN -X dontdiff.txt linux-2.4.20-pre5-clean/net/ipv4/netfilter/ipt_addrtype.c linux-2.4.20-pre5/net/ipv4/netfilter/ipt_addrtype.c
+--- linux-2.4.20-pre5-clean/net/ipv4/netfilter/ipt_addrtype.c	Thu Jan  1 01:00:00 1970
++++ linux-2.4.20-pre5/net/ipv4/netfilter/ipt_addrtype.c	Wed Sep 18 13:41:16 2002
+@@ -0,0 +1,103 @@
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
++static int match(const struct sk_buff *skb, const struct net_device *in,
++		 const struct net_device *out, const void *matchinfo,
++		 int offset, const void *hdr, u_int16_t datalen,
++		 int *hotdrop)
++{
++	const struct ipt_addrtype_info *info = matchinfo;
++	const struct iphdr *iph = skb->nh.iph;
++	unsigned type;
++	u_int32_t addr =
++		(info->mode == IPT_ADDRTYPE_SOURCE) ? iph->saddr : iph->daddr;
++
++	type = inet_addr_type(addr);
++	switch (type) {
++		case RTN_UNSPEC:
++			if (info->type&IPT_ADDRTYPE_RTN_UNSPEC)
++				return 1 ^ info->invert;
++			break;
++		case RTN_UNICAST:
++			if (info->type&IPT_ADDRTYPE_RTN_UNICAST)
++				return 1 ^ info->invert;
++			break;
++		case RTN_LOCAL:
++			if (info->type&IPT_ADDRTYPE_RTN_LOCAL)
++				return 1 ^ info->invert;
++			break;
++		case RTN_BROADCAST:
++			if (info->type&IPT_ADDRTYPE_RTN_BROADCAST)
++				return 1 ^ info->invert;
++			break;
++		case RTN_ANYCAST:
++			if (info->type&IPT_ADDRTYPE_RTN_ANYCAST)
++				return 1 ^ info->invert;
++			break;
++		case RTN_MULTICAST:
++			if (info->type&IPT_ADDRTYPE_RTN_MULTICAST)
++				return 1 ^ info->invert;
++			break;
++		case RTN_BLACKHOLE:
++			if (info->type&IPT_ADDRTYPE_RTN_BLACKHOLE)
++				return 1 ^ info->invert;
++			break;
++		case RTN_UNREACHABLE:
++			if (info->type&IPT_ADDRTYPE_RTN_UNREACHABLE)
++				return 1 ^ info->invert;
++			break;
++		case RTN_PROHIBIT:
++			if (info->type&IPT_ADDRTYPE_RTN_PROHIBIT)
++				return 1 ^ info->invert;
++			break;
++		case RTN_THROW:
++			if (info->type&IPT_ADDRTYPE_RTN_THROW)
++				return 1 ^ info->invert;
++			break;
++		case RTN_NAT:
++			if (info->type&IPT_ADDRTYPE_RTN_NAT)
++				return 1 ^ info->invert;
++			break;
++		case RTN_XRESOLVE:
++			if (info->type&IPT_ADDRTYPE_RTN_XRESOLVE)
++				return 1 ^ info->invert;
++			break;
++	}
++	
++	return info->invert;
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
diff -urN patch-o-matic-20020823/extra/addrtype.patch.config.in patch-o-matic-addrtype/extra/addrtype.patch.config.in
--- patch-o-matic-20020823/extra/addrtype.patch.config.in	Thu Jan  1 01:00:00 1970
+++ patch-o-matic-addrtype/extra/addrtype.patch.config.in	Wed Sep 18 14:11:44 2002
@@ -0,0 +1,2 @@
+  dep_tristate '  TTL match support' CONFIG_IP_NF_MATCH_TTL $CONFIG_IP_NF_IPTABLES
+  dep_tristate '  address type match support' CONFIG_IP_NF_MATCH_ADDRTYPE $CONFIG_IP_NF_IPTABLES
diff -urN patch-o-matic-20020823/extra/addrtype.patch.help patch-o-matic-addrtype/extra/addrtype.patch.help
--- patch-o-matic-20020823/extra/addrtype.patch.help	Thu Jan  1 01:00:00 1970
+++ patch-o-matic-addrtype/extra/addrtype.patch.help	Wed Sep 18 13:55:27 2002
@@ -0,0 +1,20 @@
+Author: Patrick McHardy <kaber@trash.net>
+Status: Seems to work ..
+
+This match allows you to match address types.
+Valid types are:
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
+blabla
diff -urN patch-o-matic-20020823/extra/addrtype.patch.makefile patch-o-matic-addrtype/extra/addrtype.patch.makefile
--- patch-o-matic-20020823/extra/addrtype.patch.makefile	Thu Jan  1 01:00:00 1970
+++ patch-o-matic-addrtype/extra/addrtype.patch.makefile	Wed Sep 18 14:14:39 2002
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_MATCH_TCPMSS) += ipt_tcpmss.o
+obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
diff -urN extensions/libipt_addrtype.c extensions/libipt_addrtype.c
--- extensions/libipt_addrtype.c	Thu Jan  1 01:00:00 1970
+++ extensions/libipt_addrtype.c	Wed Sep 18 15:14:35 2002
@@ -0,0 +1,256 @@
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
+"  --source             Match source address\n"
+"  --dest               Match destination address\n"
+" [!] --type		[UNSPEC|UNICAST|LOCAL|BROADCAST|ANYCAST|MULTICAST|\n"
+"                        BLACKHOLE|UNREACHABLE|PROHIBIT|THROW|NAT|XRESOLVE]\n"
+"                       [,...]\n"
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
+parse_type(const char *type, size_t strlen, struct ipt_addrtype_info *info)
+{
+	if (strncasecmp(type, "UNSPEC", strlen) == 0)
+		info->type |= IPT_ADDRTYPE_RTN_UNSPEC;
+	else if (strncasecmp(type, "UNICAST", strlen) == 0)
+		info->type |= IPT_ADDRTYPE_RTN_UNICAST;
+	else if (strncasecmp(type, "LOCAL", strlen) == 0)
+		info->type |= IPT_ADDRTYPE_RTN_LOCAL;
+	else if (strncasecmp(type, "BROADCAST", strlen) == 0)
+		info->type |= IPT_ADDRTYPE_RTN_BROADCAST;
+	else if (strncasecmp(type, "ANYCAST", strlen) == 0)
+		info->type |= IPT_ADDRTYPE_RTN_ANYCAST;
+	else if (strncasecmp(type, "MULTICAST", strlen) == 0)
+		info->type |= IPT_ADDRTYPE_RTN_MULTICAST;
+	else if (strncasecmp(type, "BLACKHOLE", strlen) == 0)
+		info->type |= IPT_ADDRTYPE_RTN_BLACKHOLE;
+	else if (strncasecmp(type, "UNREACHABLE", strlen) == 0)
+		info->type |= IPT_ADDRTYPE_RTN_UNREACHABLE;
+	else if (strncasecmp(type, "PROHIBIT", strlen) == 0)
+		info->type |= IPT_ADDRTYPE_RTN_PROHIBIT;
+	else if (strncasecmp(type, "THROW", strlen) == 0)
+		info->type |= IPT_ADDRTYPE_RTN_THROW;
+	else if (strncasecmp(type, "NAT", strlen) == 0)
+		info->type |= IPT_ADDRTYPE_RTN_NAT;
+	else if (strncasecmp(type, "XRESOLVE", strlen) == 0)
+		info->type |= IPT_ADDRTYPE_RTN_XRESOLVE;
+	else
+		return 0;
+	return 1;
+}
+
+static void parse_types(const char *arg, struct ipt_addrtype_info *info)
+{
+	const char *comma;
+
+	while ((comma = strchr(arg, ',')) != NULL) {
+		if (comma == arg || !parse_type(arg, comma-arg, info))
+			exit_error(PARAMETER_PROBLEM, "Bad type `%s'", arg);
+		arg = comma + 1;
+	}
+
+	if (strlen(arg) == 0 || !parse_type(arg, strlen(arg), info))
+		exit_error(PARAMETER_PROBLEM, "Bad type `%s'", arg);
+}
+	
+#define IPT_ADDRTYPE_OPT_DIR	0x1
+#define IPT_ADDRTYPE_OPT_TYPE	0x2
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
+			if (*flags&IPT_ADDRTYPE_OPT_DIR)
+				exit_error(PARAMETER_PROBLEM,
+					   "Can't specify source/dest twice");
+
+			info->mode = IPT_ADDRTYPE_SOURCE;
+			*flags |= IPT_ADDRTYPE_OPT_DIR;
+			break;
+		case '2':
+			if (*flags&IPT_ADDRTYPE_OPT_DIR)
+				exit_error(PARAMETER_PROBLEM,
+					   "Can't specify source/dest twice");
+
+			info->mode = IPT_ADDRTYPE_DEST;
+			*flags |= IPT_ADDRTYPE_OPT_DIR;
+			break;
+		case '3':
+			if (*flags&IPT_ADDRTYPE_OPT_TYPE)
+				exit_error(PARAMETER_PROBLEM,
+					   "Can't specify --type twice");
+
+			check_inverse(optarg, &invert, &optind, 0);
+			parse_types(argv[optind-1], info);
+			if (invert)
+				info->invert = 1;
+			*flags |= IPT_ADDRTYPE_OPT_TYPE;
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
+	if (!(flags&IPT_ADDRTYPE_OPT_DIR))
+		exit_error(PARAMETER_PROBLEM,
+			   "addrtype: you must specify --source or --dest");
+	if (!(flags&IPT_ADDRTYPE_OPT_TYPE))
+		exit_error(PARAMETER_PROBLEM,
+			   "addrtype: you must specify --type");
+}
+
+static void print_type(unsigned typemask) {
+	const char *sep = "";
+	if (typemask&IPT_ADDRTYPE_RTN_UNSPEC) {
+		printf("%sUNSPEC", sep);
+		sep = ",";
+	}
+	if (typemask&IPT_ADDRTYPE_RTN_UNICAST) {
+		printf("%sUNICAST", sep);
+		sep = ",";
+	}
+	if (typemask&IPT_ADDRTYPE_RTN_LOCAL) {
+		printf("%sLOCAL", sep);
+		sep = ",";
+	}
+	if (typemask&IPT_ADDRTYPE_RTN_BROADCAST) {
+		printf("%sBROADCAST", sep);
+		sep = ",";
+	}
+	if (typemask&IPT_ADDRTYPE_RTN_ANYCAST) {
+		printf("%sANYCAST", sep);
+		sep = ",";
+	}
+	if (typemask&IPT_ADDRTYPE_RTN_MULTICAST) {
+		printf("%sMULTICAST", sep);
+		sep = ",";
+	}
+	if (typemask&IPT_ADDRTYPE_RTN_BLACKHOLE) {
+		printf("%sBLACKHOLE", sep);
+		sep = ",";
+	}
+	if (typemask&IPT_ADDRTYPE_RTN_UNREACHABLE) {
+		printf("%sUNREACHABLE", sep);
+		sep = ",";
+	}
+	if (typemask&IPT_ADDRTYPE_RTN_PROHIBIT) {
+		printf("%sPROHIBIT", sep);
+		sep = ",";
+	}
+	if (typemask&IPT_ADDRTYPE_RTN_THROW) {
+		printf("%sTHROW", sep);
+		sep = ",";
+	}
+	if (typemask&IPT_ADDRTYPE_RTN_XRESOLVE) {
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
+	switch (info->mode) {
+		case IPT_ADDRTYPE_SOURCE:
+			printf("sourceaddr ");
+			break;
+		case IPT_ADDRTYPE_DEST:
+			printf("destaddr ");
+			break;
+	}
+
+	if (info->invert)
+		printf("!");
+
+	print_type(info->type);
+}
+
+static void save(const struct ipt_ip *ip, 
+		const struct ipt_entry_match *match)
+{
+	const struct ipt_addrtype_info *info =
+		(struct ipt_addrtype_info *) match->data;
+
+	switch (info->mode) {
+		case IPT_ADDRTYPE_SOURCE:
+			printf("--source ");
+			break;
+		case IPT_ADDRTYPE_DEST:
+			printf("--dest ");
+			break;
+		default:
+			break;
+	}
+
+	if (info->invert)
+		printf("! ");
+	printf("--type ");
+	print_type(info->type);
+}
+
+static struct option opts[] = {
+	{ "source", 0, 0, '1' },
+	{ "dest", 0, 0, '2' },
+	{ "type", 1, 0, '3' },
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
diff -urN extensions/.addrtype-test extensions/.addrtype-test
--- extensions/.addrtype-test	Thu Jan  1 01:00:00 1970
+++ extensions/.addrtype-test	Wed Sep 18 15:18:25 2002
@@ -0,0 +1,5 @@
+#!/bin/bash
+
+if test -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_addrtype.h; then
+	echo "addrtype"
+fi

--------------070806000008010904070901--
