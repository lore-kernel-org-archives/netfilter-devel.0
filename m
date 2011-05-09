From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/13] libxt_statistic: use guided option parser
Date: Mon,  9 May 2011 11:37:09 +0200
Message-ID: <1304933832-16412-12-git-send-email-jengelh@medozas.de>
References: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51691 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab1EIJh1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:37:27 -0400
In-Reply-To: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_statistic.c |  144 ++++++++++++++++-------------------------
 1 files changed, 56 insertions(+), 88 deletions(-)

diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index f13cdba..12a83dd 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -1,15 +1,19 @@
 #include <math.h>
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
-#include <stdlib.h>
-#include <stddef.h>
-#include <getopt.h>
-
 #include <xtables.h>
 #include <linux/netfilter/xt_statistic.h>
 
+enum {
+	O_MODE = 0,
+	O_PROBABILITY,
+	O_EVERY,
+	O_PACKET,
+	F_PROBABILITY = 1 << O_PROBABILITY,
+	F_EVERY       = 1 << O_EVERY,
+	F_PACKET      = 1 << O_PACKET,
+};
+
 static void statistic_help(void)
 {
 	printf(
@@ -22,106 +26,71 @@ static void statistic_help(void)
 " --packet p			 Initial counter value (0 <= p <= n-1, default 0)\n");
 }
 
-static const struct option statistic_opts[] = {
-	{.name = "mode",        .has_arg = true, .val = '1'},
-	{.name = "probability", .has_arg = true, .val = '2'},
-	{.name = "every",       .has_arg = true, .val = '3'},
-	{.name = "packet",      .has_arg = true, .val = '4'},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_statistic_info
+static const struct xt_option_entry statistic_opts[] = {
+	{.name = "mode", .id = O_MODE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND},
+	{.name = "probability", .id = O_PROBABILITY, .type = XTTYPE_DOUBLE,
+	 .flags = XTOPT_INVERT, .min = 0, .max = 1,
+	 .excl = F_EVERY | F_PACKET},
+	{.name = "every", .id = O_EVERY, .type = XTTYPE_UINT32, .min = 1,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, u.nth.every),
+	 .excl = F_PROBABILITY, .also = F_PACKET},
+	{.name = "packet", .id = O_PACKET, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, u.nth.packet),
+	 .excl = F_PROBABILITY, .also = F_EVERY},
+	XTOPT_TABLEEND,
 };
+#undef s
 
-static struct xt_statistic_info *global_info;
-
-static void statistic_mt_init(struct xt_entry_match *match)
-{
-	global_info = (void *)match->data;
-}
-
-static int
-statistic_parse(int c, char **argv, int invert, unsigned int *flags,
-                const void *entry, struct xt_entry_match **match)
+static void statistic_parse(struct xt_option_call *cb)
 {
-	struct xt_statistic_info *info = (void *)(*match)->data;
-	unsigned int val;
-	double prob;
+	struct xt_statistic_info *info = cb->data;
 
-	if (invert)
+	if (cb->invert)
 		info->flags |= XT_STATISTIC_INVERT;
 
-	switch (c) {
-	case '1':
-		if (*flags & 0x1)
-			xtables_error(PARAMETER_PROBLEM, "double --mode");
-		if (!strcmp(optarg, "random"))
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_MODE:
+		if (strcmp(cb->arg, "random") == 0)
 			info->mode = XT_STATISTIC_MODE_RANDOM;
-		else if (!strcmp(optarg, "nth"))
+		else if (strcmp(cb->arg, "nth") == 0)
 			info->mode = XT_STATISTIC_MODE_NTH;
 		else
-			xtables_error(PARAMETER_PROBLEM, "Bad mode \"%s\"", optarg);
-		*flags |= 0x1;
+			xtables_error(PARAMETER_PROBLEM, "Bad mode \"%s\"",
+				cb->arg);
 		break;
-	case '2':
-		if (*flags & 0x2)
-			xtables_error(PARAMETER_PROBLEM, "double --probability");
-		prob = strtod(optarg, NULL);
-		if (prob < 0 || prob > 1)
-			xtables_error(PARAMETER_PROBLEM,
-				   "--probability must be between 0 and 1");
-		info->u.random.probability = lround(0x80000000 * prob);
-		*flags |= 0x2;
+	case O_PROBABILITY:
+		info->u.random.probability = lround(0x80000000 * cb->val.dbl);
 		break;
-	case '3':
-		if (*flags & 0x4)
-			xtables_error(PARAMETER_PROBLEM, "double --every");
-		if (!xtables_strtoui(optarg, NULL, &val, 0, UINT32_MAX))
-			xtables_error(PARAMETER_PROBLEM,
-				   "cannot parse --every `%s'", optarg);
-		info->u.nth.every = val;
-		if (info->u.nth.every == 0)
-			xtables_error(PARAMETER_PROBLEM, "--every cannot be 0");
-		info->u.nth.every--;
-		*flags |= 0x4;
-		break;
-	case '4':
-		if (*flags & 0x8)
-			xtables_error(PARAMETER_PROBLEM, "double --packet");
-		if (!xtables_strtoui(optarg, NULL, &val, 0, UINT32_MAX))
-			xtables_error(PARAMETER_PROBLEM,
-				   "cannot parse --packet `%s'", optarg);
-		info->u.nth.packet = val;
-		*flags |= 0x8;
+	case O_EVERY:
+		--info->u.nth.every;
 		break;
 	}
-	return 1;
 }
 
