Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C106C39E16C
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 23:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787787149; cv=none; b=pb5hhtaXSsWJtWt0lCN1P8050UdfHvdhxGdAKGnfCWur611zAxDXG1NawG+Ktua/9NB120MU20cgnHerupP5koHn4Y1YsOCatzqY2Kh2tfkbhuNz0oEhTgDgTms8mzvDg4E9fkgcJilxC+Mm02ck+8SMKcBQt1oAlUQ7sH+hT78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787787149; c=relaxed/simple;
	bh=QCQOF5VtmUx/frt2G3goufshzY6tjHXChEhMOHKGXLk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mmisSL8ey87puSW0Kn41WsSPlWlGjJfVjU4PES43Y62dLb/RccI3S/lSFUWb2Brzt8a0lxb3UKL2oMUsx4TFlOJA5VNTt5L4Ad2Pquy5Jurq0ho34P7g0JOmJmmQa4fzXJma/SS5uEHM3CXeblopfsEXKbNg7SH07d6egzv+TWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OeIbEkxj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OeIbEkxj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787787139;
	bh=gy47BcGso3QCderVN5By5y/h3a0ortx4ZZPK26a/+ms=;
	h=From:To:Subject:Date:From;
	b=OeIbEkxjxAONKjezNl9VjctVqMRMz11BnyYvV76AyIHBiC9HX+S0M2Qw0HlUMzHPZ
	 bcp1nQ02v+QG6DkO+ARynbZBCjc/v+28+eV03GJ2U1OHsymrtzPjfjYpXGuCiDlToa
	 CtGfRFnjhv2aUIWgBugTgG9wDeyUunthdp/2GvaE56+jDECzLFn3Ud3Z/v4e2fFfk/
	 YQ34A6PdA2ALp+lB1fLT6GIc8fDn5uFxi2a/2nqhod6kD45sh6JmEtUty5p0wdbzXB
	 XwZAld1YQMMeO7IFLt3CcCPqjXU/bYs1H6AJSyij6Op8LcjkdI03ha55D8DrGXhtgR
	 IB58z5lWIxJ3w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E54776007D
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2026 01:32:18 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 1/2] netfilter: flowtable: defer ct stats sync via worker
Date: Thu, 27 Aug 2026 01:32:14 +0200
Message-ID: <20260826233215.279277-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the existing gc worker to sync flow stats with ct stats. It is not
safe to access flow->ct from datapath since the GC worker drops the ct
refcount on teardown while datapath could still be accessing the ct
object to update the stats, this is related to conntrack typesafe RCU.

Update nf_ct_acct_add() to take u64 for packets and bytes to ensure u32
truncation is not an issue.

Fixes: 53c2b2899af7 ("netfilter: flowtable: add counter support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - update flowtable ipv6 and tc act_ct too
    - update nf_ct_acct_add() to use u64 to prevent truncation
    - move nf_flow_sync_ct_stats() call after teardown check,
      still race with GC could lead to miss some final packets
      due to lockless rhashtable lookups winning race on teardown,
      this is best effort. Best way would be to expose a netlink
      interface for flow entries, instead of synchronizing with ct.

 include/net/netfilter/nf_conntrack_acct.h |  3 +--
 include/net/netfilter/nf_flow_table.h     |  3 +++
 net/netfilter/nf_conntrack_core.c         |  3 +--
 net/netfilter/nf_flow_table_core.c        | 18 ++++++++++++++++++
 net/netfilter/nf_flow_table_ip.c          | 12 ++++++++----
 net/sched/act_ct.c                        |  6 ++++--
 6 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index a120685cac93..a6700a0cca06 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -65,8 +65,7 @@ static inline void nf_ct_set_acct(struct net *net, bool enable)
 #endif
 }
 
-void nf_ct_acct_add(struct nf_conn *ct, u32 dir, unsigned int packets,
-		    unsigned int bytes);
+void nf_ct_acct_add(struct nf_conn *ct, u32 dir, u64 packets, u64 bytes);
 
 static inline void nf_ct_acct_update(struct nf_conn *ct, u32 dir,
 				     unsigned int bytes)
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f2e2771f188f..6060202133c7 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -171,6 +171,9 @@ struct flow_offload_tuple {
 			u32		iifidx;
 		} tc;
 	};
+
+	atomic64_t			packets;
+	atomic64_t			bytes;
 };
 
 struct flow_offload_tuple_rhash {
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d0d9e5ea84a0..00acd4dee707 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -921,8 +921,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_hash_check_insert);
 
-void nf_ct_acct_add(struct nf_conn *ct, u32 dir, unsigned int packets,
-		    unsigned int bytes)
+void nf_ct_acct_add(struct nf_conn *ct, u32 dir, u64 packets, u64 bytes)
 {
 	struct nf_conn_acct *acct;
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 03241d4bfd5e..625caaa8addf 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -13,6 +13,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/netfilter/nf_conntrack_acct.h>
 
 static DEFINE_MUTEX(flowtable_lock);
 static LIST_HEAD(flowtables);
@@ -565,6 +566,21 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 	nf_ct_put(ct);
 }
 
+static void __nf_flow_sync_ct_stats(struct flow_offload *flow, int dir)
+{
+	u64 pkts, bytes;
+
+	pkts = atomic64_xchg(&flow->tuplehash[dir].tuple.packets, 0);
+	bytes = atomic64_xchg(&flow->tuplehash[dir].tuple.bytes, 0);
+	nf_ct_acct_add(flow->ct, dir, pkts, bytes);
+}
+
+static void nf_flow_sync_ct_stats(struct flow_offload *flow)
+{
+	__nf_flow_sync_ct_stats(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
+	__nf_flow_sync_ct_stats(flow, FLOW_OFFLOAD_DIR_REPLY);
+}
+
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
@@ -581,6 +597,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 		nf_flow_table_extend_ct_timeout(flow->ct);
 	}
 
+	nf_flow_sync_ct_stats(flow);
+
 	if (teardown) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
 			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c8c29a9a1684..a9bf4d61d25b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -509,8 +509,10 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	ip_decrease_ttl(iph);
 	skb_clear_tstamp(skb);
 
-	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
-		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
+	if (flow_table->flags & NF_FLOWTABLE_COUNTER) {
+		atomic64_add(1, &tuplehash->tuple.packets);
+		atomic64_add(skb->len, &tuplehash->tuple.bytes);
+	}
 
 	return 1;
 }
@@ -1104,8 +1106,10 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	ip6h->hop_limit--;
 	skb_clear_tstamp(skb);
 
-	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
-		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
+	if (flow_table->flags & NF_FLOWTABLE_COUNTER) {
+		atomic64_add(1, &tuplehash->tuple.packets);
+		atomic64_add(skb->len, &tuplehash->tuple.bytes);
+	}
 
 	return 1;
 }
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 9080cb386c16..5c647c9fe5d7 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -726,8 +726,10 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 
 	nf_conntrack_get(&ct->ct_general);
 	nf_ct_set(skb, ct, ctinfo);
-	if (nf_ft->flags & NF_FLOWTABLE_COUNTER)
-		nf_ct_acct_update(ct, dir, skb->len);
+	if (nf_ft->flags & NF_FLOWTABLE_COUNTER) {
+		atomic64_add(1, &tuplehash->tuple.packets);
+		atomic64_add(skb->len, &tuplehash->tuple.bytes);
+	}
 
 	return true;
 }
-- 
2.47.3

