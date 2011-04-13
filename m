From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 16/26] libxt_CT: use guided option parser
Date: Wed, 13 Apr 2011 18:13:37 +0200
Message-ID: <1302711228-15947-17-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42461 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933070Ab1DMQOH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:07 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_CT.c |   74 ++++++++++++++++++------------------------------
 1 files changed, 28 insertions(+), 46 deletions(-)

diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
index 38ee17b..7b93bfa 100644
--- a/extensions/libxt_CT.c
+++ b/extensions/libxt_CT.c
@@ -1,9 +1,5 @@
-#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
-#include <stdlib.h>
-#include <stddef.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/xt_CT.h>
@@ -20,22 +16,26 @@ static void ct_help(void)
 	);
 }
 
-enum ct_options {
-	CT_OPT_NOTRACK		= 0x1,
-	CT_OPT_HELPER		= 0x2,
-	CT_OPT_CTEVENTS		= 0x4,
-	CT_OPT_EXPEVENTS	= 0x8,
-	CT_OPT_ZONE		= 0x10,
+enum {
+	O_NOTRACK = 0,
+	O_HELPER,
+	O_CTEVENTS,
+	O_EXPEVENTS,
+	O_ZONE,
 };
 
-static const struct option ct_opts[] = {
-	{.name = "notrack",	.has_arg = false, .val = CT_OPT_NOTRACK},
-	{.name = "helper",	.has_arg = true,  .val = CT_OPT_HELPER},
-	{.name = "ctevents",	.has_arg = true,  .val = CT_OPT_CTEVENTS},
-	{.name = "expevents",	.has_arg = true,  .val = CT_OPT_EXPEVENTS},
-	{.name = "zone",	.has_arg = true,  .val = CT_OPT_ZONE},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_ct_target_info
+static const struct xt_option_entry ct_opts[] = {
+	{.name = "notrack", .id = O_NOTRACK, .type = XTTYPE_NONE},
+	{.name = "helper", .id = O_HELPER, .type = XTTYPE_STRING,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, helper)},
+	{.name = "ctevents", .id = O_CTEVENTS, .type = XTTYPE_STRING},
+	{.name = "expevents", .id = O_EXPEVENTS, .type = XTTYPE_STRING},
+	{.name = "zone", .id = O_ZONE, .type = XTTYPE_UINT16,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, zone)},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 struct event_tbl {
 	const char	*name;
@@ -96,40 +96,22 @@ static void ct_print_events(const char *pfx, const struct event_tbl *tbl,
 	}
 }
 
-static int ct_parse(int c, char **argv, int invert, unsigned int *flags,
-		    const void *entry, struct xt_entry_target **target)
+static void ct_parse(struct xt_option_call *cb)
 {
-	struct xt_ct_target_info *info = (struct xt_ct_target_info *)(*target)->data;
-	unsigned int zone;
+	struct xt_ct_target_info *info = cb->data;
 
-	switch (c) {
-	case CT_OPT_NOTRACK:
-		xtables_param_act(XTF_ONLY_ONCE, "CT", "--notrack", *flags & CT_OPT_NOTRACK);
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_NOTRACK:
 		info->flags |= XT_CT_NOTRACK;
 		break;
-	case CT_OPT_HELPER:
-		xtables_param_act(XTF_ONLY_ONCE, "CT", "--helper", *flags & CT_OPT_HELPER);
-		strncpy(info->helper, optarg, sizeof(info->helper));
-		info->helper[sizeof(info->helper) - 1] = '\0';
+	case O_CTEVENTS:
+		info->ct_events = ct_parse_events(ct_event_tbl, ARRAY_SIZE(ct_event_tbl), cb->arg);
 		break;
-	case CT_OPT_CTEVENTS:
-		xtables_param_act(XTF_ONLY_ONCE, "CT", "--ctevents", *flags & CT_OPT_CTEVENTS);
-		info->ct_events = ct_parse_events(ct_event_tbl, ARRAY_SIZE(ct_event_tbl), optarg);
-		break;
-	case CT_OPT_EXPEVENTS:
-		xtables_param_act(XTF_ONLY_ONCE, "CT", "--expevents", *flags & CT_OPT_EXPEVENTS);
-		info->exp_events = ct_parse_events(exp_event_tbl, ARRAY_SIZE(exp_event_tbl), optarg);
-		break;
-	case CT_OPT_ZONE:
-		xtables_param_act(XTF_ONLY_ONCE, "CT", "--zone", *flags & CT_OPT_ZONE);
-		if (!xtables_strtoui(optarg, NULL, &zone, 0, UINT16_MAX))
-			xtables_error(PARAMETER_PROBLEM, "Bad zone value \"%s\"", optarg);
-		info->zone = zone;
+	case O_EXPEVENTS:
+		info->exp_events = ct_parse_events(exp_event_tbl, ARRAY_SIZE(exp_event_tbl), cb->arg);
 		break;
 	}
-
-	*flags |= c;
-	return 1;
 }
 
 static void ct_print(const void *ip, const struct xt_entry_target *target, int numeric)
@@ -178,10 +160,10 @@ static struct xtables_target ct_target = {
 	.size		= XT_ALIGN(sizeof(struct xt_ct_target_info)),
 	.userspacesize	= offsetof(struct xt_ct_target_info, ct),
 	.help		= ct_help,
-	.parse		= ct_parse,
 	.print		= ct_print,
 	.save		= ct_save,
-	.extra_opts	= ct_opts,
+	.x6_parse	= ct_parse,
+	.x6_options	= ct_opts,
 };
 
 void _init(void)
-- 
1.7.1

