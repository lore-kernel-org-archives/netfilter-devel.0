From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 12/13] libxt_IDLETIMER: use guided option parser
Date: Mon,  9 May 2011 11:37:10 +0200
Message-ID: <1304933832-16412-13-git-send-email-jengelh@medozas.de>
References: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51693 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1EIJh2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:37:28 -0400
In-Reply-To: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_IDLETIMER.c |   70 +++++++----------------------------------
 1 files changed, 12 insertions(+), 58 deletions(-)

diff --git a/extensions/libxt_IDLETIMER.c b/extensions/libxt_IDLETIMER.c
index 847ab18..21004a4 100644
--- a/extensions/libxt_IDLETIMER.c
+++ b/extensions/libxt_IDLETIMER.c
@@ -20,26 +20,24 @@
  * 02110-1301 USA
  *
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <stddef.h>
-
 #include <xtables.h>
 #include <linux/netfilter/xt_IDLETIMER.h>
 
 enum {
-	IDLETIMER_TG_OPT_TIMEOUT = 1 << 0,
-	IDLETIMER_TG_OPT_LABEL	 = 1 << 1,
+	O_TIMEOUT = 0,
+	O_LABEL,
 };
 
-static const struct option idletimer_tg_opts[] = {
-	{.name = "timeout", .has_arg = true, .val = 't'},
-	{.name = "label",   .has_arg = true, .val = 'l'},
-	XT_GETOPT_TABLEEND,
+#define s struct idletimer_tg_info
+static const struct xt_option_entry idletimer_tg_opts[] = {
+	{.name = "timeout", .id = O_TIMEOUT, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, timeout)},
+	{.name = "label", .id = O_LABEL, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, label)},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 static void idletimer_tg_help(void)
 {
@@ -50,49 +48,6 @@ static void idletimer_tg_help(void)
 "\n");
 }
 
-static int idletimer_tg_parse(int c, char **argv, int invert,
-			      unsigned int *flags,
-			      const void *entry,
-			      struct xt_entry_target **target)
-{
-	struct idletimer_tg_info *info =
-		(struct idletimer_tg_info *)(*target)->data;
-
-	switch (c) {
-	case 't':
-		xtables_param_act(XTF_ONLY_ONCE, "IDLETIMER", "--timeout",
-				  *flags & IDLETIMER_TG_OPT_TIMEOUT);
-
-		info->timeout = atoi(optarg);
-		*flags |= IDLETIMER_TG_OPT_TIMEOUT;
-		break;
-
-	case 'l':
-		xtables_param_act(XTF_ONLY_ONCE, "IDLETIMER", "--label",
-				  *flags & IDLETIMER_TG_OPT_TIMEOUT);
-
-		if (strlen(optarg) > MAX_IDLETIMER_LABEL_SIZE - 1)
-			xtables_param_act(XTF_BAD_VALUE, "IDLETIMER", "--label",
-					 optarg);
-
-		strcpy(info->label, optarg);
-		*flags |= IDLETIMER_TG_OPT_LABEL;
-		break;
-	}
-
-	return true;
-}
-
-static void idletimer_tg_final_check(unsigned int flags)
-{
-	if (!(flags & IDLETIMER_TG_OPT_TIMEOUT))
-		xtables_error(PARAMETER_PROBLEM, "IDLETIMER target: "
-			      "--timeout parameter required");
-	if (!(flags & IDLETIMER_TG_OPT_LABEL))
-		xtables_error(PARAMETER_PROBLEM, "IDLETIMER target: "
-			      "--label parameter required");
-}
-
 static void idletimer_tg_print(const void *ip,
 			       const struct xt_entry_target *target,
 			       int numeric)
@@ -122,11 +77,10 @@ static struct xtables_target idletimer_tg_reg = {
 	.size	       = XT_ALIGN(sizeof(struct idletimer_tg_info)),
 	.userspacesize = offsetof(struct idletimer_tg_info, timer),
 	.help	       = idletimer_tg_help,
-	.parse	       = idletimer_tg_parse,
-	.final_check   = idletimer_tg_final_check,
+	.x6_parse      = xtables_option_parse,
 	.print	       = idletimer_tg_print,
 	.save	       = idletimer_tg_save,
-	.extra_opts    = idletimer_tg_opts,
+	.x6_options    = idletimer_tg_opts,
 };
 
 void _init(void)
-- 
1.7.1

