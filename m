Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA073CF03E;
	Thu,  9 Apr 2026 13:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740074; cv=none; b=jFDZgv9jNEBO2aBGHI3/XQmOEQ38X4Ot400rBaFk6HtY99ZhG62uXLwdQD1OdJiuFLdF8GLxmAmn0AfciyfeF8orftXH0EUkMekkDFfBvLMNDFwXm2qDUNBliaZ7724JXQkFH8Vr9etVKMM6UU79h+LQsMS3zBkgPwzBt3ijrPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740074; c=relaxed/simple;
	bh=qgHyUF6g4crc16uF8ArziTxB513q2/NNff1YStmKGOY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gqG88ufibPn3bUWaF5sCWGSCDbJzjiFzB48ud6wQ5MAdufofo9le3/jplBPmdWGflKuAaGo+z5/y05gduNDKLCcn8u5pEhEZgVKyVqmZN1XwYCEABQ8LI6vjIQ29Qvhiaw468j08hL9bCL3EDYMXSY9HC3I6i63XC/6sLklhSTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wAp6p-000000001km-2eEu;
	Thu, 09 Apr 2026 13:07:47 +0000
Date: Thu, 9 Apr 2026 14:07:44 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH RFC net-next 3/4] nf_flow_table: convert hw byte counts and
 update sub-interface stats
Message-ID: <28eadbf14db58dd6e402325b62658a86d240e0f9.1775739840.git.daniel@makrotopia.org>
References: <cover.1775739840.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1775739840.git.daniel@makrotopia.org>

Hardware flow offload counters may report L2 frame bytes while
conntrack expects L3 (IP) bytes. When a driver sets byte_type
to INGRESS_L2 or EGRESS_L2, subtract the appropriate per-direction
encap and tunnel overhead to derive L3 byte counts for conntrack.

Additionally, propagate per-flow stats to bridge, VLAN and PPPoE
sub-interfaces that are bypassed by hardware offloading. Each
sub-interface gets the L3 byte count plus the overhead of any
inner encap layers below it, matching what the software path
would count. Both RX and TX directions are updated.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 net/netfilter/nf_flow_table_offload.c | 174 +++++++++++++++++++++++++-
 1 file changed, 172 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 002ec15d988bd..67452da487c94 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -5,6 +5,8 @@
 #include <linux/netfilter.h>
 #include <linux/rhashtable.h>
 #include <linux/netdevice.h>
+#include <linux/if_vlan.h>
+#include <linux/if_pppox.h>
 #include <linux/tc_act/tc_csum.h>
 #include <net/flow_offload.h>
 #include <net/ip_tunnels.h>
@@ -1008,10 +1010,135 @@ static void flow_offload_tuple_stats(struct flow_offload_work *offload,
 			      &offload->flowtable->flow_block.cb_list);
 }
 
