From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 4/4] netfilter: nfnetlink_queue: don't queue dying conntracks to userspace
Date: Wed, 26 Jul 2017 00:02:34 +0200
Message-ID: <20170725220234.29354-5-fw@strlen.de>
References: <20170725220234.29354-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56184 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751746AbdGYWCb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 18:02:31 -0400
In-Reply-To: <20170725220234.29354-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When skb is queued to userspace it leaves softirq/rcu protection.
skb->nfct (via conntrack extensions such as helper) could then reference
modules that no longer exist if the conntrack was not yet confirmed.

nf_ct_iterate_destroy() will set the DYING bit for unconfirmed
conntracks, we therefore solve this race as follows:

1. take the queue spinlock.
2. check if the conntrack is unconfirmed and has dying bit set.
   In this case, we must discard skb while we're still inside
   rcu read-side section.
3. If nf_ct_iterate_destroy() is called right after the packet is queued
   to userspace, it will be removed from the queue via
   nf_ct_iterate_destroy -> nf_queue_nf_hook_drop.

When userspace sends the verdict (nfnetlink takes rcu read lock), there
are two cases to consider:

1. nf_ct_iterate_destroy() was called while packet was out.
   In this case, skb will have been removed from the queue already
   and no reinject takes place as we won't find a matching entry for the
   packet id.

2. nf_ct_iterate_destroy() gets called right after verdict callback
   found and removed the skb from queue list.

   In this case, skb->nfct is marked as dying but it is still valid.
   The skb will be dropped either in nf_conntrack_confirm (we don't
   insert DYING conntracks into hash table) or when we try to queue
   the skb again, but either events don't occur before the rcu read lock
   is dropped.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Changes since v1:
 - guard nf_conntrack.h inclusion with IS_ENABLED() check, else
   this fails to build if NF_QUEUE=y CONNTRACK=n.

 net/netfilter/nfnetlink_queue.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 16fa04086880..f5ef75036041 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -41,6 +41,10 @@
 #include "../bridge/br_private.h"
 #endif
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#include <net/netfilter/nf_conntrack.h>
+#endif
+
 #define NFQNL_QMAX_DEFAULT 1024
 
 /* We're using struct nlattr which has 16bit nla_len. Note that nla_len
@@ -612,6 +616,18 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	return NULL;
 }
 
+static bool nf_ct_drop_unconfirmed(const struct nf_queue_entry *entry)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	static const unsigned long flags = IPS_CONFIRMED | IPS_DYING;
+	const struct nf_conn *ct = (void *)skb_nfct(entry->skb);
+
+	if (ct && ((ct->status & flags) == IPS_DYING))
+		return true;
+#endif
+	return false;
+}
+
 static int
 __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 			struct nf_queue_entry *entry)
@@ -628,6 +644,9 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	}
 	spin_lock_bh(&queue->lock);
 
+	if (nf_ct_drop_unconfirmed(entry))
+		goto err_out_free_nskb;
+
 	if (queue->queue_total >= queue->queue_maxlen) {
 		if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
 			failopen = 1;
-- 
2.13.0

