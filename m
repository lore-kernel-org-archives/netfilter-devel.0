From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCH] Iptables addrtype match limited to incoming interface
Date: Fri, 05 Oct 2007 18:10:59 +0200
Message-ID: <47066213.tlPJQeiJpbIhMjnH%panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:51385 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759081AbXJEQLF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:11:05 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 2659DC1243
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Oct 2007 18:11:04 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Userspace part of the addrtype extension that limits source and
destination address type check to the incoming interface.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>

Index: include/linux/netfilter_ipv4/ipt_addrtype.h
===================================================================
--- include/linux/netfilter_ipv4/ipt_addrtype.h	(revision 7065)
+++ include/linux/netfilter_ipv4/ipt_addrtype.h	(working copy)
@@ -1,9 +1,24 @@
 #ifndef _IPT_ADDRTYPE_H
 #define _IPT_ADDRTYPE_H
 
+#define IPT_ADDRTYPE_REVISION        0x0001
+
+enum
+{
+	IPT_ADDRTYPE_INVERT_SOURCE = 0x0001,
+	IPT_ADDRTYPE_INVERT_DEST   = 0x0002,
+	IPT_ADDRTYPE_LIMIT_IFACE   = 0x0004,
+};
+
 struct ipt_addrtype_info {
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
--- extensions/libipt_addrtype.c	(revision 7065)
+++ extensions/libipt_addrtype.c	(working copy)
@@ -28,6 +28,10 @@
 	NULL
 };
 
+#ifndef IPT_ADDRTYPE_REVISION
+# define ipt_addrtype_info_v0 ipt_addrtype_info
+#endif /* IPT_ADDRTYPE_REVISION */
+ 
 static void addrtype_help_types(void)
 {
 	int i;
@@ -36,20 +40,36 @@
 		printf("                                %s\n", rtn_names[i]);
 }
 
+#ifdef IPT_ADDRTYPE_REVISION 
 static void addrtype_help(void)
 {
 	printf(
 "Address type match v%s options:\n"
 " [!] --src-type type[,...]      Match source address type\n"
 " [!] --dst-type type[,...]      Match destination address type\n"
+"     --limit-iface              Match on the incoming interface only\n"
 "\n"
 "Valid types:           \n"
 , IPTABLES_VERSION);
 	addrtype_help_types();
 }
 
+#endif /* IPT_ADDTYPE_REVISION */
+
+static void addrtype_help_v0(void)
+{
+	printf(
+"Address type match v%s options:\n"
+" [!] --src-type type[,...]      Match source address type\n"
+" [!] --dst-type type[,...]      Match destination address type\n"
+"\n"
+"Valid types:           \n"
+, IPTABLES_VERSION);
+	addrtype_help_types();
+}
+
 static int
-parse_type(const char *name, size_t strlen, u_int16_t *mask)
+addrtype_parse_type(const char *name, size_t strlen, u_int16_t *mask)
 {
 	int i;
 
@@ -63,24 +83,26 @@
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
 
+#ifdef IPT_ADDRTYPE_REVISION
 static int
 addrtype_parse(int c, char **argv, int invert, unsigned int *flags,
                const void *entry, struct xt_entry_match **match)
@@ -90,21 +112,64 @@
 
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
+			info->flags |= IPT_ADDRTYPE_INVERT_SOURCE;
+		*flags |= IPT_ADDRTYPE_OPT_SRCTYPE;
+		break;
+	case '2':
+		if (*flags & IPT_ADDRTYPE_OPT_DSTTYPE)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify dst-type twice");
+		check_inverse(optarg, &invert, &optind, 0);
+		addrtype_parse_types(argv[optind-1], &info->dest);
+		if (invert)
+			info->flags |= IPT_ADDRTYPE_INVERT_DEST;
+		*flags |= IPT_ADDRTYPE_OPT_DSTTYPE;
+		break;
+	case '3':
+		if (*flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify limit-iface twice");
+		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE;
+		*flags |= IPT_ADDRTYPE_OPT_LIMIT_IFACE;
+		break;
+	default:
+		return 0;
+	}
+	
+	return 1;
+}
+#endif
+
+static int
+addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
+               const void *entry, struct xt_entry_match **match)
+{
+	struct ipt_addrtype_info_v0 *info =
+		(struct ipt_addrtype_info_v0 *) (*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & IPT_ADDRTYPE_OPT_SRCTYPE)
+			exit_error(PARAMETER_PROBLEM,
+			           "addrtype: can't specify src-type twice");
+		check_inverse(optarg, &invert, &optind, 0);
+		addrtype_parse_types(argv[optind-1], &info->source);
+		if (invert)
 			info->invert_source = 1;
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
 			info->invert_dest = 1;
 		*flags |= IPT_ADDRTYPE_OPT_DSTTYPE;
@@ -116,14 +181,23 @@
 	return 1;
 }
 
+#ifdef IPT_ADDRTYPE_REVISION
 static void addrtype_check(unsigned int flags)
 {
 	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
 		exit_error(PARAMETER_PROBLEM,
 			   "addrtype: you must specify --src-type or --dst-type");
 }
