From: Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 2/2] netfilter: nf_tables: fix flowtable resource leak
Date: Mon,  5 Feb 2018 19:02:34 +0100
Message-ID: <20180205180234.26487-2-nbd@nbd.name>
References: <20180205180234.26487-1-nbd@nbd.name>
Cc: netdev@vger.kernel.org, davem@davemloft.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50488 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753101AbeBESCj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Feb 2018 13:02:39 -0500
In-Reply-To: <20180205180234.26487-1-nbd@nbd.name>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When cleaning up flowtable entries, associated dst and ct entries need
to be released as well

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/netfilter/nf_flow_table.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_flow_table.c b/net/netfilter/nf_flow_table.c
index 20f86091ab98..9925bd3f93c4 100644
--- a/net/netfilter/nf_flow_table.c
+++ b/net/netfilter/nf_flow_table.c
@@ -124,7 +124,7 @@ void flow_offload_free(struct flow_offload *flow)
 	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_cache);
 	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_cache);
 	e = container_of(flow, struct flow_offload_entry, flow);
-	kfree(e);
+	kfree_rcu(e, rcu_head);
 }
 EXPORT_SYMBOL_GPL(flow_offload_free);
 
@@ -161,7 +161,9 @@ void flow_offload_del(struct nf_flowtable *flow_table,
 			       *flow_table->type->params);
 
 	e = container_of(flow, struct flow_offload_entry, flow);
-	kfree_rcu(e, rcu_head);
+	nf_ct_delete(e->ct, 0, 0);
+	nf_ct_put(e->ct);
+	flow_offload_free(flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_del);
 
@@ -174,15 +176,6 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 }
 EXPORT_SYMBOL_GPL(flow_offload_lookup);
 
-static void nf_flow_release_ct(const struct flow_offload *flow)
-{
-	struct flow_offload_entry *e;
-
-	e = container_of(flow, struct flow_offload_entry, flow);
-	nf_ct_delete(e->ct, 0, 0);
-	nf_ct_put(e->ct);
-}
-
 int nf_flow_table_iterate(struct nf_flowtable *flow_table,
 			  void (*iter)(struct flow_offload *flow, void *data),
 			  void *data)
@@ -276,10 +269,8 @@ void nf_flow_offload_work_gc(struct work_struct *work)
 		flow = container_of(tuplehash, struct flow_offload, tuplehash[0]);
 
 		if (nf_flow_has_expired(flow) ||
-		    nf_flow_is_dying(flow)) {
+		    nf_flow_is_dying(flow))
 			flow_offload_del(flow_table, flow);
-			nf_flow_release_ct(flow);
-		}
 	}
 out:
 	rhashtable_walk_stop(&hti);
-- 
2.14.2

