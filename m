From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/28] libip[6]t_hl: use guided option parser
Date: Tue, 12 Apr 2011 16:23:18 +0200
Message-ID: <1302618224-9449-4-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51086 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab1DLOXt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:23:49 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_hl.c |  106 ++++++++++++++++++----------------------------
 extensions/libipt_ttl.c |  109 ++++++++++++++++++-----------------------------
 2 files changed, 82 insertions(+), 133 deletions(-)

diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 5da3210..3559db4 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -5,15 +5,20 @@
  * This program is released under the terms of GNU GPL
  * Cleanups by Stephane Ouellette <ouellettes@videotron.ca>
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <getopt.h>
 #include <xtables.h>
-
 #include <linux/netfilter_ipv6/ip6t_hl.h>
 
+enum {
+	O_HL_EQ = 0,
+	O_HL_LT,
+	O_HL_GT,
+	F_HL_EQ = 1 << O_HL_EQ,
+	F_HL_LT = 1 << O_HL_LT,
+	F_HL_GT = 1 << O_HL_GT,
+	F_ANY  = F_HL_EQ | F_HL_LT | F_HL_GT,
+};
+
 static void hl_help(void)
 {
 	printf(
@@ -23,62 +28,27 @@ static void hl_help(void)
 "  --hl-gt value	Match HL > value\n");
 }
 
-static int hl_parse(int c, char **argv, int invert, unsigned int *flags,
-                    const void *entry, struct xt_entry_match **match)
+static void hl_parse(struct xt_option_call *cb)
 {
-	struct ip6t_hl_info *info = (struct ip6t_hl_info *) (*match)->data;
-	uint8_t value;
-
-	xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-	value = atoi(optarg);
-
-	if (*flags) 
-		xtables_error(PARAMETER_PROBLEM,
-				"Can't specify HL option twice");
-
-	if (!optarg)
-		xtables_error(PARAMETER_PROBLEM,
-				"hl: You must specify a value");
-	switch (c) {
-		case '2':
-			if (invert)
-				info->mode = IP6T_HL_NE;
-			else
-				info->mode = IP6T_HL_EQ;
-
-			/* is 0 allowed? */
-			info->hop_limit = value;
-			*flags = 1;
-
-			break;
-		case '3':
-			if (invert) 
-				xtables_error(PARAMETER_PROBLEM,
-						"hl: unexpected `!'");
-
-			info->mode = IP6T_HL_LT;
-			info->hop_limit = value;
-			*flags = 1;
-
-			break;
-		case '4':
-			if (invert)
-				xtables_error(PARAMETER_PROBLEM,
-						"hl: unexpected `!'");
-
-			info->mode = IP6T_HL_GT;
-			info->hop_limit = value;
-			*flags = 1;
-
-			break;
+	struct ip6t_hl_info *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_HL_EQ:
+		info->mode = cb->invert ? IP6T_HL_NE : IP6T_HL_EQ;
+		break;
+	case O_HL_LT:
+		info->mode = IP6T_HL_LT;
+		break;
+	case O_HL_GT:
+		info->mode = IP6T_HL_GT;
+		break;
 	}
-
-	return 1;
 }
 
-static void hl_check(unsigned int flags)
+static void hl_check(struct xt_fcheck_call *cb)
 {
-	if (!flags) 
+	if (!(cb->xflags & F_ANY))
 		xtables_error(PARAMETER_PROBLEM,
 			"HL match: You must specify one of "
 			"`--hl-eq', `--hl-lt', `--hl-gt'");
@@ -113,13 +83,19 @@ static void hl_save(const void *ip, const struct xt_entry_match *match)
 	printf(" %s %u", op[info->mode], info->hop_limit);
 }
 
