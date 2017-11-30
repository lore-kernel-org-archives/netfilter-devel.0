From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: core: make nf_unregister_net_hooks simple wrapper again
Date: Fri,  1 Dec 2017 00:21:02 +0100
Message-ID: <20171130232104.541-2-fw@strlen.de>
References: <20171130232104.541-1-fw@strlen.de>
Cc: gscrivan@redhat.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37886 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750994AbdK3XeK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Nov 2017 18:34:10 -0500
In-Reply-To: <20171130232104.541-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This reverts commit d3ad2c17b4047
("netfilter: core: batch nf_unregister_net_hooks synchronize_net calls").

Nothing wrong with it.  However, followup patch will delay freeing of hooks
with call_rcu, so all synchronize_net() calls become obsolete and there
is no need anymore for this batching.

This revert causes a temporary performance degradation when destroying
network namespace, but its resolved with the upcoming call_rcu conversion.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/core.c | 59 +++-------------------------------------------------
 1 file changed, 3 insertions(+), 56 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 52cd2901a097..d39bb2c583dc 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -395,63 +395,10 @@ EXPORT_SYMBOL(nf_register_net_hooks);
 void nf_unregister_net_hooks(struct net *net, const struct nf_hook_ops *reg,
 			     unsigned int hookcount)
 {
-	struct nf_hook_entries *to_free[16], *p;
-	struct nf_hook_entries __rcu **pp;
-	unsigned int i, j, n;
-
-	mutex_lock(&nf_hook_mutex);
-	for (i = 0; i < hookcount; i++) {
-		pp = nf_hook_entry_head(net, &reg[i]);
-		if (!pp)
-			continue;
-
-		p = nf_entry_dereference(*pp);
-		if (WARN_ON_ONCE(!p))
-			continue;
-		__nf_unregister_net_hook(p, &reg[i]);
-	}
-	mutex_unlock(&nf_hook_mutex);
-
-	do {
-		n = min_t(unsigned int, hookcount, ARRAY_SIZE(to_free));
-
-		mutex_lock(&nf_hook_mutex);
-
-		for (i = 0, j = 0; i < hookcount && j < n; i++) {
-			pp = nf_hook_entry_head(net, &reg[i]);
-			if (!pp)
-				continue;
-
-			p = nf_entry_dereference(*pp);
-			if (!p)
-				continue;
-
-			to_free[j] = __nf_hook_entries_try_shrink(pp);
-			if (to_free[j])
-				++j;
-		}
-
-		mutex_unlock(&nf_hook_mutex);
-
-		if (j) {
-			unsigned int nfq;
-
-			synchronize_net();
-
-			/* need 2nd synchronize_net() if nfqueue is used, skb
-			 * can get reinjected right before nf_queue_hook_drop()
-			 */
-			nfq = nf_queue_nf_hook_drop(net);
-			if (nfq)
-				synchronize_net();
-
-			for (i = 0; i < j; i++)
-				kvfree(to_free[i]);
-		}
+	unsigned int i;
 
-		reg += n;
-		hookcount -= n;
-	} while (hookcount > 0);
+	for (i = 0; i < hookcount; i++)
+		nf_unregister_net_hook(net, &reg[i]);
 }
 EXPORT_SYMBOL(nf_unregister_net_hooks);
 
-- 
2.13.6

