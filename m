From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/38] netfilter: nf_conncount: Early exit for garbage collection
Date: Fri, 20 Jul 2018 15:08:45 +0200
Message-ID: <20180720130906.27687-18-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Yi-Hung Wei <yihung.wei@gmail.com>

This patch is originally from Florian Westphal.

We use an extra function with early exit for garbage collection.
It is not necessary to traverse the full list for every node since
it is enough to zap a couple of entries for garbage collection.

Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 510039862aa9..81c02185b2e8 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -189,6 +189,42 @@ unsigned int nf_conncount_lookup(struct net *net, struct hlist_head *head,
 }
 EXPORT_SYMBOL_GPL(nf_conncount_lookup);
 
+static void nf_conncount_gc_list(struct net *net,
+				 struct nf_conncount_rb *rbconn)
+{
+	const struct nf_conntrack_tuple_hash *found;
+	struct nf_conncount_tuple *conn;
+	struct hlist_node *n;
+	struct nf_conn *found_ct;
+	unsigned int collected = 0;
+
+	hlist_for_each_entry_safe(conn, n, &rbconn->hhead, node) {
+		found = find_or_evict(net, conn);
+		if (IS_ERR(found)) {
+			if (PTR_ERR(found) == -ENOENT)
+				collected++;
+			continue;
+		}
+
+		found_ct = nf_ct_tuplehash_to_ctrack(found);
+		if (already_closed(found_ct)) {
+			/*
+			 * we do not care about connections which are
+			 * closed already -> ditch it
+			 */
+			nf_ct_put(found_ct);
+			hlist_del(&conn->node);
+			kmem_cache_free(conncount_conn_cachep, conn);
+			collected++;
+			continue;
+		}
+
+		nf_ct_put(found_ct);
+		if (collected > CONNCOUNT_GC_MAX_NODES)
+			return;
+	}
+}
+
 static void tree_nodes_free(struct rb_root *root,
 			    struct nf_conncount_rb *gc_nodes[],
 			    unsigned int gc_count)
@@ -251,8 +287,7 @@ count_tree(struct net *net, struct rb_root *root,
 		if (no_gc || gc_count >= ARRAY_SIZE(gc_nodes))
 			continue;
 
-		/* only used for GC on hhead, retval and 'addit' ignored */
-		nf_conncount_lookup(net, &rbconn->hhead, tuple, zone, &addit);
+		nf_conncount_gc_list(net, rbconn);
 		if (hlist_empty(&rbconn->hhead))
 			gc_nodes[gc_count++] = rbconn;
 	}
-- 
2.11.0
