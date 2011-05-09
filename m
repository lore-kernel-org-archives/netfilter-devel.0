From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 13/13] libxt_NFLOG: use guided option parser
Date: Mon,  9 May 2011 11:37:11 +0200
Message-ID: <1304933832-16412-14-git-send-email-jengelh@medozas.de>
References: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51697 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab1EIJh3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:37:29 -0400
In-Reply-To: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_NFLOG.c |   98 +++++++++++----------------------------------
 1 files changed, 24 insertions(+), 74 deletions(-)

diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 61c9741..448576a 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -9,19 +9,25 @@
 #include <linux/netfilter/xt_NFLOG.h>
 
 enum {
-	NFLOG_GROUP	= 0x1,
-	NFLOG_PREFIX	= 0x2,
-	NFLOG_RANGE	= 0x4,
-	NFLOG_THRESHOLD	= 0x8,
+	O_GROUP = 0,
+	O_PREFIX,
+	O_RANGE,
+	O_THRESHOLD,
 };
 
-static const struct option NFLOG_opts[] = {
-	{.name = "nflog-group",     .has_arg = true, .val = NFLOG_GROUP},
-	{.name = "nflog-prefix",    .has_arg = true, .val = NFLOG_PREFIX},
-	{.name = "nflog-range",     .has_arg = true, .val = NFLOG_RANGE},
-	{.name = "nflog-threshold", .has_arg = true, .val = NFLOG_THRESHOLD},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_nflog_info
+static const struct xt_option_entry NFLOG_opts[] = {
+	{.name = "nflog-group", .id = O_GROUP, .type = XTTYPE_UINT16,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, group)},
+	{.name = "nflog-prefix", .id = O_PREFIX, .type = XTTYPE_STRING,
+	 .min = 1, .flags = XTOPT_PUT, XTOPT_POINTER(s, prefix)},
+	{.name = "nflog-range", .id = O_RANGE, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, len)},
+	{.name = "nflog-threshold", .id = O_THRESHOLD, .type = XTTYPE_UINT16,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, threshold)},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 static void NFLOG_help(void)
 {
@@ -39,72 +45,16 @@ static void NFLOG_init(struct xt_entry_target *t)
 	info->threshold	= XT_NFLOG_DEFAULT_THRESHOLD;
 }
 
-static int NFLOG_parse(int c, char **argv, int invert, unsigned int *flags,
-                       const void *entry, struct xt_entry_target **target)
+static void NFLOG_parse(struct xt_option_call *cb)
 {
-	struct xt_nflog_info *info = (struct xt_nflog_info *)(*target)->data;
-	int n;
-	size_t length;
-
-	switch (c) {
-	case NFLOG_GROUP:
-		if (*flags & NFLOG_GROUP)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --nflog-group twice");
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --nflog-group");
-
-		n = atoi(optarg);
-		if (n < 0)
-			xtables_error(PARAMETER_PROBLEM,
-				   "--nflog-group can not be negative");
-		info->group = n;
-		break;
-	case NFLOG_PREFIX:
-		if (*flags & NFLOG_PREFIX)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --nflog-prefix twice");
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --nflog-prefix");
-
-		length = strlen(optarg);
-		if (length == 0)
-			xtables_error(PARAMETER_PROBLEM,
-				   "No prefix specified for --nflog-prefix");
-		if (length >= sizeof(info->prefix))
-			xtables_error(PARAMETER_PROBLEM,
-				   "--nflog-prefix too long, max %Zu characters",
-				   sizeof(info->prefix) - 1);
-		if (length != strlen(strtok(optarg, "\n")))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Newlines are not allowed in --nflog-prefix");
-		strcpy(info->prefix, optarg);
-		break;
-	case NFLOG_RANGE:
-		if (*flags & NFLOG_RANGE)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --nflog-range twice");
-		n = atoi(optarg);
-		if (n < 0)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid --nflog-range, must be >= 0");
-		info->len = n;
-		break;
-	case NFLOG_THRESHOLD:
-		if (*flags & NFLOG_THRESHOLD)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --nflog-threshold twice");
-		n = atoi(optarg);
-		if (n < 1)
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_PREFIX:
+		if (strchr(cb->arg, '\n') != NULL)
 			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid --nflog-threshold, must be >= 1");
-		info->threshold = n;
+				   "Newlines not allowed in --log-prefix");
 		break;
 	}
-	*flags |= c;
-	return 1;
 }
 
 static void nflog_print(const struct xt_nflog_info *info, char *prefix)
@@ -144,10 +94,10 @@ static struct xtables_target nflog_target = {
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_nflog_info)),
 	.help		= NFLOG_help,
 	.init		= NFLOG_init,
-	.parse		= NFLOG_parse,
+	.x6_parse	= NFLOG_parse,
 	.print		= NFLOG_print,
 	.save		= NFLOG_save,
-	.extra_opts	= NFLOG_opts,
+	.x6_options	= NFLOG_opts,
 };
 
 void _init(void)
-- 
1.7.1

