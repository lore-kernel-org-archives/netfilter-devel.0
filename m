From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,RFC 10/10] netfilter: inline nf_hook_slow() and rename it to nf_hook_iterate()
Date: Thu, 13 Oct 2016 14:02:51 +0200
Message-ID: <1476360171-2991-11-git-send-email-pablo@netfilter.org>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46282 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754762AbcJMMPd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 08:15:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1591C9B80C
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03213207C9
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4444207BF
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:09 +0200 (CEST)
In-Reply-To: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that this function has become smaller, inline it and use a better
name to describe what this is doing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h         | 41 +++++++++++++++++++++++++++++++++++++--
 include/linux/netfilter_ingress.h |  2 +-
 net/bridge/br_netfilter_hooks.c   |  4 ++--
 net/netfilter/core.c              | 39 -------------------------------------
 4 files changed, 42 insertions(+), 44 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index e0d000f6c9bf..d0beb6072e14 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -150,7 +150,44 @@ void nf_unregister_sockopt(struct nf_sockopt_ops *reg);
 extern struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 #endif
 
-int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state);
+/* Returns 1 if okfn() needs to be executed by the caller,
+ * -EPERM for NF_DROP, 0 otherwise.  Caller must hold rcu_read_lock.
+ */
+static inline int nf_hook_iterate(struct sk_buff *skb,
+				  struct nf_hook_state *state)
+{
+	struct nf_hook_entry *entry;
+	unsigned int verdict;
+	int ret;
+
+	entry = rcu_dereference(state->hook_entries);
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
+	}
+
+	return 1;
+}
 
 /**
  *	nf_hook - call a netfilter hook
@@ -182,7 +219,7 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct net *net,
 		nf_hook_state_init(&state, hook_head, hook, pf, indev, outdev,
 				   sk, net, okfn);
 
-		ret = nf_hook_slow(skb, &state);
+		ret = nf_hook_iterate(skb, &state);
 	}
 	rcu_read_unlock();
 
diff --git a/include/linux/netfilter_ingress.h b/include/linux/netfilter_ingress.h
index fd44e4131710..c7056a1f9d36 100644
--- a/include/linux/netfilter_ingress.h
+++ b/include/linux/netfilter_ingress.h
@@ -29,7 +29,7 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 	nf_hook_state_init(&state, e, NF_NETDEV_INGRESS,
 			   NFPROTO_NETDEV, skb->dev, NULL, NULL,
 			   dev_net(skb->dev), NULL);
-	return nf_hook_slow(skb, &state);
+	return nf_hook_iterate(skb, &state);
 }
 
 static inline void nf_hook_ingress_init(struct net_device *dev)
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 7e3645fa6339..d153925ec9ec 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -992,7 +992,7 @@ static struct notifier_block brnf_notifier __read_mostly = {
 	.notifier_call = brnf_device_event,
 };
 
-/* recursively invokes nf_hook_slow (again), skipping already-called
+/* recursively invokes nf_hook_iterate (again), skipping already-called
  * hooks (< NF_BR_PRI_BRNF).
  *
  * Called with rcu read lock held.
@@ -1021,7 +1021,7 @@ int br_nf_hook_thresh(unsigned int hook, struct net *net,
 	nf_hook_state_init(&state, elem, hook, NFPROTO_BRIDGE, indev, outdev,
 			   sk, net, okfn);
 
-	ret = nf_hook_slow(skb, &state);
+	ret = nf_hook_iterate(skb, &state);
 	rcu_read_unlock();
 	if (ret == 1)
 		ret = okfn(net, sk, skb);
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index dceb5f92c6a2..5cf941571ecd 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -302,45 +302,6 @@ void _nf_unregister_hooks(struct nf_hook_ops *reg, unsigned int n)
 }
 EXPORT_SYMBOL(_nf_unregister_hooks);
 
-/* Returns 1 if okfn() needs to be executed by the caller,
- * -EPERM for NF_DROP, 0 otherwise.  Caller must hold rcu_read_lock. */
-int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state)
-{
-	struct nf_hook_entry *entry;
-	unsigned int verdict;
-	int ret;
-
-	entry = rcu_dereference(state->hook_entries);
-	while (entry) {
-		RCU_INIT_POINTER(state->hook_entries, entry);
-repeat:
-		verdict = entry->ops.hook(entry->ops.priv, skb, state);
-		switch (verdict) {
-		case NF_ACCEPT:
-			entry = rcu_dereference(entry->next);
-			break;
-		case NF_DROP:
-			kfree_skb(skb);
-			ret = NF_DROP_GETERR(verdict);
-			if (ret == 0)
-				ret = -EPERM;
-
-			return ret;
-		case NF_REPEAT:
-			goto repeat;
-		default:
-			/* Implicit handling for NF_STOLEN, as well as any
-			 * other non conventional verdicts.
-			 */
-			return 0;
-		}
-	}
-
-	return 1;
-}
-EXPORT_SYMBOL(nf_hook_slow);
-
-
 int skb_make_writable(struct sk_buff *skb, unsigned int writable_len)
 {
 	if (writable_len > skb->len)
-- 
2.1.4

