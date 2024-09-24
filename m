Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9F74A3E
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2024 19:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727207159; cv=none; b=gIzfbTuX63OBIxMHSzZF92GnXCghmST3/iqguvHwAlW00FAExDOhJG94KpkF1p4gwKLChnpHBHETQPo8tyhsD0EX7U3x+Zn4ou6/RTJjbtKRFiIyUnMG0Wh/4r1pMBxIyna09s0fcrJise29YmOzg1HwXU9NvJbZf1fWuNxwLnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727207159; c=relaxed/simple;
	bh=MlA0mg0icdrz8lVWaq+cmHdIAz+z8g77yDy9sY2lJ5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BePRBHKTJ5QPafvz4VeVyRQbi/kMHTsopYEIUYOMo67RrkzCuFUOir38ChSH8RywmW1Se0PhqOdiGH986ISDXJgQZcyWpNq28b8KHl8f1U9tr/DINmOt5J+iT4Lm2RlghAdXbYo6PH+uavgWRATWrnOV0/VvKJs8jNgUSCu5vg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1stBTu-0004p1-QF; Tue, 24 Sep 2024 21:45:54 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: cmi@nvidia.com,
	nbd@nbd.name,
	sven.auhagen@voleatech.de,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 6/7] netfilter: nft_flow_offload: never grow the timeout when moving packets back to slowpath
Date: Tue, 24 Sep 2024 21:44:14 +0200
Message-ID: <20240924194419.29936-7-fw@strlen.de>
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

The timeout for offloaded packets is set to a large value.  Once packets
are moved back to slowpath again, we must make sure that we don't end up
with an nf_conn entry with a huge (i.e., hours) timeout:

Its possible that we do not see any further traffic, in such case we
end up with a stale entry for a very long time.

flow_offload_fixup_ct() should reduce the timeout to avoid this, but it
has a possible race in case another packet is already handled by software
slowpath, e.g. in reverse direction.

This could happen e.g. when the packet in question exceeds the
MTU or has IP options set while other direction sees a tcp reset or
expired route.

 cpu1 (skb pushed to slowpatch)      cpu2 (dst expired):
 calls nf_conntrack_tcp_packet
                                     calls flow_offload_teardown()
                                     timeout = tn->timeouts[ct->proto.tcp.state];
 sets ct->proto.tcp.state = new_state
 update timeout
                                      WRITE_ONCE(ct->timeout, nfct_time_stamp + timeout);

This could be avoided via cmpxchg tricks, but lets keep it simpler
and clamp the new timeout to TCP_UNACKED, similar to what we do in classic
conntrack for mid-stream pickups.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_core.c | 75 ++++++++++++++++++++++++------
 1 file changed, 62 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 10a0fb83a01a..d0267fe3eb37 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -177,36 +177,71 @@ static void flow_offload_fixup_tcp(struct nf_conn *ct)
 	spin_unlock_bh(&ct->lock);
 }
 
-static void flow_offload_fixup_ct(struct nf_conn *ct)
+/**
+ * flow_offload_fixup_ct() - fix ct timeout on flow entry removal
+ * @ct:			conntrack entry
+ * @expired:		true if flowtable entry timed out
+ *
+ * Offload nf_conn entries have their timeout inflated to a very large
+ * value to prevent garbage collection from kicking in during lookup.
+ *
+ * When the flowtable entry is removed for whatever reason, then the
+ * ct entry must have the timeout set to a saner value to prevent it
+ * from remaining in place for a very long time.
+ *
+ * If the offload flow expired, also subtract the flow offload timeout,
+ * this helps to expire conntrack entries faster, especially for UDP.
+ */
+static void flow_offload_fixup_ct(struct nf_conn *ct, bool expired)
 {
+	u32 expires, offload_timeout = 0;
 	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
 	s32 timeout;
 
 	if (l4num == IPPROTO_TCP) {
-		struct nf_tcp_net *tn = nf_tcp_pernet(net);
+		const struct nf_tcp_net *tn = nf_tcp_pernet(net);
+		u8 tcp_state = READ_ONCE(ct->proto.tcp.state);
+		u32 unacked_timeout;
 
 		flow_offload_fixup_tcp(ct);
 
-		timeout = tn->timeouts[ct->proto.tcp.state];
-		timeout -= tn->offload_timeout;
+		timeout = READ_ONCE(tn->timeouts[tcp_state]);
+		unacked_timeout = READ_ONCE(tn->timeouts[TCP_CONNTRACK_UNACK]);
+
+		/* Limit to unack, in case we missed a possible
+		 * ESTABLISHED -> UNACK transition right before,
+		 * forward path could have updated tcp.state now.
+		 *
+		 * This also won't leave nf_conn hanging around forever
+		 * in case no further packets are received while in
+		 * established state.
+		 */
+		if (timeout > unacked_timeout)
+			timeout = unacked_timeout;
+
+		offload_timeout = READ_ONCE(tn->offload_timeout);
 	} else if (l4num == IPPROTO_UDP) {
-		struct nf_udp_net *tn = nf_udp_pernet(net);
-		enum udp_conntrack state =
-			test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
-			UDP_CT_REPLIED : UDP_CT_UNREPLIED;
+		const struct nf_udp_net *tn = nf_udp_pernet(net);
+		enum udp_conntrack state = test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
+						    UDP_CT_REPLIED : UDP_CT_UNREPLIED;
 
-		timeout = tn->timeouts[state];
-		timeout -= tn->offload_timeout;
+		offload_timeout = READ_ONCE(tn->offload_timeout);
+		timeout = READ_ONCE(tn->timeouts[state]);
 	} else {
 		return;
 	}
 
+	if (expired)
+		timeout -= offload_timeout;
+
 	if (timeout < 0)
 		timeout = 0;
 
-	if (nf_flow_timeout_delta(READ_ONCE(ct->timeout)) > (__s32)timeout)
-		WRITE_ONCE(ct->timeout, nfct_time_stamp + timeout);
+	expires = nf_ct_expires(ct);
+	/* never increase ct->timeout */
+	if (expires > timeout)
+		nf_ct_refresh(ct, timeout);
 }
 
 static void flow_offload_route_release(struct flow_offload *flow)
@@ -350,11 +385,25 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 	flow_offload_free(flow);
 }
 
+/**
+ * flow_offload_teardown() - un-offload a flow
+ * @flow:	flow that should not be offload anymore
+ *
+ * This is called when @flow has been idle for too long or
+ * when there is a permanent processing problem during
+ * flow offload processing.
+ *
+ * Examples of such errors are:
+ *  - offloaded route/dst entry is stale
+ *  - tx function returns error
+ *  - RST flag set (TCP only)
+ */
 void flow_offload_teardown(struct flow_offload *flow)
 {
 	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
-	flow_offload_fixup_ct(flow->ct);
+	flow_offload_fixup_ct(flow->ct,
+			      nf_flow_has_expired(flow));
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
-- 
2.44.2

