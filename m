From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] secpath match
Date: Tue, 26 Aug 2003 18:08:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F4B8604.4010106@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050508050207000300090401"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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
--------------050508050207000300090401
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,
this is a second version of the sectype match I sent to netfilter-devel
yesterday. It is used to match stuff from the secpath of a decapsulated
packet. It can be used for matching if a packet came from a specific
tunnel, tunnel endpoints, spis, protos, ... and can also match complex
descriptions like "ah transport + esp tunnel from 192.168.0.0/24".
If you like it, please add to patch-o-matic.

Best regards,
Patrick


--------------050508050207000300090401
Content-Type: text/plain;
 name="nf-secpath.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nf-secpath.diff"

diff -urN a/patch-o-matic_2.5/extra/secpath.patch b/patch-o-matic_2.5/extra/secpath.patch
--- a/patch-o-matic_2.5/extra/secpath.patch	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic_2.5/extra/secpath.patch	2003-08-26 17:45:50.000000000 +0200
@@ -0,0 +1,193 @@
+diff -Nru a/include/linux/netfilter_ipv4/ipt_secpath.h b/include/linux/netfilter_ipv4/ipt_secpath.h
+--- /dev/null	Wed Dec 31 16:00:00 1969
++++ b/include/linux/netfilter_ipv4/ipt_secpath.h	Tue Aug 26 16:09:24 2003
+@@ -0,0 +1,43 @@
++#ifndef _IPT_SECPATH_H
++#define _IPT_SECPATH_H
++
++#define SECPATH_MAX_DEPTH	4		/* must match XFRM_MAX_DEPTH */
++
++#define MATCH_PATH		0x1
++
++#define SECPATH_MODE_TRANSPORT	0
++#define SECPATH_MODE_TUNNEL	1
++
++struct ipt_secpath_flags
++{
++	u_int8_t saddr:1,
++	         daddr:1,
++	         spi:1,
++	         reqid:1,
++	         proto:1,
++	         mode:1;
++};
++
++struct ipt_secpath_elem
++{
++	u_int32_t saddr;
++	u_int32_t smask;
++	u_int32_t daddr;
++	u_int32_t dmask;
++	u_int32_t spi;
++	u_int32_t reqid;
++	u_int8_t proto;
++	u_int8_t mode;
++
++	struct ipt_secpath_flags match;
++	struct ipt_secpath_flags invert;
++};
++
++struct ipt_secpath_info
++{
++	struct ipt_secpath_elem path[SECPATH_MAX_DEPTH];
++	u_int8_t len;
++	u_int8_t flags;
++};
++
++#endif
+diff -Nru a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
+--- a/net/ipv4/netfilter/Kconfig	Tue Aug 26 16:09:24 2003
++++ b/net/ipv4/netfilter/Kconfig	Tue Aug 26 16:09:24 2003
+@@ -301,6 +301,17 @@
+ 	  If you want to compile it as a module, say M here and read
+ 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+ 
++config IP_NF_MATCH_SECPATH
++	tristate "Secpath match support"
++	depends on EXPERIMENTAL && IP_NF_IPTABLES
++	help
++	  Secpath packet matching allows you to match various attributes
++	  of a packets secpath which describes the path a packet took through
++	  the (ipsec) transformers during decapsulation.
++
++	  If you want to compile it as a module, say M here and read
++	  <file:Documentation/modules.txt>.  If unsure, say `N'.
++
+ # The targets
+ config IP_NF_FILTER
+ 	tristate "Packet filtering"
+diff -Nru a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
+--- a/net/ipv4/netfilter/Makefile	Tue Aug 26 16:09:24 2003
++++ b/net/ipv4/netfilter/Makefile	Tue Aug 26 16:09:24 2003
+@@ -65,6 +65,7 @@
+ obj-$(CONFIG_IP_NF_MATCH_TCPMSS) += ipt_tcpmss.o
+ 
+ obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev.o
++obj-$(CONFIG_IP_NF_MATCH_SECPATH) += ipt_secpath.o
+ 
+ # targets
+ obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
+diff -Nru a/net/ipv4/netfilter/ipt_secpath.c b/net/ipv4/netfilter/ipt_secpath.c
+--- /dev/null	Wed Dec 31 16:00:00 1969
++++ b/net/ipv4/netfilter/ipt_secpath.c	Tue Aug 26 16:09:24 2003
+@@ -0,0 +1,110 @@
++/* IP tables module for matching various secpath attributes
++ *
++ * (C) 2003 by Patrick McHardy <kaber@trash.net>
++ *
++ * This software is distributed under the terms of the GNU GPL version 2.
++ */
++
++#include <linux/config.h>
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <net/xfrm.h>
++
++#include <linux/netfilter_ipv4/ipt_secpath.h>
++#include <linux/netfilter_ipv4/ip_tables.h>
++
++MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
++MODULE_DESCRIPTION("IPtables secpath attribute matching module");
++MODULE_LICENSE("GPL");
++
++static int match_secpath(struct xfrm_state *x, const struct ipt_secpath_elem *e)
++{
++	if (e->match.saddr) {
++		if ((e->saddr != ((u32) x->props.saddr.a4 & e->smask)) ^
++		    e->invert.saddr)
++			return 0;
++	}
++	if (e->match.daddr) {
++		if ((e->daddr != ((u32) x->id.daddr.a4 & e->dmask)) ^
++		    e->invert.daddr)
++			return 0;
++	}
++	if (e->match.proto) {
++		if ((e->proto != x->id.proto) ^ e->invert.proto)
++			return 0;
++	}
++	if (e->match.mode) {
++		if ((e->mode != x->props.mode) ^ e->invert.mode)
++			return 0;
++	}
++	if (e->match.spi) {
++		if ((e->spi != x->id.spi) ^ e->invert.spi)
++			return 0;
++	}
++	if (e->match.reqid) {
++		if ((e->reqid != x->props.reqid) ^ e->invert.reqid)
++			return 0;
++	}
++	return 1;
++}
++
++static int match(const struct sk_buff *skb,
++                 const struct net_device *in,
++                 const struct net_device *out,
++                 const void *matchinfo, int offset, int *hotdrop)
++{
++	const struct ipt_secpath_info *info = matchinfo;
++	struct sec_path *sp = skb->sp;
++	unsigned int i;
++	int strict = info->flags & MATCH_PATH;
++
++	if (sp == NULL)
++		return 0;
++
++	if (strict && info->len != sp->len)
++		return 0;
++	
++	for (i = 0; i < sp->len; i++) {
++		if (match_secpath(sp->x[i].xvec, &info->path[strict ? i : 0])) {
++			if (!strict)
++				return 1;
++		} else if (strict)
++			return 0;
++	}
++
++	return strict ? 1 : 0;
++}
++
++static int checkentry(const char *tablename, const struct ipt_ip *ip,
++		      void *matchinfo, unsigned int matchsize,
++		      unsigned int hook_mask)
++{
++	if (matchsize != IPT_ALIGN(sizeof(struct ipt_secpath_info))) {
++		printk(KERN_ERR "ipt_secpath: matchsize %u != %u.\n",
++		       matchsize, IPT_ALIGN(sizeof(struct ipt_secpath_info)));
++		return 0;
++	}
++
++	return 1;
++}
++
++static struct ipt_match secpath_match = {
++	.name		= "secpath",
++	.match		= &match,
++	.checkentry	= &checkentry,
++	.me		= THIS_MODULE,
++};
++
++static int __init init(void)
++{
++	return ipt_register_match(&secpath_match);
++}
++
++static void __exit fini(void)
++{
++	ipt_unregister_match(&secpath_match);
++
++}
++
++module_init(init);
++module_exit(fini);
diff -urN a/patch-o-matic_2.5/extra/secpath.patch.help b/patch-o-matic_2.5/extra/secpath.patch.help
--- a/patch-o-matic_2.5/extra/secpath.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic_2.5/extra/secpath.patch.help	2003-08-26 17:47:51.000000000 +0200
@@ -0,0 +1,57 @@
+uthor: Patrick McHardy <kaber@trash.net>
+Status: Experimental
+
+This patch adds a new match 'secpath' which is used to match attributes of the
+secpath of a decapsulated packet. The secpath describes a packets path through
+the (ipsec) transformers during decapsulation.
+
+Options:
+
+	[!] --reqid reqid               Match reqid
+	[!] --spi spi                   Match SPI
+	[!] --proto proto               Match protocol (ah/esp/ipcomp)
+	[!] --mode mode                 Match mode (transport/tunnel)
+	[!] --local addr/mask           Match local tunnel endpoint
+	[!] --remote addr/mask          Match remote tunnel endpoint
+	  --path                        Match path instead of single element at
+	                                any position
+	  --next                        Begin next element in path
+
+
+
+Examples:
+
+	# match everything coming out of an esp tunnel from 
+	# 192.168.0.0/24 to 192.168.0.1
+
+	iptables .. -m secpath --proto esp \
+			       --mode tunnel \
+			       --local 192.168.0.1 \
+			       --remote 192.168.0.0/24
+	
+
+	# match all tcp packets coming out of a tunnel from 192.168.0.0/24 
+	# to 192.168.0.1 which looks like this:
+	# <ip> <ah> <esp> <ip>
+
+	iptables .. -p tcp -m secpath --path \
+				      --proto ah \
+				      --mode transport \
+				      --next \
+				      --proto esp \
+				      --mode tunnel \
+				      --local 192.168.0.1 \
+				      --remote 192.168.0.0/24
+
+
+	# accept everything coming from a specific tunnel. The policy is
+	# given like this:
+
+	spdadd 192.168.0.23/32 192.168.0.1/32 any -P in
+		esp/tunnel/192.168.0.23-192.168.0.1/unique:100
+		ah/transport//unique:100;
+
+	# the iptables rule:
+
+	iptables .. -m secpath --reqid 100 ..
+
diff -urN a/userspace/extensions/libipt_secpath.c b/userspace/extensions/libipt_secpath.c
--- a/userspace/extensions/libipt_secpath.c	1970-01-01 01:00:00.000000000 +0100
+++ b/userspace/extensions/libipt_secpath.c	2003-08-26 17:45:50.000000000 +0200
@@ -0,0 +1,352 @@
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <syslog.h>
+#include <getopt.h>
+#include <netdb.h>
+#include <errno.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <iptables.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_secpath.h>
+
+static void help(void)
+{
+	printf(
+"secpath v%s options:\n"
+"[!] --reqid reqid		Match reqid\n"
+"[!] --spi spi			Match SPI\n"
+"[!] --proto proto		Match protocol (ah/esp/ipcomp)\n"
+"[!] --mode mode 		Match mode (transport/tunnel)\n"
+"[!] --local addr/mask		Match local tunnel endpoint\n"
+"[!] --remote addr/mask		Match remote tunnel endpoint\n"
+"  --path 			Match path instead of single element at\n"
+"				any position\n"
+"  --next 			Begin next element in path\n",
+	IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{
+		.name		= "reqid",
+		.has_arg	= 1,
+		.flag		= 0,
+		.val		= '1',
+	},
+	{
+		.name		= "spi",
+		.has_arg	= 1,
+		.flag		= 0,
+		.val		= '2'
+	},
+	{
+		.name		= "local",
+		.has_arg	= 1,
+		.flag		= 0,
+		.val		= '3'
+	},
+	{
+		.name		= "remote",
+		.has_arg	= 1,
+		.flag		= 0,
+		.val		= '4'
+	},
+	{
+		.name		= "proto",
+		.has_arg	= 1,
+		.flag		= 0,
+		.val		= '5'
+	},
+	{
+		.name		= "mode",
+		.has_arg	= 1,
+		.flag		= 0,
+		.val		= '6'
+	},
+	{
+		.name		= "path",
+		.has_arg	= 0,
+		.flag		= 0,
+		.val		= '7'
+	},
+	{
+		.name		= "next",
+		.has_arg	= 0,
+		.flag		= 0,
+		.val		= '8'
+	},
+	{ 0 }
+};
+
+static void init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+	*nfcache |= NFC_UNKNOWN;
+}
+
+static int parse_mode(char *s)
+{
+	if (strcmp(s, "transport") == 0)
+		return SECPATH_MODE_TRANSPORT;
+	if (strcmp(s, "tunnel") == 0)
+		return SECPATH_MODE_TUNNEL;
+	return -EINVAL;
+}
+
+static int parse(int c, char **argv, int invert, unsigned int *i,
+                 const struct ipt_entry *entry,
+                 unsigned int *nfcache,
+                 struct ipt_entry_match **match)
+{
+	struct ipt_secpath_info *info = (void *)(*match)->data;
+	struct ipt_secpath_elem *e = &info->path[*i];
+	struct in_addr *addr = NULL, mask;
+	struct protoent *p;
+	unsigned int naddr = 0;
+	int mode, proto;
+
+	check_inverse(optarg, &invert, &optind, 0);
+
+	switch (c) {
+	case '1':
+		if (e->match.reqid)
+			exit_error(PARAMETER_PROBLEM,
+			           "Can't specify --reqid twice");
+
+		e->match.reqid = 1;
+		e->invert.reqid = invert;
+		e->reqid = strtol(argv[optind-1], NULL, 10);
+		break;
+	case '2':
+		if (e->match.spi)
+			exit_error(PARAMETER_PROBLEM,
+			           "Can't specify --spi twice");
+		
+		e->match.spi = 1;
+		e->invert.spi = invert;
+		e->spi = strtol(argv[optind-1], NULL, 0x10);
+		break;
+	case '3':
+		if (e->match.daddr)
+			exit_error(PARAMETER_PROBLEM,
+			           "Can't specify --local twice");
+		
+		parse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
+		if (naddr > 1)
+			exit_error(PARAMETER_PROBLEM,
+			           "Multiple IP addresses are not allowed");
+
+		e->match.daddr = 1;
+		e->invert.daddr = invert;
+		e->daddr = addr[0].s_addr;
+		e->dmask = mask.s_addr;
+		break;
+	case '4':
+		if (e->match.saddr)
+			exit_error(PARAMETER_PROBLEM,
+			           "Can't specify --remote twice");
+
+		parse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
+		if (naddr > 1)
+			exit_error(PARAMETER_PROBLEM,
+			           "Multiple IP addresses are not allowed");
+
+		e->match.saddr = 1;
+		e->invert.saddr = invert;
+		e->saddr = addr[0].s_addr;
+		e->smask = mask.s_addr;
+                break;
+	case '5':
+		if (e->match.proto)
+			exit_error(PARAMETER_PROBLEM,
+			           "Can't specify --proto twice");
+
+		p = getprotobyname(argv[optind-1]);
+		if (p != NULL)
+			proto = p->p_proto;
+		else if (!(proto = atoi(argv[optind-1])))
+			exit_error(PARAMETER_PROBLEM,
+			           "Unknown protocol `%s'\n",
+			           argv[optind-1]);
+
+		e->match.proto = 1;
+		e->invert.proto = invert;
+		e->proto = proto;
+		break;
+	case '6':
+		if (e->match.mode)
+			exit_error(PARAMETER_PROBLEM,
+			           "Can't specify --mode twice");
+		
+		mode = parse_mode(argv[optind-1]);
+		if (mode < 0)
+			exit_error(PARAMETER_PROBLEM,
+			           "Unknown mode `%s'\n",
+			           argv[optind-1]);
+
+		e->match.mode = 1;
+		e->invert.mode = invert;
+		e->mode = mode;
+		break;
+	case '7':
+		if (info->flags & MATCH_PATH)
+			exit_error(PARAMETER_PROBLEM,
+			           "Can't specify --path twice");
+
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "Can't invert `--path' option");
+
+		info->flags |= MATCH_PATH;
+		break;
+	case '8':
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "Can't invert `--next' option");
+
+		if (++(*i) == SECPATH_MAX_DEPTH)
+			exit_error(PARAMETER_PROBLEM,
+			           "Maximum path depth reached");
+
+		break;
+	default:
+		return 0;
+	}
+
+	info->len = *i + 1;
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	return;
+}
+
+static void print_proto(char *prefix, u_int8_t proto, int numeric)
+{
+	struct protoent *p = NULL;
+
+	if (!numeric)
+		p = getprotobynumber(proto);
+	if (p == NULL)
+		printf("%sproto %u ", prefix, proto);
+	else
+		printf("%sproto %s ", prefix, p->p_name);
+}
+
+static void print_mode(char *prefix, u_int8_t mode, int numeric)
+{
+	printf("%smode ", prefix);
+
+	switch (mode) {
+	case SECPATH_MODE_TRANSPORT:
+		printf("transport ");
+		break;
+	case SECPATH_MODE_TUNNEL:
+		printf("tunnel ");
+		break;
+	default:
+		printf("??? ");
+		break;
+	}
+}
+
+#define PRINT_INVERT(x)		\
+do {				\
+	if (x)			\
+		printf("! ");	\
+} while(0)
+
+static void print_entry(char *prefix, const struct ipt_secpath_elem *e,
+                        int numeric)
+{
+	if (e->match.reqid) {
+		PRINT_INVERT(e->invert.reqid);
+		printf("%sreqid %u ", prefix, e->reqid);
+	}
+	if (e->match.spi) {
+		PRINT_INVERT(e->invert.spi);
+		printf("%sspi 0x%x ", prefix, e->spi);
+	}
+	if (e->match.proto) {
+		PRINT_INVERT(e->invert.proto);
+		print_proto(prefix, e->proto, numeric);
+	}
+	if (e->match.mode) {
+		PRINT_INVERT(e->invert.mode);
+		print_mode(prefix, e->mode, numeric);
+	}
+	if (e->match.daddr) {
+		PRINT_INVERT(e->invert.daddr);
+		printf("%slocal %s%s ", prefix,
+		       addr_to_dotted((struct in_addr *)&e->daddr),
+		       mask_to_dotted((struct in_addr *)&e->dmask));
+	}
+	if (e->match.saddr) {
+		PRINT_INVERT(e->invert.saddr);
+		printf("%sremote %s%s ", prefix,
+		       addr_to_dotted((struct in_addr *)&e->saddr),
+		       mask_to_dotted((struct in_addr *)&e->smask));
+	}
+}
+
+static void print(const struct ipt_ip *ip,
+                  const struct ipt_entry_match *match,
+		  int numeric)
+{
+	const struct ipt_secpath_info *info = (void *)match->data;
+	unsigned int i;
+
+	printf ("secpath match ");
+	if (info->flags & MATCH_PATH)
+		printf("path ");
+
+	for (i = 0; i < info->len; i++) {
+		if (info->len > 1)
+			printf("[%u] ", i);
+		print_entry("", &info->path[i], numeric);
+	}
+
+	printf("\n");
+}
+
+static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	const struct ipt_secpath_info *info = (void *)match->data;
+	unsigned int i;
+
+	if (info->flags & MATCH_PATH)
+		printf("--path ");
+
+	for (i = 0; i < info->len; i++) {
+		print_entry("--", &info->path[i], 0);
+		if (i + 1 < info->len)
+			printf("--next ");
+	}
+
+	printf("\n");
+}
+
+struct iptables_match secpath =
+{
+	NULL,
+	"secpath",
+	IPTABLES_VERSION,
+	IPT_ALIGN(sizeof(struct ipt_secpath_info)),
+	IPT_ALIGN(sizeof(struct ipt_secpath_info)),
+	&help,
+	&init,
+	&parse,
+	&final_check,
+	&print,
+	&save,
+	opts
+};
+
+void _init(void)
+{
+	register_match(&secpath);
+}
diff -urN a/userspace/extensions/.secpath-test b/userspace/extensions/.secpath-test
--- a/userspace/extensions/.secpath-test	1970-01-01 01:00:00.000000000 +0100
+++ b/userspace/extensions/.secpath-test	2003-08-26 17:45:50.000000000 +0200
@@ -0,0 +1,3 @@
+#!/bin/sh
+# True if secpath match patch is applied.
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_secpath.h ] && echo secpath

--------------050508050207000300090401--