+static int flow_offload_encap_hlen(const struct flow_offload_tuple *tuple,
+				   int idx)
+{
+	switch (tuple->encap[idx].proto) {
+	case htons(ETH_P_8021Q):
+	case htons(ETH_P_8021AD):
+		return VLAN_HLEN;
+	case htons(ETH_P_PPP_SES):
+		return PPPOE_SES_HLEN;
+	}
+	return 0;
+}
+
+static void flow_offload_encap_netstats(struct net_device *dev,
+					__be16 encap_proto,
+					bool rx, u64 pkts, u64 bytes)
+{
+	struct pcpu_sw_netstats *tstats;
+	struct vlan_pcpu_stats *vstats;
+
+	if (encap_proto == htons(ETH_P_8021Q) ||
+	    encap_proto == htons(ETH_P_8021AD)) {
+		vstats = this_cpu_ptr(vlan_dev_priv(dev)->vlan_pcpu_stats);
+		u64_stats_update_begin(&vstats->syncp);
+		if (rx) {
+			u64_stats_add(&vstats->rx_packets, pkts);
+			u64_stats_add(&vstats->rx_bytes, bytes);
+		} else {
+			u64_stats_add(&vstats->tx_packets, pkts);
+			u64_stats_add(&vstats->tx_bytes, bytes);
+		}
+		u64_stats_update_end(&vstats->syncp);
+	} else if (dev->tstats) {
+		tstats = this_cpu_ptr(dev->tstats);
+		u64_stats_update_begin(&tstats->syncp);
+		if (rx) {
+			u64_stats_add(&tstats->rx_packets, pkts);
+			u64_stats_add(&tstats->rx_bytes, bytes);
+		} else {
+			u64_stats_add(&tstats->tx_packets, pkts);
+			u64_stats_add(&tstats->tx_bytes, bytes);
+		}
+		u64_stats_update_end(&tstats->syncp);
+	}
+}
+
+/* Update sub-interface (VLAN, PPPoE) stats for hw-offloaded flows.
+ *
+ * The driver reports L3 (IP) bytes. Each sub-interface in the
+ * software path sees the frame with the headers of all layers
+ * BELOW it still present, so we add back inner-layer overhead.
+ *
+ * encap[] is ordered outermost to innermost, so walk from the
+ * innermost layer outward, accumulating overhead as we go.
+ */
+static void flow_offload_update_encap_stats(struct flow_offload *flow,
+					    struct flow_offload_tuple *tuple,
+					    bool rx, u64 pkts, u64 bytes)
+{
+	struct net_device *dev;
+	int inner_hlen = 0;
+	int i;
+
+	for (i = tuple->encap_num - 1; i >= 0; i--) {
+		if (tuple->in_vlan_ingress & BIT(i))
+			continue;
+
+		dev = dev_get_by_index_rcu(dev_net(flow->ct->ct_net),
+					   tuple->encap_ifidx[i]);
+		if (dev)
+			flow_offload_encap_netstats(dev,
+						    tuple->encap[i].proto, rx,
+						    pkts,
+						    bytes + inner_hlen * pkts);
+
+		inner_hlen += flow_offload_encap_hlen(tuple, i);
+	}
+
+	/* Bridge device sits outside all encap layers -- it sees
+	 * L3 bytes plus the full encap overhead.
+	 */
+	if (tuple->bridge_ifidx) {
+		dev = dev_get_by_index_rcu(dev_net(flow->ct->ct_net),
+					   tuple->bridge_ifidx);
+		if (dev && dev->tstats)
+			flow_offload_encap_netstats(dev, 0, rx, pkts,
+						    bytes + inner_hlen * pkts);
+	}
+}
+
+/* Compute per-direction input overhead from the encap and tunnel
+ * chains. Hardware flow counters report L2 frame bytes but
+ * conntrack expects L3 (inner IP) bytes -- matching what the
+ * software path sees after stripping all encap and tunnel headers.
+ */
+static int flow_offload_input_l2_overhead(struct flow_offload_tuple *tuple)
+{
+	int overhead = ETH_HLEN;
+	int i;
+
+	for (i = 0; i < tuple->encap_num; i++) {
+		if (tuple->in_vlan_ingress & BIT(i))
+			continue;
+
+		overhead += flow_offload_encap_hlen(tuple, i);
+	}
+
+	if (tuple->tun_num) {
+		switch (tuple->tun.l3_proto) {
+		case IPPROTO_IPIP:
+			overhead += sizeof(struct iphdr);
+			break;
+		case IPPROTO_IPV6:
+			overhead += sizeof(struct ipv6hdr);
+			break;
+		}
+	}
+
+	return overhead;
+}
+
 static void flow_offload_work_stats(struct flow_offload_work *offload)
 {
+	struct flow_offload_tuple *tuple;
 	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
+	u64 l3_bytes[FLOW_OFFLOAD_DIR_MAX];
+	int l2_overhead;
 	u64 lastused;
+	int i;
 
 	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
 	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
@@ -1022,16 +1149,59 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 	offload->flow->timeout = max_t(u64, offload->flow->timeout,
 				       lastused + flow_offload_get_timeout(offload->flow));
 
+	/* Convert hardware byte counts to L3 based on what the driver
+	 * reports.  Drivers that already report L3 (or do not set
+	 * byte_type) need no conversion.
+	 */
+	for (i = 0; i < FLOW_OFFLOAD_DIR_MAX; i++) {
+		l2_overhead = 0;
+
+		switch (stats[i].byte_type) {
+		case FLOW_STATS_BYTES_INGRESS_L2:
+			tuple = &offload->flow->tuplehash[i].tuple;
+			l2_overhead = flow_offload_input_l2_overhead(tuple);
+			break;
+		case FLOW_STATS_BYTES_EGRESS_L2:
+			tuple = &offload->flow->tuplehash[!i].tuple;
+			l2_overhead = flow_offload_input_l2_overhead(tuple);
+			break;
+		default:
+			break;
+		}
+		l3_bytes[i] = stats[i].bytes - stats[i].pkts * l2_overhead;
+	}
+
 	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
 		if (stats[0].pkts)
 			nf_ct_acct_add(offload->flow->ct,
 				       FLOW_OFFLOAD_DIR_ORIGINAL,
-				       stats[0].pkts, stats[0].bytes);
+				       stats[0].pkts, l3_bytes[0]);
 		if (stats[1].pkts)
 			nf_ct_acct_add(offload->flow->ct,
 				       FLOW_OFFLOAD_DIR_REPLY,
-				       stats[1].pkts, stats[1].bytes);
+				       stats[1].pkts, l3_bytes[1]);
+	}
+
+	rcu_read_lock();
+	for (i = 0; i < FLOW_OFFLOAD_DIR_MAX; i++) {
+		tuple = &offload->flow->tuplehash[i].tuple;
+		if (!tuple->encap_num)
+			continue;
+
+		/* Input-side encap devices get RX stats */
+		if (stats[i].pkts)
+			flow_offload_update_encap_stats(offload->flow,
+							tuple, true,
+							stats[i].pkts,
+							l3_bytes[i]);
+		/* Same devices get TX stats from the other direction */
+		if (stats[!i].pkts)
+			flow_offload_update_encap_stats(offload->flow,
+							tuple, false,
+							stats[!i].pkts,
+							l3_bytes[!i]);
 	}
+	rcu_read_unlock();
 }
 
 static void flow_offload_work_handler(struct work_struct *work)
-- 
2.53.0