-static const struct option hl_opts[] = {
-	{.name = "hl",    .has_arg = true, .val = '2'},
-	{.name = "hl-eq", .has_arg = true, .val = '2'},
-	{.name = "hl-lt", .has_arg = true, .val = '3'},
-	{.name = "hl-gt", .has_arg = true, .val = '4'},
-	XT_GETOPT_TABLEEND,
+#define s struct ip6t_hl_info
+static const struct xt_option_entry hl_opts[] = {
+	{.name = "hl-lt", .id = O_HL_LT, .excl = F_ANY, .type = XTTYPE_UINT8,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, hop_limit)},
+	{.name = "hl-gt", .id = O_HL_GT, .excl = F_ANY, .type = XTTYPE_UINT8,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, hop_limit)},
+	{.name = "hl-eq", .id = O_HL_EQ, .excl = F_ANY, .type = XTTYPE_UINT8,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, hop_limit)},
+	{.name = "hl", .id = O_HL_EQ, .excl = F_ANY, .type = XTTYPE_UINT8,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, hop_limit)},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 static struct xtables_match hl_mt6_reg = {
 	.name          = "hl",
@@ -128,11 +104,11 @@ static struct xtables_match hl_mt6_reg = {
 	.size          = XT_ALIGN(sizeof(struct ip6t_hl_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_hl_info)),
 	.help          = hl_help,
-	.parse         = hl_parse,
-	.final_check   = hl_check,
 	.print         = hl_print,
 	.save          = hl_save,
-	.extra_opts    = hl_opts,
+	.x6_parse      = hl_parse,
+	.x6_fcheck     = hl_check,
+	.x6_options    = hl_opts,
 };
 
 
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index d10eb80..6370cb6 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -2,15 +2,20 @@
  * (C) 2000 by Harald Welte <laforge@gnumonks.org>
  *
  * This program is released under the terms of GNU GPL */
-#include <stdbool.h>
 #include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <getopt.h>
 #include <xtables.h>
-
 #include <linux/netfilter_ipv4/ipt_ttl.h>
 
+enum {
+	O_TTL_EQ = 0,
+	O_TTL_LT,
+	O_TTL_GT,
+	F_TTL_EQ = 1 << O_TTL_EQ,
+	F_TTL_LT = 1 << O_TTL_LT,
+	F_TTL_GT = 1 << O_TTL_GT,
+	F_ANY    = F_TTL_EQ | F_TTL_LT | F_TTL_GT,
+};
+
 static void ttl_help(void)
 {
 	printf(
@@ -20,65 +25,27 @@ static void ttl_help(void)
 "  --ttl-gt value	Match TTL > value\n");
 }
 
-static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
-                     const void *entry, struct xt_entry_match **match)
+static void ttl_parse(struct xt_option_call *cb)
 {
-	struct ipt_ttl_info *info = (struct ipt_ttl_info *) (*match)->data;
-	unsigned int value;
-
-	xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-	switch (c) {
-		case '2':
-			if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
-				xtables_error(PARAMETER_PROBLEM,
-				           "ttl: Expected value between 0 and 255");
-
-			if (invert)
-				info->mode = IPT_TTL_NE;
-			else
-				info->mode = IPT_TTL_EQ;
-
-			/* is 0 allowed? */
-			info->ttl = value;
-			break;
-		case '3':
-			if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
-				xtables_error(PARAMETER_PROBLEM,
-				           "ttl: Expected value between 0 and 255");
-
-			if (invert) 
-				xtables_error(PARAMETER_PROBLEM,
-						"ttl: unexpected `!'");
-
-			info->mode = IPT_TTL_LT;
-			info->ttl = value;
-			break;
-		case '4':
-			if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
-				xtables_error(PARAMETER_PROBLEM,
-				           "ttl: Expected value between 0 and 255");
-
-			if (invert)
-				xtables_error(PARAMETER_PROBLEM,
-						"ttl: unexpected `!'");
-
-			info->mode = IPT_TTL_GT;
-			info->ttl = value;
-			break;
+	struct ipt_ttl_info *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_TTL_EQ:
+		info->mode = cb->invert ? IPT_TTL_NE : IPT_TTL_EQ;
+		break;
+	case O_TTL_LT:
+		info->mode = IPT_TTL_LT;
+		break;
+	case O_TTL_GT:
+		info->mode = IPT_TTL_GT;
+		break;
 	}
-
-	if (*flags) 
-		xtables_error(PARAMETER_PROBLEM,
-				"Can't specify TTL option twice");
-	*flags = 1;
-
-	return 1;
 }
 
-static void ttl_check(unsigned int flags)
+static void ttl_check(struct xt_fcheck_call *cb)
 {
-	if (!flags) 
+	if (!(cb->xflags & F_ANY))
 		xtables_error(PARAMETER_PROBLEM,
 			"TTL match: You must specify one of "
 			"`--ttl-eq', `--ttl-lt', `--ttl-gt");
@@ -133,13 +100,19 @@ static void ttl_save(const void *ip, const struct xt_entry_match *match)
 	printf(" %u", info->ttl);
 }
 
-static const struct option ttl_opts[] = {
-	{.name = "ttl",    .has_arg = true, .val = '2'},
-	{.name = "ttl-eq", .has_arg = true, .val = '2'},
-	{.name = "ttl-lt", .has_arg = true, .val = '3'},
-	{.name = "ttl-gt", .has_arg = true, .val = '4'},
-	XT_GETOPT_TABLEEND,
+#define s struct ipt_ttl_info
+static const struct xt_option_entry ttl_opts[] = {
+	{.name = "ttl-lt", .id = O_TTL_LT, .excl = F_ANY, .type = XTTYPE_UINT8,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, ttl)},
+	{.name = "ttl-gt", .id = O_TTL_GT, .excl = F_ANY, .type = XTTYPE_UINT8,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, ttl)},
+	{.name = "ttl-eq", .id = O_TTL_EQ, .excl = F_ANY, .type = XTTYPE_UINT8,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, ttl)},
+	{.name = "ttl", .id = O_TTL_EQ, .excl = F_ANY, .type = XTTYPE_UINT8,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, ttl)},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 static struct xtables_match ttl_mt_reg = {
 	.name		= "ttl",
@@ -148,11 +121,11 @@ static struct xtables_match ttl_mt_reg = {
 	.size		= XT_ALIGN(sizeof(struct ipt_ttl_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_ttl_info)),
 	.help		= ttl_help,
-	.parse		= ttl_parse,
-	.final_check	= ttl_check,
 	.print		= ttl_print,
 	.save		= ttl_save,
-	.extra_opts	= ttl_opts,
+	.x6_parse	= ttl_parse,
+	.x6_fcheck	= ttl_check,
+	.x6_options	= ttl_opts,
 };
 
 
-- 
1.7.1

