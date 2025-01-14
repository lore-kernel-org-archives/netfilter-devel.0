Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 274DD1C1AAA
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2025 16:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736872040; cv=none; b=Omom5hTu/JE53C1pTcvKkzYwLiqaFmTHc82y1F4H9Z2mzR5QipG9PMgPSOn5I83w7SZM8sYTgayimVgycZ+HAucx6qN13NF8GhQVqqq7TJgYPtR4PruWZz2564S8zNkdZxO/clYMIKOkl6Zhk9bSyhnFqKpKz8pKtAFL+LMzDuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736872040; c=relaxed/simple;
	bh=rT04vAecuV7JyoOCeS2NAKTsl45P4vNGQ6bXmzrz2hA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BkR5urRdEw5+QLJKuHfMrvD8UmA5zt08n6Y+Pw/gUfIqmMgb30lG88QGDlF9CcdtE1Ft9XONORD4DOFk1/hUhEtf6qnZcT65RZnWAsDXP/z4uw6c0X8g32aDAxVxdos8N3dngrZx5M3r0Fb3lEbjxpc4ug1zztVU6QHDUw7Bydg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v2 6/6] netfilter: flowtable: add CLOSING state
Date: Tue, 14 Jan 2025 17:27:02 +0100
Message-Id: <20250114162702.9128-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250114162702.9128-1-pablo@netfilter.org>
References: <20250114162702.9128-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tcp rst/fin packet triggers an immediate teardown of the flow which
results in sending flows back to the classic forwarding path.

This behaviour was introduced by:

  da5984e51063 ("netfilter: nf_flow_table: add support for sending flows back to the slow path")
  b6f27d322a0a ("netfilter: nf_flow_table: tear down TCP flows if RST or FIN was seen")

whose goal is to expedite removal of flow entries from the hardware
table. Before these patches, the flow was released after the flow entry
timed out.

However, this approach leads to packet races when restoring the
conntrack state as well as late flow re-offload situations when the TCP
connection is ending.

This patch adds a new CLOSING state that is is entered when tcp rst/fin
packet is seen. This allows for an early removal of the flow entry from
the hardware table. But the flow entry still remains in software, so tcp
packets to shut down the flow are not sent back to slow path.

If syn packet is seen from this new CLOSING state, then this flow enters
teardown state, ct state is set to TCP_CONNTRACK_CLOSE state and packet
is sent to slow path, so this TCP reopen scenario can be handled by
conntrack. TCP_CONNTRACK_CLOSE provides a small timeout that aims at
quickly releasing this stale entry from the conntrack table.

