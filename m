From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 19/38] netfilter: nf_conncount: Early exit in nf_conncount_lookup() and cleanup
Date: Fri, 20 Jul 2018 15:08:47 +0200
Message-ID: <20180720130906.27687-20-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Yi-Hung Wei <yihung.wei@gmail.com>

This patch is originally from Florian Westphal.

This patch does the following three tasks.

It applies the same early exit technique for nf_conncount_lookup().

Since now we keep the number of connections in 'struct nf_conncount_list',
we no longer need to return the count in nf_conncount_lookup().

Moreover, we expose the garbage collection function nf_conncount_gc_list()
for nft_connlimit.

Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_count.h | 11 +++++----
 net/netfilter/nf_conncount.c               | 38 +++++++++++++++++-------------
 net/netfilter/nft_connlimit.c              |  9 +++----
 3 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index e4884e0e4f69..dbec17f674b7 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -21,10 +21,10 @@ unsigned int nf_conncount_count(struct net *net,
 				const struct nf_conntrack_tuple *tuple,
 				const struct nf_conntrack_zone *zone);
 
-unsigned int nf_conncount_lookup(struct net *net, struct nf_conncount_list *list,
-				 const struct nf_conntrack_tuple *tuple,
-				 const struct nf_conntrack_zone *zone,
-				 bool *addit);
+void nf_conncount_lookup(struct net *net, struct nf_conncount_list *list,
+			 const struct nf_conntrack_tuple *tuple,
+			 const struct nf_conntrack_zone *zone,
+			 bool *addit);
 
 void nf_conncount_list_init(struct nf_conncount_list *list);
 
@@ -32,6 +32,9 @@ bool nf_conncount_add(struct nf_conncount_list *list,
 		      const struct nf_conntrack_tuple *tuple,
 		      const struct nf_conntrack_zone *zone);
 
+void nf_conncount_gc_list(struct net *net,
+			  struct nf_conncount_list *list);
+
 void nf_conncount_cache_free(struct nf_conncount_list *list);
 
 #endif
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 81b060adefef..7dfd9d5e6a3e 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -144,26 +144,29 @@ find_or_evict(struct net *net, struct nf_conncount_list *list,
 	return ERR_PTR(-EAGAIN);
 }
 
-unsigned int nf_conncount_lookup(struct net *net,
-				 struct nf_conncount_list *list,
-				 const struct nf_conntrack_tuple *tuple,
-				 const struct nf_conntrack_zone *zone,
-				 bool *addit)
+void nf_conncount_lookup(struct net *net,
+			 struct nf_conncount_list *list,
+			 const struct nf_conntrack_tuple *tuple,
+			 const struct nf_conntrack_zone *zone,
+			 bool *addit)
 {
 	const struct nf_conntrack_tuple_hash *found;
 	struct nf_conncount_tuple *conn, *conn_n;
 	struct nf_conn *found_ct;
-	unsigned int length = 0;
+	unsigned int collect = 0;
 
+	/* best effort only */
 	*addit = tuple ? true : false;
 
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
+		if (collect > CONNCOUNT_GC_MAX_NODES)
+			break;
+
 		found = find_or_evict(net, list, conn);
 		if (IS_ERR(found)) {
 			/* Not found, but might be about to be confirmed */
 			if (PTR_ERR(found) == -EAGAIN) {
-				length++;
 				if (!tuple)
 					continue;
 
@@ -171,8 +174,8 @@ unsigned int nf_conncount_lookup(struct net *net,
 				    nf_ct_zone_id(&conn->zone, conn->zone.dir) ==
 				    nf_ct_zone_id(zone, zone->dir))
 					*addit = false;
-			}
-
+			} else if (PTR_ERR(found) == -ENOENT)
+				collect++;
 			continue;
 		}
 
@@ -181,9 +184,10 @@ unsigned int nf_conncount_lookup(struct net *net,
 		if (tuple && nf_ct_tuple_equal(&conn->tuple, tuple) &&
 		    nf_ct_zone_equal(found_ct, zone, zone->dir)) {
 			/*
-			 * Just to be sure we have it only once in the list.
 			 * We should not see tuples twice unless someone hooks
 			 * this into a table without "-p tcp --syn".
+			 *
+			 * Attempt to avoid a re-add in this case.
 			 */
 			*addit = false;
 		} else if (already_closed(found_ct)) {
@@ -193,14 +197,12 @@ unsigned int nf_conncount_lookup(struct net *net,
 			 */
 			nf_ct_put(found_ct);
 			conn_free(list, conn);
+			collect++;
 			continue;
 		}
 
 		nf_ct_put(found_ct);
-		length++;
 	}
-
-	return length;
 }
 EXPORT_SYMBOL_GPL(nf_conncount_lookup);
 
@@ -211,8 +213,8 @@ void nf_conncount_list_init(struct nf_conncount_list *list)
 }
 EXPORT_SYMBOL_GPL(nf_conncount_list_init);
 
-static void nf_conncount_gc_list(struct net *net,
-				 struct nf_conncount_list *list)
+void nf_conncount_gc_list(struct net *net,
+			  struct nf_conncount_list *list)
 {
 	const struct nf_conntrack_tuple_hash *found;
 	struct nf_conncount_tuple *conn, *conn_n;
@@ -244,6 +246,7 @@ static void nf_conncount_gc_list(struct net *net,
 			return;
 	}
 }
+EXPORT_SYMBOL_GPL(nf_conncount_gc_list);
 
 static void tree_nodes_free(struct rb_root *root,
 			    struct nf_conncount_rb *gc_nodes[],
@@ -291,8 +294,9 @@ count_tree(struct net *net, struct rb_root *root,
 			/* same source network -> be counted! */
 			unsigned int count;
 
-			count = nf_conncount_lookup(net, &rbconn->list, tuple,
-						    zone, &addit);
+			nf_conncount_lookup(net, &rbconn->list, tuple, zone,
+					    &addit);
+			count = rbconn->list.count;
 
 			tree_nodes_free(root, gc_nodes, gc_count);
 			if (!addit)
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 4f0491a36a1d..37c52ae06741 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -46,8 +46,9 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 	}
 
 	spin_lock_bh(&priv->lock);
-	count = nf_conncount_lookup(nft_net(pkt), &priv->list, tuple_ptr, zone,
-				    &addit);
+	nf_conncount_lookup(nft_net(pkt), &priv->list, tuple_ptr, zone,
+			    &addit);
+	count = priv->list.count;
 
 	if (!addit)
 		goto out;
@@ -231,10 +232,10 @@ static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
 static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
 {
 	struct nft_connlimit *priv = nft_expr_priv(expr);
-	bool addit, ret;
+	bool ret;
 
 	spin_lock_bh(&priv->lock);
-	nf_conncount_lookup(net, &priv->list, NULL, &nf_ct_zone_dflt, &addit);
+	nf_conncount_gc_list(net, &priv->list);
 
 	ret = list_empty(&priv->list.head);
 	spin_unlock_bh(&priv->lock);
-- 
2.11.0
