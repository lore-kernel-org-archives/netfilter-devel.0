From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/26] libxt_MARK: use guided option parser
Date: Wed, 13 Apr 2011 18:13:23 +0200
Message-ID: <1302711228-15947-3-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42510 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049Ab1DMQNx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:53 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_MARK.c |  202 ++++++++++++++++++----------------------------
 extensions/libxt_mark.c |   95 ++++++----------------
 2 files changed, 104 insertions(+), 193 deletions(-)

diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 885cf2f..556dbde 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -1,12 +1,6 @@
-/* Shared library add-on to iptables to add MARK target support. */
 #include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
-#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_MARK.h>
 
 /* Version 0 */
@@ -27,7 +21,18 @@ struct xt_mark_target_info_v1 {
 };
 
 enum {
-	F_MARK = 1 << 0,
+	O_SET_MARK = 0,
+	O_AND_MARK,
+	O_OR_MARK,
+	O_XOR_MARK,
+	O_SET_XMARK,
+	F_SET_MARK  = 1 << O_SET_MARK,
+	F_AND_MARK  = 1 << O_AND_MARK,
+	F_OR_MARK   = 1 << O_OR_MARK,
+	F_XOR_MARK  = 1 << O_XOR_MARK,
+	F_SET_XMARK = 1 << O_SET_XMARK,
+	F_ANY       = F_SET_MARK | F_AND_MARK | F_OR_MARK |
+	              F_XOR_MARK | F_SET_XMARK,
 };
 
 static void MARK_help(void)
@@ -39,20 +44,28 @@ static void MARK_help(void)
 "  --or-mark  value                   Binary OR  the nfmark with value\n");
 }
 
-static const struct option MARK_opts[] = {
-	{.name = "set-mark", .has_arg = true, .val = '1'},
-	{.name = "and-mark", .has_arg = true, .val = '2'},
-	{.name = "or-mark",  .has_arg = true, .val = '3'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry MARK_opts[] = {
+	{.name = "set-mark", .id = O_SET_MARK, .type = XTTYPE_UINT32,
+	 .excl = F_ANY},
+	{.name = "and-mark", .id = O_AND_MARK, .type = XTTYPE_UINT32,
+	 .excl = F_ANY},
+	{.name = "or-mark", .id = O_OR_MARK, .type = XTTYPE_UINT32,
+	 .excl = F_ANY},
+	XTOPT_TABLEEND,
 };
 
-static const struct option mark_tg_opts[] = {
-	{.name = "set-xmark", .has_arg = true, .val = 'X'},
-	{.name = "set-mark",  .has_arg = true, .val = '='},
-	{.name = "and-mark",  .has_arg = true, .val = '&'},
-	{.name = "or-mark",   .has_arg = true, .val = '|'},
-	{.name = "xor-mark",  .has_arg = true, .val = '^'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry mark_tg_opts[] = {
+	{.name = "set-xmark", .id = O_SET_XMARK, .type = XTTYPE_MARKMASK32,
+	 .excl = F_ANY},
+	{.name = "set-mark", .id = O_SET_MARK, .type = XTTYPE_MARKMASK32,
+	 .excl = F_ANY},
+	{.name = "and-mark", .id = O_AND_MARK, .type = XTTYPE_UINT32,
+	 .excl = F_ANY},
+	{.name = "or-mark", .id = O_OR_MARK, .type = XTTYPE_UINT32,
+	 .excl = F_ANY},
+	{.name = "xor-mark", .id = O_XOR_MARK, .type = XTTYPE_UINT32,
+	 .excl = F_ANY},
+	XTOPT_TABLEEND,
 };
 
 static void mark_tg_help(void)
@@ -67,137 +80,80 @@ static void mark_tg_help(void)
 "\n");
 }
 
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-MARK_parse_v0(int c, char **argv, int invert, unsigned int *flags,
-              const void *entry, struct xt_entry_target **target)
+static void MARK_parse_v0(struct xt_option_call *cb)
 {
-	struct xt_mark_target_info *markinfo
-		= (struct xt_mark_target_info *)(*target)->data;
-	unsigned int mark = 0;
+	struct xt_mark_target_info *markinfo = cb->data;
 
-	switch (c) {
-	case '1':
-		if (!xtables_strtoui(optarg, NULL, &mark, 0, UINT32_MAX))
-			xtables_error(PARAMETER_PROBLEM, "Bad MARK value \"%s\"", optarg);
-		markinfo->mark = mark;
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-			           "MARK target: Can't specify --set-mark twice");
-		*flags = 1;
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SET_MARK:
+		markinfo->mark = cb->val.mark;
 		break;
-	case '2':
-		xtables_error(PARAMETER_PROBLEM,
-			   "MARK target: kernel too old for --and-mark");
-	case '3':
+	default:
 		xtables_error(PARAMETER_PROBLEM,
-			   "MARK target: kernel too old for --or-mark");
+			   "MARK target: kernel too old for --%s",
+			   cb->entry->name);
 	}
-
-	return 1;
 }
 
