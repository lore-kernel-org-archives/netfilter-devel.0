From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/26] libxt_quota: use guided option parser
Date: Wed, 13 Apr 2011 18:13:26 +0200
Message-ID: <1302711228-15947-6-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42511 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933046Ab1DMQNz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:55 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_quota.c |   67 ++++++++++-----------------------------------
 1 files changed, 15 insertions(+), 52 deletions(-)

diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index e3699ad..988f404 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -3,18 +3,18 @@
  *
  * Sam Johnston <samj@samj.net>
  */
-#include <stdbool.h>
-#include <stddef.h>
 #include <stdio.h>
-#include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
-
 #include <linux/netfilter/xt_quota.h>
 
-static const struct option quota_opts[] = {
-	{.name = "quota", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+enum {
+	O_QUOTA = 0,
+};
+
+static const struct xt_option_entry quota_opts[] = {
+	{.name = "quota", .id = O_QUOTA, .type = XTTYPE_UINT64,
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
 static void quota_help(void)
@@ -40,49 +40,13 @@ quota_save(const void *ip, const struct xt_entry_match *match)
 	printf(" --quota %llu", (unsigned long long) q->quota);
 }
 
-/* parse quota option */
-static int
-parse_quota(const char *s, uint64_t * quota)
-{
-	*quota = strtoull(s, NULL, 10);
-
-#ifdef DEBUG_XT_QUOTA
-	printf("Quota: %llu\n", *quota);
-#endif
-
-	if (*quota == UINT64_MAX)
-		xtables_error(PARAMETER_PROBLEM, "quota invalid: '%s'\n", s);
-	else
-		return 1;
-}
-
-static int
-quota_parse(int c, char **argv, int invert, unsigned int *flags,
-	    const void *entry, struct xt_entry_match **match)
+static void quota_parse(struct xt_option_call *cb)
 {
-	struct xt_quota_info *info = (struct xt_quota_info *) (*match)->data;
-
-	switch (c) {
-	case '1':
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM, "quota: unexpected '!'");
-		if (!parse_quota(optarg, &info->quota))
-			xtables_error(PARAMETER_PROBLEM,
-				   "bad quota: '%s'", optarg);
+	struct xt_quota_info *info = cb->data;
 
-		if (invert)
-			info->flags |= XT_QUOTA_INVERT;
-		*flags |= 1;
-		break;
-	}
-	return 1;
-}
-
-static void quota_check(unsigned int flags)
-{
-	if (flags == 0)
-		xtables_error(PARAMETER_PROBLEM,
-			"quota: the --quota argument must be specified\n");
+	xtables_option_parse(cb);
+	if (cb->invert)
+		info->flags |= XT_QUOTA_INVERT;
 }
 
 static struct xtables_match quota_match = {
@@ -92,11 +56,10 @@ static struct xtables_match quota_match = {
 	.size		= XT_ALIGN(sizeof (struct xt_quota_info)),
 	.userspacesize	= offsetof(struct xt_quota_info, master),
 	.help		= quota_help,
-	.parse		= quota_parse,
-	.final_check	= quota_check,
 	.print		= quota_print,
 	.save		= quota_save,
-	.extra_opts	= quota_opts,
+	.x6_parse	= quota_parse,
+	.x6_options	= quota_opts,
 };
 
 void
-- 
1.7.1

