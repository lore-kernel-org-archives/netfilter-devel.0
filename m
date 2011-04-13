From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/26] libxt_tcpmss: use guided option parser
Date: Wed, 13 Apr 2011 18:13:32 +0200
Message-ID: <1302711228-15947-12-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42455 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933061Ab1DMQOC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:02 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_tcpmss.c |   92 ++++++++++-----------------------------------
 1 files changed, 20 insertions(+), 72 deletions(-)

diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 3dc3528..c7c5971 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -1,14 +1,11 @@
-/* Shared library add-on to iptables to add tcp MSS matching support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
 #include <linux/netfilter/xt_tcpmss.h>
 
+enum {
+	O_TCPMSS = 0,
+};
+
 static void tcpmss_help(void)
 {
 	printf(
@@ -17,71 +14,23 @@ static void tcpmss_help(void)
 "				(only valid for TCP SYN or SYN/ACK packets)\n");
 }
 
-static const struct option tcpmss_opts[] = {
-	{.name = "mss", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry tcpmss_opts[] = {
+	{.name = "mss", .id = O_TCPMSS, .type = XTTYPE_UINT16RC,
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
-static uint16_t
-parse_tcp_mssvalue(const char *mssvalue)
-{
-	unsigned int mssvaluenum;
-
-	if (xtables_strtoui(mssvalue, NULL, &mssvaluenum, 0, UINT16_MAX))
-		return mssvaluenum;
-
-	xtables_error(PARAMETER_PROBLEM,
-		   "Invalid mss `%s' specified", mssvalue);
-}
-
-static void
-parse_tcp_mssvalues(const char *mssvaluestring,
-		    uint16_t *mss_min, uint16_t *mss_max)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(mssvaluestring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		*mss_min = *mss_max = parse_tcp_mssvalue(buffer);
-	else {
-		*cp = '\0';
-		cp++;
-
-		*mss_min = buffer[0] ? parse_tcp_mssvalue(buffer) : 0;
-		*mss_max = cp[0] ? parse_tcp_mssvalue(cp) : 0xFFFF;
-	}
-	free(buffer);
-}
-
-static int
-tcpmss_parse(int c, char **argv, int invert, unsigned int *flags,
-             const void *entry, struct xt_entry_match **match)
-{
-	struct xt_tcpmss_match_info *mssinfo =
-		(struct xt_tcpmss_match_info *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--mss' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_tcp_mssvalues(optarg,
-				    &mssinfo->mss_min, &mssinfo->mss_max);
-		if (invert)
-			mssinfo->invert = 1;
-		*flags = 1;
-		break;
-	}
-	return 1;
-}
-
-static void tcpmss_check(unsigned int flags)
+static void tcpmss_parse(struct xt_option_call *cb)
 {
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM,
-			   "tcpmss match: You must specify `--mss'");
+	struct xt_tcpmss_match_info *mssinfo = cb->data;
+
+	xtables_option_parse(cb);
+	mssinfo->mss_min = cb->val.u16_range[0];
+	mssinfo->mss_max = mssinfo->mss_min;
+	if (cb->nvals == 2)
+		mssinfo->mss_max = cb->val.u16_range[1];
+	if (cb->invert)
+		mssinfo->invert = 1;
 }
 
 static void
@@ -114,11 +63,10 @@ static struct xtables_match tcpmss_match = {
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
 	.help		= tcpmss_help,
-	.parse		= tcpmss_parse,
-	.final_check	= tcpmss_check,
 	.print		= tcpmss_print,
 	.save		= tcpmss_save,
-	.extra_opts	= tcpmss_opts,
+	.x6_parse	= tcpmss_parse,
+	.x6_options	= tcpmss_opts,
 };
 
 void _init(void)
-- 
1.7.1

