Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B631DE8AF
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jan 2025 23:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736293855; cv=none; b=H5MdrarsoAuSA1xjfiudIK/GM30pyfrC2SGexmeTnpTsr0Kg9+d1lL6IpTbP/J9Nb2dbFELBu5FKNHZGIC7B3JF8AJg6FPjYZv/KxTRGRBxUyPjHOgDSjHb4fl6VMw3z/xWM3yrAxouEtXOC5QPdUPhfv4Fjay98yGbkDZGO420=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736293855; c=relaxed/simple;
	bh=N/fk0YFmSH83+AIzo3UNKyksEBuPxTN836xJZBURYiQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=de+ISZEsKVpQ8owL9/gtYqXXJSUPmvhbaNWSJGuqU+9xJJSMsFShohWnoN2b9q67NasGY9XjLixTsCkqQf2K5bwScTipzky657ACmq9rfye9Qip2aDKr7GJq4gRpWotnbdRsqtR+mu2gbVpb+gzDXhqvH1y9JGiDx5F80b+SzPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v2 4/6] netfilter: conntrack: rework offload nf_conn timeout extension logic
Date: Wed,  8 Jan 2025 00:50:36 +0100
Message-Id: <20250107235038.115651-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250107235038.115651-1-pablo@netfilter.org>
References: <20250107235038.115651-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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

This allows to remove the nf_ct_offload_timeout helper.
Its safe to use in the add case, but not on teardown.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: I collapsed a small patch to:

-       nf_ct_offload_timeout(flow->ct);
+       nf_ct_refresh(flow->ct, NF_CT_DAY);

and I added a check not to extend timeout in nf_flow_offload_gc_step()
when flow is already in teardown state, otherwise previous timeout
fixup gets an override.

 include/net/netfilter/nf_conntrack.h |  10 ---
 net/netfilter/nf_conntrack_core.c    |   6 --
 net/netfilter/nf_flow_table_core.c   | 105 ++++++++++++++++++++++++++-
 3 files changed, 103 insertions(+), 18 deletions(-)

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
index 687fa99bfb5a..8666d733b984 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1544,12 +1544,6 @@ static void gc_worker(struct work_struct *work)
 
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
index bdde469bbbd1..676d582ef7ab 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -304,7 +304,7 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 		return err;
 	}
 
-	nf_ct_offload_timeout(flow->ct);
+	nf_ct_refresh(flow->ct, NF_CT_DAY);
 
 	if (nf_flowtable_hw_offload(flow_table)) {
 		__set_bit(NF_FLOW_HW, &flow->flags);
@@ -424,15 +424,116 @@ static bool nf_flow_custom_gc(struct nf_flowtable *flow_table,
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
+	bool teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
+
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
 	    nf_flow_custom_gc(flow_table, flow))
 		flow_offload_teardown(flow);
+	else if (!teardown)
+		nf_flow_table_extend_ct_timeout(flow->ct);
 
-	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
+	if (teardown) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
 			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
 				nf_flow_offload_del(flow_table, flow);
-- 
2.30.2

