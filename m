From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/26] libxt_CONNMARK: use guided option parser
Date: Wed, 13 Apr 2011 18:13:24 +0200
Message-ID: <1302711228-15947-4-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42511 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933039Ab1DMQNx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:53 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_CONNMARK.c |  271 +++++++++++++++++--------------------------
 extensions/libxt_connmark.c |   98 ++++------------
 2 files changed, 134 insertions(+), 235 deletions(-)

diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index dbb9dc5..5d5351e 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -20,13 +20,9 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 #include <stdbool.h>
+#include <stdint.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
-#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CONNMARK.h>
 
 struct xt_connmark_target_info {
@@ -36,8 +32,28 @@ struct xt_connmark_target_info {
 };
 
 enum {
-	F_MARK    = 1 << 0,
-	F_SR_MARK = 1 << 1,
+	O_SET_MARK = 0,
+	O_SAVE_MARK,
+	O_RESTORE_MARK,
+	O_AND_MARK,
+	O_OR_MARK,
+	O_XOR_MARK,
+	O_SET_XMARK,
+	O_CTMASK,
+	O_NFMASK,
+	O_MASK,
+	F_SET_MARK     = 1 << O_SET_MARK,
+	F_SAVE_MARK    = 1 << O_SAVE_MARK,
+	F_RESTORE_MARK = 1 << O_RESTORE_MARK,
+	F_AND_MARK     = 1 << O_AND_MARK,
+	F_OR_MARK      = 1 << O_OR_MARK,
+	F_XOR_MARK     = 1 << O_XOR_MARK,
+	F_SET_XMARK    = 1 << O_SET_XMARK,
+	F_CTMASK       = 1 << O_CTMASK,
+	F_NFMASK       = 1 << O_NFMASK,
+	F_MASK         = 1 << O_MASK,
+	F_OP_ANY       = F_SET_MARK | F_SAVE_MARK | F_RESTORE_MARK |
+	                 F_AND_MARK | F_OR_MARK | F_XOR_MARK | F_SET_XMARK,
 };
 
 static void CONNMARK_help(void)
@@ -49,27 +65,44 @@ static void CONNMARK_help(void)
 "  --restore-mark [--mask mask]  Restore saved nfmark value\n");
 }
 
