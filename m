From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/17] libxt_hashlimit: use guided option parser
Date: Mon,  9 May 2011 21:55:01 +0200
Message-ID: <1304970912-11520-8-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49349 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab1EITzY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:24 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_hashlimit.c |  419 +++++++++++++-----------------------------
 1 files changed, 129 insertions(+), 290 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index cd057c5..e683f9a 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -15,9 +15,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
-#include <stddef.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_hashlimit.h>
 
@@ -45,6 +43,23 @@ static void hashlimit_help(void)
 XT_HASHLIMIT_BURST);
 }
 
+enum {
+	O_UPTO = 0,
+	O_ABOVE,
+	O_LIMIT,
+	O_MODE,
+	O_SRCMASK,
+	O_DSTMASK,
+	O_NAME,
+	O_BURST,
+	O_HTABLE_SIZE,
+	O_HTABLE_MAX,
+	O_HTABLE_GCINT,
+	O_HTABLE_EXPIRE,
+	F_UPTO  = 1 << O_UPTO,
+	F_ABOVE = 1 << O_ABOVE,
+};
+
 static void hashlimit_mt_help(void)
 {
 	printf(
@@ -66,33 +81,64 @@ static void hashlimit_mt_help(void)
 "\n", XT_HASHLIMIT_BURST);
 }
 
-static const struct option hashlimit_opts[] = {
-	{.name = "hashlimit",                   .has_arg = true, .val = '%'},
-	{.name = "hashlimit-burst",             .has_arg = true, .val = '$'},
-	{.name = "hashlimit-htable-size",       .has_arg = true, .val = '&'},
-	{.name = "hashlimit-htable-max",        .has_arg = true, .val = '*'},
-	{.name = "hashlimit-htable-gcinterval", .has_arg = true, .val = '('},
-	{.name = "hashlimit-htable-expire",     .has_arg = true, .val = ')'},
-	{.name = "hashlimit-mode",              .has_arg = true, .val = '_'},
-	{.name = "hashlimit-name",              .has_arg = true, .val = '"'},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_hashlimit_info
+static const struct xt_option_entry hashlimit_opts[] = {
+	{.name = "hashlimit", .id = O_UPTO, .excl = F_ABOVE,
+	 .type = XTTYPE_STRING, .flags = XTOPT_INVERT},
+	{.name = "hashlimit-burst", .id = O_BURST, .type = XTTYPE_UINT32,
+	 .min = 1, .max = 10000, .flags = XTOPT_PUT,
+	 XTOPT_POINTER(s, cfg.burst)},
+	{.name = "hashlimit-htable-size", .id = O_HTABLE_SIZE,
+	 .type = XTTYPE_UINT32, .flags = XTOPT_PUT,
+	 XTOPT_POINTER(s, cfg.size)},
+	{.name = "hashlimit-htable-max", .id = O_HTABLE_MAX,
+	 .type = XTTYPE_UINT32, .flags = XTOPT_PUT,
+	 XTOPT_POINTER(s, cfg.max)},
+	{.name = "hashlimit-htable-gcinterval", .id = O_HTABLE_GCINT,
+	 .type = XTTYPE_UINT32, .flags = XTOPT_PUT,
+	 XTOPT_POINTER(s, cfg.gc_interval)},
+	{.name = "hashlimit-htable-expire", .id = O_HTABLE_EXPIRE,
+	 .type = XTTYPE_UINT32, .flags = XTOPT_PUT,
+	 XTOPT_POINTER(s, cfg.expire)},
+	{.name = "hashlimit-mode", .id = O_MODE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND},
+	{.name = "hashlimit-name", .id = O_NAME, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, name), .min = 1},
+	XTOPT_TABLEEND,
 };
