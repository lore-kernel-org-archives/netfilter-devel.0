From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables kernel 1/3] netfilter: nft_log: group is u16, snaplen u32
Date: Fri, 13 Sep 2013 16:44:46 +0200
Message-ID: <1379083488-20752-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58016 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757183Ab3IMOpF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:45:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

0edecbe17ae (netfilter: nft_log: group and qthreshold are 2^16)
made the correct changes except in the nla_policy where
it changed snaplen instead of group attibute.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_log.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 65cc62f..70b1be2 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -37,9 +37,9 @@ static void nft_log_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_log_policy[NFTA_LOG_MAX + 1] = {
-	[NFTA_LOG_GROUP]	= { .type = NLA_U32 },
+	[NFTA_LOG_GROUP]	= { .type = NLA_U16 },
 	[NFTA_LOG_PREFIX]	= { .type = NLA_STRING },
-	[NFTA_LOG_SNAPLEN]	= { .type = NLA_U16 },
+	[NFTA_LOG_SNAPLEN]	= { .type = NLA_U32 },
 	[NFTA_LOG_QTHRESHOLD]	= { .type = NLA_U16 },
 };
 
-- 
1.7.8.6

