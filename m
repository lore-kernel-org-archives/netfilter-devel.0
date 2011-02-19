From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/8] libip6t_hbh: remove unimplemented --hbh-not-strict
Date: Sat, 19 Feb 2011 20:04:16 +0100
Message-ID: <1298142259-11213-7-git-send-email-jengelh@medozas.de>
References: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42366 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab1BSTEk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Feb 2011 14:04:40 -0500
In-Reply-To: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Same as with ip6t_dst.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_hbh.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 9eb504e..b6a8e46 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -27,7 +27,6 @@ IP6T_OPTS_OPTSNR);
 static const struct option hbh_opts[] = {
 	{.name = "hbh-len",        .has_arg = true, .val = '1'},
 	{.name = "hbh-opts",       .has_arg = true, .val = '2'},
-	{.name = "hbh-not-strict", .has_arg = true, .val = '3'},
 	XT_GETOPT_TABLEEND,
 };
 
@@ -129,16 +128,6 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
 		optinfo->flags |= IP6T_OPTS_OPTS;
 		*flags |= IP6T_OPTS_OPTS;
 		break;
-	case '3':
-		if (*flags & IP6T_OPTS_NSTRICT)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--hbh-not-strict' allowed");
-		if ( !(*flags & IP6T_OPTS_OPTS) )
-			xtables_error(PARAMETER_PROBLEM,
-				   "`--hbh-opts ...' required before `--hbh-not-strict'");
-		optinfo->flags |= IP6T_OPTS_NSTRICT;
-		*flags |= IP6T_OPTS_NSTRICT;
-		break;
 	}
 
 	return 1;
@@ -171,7 +160,6 @@ static void hbh_print(const void *ip, const struct xt_entry_match *match,
 	}
 	if (optinfo->flags & IP6T_OPTS_OPTS) printf(" opts");
 	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
-	if (optinfo->flags & IP6T_OPTS_NSTRICT) printf(" not-strict");
 	if (optinfo->invflags & ~IP6T_OPTS_INV_MASK)
 		printf(" Unknown invflags: 0x%X",
 		       optinfo->invflags & ~IP6T_OPTS_INV_MASK);
@@ -190,8 +178,6 @@ static void hbh_save(const void *ip, const struct xt_entry_match *match)
 	if (optinfo->flags & IP6T_OPTS_OPTS)
 		printf(" --hbh-opts");
 	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
-	if (optinfo->flags & IP6T_OPTS_NSTRICT)
-		printf(" --hbh-not-strict");
 }
 
 static struct xtables_match hbh_mt6_reg = {
-- 
1.7.1