Moreover, skip hardware re-offload from flowtable software packet if the
flow is in CLOSING state.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - fix uninitialized bool expired reported by kbuild robot
    - use nf_ct_refresh() to update timeout if closing, but do not extend existing timeout
    - fix nf_flow_state_check() to let rst AND fin packets follow flowtable path
      (return 0 instead of -1)

 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    | 66 +++++++++++++++++++--------
 net/netfilter/nf_flow_table_ip.c      |  6 ++-
 3 files changed, 54 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index b63d53bb9dd6..d711642e78b5 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -163,6 +163,7 @@ struct flow_offload_tuple_rhash {
 enum nf_flow_flags {
 	NF_FLOW_SNAT,
 	NF_FLOW_DNAT,
+	NF_FLOW_CLOSING,
 	NF_FLOW_TEARDOWN,
 	NF_FLOW_HW,
 	NF_FLOW_HW_DYING,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 676d582ef7ab..659087655118 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -161,11 +161,19 @@ void flow_offload_route_init(struct flow_offload *flow,
 }
 EXPORT_SYMBOL_GPL(flow_offload_route_init);
 
-static void flow_offload_fixup_tcp(struct nf_conn *ct)
+static inline bool nf_flow_has_expired(const struct flow_offload *flow)
+{
+	return nf_flow_timeout_delta(flow->timeout) <= 0;
+}
+
+static void flow_offload_fixup_tcp(struct nf_conn *ct, u8 tcp_state)
 {
 	struct ip_ct_tcp *tcp = &ct->proto.tcp;
 
 	spin_lock_bh(&ct->lock);
+	if (tcp->state != tcp_state)
+		tcp->state = tcp_state;
+
 	/* Conntrack state is outdated due to offload bypass.
 	 * Clear IP_CT_TCP_FLAG_MAXACK_SET, otherwise conntracks
 	 * TCP reset validation will fail.
@@ -177,36 +185,58 @@ static void flow_offload_fixup_tcp(struct nf_conn *ct)
 	spin_unlock_bh(&ct->lock);
 }
 
-static void flow_offload_fixup_ct(struct nf_conn *ct)
+static void flow_offload_fixup_ct(struct flow_offload *flow)
 {
+	struct nf_conn *ct = flow->ct;
 	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
+	bool expired, closing = false;
+	u32 offload_timeout = 0;
 	s32 timeout;
 
 	if (l4num == IPPROTO_TCP) {
-		struct nf_tcp_net *tn = nf_tcp_pernet(net);
+		const struct nf_tcp_net *tn = nf_tcp_pernet(net);
+		u8 tcp_state;
 
-		flow_offload_fixup_tcp(ct);
+		/* Enter CLOSE state if fin/rst packet has been seen, this
+		 * allows TCP reopen from conntrack. Otherwise, pick up from
+		 * the last seen TCP state.
+		 */
+		closing = test_bit(NF_FLOW_CLOSING, &flow->flags);
+		if (closing) {
+			flow_offload_fixup_tcp(ct, TCP_CONNTRACK_CLOSE);
+			timeout = READ_ONCE(tn->timeouts[TCP_CONNTRACK_CLOSE]);
+			expired = false;
+		} else {
+			tcp_state = READ_ONCE(ct->proto.tcp.state);
+			flow_offload_fixup_tcp(ct, tcp_state);
+			timeout = READ_ONCE(tn->timeouts[tcp_state]);
+			expired = nf_flow_has_expired(flow);
+		}
+		offload_timeout = READ_ONCE(tn->offload_timeout);
 
-		timeout = tn->timeouts[ct->proto.tcp.state];
-		timeout -= tn->offload_timeout;
 	} else if (l4num == IPPROTO_UDP) {
-		struct nf_udp_net *tn = nf_udp_pernet(net);
+		const struct nf_udp_net *tn = nf_udp_pernet(net);
 		enum udp_conntrack state =
 			test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
 			UDP_CT_REPLIED : UDP_CT_UNREPLIED;
 
-		timeout = tn->timeouts[state];
-		timeout -= tn->offload_timeout;
+		timeout = READ_ONCE(tn->timeouts[state]);
+		expired = nf_flow_has_expired(flow);
+		offload_timeout = READ_ONCE(tn->offload_timeout);
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
+	if (closing ||
+	    nf_flow_timeout_delta(READ_ONCE(ct->timeout)) > (__s32)timeout)
+		nf_ct_refresh(ct, timeout);
 }
 
 static void flow_offload_route_release(struct flow_offload *flow)
@@ -326,18 +356,14 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 	else
 		return;
 
-	if (likely(!nf_flowtable_hw_offload(flow_table)))
+	if (likely(!nf_flowtable_hw_offload(flow_table)) ||
+	    test_bit(NF_FLOW_CLOSING, &flow->flags))
 		return;
 
 	nf_flow_offload_add(flow_table, flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_refresh);
 
-static inline bool nf_flow_has_expired(const struct flow_offload *flow)
-{
-	return nf_flow_timeout_delta(flow->timeout) <= 0;
-}
-
 static void flow_offload_del(struct nf_flowtable *flow_table,
 			     struct flow_offload *flow)
 {
@@ -354,7 +380,7 @@ void flow_offload_teardown(struct flow_offload *flow)
 {
 	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
-	flow_offload_fixup_ct(flow->ct);
+	flow_offload_fixup_ct(flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
@@ -542,6 +568,10 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 		} else {
 			flow_offload_del(flow_table, flow);
 		}
+	} else if (test_bit(NF_FLOW_CLOSING, &flow->flags) &&
+		   test_bit(NF_FLOW_HW, &flow->flags) &&
+		   !test_bit(NF_FLOW_HW_DYING, &flow->flags)) {
+		nf_flow_offload_del(flow_table, flow);
 	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
 		nf_flow_offload_stats(flow_table, flow);
 	}
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index a22856106383..97c6eb8847a0 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -28,11 +28,15 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
 		return 0;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
-	if (unlikely(tcph->fin || tcph->rst)) {
+	if (tcph->syn && test_bit(NF_FLOW_CLOSING, &flow->flags)) {
 		flow_offload_teardown(flow);
 		return -1;
 	}
 
+	if ((tcph->fin || tcph->rst) &&
+	    !test_bit(NF_FLOW_CLOSING, &flow->flags))
+		set_bit(NF_FLOW_CLOSING, &flow->flags);
+
 	return 0;
 }
 
-- 
2.30.2