-
-static const struct option hashlimit_mt_opts[] = {
-	{.name = "hashlimit-upto",              .has_arg = true, .val = '%'},
-	{.name = "hashlimit-above",             .has_arg = true, .val = '^'},
-	{.name = "hashlimit",                   .has_arg = true, .val = '%'},
-	{.name = "hashlimit-srcmask",           .has_arg = true, .val = '<'},
-	{.name = "hashlimit-dstmask",           .has_arg = true, .val = '>'},
-	{.name = "hashlimit-burst",             .has_arg = true, .val = '$'},
-	{.name = "hashlimit-htable-size",       .has_arg = true, .val = '&'},
-	{.name = "hashlimit-htable-max",        .has_arg = true, .val = '*'},
-	{.name = "hashlimit-htable-gcinterval", .has_arg = true, .val = '('},
-	{.name = "hashlimit-htable-expire",     .has_arg = true, .val = ')'},
-	{.name = "hashlimit-mode",              .has_arg = true, .val = '_'},
-	{.name = "hashlimit-name",              .has_arg = true, .val = '"'},
-	XT_GETOPT_TABLEEND,
+#undef s
+
+#define s struct xt_hashlimit_mtinfo1
+static const struct xt_option_entry hashlimit_mt_opts[] = {
+	{.name = "hashlimit-upto", .id = O_UPTO, .excl = F_ABOVE,
+	 .type = XTTYPE_STRING, .flags = XTOPT_INVERT},
+	{.name = "hashlimit-above", .id = O_ABOVE, .excl = F_UPTO,
+	 .type = XTTYPE_STRING, .flags = XTOPT_INVERT},
+	{.name = "hashlimit", .id = O_UPTO, .excl = F_ABOVE,
+	 .type = XTTYPE_STRING, .flags = XTOPT_INVERT}, /* old name */
+	{.name = "hashlimit-srcmask", .id = O_SRCMASK, .type = XTTYPE_PLEN},
+	{.name = "hashlimit-dstmask", .id = O_DSTMASK, .type = XTTYPE_PLEN},
+	{.name = "hashlimit-burst", .id = O_BURST, .type = XTTYPE_UINT32,
+	 .min = 1, .max = 10000, .flags = XTOPT_PUT,
+	 XTOPT_POINTER(s, cfg.burst)},
+	{.name = "hashlimit-htable-size", .id = O_HTABLE_SIZE,
+	 .type = XTTYPE_UINT32, .flags = XTOPT_PUT,
+	 XTOPT_POINTER(s, cfg.size)},
+	{.name = "hashlimit-htable-max", .id = O_HTABLE_MAX,
+	 .type = XTTYPE_UINT32, .flags = XTOPT_PUT,
+	 XTOPT_POINTER(s, cfg.max)},
+	{.name = "hashlimit-htable-gcinterval", .id = O_HTABLE_GCINT,
+	 .type = XTTYPE_UINT32, .flags = XTOPT_PUT,
+	 XTOPT_POINTER(s, cfg.gc_interval)},
+	{.name = "hashlimit-htable-expire", .id = O_HTABLE_EXPIRE,
+	 .type = XTTYPE_UINT32, .flags = XTOPT_PUT,
+	 XTOPT_POINTER(s, cfg.expire)},
+	{.name = "hashlimit-mode", .id = O_MODE, .type = XTTYPE_STRING},
+	{.name = "hashlimit-name", .id = O_NAME, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, name), .min = 1},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 static
 int parse_rate(const char *rate, uint32_t *val)
@@ -165,7 +211,7 @@ static void hashlimit_mt6_init(struct xt_entry_match *match)
 }
 
 /* Parse a 'mode' parameter into the required bitmask */
-static int parse_mode(uint32_t *mode, char *option_arg)
+static int parse_mode(uint32_t *mode, const char *option_arg)
 {
 	char *tok;
 	char *arg = strdup(option_arg);
@@ -193,280 +239,73 @@ static int parse_mode(uint32_t *mode, char *option_arg)
 	return 0;
 }
 
