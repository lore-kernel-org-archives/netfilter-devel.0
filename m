From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 26/26] libipt_ULOG: use guided option parser
Date: Wed, 13 Apr 2011 18:13:47 +0200
Message-ID: <1302711228-15947-27-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42491 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933056Ab1DMQOS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:18 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_ULOG.c |  137 +++++++++++----------------------------------
 1 files changed, 34 insertions(+), 103 deletions(-)

diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 8eeccf0..e08ae05 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -9,29 +9,18 @@
  * 
  * libipt_ULOG.c,v 1.7 2001/01/30 11:55:02 laforge Exp
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
-#include <stdlib.h>
-#include <syslog.h>
-#include <getopt.h>
 #include <xtables.h>
 /* For 64bit kernel / 32bit userspace */
 #include <linux/netfilter_ipv4/ipt_ULOG.h>
 
-
-static void print_groups(unsigned int gmask)
-{
-	int b;
-	unsigned int test;
-
-	for (b = 31; b >= 0; b--) {
-		test = (1 << b);
-		if (gmask & test)
-			printf(" %d", b + 1);
-	}
-}
+enum {
+	O_ULOG_NLGROUP = 0,
+	O_ULOG_PREFIX,
+	O_ULOG_CPRANGE,
+	O_ULOG_QTHR,
+};
 
 static void ULOG_help(void)
 {
@@ -42,12 +31,16 @@ static void ULOG_help(void)
 	       " --ulog-prefix prefix		Prefix log messages with this prefix.\n");
 }
 
-static const struct option ULOG_opts[] = {
-	{.name = "ulog-nlgroup",    .has_arg = true, .val = '!'},
-	{.name = "ulog-prefix",     .has_arg = true, .val = '#'},
-	{.name = "ulog-cprange",    .has_arg = true, .val = 'A'},
-	{.name = "ulog-qthreshold", .has_arg = true, .val = 'B'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry ULOG_opts[] = {
+	{.name = "ulog-nlgroup", .id = O_ULOG_NLGROUP, .type = XTTYPE_UINT8,
+	 .min = 1, .max = 32},
+	{.name = "ulog-prefix", .id = O_ULOG_PREFIX, .type = XTTYPE_STRING,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(struct ipt_ulog_info, prefix),
+	 .min = 1},
+	{.name = "ulog-cprange", .id = O_ULOG_CPRANGE, .type = XTTYPE_UINT64,
+	 .min = 1, .max = ULOG_MAX_QLEN},
+	{.name = "ulog-qthreshold", .id = O_ULOG_QTHR, .type = XTTYPE_UINT64},
+	XTOPT_TABLEEND,
 };
 
 static void ULOG_init(struct xt_entry_target *t)
@@ -59,87 +52,27 @@ static void ULOG_init(struct xt_entry_target *t)
 
 }
 
-#define IPT_LOG_OPT_NLGROUP 0x01
-#define IPT_LOG_OPT_PREFIX 0x02
-#define IPT_LOG_OPT_CPRANGE 0x04
-#define IPT_LOG_OPT_QTHRESHOLD 0x08
-
-static int ULOG_parse(int c, char **argv, int invert, unsigned int *flags,
-                      const void *entry, struct xt_entry_target **target)
+static void ULOG_parse(struct xt_option_call *cb)
 {
-	struct ipt_ulog_info *loginfo =
-	    (struct ipt_ulog_info *) (*target)->data;
-	int group_d;
+	struct ipt_ulog_info *loginfo = cb->data;
 
-	switch (c) {
-	case '!':
-		if (*flags & IPT_LOG_OPT_NLGROUP)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --ulog-nlgroup twice");
-
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --ulog-nlgroup");
-		group_d = atoi(optarg);
-		if (group_d > 32 || group_d < 1)
-			xtables_error(PARAMETER_PROBLEM,
-				   "--ulog-nlgroup has to be between 1 and 32");
-
-		loginfo->nl_group = (1 << (group_d - 1));
-
-		*flags |= IPT_LOG_OPT_NLGROUP;
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_ULOG_NLGROUP:
+		loginfo->nl_group = 1 << (cb->val.u8 - 1);
 		break;
-
-	case '#':
-		if (*flags & IPT_LOG_OPT_PREFIX)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --ulog-prefix twice");
-
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --ulog-prefix");
-
-		if (strlen(optarg) > sizeof(loginfo->prefix) - 1)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Maximum prefix length %u for --ulog-prefix",
-				   (unsigned int)sizeof(loginfo->prefix) - 1);
-
-		if (strlen(optarg) == 0)
-			xtables_error(PARAMETER_PROBLEM,
-				   "No prefix specified for --ulog-prefix");
-
-		if (strlen(optarg) != strlen(strtok(optarg, "\n")))
+	case O_ULOG_PREFIX:
+		if (strchr(cb->arg, '\n') != NULL)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Newlines not allowed in --ulog-prefix");
-
-		strcpy(loginfo->prefix, optarg);
-		*flags |= IPT_LOG_OPT_PREFIX;
 		break;
-	case 'A':
-		if (*flags & IPT_LOG_OPT_CPRANGE)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --ulog-cprange twice");
-		if (atoi(optarg) < 0)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Negative copy range?");
-		loginfo->copy_range = atoi(optarg);
-		*flags |= IPT_LOG_OPT_CPRANGE;
+	case O_ULOG_CPRANGE:
+		loginfo->copy_range = cb->val.u64;
 		break;
-	case 'B':
-		if (*flags & IPT_LOG_OPT_QTHRESHOLD)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --ulog-qthreshold twice");
-		if (atoi(optarg) < 1)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Negative or zero queue threshold ?");
-		if (atoi(optarg) > ULOG_MAX_QLEN)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Maximum queue length exceeded");
-		loginfo->qthreshold = atoi(optarg);
-		*flags |= IPT_LOG_OPT_QTHRESHOLD;
+	case O_ULOG_QTHR:
+		loginfo->qthreshold = cb->val.u64;
 		break;
 	}
-	return 1;
 }
 
 static void ULOG_save(const void *ip, const struct xt_entry_target *target)
