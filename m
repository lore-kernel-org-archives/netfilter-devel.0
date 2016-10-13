From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,RFC 08/10] netfilter: move NF_QUEUE handling away from core
Date: Thu, 13 Oct 2016 14:02:49 +0200
Message-ID: <1476360171-2991-9-git-send-email-pablo@netfilter.org>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46288 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753343AbcJMMPc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 08:15:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3133B9B80A
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1338B207C1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52442207B7
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:08 +0200 (CEST)
In-Reply-To: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Export a new nf_queue() function that translates the NF_QUEUE verdict
depending on the scenario:

1) Drop packet if queue is full.
2) Accept packet if bypass is enabled.
3) Return stolen if packet is enqueued.

We can call this function from xt_NFQUEUE and nft_queue. Thus, we
move packet queuing to userspace away from the core path.

We still have to handle the old QUEUE standard target for
{ip,ip6}_tables, which points to queue number zero. Just in case we
still have any user relying on this behaviour. No need to handle this
from arp and ebtables, they never got a native queue target.

After this patch, we have to inconditionally set state->hook_entries
before calling the hook since nf_iterate() since we need this to know
from what hook the packet is escaping to userspace in nf_queue.

>From nft_verdict_init(), disallow NF_QUEUE as verdict since we always
use the nft_queue expression for this and we don't have any userspace
code using this since the beginning.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_queue.h |  3 +++
 net/ipv4/netfilter/arp_tables.c  |  1 +
 net/ipv4/netfilter/ip_tables.c   |  4 ++++
 net/ipv6/netfilter/ip6_tables.c  |  4 ++++
 net/netfilter/core.c             | 14 ++---------
 net/netfilter/nf_internals.h     |  2 --
 net/netfilter/nf_queue.c         | 51 ++++++++++++++++++++++++++--------------
 net/netfilter/nf_tables_api.c    |  3 +--
 net/netfilter/nf_tables_core.c   |  3 +--
 net/netfilter/nft_queue.c        |  6 ++---
 net/netfilter/xt_NFQUEUE.c       | 29 ++++++++++++-----------
 11 files changed, 67 insertions(+), 53 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 2280cfe86c56..807b9de72b43 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -29,6 +29,9 @@ struct nf_queue_handler {
 
 void nf_register_queue_handler(struct net *net, const struct nf_queue_handler *qh);
 void nf_unregister_queue_handler(struct net *net);
+
+int nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
+	     unsigned int queuenum, bool bypass);
 void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict);
 
 void nf_queue_entry_get_refs(struct nf_queue_entry *entry);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index e76ab23a2deb..83d82f6be8dd 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -28,6 +28,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_arp/arp_tables.h>
+#include <net/netfilter/nf_queue.h>
 #include "../../netfilter/xt_repldata.h"
 
 MODULE_LICENSE("GPL");
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index de4fa03f46f3..7040842c34f4 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -29,6 +29,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <net/netfilter/nf_log.h>
+#include <net/netfilter/nf_queue.h>
 #include "../../netfilter/xt_repldata.h"
 
 MODULE_LICENSE("GPL");