-static const struct option CONNMARK_opts[] = {
-	{.name = "set-mark",     .has_arg = true,  .val = '1'},
-	{.name = "save-mark",    .has_arg = false, .val = '2'},
-	{.name = "restore-mark", .has_arg = false, .val = '3'},
-	{.name = "mask",         .has_arg = true,  .val = '4'},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_connmark_target_info
+static const struct xt_option_entry CONNMARK_opts[] = {
+	{.name = "set-mark", .id = O_SET_MARK, .type = XTTYPE_MARKMASK32,
+	 .excl = F_OP_ANY},
+	{.name = "save-mark", .id = O_SAVE_MARK, .type = XTTYPE_NONE,
+	 .excl = F_OP_ANY},
+	{.name = "restore-mark", .id = O_RESTORE_MARK, .type = XTTYPE_NONE,
+	 .excl = F_OP_ANY},
+	{.name = "mask", .id = O_MASK, .type = XTTYPE_UINT32},
+	XTOPT_TABLEEND,
 };
-
-static const struct option connmark_tg_opts[] = {
-	{.name = "set-xmark",     .has_arg = true,  .val = '='},
-	{.name = "set-mark",      .has_arg = true,  .val = '-'},
-	{.name = "and-mark",      .has_arg = true,  .val = '&'},
-	{.name = "or-mark",       .has_arg = true,  .val = '|'},
-	{.name = "xor-mark",      .has_arg = true,  .val = '^'},
-	{.name = "save-mark",     .has_arg = false, .val = 'S'},
-	{.name = "restore-mark",  .has_arg = false, .val = 'R'},
-	{.name = "ctmask",        .has_arg = true,  .val = 'c'},
-	{.name = "nfmask",        .has_arg = true,  .val = 'n'},
-	{.name = "mask",          .has_arg = true,  .val = 'm'},
-	XT_GETOPT_TABLEEND,
+#undef s
+
+#define s struct xt_connmark_tginfo1
+static const struct xt_option_entry connmark_tg_opts[] = {
+	{.name = "set-xmark", .id = O_SET_XMARK, .type = XTTYPE_MARKMASK32,
+	 .excl = F_OP_ANY},
+	{.name = "set-mark", .id = O_SET_MARK, .type = XTTYPE_MARKMASK32,
+	 .excl = F_OP_ANY},
+	{.name = "and-mark", .id = O_AND_MARK, .type = XTTYPE_UINT32,
+	 .excl = F_OP_ANY},
+	{.name = "or-mark", .id = O_OR_MARK, .type = XTTYPE_UINT32,
+	 .excl = F_OP_ANY},
+	{.name = "xor-mark", .id = O_XOR_MARK, .type = XTTYPE_UINT32,
+	 .excl = F_OP_ANY},
+	{.name = "save-mark", .id = O_SAVE_MARK, .type = XTTYPE_NONE,
+	 .excl = F_OP_ANY},
+	{.name = "restore-mark", .id = O_RESTORE_MARK, .type = XTTYPE_NONE,
+	 .excl = F_OP_ANY},
+	{.name = "ctmask", .id = O_CTMASK, .type = XTTYPE_UINT32,
+	 .excl = F_MASK, .flags = XTOPT_PUT, XTOPT_POINTER(s, ctmask)},
+	{.name = "nfmask", .id = O_NFMASK, .type = XTTYPE_UINT32,
+	 .excl = F_MASK, .flags = XTOPT_PUT, XTOPT_POINTER(s, nfmask)},
+	{.name = "mask", .id = O_MASK, .type = XTTYPE_UINT32,
+	 .excl = F_CTMASK | F_NFMASK},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 static void connmark_tg_help(void)
 {
@@ -101,163 +134,75 @@ static void connmark_tg_init(struct xt_entry_target *target)
 	info->nfmask = UINT32_MAX;
 }
 
-static int
-CONNMARK_parse(int c, char **argv, int invert, unsigned int *flags,
-               const void *entry, struct xt_entry_target **target)
+static void CONNMARK_parse(struct xt_option_call *cb)
 {
-	struct xt_connmark_target_info *markinfo
-		= (struct xt_connmark_target_info *)(*target)->data;
+	struct xt_connmark_target_info *markinfo = cb->data;
 
-	switch (c) {
-		char *end;
-	case '1':
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SET_MARK:
 		markinfo->mode = XT_CONNMARK_SET;
-
-		markinfo->mark = strtoul(optarg, &end, 0);
-		if (*end == '/' && end[1] != '\0')
-		    markinfo->mask = strtoul(end+1, &end, 0);
-
-		if (*end != '\0' || end == optarg)
-			xtables_error(PARAMETER_PROBLEM, "Bad MARK value \"%s\"", optarg);
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-			           "CONNMARK target: Can't specify --set-mark twice");
-		*flags = 1;
+		markinfo->mark = cb->val.mark;
+		markinfo->mask = cb->val.mask;
 		break;
-	case '2':
+	case O_SAVE_MARK:
 		markinfo->mode = XT_CONNMARK_SAVE;
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-			           "CONNMARK target: Can't specify --save-mark twice");
-		*flags = 1;
 		break;
-	case '3':
+	case O_RESTORE_MARK:
 		markinfo->mode = XT_CONNMARK_RESTORE;
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-			           "CONNMARK target: Can't specify --restore-mark twice");
-		*flags = 1;
 		break;
-	case '4':
-		if (!*flags)
-			xtables_error(PARAMETER_PROBLEM,
-			           "CONNMARK target: Can't specify --mask without a operation");
-		markinfo->mask = strtoul(optarg, &end, 0);
-
-		if (*end != '\0' || end == optarg)
-			xtables_error(PARAMETER_PROBLEM, "Bad MASK value \"%s\"", optarg);
+	case O_MASK:
+		markinfo->mask = cb->val.u32;
 		break;
 	}
-
-	return 1;
 }
 
