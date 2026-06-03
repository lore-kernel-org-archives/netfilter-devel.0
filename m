Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4213C76B8
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 11:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780485939; cv=none; b=Z5aoKrHaD967/OM6+aWHiPimGjvh6jLgdF7YeAPxUQCfc6XKNOc19YXw7Ic2NmaVqKjTm3ntLeUjK6UpAawSwD9SI01YCxQqWgivUkuAOzBVkvz7QBn0REmF8/DdU+nwQDuIPjuucrzlaTAXLpiFbey9CVzkGR8z4bRzSszxibA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780485939; c=relaxed/simple;
	bh=y3vuW9CepsYMrWd4I3ULVPjgvrAerQ24Moh5TEua5SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNgHTBExhC1DTNezVkOpDG3VQXHIliTxK3yzfTVa0wlEVc+ZCw+/BRVQLl5K1UptVfknvy/NwhO4SUs6WNS9SyORaIJvyr8n1yAsNBkIC4YQ8HukwzH6o+mKR7mEze8KqEXg8NM7ddce4LQnQ8+pk8O62QlsfYphUdZlBVOdmsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 520D4602F8; Wed, 03 Jun 2026 13:25:36 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] netfilter: nf_conncount: gc and rcu fixes
Date: Wed,  3 Jun 2026 13:25:00 +0200
Message-ID: <20260603112513.2263-4-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603112513.2263-1-fw@strlen.de>
References: <20260603112513.2263-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Another drive-by AI review:

1) tree_gc_worker fails to wrap around after it can't find more pending
   work.  Update data->gc_tree unconditionally.  If its 0, start from
   the first pending tree (which can be 0).

2) tree_gc_worker() iterates the rbtree without lock.
   Add a sequence count to detect concurrent modifications and
   avoid possible infinite loop / cycle.

3) module exit function needs rcu_barrier before we zap the kmem cache.

Fixes: 5c789e131cbb ("netfilter: nf_conncount: Add list lock and gc worker, and RCU for init tree search")
Closes: https://sashiko.dev/#/patchset/20260525182924.28456-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conncount.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 8d9c24b69dc9..f848d03f63fa 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -58,6 +58,7 @@ static spinlock_t nf_conncount_locks[CONNCOUNT_SLOTS] __cacheline_aligned_in_smp
 
 struct nf_conncount_root {
 	struct rb_root root;
+	seqcount_t count;
 };
 
 struct nf_conncount_data {
@@ -478,8 +479,10 @@ insert_tree(struct net *net,
 		count = 1;
 		rbconn->list.count = count;
 
+		write_seqcount_begin(&root->count);
 		rb_link_node_rcu(&rbconn->node, parent, rbnode);
 		rb_insert_color(&rbconn->node, &root->root);
+		write_seqcount_end(&root->count);
 	}
 out_unlock:
 	if (refcounted)
@@ -492,6 +495,7 @@ static struct nf_conncount_rb *
 find_tree_node(struct nf_conncount_root *root, struct nf_conncount_data *data,
 	       const u32 *key)
 {
+	unsigned int seq = read_seqcount_begin(&root->count);
 	struct rb_node *parent;
 
 	parent = rcu_dereference_raw(root->root.rb_node);
@@ -509,6 +513,9 @@ find_tree_node(struct nf_conncount_root *root, struct nf_conncount_data *data,
 		} else {
 			return rbconn;
 		}
+
+		if (read_seqcount_retry(&root->count, seq))
+			return ERR_PTR(-EAGAIN);
 	}
 
 	return ERR_PTR(-ENOENT);
@@ -531,6 +538,12 @@ count_tree(struct net *net,
 
 	rbconn = find_tree_node(root, data, key);
 	if (IS_ERR(rbconn)) {
+		if (PTR_ERR(rbconn) == -EAGAIN) {
+			spin_lock_bh(&nf_conncount_locks[hash]);
+			rbconn = find_tree_node(root, data, key);
+			spin_unlock_bh(&nf_conncount_locks[hash]);
+		}
+
 		if (PTR_ERR(rbconn) == -ENOENT) {
 			if (!skb)
 				return 0;
@@ -575,19 +588,28 @@ static void tree_gc_worker(struct work_struct *work)
 {
 	struct nf_conncount_data *data = container_of(work, struct nf_conncount_data, gc_work);
 	struct nf_conncount_rb *gc_nodes[CONNCOUNT_GC_MAX_NODES], *rbconn;
+	unsigned int seq, tree, next_tree, gc_count = 0;
 	struct nf_conncount_root *root;
 	struct rb_node *node;
-	unsigned int tree, next_tree, gc_count = 0;
+	bool busy = false;
+
+	if (data->gc_tree == 0)
+		data->gc_tree = find_first_bit(data->pending_trees, CONNCOUNT_SLOTS);
 
 	tree = data->gc_tree % CONNCOUNT_SLOTS;
 	root = &data->root[tree];
 
 	local_bh_disable();
 	rcu_read_lock();
+	seq = read_seqcount_begin(&root->count);
 	for (node = rb_first(&root->root); node ; node = rb_next(node)) {
 		rbconn = rb_entry(node, struct nf_conncount_rb, node);
 		if (nf_conncount_gc_list(data->net, &rbconn->list))
 			gc_count++;
+		if (read_seqcount_retry(&root->count, seq)) {
+			busy = true;
+			break;
+		}
 	}
 	rcu_read_unlock();
 	local_bh_enable();
@@ -616,16 +638,22 @@ static void tree_gc_worker(struct work_struct *work)
 
 	tree_nodes_free(root, gc_nodes, gc_count);
 next:
-	clear_bit(tree, data->pending_trees);
+	if (!busy)
+		clear_bit(tree, data->pending_trees);
 
 	next_tree = (tree + 1) % CONNCOUNT_SLOTS;
 	next_tree = find_next_bit(data->pending_trees, CONNCOUNT_SLOTS, next_tree);
 
 	if (next_tree < CONNCOUNT_SLOTS) {
 		data->gc_tree = next_tree;
-		schedule_work(work);
+		busy = true;
+	} else {
+		data->gc_tree = 0;
 	}
 
+	if (busy)
+		schedule_work(work);
+
 	spin_unlock_bh(&nf_conncount_locks[tree]);
 }
 
@@ -647,6 +675,7 @@ EXPORT_SYMBOL_GPL(nf_conncount_count_skb);
 static void nf_conncount_root_init(struct nf_conncount_root *r)
 {
 	r->root = RB_ROOT;
+	seqcount_init(&r->count);
 }
 
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen)
@@ -737,6 +766,7 @@ static int __init nf_conncount_modinit(void)
 
 static void __exit nf_conncount_modexit(void)
 {
+	rcu_barrier();
 	kmem_cache_destroy(conncount_conn_cachep);
 	kmem_cache_destroy(conncount_rb_cachep);
 }
-- 
2.53.0