-static void MARK_check(unsigned int flags)
+static void MARK_check(struct xt_fcheck_call *cb)
 {
-	if (!flags)
+	if (cb->xflags == 0)
 		xtables_error(PARAMETER_PROBLEM,
 		           "MARK target: Parameter --set/and/or-mark"
 			   " is required");
 }
 
-static int
-MARK_parse_v1(int c, char **argv, int invert, unsigned int *flags,
-              const void *entry, struct xt_entry_target **target)
+static void MARK_parse_v1(struct xt_option_call *cb)
 {
-	struct xt_mark_target_info_v1 *markinfo
-		= (struct xt_mark_target_info_v1 *)(*target)->data;
-	unsigned int mark = 0;
+	struct xt_mark_target_info_v1 *markinfo = cb->data;
 
-	switch (c) {
-	case '1':
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SET_MARK:
 	        markinfo->mode = XT_MARK_SET;
 		break;
-	case '2':
+	case O_AND_MARK:
 	        markinfo->mode = XT_MARK_AND;
 		break;
-	case '3':
+	case O_OR_MARK:
 	        markinfo->mode = XT_MARK_OR;
 		break;
 	}
-
-	if (!xtables_strtoui(optarg, NULL, &mark, 0, UINT32_MAX))
-		xtables_error(PARAMETER_PROBLEM, "Bad MARK value \"%s\"", optarg);
-	markinfo->mark = mark;
-	if (*flags)
-		xtables_error(PARAMETER_PROBLEM,
-			   "MARK target: Can't specify --set-mark twice");
-
-	*flags = 1;
-	return 1;
+	markinfo->mark = cb->val.u32;
 }
 
