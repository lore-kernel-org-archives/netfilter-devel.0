From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 18/26] libxt_TCPMSS: use guided option parser
Date: Wed, 13 Apr 2011 18:13:39 +0200
Message-ID: <1302711228-15947-19-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42468 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933070Ab1DMQOK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:10 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TCPMSS.c |   96 ++++++++++++++++----------------------------
 1 files changed, 35 insertions(+), 61 deletions(-)

diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index e15e87a..2266326 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -2,16 +2,17 @@
  *
  * Copyright (c) 2000 Marc Boucher
 */
-#include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
-#include <linux/netfilter/x_tables.h>
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
 #include <linux/netfilter/xt_TCPMSS.h>
 
+enum {
+	O_SET_MSS = 0,
+	O_CLAMP_MSS,
+};
+
 struct mssinfo {
 	struct xt_entry_target t;
 	struct xt_tcpmss_info mss;
@@ -28,69 +29,42 @@ hdrsize);
 
 static void TCPMSS_help(void)
 {
-	__TCPMSS_help(40);
+	__TCPMSS_help(sizeof(struct iphdr));
 }
 
 static void TCPMSS_help6(void)
 {
-	__TCPMSS_help(60);
+	__TCPMSS_help(sizeof(struct ip6_hdr));
 }
 
-static const struct option TCPMSS_opts[] = {
-	{.name = "set-mss",           .has_arg = true,  .val = '1'},
-	{.name = "clamp-mss-to-pmtu", .has_arg = false, .val = '2'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry TCPMSS4_opts[] = {
+	{.name = "set-mss", .id = O_SET_MSS, .type = XTTYPE_UINT16,
+	 .min = 0, .max = UINT16_MAX - sizeof(struct iphdr),
+	 .flags = XTOPT_PUT, XTOPT_POINTER(struct xt_tcpmss_info, mss)},
+	{.name = "clamp-mss-to-pmtu", .id = O_CLAMP_MSS, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
 
-static int __TCPMSS_parse(int c, char **argv, int invert, unsigned int *flags,
-                          const void *entry, struct xt_entry_target **target,
-                          int hdrsize)
-{
-	struct xt_tcpmss_info *mssinfo
-		= (struct xt_tcpmss_info *)(*target)->data;
-
-	switch (c) {
-		unsigned int mssval;
-
-	case '1':
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-			           "TCPMSS target: Only one option may be specified");
-		if (!xtables_strtoui(optarg, NULL, &mssval,
-		    0, UINT16_MAX - hdrsize))
-			xtables_error(PARAMETER_PROBLEM, "Bad TCPMSS value \"%s\"", optarg);
-		
-		mssinfo->mss = mssval;
-		*flags = 1;
-		break;
-
-	case '2':
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-			           "TCPMSS target: Only one option may be specified");
-		mssinfo->mss = XT_TCPMSS_CLAMP_PMTU;
-		*flags = 1;
-		break;
-	}
-
-	return 1;
-}
+static const struct xt_option_entry TCPMSS6_opts[] = {
+	{.name = "set-mss", .id = O_SET_MSS, .type = XTTYPE_UINT16,
+	 .min = 0, .max = UINT16_MAX - sizeof(struct ip6_hdr),
+	 .flags = XTOPT_PUT, XTOPT_POINTER(struct xt_tcpmss_info, mss)},
+	{.name = "clamp-mss-to-pmtu", .id = O_CLAMP_MSS, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
+};
 
-static int TCPMSS_parse(int c, char **argv, int invert, unsigned int *flags,
-                        const void *entry, struct xt_entry_target **target)
+static void TCPMSS_parse(struct xt_option_call *cb)
 {
-	return __TCPMSS_parse(c, argv, invert, flags, entry, target, 40);
-}
+	struct xt_tcpmss_info *mssinfo = cb->data;
 
-static int TCPMSS_parse6(int c, char **argv, int invert, unsigned int *flags,
-                         const void *entry, struct xt_entry_target **target)
-{
-	return __TCPMSS_parse(c, argv, invert, flags, entry, target, 60);
+	xtables_option_parse(cb);
+	if (cb->entry->id == O_CLAMP_MSS)
+		mssinfo->mss = XT_TCPMSS_CLAMP_PMTU;
 }
 
-static void TCPMSS_check(unsigned int flags)
+static void TCPMSS_check(struct xt_fcheck_call *cb)
 {
-	if (!flags)
+	if (cb->xflags == 0)
 		xtables_error(PARAMETER_PROBLEM,
 		           "TCPMSS target: At least one parameter is required");
 }
@@ -124,11 +98,11 @@ static struct xtables_target tcpmss_target = {
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
 	.help		= TCPMSS_help,
-	.parse		= TCPMSS_parse,
-	.final_check	= TCPMSS_check,
 	.print		= TCPMSS_print,
 	.save		= TCPMSS_save,
-	.extra_opts	= TCPMSS_opts,
+	.x6_parse	= TCPMSS_parse,
+	.x6_fcheck	= TCPMSS_check,
+	.x6_options	= TCPMSS4_opts,
 };
 
 static struct xtables_target tcpmss_target6 = {
@@ -138,11 +112,11 @@ static struct xtables_target tcpmss_target6 = {
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
 	.help		= TCPMSS_help6,
-	.parse		= TCPMSS_parse6,
-	.final_check	= TCPMSS_check,
 	.print		= TCPMSS_print,
 	.save		= TCPMSS_save,
-	.extra_opts	= TCPMSS_opts,
+	.x6_parse	= TCPMSS_parse,
+	.x6_fcheck	= TCPMSS_check,
+	.x6_options	= TCPMSS6_opts,
 };
 
 void _init(void)
-- 
1.7.1