-static int connmark_tg_parse(int c, char **argv, int invert,
-                             unsigned int *flags, const void *entry,
-                             struct xt_entry_target **target)
+static void connmark_tg_parse(struct xt_option_call *cb)
 {
-	struct xt_connmark_tginfo1 *info = (void *)(*target)->data;
-	unsigned int value, mask = UINT32_MAX;
-	char *end;
+	struct xt_connmark_tginfo1 *info = cb->data;
 
-	switch (c) {
-	case '=': /* --set-xmark */
-	case '-': /* --set-mark */
-		xtables_param_act(XTF_ONE_ACTION, "CONNMARK", *flags & F_MARK);
-		if (!xtables_strtoui(optarg, &end, &value, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
-		if (*end == '/')
-			if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
-				xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
-		if (*end != '\0')
-			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SET_XMARK:
 		info->mode   = XT_CONNMARK_SET;
-		info->ctmark = value;
-		info->ctmask = mask;
-		if (c == '-')
-			info->ctmask |= value;
-		*flags |= F_MARK;
-		return true;
-
-	case '&': /* --and-mark */
-		xtables_param_act(XTF_ONE_ACTION, "CONNMARK", *flags & F_MARK);
-		if (!xtables_strtoui(optarg, NULL, &mask, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--and-mark", optarg);
+		info->ctmark = cb->val.mark;
+		info->ctmask = cb->val.mask;
+		break;
+	case O_SET_MARK:
+		info->mode   = XT_CONNMARK_SET;
+		info->ctmark = cb->val.mark;
+		info->ctmask = cb->val.mark | cb->val.mask;
+		break;
+	case O_AND_MARK:
 		info->mode   = XT_CONNMARK_SET;
 		info->ctmark = 0;
-		info->ctmask = ~mask;
-		*flags      |= F_MARK;
-		return true;
-
-	case '|': /* --or-mark */
-		xtables_param_act(XTF_ONE_ACTION, "CONNMARK", *flags & F_MARK);
-		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--or-mark", optarg);
+		info->ctmask = ~cb->val.u32;
+		break;
+	case O_OR_MARK:
 		info->mode   = XT_CONNMARK_SET;
-		info->ctmark = value;
-		info->ctmask = value;
-		*flags      |= F_MARK;
-		return true;
-
-	case '^': /* --xor-mark */
-		xtables_param_act(XTF_ONE_ACTION, "CONNMARK", *flags & F_MARK);
-		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--xor-mark", optarg);
+		info->ctmark = cb->val.u32;
+		info->ctmask = cb->val.u32;
+		break;
+	case O_XOR_MARK:
 		info->mode   = XT_CONNMARK_SET;
-		info->ctmark = value;
+		info->ctmark = cb->val.u32;
 		info->ctmask = 0;
-		*flags      |= F_MARK;
-		return true;
-
-	case 'S': /* --save-mark */
-		xtables_param_act(XTF_ONE_ACTION, "CONNMARK", *flags & F_MARK);
+		break;
+	case O_SAVE_MARK:
 		info->mode = XT_CONNMARK_SAVE;
-		*flags |= F_MARK | F_SR_MARK;
-		return true;
-
-	case 'R': /* --restore-mark */
-		xtables_param_act(XTF_ONE_ACTION, "CONNMARK", *flags & F_MARK);
+		break;
+	case O_RESTORE_MARK:
 		info->mode = XT_CONNMARK_RESTORE;
-		*flags |= F_MARK | F_SR_MARK;
-		return true;
-
-	case 'n': /* --nfmask */
-		if (!(*flags & F_SR_MARK))
-			xtables_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
-			           "or --restore-mark is required for "
-			           "--nfmask");
-		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--nfmask", optarg);
-		info->nfmask = value;
-		return true;
-
-	case 'c': /* --ctmask */
-		if (!(*flags & F_SR_MARK))
-			xtables_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
-			           "or --restore-mark is required for "
-			           "--ctmask");
-		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--ctmask", optarg);
-		info->ctmask = value;
-		return true;
-
-	case 'm': /* --mask */
-		if (!(*flags & F_SR_MARK))
-			xtables_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
-			           "or --restore-mark is required for "
-			           "--mask");
-		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--mask", optarg);
-		info->nfmask = info->ctmask = value;
-		return true;
+		break;
+	case O_MASK:
+		info->nfmask = info->ctmask = cb->val.u32;
+		break;
 	}
-
-	return false;
 }
 
-static void connmark_tg_check(unsigned int flags)
+static void connmark_tg_check(struct xt_fcheck_call *cb)
 {
-	if (!flags)
+	if (!(cb->xflags & F_OP_ANY))
 		xtables_error(PARAMETER_PROBLEM,
 		           "CONNMARK target: No operation specified");
 }
@@ -412,11 +357,11 @@ static struct xtables_target connmark_tg_reg[] = {
 		.userspacesize = XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 		.help          = CONNMARK_help,
 		.init          = CONNMARK_init,
-		.parse         = CONNMARK_parse,
-		.final_check   = connmark_tg_check,
 		.print         = CONNMARK_print,
 		.save          = CONNMARK_save,
-		.extra_opts    = CONNMARK_opts,
+		.x6_parse      = CONNMARK_parse,
+		.x6_fcheck     = connmark_tg_check,
+		.x6_options    = CONNMARK_opts,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -427,11 +372,11 @@ static struct xtables_target connmark_tg_reg[] = {
 		.userspacesize = XT_ALIGN(sizeof(struct xt_connmark_tginfo1)),
 		.help          = connmark_tg_help,
 		.init          = connmark_tg_init,
-		.parse         = connmark_tg_parse,
-		.final_check   = connmark_tg_check,
 		.print         = connmark_tg_print,
 		.save          = connmark_tg_save,
-		.extra_opts    = connmark_tg_opts,
+		.x6_parse      = connmark_tg_parse,
+		.x6_fcheck     = connmark_tg_check,
+		.x6_options    = connmark_tg_opts,
 	},
 };
 
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index a0e89fe..6f1d532 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -20,12 +20,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 #include <stdbool.h>
+#include <stdint.h>
 #include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
 #include <linux/netfilter/xt_connmark.h>
 
@@ -35,7 +31,7 @@ struct xt_connmark_info {
 };
 
 enum {
-	F_MARK = 1 << 0,
+	O_MARK = 0,
 };
 
 static void connmark_mt_help(void)
@@ -45,65 +41,32 @@ static void connmark_mt_help(void)
 "[!] --mark value[/mask]    Match ctmark value with optional mask\n");
 }
 
