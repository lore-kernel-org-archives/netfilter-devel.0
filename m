From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 17/28] libxt_CLASSIFY: use guided option parser
Date: Tue, 12 Apr 2011 16:23:32 +0200
Message-ID: <1302618224-9449-18-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54671 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756352Ab1DLOYE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:04 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_CLASSIFY.c |   55 +++++++++++-------------------------------
 1 files changed, 15 insertions(+), 40 deletions(-)

diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index e9a0365..ee0f9e1 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -1,16 +1,12 @@
-/* Shared library add-on to iptables to add CLASSIFY target support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
-#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CLASSIFY.h>
-#include <linux/types.h>
 #include <linux/pkt_sched.h>
 
+enum {
+	O_SET_CLASS = 0,
+};
+
 static void
 CLASSIFY_help(void)
 {
@@ -19,9 +15,10 @@ CLASSIFY_help(void)
 "--set-class MAJOR:MINOR    Set skb->priority value (always hexadecimal!)\n");
 }
 
-static const struct option CLASSIFY_opts[] = {
-	{.name = "set-class", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry CLASSIFY_opts[] = {
+	{.name = "set-class", .id = O_SET_CLASS, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND},
+	XTOPT_TABLEEND,
 };
 
 static int CLASSIFY_string_to_priority(const char *s, unsigned int *p)
@@ -35,35 +32,14 @@ static int CLASSIFY_string_to_priority(const char *s, unsigned int *p)
 	return 0;
 }
 
-static int
-CLASSIFY_parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static void CLASSIFY_parse(struct xt_option_call *cb)
 {
-	struct xt_classify_target_info *clinfo
-		= (struct xt_classify_target_info *)(*target)->data;
-
-	switch (c) {
-	case '1':
-		if (CLASSIFY_string_to_priority(optarg, &clinfo->priority))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Bad class value `%s'", optarg);
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-			           "CLASSIFY: Can't specify --set-class twice");
-		*flags = 1;
-		break;
-	}
+	struct xt_classify_target_info *clinfo = cb->data;
 
-	return 1;
-}
-
-static void
-CLASSIFY_final_check(unsigned int flags)
-{
-	if (!flags)
+	xtables_option_parse(cb);
+	if (CLASSIFY_string_to_priority(cb->arg, &clinfo->priority))
 		xtables_error(PARAMETER_PROBLEM,
-		           "CLASSIFY: Parameter --set-class is required");
+			   "Bad class value \"%s\"", cb->arg);
 }
 
 static void
@@ -100,11 +76,10 @@ static struct xtables_target classify_target = {
 	.size		= XT_ALIGN(sizeof(struct xt_classify_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_classify_target_info)),
 	.help		= CLASSIFY_help,
-	.parse		= CLASSIFY_parse,
-	.final_check	= CLASSIFY_final_check,
 	.print		= CLASSIFY_print,
 	.save		= CLASSIFY_save,
-	.extra_opts	= CLASSIFY_opts,
+	.x6_parse	= CLASSIFY_parse,
+	.x6_options	= CLASSIFY_opts,
 };
 
 void _init(void)
-- 
1.7.1

