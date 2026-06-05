Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED8130D403
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jun 2026 13:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780665114; cv=none; b=VdgYcXiGKztz/ei7IRX62bpcMDUA5GpaiIu51vIEzwwWu+tHQUF6Tf+DygM3D3Kqfmbd8kVQff28GRKWlyDbk6t+4KyVaZqAkJl9SyOeNdr75aGg7FVdcAeHXWWjQe53Z6d+LT5hKx2h+GaJ6Quu47/DH5Q+ZHimnDNXDrgNdGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780665114; c=relaxed/simple;
	bh=fMmivzsBAoit/1HGkhkbS4T9mU97bjFFScL9p90CRfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwmgWNxSIFB2Mlizb8uiyajuJQtGE9LAgpyShVkCt9O11jK4d/W+yN+0WwT96s4Frsed5h3q5uI5HKhJwpgRmelXN6esGYst81Hc8Qp7zmEISZaP/TiD4H71MJ/jcZLwS1/CR5Cd0BPGZeuUS3ytj6v9J+tz2VaNViZIcuRpVHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1B61E60425; Fri, 05 Jun 2026 15:11:52 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 5/5] netfilter: nf_conncount: gc and rcu fixes
Date: Fri,  5 Jun 2026 15:11:23 +0200
Message-ID: <20260605131123.19435-6-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605131123.19435-1-fw@strlen.de>
References: <20260605131123.19435-1-fw@strlen.de>
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

2) tree_gc_worker() iterates the rbtree without lock. This is never
   safe.  Move iteration under the spinlock.  If this takes too long
   (resched needed), save key of next node, drop lock, resched, re-lock,
   then search for the key (node).  In very rare cases this node might
   no longer exist, in that case we can just wait for next gc.

3) use disable_work_sync(), we don't want any restarts.

4) module exit function needs rcu_barrier before we zap the kmem cache.

Fixes: 5c789e131cbb ("netfilter: nf_conncount: Add list lock and gc worker, and RCU for init tree search")
Closes: https://sashiko.dev/#/patchset/20260525182924.28456-1-fw%40strlen.de
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v4: minor adjustments due to earlier lock array removal.

 net/netfilter/nf_conncount.c | 54 +++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 1247cbe77740..dd67004a5cc0 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -595,47 +595,54 @@ static void tree_gc_worker(struct work_struct *work)
 {
 	struct nf_conncount_data *data = container_of(work, struct nf_conncount_data, gc_work);
 	struct nf_conncount_rb *gc_nodes[CONNCOUNT_GC_MAX_NODES], *rbconn;
+	unsigned int tree, next_tree, gc_count = 0;
 	struct nf_conncount_root *root;
 	struct rb_node *node;
-	unsigned int tree, next_tree, gc_count = 0;
+
+	if (data->gc_tree == 0)
+		data->gc_tree = find_first_bit(data->pending_trees, CONNCOUNT_SLOTS);
 
 	tree = data->gc_tree % CONNCOUNT_SLOTS;
 	root = &data->root[tree];
 
-	local_bh_disable();
-	rcu_read_lock();
-	for (node = rb_first(&root->root); node ; node = rb_next(node)) {
-		rbconn = rb_entry(node, struct nf_conncount_rb, node);
-		if (nf_conncount_gc_list(data->net, &rbconn->list))
-			gc_count++;
-	}
-	rcu_read_unlock();
-	local_bh_enable();
-
-	cond_resched();
-
 	spin_lock_bh(&root->lock);
-	if (gc_count < ARRAY_SIZE(gc_nodes))
-		goto next; /* do not bother */
-
 	gc_count = 0;
 	node = rb_first(&root->root);
 	while (node != NULL) {
+		u32 key[MAX_KEYLEN];
+		bool drop_lock;
+
 		rbconn = rb_entry(node, struct nf_conncount_rb, node);
 		node = rb_next(node);
 
-		if (rbconn->list.count > 0)
-			continue;
+		if (nf_conncount_gc_list(data->net, &rbconn->list))
+			gc_nodes[gc_count++] = rbconn;
+
+		drop_lock = need_resched();
 
-		gc_nodes[gc_count++] = rbconn;
-		if (gc_count >= ARRAY_SIZE(gc_nodes)) {
+		if (drop_lock || gc_count >= ARRAY_SIZE(gc_nodes)) {
 			tree_nodes_free(root, gc_nodes, gc_count);
 			gc_count = 0;
 		}
+
+		if (!drop_lock || !node)
+			continue;
+
+		rbconn = rb_entry(node, struct nf_conncount_rb, node);
+		memcpy(key, rbconn->key, sizeof(key));
+		spin_unlock_bh(&root->lock);
+
+		cond_resched();
+
+		spin_lock_bh(&root->lock);
+		rbconn = find_tree_node(root, data, key);
+		if (IS_ERR_OR_NULL(rbconn)) /* rbconn was reaped */
+			break;
+
+		node = &rbconn->node;
 	}
 
 	tree_nodes_free(root, gc_nodes, gc_count);
-next:
 	clear_bit(tree, data->pending_trees);
 
 	next_tree = (tree + 1) % CONNCOUNT_SLOTS;
@@ -644,6 +651,8 @@ static void tree_gc_worker(struct work_struct *work)
 	if (next_tree < CONNCOUNT_SLOTS) {
 		data->gc_tree = next_tree;
 		schedule_work(work);
+	} else {
+		data->gc_tree = 0;
 	}
 
 	spin_unlock_bh(&root->lock);
@@ -726,7 +735,7 @@ void nf_conncount_destroy(struct net *net, struct nf_conncount_data *data)
 {
 	unsigned int i;
 
-	cancel_work_sync(&data->gc_work);
+	disable_work_sync(&data->gc_work);
 
 	for (i = 0; i < ARRAY_SIZE(data->root); ++i)
 		destroy_tree(&data->root[i]);
@@ -752,6 +761,7 @@ static int __init nf_conncount_modinit(void)
 
 static void __exit nf_conncount_modexit(void)
 {
+	rcu_barrier();
 	kmem_cache_destroy(conncount_conn_cachep);
 	kmem_cache_destroy(conncount_rb_cachep);
 }
-- 
2.53.0

