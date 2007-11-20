From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCHv5 iptables] Address type match: limited to incoming or outgoing interface
Date: Tue, 20 Nov 2007 09:00:44 +0100
Message-ID: <11955456461226-git-send-email-panther@balabit.hu>
References: <11955456442652-git-send-email-panther@balabit.hu>
 <11955456451525-git-send-email-panther@balabit.hu>
 <11955456453362-git-send-email-panther@balabit.hu>
Cc: netfilter-devel@vger.kernel.org,
	Laszlo Attila Toth <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:52292 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506AbXKTIAv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Nov 2007 03:00:51 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 0E182C154B
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Nov 2007 09:00:50 +0100 (CET)
In-Reply-To: <11955456453362-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Address type checking can be limited to the incoming or outgoing interface
depending on the current chain. In the FORWARD chain only one of them is
allowed at the same time.

Only revision one is supported.

The man page is updated to print the address types in separate sections
instead of a single paragraph.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 extensions/libipt_addrtype.c                |  102 +++++++++++++++++++---------
 extensions/libipt_addrtype.man              |   35 +++++++++
 include/linux/netfilter_ipv4/ipt_addrtype.h |   17 ++++
 3 files changed, 122 insertions(+), 32 deletions(-)

Index: include/linux/netfilter_ipv4/ipt_addrtype.h
===================================================================
--- include/linux/netfilter_ipv4/ipt_addrtype.h	(revision 7090)
+++ include/linux/netfilter_ipv4/ipt_addrtype.h	(working copy)
@@ -1,6 +1,22 @@
 #ifndef _IPT_ADDRTYPE_H
 #define _IPT_ADDRTYPE_H
 
+enum
+{
+	IPT_ADDRTYPE_INVERT_SOURCE	= 0x0001,
+	IPT_ADDRTYPE_INVERT_DEST	= 0x0002,
+	IPT_ADDRTYPE_LIMIT_IFACE_IN	= 0x0004,
+	IPT_ADDRTYPE_LIMIT_IFACE_OUT	= 0x0008,
+};
+
+struct ipt_addrtype_info_v1 {
+	u_int16_t	source;		/* source-type mask */
+	u_int16_t	dest;		/* dest-type mask */
+	u_int32_t	flags;
+};
+
+
+/* revision 0 */
 struct ipt_addrtype_info {
 	u_int16_t	source;		/* source-type mask */
 	u_int16_t	dest;		/* dest-type mask */
@@ -8,4 +24,5 @@
 	u_int32_t	invert_dest;
 };
 
+
 #endif
Index: extensions/libipt_addrtype.c
===================================================================
--- extensions/libipt_addrtype.c	(revision 7090)
+++ extensions/libipt_addrtype.c	(working copy)
@@ -42,6 +42,8 @@
 "Address type match v%s options:\n"
 " [!] --src-type type[,...]      Match source address type\n"
 " [!] --dst-type type[,...]      Match destination address type\n"
+"     --limit-iface-in           Match only on the packet's incoming device\n"
+"     --limit-iface-out          Match only on the packet's incoming device\n"
 "\n"
 "Valid types:           \n"
 , IPTABLES_VERSION);
@@ -49,7 +51,7 @@
 }
 
 static int
-parse_type(const char *name, size_t strlen, u_int16_t *mask)
+addrtype_parse_type(const char *name, size_t strlen, u_int16_t *mask)
 {
 	int i;
 
@@ -63,52 +65,68 @@
 	return 0;
 }
 
-static void parse_types(const char *arg, u_int16_t *mask)
+static void addrtype_parse_types(const char *arg, u_int16_t *mask)
 {
 	const char *comma;
 
 	while ((comma = strchr(arg, ',')) != NULL) {
-		if (comma == arg || !parse_type(arg, comma-arg, mask))
+		if (comma == arg || !addrtype_parse_type(arg, comma-arg, mask))
 			exit_error(PARAMETER_PROBLEM,
 			           "addrtype: bad type `%s'", arg);
 		arg = comma + 1;
 	}
 
-	if (strlen(arg) == 0 || !parse_type(arg, strlen(arg), mask))
+	if (strlen(arg) == 0 || !addrtype_parse_type(arg, strlen(arg), mask))
 		exit_error(PARAMETER_PROBLEM, "addrtype: bad type `%s'", arg);
 }
 	
