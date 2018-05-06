From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 19/51] netfilter: nf_flow_table: make flow_offload_dead inline
Date: Mon,  7 May 2018 00:46:37 +0200
Message-ID: <20180506224709.29100-20-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

It is too trivial to keep as a separate exported function

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 5 ++++-
 net/netfilter/nf_flow_table_core.c    | 6 ------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ab408adba688..5aa49524ebef 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -103,7 +103,10 @@ void nf_flow_table_cleanup(struct net *net, struct net_device *dev);
 int nf_flow_table_init(struct nf_flowtable *flow_table);
 void nf_flow_table_free(struct nf_flowtable *flow_table);
 
-void flow_offload_dead(struct flow_offload *flow);
+static inline void flow_offload_dead(struct flow_offload *flow)
+{
+	flow->flags |= FLOW_OFFLOAD_DYING;
+}
 
 int nf_flow_snat_port(const struct flow_offload *flow,
 		      struct sk_buff *skb, unsigned int thoff,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index e761359b56a9..0d38f20fd226 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -113,12 +113,6 @@ void flow_offload_free(struct flow_offload *flow)
 }
 EXPORT_SYMBOL_GPL(flow_offload_free);
 
-void flow_offload_dead(struct flow_offload *flow)
-{
-	flow->flags |= FLOW_OFFLOAD_DYING;
-}
-EXPORT_SYMBOL_GPL(flow_offload_dead);
-
 static u32 flow_offload_hash(const void *data, u32 len, u32 seed)
 {
 	const struct flow_offload_tuple *tuple = data;
-- 
2.11.0
