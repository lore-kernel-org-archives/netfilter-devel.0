From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 16/28] libxt_AUDIT: use guided option parser
Date: Tue, 12 Apr 2011 16:23:31 +0200
Message-ID: <1302618224-9449-17-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54667 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380Ab1DLOYD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:03 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_AUDIT.c |   66 +++++++++++++++------------------------------
 1 files changed, 22 insertions(+), 44 deletions(-)

diff --git a/extensions/libxt_AUDIT.c b/extensions/libxt_AUDIT.c
index a6ab37f..86a61cb 100644
--- a/extensions/libxt_AUDIT.c
+++ b/extensions/libxt_AUDIT.c
@@ -5,16 +5,15 @@
  *
  * This program is distributed under the terms of GNU GPL v2, 1991
  */
-
-#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
 #include <linux/netfilter/xt_AUDIT.h>
 
+enum {
+	O_AUDIT_TYPE = 0,
+};
+
 static void audit_help(void)
 {
 	printf(
@@ -22,46 +21,26 @@ static void audit_help(void)
 "  --type TYPE		Action type to be recorded.\n");
 }
 
-static const struct option audit_opts[] = {
-	{.name = "type", .has_arg = true, .val = 't'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry audit_opts[] = {
+	{.name = "type", .id = O_AUDIT_TYPE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND},
+	XTOPT_TABLEEND,
 };
 
-static int audit_parse(int c, char **argv, int invert, unsigned int *flags,
-                     const void *entry, struct xt_entry_target **target)
-{
-	struct xt_audit_info *einfo
-		= (struct xt_audit_info *)(*target)->data;
-
-	switch (c) {
-	case 't':
-		if (!strcasecmp(optarg, "accept"))
-			einfo->type = XT_AUDIT_TYPE_ACCEPT;
-		else if (!strcasecmp(optarg, "drop"))
-			einfo->type = XT_AUDIT_TYPE_DROP;
-		else if (!strcasecmp(optarg, "reject"))
-			einfo->type = XT_AUDIT_TYPE_REJECT;
-		else
-			xtables_error(PARAMETER_PROBLEM,
-				   "Bad action type value `%s'", optarg);
-
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-			           "AUDIT: Can't specify --type twice");
-		*flags = 1;
-		break;
-	default:
-		return 0;
-	}
-
-	return 1;
-}
-
-static void audit_final_check(unsigned int flags)
+static void audit_parse(struct xt_option_call *cb)
 {
-	if (!flags)
+	struct xt_audit_info *einfo = cb->data;
+
+	xtables_option_parse(cb);
+	if (strcasecmp(cb->arg, "accept") == 0)
+		einfo->type = XT_AUDIT_TYPE_ACCEPT;
+	else if (strcasecmp(cb->arg, "drop") == 0)
+		einfo->type = XT_AUDIT_TYPE_DROP;
+	else if (strcasecmp(cb->arg, "reject") == 0)
+		einfo->type = XT_AUDIT_TYPE_REJECT;
+	else
 		xtables_error(PARAMETER_PROBLEM,
-		           "AUDIT target: Parameter --type is required");
+			   "Bad action type value \"%s\"", cb->arg);
 }
 
 static void audit_print(const void *ip, const struct xt_entry_target *target,
@@ -110,11 +89,10 @@ static struct xtables_target audit_tg_reg = {
 	.size		= XT_ALIGN(sizeof(struct xt_audit_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_audit_info)),
 	.help		= audit_help,
-	.parse		= audit_parse,
-	.final_check	= audit_final_check,
 	.print		= audit_print,
 	.save		= audit_save,
-	.extra_opts	= audit_opts,
+	.x6_parse	= audit_parse,
+	.x6_options	= audit_opts,
 };
 
 void _init(void)
-- 
1.7.1

