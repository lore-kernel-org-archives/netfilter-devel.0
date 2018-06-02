From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/9] netfilter: nf_conncount: expose connection list interface
Date: Sun,  3 Jun 2018 01:14:08 +0200
Message-ID: <20180602231413.31974-5-pablo@netfilter.org>
References: <20180602231413.31974-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602231413.31974-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch provides an interface to maintain the list of connections and
the lookup function to obtain the number of connections in the list.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_count.h | 11 +++++++++
 net/netfilter/nf_conncount.c               | 36 +++++++++++++++++++-----------
 2 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index e61184fbfb71..1910b6572430 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -13,4 +13,15 @@ unsigned int nf_conncount_count(struct net *net,
 				const u32 *key,
 				const struct nf_conntrack_tuple *tuple,
 				const struct nf_conntrack_zone *zone);
+
+unsigned int nf_conncount_lookup(struct net *net, struct hlist_head *head,
+				 const struct nf_conntrack_tuple *tuple,
+				 const struct nf_conntrack_zone *zone,
+				 bool *addit);
+
+bool nf_conncount_add(struct hlist_head *head,
+		      const struct nf_conntrack_tuple *tuple);
+
+void nf_conncount_cache_free(struct hlist_head *hhead);
+
 #endif
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 153e690e2893..3b5059a8dcdd 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -79,7 +79,7 @@ static int key_diff(const u32 *a, const u32 *b, unsigned int klen)
 	return memcmp(a, b, klen * sizeof(u32));
 }
 
-static bool add_hlist(struct hlist_head *head,
+bool nf_conncount_add(struct hlist_head *head,
 		      const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conncount_tuple *conn;
@@ -91,12 +91,12 @@ static bool add_hlist(struct hlist_head *head,
 	hlist_add_head(&conn->node, head);
 	return true;
 }
+EXPORT_SYMBOL_GPL(nf_conncount_add);
 
-static unsigned int check_hlist(struct net *net,
-				struct hlist_head *head,
-				const struct nf_conntrack_tuple *tuple,
-				const struct nf_conntrack_zone *zone,
-				bool *addit)
+unsigned int nf_conncount_lookup(struct net *net, struct hlist_head *head,
+				 const struct nf_conntrack_tuple *tuple,
+				 const struct nf_conntrack_zone *zone,
+				 bool *addit)
 {
 	const struct nf_conntrack_tuple_hash *found;
 	struct nf_conncount_tuple *conn;
@@ -141,6 +141,7 @@ static unsigned int check_hlist(struct net *net,
 
 	return length;
 }
+EXPORT_SYMBOL_GPL(nf_conncount_lookup);
 
 static void tree_nodes_free(struct rb_root *root,
 			    struct nf_conncount_rb *gc_nodes[],
@@ -187,13 +188,15 @@ count_tree(struct net *net, struct rb_root *root,
 		} else {
 			/* same source network -> be counted! */
 			unsigned int count;
-			count = check_hlist(net, &rbconn->hhead, tuple, zone, &addit);
+
+			count = nf_conncount_lookup(net, &rbconn->hhead, tuple,
+						    zone, &addit);
 
 			tree_nodes_free(root, gc_nodes, gc_count);
 			if (!addit)
 				return count;
 
-			if (!add_hlist(&rbconn->hhead, tuple))
+			if (!nf_conncount_add(&rbconn->hhead, tuple))
 				return 0; /* hotdrop */
 
 			return count + 1;
@@ -203,7 +206,7 @@ count_tree(struct net *net, struct rb_root *root,
 			continue;
 
 		/* only used for GC on hhead, retval and 'addit' ignored */
-		check_hlist(net, &rbconn->hhead, tuple, zone, &addit);
+		nf_conncount_lookup(net, &rbconn->hhead, tuple, zone, &addit);
 		if (hlist_empty(&rbconn->hhead))
 			gc_nodes[gc_count++] = rbconn;
 	}
@@ -303,11 +306,19 @@ struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family
 }
 EXPORT_SYMBOL_GPL(nf_conncount_init);
 
-static void destroy_tree(struct rb_root *r)
+void nf_conncount_cache_free(struct hlist_head *hhead)
 {
 	struct nf_conncount_tuple *conn;
-	struct nf_conncount_rb *rbconn;
 	struct hlist_node *n;
+
+	hlist_for_each_entry_safe(conn, n, hhead, node)
+		kmem_cache_free(conncount_conn_cachep, conn);
+}
+EXPORT_SYMBOL_GPL(nf_conncount_cache_free);
+
+static void destroy_tree(struct rb_root *r)
+{
+	struct nf_conncount_rb *rbconn;
 	struct rb_node *node;
 
 	while ((node = rb_first(r)) != NULL) {
@@ -315,8 +326,7 @@ static void destroy_tree(struct rb_root *r)
 
 		rb_erase(node, r);
 
-		hlist_for_each_entry_safe(conn, n, &rbconn->hhead, node)
-			kmem_cache_free(conncount_conn_cachep, conn);
+		nf_conncount_cache_free(&rbconn->hhead);
 
 		kmem_cache_free(conncount_rb_cachep, rbconn);
 	}
-- 
2.11.0
