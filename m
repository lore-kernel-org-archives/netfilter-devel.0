From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 14/26] libxt_connbytes: use guided option parser
Date: Wed, 13 Apr 2011 18:13:35 +0200
Message-ID: <1302711228-15947-15-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42461 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933063Ab1DMQOF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:05 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_connbytes.c |  107 +++++++++++++++---------------------------
 1 files changed, 38 insertions(+), 69 deletions(-)

diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index 1d3391a..46a7e4b 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -1,14 +1,14 @@
-/* Shared library add-on to iptables to add byte tracking support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
-#include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/xt_connbytes.h>
 
+enum {
+	O_CONNBYTES = 0,
+	O_CONNBYTES_DIR,
+	O_CONNBYTES_MODE,
+};
+
 static void connbytes_help(void)
 {
 	printf(
@@ -18,87 +18,57 @@ static void connbytes_help(void)
 "     --connbytes-mode [packets, bytes, avgpkt]\n");
 }
 
-static const struct option connbytes_opts[] = {
-	{.name = "connbytes",      .has_arg = true, .val = '1'},
-	{.name = "connbytes-dir",  .has_arg = true, .val = '2'},
-	{.name = "connbytes-mode", .has_arg = true, .val = '3'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry connbytes_opts[] = {
+	{.name = "connbytes", .id = O_CONNBYTES, .type = XTTYPE_UINT64RC,
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	{.name = "connbytes-dir", .id = O_CONNBYTES_DIR, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND},
+	{.name = "connbytes-mode", .id = O_CONNBYTES_MODE,
+	 .type = XTTYPE_STRING, .flags = XTOPT_MAND},
+	XTOPT_TABLEEND,
 };
 
-static void
-parse_range(const char *arg, struct xt_connbytes_info *si)
-{
-	char *colon,*p;
-
-	si->count.from = strtoul(arg,&colon,10);
-	if (*colon != ':') 
-		xtables_error(PARAMETER_PROBLEM, "Bad range \"%s\"", arg);
-	si->count.to = strtoul(colon+1,&p,10);
-	if (p == colon+1) {
-		/* second number omited */
-		si->count.to = 0xffffffff;
-	}
-	if (si->count.from > si->count.to)
-		xtables_error(PARAMETER_PROBLEM, "%llu should be less than %llu",
-			   (unsigned long long)si->count.from,
-			   (unsigned long long)si->count.to);
-}
-
-static int
-connbytes_parse(int c, char **argv, int invert, unsigned int *flags,
-                const void *entry, struct xt_entry_match **match)
+static void connbytes_parse(struct xt_option_call *cb)
 {
-	struct xt_connbytes_info *sinfo = (struct xt_connbytes_info *)(*match)->data;
-	unsigned long i;
-
-	switch (c) {
-	case '1':
-		if (xtables_check_inverse(optarg, &invert, &optind, 0, argv))
-			optind++;
-
-		parse_range(optarg, sinfo);
-		if (invert) {
+	struct xt_connbytes_info *sinfo = cb->data;
+	unsigned long long i;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_CONNBYTES:
+		sinfo->count.from = cb->val.u64_range[0];
+		sinfo->count.to   = cb->val.u64_range[0];
+		if (cb->nvals == 2)
+			sinfo->count.to = cb->val.u64_range[1];
+		if (cb->invert) {
 			i = sinfo->count.from;
 			sinfo->count.from = sinfo->count.to;
 			sinfo->count.to = i;
 		}
-		*flags |= 1;
 		break;
-	case '2':
-		if (!strcmp(optarg, "original"))
+	case O_CONNBYTES_DIR:
+		if (strcmp(cb->arg, "original") == 0)
 			sinfo->direction = XT_CONNBYTES_DIR_ORIGINAL;
-		else if (!strcmp(optarg, "reply"))
+		else if (strcmp(cb->arg, "reply") == 0)
 			sinfo->direction = XT_CONNBYTES_DIR_REPLY;
-		else if (!strcmp(optarg, "both"))
+		else if (strcmp(cb->arg, "both") == 0)
 			sinfo->direction = XT_CONNBYTES_DIR_BOTH;
 		else
 			xtables_error(PARAMETER_PROBLEM,
-				   "Unknown --connbytes-dir `%s'", optarg);
-
-		*flags |= 2;
+				   "Unknown --connbytes-dir `%s'", cb->arg);
 		break;
-	case '3':
-		if (!strcmp(optarg, "packets"))
+	case O_CONNBYTES_MODE:
+		if (strcmp(cb->arg, "packets") == 0)
 			sinfo->what = XT_CONNBYTES_PKTS;
-		else if (!strcmp(optarg, "bytes"))
+		else if (strcmp(cb->arg, "bytes") == 0)
 			sinfo->what = XT_CONNBYTES_BYTES;
-		else if (!strcmp(optarg, "avgpkt"))
+		else if (strcmp(cb->arg, "avgpkt") == 0)
 			sinfo->what = XT_CONNBYTES_AVGPKT;
 		else
 			xtables_error(PARAMETER_PROBLEM,
-				   "Unknown --connbytes-mode `%s'", optarg);
-		*flags |= 4;
+				   "Unknown --connbytes-mode `%s'", cb->arg);
 		break;
 	}
-
-	return 1;
-}
-
-static void connbytes_check(unsigned int flags)
-{
-	if (flags != 7)
-		xtables_error(PARAMETER_PROBLEM, "You must specify `--connbytes'"
-			   "`--connbytes-dir' and `--connbytes-mode'");
 }
 
 static void print_mode(const struct xt_connbytes_info *sinfo)
@@ -185,11 +155,10 @@ static struct xtables_match connbytes_match = {
 	.size 		= XT_ALIGN(sizeof(struct xt_connbytes_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connbytes_info)),
 	.help		= connbytes_help,
-	.parse		= connbytes_parse,
-	.final_check	= connbytes_check,
 	.print		= connbytes_print,
 	.save 		= connbytes_save,
-	.extra_opts	= connbytes_opts,
+	.x6_parse	= connbytes_parse,
+	.x6_options	= connbytes_opts,
 };
 
 void _init(void)
-- 
1.7.1

