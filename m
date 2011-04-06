From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/10] libxt_CONNSECMARK: use guided option parser
Date: Wed,  6 Apr 2011 13:31:13 +0200
Message-ID: <1302089478-15022-7-git-send-email-jengelh@medozas.de>
References: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46496 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab1DFLb1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:31:27 -0400
In-Reply-To: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_CONNSECMARK.c |   59 +++++++++++++++------------------------
 1 files changed, 23 insertions(+), 36 deletions(-)

diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECMARK.c
index 6b161f3..df2e6b8 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -5,16 +5,19 @@
  *
  * Copyright (C) 2006 Red Hat, Inc., James Morris <jmorris@redhat.com>
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_CONNSECMARK.h>
 
 #define PFX "CONNSECMARK target: "
 
+enum {
+	O_SAVE = 0,
+	O_RESTORE,
+	F_SAVE    = 1 << O_SAVE,
+	F_RESTORE = 1 << O_RESTORE,
+};
+
 static void CONNSECMARK_help(void)
 {
 	printf(
@@ -23,48 +26,32 @@ static void CONNSECMARK_help(void)
 "  --restore                Copy security mark from connection to packet\n");
 }
 
-static const struct option CONNSECMARK_opts[] = {
-	{.name = "save",    .has_arg = false, .val = '1'},
-	{.name = "restore", .has_arg = false, .val = '2'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry CONNSECMARK_opts[] = {
+	{.name = "save", .id = O_SAVE, .excl = F_RESTORE, .type = XTTYPE_NONE},
+	{.name = "restore", .id = O_RESTORE, .excl = F_SAVE,
+	 .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
 
-static int
-CONNSECMARK_parse(int c, char **argv, int invert, unsigned int *flags,
-                  const void *entry, struct xt_entry_target **target)
+static void CONNSECMARK_parse(struct xt_option_call *cb)
 {
-	struct xt_connsecmark_target_info *info =
-		(struct xt_connsecmark_target_info*)(*target)->data;
+	struct xt_connsecmark_target_info *info = cb->data;
 
-	switch (c) {
-	case '1':
-		if (*flags & CONNSECMARK_SAVE)
-			xtables_error(PARAMETER_PROBLEM, PFX
-				   "Can't specify --save twice");
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SAVE:
 		info->mode = CONNSECMARK_SAVE;
-		*flags |= CONNSECMARK_SAVE;
 		break;
-
-	case '2':
-		if (*flags & CONNSECMARK_RESTORE)
-			xtables_error(PARAMETER_PROBLEM, PFX
-				   "Can't specify --restore twice");
+	case O_RESTORE:
 		info->mode = CONNSECMARK_RESTORE;
-		*flags |= CONNSECMARK_RESTORE;
 		break;
 	}
-
-	return 1;
 }
 
-static void CONNSECMARK_check(unsigned int flags)
+static void CONNSECMARK_check(struct xt_fcheck_call *cb)
 {
-	if (!flags)
+	if (cb->xflags == 0)
 		xtables_error(PARAMETER_PROBLEM, PFX "parameter required");
-
-	if (flags == (CONNSECMARK_SAVE|CONNSECMARK_RESTORE))
-		xtables_error(PARAMETER_PROBLEM, PFX "only one flag of --save "
-		           "or --restore is allowed");
 }
 
 static void print_connsecmark(const struct xt_connsecmark_target_info *info)
@@ -111,12 +98,12 @@ static struct xtables_target connsecmark_target = {
 	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
-	.parse		= CONNSECMARK_parse,
 	.help		= CONNSECMARK_help,
-	.final_check	= CONNSECMARK_check,
 	.print		= CONNSECMARK_print,
 	.save		= CONNSECMARK_save,
-	.extra_opts	= CONNSECMARK_opts,
+	.x6_parse	= CONNSECMARK_parse,
+	.x6_fcheck	= CONNSECMARK_check,
+	.x6_options	= CONNSECMARK_opts,
 };
 
 void _init(void)
-- 
1.7.1

