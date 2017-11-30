From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] netfilter: core: free hooks with call_rcu
Date: Fri,  1 Dec 2017 00:21:04 +0100
Message-ID: <20171130232104.541-4-fw@strlen.de>
References: <20171130232104.541-1-fw@strlen.de>
Cc: gscrivan@redhat.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37902 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751069AbdK3XeR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Nov 2017 18:34:17 -0500
In-Reply-To: <20171130232104.541-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Giuseppe Scrivano says:
  "SELinux, if enabled, registers for each new network namespace 6
    netfilter hooks."

Cost for this is high.  With synchronize_net() removed:
   "The net benefit on an SMP machine with two cores is that creating a
   new network namespace takes -40% of the original time."

This patch replaces synchronize_net+kvfree with call_rcu().
We store rcu_head at the tail of a structure that has no fixed layout,
i.e. we cannot use offsetof() to compute the start of the original
allocation.  Thus store this information right after the rcu head.

We could simplify this by just placing the rcu_head at the start
of struct nf_hook_entries.  However, this structure is used in
packet processing hotpath, so only place what is needed for that
at the beginning of the struct.

Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h | 19 +++++++++++++++----
 net/netfilter/core.c      | 34 ++++++++++++++++++++++++++++------
 2 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index b24e9b101651..792f6d535707 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -77,17 +77,28 @@ struct nf_hook_entry {
 	void				*priv;
 };
 
+struct nf_hook_entries_rcu_head {
+	struct rcu_head head;
+	void	*allocation;
+};
+
 struct nf_hook_entries {
 	u16				num_hook_entries;
 	/* padding */
 	struct nf_hook_entry		hooks[];
 
-	/* trailer: pointers to original orig_ops of each hook.
-	 *
-	 * This is not part of struct nf_hook_entry since its only
-	 * needed in slow path (hook register/unregister).
+	/* trailer: pointers to original orig_ops of each hook,
+	 * followed by rcu_head and scratch space used for freeing
+	 * the structure via call_rcu.
 	 *
+	 *   This is not part of struct nf_hook_entry since its only
+	 *   needed in slow path (hook register/unregister):
 	 * const struct nf_hook_ops     *orig_ops[]
+	 *
+	 *   For the same reason, we store this at end -- its
+	 *   only needed when a hook is deleted, not during
+	 *   packet path processing:
+	 * struct nf_hook_entries_rcu_head     head
 	 */
 };
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 9a84b6cb99e6..6921f9f1cc81 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -74,7 +74,8 @@ static struct nf_hook_entries *allocate_hook_entries_size(u16 num)
 	struct nf_hook_entries *e;
 	size_t alloc = sizeof(*e) +
 		       sizeof(struct nf_hook_entry) * num +
-		       sizeof(struct nf_hook_ops *) * num;
+		       sizeof(struct nf_hook_ops *) * num +
+		       sizeof(struct nf_hook_entries_rcu_head);
 
 	if (num == 0)
 		return NULL;
@@ -85,6 +86,30 @@ static struct nf_hook_entries *allocate_hook_entries_size(u16 num)
 	return e;
 }
 
+static void __nf_hook_entries_free(struct rcu_head *h)
+{
+	struct nf_hook_entries_rcu_head *head;
+
+	head = container_of(h, struct nf_hook_entries_rcu_head, head);
+	kvfree(head->allocation);
+}
+
+static void nf_hook_entries_free(struct nf_hook_entries *e)
+{
+	struct nf_hook_entries_rcu_head *head;
+	struct nf_hook_ops **ops;
+	unsigned int num;
+
+	if (!e)
+		return;
+
+	num = e->num_hook_entries;
+	ops = nf_hook_entries_get_hook_ops(e);
+	head = (void *)&ops[num];
+	head->allocation = e;
+	call_rcu(&head->head, __nf_hook_entries_free);
+}
+
 static unsigned int accept_all(void *priv,
 			       struct sk_buff *skb,
 			       const struct nf_hook_state *state)
@@ -291,9 +316,8 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 #ifdef HAVE_JUMP_LABEL
 	static_key_slow_inc(&nf_hooks_needed[reg->pf][reg->hooknum]);
 #endif
-	synchronize_net();
 	BUG_ON(p == new_hooks);
-	kvfree(p);
+	nf_hook_entries_free(p);
 	return 0;
 }
 EXPORT_SYMBOL(nf_register_net_hook);
@@ -361,10 +385,8 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 	if (!p)
 		return;
 
-	synchronize_net();
-
 	nf_queue_nf_hook_drop(net);
-	kvfree(p);
+	nf_hook_entries_free(p);
 }
 EXPORT_SYMBOL(nf_unregister_net_hook);
 
-- 
2.13.6

