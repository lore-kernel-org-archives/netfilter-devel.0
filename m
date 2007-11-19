From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCHv4 iptables] Address type match: limited to incoming or outgoing interface. Moved to xtables
Date: Mon, 19 Nov 2007 16:55:48 +0100
Message-ID: <11954877482913-git-send-email-panther@balabit.hu>
References: <11954877483732-git-send-email-panther@balabit.hu>
 <11954877481813-git-send-email-panther@balabit.hu>
 <11954877481145-git-send-email-panther@balabit.hu>
Cc: netfilter-devel@vger.kernel.org,
	Laszlo Attila Toth <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:52365 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbXKSPz5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:55:57 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 070B4C15E2
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Nov 2007 16:55:56 +0100 (CET)
In-Reply-To: <11954877481145-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Address type checking can be limited to the incoming or outgoing interface
depending on the current chain. In the FORWARD chain only one of them is
allowed at the same time.

The match is moved to xtables and only the revision one is supported

The man page is updated to print the address in separate sections insted of
a single paragraph.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 extensions/Makefile                         |    4 
 extensions/libipt_addrtype.c                |  203 -----------------------
 extensions/libipt_addrtype.man              |   35 ++++
 extensions/libxt_addrtype.c                 |  239 ++++++++++++++++++++++++++++
 include/linux/netfilter/xt_addrtype.h       |   18 ++
 include/linux/netfilter_ipv4/ipt_addrtype.h |   11 -
 6 files changed, 294 insertions(+), 216 deletions(-)

