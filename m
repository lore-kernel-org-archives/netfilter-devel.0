From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] netfilter: core: batch nf_unregister_net_hooks synchronize_net calls
Date: Wed, 23 Aug 2017 17:26:27 +0200
Message-ID: <20170823152627.19865-4-fw@strlen.de>
References: <20170823152627.19865-1-fw@strlen.de>
Cc: aconole@bytheb.org, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58172 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932337AbdHWP0T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2017 11:26:19 -0400
In-Reply-To: <20170823152627.19865-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

re-add batching in nf_unregister_net_hooks().

Similar as before, just store an array with to-be-free'd rule arrays
on stack, then call synchronize_net once per batch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/core.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 56 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 8ca26729430b..db0b4195e0fe 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -397,10 +397,63 @@ EXPORT_SYMBOL(nf_register_net_hooks);
 void nf_unregister_net_hooks(struct net *net, const struct nf_hook_ops *reg,
 			     unsigned int hookcount)
 {
-	unsigned int i;
+	struct nf_hook_entries *to_free[16], *p;
+	struct nf_hook_entries __rcu **pp;
+	unsigned int i, j, n;
+
+	mutex_lock(&nf_hook_mutex);
+	for (i = 0; i < hookcount; i++) {
+		pp = nf_hook_entry_head(net, &reg[i]);
+		if (!pp)
+			continue;
+
+		p = nf_entry_dereference(*pp);
+		if (WARN_ON_ONCE(!p))
+			continue;
+		__nf_unregister_net_hook(p, &reg[i]);
+	}
+	mutex_unlock(&nf_hook_mutex);
+
+	do {
+		n = min_t(unsigned int, hookcount, ARRAY_SIZE(to_free));
+
+		mutex_lock(&nf_hook_mutex);
+
+		for (i = 0, j = 0; i < hookcount && j < n; i++) {
+			pp = nf_hook_entry_head(net, &reg[i]);
+			if (!pp)
+				continue;
+
+			p = nf_entry_dereference(*pp);
+			if (!p)
+				continue;
+
+			to_free[j] = __nf_hook_entries_try_shrink(pp);
+			if (to_free[j])
+				++j;
+		}
+
+		mutex_unlock(&nf_hook_mutex);
+
+		if (j) {
+			unsigned int nfq;
+
+			synchronize_net();
+
+			/* need 2nd synchronize_net() if nfqueue is used, skb
+			 * can get reinjected right before nf_queue_hook_drop()
+			 */
+			nfq = nf_queue_nf_hook_drop(net);
+			if (nfq)
+				synchronize_net();
+
+			for (i = 0; i < j; i++)
+				kvfree(to_free[i]);
+		}
 
-	for (i = 0; i < hookcount; i++)
-		nf_unregister_net_hook(net, &reg[i]);
+		reg += n;
+		hookcount -= n;
+	} while (hookcount > 0);
 }
 EXPORT_SYMBOL(nf_unregister_net_hooks);
 
-- 
2.13.0

