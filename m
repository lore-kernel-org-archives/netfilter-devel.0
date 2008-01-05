From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 18/21] libxt_mark match, revision 1
Date: Sat, 5 Jan 2008 15:50:12 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801051549590.14194@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801041525100.8731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48624 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbYAEOuN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:50:13 -0500
In-Reply-To: <Pine.LNX.4.64.0801041525100.8731@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Introduce libxt_mark match revision 1 support.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libxt_mark.c           |  140 ++++++++++++++++++++++++++++++--------
 include/linux/netfilter/xt_mark.h |    7 +
 2 files changed, 118 insertions(+), 29 deletions(-)

Index: iptables-modules/extensions/libxt_mark.c
===================================================================
--- iptables-modules.orig/extensions/libxt_mark.c
+++ iptables-modules/extensions/libxt_mark.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add NFMARK matching support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -6,24 +7,53 @@
 #include <getopt.h>
 
 #include <xtables.h>
-/* For 64bit kernel / 32bit userspace */
-#include "../include/linux/netfilter/xt_mark.h"
+#include <linux/netfilter/xt_mark.h>
 
-/* Function which prints out usage message. */
-static void mark_help(void)
+enum {
+	F_MARK = 1 << 0,
+};
+
+static void mark_mt_help(void)
 {
 	printf(
-"MARK match v%s options:\n"
-"[!] --mark value[/mask]         Match nfmark value with optional mask\n"
-"\n",
-IPTABLES_VERSION);
+"mark match options:\n"
+"[!] --mark value[/mask]    Match nfmark value with optional mask\n"
+"\n");
 }
 
-static const struct option mark_opts[] = {
-	{ "mark", 1, NULL, '1' },
-	{ }
+static const struct option mark_mt_opts[] = {
+	{.name = "mark", .has_arg = true, .val = '1'},
+	{},
 };
 
+static int mark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
+                         const void *entry, struct xt_entry_match **match)
+{
+	struct xt_mark_mtinfo1 *info = (void *)(*match)->data;
+	unsigned int mark, mask = ~0U;
+	char *end;
+
+	switch (c) {
+	case '1': /* --mark */
+		param_act(P_ONLY_ONCE, "mark", "--mark", *flags & F_MARK);
+		if (!strtonum(optarg, &end, &mark, 0, ~0U))
+			param_act(P_BAD_VALUE, "mark", "--mark", optarg);
+		if (*end == '/')
+			if (!strtonum(end + 1, &end, &mask, 0, ~0U))
+				param_act(P_BAD_VALUE, "mark", "--mark", optarg);
+		if (*end != '\0')
+			param_act(P_BAD_VALUE, "mark", "--mark", optarg);
+
+		if (invert)
+			info->invert = true;
+		info->mark = mark;
+		info->mask = mask;
+		*flags    |= F_MARK;
+		return true;
+	}
+	return false;
+}
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -54,21 +84,30 @@ mark_parse(int c, char **argv, int inver
 	return 1;
 }
 
-static void
-print_mark(unsigned long mark, unsigned long mask, int numeric)
+static void print_mark(unsigned int mark, unsigned int mask)
 {
-	if(mask != 0xffffffff)
-		printf("0x%lx/0x%lx ", mark, mask);
+	if (mask != 0xffffffffU)
+		printf("0x%x/0x%x ", mark, mask);
 	else
-		printf("0x%lx ", mark);
+		printf("0x%x ", mark);
 }
 
-/* Final check; must have specified --mark. */
-static void mark_check(unsigned int flags)
+static void mark_mt_check(unsigned int flags)
 {
-	if (!flags)
+	if (flags == 0)
 		exit_error(PARAMETER_PROBLEM,
-			   "MARK match: You must specify `--mark'");
+			   "mark match: The --mark option is required");
+}
+
+static void
+mark_mt_print(const void *ip, const struct xt_entry_match *match, int numeric)
+{
+	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
+
+	printf("mark match ");
+	if (info->invert)
+		printf("!");
+	print_mark(info->mark, info->mask);
 }
 
 /* Prints out the matchinfo. */
@@ -82,7 +121,18 @@ mark_print(const void *ip, const struct 
 	if (info->invert)
 		printf("!");
 	
-	print_mark(info->mark, info->mask, numeric);
+	print_mark(info->mark, info->mask);
+}
+
+static void mark_mt_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
+
+	if (info->invert)
+		printf("!");
+
+	printf("--mark ");
+	print_mark(info->mark, info->mask);
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
@@ -95,39 +145,73 @@ mark_save(const void *ip, const struct x
 		printf("! ");
 	
 	printf("--mark ");
-	print_mark(info->mark, info->mask, 0);
+	print_mark(info->mark, info->mask);
 }
 
 static struct xtables_match mark_match = {
 	.family		= AF_INET,
 	.name		= "mark",
+	.revision	= 0,
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_mark_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_info)),
-	.help		= mark_help,
+	.help		= mark_mt_help,
 	.parse		= mark_parse,
-	.final_check	= mark_check,
+	.final_check	= mark_mt_check,
 	.print		= mark_print,
 	.save		= mark_save,
-	.extra_opts	= mark_opts,
+	.extra_opts	= mark_mt_opts,
 };
 
 static struct xtables_match mark_match6 = {
 	.family		= AF_INET6,
 	.name		= "mark",
+	.revision	= 0,
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_mark_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_info)),
-	.help		= mark_help,
+	.help		= mark_mt_help,
 	.parse		= mark_parse,
-	.final_check	= mark_check,
+	.final_check	= mark_mt_check,
 	.print		= mark_print,
 	.save		= mark_save,
-	.extra_opts	= mark_opts,
+	.extra_opts	= mark_mt_opts,
+};
+
+static struct xtables_match mark_mt_reg = {
+	.version        = IPTABLES_VERSION,
+	.name           = "mark",
+	.revision       = 1,
+	.family         = AF_INET6,
+	.size           = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
+	.userspacesize  = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
+	.help           = mark_mt_help,
+	.parse          = mark_mt_parse,
+	.final_check    = mark_mt_check,
+	.print          = mark_mt_print,
+	.save           = mark_mt_save,
+	.extra_opts     = mark_mt_opts,
+};
+
+static struct xtables_match mark_mt6_reg = {
+	.version        = IPTABLES_VERSION,
+	.name           = "mark",
+	.revision       = 1,
+	.family         = AF_INET6,
+	.size           = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
+	.userspacesize  = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
+	.help           = mark_mt_help,
+	.parse          = mark_mt_parse,
+	.final_check    = mark_mt_check,
+	.print          = mark_mt_print,
+	.save           = mark_mt_save,
+	.extra_opts     = mark_mt_opts,
 };
 
 void _init(void)
 {
 	xtables_register_match(&mark_match);
 	xtables_register_match(&mark_match6);
+	xtables_register_match(&mark_mt_reg);
+	xtables_register_match(&mark_mt6_reg);
 }
Index: iptables-modules/include/linux/netfilter/xt_mark.h
===================================================================
--- iptables-modules.orig/include/linux/netfilter/xt_mark.h
+++ iptables-modules/include/linux/netfilter/xt_mark.h
@@ -2,7 +2,12 @@
 #define _XT_MARK_H
 
 struct xt_mark_info {
-	unsigned long mark, mask;
+    unsigned long mark, mask;
+    u_int8_t invert;
+};
+
+struct xt_mark_mtinfo1 {
+	u_int32_t mark, mask;
 	u_int8_t invert;
 };
 