Index: include/linux/netfilter/xt_addrtype.h
===================================================================
--- include/linux/netfilter/xt_addrtype.h	(revision 0)
+++ include/linux/netfilter/xt_addrtype.h	(revision 0)
@@ -0,0 +1,18 @@
+#ifndef _XT_ADDRTYPE_H
+#define _XT_ADDRTYPE_H
+
+enum
+{
+	XT_ADDRTYPE_INVERT_SOURCE	= 0x0001,
+	XT_ADDRTYPE_INVERT_DEST		= 0x0002,
+	XT_ADDRTYPE_LIMIT_IFACE_IN	= 0x0004,
+	XT_ADDRTYPE_LIMIT_IFACE_OUT	= 0x0008,
+};
+
+struct xt_addrtype_info {
+	u_int16_t	source;		/* source-type mask */
+	u_int16_t	dest;		/* dest-type mask */
+	u_int32_t	flags;
+};
+
+#endif
Index: include/linux/netfilter_ipv4/ipt_addrtype.h
===================================================================
--- include/linux/netfilter_ipv4/ipt_addrtype.h	(revision 7090)
+++ include/linux/netfilter_ipv4/ipt_addrtype.h	(working copy)
@@ -1,11 +0,0 @@
-#ifndef _IPT_ADDRTYPE_H
-#define _IPT_ADDRTYPE_H
-
-struct ipt_addrtype_info {
-	u_int16_t	source;		/* source-type mask */
-	u_int16_t	dest;		/* dest-type mask */
-	u_int32_t	invert_source;
-	u_int32_t	invert_dest;
-};
-
-#endif
Index: extensions/libipt_addrtype.c
===================================================================
--- extensions/libipt_addrtype.c	(revision 7090)
+++ extensions/libipt_addrtype.c	(working copy)
@@ -1,203 +0,0 @@
-/* Shared library add-on to iptables to add addrtype matching support 
- * 
- * This program is released under the terms of GNU GPL */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <getopt.h>
-#include <iptables.h>
-
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_addrtype.h>
-
-/* from linux/rtnetlink.h, must match order of enumeration */
-static const char *const rtn_names[] = {
-	"UNSPEC",
-	"UNICAST",
-	"LOCAL",
-	"BROADCAST",
-	"ANYCAST",
-	"MULTICAST",
-	"BLACKHOLE",
-	"UNREACHABLE",
-	"PROHIBIT",
-	"THROW",
-	"NAT",
-	"XRESOLVE",
-	NULL
-};
-
-static void addrtype_help_types(void)
-{
-	int i;
-
-	for (i = 0; rtn_names[i]; i++)
-		printf("                                %s\n", rtn_names[i]);
-}
-
-static void addrtype_help(void)
-{
-	printf(
-"Address type match v%s options:\n"
-" [!] --src-type type[,...]      Match source address type\n"
-" [!] --dst-type type[,...]      Match destination address type\n"
-"\n"
-"Valid types:           \n"
-, IPTABLES_VERSION);
-	addrtype_help_types();
-}
-
-static int
-parse_type(const char *name, size_t strlen, u_int16_t *mask)
-{
-	int i;
-
-	for (i = 0; rtn_names[i]; i++)
-		if (strncasecmp(name, rtn_names[i], strlen) == 0) {
-			/* build up bitmask for kernel module */
-			*mask |= (1 << i);
-			return 1;
-		}
-
-	return 0;
-}
-
-static void parse_types(const char *arg, u_int16_t *mask)
-{
-	const char *comma;
-
-	while ((comma = strchr(arg, ',')) != NULL) {
-		if (comma == arg || !parse_type(arg, comma-arg, mask))
-			exit_error(PARAMETER_PROBLEM,
-			           "addrtype: bad type `%s'", arg);
-		arg = comma + 1;
-	}
-
-	if (strlen(arg) == 0 || !parse_type(arg, strlen(arg), mask))
-		exit_error(PARAMETER_PROBLEM, "addrtype: bad type `%s'", arg);
-}
-	
-#define IPT_ADDRTYPE_OPT_SRCTYPE	0x1
-#define IPT_ADDRTYPE_OPT_DSTTYPE	0x2
-
-static int
-addrtype_parse(int c, char **argv, int invert, unsigned int *flags,
-               const void *entry, struct xt_entry_match **match)
-{
-	struct ipt_addrtype_info *info =
-		(struct ipt_addrtype_info *) (*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags&IPT_ADDRTYPE_OPT_SRCTYPE)
-			exit_error(PARAMETER_PROBLEM,
-			           "addrtype: can't specify src-type twice");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_types(argv[optind-1], &info->source);
-		if (invert)
-			info->invert_source = 1;
-		*flags |= IPT_ADDRTYPE_OPT_SRCTYPE;
-		break;
-	case '2':
-		if (*flags&IPT_ADDRTYPE_OPT_DSTTYPE)
-			exit_error(PARAMETER_PROBLEM,
-			           "addrtype: can't specify dst-type twice");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_types(argv[optind-1], &info->dest);
-		if (invert)
-			info->invert_dest = 1;
-		*flags |= IPT_ADDRTYPE_OPT_DSTTYPE;
-		break;
-	default:
-		return 0;
-	}
-	
-	return 1;
-}
-
-static void addrtype_check(unsigned int flags)
-{
-	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
-		exit_error(PARAMETER_PROBLEM,
-			   "addrtype: you must specify --src-type or --dst-type");
-}
-
-static void print_types(u_int16_t mask)
-{
-	const char *sep = "";
-	int i;
-
-	for (i = 0; rtn_names[i]; i++)
-		if (mask & (1 << i)) {
-			printf("%s%s", sep, rtn_names[i]);
-			sep = ",";
-		}
-
-	printf(" ");
-}
-
-static void addrtype_print(const void *ip, const struct xt_entry_match *match,
-                           int numeric)
-{
-	const struct ipt_addrtype_info *info = 
-		(struct ipt_addrtype_info *) match->data;
-
-	printf("ADDRTYPE match ");
-	if (info->source) {
-		printf("src-type ");
-		if (info->invert_source)
-			printf("!");
-		print_types(info->source);
-	}
-	if (info->dest) {
-		printf("dst-type ");
-		if (info->invert_dest)
-			printf("!");
-		print_types(info->dest);
-	}
-}
-
-static void addrtype_save(const void *ip, const struct xt_entry_match *match)
-{
-	const struct ipt_addrtype_info *info =
-		(struct ipt_addrtype_info *) match->data;
-
-	if (info->source) {
-		printf("--src-type ");
-		if (info->invert_source)
-			printf("! ");
-		print_types(info->source);
-	}
-	if (info->dest) {
-		printf("--dst-type ");
-		if (info->invert_dest)
-			printf("! ");
-		print_types(info->dest);
-	}
-}
-
-static const struct option addrtype_opts[] = {
-	{ "src-type", 1, NULL, '1' },
-	{ "dst-type", 1, NULL, '2' },
-	{ }
-};
-
-static struct iptables_match addrtype_match = {
-	.name 		= "addrtype",
-	.version 	= IPTABLES_VERSION,
-	.size 		= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
-	.userspacesize 	= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
-	.help 		= addrtype_help,
-	.parse 		= addrtype_parse,
-	.final_check 	= addrtype_check,
-	.print 		= addrtype_print,
-	.save 		= addrtype_save,
-	.extra_opts 	= addrtype_opts,
-};
-
-
-void _init(void) 
-{
-	register_match(&addrtype_match);
-}
Index: extensions/libxt_addrtype.c
===================================================================
--- extensions/libxt_addrtype.c	(revision 0)
+++ extensions/libxt_addrtype.c	(revision 0)
@@ -0,0 +1,239 @@
+/* Shared library add-on to iptables to add addrtype matching support 
+ * 
+ * This program is released under the terms of GNU GPL */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <xtables.h>
+#include <linux/netfilter/xt_addrtype.h>
+
+/* from linux/rtnetlink.h, must match order of enumeration */
+static const char *const rtn_names[] = {
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
+static void addrtype_help_types(void)
+{
+	int i;
+
+	for (i = 0; rtn_names[i]; i++)
+		printf("                                %s\n", rtn_names[i]);
+}
+
+static void addrtype_help(void)
+{
+	printf(
+"Address type match v%s options:\n"
+" [!] --src-type type[,...]      Match source address type\n"
+" [!] --dst-type type[,...]      Match destination address type\n"
+"     --limit-iface-in           Match only on the packet's incoming device\n"
+"     --limit-iface-out          Match only on the packet's incoming device\n"
+"\n"
+"Valid types:           \n"
+, IPTABLES_VERSION);
+	addrtype_help_types();
+}
+
+static int
+addrtype_parse_type(const char *name, size_t strlen, u_int16_t *mask)
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
+static void addrtype_parse_types(const char *arg, u_int16_t *mask)
+{
+	const char *comma;
+
+	while ((comma = strchr(arg, ',')) != NULL) {
+		if (comma == arg || !addrtype_parse_type(arg, comma-arg, mask))
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: bad type `%s'", arg);
+		arg = comma + 1;
+	}
+
+	if (strlen(arg) == 0 || !addrtype_parse_type(arg, strlen(arg), mask))
+		exit_error(PARAMETER_PROBLEM, "addrtype: bad type `%s'", arg);
+}
+	
+#define XT_ADDRTYPE_OPT_SRCTYPE		0x1
+#define XT_ADDRTYPE_OPT_DSTTYPE		0x2
+#define XT_ADDRTYPE_OPT_LIMIT_IFACE_IN	0x4
+#define XT_ADDRTYPE_OPT_LIMIT_IFACE_OUT	0x8
+
+static int
+addrtype_parse(int c, char **argv, int invert, unsigned int *flags,
+               const void *entry, struct xt_entry_match **match)
+{
+	struct xt_addrtype_info *info =
+		(struct xt_addrtype_info *) (*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & XT_ADDRTYPE_OPT_SRCTYPE)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify src-type twice");
+		check_inverse(optarg, &invert, &optind, 0);
+		addrtype_parse_types(argv[optind-1], &info->source);
+		if (invert)
+			info->flags |= XT_ADDRTYPE_INVERT_SOURCE;
+		*flags |= XT_ADDRTYPE_OPT_SRCTYPE;
+		break;
+	case '2':
+		if (*flags & XT_ADDRTYPE_OPT_DSTTYPE)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify dst-type twice");
+		check_inverse(optarg, &invert, &optind, 0);
+		addrtype_parse_types(argv[optind-1], &info->dest);
+		if (invert)
+			info->flags |= XT_ADDRTYPE_INVERT_DEST;
+		*flags |= XT_ADDRTYPE_OPT_DSTTYPE;
+		break;
+	case '3':
+		if (*flags & XT_ADDRTYPE_OPT_LIMIT_IFACE_IN)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify limit-iface-in twice");
+		info->flags |= XT_ADDRTYPE_LIMIT_IFACE_IN;
+		*flags |= XT_ADDRTYPE_OPT_LIMIT_IFACE_IN;
+		break;
+	case '4':
+		if (*flags & XT_ADDRTYPE_OPT_LIMIT_IFACE_OUT)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify limit-iface-out twice");
+		info->flags |= XT_ADDRTYPE_LIMIT_IFACE_OUT;
+		*flags |= XT_ADDRTYPE_OPT_LIMIT_IFACE_OUT;
+		break;
+	default:
+		return 0;
+	}
+	
+	return 1;
+}
+
+static void addrtype_check(unsigned int flags)
+{
+	if (!(flags & (XT_ADDRTYPE_OPT_SRCTYPE|XT_ADDRTYPE_OPT_DSTTYPE)))
+		exit_error(PARAMETER_PROBLEM,
+			   "addrtype: you must specify --src-type or --dst-type");
+	if (flags & XT_ADDRTYPE_OPT_LIMIT_IFACE_IN &&
+	    flags & XT_ADDRTYPE_OPT_LIMIT_IFACE_OUT)
+		exit_error(PARAMETER_PROBLEM,
+			   "addrtype: you can't specify both --limit-iface-in "
+			   "and --limit-iface-out");
+}
+ 
+static void addrtype_print_types(u_int16_t mask)
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
+static void addrtype_print(const void *ip, const struct xt_entry_match *match,
+                           int numeric)
+{
+	const struct xt_addrtype_info *info = 
+		(struct xt_addrtype_info *) match->data;
+
+	printf("ADDRTYPE match ");
+	if (info->source) {
+		printf("src-type ");
+		if (info->flags & XT_ADDRTYPE_INVERT_SOURCE)
+			printf("!");
+		addrtype_print_types(info->source);
+	}
+	if (info->dest) {
+		printf("dst-type ");
+		if (info->flags & XT_ADDRTYPE_INVERT_DEST)
+			printf("!");
+		addrtype_print_types(info->dest);
+	}
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN) {
+		printf("limit-in ");
+	}
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT) {
+		printf("limit-out ");
+	}
+}
+
+static void addrtype_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_addrtype_info *info =
+		(struct xt_addrtype_info *) match->data;
+
+	if (info->source) {
+		printf("--src-type ");
+		if (info->flags & XT_ADDRTYPE_INVERT_SOURCE)
+			printf("! ");
+		addrtype_print_types(info->source);
+	}
+	if (info->dest) {
+		printf("--dst-type ");
+		if (info->flags & XT_ADDRTYPE_INVERT_DEST)
+			printf("! ");
+		addrtype_print_types(info->dest);
+	}
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN) {
+		printf("--limit-iface-in ");
+	}
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT) {
+		printf("--limit-iface-out ");
+	}
+}
+
+static const struct option addrtype_opts[] = {
+	{ "src-type", 1, NULL, '1' },
+	{ "dst-type", 1, NULL, '2' },
+	{ "limit-iface-in", 0, NULL, '3' },
+	{ "limit-iface-out", 0, NULL, '4' },
+	{ }
+};
+
+static struct xtables_match addrtype_match = {
+	.family         = AF_INET,
+	.name 		= "addrtype",
+	.version 	= IPTABLES_VERSION,
+	.revision	= 1,
+	.size 		= XT_ALIGN(sizeof(struct xt_addrtype_info)),
+	.userspacesize 	= XT_ALIGN(sizeof(struct xt_addrtype_info)),
+	.help 		= addrtype_help,
+	.parse 		= addrtype_parse,
+	.final_check 	= addrtype_check,
+	.print 		= addrtype_print,
+	.save 		= addrtype_save,
+	.extra_opts 	= addrtype_opts,
+};
+
+void _init(void) 
+{
+	xtables_register_match(&addrtype_match);
+}
Index: extensions/Makefile
===================================================================
--- extensions/Makefile	(revision 7090)
+++ extensions/Makefile	(working copy)
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype conntrack ecn icmp iprange owner policy realm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
+PF_EXT_SLIB:=ah conntrack ecn icmp iprange owner policy realm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=ah dst eui64 frag hbh hl icmp6 ipv6header mh owner policy rt HL LOG REJECT
-PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=addrtype connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
 
 PF_EXT_SELINUX_SLIB:=
 PF6_EXT_SELINUX_SLIB:=
