From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: bridge: remove unneeded rcu_read_lock
Date: Tue,  7 Mar 2017 12:45:04 +0100
Message-ID: <20170307114504.2507-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58922 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751579AbdCGLeR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2017 06:34:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

as comment says, the function is always called with rcu read lock held.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/br_netfilter_hooks.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 95087e6..52739e6 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -1016,13 +1016,10 @@ int br_nf_hook_thresh(unsigned int hook, struct net *net,
 	if (!elem)
 		return okfn(net, sk, skb);
 
-	/* We may already have this, but read-locks nest anyway */
-	rcu_read_lock();
 	nf_hook_state_init(&state, hook, NFPROTO_BRIDGE, indev, outdev,
 			   sk, net, okfn);
 
 	ret = nf_hook_slow(skb, &state, elem);
-	rcu_read_unlock();
 	if (ret == 1)
 		ret = okfn(net, sk, skb);
 
-- 
2.9.3

