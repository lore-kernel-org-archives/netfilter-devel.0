From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH RFC netfilter-next 3/3] netfilter: convert while loops to for loops
Date: Thu, 27 Oct 2016 14:27:53 -0400
Message-ID: <1477592873-4468-4-git-send-email-aconole@bytheb.org>
References: <1477592873-4468-1-git-send-email-aconole@bytheb.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34833 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942199AbcJ0S2H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 14:28:07 -0400
Received: by mail-qt0-f193.google.com with SMTP id 23so1192046qtp.2
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 11:28:06 -0700 (PDT)
In-Reply-To: <1477592873-4468-1-git-send-email-aconole@bytheb.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is to facilitate converting from a singly-linked list to an array
of elements.

Signed-off-by: Aaron Conole <aconole@bytheb.org>
---
 include/linux/netfilter.h       | 3 +--
 net/bridge/br_netfilter_hooks.c | 8 ++++----
 net/netfilter/core.c            | 6 ++----
 net/netfilter/nf_queue.c        | 3 +--
 4 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index cc2d977..89bb370 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -195,14 +195,13 @@ static inline int nf_hook_iterate(struct sk_buff *skb,
 	int ret;
 
 	entry = rcu_dereference(state->hook_entries);
-	while (entry) {
+	for (; entry; entry = rcu_dereference(entry->next)) {
 		RCU_INIT_POINTER(state->hook_entries, entry);
 repeat:
 		verdict = nf_hook_entry_hookfn(entry)(nf_hook_entry_priv(entry),
 						      skb, state);
 		switch (verdict) {
 		case NF_ACCEPT:
-			entry = rcu_dereference(entry->next);
 			break;
 		case NF_DROP:
 			kfree_skb(skb);
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 37c4d59..ec4c409 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -1008,10 +1008,10 @@ int br_nf_hook_thresh(unsigned int hook, struct net *net,
 	struct nf_hook_state state;
 	int ret;
 
-	elem = rcu_dereference(net->nf.hooks[NFPROTO_BRIDGE][hook]);
-
-	while (elem && (nf_hook_entry_priority(elem) <= NF_BR_PRI_BRNF))
-		elem = rcu_dereference(elem->next);
+	for (elem = rcu_dereference(net->nf.hooks[NFPROTO_BRIDGE][hook]);
+	     elem && (nf_hook_entry_priority(elem) <= NF_BR_PRI_BRNF);
+	     elem = rcu_dereference(elem->next))
+		;
 
 	if (!elem)
 		return okfn(net, sk, skb);
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 48782d4..52ded39 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -107,10 +107,9 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 	mutex_lock(&nf_hook_mutex);
 
 	/* Find the spot in the list */
-	while ((p = nf_entry_dereference(*pp)) != NULL) {
+	for (; (p = nf_entry_dereference(*pp)) != NULL; pp = &p->next) {
 		if (reg->priority < nf_hook_entry_priority(p))
 			break;
-		pp = &p->next;
 	}
 	rcu_assign_pointer(entry->next, p);
 	rcu_assign_pointer(*pp, entry);
@@ -137,12 +136,11 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 		return;
 
 	mutex_lock(&nf_hook_mutex);
-	while ((p = nf_entry_dereference(*pp)) != NULL) {
+	for (; (p = nf_entry_dereference(*pp)) != NULL; pp = &p->next) {
 		if (nf_hook_entry_ops(p) == reg) {
 			rcu_assign_pointer(*pp, p->next);
 			break;
 		}
-		pp = &p->next;
 	}
 	mutex_unlock(&nf_hook_mutex);
 	if (!p) {
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 2d0dc56..2c53357 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -183,7 +183,7 @@ static unsigned int nf_iterate(struct sk_buff *skb,
 {
 	unsigned int verdict;
 
-	while (*entryp) {
+	for (; *entryp; *entryp = rcu_dereference((*entryp)->next)) {
 		RCU_INIT_POINTER(state->hook_entries, *entryp);
 repeat:
 		verdict = nf_hook_entry_hookfn(*entryp)
@@ -193,7 +193,6 @@ static unsigned int nf_iterate(struct sk_buff *skb,
 				return verdict;
 			goto repeat;
 		}
-		*entryp = rcu_dereference((*entryp)->next);
 	}
 	return NF_ACCEPT;
 }
-- 
2.7.4

