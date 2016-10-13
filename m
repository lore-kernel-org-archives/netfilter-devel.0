From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,RFC 09/10] netfilter: merge nf_iterate() into nf_hook_slow()
Date: Thu, 13 Oct 2016 14:02:50 +0200
Message-ID: <1476360171-2991-10-git-send-email-pablo@netfilter.org>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46286 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754667AbcJMMPd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 08:15:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7FED59B80E
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D47C207BA
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14E71207BA
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:09 +0200 (CEST)
In-Reply-To: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_iterate() has become rather simple, we can integrate this code into
nf_hook_slow() to reduce the amount of LOC in the core path.

However, we still need nf_iterate() around for nf_queue packet handling,
so move this function there where we only need it. I think it should be
possible to refactor nf_queue code to get rid of it definitely, but
given this is slow path anyway, let's have a look this later.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c         | 64 +++++++++++++++++---------------------------
 net/netfilter/nf_internals.h |  5 ----
 net/netfilter/nf_queue.c     | 20 ++++++++++++++
 3 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 9ae2febd86e3..dceb5f92c6a2 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -302,27 +302,6 @@ void _nf_unregister_hooks(struct nf_hook_ops *reg, unsigned int n)
 }
 EXPORT_SYMBOL(_nf_unregister_hooks);
 
-unsigned int nf_iterate(struct sk_buff *skb,
-			struct nf_hook_state *state,
-			struct nf_hook_entry **entryp)
-{
-	unsigned int verdict;
-
-	while (*entryp) {
-		RCU_INIT_POINTER(state->hook_entries, *entryp);
-repeat:
-		verdict = (*entryp)->ops.hook((*entryp)->ops.priv, skb, state);
-		if (verdict != NF_ACCEPT) {
-			if (verdict != NF_REPEAT)
-				return verdict;
-			goto repeat;
-		}
-		*entryp = rcu_dereference((*entryp)->next);
-	}
-	return NF_ACCEPT;
-}
-
-
 /* Returns 1 if okfn() needs to be executed by the caller,
  * -EPERM for NF_DROP, 0 otherwise.  Caller must hold rcu_read_lock. */
 int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state)
@@ -332,25 +311,32 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state)
 	int ret;
 
 	entry = rcu_dereference(state->hook_entries);
-	verdict = nf_iterate(skb, state, &entry);
-	switch (verdict) {
-	case NF_ACCEPT:
-		ret = 1;
-		break;
-	case NF_DROP:
-		kfree_skb(skb);
-		ret = NF_DROP_GETERR(verdict);
-		if (ret == 0)
-			ret = -EPERM;
-		break;
-	default:
-		/* Implicit handling for NF_STOLEN, as well as any other non
-		 * conventional verdicts.
-		 */
-		ret = 0;
-		break;
+	while (entry) {
+		RCU_INIT_POINTER(state->hook_entries, entry);
+repeat:
+		verdict = entry->ops.hook(entry->ops.priv, skb, state);
+		switch (verdict) {
+		case NF_ACCEPT:
+			entry = rcu_dereference(entry->next);
+			break;
+		case NF_DROP:
+			kfree_skb(skb);
+			ret = NF_DROP_GETERR(verdict);
+			if (ret == 0)
+				ret = -EPERM;
+
+			return ret;
+		case NF_REPEAT:
+			goto repeat;
+		default:
+			/* Implicit handling for NF_STOLEN, as well as any
+			 * other non conventional verdicts.
+			 */
+			return 0;
+		}
 	}
-	return ret;
+
+	return 1;
 }
 EXPORT_SYMBOL(nf_hook_slow);
 
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index de25d7cdfd42..22b4915c48f4 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -11,11 +11,6 @@
 #define NFDEBUG(format, args...)
 #endif
 
-
-/* core.c */
-unsigned int nf_iterate(struct sk_buff *skb, struct nf_hook_state *state,
-			struct nf_hook_entry **entryp);
-
 /* nf_queue.c */
 void nf_queue_nf_hook_drop(struct net *net, const struct nf_hook_entry *entry);
 int __init netfilter_queue_init(void);
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index c97f4e4e25d9..2b5429c969d5 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -177,6 +177,26 @@ int nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 }
 EXPORT_SYMBOL_GPL(nf_queue);
 
+static unsigned int nf_iterate(struct sk_buff *skb,
+			       struct nf_hook_state *state,
+			       struct nf_hook_entry **entryp)
+{
+	unsigned int verdict;
+
+	while (*entryp) {
+		RCU_INIT_POINTER(state->hook_entries, *entryp);
+repeat:
+		verdict = (*entryp)->ops.hook((*entryp)->ops.priv, skb, state);
+		if (verdict != NF_ACCEPT) {
+			if (verdict != NF_REPEAT)
+				return verdict;
+			goto repeat;
+		}
+		*entryp = rcu_dereference((*entryp)->next);
+	}
+	return NF_ACCEPT;
+}
+
 void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
 	struct nf_hook_entry *hook_entry;
-- 
2.1.4