@@ -152,10 +85,8 @@ static void ULOG_save(const void *ip, const struct xt_entry_target *target)
 		xtables_save_string(loginfo->prefix);
 	}
 
-	if (loginfo->nl_group != ULOG_DEFAULT_NLGROUP) {
-		printf(" --ulog-nlgroup");
-		print_groups(loginfo->nl_group);
-	}
+	if (loginfo->nl_group != ULOG_DEFAULT_NLGROUP)
+		printf(" --ulog-nlgroup %d", ffs(loginfo->nl_group));
 	if (loginfo->copy_range)
 		printf(" --ulog-cprange %u", (unsigned int)loginfo->copy_range);
 
@@ -170,8 +101,8 @@ static void ULOG_print(const void *ip, const struct xt_entry_target *target,
 	    = (const struct ipt_ulog_info *) target->data;
 
 	printf(" ULOG ");
-	printf("copy_range %u nlgroup", (unsigned int)loginfo->copy_range);
-	print_groups(loginfo->nl_group);
+	printf("copy_range %u nlgroup %d", (unsigned int)loginfo->copy_range,
+	       ffs(loginfo->nl_group));
 	if (strcmp(loginfo->prefix, "") != 0)
 		printf(" prefix \"%s\"", loginfo->prefix);
 	printf(" queue_threshold %u", (unsigned int)loginfo->qthreshold);
@@ -185,10 +116,10 @@ static struct xtables_target ulog_tg_reg = {
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_ulog_info)),
 	.help		= ULOG_help,
 	.init		= ULOG_init,
-	.parse		= ULOG_parse,
 	.print		= ULOG_print,
 	.save		= ULOG_save,
-	.extra_opts	= ULOG_opts,
+	.x6_parse	= ULOG_parse,
+	.x6_options	= ULOG_opts,
 };
 
 void _init(void)
-- 
1.7.1

