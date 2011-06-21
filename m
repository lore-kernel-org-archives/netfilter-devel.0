From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/7] libxt_RATEEST: use guided option parser
Date: Tue, 21 Jun 2011 17:53:30 +0200
Message-ID: <1308671615-17505-4-git-send-email-jengelh@medozas.de>
References: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40644 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743Ab1FUPxk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:53:40 -0400
In-Reply-To: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_RATEEST.c |   94 ++++++++++++++------------------------------
 1 files changed, 30 insertions(+), 64 deletions(-)

diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index 6369e9e..b928b33 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -1,9 +1,6 @@
-#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-#include <stddef.h>
-#include <getopt.h>
 #include <math.h>
 
 #include <xtables.h>
@@ -11,7 +8,6 @@
 #include <linux/netfilter/xt_RATEEST.h>
 
 /* hack to pass raw values to final_check */
-static struct xt_rateest_target_info *RATEEST_info;
 static unsigned int interval;
 static unsigned int ewma_log;
 
@@ -25,18 +21,23 @@ RATEEST_help(void)
 "  --rateest-ewmalog value	Rate measurement averaging time constant\n");
 }
 
-enum RATEEST_options {
-	RATEEST_OPT_NAME,
-	RATEEST_OPT_INTERVAL,
-	RATEEST_OPT_EWMALOG,
+enum {
+	O_NAME = 0,
+	O_INTERVAL,
+	O_EWMALOG,
 };
 
-static const struct option RATEEST_opts[] = {
-	{.name = "rateest-name",     .has_arg = true, .val = RATEEST_OPT_NAME},
-	{.name = "rateest-interval", .has_arg = true, .val = RATEEST_OPT_INTERVAL},
-	{.name = "rateest-ewmalog",  .has_arg = true, .val = RATEEST_OPT_EWMALOG},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_rateest_target_info
+static const struct xt_option_entry RATEEST_opts[] = {
+	{.name = "rateest-name", .id = O_NAME, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, name)},
+	{.name = "rateest-interval", .id = O_INTERVAL, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND},
+	{.name = "rateest-ewmalog", .id = O_EWMALOG, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 /* Copied from iproute */
 #define TIME_UNITS_PER_SEC	1000000
@@ -82,63 +83,28 @@ RATEEST_print_time(unsigned int time)
 		printf(" %uus", time);
 }
 
-static int
-RATEEST_parse(int c, char **argv, int invert, unsigned int *flags,
-	      const void *entry, struct xt_entry_target **target)
+static void RATEEST_parse(struct xt_option_call *cb)
 {
-	struct xt_rateest_target_info *info = (void *)(*target)->data;
-
-	RATEEST_info = info;
-
-	switch (c) {
-	case RATEEST_OPT_NAME:
-		if (*flags & (1 << c))
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_INTERVAL:
+		if (RATEEST_get_time(&interval, cb->arg) < 0)
 			xtables_error(PARAMETER_PROBLEM,
-				   "RATEEST: can't specify --rateest-name twice");
-		*flags |= 1 << c;
-
-		strncpy(info->name, optarg, sizeof(info->name) - 1);
+				   "RATEEST: bad interval value \"%s\"",
+				   cb->arg);
 		break;
-
-	case RATEEST_OPT_INTERVAL:
-		if (*flags & (1 << c))
+	case O_EWMALOG:
+		if (RATEEST_get_time(&ewma_log, cb->arg) < 0)
 			xtables_error(PARAMETER_PROBLEM,
-				   "RATEEST: can't specify --rateest-interval twice");
-		*flags |= 1 << c;
-
-		if (RATEEST_get_time(&interval, optarg) < 0)
-			xtables_error(PARAMETER_PROBLEM,
-				   "RATEEST: bad interval value `%s'", optarg);
-
-		break;
-
-	case RATEEST_OPT_EWMALOG:
-		if (*flags & (1 << c))
-			xtables_error(PARAMETER_PROBLEM,
-				   "RATEEST: can't specify --rateest-ewmalog twice");
-		*flags |= 1 << c;
-
-		if (RATEEST_get_time(&ewma_log, optarg) < 0)
-			xtables_error(PARAMETER_PROBLEM,
-				   "RATEEST: bad ewmalog value `%s'", optarg);
-
+				   "RATEEST: bad ewmalog value \"%s\"",
+				   cb->arg);
 		break;
 	}
-
-	return 1;
 }
 
-static void
-RATEEST_final_check(unsigned int flags)
+static void RATEEST_final_check(struct xt_fcheck_call *cb)
 {
-	struct xt_rateest_target_info *info = RATEEST_info;
-
-	if (!(flags & (1 << RATEEST_OPT_NAME)))
-		xtables_error(PARAMETER_PROBLEM, "RATEEST: no name specified");
-	if (!(flags & (1 << RATEEST_OPT_INTERVAL)))
-		xtables_error(PARAMETER_PROBLEM, "RATEEST: no interval specified");
-	if (!(flags & (1 << RATEEST_OPT_EWMALOG)))
-		xtables_error(PARAMETER_PROBLEM, "RATEEST: no ewmalog specified");
+	struct xt_rateest_target_info *info = cb->data;
 
 	for (info->interval = 0; info->interval <= 5; info->interval++) {
 		if (interval <= (1 << info->interval) * (TIME_UNITS_PER_SEC / 4))
@@ -199,11 +165,11 @@ static struct xtables_target rateest_tg_reg = {
 	.size		= XT_ALIGN(sizeof(struct xt_rateest_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_rateest_target_info)),
 	.help		= RATEEST_help,
-	.parse		= RATEEST_parse,
-	.final_check	= RATEEST_final_check,
+	.x6_parse	= RATEEST_parse,
+	.x6_fcheck	= RATEEST_final_check,
 	.print		= RATEEST_print,
 	.save		= RATEEST_save,
-	.extra_opts	= RATEEST_opts,
+	.x6_options	= RATEEST_opts,
 };
 
 void _init(void)
-- 
1.7.3.4

