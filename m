From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/28] libip[6]t_HL: use guided option parser
Date: Tue, 12 Apr 2011 16:23:17 +0200
Message-ID: <1302618224-9449-3-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51082 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab1DLOXs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:23:48 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_HL.c |  111 ++++++++++++++++++-----------------------------
 extensions/libipt_TTL.c |  110 ++++++++++++++++++-----------------------------
 2 files changed, 84 insertions(+), 137 deletions(-)

diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 900564c..254b191 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -4,17 +4,33 @@
  * Based on HW's ttl target
  * This program is distributed under the terms of GNU GPL
  */
-
-#include <getopt.h>
-#include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
 #include <xtables.h>
-
 #include <linux/netfilter_ipv6/ip6t_HL.h>
 
-#define IP6T_HL_USED	1
+enum {
+	O_HL_SET = 0,
+	O_HL_INC,
+	O_HL_DEC,
+	F_HL_SET = 1 << O_HL_SET,
+	F_HL_INC = 1 << O_HL_INC,
+	F_HL_DEC = 1 << O_HL_DEC,
+	F_ANY    = F_HL_SET | F_HL_INC | F_HL_DEC,
+};
+
+#define s struct ip6t_HL_info
+static const struct xt_option_entry HL_opts[] = {
+	{.name = "ttl-set", .type = XTTYPE_UINT8, .id = O_HL_SET,
+	 .excl = F_ANY, .flags = XTOPT_PUT, XTOPT_POINTER(s, hop_limit)},
+	{.name = "ttl-dec", .type = XTTYPE_UINT8, .id = O_HL_DEC,
+	 .excl = F_ANY, .flags = XTOPT_PUT, XTOPT_POINTER(s, hop_limit),
+	 .min = 1},
+	{.name = "ttl-inc", .type = XTTYPE_UINT8, .id = O_HL_INC,
+	 .excl = F_ANY, .flags = XTOPT_PUT, XTOPT_POINTER(s, hop_limit),
+	 .min = 1},
+	XTOPT_TABLEEND,
+};
+#undef s
 
 static void HL_help(void)
 {
@@ -25,63 +41,27 @@ static void HL_help(void)
 "  --hl-inc value		Increment HL by <value 1-255>\n");
 }
 
-static int HL_parse(int c, char **argv, int invert, unsigned int *flags,
-                    const void *entry, struct xt_entry_target **target)
+static void HL_parse(struct xt_option_call *cb)
 {
-	struct ip6t_HL_info *info = (struct ip6t_HL_info *) (*target)->data;
-	unsigned int value;
-
-	if (*flags & IP6T_HL_USED) {
-		xtables_error(PARAMETER_PROBLEM,
-				"Can't specify HL option twice");
+	struct ip6t_HL_info *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_HL_SET:
+		info->mode = IP6T_HL_SET;
+		break;
+	case O_HL_INC:
+		info->mode = IP6T_HL_INC;
+		break;
+	case O_HL_DEC:
+		info->mode = IP6T_HL_DEC;
+		break;
 	}
-
-	if (!optarg) 
-		xtables_error(PARAMETER_PROBLEM,
-				"HL: You must specify a value");
-
-	if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-		xtables_error(PARAMETER_PROBLEM,
-				"HL: unexpected `!'");
-	
-	if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
-		xtables_error(PARAMETER_PROBLEM,
-		           "HL: Expected value between 0 and 255");
-
-	switch (c) {
-
-		case '1':
-			info->mode = IP6T_HL_SET;
-			break;
-
-		case '2':
-			if (value == 0) {
-				xtables_error(PARAMETER_PROBLEM,
-					"HL: decreasing by 0?");
-			}
-
-			info->mode = IP6T_HL_DEC;
-			break;
-
-		case '3':
-			if (value == 0) {
-				xtables_error(PARAMETER_PROBLEM,
-					"HL: increasing by 0?");
-			}
-
-			info->mode = IP6T_HL_INC;
-			break;
-	}
-	
-	info->hop_limit = value;
-	*flags |= IP6T_HL_USED;
-
-	return 1;
 }
 
-static void HL_check(unsigned int flags)
+static void HL_check(struct xt_fcheck_call *cb)
 {
-	if (!(flags & IP6T_HL_USED))
+	if (!(cb->xflags & F_ANY))
 		xtables_error(PARAMETER_PROBLEM,
 				"HL: You must specify an action");
 }
@@ -127,13 +107,6 @@ static void HL_print(const void *ip, const struct xt_entry_target *target,
 	printf(" %u", info->hop_limit);
 }
 