-static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
-                         const void *entry, struct xt_entry_target **target)
+static void mark_tg_parse(struct xt_option_call *cb)
 {
-	struct xt_mark_tginfo2 *info = (void *)(*target)->data;
-	unsigned int value, mask = UINT32_MAX;
-	char *end;
+	struct xt_mark_tginfo2 *info = cb->data;
 
-	switch (c) {
-	case 'X': /* --set-xmark */
-	case '=': /* --set-mark */
-		xtables_param_act(XTF_ONE_ACTION, "MARK", *flags & F_MARK);
-		xtables_param_act(XTF_NO_INVERT, "MARK", "--set-xmark/--set-mark", invert);
-		if (!xtables_strtoui(optarg, &end, &value, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
-		if (*end == '/')
-			if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
-				xtables_param_act(XTF_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
-		if (*end != '\0')
-			xtables_param_act(XTF_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
-		info->mark = value;
-		info->mask = mask;
-
-		if (c == '=')
-			info->mask = value | mask;
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SET_XMARK:
+		info->mark = cb->val.mark;
+		info->mask = cb->val.mask;
 		break;
-
-	case '&': /* --and-mark */
-		xtables_param_act(XTF_ONE_ACTION, "MARK", *flags & F_MARK);
-		xtables_param_act(XTF_NO_INVERT, "MARK", "--and-mark", invert);
-		if (!xtables_strtoui(optarg, NULL, &mask, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "MARK", "--and-mark", optarg);
+	case O_SET_MARK:
+		info->mark = cb->val.mark;
+		info->mask = cb->val.mark | cb->val.mask;
+		break;
+	case O_AND_MARK:
 		info->mark = 0;
-		info->mask = ~mask;
+		info->mask = ~cb->val.u32;
 		break;
-
-	case '|': /* --or-mark */
-		xtables_param_act(XTF_ONE_ACTION, "MARK", *flags & F_MARK);
-		xtables_param_act(XTF_NO_INVERT, "MARK", "--or-mark", invert);
-		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "MARK", "--or-mark", optarg);
-		info->mark = value;
-		info->mask = value;
+	case O_OR_MARK:
+		info->mark = info->mask = cb->val.u32;
 		break;
-
-	case '^': /* --xor-mark */
-		xtables_param_act(XTF_ONE_ACTION, "MARK", *flags & F_MARK);
-		xtables_param_act(XTF_NO_INVERT, "MARK", "--xor-mark", invert);
-		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "MARK", "--xor-mark", optarg);
-		info->mark = value;
+	case O_XOR_MARK:
+		info->mark = cb->val.u32;
 		info->mask = 0;
 		break;
 	}
-
-	*flags |= F_MARK;
-	return true;
 }
 
-static void mark_tg_check(unsigned int flags)
+static void mark_tg_check(struct xt_fcheck_call *cb)
 {
-	if (flags == 0)
+	if (cb->xflags == 0)
 		xtables_error(PARAMETER_PROBLEM, "MARK: One of the --set-xmark, "
 		           "--{and,or,xor,set}-mark options is required");
 }
@@ -298,11 +254,11 @@ static struct xtables_target mark_tg_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_mark_target_info)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_mark_target_info)),
 		.help          = MARK_help,
-		.parse         = MARK_parse_v0,
-		.final_check   = MARK_check,
 		.print         = MARK_print_v0,
 		.save          = MARK_save_v0,
-		.extra_opts    = MARK_opts,
+		.x6_parse      = MARK_parse_v0,
+		.x6_fcheck     = MARK_check,
+		.x6_options    = MARK_opts,
 	},
 	{
 		.family        = NFPROTO_IPV4,
@@ -312,11 +268,11 @@ static struct xtables_target mark_tg_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_mark_target_info_v1)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_mark_target_info_v1)),
 		.help          = MARK_help,
-		.parse         = MARK_parse_v1,
-		.final_check   = MARK_check,
 		.print         = MARK_print_v1,
 		.save          = MARK_save_v1,
-		.extra_opts    = MARK_opts,
+		.x6_parse      = MARK_parse_v1,
+		.x6_fcheck     = MARK_check,
+		.x6_options    = MARK_opts,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -326,11 +282,11 @@ static struct xtables_target mark_tg_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_mark_tginfo2)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_mark_tginfo2)),
 		.help          = mark_tg_help,
-		.parse         = mark_tg_parse,
-		.final_check   = mark_tg_check,
 		.print         = mark_tg_print,
 		.save          = mark_tg_save,
-		.extra_opts    = mark_tg_opts,
+		.x6_parse      = mark_tg_parse,
+		.x6_fcheck     = mark_tg_check,
+		.x6_options    = mark_tg_opts,
 	},
 };
 
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index d3c1727..7f8c995 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -1,11 +1,5 @@
-/* Shared library add-on to iptables to add NFMARK matching support. */
 #include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
 #include <linux/netfilter/xt_mark.h>
 
@@ -15,7 +9,7 @@ struct xt_mark_info {
 };
 
 enum {
-	F_MARK = 1 << 0,
+	O_MARK = 0,
 };
 
 static void mark_mt_help(void)
@@ -25,62 +19,32 @@ static void mark_mt_help(void)
 "[!] --mark value[/mask]    Match nfmark value with optional mask\n");
 }
 
