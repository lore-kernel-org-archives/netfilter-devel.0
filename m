From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/10] libxt_CHECKSUM: use guided option parser
Date: Wed,  6 Apr 2011 13:31:10 +0200
Message-ID: <1302089478-15022-4-git-send-email-jengelh@medozas.de>
References: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46485 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab1DFLbY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:31:24 -0400
In-Reply-To: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_CHECKSUM.c |   46 +++++++++++++-----------------------------
 1 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/extensions/libxt_CHECKSUM.c b/extensions/libxt_CHECKSUM.c
index 83b3d69..df9f9b3 100644
--- a/extensions/libxt_CHECKSUM.c
+++ b/extensions/libxt_CHECKSUM.c
@@ -8,15 +8,14 @@
  *
  * libxt_CHECKSUM.c borrowed some bits from libipt_ECN.c
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
 #include <linux/netfilter/xt_CHECKSUM.h>
 
+enum {
+	O_CHECKSUM_FILL = 0,
+};
+
 static void CHECKSUM_help(void)
 {
 	printf(
@@ -24,34 +23,18 @@ static void CHECKSUM_help(void)
 "  --checksum-fill			Fill in packet checksum.\n");
 }
 
-static const struct option CHECKSUM_opts[] = {
-	{.name = "checksum-fill", .has_arg = false, .val = 'F'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry CHECKSUM_opts[] = {
+	{.name = "checksum-fill", .id = O_CHECKSUM_FILL,
+	 .flags = XTOPT_MAND, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
 
-static int CHECKSUM_parse(int c, char **argv, int invert, unsigned int *flags,
-                     const void *entry, struct xt_entry_target **target)
+static void CHECKSUM_parse(struct xt_option_call *cb)
 {
-	struct xt_CHECKSUM_info *einfo
-		= (struct xt_CHECKSUM_info *)(*target)->data;
-
-	switch (c) {
-	case 'F':
-		xtables_param_act(XTF_ONLY_ONCE, "CHECKSUM", "--checksum-fill",
-			*flags & XT_CHECKSUM_OP_FILL);
-		einfo->operation = XT_CHECKSUM_OP_FILL;
-		*flags |= XT_CHECKSUM_OP_FILL;
-		break;
-	}
+	struct xt_CHECKSUM_info *einfo = cb->data;
 
-	return 1;
-}
-
-static void CHECKSUM_check(unsigned int flags)
-{
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM,
-		           "CHECKSUM target: Parameter --checksum-fill is required");
+	xtables_option_parse(cb);
+	einfo->operation = XT_CHECKSUM_OP_FILL;
 }
 
 static void CHECKSUM_print(const void *ip, const struct xt_entry_target *target,
@@ -82,11 +65,10 @@ static struct xtables_target checksum_tg_reg = {
 	.size		= XT_ALIGN(sizeof(struct xt_CHECKSUM_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_CHECKSUM_info)),
 	.help		= CHECKSUM_help,
-	.parse		= CHECKSUM_parse,
-	.final_check	= CHECKSUM_check,
 	.print		= CHECKSUM_print,
 	.save		= CHECKSUM_save,
-	.extra_opts	= CHECKSUM_opts,
+	.x6_parse	= CHECKSUM_parse,
+	.x6_options	= CHECKSUM_opts,
 };
 
 void _init(void)
-- 
1.7.1