-static const struct option connmark_mt_opts[] = {
-	{.name = "mark", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry connmark_mt_opts[] = {
+	{.name = "mark", .id = O_MARK, .type = XTTYPE_MARKMASK32,
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
-static int
-connmark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
-                  const void *entry, struct xt_entry_match **match)
+static void connmark_mt_parse(struct xt_option_call *cb)
 {
-	struct xt_connmark_mtinfo1 *info = (void *)(*match)->data;
-	unsigned int mark, mask = UINT32_MAX;
-	char *end;
-
-	switch (c) {
-	case '1': /* --mark */
-		xtables_param_act(XTF_ONLY_ONCE, "connmark", "--mark", *flags & F_MARK);
-		if (!xtables_strtoui(optarg, &end, &mark, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "connmark", "--mark", optarg);
-		if (*end == '/')
-			if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
-				xtables_param_act(XTF_BAD_VALUE, "connmark", "--mark", optarg);
-		if (*end != '\0')
-			xtables_param_act(XTF_BAD_VALUE, "connmark", "--mark", optarg);
-
-		if (invert)
-			info->invert = true;
-		info->mark = mark;
-		info->mask = mask;
-		*flags    |= F_MARK;
-		return true;
-	}
-	return false;
+	struct xt_connmark_mtinfo1 *info = cb->data;
+
+	xtables_option_parse(cb);
+	if (cb->invert)
+		info->invert = true;
+	info->mark = cb->val.mark;
+	info->mask = cb->val.mask;
 }
 
-static int
-connmark_parse(int c, char **argv, int invert, unsigned int *flags,
-               const void *entry, struct xt_entry_match **match)
+static void connmark_parse(struct xt_option_call *cb)
 {
-	struct xt_connmark_info *markinfo = (struct xt_connmark_info *)(*match)->data;
-
-	switch (c) {
-		char *end;
-	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		markinfo->mark = strtoul(optarg, &end, 0);
-		markinfo->mask = 0xffffffffUL;
-		
-		if (*end == '/')
-			markinfo->mask = strtoul(end+1, &end, 0);
-
-		if (*end != '\0' || end == optarg)
-			xtables_error(PARAMETER_PROBLEM, "Bad MARK value \"%s\"", optarg);
-		if (invert)
-			markinfo->invert = 1;
-		*flags = 1;
-		break;
-	}
-	return 1;
+	struct xt_connmark_info *markinfo = cb->data;
+
+	xtables_option_parse(cb);
+	markinfo->mark = cb->val.mark;
+	markinfo->mask = cb->val.mask;
+	if (cb->invert)
+		markinfo->invert = 1;
 }
 
 static void print_mark(unsigned int mark, unsigned int mask)
@@ -114,13 +77,6 @@ static void print_mark(unsigned int mark, unsigned int mask)
 		printf(" 0x%x", mark);
 }
 
-static void connmark_mt_check(unsigned int flags)
-{
-	if (flags == 0)
-		xtables_error(PARAMETER_PROBLEM,
-		           "connmark: The --mark option is required");
-}
-
 static void
 connmark_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
@@ -175,11 +131,10 @@ static struct xtables_match connmark_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_connmark_info)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_connmark_info)),
 		.help          = connmark_mt_help,
-		.parse         = connmark_parse,
-		.final_check   = connmark_mt_check,
 		.print         = connmark_print,
 		.save          = connmark_save,
-		.extra_opts    = connmark_mt_opts,
+		.x6_parse      = connmark_parse,
+		.x6_options    = connmark_mt_opts,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -189,11 +144,10 @@ static struct xtables_match connmark_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_connmark_mtinfo1)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_connmark_mtinfo1)),
 		.help          = connmark_mt_help,
-		.parse         = connmark_mt_parse,
-		.final_check   = connmark_mt_check,
 		.print         = connmark_mt_print,
 		.save          = connmark_mt_save,
-		.extra_opts    = connmark_mt_opts,
+		.x6_parse      = connmark_mt_parse,
+		.x6_options    = connmark_mt_opts,
 	},
 };
 
-- 
1.7.1

