From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 21/51] netfilter: nf_flow_table: in flow_offload_lookup, skip entries being deleted
Date: Mon,  7 May 2018 00:46:39 +0200
Message-ID: <20180506224709.29100-22-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Preparation for sending flows back to the slow path

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 5a81e4f771e9..ff5e17a15963 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -184,8 +184,21 @@ struct flow_offload_tuple_rhash *
 flow_offload_lookup(struct nf_flowtable *flow_table,
 		    struct flow_offload_tuple *tuple)
 {
-	return rhashtable_lookup_fast(&flow_table->rhashtable, tuple,
-				      nf_flow_offload_rhash_params);
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct flow_offload *flow;
+	int dir;
+
+	tuplehash = rhashtable_lookup_fast(&flow_table->rhashtable, tuple,
+					   nf_flow_offload_rhash_params);
+	if (!tuplehash)
+		return NULL;
+
+	dir = tuplehash->tuple.dir;
+	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+	if (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN))
+		return NULL;
+
+	return tuplehash;
 }
 EXPORT_SYMBOL_GPL(flow_offload_lookup);
 
-- 
2.11.0
