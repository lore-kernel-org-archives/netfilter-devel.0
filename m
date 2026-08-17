Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4885731352B
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 16:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786985264; cv=none; b=OmnwsE1cQGoi+CkuQt09YuIbSqMzqJcvmxULl1sP+PMQAH+9L8rHlVELUQZHzgMIf6eO3uwhsizCZNisa8aySi/VPyj/2jpdy7hp+mp6J+plWSmAbcy2o7VT61omUa5xun9ceORvjrvfojoB/uR6Pm3xCgdKZOF+IOEX0yGZUD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786985264; c=relaxed/simple;
	bh=bRHwTwMyGv5Ab7j0NMAU2MJcRvjouSkTra6Vx5ElkNo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIwDhNBuKlMHss3/Bua4L8Ozt3QeMUOeQg00P3B/5qpTRObdP0bwVYnD79Y4WUhBIwV7kE9Hw7cjDIgWsGC+GHFyfFPpsj0OHNwdlJ5A8vE5RYlSW0ndrZhieWv3JR/NJW/Pj3MHKSPGy9dmfIFePr3P/YF40dPArn8ysG0Teyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=v27/nQDN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="v27/nQDN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786985261;
	bh=6xlgvOzCfPiEZnhcc8ZpT7FpuLhMl7vvquy8qfLgW9A=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=v27/nQDNuMEuCr7Wz8eU1+Kmjf28Pjr3M36jsRMnJx1aofCpbIYcawRi8kIg+D+SB
	 5t18Md54F1bjo5K1xyVCSP7GQxGnknuGR/Oh6kDdSroSovrBy3wEeYVnT96yleuZA/
	 IgMoqXJipKg1Aw93hXhITBKgNwyCODtKSzWxnQc8Pza8brYE4gtrAIiciEojTpccVz
	 ARuwEfR54Lno9av7uu3pCdIWnkT47JwKLPjqyE3wYxLpz87pAt1HgY4NuUny/BldJT
	 nzl3ZQHeMyRjVIt5IGyvhSD4QrQeo9wH0PUQcLujvXTJL/GDQZIEqJZuz9sMgeCfV1
	 9BnVZ49AdSmwg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2A19E60077
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 18:47:41 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3 2/4] netfilter: flowtable: do not expose expired flows via lookup function
Date: Mon, 17 Aug 2026 18:47:33 +0200
Message-ID: <20260817164735.1207999-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817164735.1207999-1-pablo@netfilter.org>
References: <20260817164735.1207999-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The lookup function currently relies on the teardown bit to skip flow
entries that will be removed soon by the GC. However, datapath can still
reach a flow that has expired without the teardown bit set on. This
includes a flow that is being set up at this time whose timeout is still
not fully initially.

Although the new NF_FLOW_CONFIRMED bit could be used to skip this flow
entry in lookups, skipping a expired flow in the lookup is convenient.
While it is safe to access such expired flow entry from datapath because
of the rcu semantics, the flow->ct pointer for a released flow via rcu
might point to a different conntrack object due to the typesafe rcu
semantics. Note that nf_ct_put() called from flow_offload_free()
releases a conntrack inmmediately.

This patch adds the missing READ_ONCE/WRITE_ONCE to update/access the
flow entry timeout. Then, skip expired flow entries from the flow lookup
function so they become stale inmediately even though the GC did not set
on the teardown bit yet.

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: new in this series

 net/netfilter/nf_flow_table_core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index cbb56ca94717..675d470ea581 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -172,7 +172,7 @@ EXPORT_SYMBOL_GPL(flow_offload_route_init);
 
 static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 {
-	return nf_flow_timeout_delta(flow->timeout) <= 0;
+	return nf_flow_timeout_delta(READ_ONCE(flow->timeout)) <= 0;
 }
 
 static void flow_offload_fixup_tcp(struct nf_conn *ct, u8 tcp_state)
@@ -329,7 +329,7 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
 	int err;
 
-	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
+	WRITE_ONCE(flow->timeout, nf_flowtable_time_stamp);
 
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
 				     &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
@@ -352,6 +352,7 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 	if (nf_flowtable_hw_offload(flow_table))
 		nf_flow_offload_add(flow_table, flow);
 
+	WRITE_ONCE(flow->timeout, flow->timeout + flow_offload_get_timeout(flow));
 	smp_mb__before_atomic();
 	set_bit(NF_FLOW_CONFIRMED, &flow->flags);
 
@@ -414,10 +415,9 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
-		return NULL;
-
-	if (unlikely(nf_ct_is_dying(flow->ct)))
+	if (nf_flow_has_expired(flow) ||
+	    test_bit(NF_FLOW_TEARDOWN, &flow->flags) ||
+	    unlikely(nf_ct_is_dying(flow->ct)))
 		return NULL;
 
 	return tuplehash;
-- 
2.47.3

