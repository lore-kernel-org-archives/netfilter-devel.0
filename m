From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH RFC netfilter-next 1/3] netfilter: introduce accessor functions for hook entries
Date: Thu, 27 Oct 2016 14:27:51 -0400
Message-ID: <1477592873-4468-2-git-send-email-aconole@bytheb.org>
References: <1477592873-4468-1-git-send-email-aconole@bytheb.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34828 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936503AbcJ0S2E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 14:28:04 -0400
Received: by mail-qt0-f193.google.com with SMTP id 23so1192003qtp.2
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 11:28:03 -0700 (PDT)
In-Reply-To: <1477592873-4468-1-git-send-email-aconole@bytheb.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows easier future refactoring.

Signed-off-by: Aaron Conole <aconole@bytheb.org>
---
 include/linux/netfilter.h       | 35 ++++++++++++++++++++++++++++++++++-
 net/bridge/br_netfilter_hooks.c |  2 +-
 net/netfilter/core.c            |  8 +++-----
 net/netfilter/nf_queue.c        |  8 ++++----
 4 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index d0beb607..b25386b 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -80,6 +80,38 @@ struct nf_hook_entry {
 	const struct nf_hook_ops	*orig_ops;
 };
 
+static inline void
+nf_hook_entry_init(struct nf_hook_entry *entry,	const struct nf_hook_ops *ops)
+{
+	entry->next = NULL;
+	entry->ops = *ops;
+	entry->orig_ops = ops;
+}
+
+static inline int
+nf_hook_entry_priority(const struct nf_hook_entry *entry)
+{
+	return entry->ops.priority;
+}
+
+static inline nf_hookfn *
+nf_hook_entry_hookfn(const struct nf_hook_entry *entry)
+{
+	return entry->ops.hook;
+}
+
+static inline void *
+nf_hook_entry_priv(const struct nf_hook_entry *entry)
+{
+	return entry->ops.priv;
+}
+
+static inline const struct nf_hook_ops *
+nf_hook_entry_ops(const struct nf_hook_entry *entry)
+{
+	return entry->orig_ops;
+}
+
 static inline void nf_hook_state_init(struct nf_hook_state *p,
 				      struct nf_hook_entry *hook_entry,
 				      unsigned int hook,
@@ -164,7 +196,8 @@ static inline int nf_hook_iterate(struct sk_buff *skb,
 	while (entry) {
 		RCU_INIT_POINTER(state->hook_entries, entry);
 repeat:
-		verdict = entry->ops.hook(entry->ops.priv, skb, state);
+		verdict = nf_hook_entry_hookfn(entry)(nf_hook_entry_priv(entry),
+						      skb, state);
 		switch (verdict) {
 		case NF_ACCEPT:
 			entry = rcu_dereference(entry->next);
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index d153925..37c4d59 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -1010,7 +1010,7 @@ int br_nf_hook_thresh(unsigned int hook, struct net *net,
 
 	elem = rcu_dereference(net->nf.hooks[NFPROTO_BRIDGE][hook]);
 
-	while (elem && (elem->ops.priority <= NF_BR_PRI_BRNF))
+	while (elem && (nf_hook_entry_priority(elem) <= NF_BR_PRI_BRNF))
 		elem = rcu_dereference(elem->next);
 
 	if (!elem)
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 5cf9415..48782d4 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -102,15 +102,13 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 	if (!entry)
 		return -ENOMEM;
 
-	entry->orig_ops	= reg;
-	entry->ops	= *reg;
-	entry->next	= NULL;
+	nf_hook_entry_init(entry, reg);
 
 	mutex_lock(&nf_hook_mutex);
 
 	/* Find the spot in the list */
 	while ((p = nf_entry_dereference(*pp)) != NULL) {
-		if (reg->priority < p->orig_ops->priority)
+		if (reg->priority < nf_hook_entry_priority(p))
 			break;
 		pp = &p->next;
 	}
@@ -140,7 +138,7 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 
 	mutex_lock(&nf_hook_mutex);
 	while ((p = nf_entry_dereference(*pp)) != NULL) {
-		if (p->orig_ops == reg) {
+		if (nf_hook_entry_ops(p) == reg) {
 			rcu_assign_pointer(*pp, p->next);
 			break;
 		}
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 2d5dca0..2d0dc56 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -186,7 +186,8 @@ static unsigned int nf_iterate(struct sk_buff *skb,
 	while (*entryp) {
 		RCU_INIT_POINTER(state->hook_entries, *entryp);
 repeat:
-		verdict = (*entryp)->ops.hook((*entryp)->ops.priv, skb, state);
+		verdict = nf_hook_entry_hookfn(*entryp)
+			(nf_hook_entry_priv(*entryp), skb, state);
 		if (verdict != NF_ACCEPT) {
 			if (verdict != NF_REPEAT)
 				return verdict;
@@ -202,7 +203,6 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	struct nf_hook_entry *hook_entry;
 	struct sk_buff *skb = entry->skb;
 	const struct nf_afinfo *afinfo;
-	struct nf_hook_ops *elem;
 	int err;
 
 	/* Userspace may request to enqueue this packet again. */
@@ -220,13 +220,13 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	}
 
 	hook_entry = rcu_dereference(entry->state.hook_entries);
-	elem = &hook_entry->ops;
 
 	nf_queue_entry_release_refs(entry);
 
 	/* Continue traversal iff userspace said ok... */
 	if (verdict == NF_REPEAT)
-		verdict = elem->hook(elem->priv, skb, &entry->state);
+		verdict = nf_hook_entry_hookfn(hook_entry)
+			(nf_hook_entry_priv(hook_entry), skb, &entry->state);
 
 	if (verdict == NF_ACCEPT) {
 		afinfo = nf_get_afinfo(entry->state.pf);
-- 
2.7.4

