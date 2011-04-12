From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 24/28] libxt_physdev: use guided option parser
Date: Tue, 12 Apr 2011 16:23:39 +0200
Message-ID: <1302618224-9449-25-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54695 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451Ab1DLOYM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:12 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_physdev.c |  113 ++++++++++++++++---------------------------
 1 files changed, 42 insertions(+), 71 deletions(-)

diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 1c0de97..8f57fe9 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -1,17 +1,14 @@
-/* Shared library add-on to iptables to add bridge port matching support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <ctype.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_physdev.h>
-#if defined(__GLIBC__) && __GLIBC__ == 2
-#include <net/ethernet.h>
-#else
-#include <linux/if_ether.h>
-#endif
+
+enum {
+	O_PHYSDEV_IN = 0,
+	O_PHYSDEV_OUT,
+	O_PHYSDEV_IS_IN,
+	O_PHYSDEV_IS_OUT,
+	O_PHYSDEV_IS_BRIDGED,
+};
 
 static void physdev_help(void)
 {
@@ -24,88 +21,62 @@ static void physdev_help(void)
 " [!] --physdev-is-bridged		it's a bridged packet\n");
 }
 
-static const struct option physdev_opts[] = {
-	{.name = "physdev-in",         .has_arg = true,  .val = '1'},
-	{.name = "physdev-out",        .has_arg = true,  .val = '2'},
-	{.name = "physdev-is-in",      .has_arg = false, .val = '3'},
-	{.name = "physdev-is-out",     .has_arg = false, .val = '4'},
-	{.name = "physdev-is-bridged", .has_arg = false, .val = '5'},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_physdev_info
+static const struct xt_option_entry physdev_opts[] = {
+	{.name = "physdev-in", .id = O_PHYSDEV_IN, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, physindev)},
+	{.name = "physdev-out", .id = O_PHYSDEV_OUT, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, physoutdev)},
+	{.name = "physdev-is-in", .id = O_PHYSDEV_IS_IN, .type = XTTYPE_NONE},
+	{.name = "physdev-is-out", .id = O_PHYSDEV_IS_OUT,
+	 .type = XTTYPE_NONE},
+	{.name = "physdev-is-bridged", .id = O_PHYSDEV_IS_BRIDGED,
+	 .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
+#undef s
 
-static int
-physdev_parse(int c, char **argv, int invert, unsigned int *flags,
-              const void *entry, struct xt_entry_match **match)
+static void physdev_parse(struct xt_option_call *cb)
 {
-	struct xt_physdev_info *info =
-		(struct xt_physdev_info*)(*match)->data;
+	struct xt_physdev_info *info = cb->data;
 
-	switch (c) {
-	case '1':
-		if (*flags & XT_PHYSDEV_OP_IN)
-			goto multiple_use;
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		xtables_parse_interface(optarg, info->physindev,
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_PHYSDEV_IN:
+		xtables_parse_interface(cb->arg, info->physindev,
 				(unsigned char *)info->in_mask);
-		if (invert)
+		if (cb->invert)
 			info->invert |= XT_PHYSDEV_OP_IN;
 		info->bitmask |= XT_PHYSDEV_OP_IN;
-		*flags |= XT_PHYSDEV_OP_IN;
 		break;
-
-	case '2':
-		if (*flags & XT_PHYSDEV_OP_OUT)
-			goto multiple_use;
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		xtables_parse_interface(optarg, info->physoutdev,
+	case O_PHYSDEV_OUT:
+		xtables_parse_interface(cb->arg, info->physoutdev,
 				(unsigned char *)info->out_mask);
-		if (invert)
+		if (cb->invert)
 			info->invert |= XT_PHYSDEV_OP_OUT;
 		info->bitmask |= XT_PHYSDEV_OP_OUT;
-		*flags |= XT_PHYSDEV_OP_OUT;
 		break;
-
-	case '3':
-		if (*flags & XT_PHYSDEV_OP_ISIN)
-			goto multiple_use;
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
+	case O_PHYSDEV_IS_IN:
 		info->bitmask |= XT_PHYSDEV_OP_ISIN;
-		if (invert)
+		if (cb->invert)
 			info->invert |= XT_PHYSDEV_OP_ISIN;
-		*flags |= XT_PHYSDEV_OP_ISIN;
 		break;
-
-	case '4':
-		if (*flags & XT_PHYSDEV_OP_ISOUT)
-			goto multiple_use;
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
+	case O_PHYSDEV_IS_OUT:
 		info->bitmask |= XT_PHYSDEV_OP_ISOUT;
-		if (invert)
+		if (cb->invert)
 			info->invert |= XT_PHYSDEV_OP_ISOUT;
-		*flags |= XT_PHYSDEV_OP_ISOUT;
 		break;
-
-	case '5':
-		if (*flags & XT_PHYSDEV_OP_BRIDGED)
-			goto multiple_use;
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		if (invert)
+	case O_PHYSDEV_IS_BRIDGED:
+		if (cb->invert)
 			info->invert |= XT_PHYSDEV_OP_BRIDGED;
-		*flags |= XT_PHYSDEV_OP_BRIDGED;
 		info->bitmask |= XT_PHYSDEV_OP_BRIDGED;
 		break;
 	}
-
-	return 1;
-multiple_use:
-	xtables_error(PARAMETER_PROBLEM,
-	   "multiple use of the same physdev option is not allowed");
-
 }
 
-static void physdev_check(unsigned int flags)
+static void physdev_check(struct xt_fcheck_call *cb)
 {
-	if (flags == 0)
+	if (cb->xflags == 0)
 		xtables_error(PARAMETER_PROBLEM, "PHYSDEV: no physdev option specified");
 }
 
@@ -164,11 +135,11 @@ static struct xtables_match physdev_match = {
 	.size		= XT_ALIGN(sizeof(struct xt_physdev_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_physdev_info)),
 	.help		= physdev_help,
-	.parse		= physdev_parse,
-	.final_check	= physdev_check,
 	.print		= physdev_print,
 	.save		= physdev_save,
-	.extra_opts	= physdev_opts,
+	.x6_parse	= physdev_parse,
+	.x6_fcheck	= physdev_check,
+	.x6_options	= physdev_opts,
 };
 
 void _init(void)
-- 
1.7.1

