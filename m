Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F074B1DC1AB;
	Fri,  6 Feb 2026 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770391868; cv=none; b=OXsiaoIVgeUwGYrljjUTI5mWS80kG9MPNCWqOPqMGLFu2EhHPnEKWuGNCieo+OtOJhBquzx2BHU98mf5hk5gnejivbHu9A0Hn7tcQ5n0MsKBO2Nv2BK9EuGwoy5q8R9x0Vjqb2yLeIE6yhjOcH7KYWN5IsMyC+RnmUS7O8EQMms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770391868; c=relaxed/simple;
	bh=yZHUxD0HGS++xaC4ODShqzXV+2e3yyl7LTI1TiJGjOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/baZvDerEuUrLs8yRRJtoa1cGRjgo8HB+tGIgTBDcsHjV5sM/IqXtDXhTRJUj1YkqcWnawd9dB3L09tC2PzJtdxBe+IGm1uhmRE1qFz0sTx7w3biY/SinkFLs2S5UANYXmXHGLaBetDHI+E12FouH+kOvSrAXrsVdxqHugzfT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 78AF860345; Fri, 06 Feb 2026 16:31:06 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 02/11] netfilter: nfnetlink_queue: do shared-unconfirmed check before segmentation
Date: Fri,  6 Feb 2026 16:30:39 +0100
Message-ID: <20260206153048.17570-3-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206153048.17570-1-fw@strlen.de>
References: <20260206153048.17570-1-fw@strlen.de>
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
 include/net/netfilter/nf_queue.h |   1 +
 net/netfilter/nfnetlink_queue.c  | 123 +++++++++++++++++++------------
 2 files changed, 75 insertions(+), 49 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index e6803831d6af..45eb26b2e95b 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -21,6 +21,7 @@ struct nf_queue_entry {
 	struct net_device	*physout;
 #endif
 	struct nf_hook_state	state;
+	bool			nf_ct_is_unconfirmed;
 	u16			size; /* sizeof(entry) + saved route keys */
 	u16			queue_num;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 671b52c652ef..f1c8049861a6 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -435,6 +435,34 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
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
+	if (is_unconfirmed)
+		*is_unconfirmed = true;
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
@@ -462,6 +490,24 @@ static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 			break;
 		}
 	}
+
+	if (verdict != NF_DROP && entry->nf_ct_is_unconfirmed) {
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
+		if (nf_ct_drop_unconfirmed(entry, NULL))
+			verdict = NF_DROP;
+	}
+
 	nf_reinject(entry, verdict);
 }
 
@@ -891,49 +937,6 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -950,9 +953,6 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	}
 	spin_lock_bh(&queue->lock);
 
-	if (nf_ct_drop_unconfirmed(entry))
-		goto err_out_free_nskb;
-
 	if (queue->queue_total >= queue->queue_maxlen)
 		goto err_out_queue_drop;
 
@@ -995,7 +995,6 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 		else
 			net_warn_ratelimited("nf_queue: hash insert failed: %d\n", err);
 	}
-err_out_free_nskb:
 	kfree_skb(nskb);
 err_out_unlock:
 	spin_unlock_bh(&queue->lock);
@@ -1074,9 +1073,10 @@ __nfqnl_enqueue_packet_gso(struct net *net, struct nfqnl_instance *queue,
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
@@ -1100,6 +1100,15 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
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
 
@@ -1113,7 +1122,23 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		goto out_err;
 	queued = 0;
 	err = 0;
+
 	skb_list_walk_safe(segs, segs, nskb) {
+		if (ct_is_unconfirmed && queued > 0) {
+			/* skb_gso_segment() increments the ct refcount.
+			 * This is a problem for unconfirmed (not in hash)
+			 * entries, those can race when reinjections happen
+			 * in parallel.
+			 *
+			 * Annotate this for all queued entries except the
+			 * first one.
+			 *
+			 * As long as the first one is reinjected first it
+			 * will do the confirmation for us.
+			 */
+			entry->nf_ct_is_unconfirmed = ct_is_unconfirmed;
+		}
+
 		if (err == 0)
 			err = __nfqnl_enqueue_packet_gso(net, queue,
 							segs, entry);
-- 
2.52.0

