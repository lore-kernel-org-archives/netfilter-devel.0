From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/10] netfilter: merge nf_iterate() into nf_hook_slow()
Date: Mon, 17 Oct 2016 13:10:36 +0200
Message-ID: <1476702636-3303-11-git-send-email-pablo@netfilter.org>
References: <1476702636-3303-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43252 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935039AbcJQLK5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 07:10:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1CCA31324D0
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B4DA78433
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B50B978428
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:53 +0200 (CEST)
In-Reply-To: <1476702636-3303-1-git-send-email-pablo@netfilter.org>
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
 net/netfilter/core.c         | 72 +++++++++++++++++---------------------------
 net/netfilter/nf_internals.h |  5 ---
 net/netfilter/nf_queue.c     | 20 ++++++++++++
 3 files changed, 48 insertions(+), 49 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index f299fbde150d..5f015b1948f7 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -302,26 +302,6 @@ void _nf_unregister_hooks(struct nf_hook_ops *reg, unsigned int n)
 }
 EXPORT_SYMBOL(_nf_unregister_hooks);
 
-unsigned int nf_iterate(struct sk_buff *skb,
-			struct nf_hook_state *state,
-			struct nf_hook_entry **entryp)
-{
-	unsigned int verdict;
-
-	do {
-repeat:
-		verdict = (*entryp)->ops.hook((*entryp)->ops.priv, skb, state);
-		if (verdict != NF_ACCEPT) {
-			if (verdict != NF_REPEAT)
-				return verdict;
-			goto repeat;
-		}
-		*entryp = rcu_dereference((*entryp)->next);
-	} while (*entryp);
-	return NF_ACCEPT;
-}
-
-
 /* Returns 1 if okfn() needs to be executed by the caller,
  * -EPERM for NF_DROP, 0 otherwise.  Caller must hold rcu_read_lock. */
 int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
@@ -330,31 +310,35 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 	unsigned int verdict;
 	int ret;
 
+	do {
+		verdict = entry->ops.hook(entry->ops.priv, skb, state);
+		switch (verdict & NF_VERDICT_MASK) {
+		case NF_ACCEPT:
 next_hook:
-	verdict = nf_iterate(skb, state, &entry);
-	switch (verdict & NF_VERDICT_MASK) {
-	case NF_ACCEPT:
-		ret = 1;
-		break;
-	case NF_DROP:
-		kfree_skb(skb);
-		ret = NF_DROP_GETERR(verdict);
-		if (ret == 0)
-			ret = -EPERM;
-		break;
-	case NF_QUEUE:
-		ret = nf_queue(skb, state, entry, verdict);
-		if (ret == 1)
-			goto next_hook;
-		break;
-	default:
-		/* Implicit handling for NF_STOLEN, as well as any other non
-		 * conventional verdicts.
-		 */
-		ret = 0;
-		break;
-	}
-	return ret;
+			entry = rcu_dereference(entry->next);
+			break;
+		case NF_DROP:
+			kfree_skb(skb);
+			ret = NF_DROP_GETERR(verdict);
+			if (ret == 0)
+				ret = -EPERM;
+			return ret;
+		case NF_REPEAT:
+			continue;
+		case NF_QUEUE:
+			ret = nf_queue(skb, state, entry, verdict);
+			if (ret == 1)
+				goto next_hook;
+			return ret;
+		default:
+			/* Implicit handling for NF_STOLEN, as well as any other
+			 * non conventional verdicts.
+			 */
+			return 0;
+		}
+	} while (entry);
+
+	return 1;
 }
 EXPORT_SYMBOL(nf_hook_slow);
 
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index a46f2635b71f..78a59a23421f 100644
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
 int nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 	     struct nf_hook_entry *entry, unsigned int verdict);
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index c5e0d534d352..25ad36f519f7 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -177,6 +177,26 @@ int nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 	return 0;
 }
 
+static unsigned int nf_iterate(struct sk_buff *skb,
+			       struct nf_hook_state *state,
+			       struct nf_hook_entry **entryp)
+{
+	unsigned int verdict;
+
+	do {
+repeat:
+		verdict = (*entryp)->ops.hook((*entryp)->ops.priv, skb, state);
+		if (verdict != NF_ACCEPT) {
+			if (verdict != NF_REPEAT)
+				return verdict;
+			goto repeat;
+		}
+		*entryp = rcu_dereference((*entryp)->next);
+	} while (*entryp);
+
+	return NF_ACCEPT;
+}
+
 void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
 	struct nf_hook_entry *hook_entry = entry->hook;
-- 
2.1.4

