From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/7] libxt_rateest: abolish global variables
Date: Tue, 21 Jun 2011 17:53:33 +0200
Message-ID: <1308671615-17505-7-git-send-email-jengelh@medozas.de>
References: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40655 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743Ab1FUPxn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:53:43 -0400
In-Reply-To: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_rateest.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 509b3e3..5f42a13 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -8,9 +8,6 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_rateest.h>
 
-/* Ugly hack to pass info to final_check function. We should fix the API */
-static struct xt_rateest_match_info *rateest_info;
-
 static void rateest_help(void)
 {
 	printf(
@@ -115,8 +112,6 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 	struct xt_rateest_match_info *info = (void *)(*match)->data;
 	unsigned int val;
 
-	rateest_info = info;
-
 	switch (c) {
 	case OPT_RATEEST1:
 		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
@@ -302,10 +297,9 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-static void
-rateest_final_check(unsigned int flags)
+static void rateest_final_check(struct xt_fcheck_call *cb)
 {
-	struct xt_rateest_match_info *info = rateest_info;
+	struct xt_rateest_match_info *info = cb->data;
 
 	if (info == NULL)
 		xtables_error(PARAMETER_PROBLEM, "rateest match: "
@@ -439,7 +433,7 @@ static struct xtables_match rateest_mt_reg = {
 	.userspacesize	= XT_ALIGN(offsetof(struct xt_rateest_match_info, est1)),
 	.help		= rateest_help,
 	.parse		= rateest_parse,
-	.final_check	= rateest_final_check,
+	.x6_fcheck	= rateest_final_check,
 	.print		= rateest_print,
 	.save		= rateest_save,
 	.extra_opts	= rateest_opts,
-- 
1.7.3.4

