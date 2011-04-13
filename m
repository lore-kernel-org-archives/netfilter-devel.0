From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 17/26] libxt_NFQUEUE: use guided option parser
Date: Wed, 13 Apr 2011 18:13:38 +0200
Message-ID: <1302711228-15947-18-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42466 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933072Ab1DMQOJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:09 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_NFQUEUE.c |  139 +++++++++++++++-----------------------------
 1 files changed, 47 insertions(+), 92 deletions(-)

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 7f2aab1..a86c88a 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -5,16 +5,16 @@
  * This program is distributed under the terms of GNU GPL v2, 1991
  *
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
-#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_NFQUEUE.h>
 
+enum {
+	O_QUEUE_NUM = 0,
+	O_QUEUE_BALANCE,
+	O_QUEUE_BYPASS,
+};
+
 static void NFQUEUE_help(void)
 {
 	printf(
@@ -38,103 +38,58 @@ static void NFQUEUE_help_v2(void)
 "  --queue-bypass		Bypass Queueing if no queue instance exists.\n");
 }
 
-static const struct option NFQUEUE_opts[] = {
-	{.name = "queue-num",     .has_arg = true, .val = 'F'},
-	{.name = "queue-balance", .has_arg = true, .val = 'B'},
-	{.name = "queue-bypass",  .has_arg = false,.val = 'P'},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_NFQ_info
+static const struct xt_option_entry NFQUEUE_opts[] = {
+	{.name = "queue-num", .id = O_QUEUE_NUM, .type = XTTYPE_UINT16,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, queuenum)},
+	{.name = "queue-balance", .id = O_QUEUE_BALANCE,
+	 .type = XTTYPE_UINT16RC},
+	{.name = "queue-bypass", .id = O_QUEUE_BYPASS, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
+#undef s
 
-static void exit_badqueue(const char *s)
-{
-	xtables_error(PARAMETER_PROBLEM, "Invalid queue number `%s'\n", s);
-}
-
-static void
-parse_num(const char *s, struct xt_NFQ_info *tinfo)
+static void NFQUEUE_parse(struct xt_option_call *cb)
 {
-	unsigned int num;
-
-	if (!xtables_strtoui(s, NULL, &num, 0, UINT16_MAX))
-		exit_badqueue(s);
-
-	tinfo->queuenum = num;
-}
-
-static int
-NFQUEUE_parse(int c, char **argv, int invert, unsigned int *flags,
-              const void *entry, struct xt_entry_target **target)
-{
-	struct xt_NFQ_info *tinfo
-		= (struct xt_NFQ_info *)(*target)->data;
-
-	switch (c) {
-	case 'F':
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM, "NFQUEUE target: "
-				   "Only use --queue-num ONCE!");
-		parse_num(optarg, tinfo);
-		break;
-	case 'B':
+	xtables_option_parse(cb);
+	if (cb->entry->id == O_QUEUE_BALANCE)
 		xtables_error(PARAMETER_PROBLEM, "NFQUEUE target: "
 				   "--queue-balance not supported (kernel too old?)");
-	}
-
-	return 1;
 }
 
-static int
-NFQUEUE_parse_v1(int c, char **argv, int invert, unsigned int *flags,
-                 const void *entry, struct xt_entry_target **target)
+static void NFQUEUE_parse_v1(struct xt_option_call *cb)
 {
-	struct xt_NFQ_info_v1 *info = (void *)(*target)->data;
-	char *colon;
-	unsigned int firstqueue, lastqueue;
-
-	switch (c) {
-	case 'F': /* fallthrough */
-	case 'B':
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM, "NFQUEUE target: "
-				   "Only use --queue-num ONCE!");
-
-		if (!xtables_strtoui(optarg, &colon, &firstqueue, 0, UINT16_MAX))
-			exit_badqueue(optarg);
-
-		info->queuenum = firstqueue;
-
-		if (c == 'F') {
-			if (*colon)
-				exit_badqueue(optarg);
-			break;
-		}
+	struct xt_NFQ_info_v1 *info = cb->data;
+	const uint16_t *r = cb->val.u16_range;
 
-		if (*colon != ':')
-			xtables_error(PARAMETER_PROBLEM, "Bad range \"%s\"", optarg);
-
-		if (!xtables_strtoui(colon + 1, NULL, &lastqueue, 1, UINT16_MAX))
-			exit_badqueue(optarg);
-
-		if (firstqueue >= lastqueue)
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_QUEUE_BALANCE:
+		if (cb->nvals != 2)
+			xtables_error(PARAMETER_PROBLEM,
+				"Bad range \"%s\"", cb->arg);
+		if (r[0] >= r[1])
 			xtables_error(PARAMETER_PROBLEM, "%u should be less than %u",
-							firstqueue, lastqueue);
-		info->queues_total = lastqueue - firstqueue + 1;
+				r[0], r[1]);
+		info->queuenum = r[0];
+		info->queues_total = r[1] - r[0] + 1;
 		break;
 	}
-
-	return 1;
 }
 
-static int
-NFQUEUE_parse_v2(int c, char **argv, int invert, unsigned int *flags,
-                 const void *entry, struct xt_entry_target **target)
+static void NFQUEUE_parse_v2(struct xt_option_call *cb)
 {
-	if (c == 'P') {
-		struct xt_NFQ_info_v2 *info = (void *)(*target)->data;
+	struct xt_NFQ_info_v2 *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_QUEUE_BYPASS:
 		info->bypass = 1;
-		return 1;
+		break;
+	default:
+		NFQUEUE_parse_v1(cb);
+		break;
 	}
-	return NFQUEUE_parse_v1(c, argv, invert, flags, entry, target);
 }
 
 static void NFQUEUE_print(const void *ip,
@@ -214,10 +169,10 @@ static struct xtables_target nfqueue_targets[] = {
 	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info)),
 	.help		= NFQUEUE_help,
-	.parse		= NFQUEUE_parse,
 	.print		= NFQUEUE_print,
 	.save		= NFQUEUE_save,
-	.extra_opts	= NFQUEUE_opts
+	.x6_parse	= NFQUEUE_parse,
+	.x6_options	= NFQUEUE_opts
 },{
 	.family		= NFPROTO_UNSPEC,
 	.revision	= 1,
@@ -227,10 +182,10 @@ static struct xtables_target nfqueue_targets[] = {
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info_v1)),
 	.help		= NFQUEUE_help_v1,
 	.init		= NFQUEUE_init_v1,
-	.parse		= NFQUEUE_parse_v1,
 	.print		= NFQUEUE_print_v1,
 	.save		= NFQUEUE_save_v1,
-	.extra_opts	= NFQUEUE_opts,
+	.x6_parse	= NFQUEUE_parse_v1,
+	.x6_options	= NFQUEUE_opts,
 },{
 	.family		= NFPROTO_UNSPEC,
 	.revision	= 2,
@@ -240,10 +195,10 @@ static struct xtables_target nfqueue_targets[] = {
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info_v2)),
 	.help		= NFQUEUE_help_v2,
 	.init		= NFQUEUE_init_v1,
-	.parse		= NFQUEUE_parse_v2,
 	.print		= NFQUEUE_print_v2,
 	.save		= NFQUEUE_save_v2,
-	.extra_opts	= NFQUEUE_opts,
+	.x6_parse	= NFQUEUE_parse_v2,
+	.x6_options	= NFQUEUE_opts,
 }
 };
 
-- 
1.7.1

