From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 28/31] netfilter: nf_flow_table: remove unnecessary nat flag check code
Date: Tue,  9 Oct 2018 01:01:22 +0200
Message-ID: <20181008230125.2330-29-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

nf_flow_offload_{ip/ipv6}_hook() check nat flag then, call
nf_flow_nat_{ip/ipv6} but that also check nat flag. so that
nat flag check code in nf_flow_offload_{ip/ipv6}_hook() are unnecessary.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 15ed91309992..1d291a51cd45 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -254,8 +254,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, ip_hdr(skb)->protocol, skb, thoff))
 		return NF_ACCEPT;
 
-	if (flow->flags & (FLOW_OFFLOAD_SNAT | FLOW_OFFLOAD_DNAT) &&
-	    nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
+	if (nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
 		return NF_DROP;
 
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
@@ -471,8 +470,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (skb_try_make_writable(skb, sizeof(*ip6h)))
 		return NF_DROP;
 
-	if (flow->flags & (FLOW_OFFLOAD_SNAT | FLOW_OFFLOAD_DNAT) &&
-	    nf_flow_nat_ipv6(flow, skb, dir) < 0)
+	if (nf_flow_nat_ipv6(flow, skb, dir) < 0)
 		return NF_DROP;
 
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
-- 
2.11.0
