From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/37] netfilter: nf_flow_table: make nf_flow_table_iterate() static
Date: Fri, 21 Dec 2018 01:28:09 +0100
Message-ID: <20181221002841.28587-6-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

nf_flow_table_iterate() is local function, make it static.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 4 ----
 net/netfilter/nf_flow_table_core.c    | 8 ++++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 77e2761d4f2f..7d5cda7ce32a 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -95,10 +95,6 @@ void flow_offload_free(struct flow_offload *flow);
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
-int nf_flow_table_iterate(struct nf_flowtable *flow_table,
-			  void (*iter)(struct flow_offload *flow, void *data),
-			  void *data);
-
 void nf_flow_table_cleanup(struct net_device *dev);
 
 int nf_flow_table_init(struct nf_flowtable *flow_table);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b7a4816add76..58bb006cf1b8 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -247,9 +247,10 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 }
 EXPORT_SYMBOL_GPL(flow_offload_lookup);
 
-int nf_flow_table_iterate(struct nf_flowtable *flow_table,
-			  void (*iter)(struct flow_offload *flow, void *data),
-			  void *data)
+static int
+nf_flow_table_iterate(struct nf_flowtable *flow_table,
+		      void (*iter)(struct flow_offload *flow, void *data),
+		      void *data)
 {
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct rhashtable_iter hti;
@@ -279,7 +280,6 @@ int nf_flow_table_iterate(struct nf_flowtable *flow_table,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(nf_flow_table_iterate);
 
 static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 {
-- 
2.11.0