@@ -329,6 +330,9 @@ ipt_do_table(struct sk_buff *skb,
 				/* Pop from stack? */
 				if (v != XT_RETURN) {
 					verdict = (unsigned int)(-v) - 1;
+					if (verdict == NF_QUEUE)
+						verdict = nf_queue(skb, state,
+								   0, false);
 					break;
 				}
 				if (stackidx == 0) {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 7eac01d5d621..7119daa19ba6 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -33,6 +33,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/x_tables.h>
 #include <net/netfilter/nf_log.h>
+#include <net/netfilter/nf_queue.h>
 #include "../../netfilter/xt_repldata.h"
 
 MODULE_LICENSE("GPL");
@@ -361,6 +362,9 @@ ip6t_do_table(struct sk_buff *skb,
 				/* Pop from stack? */
 				if (v != XT_RETURN) {
 					verdict = (unsigned int)(-v) - 1;
+					if (verdict == NF_QUEUE)
+						verdict = nf_queue(skb, state,
+								   0, false);
 					break;
 				}
 				if (stackidx == 0)
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 2b3b2f8e39c4..9ae2febd86e3 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -309,6 +309,7 @@ unsigned int nf_iterate(struct sk_buff *skb,
 	unsigned int verdict;
 
 	while (*entryp) {
+		RCU_INIT_POINTER(state->hook_entries, *entryp);
 repeat:
 		verdict = (*entryp)->ops.hook((*entryp)->ops.priv, skb, state);
 		if (verdict != NF_ACCEPT) {
@@ -331,9 +332,8 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state)
 	int ret;
 
 	entry = rcu_dereference(state->hook_entries);
-next_hook:
 	verdict = nf_iterate(skb, state, &entry);
-	switch (verdict & NF_VERDICT_MASK) {
+	switch (verdict) {
 	case NF_ACCEPT:
 		ret = 1;
 		break;
@@ -343,16 +343,6 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state)
 		if (ret == 0)
 			ret = -EPERM;
 		break;
-	case NF_QUEUE:
-		RCU_INIT_POINTER(state->hook_entries, entry);
-		ret = nf_queue(skb, state, verdict >> NF_VERDICT_QBITS);
-		if (ret < 0) {
-			if (ret == -ESRCH &&
-			    (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
-				goto next_hook;
-			kfree_skb(skb);
-		}
-		/* Fall through. */
 	default:
 		/* Implicit handling for NF_STOLEN, as well as any other non
 		 * conventional verdicts.
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index e0adb5959342..de25d7cdfd42 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -17,8 +17,6 @@ unsigned int nf_iterate(struct sk_buff *skb, struct nf_hook_state *state,
 			struct nf_hook_entry **entryp);
 
 /* nf_queue.c */
-int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
-	     unsigned int queuenum);
 void nf_queue_nf_hook_drop(struct net *net, const struct nf_hook_entry *entry);
 int __init netfilter_queue_init(void);
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index ebb54facd6b5..c97f4e4e25d9 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -111,9 +111,8 @@ void nf_queue_nf_hook_drop(struct net *net, const struct nf_hook_entry *entry)
  * Any packet that leaves via this function must come back
  * through nf_reinject().
  */
-int nf_queue(struct sk_buff *skb,
-	     struct nf_hook_state *state,
-	     unsigned int queuenum)
+static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
+		      unsigned int queuenum)
 {
 	int status = -ENOENT;
 	struct nf_queue_entry *entry = NULL;
@@ -161,6 +160,23 @@ int nf_queue(struct sk_buff *skb,
 	return status;
 }
 
+int nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
+	     unsigned int queuenum, bool bypass)
+{
+	int ret;
+
+	ret = __nf_queue(skb, state, queuenum);
+	if (ret < 0) {
+		if (ret == -ESRCH && bypass)
+			return NF_ACCEPT;
+		kfree_skb(skb);
+		return NF_DROP;
+	}
+
+	return NF_STOLEN;
+}
+EXPORT_SYMBOL_GPL(nf_queue);
+
 void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
 	struct nf_hook_entry *hook_entry;
@@ -169,6 +185,20 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	struct nf_hook_ops *elem;
 	int err;
 
+	/* Userspace may request to enqueue this packet again. */
+	if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
+		err = __nf_queue(skb, &entry->state,
+				 verdict >> NF_VERDICT_QBITS);
+		if (err < 0) {
+			if (err != -ESRCH ||
+			   (!(verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))) {
+				kfree_skb(skb);
+				kfree(entry);
+				return;
+			}
+		}
+	}
+
 	hook_entry = rcu_dereference(entry->state.hook_entries);
 	elem = &hook_entry->ops;
 
@@ -186,10 +216,8 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 
 	hook_entry = rcu_dereference(hook_entry->next);
 
-	if (verdict == NF_ACCEPT) {
-	next_hook:
+	if (verdict == NF_ACCEPT)
 		verdict = nf_iterate(skb, &entry->state, &hook_entry);
-	}
 
 	switch (verdict & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
@@ -198,17 +226,6 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		entry->state.okfn(entry->state.net, entry->state.sk, skb);
 		local_bh_enable();
 		break;
-	case NF_QUEUE:
-		RCU_INIT_POINTER(entry->state.hook_entries, hook_entry);
-		err = nf_queue(skb, &entry->state,
-			       verdict >> NF_VERDICT_QBITS);
-		if (err < 0) {
-			if (err == -ESRCH &&
-			   (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
-				goto next_hook;
-			kfree_skb(skb);
-		}
-		break;
 	case NF_STOLEN:
 		break;
 	default:
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b70d3ea1430e..5402289b9ea8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4583,10 +4583,9 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 
 	switch (data->verdict.code) {
 	default:
-		switch (data->verdict.code & NF_VERDICT_MASK) {
+		switch (data->verdict.code) {
 		case NF_ACCEPT:
 		case NF_DROP:
-		case NF_QUEUE:
 			break;
 		default:
 			return -EINVAL;
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 27fa3c2dea8a..d91fc90bcd4d 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -174,10 +174,9 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		break;
 	}
 
-	switch (regs.verdict.code & NF_VERDICT_MASK) {
+	switch (regs.verdict.code) {
 	case NF_ACCEPT:
 	case NF_DROP:
-	case NF_QUEUE:
 		nft_trace_packet(&info, chain, rule,
 				 rulenum, NFT_TRACETYPE_RULE);
 		return regs.verdict.code;
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index f596a1614daa..015053a2643d 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -48,10 +48,8 @@ static void nft_queue_eval(const struct nft_expr *expr,
 		}
 	}
 
-	ret = NF_QUEUE_NR(queue);
-	if (priv->flags & NFT_QUEUE_FLAG_BYPASS)
-		ret |= NF_VERDICT_FLAG_QUEUE_BYPASS;
-
+	ret = nf_queue(pkt->skb, pkt->xt.state, NF_QUEUE_NR(queue),
+		       priv->flags & NFT_QUEUE_FLAG_BYPASS);
 	regs->verdict.code = ret;
 }
 
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index a360b99a958a..f256a4a173fa 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -32,11 +32,12 @@ nfqueue_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_NFQ_info *tinfo = par->targinfo;
 
-	return NF_QUEUE_NR(tinfo->queuenum);
+	return nf_queue(skb, par->state, tinfo->queuenum, false);
 }
 
-static unsigned int
-nfqueue_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
+static unsigned int __nf_queue_tg(struct sk_buff *skb,
+				  const struct xt_action_param *par,
+				  bool bypass)
 {
 	const struct xt_NFQ_info_v1 *info = par->targinfo;
 	u32 queue = info->queuenum;
@@ -45,18 +46,22 @@ nfqueue_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
 		queue = nfqueue_hash(skb, queue, info->queues_total,
 				     xt_family(par), jhash_initval);
 	}
-	return NF_QUEUE_NR(queue);
+
+	return nf_queue(skb, par->state, info->queuenum, bypass);
+}
+
+static unsigned int
+nfqueue_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	return __nf_queue_tg(skb, par, false);
 }
 
 static unsigned int
 nfqueue_tg_v2(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_NFQ_info_v2 *info = par->targinfo;
-	unsigned int ret = nfqueue_tg_v1(skb, par);
 
-	if (info->bypass)
-		ret |= NF_VERDICT_FLAG_QUEUE_BYPASS;
-	return ret;
+	return __nf_queue_tg(skb, par, info->bypass);
 }
 
 static int nfqueue_tg_check(const struct xt_tgchk_param *par)
@@ -89,7 +94,6 @@ nfqueue_tg_v3(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_NFQ_info_v3 *info = par->targinfo;
 	u32 queue = info->queuenum;
-	int ret;
 
 	if (info->queues_total > 1) {
 		if (info->flags & NFQ_FLAG_CPU_FANOUT) {
@@ -102,11 +106,8 @@ nfqueue_tg_v3(struct sk_buff *skb, const struct xt_action_param *par)
 		}
 	}
 
-	ret = NF_QUEUE_NR(queue);
-	if (info->flags & NFQ_FLAG_BYPASS)
-		ret |= NF_VERDICT_FLAG_QUEUE_BYPASS;
-
-	return ret;
+	return nf_queue(skb, par->state, NF_QUEUE_NR(queue),
+			info->flags & NFQ_FLAG_BYPASS);
 }
 
 static struct xt_target nfqueue_tg_reg[] __read_mostly = {
-- 
2.1.4

