From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 25/51] netfilter: nf_flow_table: fix offloading connections with SNAT+DNAT
Date: Mon,  7 May 2018 00:46:43 +0200
Message-ID: <20180506224709.29100-26-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Pass all NAT types to the flow offload struct, otherwise parts of the
address/port pair do not get translated properly, causing connection
stalls

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 0699981a8511..eb0d1658ac05 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -84,7 +84,7 @@ flow_offload_alloc(struct nf_conn *ct, struct nf_flow_route *route)
 
 	if (ct->status & IPS_SRC_NAT)
 		flow->flags |= FLOW_OFFLOAD_SNAT;
-	else if (ct->status & IPS_DST_NAT)
+	if (ct->status & IPS_DST_NAT)
 		flow->flags |= FLOW_OFFLOAD_DNAT;
 
 	return flow;
-- 
2.11.0