+#endif /* IPT_ADDRTYPE_REVISION */
+ 
+static void addrtype_check_v0(unsigned int flags)
+{
+	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
+		exit_error(PARAMETER_PROBLEM,
+			   "addrtype: you must specify --src-type or --dst-type");
+}
 
-static void print_types(u_int16_t mask)
+static void addrtype_print_types(u_int16_t mask)
 {
 	const char *sep = "";
 	int i;
@@ -137,6 +211,7 @@
 	printf(" ");
 }
 
+#ifdef IPT_ADDRTYPE_REVISION 
 static void addrtype_print(const void *ip, const struct xt_entry_match *match,
                            int numeric)
 {
@@ -146,18 +221,44 @@
 	printf("ADDRTYPE match ");
 	if (info->source) {
 		printf("src-type ");
+		if (info->flags & IPT_ADDRTYPE_INVERT_SOURCE)
+			printf("!");
+		addrtype_print_types(info->source);
+	}
+	if (info->dest) {
+		printf("dst-type ");
+		if (info->flags & IPT_ADDRTYPE_INVERT_DEST)
+			printf("!");
+		addrtype_print_types(info->dest);
+	}
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE) {
+		printf("limit-iface ");
+	}
+}
+#endif /* IPT_ADDRTYPE_REVISION */
+
+static void addrtype_print_v0(const void *ip, const struct xt_entry_match *match,
+                           int numeric)
+{
+	const struct ipt_addrtype_info_v0 *info = 
+		(struct ipt_addrtype_info_v0 *) match->data;
+
+	printf("ADDRTYPE match ");
+	if (info->source) {
+		printf("src-type ");
 		if (info->invert_source)
 			printf("!");
-		print_types(info->source);
+		addrtype_print_types(info->source);
 	}
 	if (info->dest) {
 		printf("dst-type ");
 		if (info->invert_dest)
 			printf("!");
-		print_types(info->dest);
+		addrtype_print_types(info->dest);
 	}
 }
 
+#ifdef IPT_ADDRTYPE_REVISION
 static void addrtype_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_addrtype_info *info =
@@ -165,27 +266,60 @@
 
 	if (info->source) {
 		printf("--src-type ");
+		if (info->flags & IPT_ADDRTYPE_INVERT_SOURCE)
+			printf("! ");
+		addrtype_print_types(info->source);
+	}
+	if (info->dest) {
+		printf("--dst-type ");
+		if (info->flags & IPT_ADDRTYPE_INVERT_DEST)
+			printf("! ");
+		addrtype_print_types(info->dest);
+	}
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE) {
+		printf("--limit-iface ");
+	}
+}
+#endif /* IPT_ADDRTYPE_REVISION */
+
+static void addrtype_save_v0(const void *ip, const struct xt_entry_match *match)
+{
+	const struct ipt_addrtype_info_v0 *info =
+		(struct ipt_addrtype_info_v0 *) match->data;
+
+	if (info->source) {
+		printf("--src-type ");
 		if (info->invert_source)
 			printf("! ");
-		print_types(info->source);
+		addrtype_print_types(info->source);
 	}
 	if (info->dest) {
 		printf("--dst-type ");
 		if (info->invert_dest)
 			printf("! ");
-		print_types(info->dest);
+		addrtype_print_types(info->dest);
 	}
 }
 
+
 static const struct option addrtype_opts[] = {
 	{ "src-type", 1, NULL, '1' },
 	{ "dst-type", 1, NULL, '2' },
+	{ "limit-iface", 0, NULL, '3' },
 	{ }
 };
 
+static const struct option addrtype_opts_v0[] = {
+	{ "src-type", 1, NULL, '1' },
+	{ "dst-type", 1, NULL, '2' },
+	{ }
+};
+
+#ifdef IPT_ADDRTYPE_REVISION
 static struct iptables_match addrtype_match = {
 	.name 		= "addrtype",
 	.version 	= IPTABLES_VERSION,
+	.revision	= 1,
 	.size 		= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
 	.userspacesize 	= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
 	.help 		= addrtype_help,
@@ -195,9 +329,27 @@
 	.save 		= addrtype_save,
 	.extra_opts 	= addrtype_opts,
 };
+#endif /* IPT_ADDRTYPE_REVISION */
+ 
+static struct iptables_match addrtype_match_v0 = {
+	.name 		= "addrtype",
+	.version 	= IPTABLES_VERSION,
+	.revision	= 0,
+	.size 		= IPT_ALIGN(sizeof(struct ipt_addrtype_info_v0)),
+	.userspacesize 	= IPT_ALIGN(sizeof(struct ipt_addrtype_info_v0)),
+	.help 		= addrtype_help_v0,
+	.parse 		= addrtype_parse_v0,
+	.final_check 	= addrtype_check_v0,
+	.print 		= addrtype_print_v0,
+	.save 		= addrtype_save_v0,
+	.extra_opts 	= addrtype_opts_v0,
+};
 
 
 void _init(void) 
 {
-	register_match(&addrtype_match);
+#ifdef IPT_ADDRTYPE_REVISION
+ 	register_match(&addrtype_match);
+#endif /* IPT_ADDRTYPE_REVISION */
+ 	register_match(&addrtype_match_v0);
 }
