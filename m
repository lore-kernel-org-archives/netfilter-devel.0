From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Addrtype match: renaming functions
Date: Wed, 03 Oct 2007 17:49:01 +0200
Message-ID: <4703b9ed.Kwc375N0W4hwnpA7%panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:55210 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbXJCPtH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Oct 2007 11:49:07 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 73D87C1164
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Oct 2007 17:49:05 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

The function names in libipt_addrtype.c makes debugging hard, also I renamed them
prefixed by 'addrtype_'.

Regards,
  Laszlo attila toth

Index: extensions/libipt_addrtype.c
===================================================================
--- extensions/libipt_addrtype.c	(revision 7051)
+++ extensions/libipt_addrtype.c	(working copy)
@@ -28,7 +28,7 @@
 	NULL
 };
 
-static void help_types(void)
+static void addrtype_help_types(void)
 {
 	int i;
 
@@ -36,7 +36,7 @@
 		printf("                                %s\n", rtn_names[i]);
 }
 
-static void help(void) 
+static void addrtype_help(void) 
 {
 	printf(
 "Address type match v%s options:\n"
@@ -45,11 +45,11 @@
 "\n"
 "Valid types:           \n"
 , IPTABLES_VERSION);
-	help_types();
+	addrtype_help_types();
 }
 
 static int
-parse_type(const char *name, size_t strlen, u_int16_t *mask)
+addrtype_parse_type(const char *name, size_t strlen, u_int16_t *mask)
 {
 	int i;
 
@@ -63,25 +63,25 @@
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
 
-static int parse(int c, char **argv, int invert, unsigned int *flags,
+static int addrtype_parse(int c, char **argv, int invert, unsigned int *flags,
 		const void *entry,
 		struct xt_entry_match **match)
 {
@@ -94,7 +94,7 @@
 			exit_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify src-type twice");
 		check_inverse(optarg, &invert, &optind, 0);
-		parse_types(argv[optind-1], &info->source);
+		addrtype_parse_types(argv[optind-1], &info->source);
 		if (invert)
 			info->invert_source = 1;
 		*flags |= IPT_ADDRTYPE_OPT_SRCTYPE;
@@ -104,7 +104,7 @@
 			exit_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify dst-type twice");
 		check_inverse(optarg, &invert, &optind, 0);
-		parse_types(argv[optind-1], &info->dest);
+		addrtype_parse_types(argv[optind-1], &info->dest);
 		if (invert)
 			info->invert_dest = 1;
 		*flags |= IPT_ADDRTYPE_OPT_DSTTYPE;
@@ -116,14 +116,14 @@
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void addrtype_final_check(unsigned int flags)
 {
 	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
 		exit_error(PARAMETER_PROBLEM,
 			   "addrtype: you must specify --src-type or --dst-type");
 }
 
-static void print_types(u_int16_t mask)
+static void addrtype_print_types(u_int16_t mask)
 {
 	const char *sep = "";
 	int i;
@@ -137,7 +137,7 @@
 	printf(" ");
 }
 
-static void print(const void *ip,
+static void addrtype_print(const void *ip,
 		const struct xt_entry_match *match,
 		int numeric)
 {
@@ -149,17 +149,17 @@
 		printf("src-type ");
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
 
-static void save(const void *ip,
+static void addrtype_save(const void *ip,
 		const struct xt_entry_match *match)
 {
 	const struct ipt_addrtype_info *info =
@@ -169,13 +169,13 @@
 		printf("--src-type ");
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
 
@@ -191,11 +191,11 @@
 	.version 	= IPTABLES_VERSION,
 	.size 		= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
 	.userspacesize 	= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
-	.help 		= &help,
-	.parse 		= &parse,
-	.final_check 	= &final_check,
-	.print 		= &print,
-	.save 		= &save,
+	.help 		= &addrtype_help,
+	.parse 		= &addrtype_parse,
+	.final_check 	= &addrtype_final_check,
+	.print 		= &addrtype_print,
+	.save 		= &addrtype_save,
 	.extra_opts 	= opts
 };
 