Index: extensions/libipt_addrtype.man
===================================================================
--- extensions/libipt_addrtype.man	(revision 7090)
+++ extensions/libipt_addrtype.man	(working copy)
@@ -7,31 +7,66 @@
 .TP
 .BI "UNSPEC"
 an unspecified address (i.e. 0.0.0.0)
+.TP
 .BI "UNICAST"
 an unicast address
+.TP
 .BI "LOCAL"
 a local address
+.TP
 .BI "BROADCAST"
 a broadcast address
+.TP
 .BI "ANYCAST"
 an anycast packet
+.TP
 .BI "MULTICAST"
 a multicast address
+.TP
 .BI "BLACKHOLE"
 a blackhole address
+.TP
 .BI "UNREACHABLE"
 an unreachable address
+.TP
 .BI "PROHIBIT"
 a prohibited address
+.TP
 .BI "THROW"
 FIXME
+.TP
 .BI "NAT"
 FIXME
+.TP
 .BI "XRESOLVE"
 FIXME
 .TP
+Options:
+.TP
 .BI "--src-type " "type"
 Matches if the source address is of given type
 .TP
 .BI "--dst-type " "type"
 Matches if the destination address is of given type
+.TP
+.BI "--limit-iface-in"
+The address type checking can be limited to the interface the packet is coming
+in. This option is only valid in the
+.BR PREROUTING ,
+.B INPUT
+and
+.B FORWARD
+chains. It cannot be specified with the
+.B "--limit-iface-out"
+option.
+.TP
+.BI "--limit-iface-out"
+The address type checiking can be limited to the interface the packet is going
+out. This option is only valid in the
+.BR POSTROUTING ,
+.B OUTPUT
+and
+.B FORWARD
+chains. It cannot be specified with the
+.B --limit-iface-in
+option.
