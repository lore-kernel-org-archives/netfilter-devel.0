From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH] netfilter: call synchronize_net only once from
 nf_register_net_hooks
Date: Wed, 22 Nov 2017 12:56:59 +0100
Message-ID: <20171122115659.GH24866@breakpoint.cc>
References: <20171122104026.7592-1-gscrivan@redhat.com>
 <20171122110606.GF24866@breakpoint.cc>
 <87a7zea73n.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Giuseppe Scrivano <gscrivan@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54798 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752253AbdKVL57 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 06:57:59 -0500
Content-Disposition: inline
In-Reply-To: <87a7zea73n.fsf@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> Florian Westphal <fw@strlen.de> writes:
> 
> > Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> >> SELinux, if enabled, registers for each new network namespace 6
> >> netfilter hooks.  Avoid to use synchronize_net for each new hook, but do
> >> it once after all the hooks are added.  The net benefit on an SMP
> >> machine with two cores is that creating a new network namespace takes
> >> -40% of the original time.
> >
> > but this needs more work.
> >
> >> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> >> ---
> >>  net/netfilter/core.c | 15 ++++++++++++---
> >>  1 file changed, 12 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> >> index 52cd2901a097..beeb0b36f429 100644
> >> --- a/net/netfilter/core.c
> >> +++ b/net/netfilter/core.c
> >> @@ -252,7 +252,7 @@ static struct nf_hook_entries __rcu **nf_hook_entry_head(struct net *net, const
> >>  	return NULL;
> >>  }
> >>  
> >> -int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
> >> +static int __nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
> >
> > Change this to return struct nf_hook_entries *
> 
> thanks for the quick review.  Are you fine if I change it to:
> 
> static int __nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg, struct nf_hook_entries **old)

You can use ERR_PTR/PTR_ERR instead.

However, I suggest you try to go with call_rcu to get rid of all of the
synchronize_net() calls. I don't even see why its still needed for
nfqueue case provided we invoke the nfqueue drop handler first.

PoC example, untested:

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -77,6 +77,11 @@ struct nf_hook_entry {
 	void				*priv;
 };
 
+struct nf_hook_entries_rcu_head		{
+	struct rcu_head head;
+	void	*allocation;
+};
+
 struct nf_hook_entries {
 	u16				num_hook_entries;
 	/* padding */
@@ -87,10 +92,13 @@ struct nf_hook_entries {
 	 * This is not part of struct nf_hook_entry since its only
 	 * needed in slow path (hook register/unregister).
 	 *
-	 * const struct nf_hook_ops     *orig_ops[]
+	 * const struct nf_hook_ops     *orig_ops[];
+	 * struct nf_hook_entries_rcu_head;
 	 */
 };
 
+void nf_hook_entries_free_rcu(struct nf_hook_entries *e);
+
 static inline struct nf_hook_ops **nf_hook_entries_get_hook_ops(const struct nf_hook_entries *e)
 {
 	unsigned int n = e->num_hook_entries;
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -69,22 +69,61 @@ static DEFINE_MUTEX(nf_hook_mutex);
 #define nf_entry_dereference(e) \
 	rcu_dereference_protected(e, lockdep_is_held(&nf_hook_mutex))
 
+static struct nf_hook_entries_rcu_head *
+nf_hook_entries_rcu_head_get(struct nf_hook_entries *e)
+{
+	unsigned int num = e->num_hook_entries;
+	struct nf_hook_entries_rcu_head *head;
+	static struct nf_hook_ops **ops;
+
+	ops = nf_hook_entries_get_hook_ops(e);
+	head = (void *)&ops[num];
+
+	return head;
+}
+
 static struct nf_hook_entries *allocate_hook_entries_size(u16 num)
 {
 	struct nf_hook_entries *e;
 	size_t alloc = sizeof(*e) +
 		       sizeof(struct nf_hook_entry) * num +
-		       sizeof(struct nf_hook_ops *) * num;
+		       sizeof(struct nf_hook_ops *) * num +
+		       sizeof(struct nf_hook_entries_rcu_head);
 
 	if (num == 0)
 		return NULL;
 
 	e = kvzalloc(alloc, GFP_KERNEL);
-	if (e)
+	if (e) {
+		struct nf_hook_entries_rcu_head *head;
+
 		e->num_hook_entries = num;
+
+		head = nf_hook_entries_rcu_head_get(e);
+		head->allocation = e;
+	}
 	return e;
 }
 
+void __nf_hook_entries_free(struct rcu_head *h)
+{
+	struct nf_hook_entries_rcu_head *head;
+
+	head = container_of(h, struct nf_hook_entries_rcu_head, head);
+	kvfree(head->allocation);
+}
+
+void nf_hook_entries_free_rcu(struct nf_hook_entries *e)
+{
+	struct nf_hook_entries_rcu_head *head;
+
+	head = nf_hook_entries_rcu_head_get(e);
+	if (WARN_ON(e != head->allocation))
+		return;
+
+	call_rcu(&head->head, __nf_hook_entries_free);
+}
+
 static unsigned int accept_all(void *priv,
 			       struct sk_buff *skb,
 			       const struct nf_hook_state *state)
@@ -291,9 +330,9 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 #ifdef HAVE_JUMP_LABEL
 	static_key_slow_inc(&nf_hooks_needed[reg->pf][reg->hooknum]);
 #endif
-	synchronize_net();
 	BUG_ON(p == new_hooks);
-	kvfree(p);
+	if (p)
+		nf_hook_entries_free_rcu(p);
 	return 0;
 }
 EXPORT_SYMBOL(nf_register_net_hook);
@@ -341,7 +380,6 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 {
 	struct nf_hook_entries __rcu **pp;
 	struct nf_hook_entries *p;
-	unsigned int nfq;
 
 	pp = nf_hook_entry_head(net, reg);
 	if (!pp)
@@ -362,13 +400,8 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 	if (!p)
 		return;
 
-	synchronize_net();
-
-	/* other cpu might still process nfqueue verdict that used reg */
-	nfq = nf_queue_nf_hook_drop(net);
-	if (nfq)
-		synchronize_net();
-	kvfree(p);
+	nf_queue_nf_hook_drop(net);
+	nf_hook_entries_free_rcu(p);
 }
 EXPORT_SYMBOL(nf_unregister_net_hook);
 
@@ -395,63 +428,10 @@ EXPORT_SYMBOL(nf_register_net_hooks);
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
 
