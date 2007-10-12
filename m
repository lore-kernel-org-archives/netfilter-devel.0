From: Laszlo Attila Toth <panther@balabit.hu>
Subject: iptables: address type match limited to incoming interface
Date: Fri, 12 Oct 2007 16:20:44 +0200
Message-ID: <470f82bc.aaQ1PXRsYNEEo8FP%panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:58214 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbXJLOUu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:20:50 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 4BF9EC11A3
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Oct 2007 16:20:48 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

A new parameter is added to limit address type match to the incoming
interface of the packets. The kernel part uses different structure
as ipt_addrtype_info also reveision number is incrased and it is
incompatible with the older versions of addrtype match.

parse_* and print_* functions got addrtype_ prefix.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>

Index: extensions/libipt_addrtype.c
===================================================================
--- extensions/libipt_addrtype.c	(revision 7068)
+++ extensions/libipt_addrtype.c	(working copy)
@@ -42,6 +42,7 @@
 "Address type match v%s options:\n"
 " [!] --src-type type[,...]      Match source address type\n"
 " [!] --dst-type type[,...]      Match destination address type\n"
+"     --limit-iface              Match on the incoming interface only\n"
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
 
@@ -63,23 +64,24 @@
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
@@ -90,25 +92,32 @@
 
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
@@ -146,16 +155,19 @@
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
@@ -165,27 +177,32 @@
 
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
+	.revision	= 1,
 	.size 		= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
 	.userspacesize 	= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
 	.help 		= addrtype_help,
@@ -196,7 +213,6 @@
 	.extra_opts 	= addrtype_opts,
 };
 
-
 void _init(void) 
 {
 	register_match(&addrtype_match);
