Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E59639F190;
	Sun, 14 Jun 2026 11:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781437582; cv=none; b=kHa52m8JU6yhmkKKQBXTAlO1z26TZkJzJJt2GrlAtwwXONMK2gKiWP7rslg2zsUvCr1WizyqoRp7NmtnzpH1EsU/9xPeneKbDIAEUfPqGRA7o8gVynMq4gkr51M1aLI6c1JeJUaZdM0IxQIszl0k9r4Vw68xqVoJqgsA99RahHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781437582; c=relaxed/simple;
	bh=JrQUdXCFG0uwqkXM44jf7JafgIqvfMdYGHXIN1uwCeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEzLo8i1OBM0HS0juWvT2x8gJVNugkTHJmF7thvZt4q53K+IKwvAYmCWVY3BQ7bt92/kYbYiz8OEyWCDrr7MtPR5yvZzQAjkTQ1T9wuvZJ9nhSSkSEOhr2MtQ8EkL8z9l3NKpclmVHBarSGOUrXF9ixYf9pYYaDdCEdfM5LUlOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hWurvSKl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hWurvSKl"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 18763601A3;
	Sun, 14 Jun 2026 13:46:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781437579;
	bh=hLb7v6Xd3iOXfSOHwWGwwDzv6a2iONsGF/EPOL533K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWurvSKl8YwGVNSMNMntXtYSlS4dcoXhNc5Eh0imEBgY3Yikq3dG9T2Iej+Mltqcj
	 OGME65d8sx+FY7cHgfcvVdA63h1i/cfZd7ZmOaKwFj8YJBQ6gtBPGzO5xrkPd9J5CQ
	 xtVTmwFdBIZ7clbOPIUScIXbCAJQjRhWEahyRksn1rx56iM4GnSU5IPAxEThWQh0iP
	 bUsZLh609g/zpNqMGMxU5s/y84lpyji22m1ABbqVBFr55ll0t2vvxW2SGgLOZ4VOvq
	 H9lIq8nduixFcL9PYNKblQnsnxsd3+idJBhCEj6NtpR/h0Gukb0UZ3IIpy5kby8cjd
	 XKISML+6Ahj8Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 07/11] netfilter: nf_conncount: gc and rcu fixes
Date: Sun, 14 Jun 2026 13:46:01 +0200
Message-ID: <20260614114605.474783-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260614114605.474783-1-pablo@netfilter.org>
References: <20260614114605.474783-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.47.3

