Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE3980043
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2024 19:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727207157; cv=none; b=l6yedhrjWEZFifeNFLVP6oert42cTaGz/kS9OGz3sptW/TLu9/vcwnXlx5PCZiZmkv1mv1wwj265QLzLRm7EdM2S9q2Xj4+Qgg9QCj6zIEKExQZUrnb0zRg4nziDK7nFMsC91ctZDKPb3P8OSITKPUEFsYStmzvB75ZbE0owMKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727207157; c=relaxed/simple;
	bh=nPz5OAuKU3j+glyxpFr+Y1hK7BDmQLHbfF7y5IPbrsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vj9kyOxkmbiK+aDoBpT9bEDMmjpwyifdKDGpALgIGwebiwHmeAS2Y87QRTptibT8cOHRrth9bRZ2IzXw7ZMFGo6JXwTKYi32ayrOgcgTzDFh6vHxTqJR1dd138BYvwXGWRBbs4ElGzzAahbsN9f9jC8KUiJN1CEpn6x11RczOZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1stBTt-0004ok-Ni; Tue, 24 Sep 2024 21:45:53 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: cmi@nvidia.com,
	nbd@nbd.name,
	sven.auhagen@voleatech.de,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 5/7] netfilter: conntrack: rework offload nf_conn timeout extension logic
Date: Tue, 24 Sep 2024 21:44:13 +0200
Message-ID: <20240924194419.29936-6-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240924194419.29936-1-fw@strlen.de>
References: <20240924194419.29936-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Offload nf_conn entries may not see traffic for a very long time.

To prevent incorrect 'ct is stale' checks during nf_conntrack table
lookup, the gc worker extends the timeout nf_conn entries marked for
offload to a large value.

The existing logic suffers from a few problems.

Garbage collection runs without locks, its unlikely but possible
that @ct is removed right after the 'offload' bit test.

In that case, the timeout of a new/reallocated nf_conn entry will
be increased.

Prevent this by obtaining a reference count on the ct object and
re-check of the confirmed and offload bits.

If those are not set, the ct is being removed, skip the timeout
extension in this case.

Parallel teardown is also problematic:
 cpu1                                cpu2
 gc_worker
                                     calls flow_offload_teardown()
 tests OFFLOAD bit, set
                                     clear OFFLOAD bit
                                     ct->timeout is repaired (e.g. set to timeout[UDP_CT_REPLIED])
 nf_ct_offload_timeout() called
 expire value is fetched
 <INTERRUPT>
-> NF_CT_DAY timeout for flow that isn't offloaded
(and might not see any further packets).

Use cmpxchg: if ct->timeout was repaired after the 2nd 'offload bit' test
passed, then ct->timeout will only be updated of ct->timeout was not
altered in between.

As we already have a gc worker for flowtable entries, ct->timeout repair
can be handled from the flowtable gc worker.

This avoids having flowtable specific logic in the conntrack core
and avoids checking entries that were never offloaded.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h | 10 ---
 net/netfilter/nf_conntrack_core.c    |  6 --
 net/netfilter/nf_flow_table_core.c   | 99 ++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 3cbf29dd0b71..3f02a45773e8 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -312,16 +312,6 @@ static inline bool nf_ct_should_gc(const struct nf_conn *ct)
 
 #define	NF_CT_DAY	(86400 * HZ)
 
