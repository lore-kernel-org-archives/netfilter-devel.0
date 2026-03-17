Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C733AE19A;
	Tue, 17 Mar 2026 11:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773746983; cv=none; b=taaZmCMpOCKAUDCaQuSjipupdwaFsxJ4VYQfCkdF1RUBTRdOYzCFpsNDg+qZddxlR1PN6RbVz+UkhfWnWAKZxBiPV5V38mIZqNkTTwQlLci1TPRPPDRupLD1gYNlGSuSki0Dn7fvhTMRxBz1435lRTg8cRTAeEmHKJPH/MRQZD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773746983; c=relaxed/simple;
	bh=cv6wZ8dWLrgsnV3oBF+YY6vLLKiC/IoeN0IEuXPcyfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJ+SfuODkoKIm6RkLMZ7m7PDzGSinh+sInuM9BrdfbvMumYL2zyREH6DDEcj/2RKusbVM1rZeKKFniBKc24HId6zuUm1T9Vhyo80K33HJkRnoyTrmG/Vh5VfBQHqOw8qt91zh69u3IojFMx2EttZmBNQcLjkIgdlHuagaP7eTEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IUNa/SaA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IUNa/SaA"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0AD236026B;
	Tue, 17 Mar 2026 12:29:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773746980;
	bh=ZYJeK+aud/ltHHtuFINdU7sSNOijRKxbP50/Tcgt9Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUNa/SaA05Bdzm8fcNC++Deh/pA/njvLf2sEm+Hkpd7EYk2sj+mkK+1RzFsGIeCKv
	 CCPGl5BWZdCeTgvbUziW6/otRPDT5v+ehROFmyQgbrLlQY3r4xhM4Y4I8l/fMy5jgH
	 IwkPnlDKXnto9LfROjpCxOVYUCHAc7lhE57ECQfnt6eASj1a85nb4rpMekUkNWYGvq
	 ZaMhl6dX1d8uex/VUCWVJpUU/S/c2nI1JG3D7FuIuDn+W+3zq54Q+clqhPzD073lUQ
	 C/s0M0PUIH3Si39hCXBybopskFbM4igTaaaz+WoFDsU5ApKLKnYZg08eFNUCiUSxz7
	 f2NmsVmNGVEeg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org,
	steffen.klassert@secunet.com,
	antony.antony@secunet.com
Subject: [PATCH net-next,RFC 8/8] net: add dev_queue_xmit_list() and use it
Date: Tue, 17 Mar 2026 12:29:17 +0100
Message-ID: <20260317112917.4170466-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260317112917.4170466-1-pablo@netfilter.org>
References: <20260317112917.4170466-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add listified skb tx path and use it to implement the flowtable TX
datapath. Use the dev_dst_drop() and dev_noqueue_xmit_list() helper
functions to build dev_queue_xmit_list().

100dfa74cad9 ("net: dev_queue_xmit() llist adoption") requires to
reverse the skb list and then splice this list to the the last pending
skbuff for transmission.

A few notes:

- I removed:

       if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
               return -1;

Only possible if skb->sk is set on, if my assumption is not correct, this
can be checked from flowtable path.

Reducing the size of dev_queue_xmit_list() is convenient, to focus only
on speeding up what it can be really speed up, so let's return -1 if
either:

- qdisc is not empty

OR

- qdisc is not work-conserving (no TCQ_F_CAN_BYPASS is set on)

Then, the flowtable falls back to call dev_queue_xmit() for each single
skbuff.

Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h        |   2 +
 net/core/dev.c                   | 157 +++++++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_ip.c |  18 ++--
 3 files changed, 169 insertions(+), 8 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c0174aa1037f..34747e9b85d2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3401,6 +3401,8 @@ static inline int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 	return ret;
 }
 
+int dev_queue_xmit_list(struct sk_buff *skb);
+
 int register_netdevice(struct net_device *dev);
 void unregister_netdevice_queue(struct net_device *dev, struct list_head *head);
 void unregister_netdevice_many(struct list_head *head);
diff --git a/net/core/dev.c b/net/core/dev.c
index 8f5bef5a715c..8f114f5af537 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4920,6 +4920,163 @@ int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 }
 EXPORT_SYMBOL(__dev_direct_xmit);
 
