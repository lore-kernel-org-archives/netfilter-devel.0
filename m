From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 23/51] netfilter: nf_flow_table: tear down TCP flows if RST or FIN was seen
Date: Mon,  7 May 2018 00:46:41 +0200
Message-ID: <20180506224709.29100-24-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Allow the slow path to handle the shutdown of the connection with proper
timeouts. The packet containing RST/FIN is also sent to the slow path
and the TCP conntrack module will update its state.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index dc570fb7641d..692c75ef5cb7 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -15,6 +15,23 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 
+static int nf_flow_tcp_state_check(struct flow_offload *flow,
+				   struct sk_buff *skb, unsigned int thoff)
+{
+	struct tcphdr *tcph;
+
+	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)))
+		return -1;
+
+	tcph = (void *)(skb_network_header(skb) + thoff);
+	if (unlikely(tcph->fin || tcph->rst)) {
+		flow_offload_teardown(flow);
+		return -1;
+	}
+
+	return 0;
+}
+
 static int nf_flow_nat_ip_tcp(struct sk_buff *skb, unsigned int thoff,
 			      __be32 addr, __be32 new_addr)
 {
@@ -119,10 +136,9 @@ static int nf_flow_dnat_ip(const struct flow_offload *flow, struct sk_buff *skb,
 }
 
 static int nf_flow_nat_ip(const struct flow_offload *flow, struct sk_buff *skb,
-			  enum flow_offload_tuple_dir dir)
+			  unsigned int thoff, enum flow_offload_tuple_dir dir)
 {
 	struct iphdr *iph = ip_hdr(skb);
-	unsigned int thoff = iph->ihl * 4;
 
 	if (flow->flags & FLOW_OFFLOAD_SNAT &&
 	    (nf_flow_snat_port(flow, skb, thoff, iph->protocol, dir) < 0 ||
@@ -202,6 +218,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	struct flow_offload *flow;
 	struct net_device *outdev;
 	const struct rtable *rt;
+	unsigned int thoff;
 	struct iphdr *iph;
 	__be32 nexthop;
 
@@ -230,8 +247,12 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (skb_try_make_writable(skb, sizeof(*iph)))
 		return NF_DROP;
 
+	thoff = ip_hdr(skb)->ihl * 4;
+	if (nf_flow_tcp_state_check(flow, skb, thoff))
+		return NF_ACCEPT;
+
 	if (flow->flags & (FLOW_OFFLOAD_SNAT | FLOW_OFFLOAD_DNAT) &&
-	    nf_flow_nat_ip(flow, skb, dir) < 0)
+	    nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
 		return NF_DROP;
 
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
@@ -439,6 +460,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
 
+	if (nf_flow_tcp_state_check(flow, skb, sizeof(*ip6h)))
+		return NF_ACCEPT;
+
 	if (skb_try_make_writable(skb, sizeof(*ip6h)))
 		return NF_DROP;
 
-- 
2.11.0
