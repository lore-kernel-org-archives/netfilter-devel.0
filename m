Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB3A33A9F9
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Jan 2026 13:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769435415; cv=none; b=huMjCF2zyDTXaU1tfSNCUNDU7K+HDZle0Goe+7Lt89DknwuUmZa25T1qVb9aGhIj+apcCVVkNnIadg23xcJlik+AyUz1UkIJxL6O3slaWy0PdHqwqfTvW4wu5GKXthep1lq/tCDXVj6aKJgGzBCTEZ9GBzeGX70r/3BFkz8v7FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769435415; c=relaxed/simple;
	bh=BQw65kscQaHiz/Em1Y7r30a5iNgmPljMS5Y2Gn+oDCw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Muq6anmd913irO0fY/CrJggBgNrsiFfq6I3Ic2HdYSW62xf1FmpJlLeLUJzu5AHKKCFRHcEN/nUqAgX2nSUo/b2cFiLzO5CWE3Su1Arj1gcKs5RR+LikCm2o0RIi3D9wIEFE4G7y9FHKWfuBV/JF1aI2LGJpKfdjujwl4uwLvqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E7D66602B6; Mon, 26 Jan 2026 14:50:10 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Ulrich Weber <ulrich.weber@gmail.com>
Subject: [PATCH nf-next 1/2] netfilter: nfnetlink_queue: do shared-unconfirmed check before segmentation
Date: Mon, 26 Jan 2026 14:49:55 +0100
Message-ID: <20260126134958.13860-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ulrich reports a regression with nfqueue:

If an application did not set the 'F_GSO' capability flag and a gso
packet with an unconfirmed nf_conn entry is received all packets are
now dropped instead of queued, because the check happens after
skb_gso_segment().  In that case, we did have exclusive ownership
of the skb and its associated conntrack entry.  The elevated use
count is due to skb_clone happening via skb_gso_segment().

Move the check so that its peformed vs. the aggregated packet.

Then, annotate the individual segments except the first one so we
can do a 2nd check at reinject time.

For the normal case, where userspace does in-order reinjects, this avoids
packet drops: first reinjected segment continues traversal and confirms
entry, remaining segments observe the confirmed entry.

While at it, simplify nf_ct_drop_unconfirmed(): We only care about
unconfirmed entries with a refcnt > 1, there is no need to special-case
dying entries.

This only happens with UDP.  With TCP, the only unconfirmed packet will
be the TCP SYN, those aren't aggregated by GRO.

Next patch adds a udpgro test case to cover this scenario.

Reported-by: Ulrich Weber <ulrich.weber@gmail.com>
Fixes: 7d8dc1c7be8d ("netfilter: nf_queue: drop packets with cloned unconfirmed conntracks")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 NB: This is on top of 'netfilter: nfnetlink_queue: optimize verdict lookup with hash table',
 it won't apply as-is to main branch.

 include/net/netfilter/nf_queue.h |   1 +
 net/netfilter/nfnetlink_queue.c  | 119 ++++++++++++++++++-------------
 2 files changed, 69 insertions(+), 51 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index e6803831d6af..70dac4ab2f35 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -21,6 +21,7 @@ struct nf_queue_entry {
 	struct net_device	*physout;
 #endif
 	struct nf_hook_state	state;
+	bool			nf_ct_was_unconfirmed;
 	u16			size; /* sizeof(entry) + saved route keys */
 	u16			queue_num;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 671b52c652ef..930b0e534d1e 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -435,6 +435,33 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	nf_queue_entry_free(entry);
 }
 
+/* return true if the entry has an unconfirmed conntrack attached that isn't owned by us
+ * exclusively.
+ */
+static bool nf_ct_drop_unconfirmed(const struct nf_queue_entry *entry, bool *is_unconfirmed)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	struct nf_conn *ct = (void *)skb_nfct(entry->skb);
+
+	if (!ct || nf_ct_is_confirmed(ct))
+		return false;
+
+	*is_unconfirmed = true;
+
+	/* in some cases skb_clone() can occur after initial conntrack
+	 * pickup, but conntrack assumes exclusive skb->_nfct ownership for
+	 * unconfirmed entries.
+	 *
+	 * This happens for br_netfilter and with ip multicast routing.
+	 * This can't be solved with serialization here because one clone
+	 * could have been queued for local delivery or could be transmitted
+	 * in parallel on another CPU.
+	 */
+	return refcount_read(&ct->ct_general.use) > 1;
+#endif
+	return false;
+}
+
 static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
 	const struct nf_ct_hook *ct_hook;
@@ -462,6 +489,26 @@ static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 			break;
 		}
 	}
