From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/2] extensions: libxt_rateest: output all options in save hook
Date: Thu, 17 May 2012 13:03:08 +0200
Message-ID: <1337252589-1363-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46588 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761607Ab2EQLDv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 May 2012 07:03:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ipt-restore fails to parse the ipt-save output:
zmatches -m rateest --rateest RE1 --rateest-pps --rateest-lt 5
(should be "--rateest-pps 5 --rateest-lt").  Also, the "delta" option
was never shown in -save output, but twice in some cases when using
"iptables -L".

Also, the "b/pps1" option must be shown when "delta" option is used with
relative mode.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_rateest.c |   55 +++++++++++++++++++++++++++----------------
 1 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 86bbb06..185a813 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -348,8 +348,8 @@ rateest_print(const void *ip, const struct xt_entry_match *match, int numeric)
 		if (info->flags & XT_RATEEST_MATCH_DELTA)
 			rateest_print_rate(info->bps1, numeric);
 		if (info->flags & XT_RATEEST_MATCH_ABS) {
-			rateest_print_mode(info, "");
 			rateest_print_rate(info->bps2, numeric);
+			rateest_print_mode(info, "");
 		}
 	}
 	if (info->flags & XT_RATEEST_MATCH_PPS) {
@@ -366,8 +366,6 @@ rateest_print(const void *ip, const struct xt_entry_match *match, int numeric)
 		rateest_print_mode(info, "");
 
 		printf(" %s", info->name2);
-		if (info->flags & XT_RATEEST_MATCH_DELTA)
-			printf(" delta");
 
 		if (info->flags & XT_RATEEST_MATCH_BPS) {
 			printf(" bps");
@@ -382,33 +380,48 @@ rateest_print(const void *ip, const struct xt_entry_match *match, int numeric)
 	}
 }
 
+static void __rateest_save_rate(const struct xt_rateest_match_info *info,
+                                const char *name, uint32_t r1, uint32_t r2,
+                                int numeric)
+{
+	if (info->flags & XT_RATEEST_MATCH_DELTA) {
+		printf(" --rateest-%s1", name);
+		rateest_print_rate(r1, numeric);
+		rateest_print_mode(info, "--rateest-");
+		printf(" --rateest-%s2", name);
+	} else {
+		rateest_print_mode(info, "--rateest-");
+		printf(" --rateest-%s", name);
+	}
+
+	if (info->flags & (XT_RATEEST_MATCH_ABS|XT_RATEEST_MATCH_DELTA))
+		rateest_print_rate(r2, numeric);
+}
+
+static void rateest_save_rates(const struct xt_rateest_match_info *info)
+{
+	if (info->flags & XT_RATEEST_MATCH_BPS)
+		__rateest_save_rate(info, "bps", info->bps1, info->bps2, 0);
+	if (info->flags & XT_RATEEST_MATCH_PPS)
+		__rateest_save_rate(info, "pps", info->pps1, info->pps2, 1);
+}
+
+
 static void
 rateest_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_rateest_match_info *info = (const void *)match->data;
 
+	if (info->flags & XT_RATEEST_MATCH_DELTA)
+		printf(" --rateest-delta");
+
 	if (info->flags & XT_RATEEST_MATCH_REL) {
 		printf(" --rateest1 %s", info->name1);
-		if (info->flags & XT_RATEEST_MATCH_BPS)
-			printf(" --rateest-bps");
-		if (info->flags & XT_RATEEST_MATCH_PPS)
-			printf(" --rateest-pps");
-		rateest_print_mode(info, " --rateest-");
+		rateest_save_rates(info);
 		printf(" --rateest2 %s", info->name2);
-	} else {
+	} else { /* XT_RATEEST_MATCH_ABS */
 		printf(" --rateest %s", info->name1);
-		if (info->flags & XT_RATEEST_MATCH_BPS) {
-			printf(" --rateest-bps1");
-			rateest_print_rate(info->bps1, 0);
-			printf(" --rateest-bps2");
-			rateest_print_rate(info->bps2, 0);
-			rateest_print_mode(info, "--rateest-");
-		}
-		if (info->flags & XT_RATEEST_MATCH_PPS) {
-			printf(" --rateest-pps");
-			rateest_print_mode(info, "--rateest-");
-			printf(" %u", info->pps2);
-		}
+		rateest_save_rates(info);
 	}
 }
 
-- 
1.7.3.4