-static const struct option HL_opts[] = {
-	{.name = "hl-set", .has_arg = true, .val = '1'},
-	{.name = "hl-dec", .has_arg = true, .val = '2'},
-	{.name = "hl-inc", .has_arg = true, .val = '3'},
-	XT_GETOPT_TABLEEND,
-};
-
 static struct xtables_target hl_tg6_reg = {
 	.name 		= "HL",
 	.version	= XTABLES_VERSION,
@@ -141,11 +114,11 @@ static struct xtables_target hl_tg6_reg = {
 	.size		= XT_ALIGN(sizeof(struct ip6t_HL_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_HL_info)),
 	.help		= HL_help,
-	.parse		= HL_parse,
-	.final_check	= HL_check,
 	.print		= HL_print,
 	.save		= HL_save,
-	.extra_opts	= HL_opts,
+	.x6_parse	= HL_parse,
+	.x6_fcheck	= HL_check,
+	.x6_options	= HL_opts,
 };
 
 void _init(void)
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index c2518f8..0f81280 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -3,16 +3,33 @@
  *
  * This program is distributed under the terms of GNU GPL
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
-
 #include <linux/netfilter_ipv4/ipt_TTL.h>
 
-#define IPT_TTL_USED	1
+enum {
+	O_TTL_SET = 0,
+	O_TTL_INC,
+	O_TTL_DEC,
+	F_TTL_SET = 1 << O_TTL_SET,
+	F_TTL_INC = 1 << O_TTL_INC,
+	F_TTL_DEC = 1 << O_TTL_DEC,
+	F_ANY     = F_TTL_SET | F_TTL_INC | F_TTL_DEC,
+};
+
+#define s struct ipt_TTL_info
+static const struct xt_option_entry TTL_opts[] = {
+	{.name = "ttl-set", .type = XTTYPE_UINT8, .id = O_TTL_SET,
+	 .excl = F_ANY, .flags = XTOPT_PUT, XTOPT_POINTER(s, ttl)},
+	{.name = "ttl-dec", .type = XTTYPE_UINT8, .id = O_TTL_DEC,
+	 .excl = F_ANY, .flags = XTOPT_PUT, XTOPT_POINTER(s, ttl),
+	 .min = 1},
+	{.name = "ttl-inc", .type = XTTYPE_UINT8, .id = O_TTL_INC,
+	 .excl = F_ANY, .flags = XTOPT_PUT, XTOPT_POINTER(s, ttl),
+	 .min = 1},
+	XTOPT_TABLEEND,
+};
+#undef s
 
 static void TTL_help(void)
 {
@@ -23,63 +40,27 @@ static void TTL_help(void)
 "  --ttl-inc value		Increment TTL by <value 1-255>\n");
 }
 
-static int TTL_parse(int c, char **argv, int invert, unsigned int *flags,
-                     const void *entry, struct xt_entry_target **target)
+static void TTL_parse(struct xt_option_call *cb)
 {
-	struct ipt_TTL_info *info = (struct ipt_TTL_info *) (*target)->data;
-	unsigned int value;
-
-	if (*flags & IPT_TTL_USED) {
-		xtables_error(PARAMETER_PROBLEM,
-				"Can't specify TTL option twice");
-	}
-
-	if (!optarg) 
-		xtables_error(PARAMETER_PROBLEM,
-				"TTL: You must specify a value");
-
-	if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-		xtables_error(PARAMETER_PROBLEM,
-				"TTL: unexpected `!'");
-	
-	if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
-		xtables_error(PARAMETER_PROBLEM,
-		           "TTL: Expected value between 0 and 255");
-
-	switch (c) {
-
-		case '1':
-			info->mode = IPT_TTL_SET;
-			break;
-
-		case '2':
-			if (value == 0) {
-				xtables_error(PARAMETER_PROBLEM,
-					"TTL: decreasing by 0?");
-			}
-
-			info->mode = IPT_TTL_DEC;
-			break;
-
-		case '3':
-			if (value == 0) {
-				xtables_error(PARAMETER_PROBLEM,
-					"TTL: increasing by 0?");
-			}
-
-			info->mode = IPT_TTL_INC;
-			break;
+	struct ipt_TTL_info *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_TTL_SET:
+		info->mode = IPT_TTL_SET;
+		break;
+	case O_TTL_DEC:
+		info->mode = IPT_TTL_DEC;
+		break;
+	case O_TTL_INC:
+		info->mode = IPT_TTL_INC;
+		break;
 	}
-	
-	info->ttl = value;
-	*flags |= IPT_TTL_USED;
-
-	return 1;
 }
 
-static void TTL_check(unsigned int flags)
+static void TTL_check(struct xt_fcheck_call *cb)
 {
-	if (!(flags & IPT_TTL_USED))
+	if (!(cb->xflags & F_ANY))
 		xtables_error(PARAMETER_PROBLEM,
 				"TTL: You must specify an action");
 }
@@ -125,13 +106,6 @@ static void TTL_print(const void *ip, const struct xt_entry_target *target,
 	printf(" %u", info->ttl);
 }
 
-static const struct option TTL_opts[] = {
-	{.name = "ttl-set", .has_arg = true, .val = '1'},
-	{.name = "ttl-dec", .has_arg = true, .val = '2'},
-	{.name = "ttl-inc", .has_arg = true, .val = '3'},
-	XT_GETOPT_TABLEEND,
-};
-
 static struct xtables_target ttl_tg_reg = {
 	.name		= "TTL",
 	.version	= XTABLES_VERSION,
@@ -139,11 +113,11 @@ static struct xtables_target ttl_tg_reg = {
 	.size		= XT_ALIGN(sizeof(struct ipt_TTL_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_TTL_info)),
 	.help		= TTL_help,
-	.parse		= TTL_parse,
-	.final_check	= TTL_check,
 	.print		= TTL_print,
 	.save		= TTL_save,
-	.extra_opts	= TTL_opts,
+	.x6_parse	= TTL_parse,
+	.x6_fcheck	= TTL_check,
+	.x6_options	= TTL_opts,
 };
 
 void _init(void)
-- 
1.7.1

