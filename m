From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/7] libxt_RATEEST: abolish global variables
Date: Tue, 21 Jun 2011 17:53:34 +0200
Message-ID: <1308671615-17505-8-git-send-email-jengelh@medozas.de>
References: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40661 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781Ab1FUPxo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:53:44 -0400
In-Reply-To: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_RATEEST.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index b928b33..62bcb5e 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -7,9 +7,10 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_RATEEST.h>
 
-/* hack to pass raw values to final_check */
-static unsigned int interval;
-static unsigned int ewma_log;
+struct rateest_tg_udata {
+	unsigned int interval;
+	unsigned int ewma_log;
+};
 
 static void
 RATEEST_help(void)
@@ -85,16 +86,18 @@ RATEEST_print_time(unsigned int time)
 
 static void RATEEST_parse(struct xt_option_call *cb)
 {
+	struct rateest_tg_udata *udata = cb->udata;
+
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_INTERVAL:
-		if (RATEEST_get_time(&interval, cb->arg) < 0)
+		if (RATEEST_get_time(&udata->interval, cb->arg) < 0)
 			xtables_error(PARAMETER_PROBLEM,
 				   "RATEEST: bad interval value \"%s\"",
 				   cb->arg);
 		break;
 	case O_EWMALOG:
-		if (RATEEST_get_time(&ewma_log, cb->arg) < 0)
+		if (RATEEST_get_time(&udata->ewma_log, cb->arg) < 0)
 			xtables_error(PARAMETER_PROBLEM,
 				   "RATEEST: bad ewmalog value \"%s\"",
 				   cb->arg);
@@ -105,9 +108,10 @@ static void RATEEST_parse(struct xt_option_call *cb)
 static void RATEEST_final_check(struct xt_fcheck_call *cb)
 {
 	struct xt_rateest_target_info *info = cb->data;
+	struct rateest_tg_udata *udata = cb->udata;
 
 	for (info->interval = 0; info->interval <= 5; info->interval++) {
-		if (interval <= (1 << info->interval) * (TIME_UNITS_PER_SEC / 4))
+		if (udata->interval <= (1 << info->interval) * (TIME_UNITS_PER_SEC / 4))
 			break;
 	}
 
@@ -118,7 +122,7 @@ static void RATEEST_final_check(struct xt_fcheck_call *cb)
 
 	for (info->ewma_log = 1; info->ewma_log < 32; info->ewma_log++) {
 		double w = 1.0 - 1.0 / (1 << info->ewma_log);
-		if (interval / (-log(w)) > ewma_log)
+		if (udata->interval / (-log(w)) > udata->ewma_log)
 			break;
 	}
 	info->ewma_log--;
@@ -170,6 +174,7 @@ static struct xtables_target rateest_tg_reg = {
 	.print		= RATEEST_print,
 	.save		= RATEEST_save,
 	.x6_options	= RATEEST_opts,
+	.udata_size	= sizeof(struct rateest_tg_udata),
 };
 
 void _init(void)
-- 
1.7.3.4