+
+	if (verdict != NF_DROP && entry->nf_ct_was_unconfirmed) {
+		bool is_unconfirmed = false;
+
+		/* If first queued segment was already reinjected then
+		 * there is a good chance the ct entry is now confirmed.
+		 *
+		 * Handle the rare cases:
+		 *  - out-of-order verdict
+		 *  - threaded userspace reinjecting in parallel
+		 *  - first segment was dropped
+		 *
+		 * In all of those cases we can't handle this packet
+		 * because we can't be sure that another CPU won't modify
+		 * nf_conn->ext in parallel which isn't allowed.
+		 */
+		if (nf_ct_drop_unconfirmed(entry, &is_unconfirmed))
+			verdict = NF_DROP;
+	}
+
 	nf_reinject(entry, verdict);
 }
 
@@ -891,49 +938,6 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	return NULL;
 }
 
-static bool nf_ct_drop_unconfirmed(const struct nf_queue_entry *entry)
-{
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	static const unsigned long flags = IPS_CONFIRMED | IPS_DYING;
-	struct nf_conn *ct = (void *)skb_nfct(entry->skb);
-	unsigned long status;
-	unsigned int use;
-
-	if (!ct)
-		return false;
-
-	status = READ_ONCE(ct->status);
-	if ((status & flags) == IPS_DYING)
-		return true;
-
-	if (status & IPS_CONFIRMED)
-		return false;
-
-	/* in some cases skb_clone() can occur after initial conntrack
-	 * pickup, but conntrack assumes exclusive skb->_nfct ownership for
-	 * unconfirmed entries.
-	 *
-	 * This happens for br_netfilter and with ip multicast routing.
-	 * We can't be solved with serialization here because one clone could
-	 * have been queued for local delivery.
-	 */
-	use = refcount_read(&ct->ct_general.use);
-	if (likely(use == 1))
-		return false;
-
-	/* Can't decrement further? Exclusive ownership. */
-	if (!refcount_dec_not_one(&ct->ct_general.use))
-		return false;
-
-	skb_set_nfct(entry->skb, 0);
-	/* No nf_ct_put(): we already decremented .use and it cannot
-	 * drop down to 0.
-	 */
-	return true;
-#endif
-	return false;
-}
-
 static int
 __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 			struct nf_queue_entry *entry)
@@ -950,9 +954,6 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	}
 	spin_lock_bh(&queue->lock);
 
-	if (nf_ct_drop_unconfirmed(entry))
-		goto err_out_free_nskb;
-
 	if (queue->queue_total >= queue->queue_maxlen)
 		goto err_out_queue_drop;
 
@@ -995,7 +996,6 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 		else
 			net_warn_ratelimited("nf_queue: hash insert failed: %d\n", err);
 	}
-err_out_free_nskb:
 	kfree_skb(nskb);
 err_out_unlock:
 	spin_unlock_bh(&queue->lock);
@@ -1074,9 +1074,10 @@ __nfqnl_enqueue_packet_gso(struct net *net, struct nfqnl_instance *queue,
 static int
 nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 {
-	unsigned int queued;
-	struct nfqnl_instance *queue;
 	struct sk_buff *skb, *segs, *nskb;
+	bool ct_is_unconfirmed = false;
+	struct nfqnl_instance *queue;
+	unsigned int queued;
 	int err = -ENOBUFS;
 	struct net *net = entry->state.net;
 	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
@@ -1100,6 +1101,15 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		break;
 	}
 
+	/* Check if someone already holds another reference to
+	 * unconfirmed ct.  If so, we cannot queue the skb:
+	 * concurrent modifications of nf_conn->ext are not
+	 * allowed and we can't know if another CPU isn't
+	 * processing the same nf_conn entry in parallel.
+	 */
+	if (nf_ct_drop_unconfirmed(entry, &ct_is_unconfirmed))
+		return -EINVAL;
+
 	if (!skb_is_gso(skb) || ((queue->flags & NFQA_CFG_F_GSO) && !skb_is_gso_sctp(skb)))
 		return __nfqnl_enqueue_packet(net, queue, entry);
 
@@ -1117,10 +1127,17 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		if (err == 0)
 			err = __nfqnl_enqueue_packet_gso(net, queue,
 							segs, entry);
-		if (err == 0)
+		if (err == 0) {
 			queued++;
-		else
+			/* skb_gso_segment() caused increment of ct refcount.
+			 * Annotate this for all queued entries except the first one
+			 * queued.  As long as the first one is reinjected first it
+			 * will do the confirmation for us.
+			 */
+			entry->nf_ct_was_unconfirmed = ct_is_unconfirmed;
+		} else {
 			kfree_skb(segs);
+		}
 	}
 
 	if (queued) {
-- 
2.52.0