-enum {
-	PARAM_LIMIT      = 1 << 0,
-	PARAM_BURST      = 1 << 1,
-	PARAM_MODE       = 1 << 2,
-	PARAM_NAME       = 1 << 3,
-	PARAM_SIZE       = 1 << 4,
-	PARAM_MAX        = 1 << 5,
-	PARAM_GCINTERVAL = 1 << 6,
-	PARAM_EXPIRE     = 1 << 7,
-	PARAM_SRCMASK    = 1 << 8,
-	PARAM_DSTMASK    = 1 << 9,
-};
-
-static int
-hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
-                const void *entry, struct xt_entry_match **match)
+static void hashlimit_parse(struct xt_option_call *cb)
 {
-	struct xt_hashlimit_info *r = 
-			(struct xt_hashlimit_info *)(*match)->data;
-	unsigned int num;
-
-	switch(c) {
-	case '%':
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit",
-		          *flags & PARAM_LIMIT);
-		if (xtables_check_inverse(optarg, &invert, &optind, 0, argv)) break;
-		if (!parse_rate(optarg, &r->cfg.avg))
-			xtables_error(PARAMETER_PROBLEM,
-				   "bad rate `%s'", optarg);
-		*flags |= PARAM_LIMIT;
-		break;
+	struct xt_hashlimit_info *info = cb->data;
 
-	case '$':
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-burst",
-		          *flags & PARAM_BURST);
-		if (xtables_check_inverse(optarg, &invert, &optind, 0, argv)) break;
-		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
-			xtables_error(PARAMETER_PROBLEM,
-				   "bad --hashlimit-burst `%s'", optarg);
-		r->cfg.burst = num;
-		*flags |= PARAM_BURST;
-		break;
-	case '&':
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
-		          *flags & PARAM_SIZE);
-		if (xtables_check_inverse(optarg, &invert, &optind, 0, argv)) break;
-		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			xtables_error(PARAMETER_PROBLEM,
-				"bad --hashlimit-htable-size: `%s'", optarg);
-		r->cfg.size = num;
-		*flags |= PARAM_SIZE;
-		break;
-	case '*':
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
-		          *flags & PARAM_MAX);
-		if (xtables_check_inverse(optarg, &invert, &optind, 0, argv)) break;
-		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			xtables_error(PARAMETER_PROBLEM,
-				"bad --hashlimit-htable-max: `%s'", optarg);
-		r->cfg.max = num;
-		*flags |= PARAM_MAX;
-		break;
-	case '(':
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit",
-		          "--hashlimit-htable-gcinterval",
-		          *flags & PARAM_GCINTERVAL);
-		if (xtables_check_inverse(optarg, &invert, &optind, 0, argv)) break;
-		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			xtables_error(PARAMETER_PROBLEM,
-				"bad --hashlimit-htable-gcinterval: `%s'", 
-				optarg);
-		/* FIXME: not HZ dependent!! */
-		r->cfg.gc_interval = num;
-		*flags |= PARAM_GCINTERVAL;
-		break;
-	case ')':
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit",
-		          "--hashlimit-htable-expire", *flags & PARAM_EXPIRE);
-		if (xtables_check_inverse(optarg, &invert, &optind, 0, argv)) break;
-		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			xtables_error(PARAMETER_PROBLEM,
-				"bad --hashlimit-htable-expire: `%s'", optarg);
-		/* FIXME: not HZ dependent */
-		r->cfg.expire = num;
-		*flags |= PARAM_EXPIRE;
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_UPTO:
+		if (cb->invert)
+			info->cfg.mode |= XT_HASHLIMIT_INVERT;
+		if (!parse_rate(cb->arg, &info->cfg.avg))
+			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
+			          "--hashlimit-upto", cb->arg);
 		break;
-	case '_':
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-mode",
-		          *flags & PARAM_MODE);
-		if (xtables_check_inverse(optarg, &invert, &optind, 0, argv)) break;
-		if (parse_mode(&r->cfg.mode, optarg) < 0)
-			xtables_error(PARAMETER_PROBLEM,
-				   "bad --hashlimit-mode: `%s'\n", optarg);
-		*flags |= PARAM_MODE;
+	case O_ABOVE:
+		if (!cb->invert)
+			info->cfg.mode |= XT_HASHLIMIT_INVERT;
+		if (!parse_rate(cb->arg, &info->cfg.avg))
+			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
+			          "--hashlimit-above", cb->arg);
 		break;
-	case '"':
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-name",
-		          *flags & PARAM_NAME);
-		if (xtables_check_inverse(optarg, &invert, &optind, 0, argv)) break;
-		if (strlen(optarg) == 0)
-			xtables_error(PARAMETER_PROBLEM, "Zero-length name?");
-		strncpy(r->name, optarg, sizeof(r->name));
-		*flags |= PARAM_NAME;
+	case O_MODE:
+		if (parse_mode(&info->cfg.mode, cb->arg) < 0)
+			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
+			          "--hashlimit-mode", cb->arg);
 		break;
 	}
-
-	if (invert)
-		xtables_error(PARAMETER_PROBLEM,
-			   "hashlimit does not support invert");
-
-	return 1;
 }
 
