From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 20/28] libxt_SECMARK: use guided option parser
Date: Tue, 12 Apr 2011 16:23:35 +0200
Message-ID: <1302618224-9449-21-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54682 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426Ab1DLOYH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:07 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_SECMARK.c |   54 ++++++++++++-------------------------------
 1 files changed, 15 insertions(+), 39 deletions(-)

diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 5ad8486..6ba8606 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -5,16 +5,16 @@
  *
  * Copyright (C) 2006 Red Hat, Inc., James Morris <jmorris@redhat.com>
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_SECMARK.h>
 
 #define PFX "SECMARK target: "
 
+enum {
+	O_SELCTX = 0,
+};
+
 static void SECMARK_help(void)
 {
 	printf(
@@ -22,42 +22,19 @@ static void SECMARK_help(void)
 "  --selctx value                     Set the SELinux security context\n");
 }
 
-static const struct option SECMARK_opts[] = {
-	{.name = "selctx", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry SECMARK_opts[] = {
+	{.name = "selctx", .id = O_SELCTX, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_PUT,
+	 XTOPT_POINTER(struct xt_secmark_target_info, secctx)},
+	XTOPT_TABLEEND,
 };
 
-static int SECMARK_parse(int c, char **argv, int invert, unsigned int *flags,
-                         const void *entry, struct xt_entry_target **target)
+static void SECMARK_parse(struct xt_option_call *cb)
 {
-	struct xt_secmark_target_info *info =
-		(struct xt_secmark_target_info*)(*target)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & SECMARK_MODE_SEL)
-			xtables_error(PARAMETER_PROBLEM, PFX
-				   "Can't specify --selctx twice");
-		info->mode = SECMARK_MODE_SEL;
-
-		if (strlen(optarg) > SECMARK_SECCTX_MAX-1)
-			xtables_error(PARAMETER_PROBLEM, PFX
-				   "Maximum length %u exceeded by --selctx"
-				   " parameter (%zu)",
-				   SECMARK_SECCTX_MAX-1, strlen(optarg));
-
-		strcpy(info->secctx, optarg);
-		*flags |= SECMARK_MODE_SEL;
-		break;
-	}
+	struct xt_secmark_target_info *info = cb->data;
 
-	return 1;
-}
-
-static void SECMARK_check(unsigned int flags)
-{
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM, PFX "parameter required");
+	xtables_option_parse(cb);
+	info->mode = SECMARK_MODE_SEL;
 }
 
 static void print_secmark(const struct xt_secmark_target_info *info)
@@ -99,11 +76,10 @@ static struct xtables_target secmark_target = {
 	.size		= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
 	.help		= SECMARK_help,
-	.parse		= SECMARK_parse,
-	.final_check	= SECMARK_check,
 	.print		= SECMARK_print,
 	.save		= SECMARK_save,
-	.extra_opts	= SECMARK_opts,
+	.x6_parse	= SECMARK_parse,
+	.x6_options	= SECMARK_opts,
 };
 
 void _init(void)
-- 
1.7.1

