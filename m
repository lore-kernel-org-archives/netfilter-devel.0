From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: connmark: ignore skbs with magic untracked conntrack objects
Date: Sat, 29 Oct 2016 03:01:50 +0200
Message-ID: <1477702910-12957-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38426 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755083AbcJ2BR5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2016 21:17:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The (percpu) untracked conntrack entries can end up with nonzero connmarks.

The 'untracked' conntrack objects are merely a way to distinguish INVALID
(i.e. protocol connection tracker says payload doesn't meet some
requirements or packet was never seen by the connection tracking code)
from packets that are intentionally not tracked (some icmpv6 types such as
neigh solicitation, or by using 'iptables -j CT --notrack' option).

Untracked conntrack objects are implementation detail, we might as well use
invalid magic address instead to tell INVALID and UNTRACKED apart.

Check skb->nfct for untracked dummy and behave as if skb->nfct is NULL.

Reported-by: XU Tianwen <evan.xu.tianwen@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
Here is the formal submit of earlier RFC patch, I also fixed
connmark match; conceptually UNTRACKED is not a conntrack object
so such skb should always fail the match.

diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 69f78e96fdb4..b83e158e116a 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -44,7 +44,7 @@ connmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	u_int32_t newmark;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct == NULL)
+	if (ct == NULL || nf_ct_is_untracked(ct))
 		return XT_CONTINUE;
 
 	switch (info->mode) {
@@ -97,7 +97,7 @@ connmark_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct == NULL)
+	if (ct == NULL || nf_ct_is_untracked(ct))
 		return false;
 
 	return ((ct->mark & info->mask) == info->mark) ^ info->invert;
-- 
2.7.3