-/* Set an arbitrary timeout large enough not to ever expire, this save
- * us a check for the IPS_OFFLOAD_BIT from the packet path via
- * nf_ct_is_expired().
- */
-static inline void nf_ct_offload_timeout(struct nf_conn *ct)
-{
-	if (nf_ct_expires(ct) < NF_CT_DAY / 2)
-		WRITE_ONCE(ct->timeout, nfct_time_stamp + NF_CT_DAY);
-}
-
 struct kernel_param;
 
 int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 62d97d320114..0305d2cf41f6 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1498,12 +1498,6 @@ static void gc_worker(struct work_struct *work)
 
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 
-			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
-				nf_ct_offload_timeout(tmp);
-				if (!nf_conntrack_max95)
-					continue;
-			}
-
 			if (expired_count > GC_SCAN_EXPIRED_MAX) {
 				rcu_read_unlock();
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 4569917dbe0a..10a0fb83a01a 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -424,6 +424,103 @@ static bool nf_flow_custom_gc(struct nf_flowtable *flow_table,
 	return flow_table->type->gc && flow_table->type->gc(flow);
 }
 
+/**
+ * nf_flow_table_tcp_timeout() - new timeout of offloaded tcp entry
+ * @ct:		Flowtable offloaded tcp ct
+ *
+ * Return number of seconds when ct entry should expire.
+ */
+static u32 nf_flow_table_tcp_timeout(const struct nf_conn *ct)
+{
+	u8 state = READ_ONCE(ct->proto.tcp.state);
+
+	switch (state) {
+	case TCP_CONNTRACK_SYN_SENT:
+	case TCP_CONNTRACK_SYN_RECV:
+		return 0;
+	case TCP_CONNTRACK_ESTABLISHED:
+		return NF_CT_DAY;
+	case TCP_CONNTRACK_FIN_WAIT:
+	case TCP_CONNTRACK_CLOSE_WAIT:
+	case TCP_CONNTRACK_LAST_ACK:
+	case TCP_CONNTRACK_TIME_WAIT:
+		return 5 * 60 * HZ;
+	case TCP_CONNTRACK_CLOSE:
+		return 0;
+	}
+
+	return 0;
+}
+
+/**
+ * nf_flow_table_extend_ct_timeout() - Extend ct timeout of offloaded conntrack entry
+ * @ct:		Flowtable offloaded ct
+ *
+ * Datapath lookups in the conntrack table will evict nf_conn entries
+ * if they have expired.
+ *
+ * Once nf_conn entries have been offloaded, nf_conntrack might not see any
+ * packets anymore.  Thus ct->timeout is no longer refreshed and ct can
+ * be evicted.
+ *
+ * To avoid the need for an additional check on the offload bit for every
+ * packet processed via nf_conntrack_in(), set an arbitrary timeout large
+ * enough not to ever expire, this save us a check for the IPS_OFFLOAD_BIT
+ * from the packet path via nf_ct_is_expired().
+ */
+static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
+{
+	static const u32 min_timeout = 5 * 60 * HZ;
+	u32 expires = nf_ct_expires(ct);
+
+	/* normal case: large enough timeout, nothing to do. */
+	if (likely(expires >= min_timeout))
+		return;
+
+	/* must check offload bit after this, we do not hold any locks.
+	 * flowtable and ct entries could have been removed on another CPU.
+	 */
+	if (!refcount_inc_not_zero(&ct->ct_general.use))
+		return;
+
+	/* load ct->status after refcount increase */
+	smp_acquire__after_ctrl_dep();
+
+	if (nf_ct_is_confirmed(ct) &&
+	    test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
+		u8 l4proto = nf_ct_protonum(ct);
+		u32 new_timeout = true;
+
+		switch (l4proto) {
+		case IPPROTO_UDP:
+			new_timeout = NF_CT_DAY;
+			break;
+		case IPPROTO_TCP:
+			new_timeout = nf_flow_table_tcp_timeout(ct);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			break;
+		}
+
+		/* Update to ct->timeout from nf_conntrack happens
+		 * without holding ct->lock.
+		 *
+		 * Use cmpxchg to ensure timeout extension doesn't
+		 * happen when we race with conntrack datapath.
+		 *
+		 * The inverse -- datapath updating ->timeout right
+		 * after this -- is fine, datapath is authoritative.
+		 */
+		if (new_timeout) {
+			new_timeout += nfct_time_stamp;
+			cmpxchg(&ct->timeout, expires, new_timeout);
+		}
+	}
+
+	nf_ct_put(ct);
+}
+
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
@@ -431,6 +528,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 	    nf_ct_is_dying(flow->ct) ||
 	    nf_flow_custom_gc(flow_table, flow))
 		flow_offload_teardown(flow);
+	else
+		nf_flow_table_extend_ct_timeout(flow->ct);
 
 	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
-- 
2.44.2

