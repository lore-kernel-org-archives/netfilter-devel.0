From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 21/38] netfilter: nf_conncount: Split insert and traversal
Date: Fri, 20 Jul 2018 15:08:49 +0200
Message-ID: <20180720130906.27687-22-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Yi-Hung Wei <yihung.wei@gmail.com>

This patch is originally from Florian Westphal.

When we have a very coarse grouping, e.g. by large subnets, zone id,
etc, it's likely that we do not need to do tree rotation because
we'll find a node where we can attach new entry.  Based on this
observation, we split tree traversal and insertion.

Later on, we can make traversal lockless (tree protected
by RCU), and add extra lock in the individual nodes to protect list
insertion/deletion, thereby allowing parallel insert/delete in different
tree nodes.

Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 87 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 67 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index d1a4fd1c0f81..3f14806b7271 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -262,6 +262,71 @@ static void tree_nodes_free(struct rb_root *root,
 }
 
 static unsigned int
+insert_tree(struct rb_root *root,
+	    unsigned int hash,
+	    const u32 *key,
+	    u8 keylen,
+	    const struct nf_conntrack_tuple *tuple,
+	    const struct nf_conntrack_zone *zone)
+{
+	struct rb_node **rbnode, *parent;
+	struct nf_conncount_rb *rbconn;
+	struct nf_conncount_tuple *conn;
+	unsigned int count = 0;
+
+	spin_lock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
+
+	parent = NULL;
+	rbnode = &(root->rb_node);
+	while (*rbnode) {
+		int diff;
+		rbconn = rb_entry(*rbnode, struct nf_conncount_rb, node);
+
+		parent = *rbnode;
+		diff = key_diff(key, rbconn->key, keylen);
+		if (diff < 0) {
+			rbnode = &((*rbnode)->rb_left);
+		} else if (diff > 0) {
+			rbnode = &((*rbnode)->rb_right);
+		} else {
+			/* unlikely: other cpu added node already */
+			if (!nf_conncount_add(&rbconn->list, tuple, zone)) {
+				count = 0; /* hotdrop */
+				goto out_unlock;
+			}
+
+			count = rbconn->list.count;
+			goto out_unlock;
+		}
+	}
+
+	/* expected case: match, insert new node */
+	rbconn = kmem_cache_alloc(conncount_rb_cachep, GFP_ATOMIC);
+	if (rbconn == NULL)
+		goto out_unlock;
+
+	conn = kmem_cache_alloc(conncount_conn_cachep, GFP_ATOMIC);
+	if (conn == NULL) {
+		kmem_cache_free(conncount_rb_cachep, rbconn);
+		goto out_unlock;
+	}
+
+	conn->tuple = *tuple;
+	conn->zone = *zone;
+	memcpy(rbconn->key, key, sizeof(u32) * keylen);
+
+	nf_conncount_list_init(&rbconn->list);
+	list_add(&conn->node, &rbconn->list.head);
+	count = 1;
+
+	rb_link_node(&rbconn->node, parent, rbnode);
+	rb_insert_color(&rbconn->node, root);
+out_unlock:
+	spin_unlock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
+	return count;
+}
+
+static unsigned int
 count_tree(struct net *net,
 	   struct nf_conncount_data *data,
 	   const u32 *key,
@@ -272,7 +337,6 @@ count_tree(struct net *net,
 	struct rb_root *root;
 	struct rb_node **rbnode, *parent;
 	struct nf_conncount_rb *rbconn;
-	struct nf_conncount_tuple *conn;
 	unsigned int gc_count, hash;
 	bool no_gc = false;
 	unsigned int count = 0;
@@ -339,27 +403,10 @@ count_tree(struct net *net,
 	count = 0;
 	if (!tuple)
 		goto out_unlock;
-	/* no match, need to insert new node */
-	rbconn = kmem_cache_alloc(conncount_rb_cachep, GFP_ATOMIC);
-	if (rbconn == NULL)
-		goto out_unlock;
-
-	conn = kmem_cache_alloc(conncount_conn_cachep, GFP_ATOMIC);
-	if (conn == NULL) {
-		kmem_cache_free(conncount_rb_cachep, rbconn);
-		goto out_unlock;
-	}
-
-	conn->tuple = *tuple;
-	conn->zone = *zone;
-	memcpy(rbconn->key, key, sizeof(u32) * keylen);
 
-	nf_conncount_list_init(&rbconn->list);
-	list_add(&conn->node, &rbconn->list.head);
-	count = 1;
+	spin_unlock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
+	return insert_tree(root, hash, key, keylen, tuple, zone);
 
-	rb_link_node(&rbconn->node, parent, rbnode);
-	rb_insert_color(&rbconn->node, root);
 out_unlock:
 	spin_unlock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
 	return count;
-- 
2.11.0