-static int
-hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
-                   int c, int invert, unsigned int maxmask)
+static void hashlimit_mt_parse(struct xt_option_call *cb)
 {
-	unsigned int num;
+	struct xt_hashlimit_mtinfo1 *info = cb->data;
 
-	switch(c) {
-	case '%': /* --hashlimit / --hashlimit-below */
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-upto",
-		          *flags & PARAM_LIMIT);
-		if (invert)
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_UPTO:
+		if (cb->invert)
 			info->cfg.mode |= XT_HASHLIMIT_INVERT;
-		if (!parse_rate(optarg, &info->cfg.avg))
+		if (!parse_rate(cb->arg, &info->cfg.avg))
 			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
-			          "--hashlimit-upto", optarg);
-		*flags |= PARAM_LIMIT;
-		return true;
-
-	case '^': /* --hashlimit-above == !--hashlimit-below */
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-above",
-		          *flags & PARAM_LIMIT);
-		if (!invert)
+			          "--hashlimit-upto", cb->arg);
+		break;
+	case O_ABOVE:
+		if (!cb->invert)
 			info->cfg.mode |= XT_HASHLIMIT_INVERT;
-		if (!parse_rate(optarg, &info->cfg.avg))
-			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
-			          "--hashlimit-above", optarg);
-		*flags |= PARAM_LIMIT;
-		return true;
-
-	case '$': /* --hashlimit-burst */
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-burst",
-		          *flags & PARAM_BURST);
-		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
+		if (!parse_rate(cb->arg, &info->cfg.avg))
 			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
-			          "--hashlimit-burst", optarg);
-		info->cfg.burst = num;
-		*flags |= PARAM_BURST;
-		return true;
-
-	case '&': /* --hashlimit-htable-size */
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
-		          *flags & PARAM_SIZE);
-		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
-			          "--hashlimit-htable-size", optarg);
-		info->cfg.size = num;
-		*flags |= PARAM_SIZE;
-		return true;
-
-	case '*': /* --hashlimit-htable-max */
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
-		          *flags & PARAM_MAX);
-		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
-			          "--hashlimit-htable-max", optarg);
-		info->cfg.max = num;
-		*flags |= PARAM_MAX;
-		return true;
-
-	case '(': /* --hashlimit-htable-gcinterval */
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit",
-		          "--hashlimit-htable-gcinterval",
-		          *flags & PARAM_GCINTERVAL);
-		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
-			          "--hashlimit-htable-gcinterval", optarg);
-		/* FIXME: not HZ dependent!! */
-		info->cfg.gc_interval = num;
-		*flags |= PARAM_GCINTERVAL;
-		return true;
-
-	case ')': /* --hashlimit-htable-expire */
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit",
-		          "--hashlimit-htable-expire", *flags & PARAM_EXPIRE);
-		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
-			          "--hashlimit-htable-expire", optarg);
-		/* FIXME: not HZ dependent */
-		info->cfg.expire = num;
-		*flags |= PARAM_EXPIRE;
-		return true;
-
-	case '_':
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-mode",
-		          *flags & PARAM_MODE);
-		if (parse_mode(&info->cfg.mode, optarg) < 0)
-			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
-			          "--hashlimit-mode", optarg);
-		*flags |= PARAM_MODE;
-		return true;
-
-	case '"': /* --hashlimit-name */
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-name",
-		          *flags & PARAM_NAME);
-		if (strlen(optarg) == 0)
-			xtables_error(PARAMETER_PROBLEM, "Zero-length name?");
-		strncpy(info->name, optarg, sizeof(info->name));
-		info->name[sizeof(info->name)-1] = '\0';
-		*flags |= PARAM_NAME;
-		return true;
-
-	case '<': /* --hashlimit-srcmask */
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-srcmask",
-		          *flags & PARAM_SRCMASK);
-		if (!xtables_strtoui(optarg, NULL, &num, 0, maxmask))
-			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
-			          "--hashlimit-srcmask", optarg);
-		info->cfg.srcmask = num;
-		*flags |= PARAM_SRCMASK;
-		return true;
-
-	case '>': /* --hashlimit-dstmask */
-		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-dstmask",
-		          *flags & PARAM_DSTMASK);
-		if (!xtables_strtoui(optarg, NULL, &num, 0, maxmask))
+			          "--hashlimit-above", cb->arg);
+		break;
+	case O_MODE:
+		if (parse_mode(&info->cfg.mode, cb->arg) < 0)
 			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
