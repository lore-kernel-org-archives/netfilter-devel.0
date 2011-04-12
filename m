From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 23/28] libxt_helper: use guided option parser
Date: Tue, 12 Apr 2011 16:23:38 +0200
Message-ID: <1302618224-9449-24-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54691 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380Ab1DLOYL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:11 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_helper.c |   54 +++++++++++++-------------------------------
 1 files changed, 16 insertions(+), 38 deletions(-)

diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 1761b4d..c9f9435 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -1,14 +1,11 @@
-/* Shared library add-on to iptables to add related packet matching support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
 #include <linux/netfilter/xt_helper.h>
 
+enum {
+	O_HELPER = 0,
+};
+
 static void helper_help(void)
 {
 	printf(
@@ -16,38 +13,20 @@ static void helper_help(void)
 "[!] --helper string        Match helper identified by string\n");
 }
 
-static const struct option helper_opts[] = {
-	{.name = "helper", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry helper_opts[] = {
+	{.name = "helper", .id = O_HELPER, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_INVERT | XTOPT_PUT,
+	 XTOPT_POINTER(struct xt_helper_info, name)},
+	XTOPT_TABLEEND,
 };
 
-static int
-helper_parse(int c, char **argv, int invert, unsigned int *flags,
-             const void *entry, struct xt_entry_match **match)
+static void helper_parse(struct xt_option_call *cb)
 {
-	struct xt_helper_info *info = (struct xt_helper_info *)(*match)->data;
+	struct xt_helper_info *info = cb->data;
 
-	switch (c) {
-	case '1':
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-					"helper match: Only use --helper ONCE!");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		strncpy(info->name, optarg, 29);
-		info->name[29] = '\0';
-		if (invert)
-			info->invert = 1;
-		*flags = 1;
-		break;
-	}
-	return 1;
-}
-
-static void helper_check(unsigned int flags)
-{
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM,
-			   "helper match: You must specify `--helper'");
+	xtables_option_parse(cb);
+	if (cb->invert)
+		info->invert = 1;
 }
 
 static void
@@ -72,11 +51,10 @@ static struct xtables_match helper_match = {
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_helper_info)),
 	.help		= helper_help,
-	.parse		= helper_parse,
-	.final_check	= helper_check,
 	.print		= helper_print,
 	.save		= helper_save,
-	.extra_opts	= helper_opts,
+	.x6_parse	= helper_parse,
+	.x6_options	= helper_opts,
 };
 
 void _init(void)
-- 
1.7.1

