From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/52] netfilter: core: remove synchronize_net call if nfqueue is used
Date: Mon,  8 Jan 2018 21:19:19 +0100
Message-ID: <20180108202000.12989-12-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42464 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753889AbeAHUUT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 15:20:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 78F6FE7B97
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 21:20:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 64D7D29B03
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 21:20:17 +0100 (CET)
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

since commit 960632ece6949b ("netfilter: convert hook list to an array")
nfqueue no longer stores a pointer to the hook that caused the packet
to be queued.  Therefore no extra synchronize_net() call is needed after
dropping the packets enqueued by the old rule blob.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_queue.h | 2 +-
 net/netfilter/core.c             | 6 +-----
 net/netfilter/nf_internals.h     | 2 +-
 net/netfilter/nf_queue.c         | 7 ++-----
 net/netfilter/nfnetlink_queue.c  | 9 ++-------
 5 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 814058d0f167..a50a69f5334c 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -25,7 +25,7 @@ struct nf_queue_entry {
 struct nf_queue_handler {
 	int		(*outfn)(struct nf_queue_entry *entry,
 				 unsigned int queuenum);
-	unsigned int	(*nf_hook_drop)(struct net *net);
+	void		(*nf_hook_drop)(struct net *net);
 };
 
 void nf_register_queue_handler(struct net *net, const struct nf_queue_handler *qh);
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index d39bb2c583dc..9a84b6cb99e6 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -341,7 +341,6 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 {
 	struct nf_hook_entries __rcu **pp;
 	struct nf_hook_entries *p;
-	unsigned int nfq;
 
 	pp = nf_hook_entry_head(net, reg);
 	if (!pp)
@@ -364,10 +363,7 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 
 	synchronize_net();
 
-	/* other cpu might still process nfqueue verdict that used reg */
-	nfq = nf_queue_nf_hook_drop(net);
-	if (nfq)
-		synchronize_net();
+	nf_queue_nf_hook_drop(net);
 	kvfree(p);
 }
 EXPORT_SYMBOL(nf_unregister_net_hook);
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index 44284cd2528d..18f6d7ae995b 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -10,7 +10,7 @@
 int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
 	     const struct nf_hook_entries *entries, unsigned int index,
 	     unsigned int verdict);
-unsigned int nf_queue_nf_hook_drop(struct net *net);
+void nf_queue_nf_hook_drop(struct net *net);
 
 /* nf_log.c */
 int __init netfilter_log_init(void);
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index f7e21953b1de..4e42a4a68a0b 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -96,18 +96,15 @@ void nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 }
 EXPORT_SYMBOL_GPL(nf_queue_entry_get_refs);
 
-unsigned int nf_queue_nf_hook_drop(struct net *net)
+void nf_queue_nf_hook_drop(struct net *net)
 {
 	const struct nf_queue_handler *qh;
-	unsigned int count = 0;
 
 	rcu_read_lock();
 	qh = rcu_dereference(net->nf.queue_handler);
 	if (qh)
-		count = qh->nf_hook_drop(net);
+		qh->nf_hook_drop(net);
 	rcu_read_unlock();
-
-	return count;
 }
 EXPORT_SYMBOL_GPL(nf_queue_nf_hook_drop);
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c09b36755ed7..2db35f2d553d 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -941,23 +941,18 @@ static struct notifier_block nfqnl_dev_notifier = {
 	.notifier_call	= nfqnl_rcv_dev_event,
 };
 
-static unsigned int nfqnl_nf_hook_drop(struct net *net)
+static void nfqnl_nf_hook_drop(struct net *net)
 {
 	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
-	unsigned int instances = 0;
 	int i;
 
 	for (i = 0; i < INSTANCE_BUCKETS; i++) {
 		struct nfqnl_instance *inst;
 		struct hlist_head *head = &q->instance_table[i];
 
-		hlist_for_each_entry_rcu(inst, head, hlist) {
+		hlist_for_each_entry_rcu(inst, head, hlist)
 			nfqnl_flush(inst, NULL, 0);
-			instances++;
-		}
 	}
-
-	return instances;
 }
 
 static int
-- 
2.11.0