-static void statistic_check(unsigned int flags)
+static void statistic_check(struct xt_fcheck_call *cb)
 {
-	if (!(flags & 0x1))
-		xtables_error(PARAMETER_PROBLEM, "no mode specified");
-	if ((flags & 0x2) && (flags & (0x4 | 0x8)))
-		xtables_error(PARAMETER_PROBLEM,
-			   "both nth and random parameters given");
-	if (flags & 0x2 && global_info->mode != XT_STATISTIC_MODE_RANDOM)
-		xtables_error(PARAMETER_PROBLEM,
-			   "--probability can only be used in random mode");
-	if (flags & 0x4 && global_info->mode != XT_STATISTIC_MODE_NTH)
-		xtables_error(PARAMETER_PROBLEM,
-			   "--every can only be used in nth mode");
-	if (flags & 0x8 && global_info->mode != XT_STATISTIC_MODE_NTH)
+	struct xt_statistic_info *info = cb->data;
+
+	if (info->mode == XT_STATISTIC_MODE_RANDOM &&
+	    !(cb->xflags & F_PROBABILITY))
 		xtables_error(PARAMETER_PROBLEM,
-			   "--packet can only be used in nth mode");
-	if ((flags & 0x8) && !(flags & 0x4))
+			"--probability must be specified when using "
+			"random mode");
+	if (info->mode == XT_STATISTIC_MODE_NTH &&
+	    !(cb->xflags & (F_EVERY | F_PACKET)))
 		xtables_error(PARAMETER_PROBLEM,
-			   "--packet can only be used with --every");
+			"--every and --packet must be specified when "
+			"using nth mode");
+
 	/* at this point, info->u.nth.every have been decreased. */
-	if (global_info->u.nth.packet > global_info->u.nth.every)
+	if (info->u.nth.packet > info->u.nth.every)
 		xtables_error(PARAMETER_PROBLEM,
 			  "the --packet p must be 0 <= p <= n-1");
 
-
-	global_info->u.nth.count = global_info->u.nth.every -
-	                           global_info->u.nth.packet;
+	info->u.nth.count = info->u.nth.every - info->u.nth.packet;
 }
 
 static void print_match(const struct xt_statistic_info *info, char *prefix)
@@ -166,13 +135,12 @@ static struct xtables_match statistic_match = {
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_statistic_info)),
 	.userspacesize	= offsetof(struct xt_statistic_info, u.nth.count),
-	.init		= statistic_mt_init,
 	.help		= statistic_help,
-	.parse		= statistic_parse,
-	.final_check	= statistic_check,
+	.x6_parse	= statistic_parse,
+	.x6_fcheck	= statistic_check,
 	.print		= statistic_print,
 	.save		= statistic_save,
-	.extra_opts	= statistic_opts,
+	.x6_options	= statistic_opts,
 };
 
 void _init(void)
-- 
1.7.1

