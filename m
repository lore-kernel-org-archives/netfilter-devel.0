From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCHv2 iptables] Address type match: limited to incoming or outgoing interface
Date: Wed, 24 Oct 2007 16:21:31 +0200
Message-ID: <1193235691307-git-send-email-panther@balabit.hu>
References: <11932356911253-git-send-email-panther@balabit.hu>
 <1193235691233-git-send-email-panther@balabit.hu>
 <1193235691956-git-send-email-panther@balabit.hu>
Cc: netfilter-devel@vger.kernel.org,
	Laszlo Attila Toth <panther@balabit.hu>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:51471 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbXJXOVh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:21:37 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 76EBAC119E
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Oct 2007 16:21:36 +0200 (CEST)
In-Reply-To: <1193235691956-git-send-email-panther@balabit.hu>
Message-Id: <20071024-154635-1193233595.panther@balabit.hu>
In-Reply-To: <20071024-160736-1193234856.panther@balabit.hu>
References: <20071024-160736-1193234856.panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Address type checking can be limited to the incoming or outgoing interface
depending on the current chain if it is not the FORWARD chain.

Older version (revision 0) of address type match is not supported.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
extensions/libipt_addrtype.c                |   74 +++++++++++++++++-----------
 extensions/libipt_addrtype.man              |   11 ++++
 include/linux/netfilter_ipv4/ipt_addrtype.h |   15 +++++
 3 files changed, 70 insertions(+), 30 deletions(-)

Index: include/linux/netfilter_ipv4/ipt_addrtype.h
===================================================================
--- include/linux/netfilter_ipv4/ipt_addrtype.h	(revision 7083)
+++ include/linux/netfilter_ipv4/ipt_addrtype.h	(working copy)
@@ -1,9 +1,22 @@
 #ifndef _IPT_ADDRTYPE_H
 #define _IPT_ADDRTYPE_H
 
-struct ipt_addrtype_info {
+enum
+{
+	IPT_ADDRTYPE_INVERT_SOURCE = 0x0001,
+	IPT_ADDRTYPE_INVERT_DEST   = 0x0002,
+	IPT_ADDRTYPE_LIMIT_IFACE   = 0x0004,
+};
+
+struct ipt_addrtype_info_v1 {
 	u_int16_t	source;		/* source-type mask */
 	u_int16_t	dest;		/* dest-type mask */
+	u_int32_t       flags;
+};
+
+struct ipt_addrtype_info_v0 {
+	u_int16_t	source;		/* source-type mask */
+	u_int16_t	dest;		/* dest-type mask */
 	u_int32_t	invert_source;
 	u_int32_t	invert_dest;
 };
Index: extensions/libipt_addrtype.c
===================================================================
--- extensions/libipt_addrtype.c	(revision 7083)
+++ extensions/libipt_addrtype.c	(working copy)
@@ -42,6 +42,7 @@
 "Address type match v%s options:\n"
 " [!] --src-type type[,...]      Match source address type\n"
 " [!] --dst-type type[,...]      Match destination address type\n"
+"     --limit-iface              Match on the packet's interface only\n"
 "\n"
 "Valid types:           \n"
 , IPTABLES_VERSION);
@@ -49,7 +50,7 @@
 }
 
 static int
-parse_type(const char *name, size_t strlen, u_int16_t *mask)
+addrtype_parse_type(const char *name, size_t strlen, u_int16_t *mask)
 {
 	int i;
 
@@ -63,52 +64,60 @@
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
 	
 #define IPT_ADDRTYPE_OPT_SRCTYPE	0x1
 #define IPT_ADDRTYPE_OPT_DSTTYPE	0x2
+#define IPT_ADDRTYPE_OPT_LIMIT_IFACE     0x4
 
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
+		if (*flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify limit-iface twice");
+		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE;
+		*flags |= IPT_ADDRTYPE_OPT_LIMIT_IFACE;
+		break;
 	default:
 		return 0;
 	}
@@ -122,8 +131,8 @@
 		exit_error(PARAMETER_PROBLEM,
 			   "addrtype: you must specify --src-type or --dst-type");
 }
-
-static void print_types(u_int16_t mask)
+ 
+static void addrtype_print_types(u_int16_t mask)
 {
 	const char *sep = "";
 	int i;
@@ -140,54 +149,62 @@
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
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE) {
+		printf("limit-iface ");
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
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE) {
+		printf("--limit-iface ");
+	}
 }
 
 static const struct option addrtype_opts[] = {
 	{ "src-type", 1, NULL, '1' },
 	{ "dst-type", 1, NULL, '2' },
+	{ "limit-iface", 0, NULL, '3' },
 	{ }
 };
 
 static struct iptables_match addrtype_match = {
 	.name 		= "addrtype",
 	.version 	= IPTABLES_VERSION,
-	.size 		= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
-	.userspacesize 	= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
+	.revision	= 1,
+	.size 		= IPT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
+	.userspacesize 	= IPT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
 	.help 		= addrtype_help,
 	.parse 		= addrtype_parse,
 	.final_check 	= addrtype_check,
@@ -196,7 +213,6 @@
 	.extra_opts 	= addrtype_opts,
 };
 
-
 void _init(void) 
 {
 	register_match(&addrtype_match);
Index: extensions/libipt_addrtype.man
===================================================================
--- extensions/libipt_addrtype.man	(revision 7083)
+++ extensions/libipt_addrtype.man	(working copy)
@@ -35,3 +35,14 @@
 .TP
 .BI "--dst-type " "type"
 Matches if the destination address is of given type
+.TP
+.BI "--limit-iface"
+The address type checing can be limited to the interface the packet is coming in in the
+.B PREROUTING
+and
+.B INPUT
+or going out in the
+.B OUTPUT
+and
+.B POSTROUTING
+chains and user-defined chains which are only called from those chains.
