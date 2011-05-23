From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/13] libxt_rateest: fix rateest save operation
Date: Mon, 23 May 2011 16:39:21 +0200
Message-ID: <1306161564-4370-12-git-send-email-jengelh@medozas.de>
References: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44637 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650Ab1EWOji (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 10:39:38 -0400
In-Reply-To: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

rateest's save operation was pretty much busted.

References: http://marc.info/?l=netfilter&m=130332436408107&w=2
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_rateest.c |   73 +++++++++++++++++++++++++++++++++-----------
 1 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 62d6033..2244558 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -399,27 +399,64 @@ rateest_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_rateest_match_info *info = (const void *)match->data;
 
+	if (info->flags & XT_RATEEST_MATCH_DELTA)
+		printf(" --rateest-delta");
+
 	if (info->flags & XT_RATEEST_MATCH_REL) {
-		printf(" --rateest1 %s", info->name1);
-		if (info->flags & XT_RATEEST_MATCH_BPS)
-			printf(" --rateest-bps");
-		if (info->flags & XT_RATEEST_MATCH_PPS)
-			printf(" --rateest-pps");
-		rateest_print_mode(info, " --rateest-");
-		printf(" --rateest2 %s", info->name2);
-	} else {
-		printf(" --rateest %s", info->name1);
-		if (info->flags & XT_RATEEST_MATCH_BPS) {
-			printf(" --rateest-bps1");
-			rateest_print_rate(info->bps1, 0);
-			printf(" --rateest-bps2");
-			rateest_print_rate(info->bps2, 0);
+		printf(" --rateest1");
+		xtables_save_string(info->name1);
+		if (info->flags & XT_RATEEST_MATCH_DELTA) {
+			if (info->flags & XT_RATEEST_MATCH_BPS) {
+				printf(" --rateest-bps1");
+				rateest_print_rate(info->bps1, 0);
+			} else {
+				printf(" --rateest-pps1 %u", info->pps1);
+			}
 			rateest_print_mode(info, "--rateest-");
-		}
-		if (info->flags & XT_RATEEST_MATCH_PPS) {
-			printf(" --rateest-pps");
+			printf(" --rateest2");
+			xtables_save_string(info->name2);
+			if (info->flags & XT_RATEEST_MATCH_BPS) {
+				printf(" --rateest-bps2");
+				rateest_print_rate(info->bps2, 0);
+			} else {
+				printf(" --rateest-pps2 %u", info->pps2);
+			}
+		} else {
 			rateest_print_mode(info, "--rateest-");
-			printf(" %u", info->pps2);
+			printf(" --rateest2");
+			xtables_save_string(info->name2);
+			printf(info->flags & XT_RATEEST_MATCH_BPS ?
+			       " --bytes" : " --packets");
+		}
+	} else {
+		printf(" --rateest");
+		xtables_save_string(info->name1);
+		if (info->flags & XT_RATEEST_MATCH_DELTA) {
+			if (info->flags & XT_RATEEST_MATCH_BPS) {
+				printf(" --rateest-bps1");
+				rateest_print_rate(info->bps1, 0);
+			} else {
+				printf(" --rateest-pps1 %u",
+				       (unsigned int)info->pps1);
+			}
+		}
+		rateest_print_mode(info, "--rateest-");
+		if (info->flags & XT_RATEEST_MATCH_DELTA) {
+			if (info->flags & XT_RATEEST_MATCH_BPS) {
+				printf(" --rateest-bps2");
+				rateest_print_rate(info->bps2, 0);
+			} else {
+				printf(" --rateest-pps2 %u",
+				       (unsigned int)info->pps2);
+			}
+		} else {
+			if (info->flags & XT_RATEEST_MATCH_BPS) {
+				printf(" --rateest-bps");
+				rateest_print_rate(info->bps2, 0);
+			} else {
+				printf(" --rateest-pps %u",
+				       (unsigned int)info->pps2);
+			}
 		}
 	}
 }
-- 
1.7.3.4

