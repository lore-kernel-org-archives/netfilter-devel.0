From: kaber@trash.net
Subject: [PATCH 1/3] netfilter: ipt_ecn: fix protocol check in ecn_mt_check()
Date: Thu,  9 Jun 2011 14:12:32 +0200
Message-ID: <1307621554-19108-2-git-send-email-kaber@trash.net>
References: <1307621554-19108-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: eric.dumazet@gmail.com, dave.taht@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37834 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab1FIMMj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:12:39 -0400
In-Reply-To: <1307621554-19108-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

Check for protocol inversion in ecn_mt_check() and remove the unnecessary
runtime check for IPPROTO_TCP in ecn_mt().

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/ipv4/netfilter/ipt_ecn.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index af6e9c7..aaa85be 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -76,8 +76,6 @@ static bool ecn_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			return false;
 
 	if (info->operation & (IPT_ECN_OP_MATCH_ECE|IPT_ECN_OP_MATCH_CWR)) {
-		if (ip_hdr(skb)->protocol != IPPROTO_TCP)
-			return false;
 		if (!match_tcp(skb, info, &par->hotdrop))
 			return false;
 	}
@@ -97,7 +95,7 @@ static int ecn_mt_check(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (info->operation & (IPT_ECN_OP_MATCH_ECE|IPT_ECN_OP_MATCH_CWR) &&
-	    ip->proto != IPPROTO_TCP) {
+	    (ip->proto != IPPROTO_TCP || ip->invflags & IPT_INV_PROTO)) {
 		pr_info("cannot match TCP bits in rule for non-tcp packets\n");
 		return -EINVAL;
 	}
-- 
1.7.4.1

