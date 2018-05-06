From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/51] netfilter: nf_flow_table: add a new flow state for tearing down offloading
Date: Mon,  7 May 2018 00:46:38 +0200
Message-ID: <20180506224709.29100-21-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

On cleanup, this will be treated differently from FLOW_OFFLOAD_DYING:

If FLOW_OFFLOAD_DYING is set, the connection is going away, so both the
offload state and the connection tracking entry will be deleted.

If FLOW_OFFLOAD_TEARDOWN is set, the connection remains alive, but
the offload state is torn down. This is useful for cases that require
more complex state tracking / timeout handling on TCP, or if the
connection has been idle for too long.

Support for sending flows back to the slow path will be implemented in
a following patch

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  2 ++
 net/netfilter/nf_flow_table_core.c    | 22 ++++++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 5aa49524ebef..ba9fa4592f2b 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -68,6 +68,7 @@ struct flow_offload_tuple_rhash {
 #define FLOW_OFFLOAD_SNAT	0x1
 #define FLOW_OFFLOAD_DNAT	0x2
 #define FLOW_OFFLOAD_DYING	0x4
+#define FLOW_OFFLOAD_TEARDOWN	0x8
 
 struct flow_offload {
 	struct flow_offload_tuple_rhash		tuplehash[FLOW_OFFLOAD_DIR_MAX];
@@ -103,6 +104,7 @@ void nf_flow_table_cleanup(struct net *net, struct net_device *dev);
 int nf_flow_table_init(struct nf_flowtable *flow_table);
 void nf_flow_table_free(struct nf_flowtable *flow_table);
 
+void flow_offload_teardown(struct flow_offload *flow);
 static inline void flow_offload_dead(struct flow_offload *flow)
 {
 	flow->flags |= FLOW_OFFLOAD_DYING;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 0d38f20fd226..5a81e4f771e9 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -174,6 +174,12 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 	flow_offload_free(flow);
 }
 
+void flow_offload_teardown(struct flow_offload *flow)
+{
+	flow->flags |= FLOW_OFFLOAD_TEARDOWN;
+}
+EXPORT_SYMBOL_GPL(flow_offload_teardown);
+
 struct flow_offload_tuple_rhash *
 flow_offload_lookup(struct nf_flowtable *flow_table,
 		    struct flow_offload_tuple *tuple)
@@ -226,11 +232,6 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
 }
 
-static inline bool nf_flow_is_dying(const struct flow_offload *flow)
-{
-	return flow->flags & FLOW_OFFLOAD_DYING;
-}
-
 static int nf_flow_offload_gc_step(struct nf_flowtable *flow_table)
 {
 	struct flow_offload_tuple_rhash *tuplehash;
@@ -258,7 +259,8 @@ static int nf_flow_offload_gc_step(struct nf_flowtable *flow_table)
 		flow = container_of(tuplehash, struct flow_offload, tuplehash[0]);
 
 		if (nf_flow_has_expired(flow) ||
-		    nf_flow_is_dying(flow))
+		    (flow->flags & (FLOW_OFFLOAD_DYING |
+				    FLOW_OFFLOAD_TEARDOWN)))
 			flow_offload_del(flow_table, flow);
 	}
 out:
@@ -419,10 +421,14 @@ static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 {
 	struct net_device *dev = data;
 
-	if (dev && flow->tuplehash[0].tuple.iifidx != dev->ifindex)
+	if (!dev) {
+		flow_offload_teardown(flow);
 		return;
+	}
 
-	flow_offload_dead(flow);
+	if (flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
+	    flow->tuplehash[1].tuple.iifidx == dev->ifindex)
+		flow_offload_dead(flow);
 }
 
 static void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
-- 
2.11.0