-#define IPT_ADDRTYPE_OPT_SRCTYPE	0x1
-#define IPT_ADDRTYPE_OPT_DSTTYPE	0x2
+#define IPT_ADDRTYPE_OPT_SRCTYPE		0x1
+#define IPT_ADDRTYPE_OPT_DSTTYPE		0x2
+#define IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN		0x4
+#define IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT	0x8
 
 static int
 addrtype_parse(int c, char **argv, int invert, unsigned int *flags,
                const void *entry, struct xt_entry_match **match)
 {
-	struct ipt_addrtype_info *info =
-		(struct ipt_addrtype_info *) (*match)->data;
+	struct ipt_addrtype_info_v1 *info =
+		(struct ipt_addrtype_info_v1 *) (*match)->data;
 
 	switch (c) {
 	case '1':
-		if (*flags&IPT_ADDRTYPE_OPT_SRCTYPE)
+		if (*flags & IPT_ADDRTYPE_OPT_SRCTYPE)
 			exit_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify src-type twice");
 		check_inverse(optarg, &invert, &optind, 0);
-		parse_types(argv[optind-1], &info->source);
+		addrtype_parse_types(argv[optind-1], &info->source);
 		if (invert)
-			info->invert_source = 1;
+			info->flags |= IPT_ADDRTYPE_INVERT_SOURCE;
 		*flags |= IPT_ADDRTYPE_OPT_SRCTYPE;
 		break;
 	case '2':
-		if (*flags&IPT_ADDRTYPE_OPT_DSTTYPE)
+		if (*flags & IPT_ADDRTYPE_OPT_DSTTYPE)
 			exit_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify dst-type twice");
 		check_inverse(optarg, &invert, &optind, 0);
-		parse_types(argv[optind-1], &info->dest);
+		addrtype_parse_types(argv[optind-1], &info->dest);
 		if (invert)
-			info->invert_dest = 1;
+			info->flags |= IPT_ADDRTYPE_INVERT_DEST;
 		*flags |= IPT_ADDRTYPE_OPT_DSTTYPE;
 		break;
+	case '3':
+		if (*flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify limit-iface-in twice");
+		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_IN;
+		*flags |= IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN;
+		break;
+	case '4':
+		if (*flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify limit-iface-out twice");
+		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_OUT;
+		*flags |= IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT;
+		break;
 	default:
 		return 0;
 	}
@@ -121,9 +139,14 @@
 	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
 		exit_error(PARAMETER_PROBLEM,
 			   "addrtype: you must specify --src-type or --dst-type");
+	if (flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN &&
+	    flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT)
+		exit_error(PARAMETER_PROBLEM,
+			   "addrtype: you can't specify both --limit-iface-in "
+			   "and --limit-iface-out");
 }
-
-static void print_types(u_int16_t mask)
+ 
+static void addrtype_print_types(u_int16_t mask)
 {
 	const char *sep = "";
 	int i;
@@ -140,54 +163,70 @@
 static void addrtype_print(const void *ip, const struct xt_entry_match *match,
                            int numeric)
 {
-	const struct ipt_addrtype_info *info = 
-		(struct ipt_addrtype_info *) match->data;
+	const struct ipt_addrtype_info_v1 *info = 
+		(struct ipt_addrtype_info_v1 *) match->data;
 
 	printf("ADDRTYPE match ");
 	if (info->source) {
 		printf("src-type ");
-		if (info->invert_source)
+		if (info->flags & IPT_ADDRTYPE_INVERT_SOURCE)
 			printf("!");
-		print_types(info->source);
+		addrtype_print_types(info->source);
 	}
 	if (info->dest) {
 		printf("dst-type ");
-		if (info->invert_dest)
+		if (info->flags & IPT_ADDRTYPE_INVERT_DEST)
 			printf("!");
-		print_types(info->dest);
+		addrtype_print_types(info->dest);
 	}
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
+		printf("limit-in ");
+	}
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+		printf("limit-out ");
+	}
 }
 
 static void addrtype_save(const void *ip, const struct xt_entry_match *match)
 {
-	const struct ipt_addrtype_info *info =
-		(struct ipt_addrtype_info *) match->data;
+	const struct ipt_addrtype_info_v1 *info =
+		(struct ipt_addrtype_info_v1 *) match->data;
 
 	if (info->source) {
 		printf("--src-type ");
-		if (info->invert_source)
+		if (info->flags & IPT_ADDRTYPE_INVERT_SOURCE)
 			printf("! ");
-		print_types(info->source);
+		addrtype_print_types(info->source);
 	}
 	if (info->dest) {
 		printf("--dst-type ");
-		if (info->invert_dest)
+		if (info->flags & IPT_ADDRTYPE_INVERT_DEST)
 			printf("! ");
-		print_types(info->dest);
+		addrtype_print_types(info->dest);
 	}
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
+		printf("--limit-iface-in ");
+	}
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+		printf("--limit-iface-out ");
+	}
 }
 
 static const struct option addrtype_opts[] = {
 	{ "src-type", 1, NULL, '1' },
 	{ "dst-type", 1, NULL, '2' },
+	{ "limit-iface-in", 0, NULL, '3' },
+	{ "limit-iface-out", 0, NULL, '4' },
 	{ }
 };
 
-static struct iptables_match addrtype_match = {
+static struct xtables_match addrtype_match = {
+	.family         = AF_INET,
 	.name 		= "addrtype",
 	.version 	= IPTABLES_VERSION,
-	.size 		= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
-	.userspacesize 	= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
+	.revision	= 1,
+	.size 		= XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
+	.userspacesize 	= XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
 	.help 		= addrtype_help,
 	.parse 		= addrtype_parse,
 	.final_check 	= addrtype_check,
@@ -196,7 +235,6 @@
 	.extra_opts 	= addrtype_opts,
 };
 
-
 void _init(void) 
 {
 	register_match(&addrtype_match);
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
