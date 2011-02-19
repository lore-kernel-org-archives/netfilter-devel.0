From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/8] libip6t_dst: remove unimplemented --dst-not-strict
Date: Sat, 19 Feb 2011 20:04:15 +0100
Message-ID: <1298142259-11213-6-git-send-email-jengelh@medozas.de>
References: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42364 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab1BSTEj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Feb 2011 14:04:39 -0500
In-Reply-To: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This was never ever implemented in the kernel, so just remove it.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_dst.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 8b656a6..74f6029 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -25,7 +25,6 @@ IP6T_OPTS_OPTSNR);
 static const struct option dst_opts[] = {
 	{.name = "dst-len",        .has_arg = true, .val = '1'},
 	{.name = "dst-opts",       .has_arg = true, .val = '2'},
-	{.name = "dst-not-strict", .has_arg = true, .val = '3'},
 	XT_GETOPT_TABLEEND,
 };
 
@@ -135,17 +134,6 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
 		optinfo->flags |= IP6T_OPTS_OPTS;
 		*flags |= IP6T_OPTS_OPTS;
 		break;
-	case '3':
-		if (*flags & IP6T_OPTS_NSTRICT)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--dst-not-strict' allowed");
-		if ( !(*flags & IP6T_OPTS_OPTS) )
-			xtables_error(PARAMETER_PROBLEM,
-				   "`--dst-opts ...' required before "
-				   "`--dst-not-strict'");
-		optinfo->flags |= IP6T_OPTS_NSTRICT;
-		*flags |= IP6T_OPTS_NSTRICT;
-		break;
 	}
 
 	return 1;
@@ -183,9 +171,6 @@ static void dst_print(const void *ip, const struct xt_entry_match *match,
 
 	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
 
-	if (optinfo->flags & IP6T_OPTS_NSTRICT)
-		printf(" not-strict");
-
 	if (optinfo->invflags & ~IP6T_OPTS_INV_MASK)
 		printf(" Unknown invflags: 0x%X",
 		       optinfo->invflags & ~IP6T_OPTS_INV_MASK);
@@ -205,9 +190,6 @@ static void dst_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --dst-opts");
 
 	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
-
-	if (optinfo->flags & IP6T_OPTS_NSTRICT)
-		printf(" --dst-not-strict");
 }
 
 static struct xtables_match dst_mt6_reg = {
-- 
1.7.1