+static int dev_queue_xmit_skb_list(struct sk_buff *skb, struct Qdisc *q,
+				   struct net_device *dev,
+				   struct netdev_queue *txq)
+{
+	struct sk_buff *next, *to_free = NULL, *to_free2 = NULL;
+	spinlock_t *root_lock = qdisc_lock(q);
+	struct llist_node *ll_list, *first_n;
+	unsigned long defer_count = 0;
+	int rc = -1;
+
+	tcf_set_drop_reason(skb, SKB_DROP_REASON_QDISC_DROP);
+
+	if (q->flags & TCQ_F_NOLOCK) {
+		if (q->flags & TCQ_F_CAN_BYPASS && nolock_qdisc_is_empty(q) &&
+		    qdisc_run_begin(q)) {
+			/* Retest nolock_qdisc_is_empty() within the protection
+			 * of q->seqlock to protect from racing with requeuing.
+			 */
+			if (unlikely(!nolock_qdisc_is_empty(q))) {
+				to_free2 = qdisc_run_end(q);
+				goto free_skbs;
+			}
+
+			if (sch_direct_xmit(skb, q, dev, txq, NULL, false) &&
+			    !nolock_qdisc_is_empty(q))
+				__qdisc_run(q);
+
+			to_free2 = qdisc_run_end(q);
+			rc = NET_XMIT_SUCCESS;
+			goto free_skbs;
+		}
+	}
+
+	/* Transform skb list to llist in reverse order to splice this batch
+	 * into the defer_list. The next field of skb chain and llist use the
+	 * memory layout.
+	 */
+	ll_list = llist_reverse_order(&skb->ll_node);
+
+	/* Open code llist_add(&skb->ll_node, &q->defer_list) + queue limit.
+	 * In the try_cmpxchg() loop, we want to increment q->defer_count
+	 * at most once to limit the number of skbs in defer_list.
+	 * We perform the defer_count increment only if the list is not empty,
+	 * because some arches have slow atomic_long_inc_return().
+	 */
+	first_n = READ_ONCE(q->defer_list.first);
+	do {
+		if (first_n && !defer_count) {
+			defer_count = atomic_long_inc_return(&q->defer_count);
+			if (unlikely(defer_count > READ_ONCE(net_hotdata.qdisc_max_burst))) {
+				kfree_skb_reason(skb, SKB_DROP_REASON_QDISC_BURST_DROP);
+				return NET_XMIT_DROP;
+			}
+                }
+		/* Splice using last skb in the reverse list. */
+		skb->ll_node.next = first_n;
+	} while (!try_cmpxchg(&q->defer_list.first, &first_n, ll_list));
+
+	/* If defer_list was not empty, we know the cpu which queued
+	 * the first skb will process the whole list for us.
+	 */
+	if (first_n)
+		return NET_XMIT_SUCCESS;
+
+	spin_lock(root_lock);
+
+	ll_list = llist_del_all(&q->defer_list);
+	/* There is a small race because we clear defer_count not atomically
+	 * with the prior llist_del_all(). This means defer_list could grow
+	 * over qdisc_max_burst.
+	 */
+	atomic_long_set(&q->defer_count, 0);
+
+	ll_list = llist_reverse_order(ll_list);
+
+	if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED, &q->state))) {
+		llist_for_each_entry_safe(skb, next, ll_list, ll_node)
+			__qdisc_drop(skb, &to_free);
+		rc = NET_XMIT_DROP;
+		goto unlock;
+	}
+
+	if ((q->flags & TCQ_F_CAN_BYPASS) && !qdisc_qlen(q) &&
+	    !llist_next(ll_list) && qdisc_run_begin(q)) {
+		/*
+		 * This is a work-conserving queue; there are no old skbs
+		 * waiting to be sent out; and the qdisc is not running -
+		 * xmit the skb directly.
+		 */
+		DEBUG_NET_WARN_ON_ONCE(skb != llist_entry(ll_list,
+							  struct sk_buff,
+							  ll_node));
+		qdisc_bstats_update(q, skb);
+		if (sch_direct_xmit(skb, q, dev, txq, root_lock, true))
+			__qdisc_run(q);
+		to_free2 = qdisc_run_end(q);
+		rc = NET_XMIT_SUCCESS;
+	}
+unlock:
+	spin_unlock(root_lock);
+
+free_skbs:
+	tcf_kfree_skb_list(to_free);
+	tcf_kfree_skb_list(to_free2);
+	return rc;
+}
+
+int dev_queue_xmit_list(struct sk_buff *skb)
+{
+	struct net_device *dev = skb->dev;
+	struct netdev_queue *txq;
+	struct sk_buff *iter;
+	struct Qdisc *q;
+	int rc;
+
+	/* Disable soft irqs for various locks below. Also
+	 * stops preemption for RCU.
+	 */
+	rcu_read_lock_bh();
+
+	/* Intentionally, no egress hooks here. This is called from the ingress
+	 * path, which should have already classified packets before calling
+	 * this function.
+	 */
+
+	txq = netdev_tx_queue_mapping(dev, skb);
+	if (!txq)
+		txq = netdev_core_pick_tx(dev, skb, NULL);
+
+	q = rcu_dereference_bh(txq->qdisc);
+
+	iter = skb;
+	while (iter) {
+		dev_dst_drop(dev, iter);
+		skb_copy_queue_mapping(iter, skb);
+		iter = iter->next;
+	}
+
+	if (q->enqueue) {
+		rc = dev_queue_xmit_skb_list(skb, q, dev, txq);
+		goto out;
+	}
+
+	rc = dev_noqueue_xmit_list(skb, dev, txq);
+	rcu_read_unlock_bh();
+
+	if (rc < 0) {
+		dev_core_stats_tx_dropped_inc(dev);
+		kfree_skb_list(skb);
+	}
+	return rc;
+out:
+	rcu_read_unlock_bh();
+	return rc;
+}
+EXPORT_SYMBOL(dev_queue_xmit_list);
+
 /*************************************************************************
  *			Receiver routines
  *************************************************************************/
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 98b5d5e022c8..3d2d02be0f0d 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -863,14 +863,16 @@ static void nf_flow_neigh_xmit_list(struct sk_buff *skb, struct net_device *outd
 		iter = iter->next;
 	}
 
-	iter = skb;
-	while (iter) {
-		struct sk_buff *next;
-
-		next = iter->next;
-		iter->next = NULL;
-		dev_queue_xmit(iter);
-		iter = next;
+	if (dev_queue_xmit_list(skb) == -1) {
+		iter = skb;
+		while (iter) {
+			struct sk_buff *next;
+
+			next = iter->next;
+			iter->next = NULL;
+			dev_queue_xmit(iter);
+			iter = next;
+		}
 	}
 }
 
-- 
2.47.3