-static const struct option mark_mt_opts[] = {
-	{.name = "mark", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry mark_mt_opts[] = {
+	{.name = "mark", .id = O_MARK, .type = XTTYPE_MARKMASK32,
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
-static int mark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
-                         const void *entry, struct xt_entry_match **match)
+static void mark_mt_parse(struct xt_option_call *cb)
 {
-	struct xt_mark_mtinfo1 *info = (void *)(*match)->data;
-	unsigned int mark, mask = UINT32_MAX;
-	char *end;
-
-	switch (c) {
-	case '1': /* --mark */
-		xtables_param_act(XTF_ONLY_ONCE, "mark", "--mark", *flags & F_MARK);
-		if (!xtables_strtoui(optarg, &end, &mark, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "mark", "--mark", optarg);
-		if (*end == '/')
-			if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
-				xtables_param_act(XTF_BAD_VALUE, "mark", "--mark", optarg);
-		if (*end != '\0')
-			xtables_param_act(XTF_BAD_VALUE, "mark", "--mark", optarg);
-
-		if (invert)
-			info->invert = true;
-		info->mark = mark;
-		info->mask = mask;
-		*flags    |= F_MARK;
-		return true;
-	}
-	return false;
+	struct xt_mark_mtinfo1 *info = cb->data;
+
+	xtables_option_parse(cb);
+	if (cb->invert)
+		info->invert = true;
+	info->mark = cb->val.mark;
+	info->mask = cb->val.mask;
 }
 
-static int
-mark_parse(int c, char **argv, int invert, unsigned int *flags,
-           const void *entry, struct xt_entry_match **match)
+static void mark_parse(struct xt_option_call *cb)
 {
-	struct xt_mark_info *markinfo = (struct xt_mark_info *)(*match)->data;
-
-	switch (c) {
-		char *end;
-	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		markinfo->mark = strtoul(optarg, &end, 0);
-		if (*end == '/') {
-			markinfo->mask = strtoul(end+1, &end, 0);
-		} else
-			markinfo->mask = 0xffffffff;
-		if (*end != '\0' || end == optarg)
-			xtables_error(PARAMETER_PROBLEM, "Bad MARK value \"%s\"", optarg);
-		if (invert)
-			markinfo->invert = 1;
-		*flags = 1;
-		break;
-	}
-	return 1;
+	struct xt_mark_info *markinfo = cb->data;
+
+	xtables_option_parse(cb);
+	if (cb->invert)
+		markinfo->invert = 1;
+	markinfo->mark = cb->val.mark;
+	markinfo->mask = cb->val.mask;
 }
 
 static void print_mark(unsigned int mark, unsigned int mask)
@@ -91,13 +55,6 @@ static void print_mark(unsigned int mark, unsigned int mask)
 		printf(" 0x%x", mark);
 }
 
-static void mark_mt_check(unsigned int flags)
-{
-	if (flags == 0)
-		xtables_error(PARAMETER_PROBLEM,
-			   "mark match: The --mark option is required");
-}
-
 static void
 mark_mt_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
@@ -154,11 +111,10 @@ static struct xtables_match mark_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_mark_info)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_mark_info)),
 		.help          = mark_mt_help,
-		.parse         = mark_parse,
-		.final_check   = mark_mt_check,
 		.print         = mark_print,
 		.save          = mark_save,
-		.extra_opts    = mark_mt_opts,
+		.x6_parse      = mark_parse,
+		.x6_options    = mark_mt_opts,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -168,11 +124,10 @@ static struct xtables_match mark_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
 		.help          = mark_mt_help,
-		.parse         = mark_mt_parse,
-		.final_check   = mark_mt_check,
 		.print         = mark_mt_print,
 		.save          = mark_mt_save,
-		.extra_opts    = mark_mt_opts,
+		.x6_parse      = mark_mt_parse,
+		.x6_options    = mark_mt_opts,
 	},
 };
 
-- 
1.7.1

