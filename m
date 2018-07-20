From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/38] netfilter: nf_conncount: Move locking into count_tree()
Date: Fri, 20 Jul 2018 15:08:48 +0200
Message-ID: <20180720130906.27687-21-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Yi-Hung Wei <yihung.wei@gmail.com>

This patch is originally from Florian Westphal.

This is a preparation patch to allow lockless traversal
of the tree via RCU.

Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 52 +++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 7dfd9d5e6a3e..d1a4fd1c0f81 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -262,18 +262,26 @@ static void tree_nodes_free(struct rb_root *root,
 }
 
 static unsigned int
-count_tree(struct net *net, struct rb_root *root,
-	   const u32 *key, u8 keylen,
+count_tree(struct net *net,
+	   struct nf_conncount_data *data,
+	   const u32 *key,
 	   const struct nf_conntrack_tuple *tuple,
 	   const struct nf_conntrack_zone *zone)
 {
 	struct nf_conncount_rb *gc_nodes[CONNCOUNT_GC_MAX_NODES];
+	struct rb_root *root;
 	struct rb_node **rbnode, *parent;
 	struct nf_conncount_rb *rbconn;
 	struct nf_conncount_tuple *conn;
-	unsigned int gc_count;
+	unsigned int gc_count, hash;
 	bool no_gc = false;
+	unsigned int count = 0;
+	u8 keylen = data->keylen;
 
+	hash = jhash2(key, data->keylen, conncount_rnd) % CONNCOUNT_SLOTS;
+	root = &data->root[hash];
+
+	spin_lock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
  restart:
 	gc_count = 0;
 	parent = NULL;
@@ -292,20 +300,20 @@ count_tree(struct net *net, struct rb_root *root,
 			rbnode = &((*rbnode)->rb_right);
 		} else {
 			/* same source network -> be counted! */
-			unsigned int count;
-
 			nf_conncount_lookup(net, &rbconn->list, tuple, zone,
 					    &addit);
 			count = rbconn->list.count;
 
 			tree_nodes_free(root, gc_nodes, gc_count);
 			if (!addit)
-				return count;
+				goto out_unlock;
 
 			if (!nf_conncount_add(&rbconn->list, tuple, zone))
-				return 0; /* hotdrop */
+				count = 0; /* hotdrop */
+				goto out_unlock;
 
-			return count + 1;
+			count++;
+			goto out_unlock;
 		}
 
 		if (no_gc || gc_count >= ARRAY_SIZE(gc_nodes))
@@ -328,18 +336,18 @@ count_tree(struct net *net, struct rb_root *root,
 		goto restart;
 	}
 
+	count = 0;
 	if (!tuple)
-		return 0;
-
+		goto out_unlock;
 	/* no match, need to insert new node */
 	rbconn = kmem_cache_alloc(conncount_rb_cachep, GFP_ATOMIC);
 	if (rbconn == NULL)
-		return 0;
+		goto out_unlock;
 
 	conn = kmem_cache_alloc(conncount_conn_cachep, GFP_ATOMIC);
 	if (conn == NULL) {
 		kmem_cache_free(conncount_rb_cachep, rbconn);
-		return 0;
+		goto out_unlock;
 	}
 
 	conn->tuple = *tuple;
@@ -348,10 +356,13 @@ count_tree(struct net *net, struct rb_root *root,
 
 	nf_conncount_list_init(&rbconn->list);
 	list_add(&conn->node, &rbconn->list.head);
+	count = 1;
 
 	rb_link_node(&rbconn->node, parent, rbnode);
 	rb_insert_color(&rbconn->node, root);
-	return 1;
+out_unlock:
+	spin_unlock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
+	return count;
 }
 
 /* Count and return number of conntrack entries in 'net' with particular 'key'.
@@ -363,20 +374,7 @@ unsigned int nf_conncount_count(struct net *net,
 				const struct nf_conntrack_tuple *tuple,
 				const struct nf_conntrack_zone *zone)
 {
-	struct rb_root *root;
-	int count;
-	u32 hash;
-
-	hash = jhash2(key, data->keylen, conncount_rnd) % CONNCOUNT_SLOTS;
-	root = &data->root[hash];
-
-	spin_lock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
-
-	count = count_tree(net, root, key, data->keylen, tuple, zone);
-
-	spin_unlock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
-
-	return count;
+	return count_tree(net, data, key, tuple, zone);
 }
 EXPORT_SYMBOL_GPL(nf_conncount_count);
 
-- 
2.11.0
