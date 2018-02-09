From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 6/9] netfilter: bridge: use pr ratelimiting
Date: Fri,  9 Feb 2018 15:52:04 +0100
Message-ID: <20180209145207.2097-7-fw@strlen.de>
References: <20180209145207.2097-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46640 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751053AbeBIOzi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Feb 2018 09:55:38 -0500
In-Reply-To: <20180209145207.2097-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ebt_among still uses pr_err -- these errors indicate ebtables tool bug,
not a usage error.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 patch is new in v2 (split away from different patch).

 net/bridge/netfilter/ebt_among.c | 10 +++++-----
 net/bridge/netfilter/ebt_limit.c |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 279527f8b1fe..ce7152a12bd8 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -187,17 +187,17 @@ static int ebt_among_mt_check(const struct xt_mtchk_param *par)
 	expected_length += ebt_mac_wormhash_size(wh_src);
 
 	if (em->match_size != EBT_ALIGN(expected_length)) {
-		pr_info("wrong size: %d against expected %d, rounded to %zd\n",
-			em->match_size, expected_length,
-			EBT_ALIGN(expected_length));
+		pr_err_ratelimited("wrong size: %d against expected %d, rounded to %zd\n",
+				   em->match_size, expected_length,
+				   EBT_ALIGN(expected_length));
 		return -EINVAL;
 	}
 	if (wh_dst && (err = ebt_mac_wormhash_check_integrity(wh_dst))) {
-		pr_info("dst integrity fail: %x\n", -err);
+		pr_err_ratelimited("dst integrity fail: %x\n", -err);
 		return -EINVAL;
 	}
 	if (wh_src && (err = ebt_mac_wormhash_check_integrity(wh_src))) {
-		pr_info("src integrity fail: %x\n", -err);
+		pr_err_ratelimited("src integrity fail: %x\n", -err);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 61a9f1be1263..165b9d678cf1 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -72,8 +72,8 @@ static int ebt_limit_mt_check(const struct xt_mtchk_param *par)
 	/* Check for overflow. */
 	if (info->burst == 0 ||
 	    user2credits(info->avg * info->burst) < user2credits(info->avg)) {
-		pr_info("overflow, try lower: %u/%u\n",
-			info->avg, info->burst);
+		pr_info_ratelimited("overflow, try lower: %u/%u\n",
+				    info->avg, info->burst);
 		return -EINVAL;
 	}
 
-- 
2.13.6