-			          "--hashlimit-dstmask", optarg);
-		info->cfg.dstmask = num;
-		*flags |= PARAM_DSTMASK;
-		return true;
+			          "--hashlimit-mode", cb->arg);
+		break;
+	case O_SRCMASK:
+		info->cfg.srcmask = cb->val.hlen;
+		break;
+	case O_DSTMASK:
+		info->cfg.dstmask = cb->val.hlen;
+		break;
 	}
-	return false;
-}
-
-static int
-hashlimit_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
-                    const void *entry, struct xt_entry_match **match)
-{
-	return hashlimit_mt_parse((void *)(*match)->data,
-	       flags, c, invert, 32);
-}
-
-static int
-hashlimit_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
-                    const void *entry, struct xt_entry_match **match)
-{
-	return hashlimit_mt_parse((void *)(*match)->data,
-	       flags, c, invert, 128);
 }
 
-static void hashlimit_check(unsigned int flags)
+static void hashlimit_check(struct xt_fcheck_call *cb)
 {
-	if (!(flags & PARAM_LIMIT))
+	if (!(cb->xflags & (F_UPTO | F_ABOVE)))
 		xtables_error(PARAMETER_PROBLEM,
 				"You have to specify --hashlimit");
-	if (!(flags & PARAM_MODE))
-		xtables_error(PARAMETER_PROBLEM,
-				"You have to specify --hashlimit-mode");
-	if (!(flags & PARAM_NAME))
-		xtables_error(PARAMETER_PROBLEM,
-				"You have to specify --hashlimit-name");
-}
-
-static void hashlimit_mt_check(unsigned int flags)
-{
-	if (!(flags & PARAM_LIMIT))
-		xtables_error(PARAMETER_PROBLEM, "You have to specify "
-		           "--hashlimit-upto or --hashlimit-above");
-	if (!(flags & PARAM_NAME))
-		xtables_error(PARAMETER_PROBLEM,
-		           "You have to specify --hashlimit-name");
 }
 
 static const struct rates
@@ -664,11 +503,11 @@ static struct xtables_match hashlimit_mt_reg[] = {
 		.userspacesize = offsetof(struct xt_hashlimit_info, hinfo),
 		.help          = hashlimit_help,
 		.init          = hashlimit_init,
-		.parse         = hashlimit_parse,
-		.final_check   = hashlimit_check,
+		.x6_parse      = hashlimit_parse,
+		.x6_fcheck     = hashlimit_check,
 		.print         = hashlimit_print,
 		.save          = hashlimit_save,
-		.extra_opts    = hashlimit_opts,
+		.x6_options    = hashlimit_mt_opts,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -679,11 +518,11 @@ static struct xtables_match hashlimit_mt_reg[] = {
 		.userspacesize = offsetof(struct xt_hashlimit_mtinfo1, hinfo),
 		.help          = hashlimit_mt_help,
 		.init          = hashlimit_mt4_init,
-		.parse         = hashlimit_mt4_parse,
-		.final_check   = hashlimit_mt_check,
+		.x6_parse      = hashlimit_mt_parse,
+		.x6_fcheck     = hashlimit_check,
 		.print         = hashlimit_mt4_print,
 		.save          = hashlimit_mt4_save,
-		.extra_opts    = hashlimit_mt_opts,
+		.x6_options    = hashlimit_mt_opts,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -694,11 +533,11 @@ static struct xtables_match hashlimit_mt_reg[] = {
 		.userspacesize = offsetof(struct xt_hashlimit_mtinfo1, hinfo),
 		.help          = hashlimit_mt_help,
 		.init          = hashlimit_mt6_init,
-		.parse         = hashlimit_mt6_parse,
-		.final_check   = hashlimit_mt_check,
+		.x6_parse      = hashlimit_mt_parse,
+		.x6_fcheck     = hashlimit_check,
 		.print         = hashlimit_mt6_print,
 		.save          = hashlimit_mt6_save,
-		.extra_opts    = hashlimit_mt_opts,
+		.x6_options    = hashlimit_mt_opts,
 	},
 };
 
-- 
1.7.1

