Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8773F2DA759
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 15:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780585816; cv=none; b=Qt6vPAzl9BQUAvcaos4G6JI2DRX3vI1XbZXdCVZH72pNfzauMWSqZkUDw3BtoBkhvGtA9ULITNOl4pGjs56j57mDAJMC5y5HWynwdgTvxpBfmV8zQK96OXwwmLOPqjHGc4QDT4sAfyiEp2AvkHO7SNSnOgqXrKsXxSv1XKFEPnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780585816; c=relaxed/simple;
	bh=NqhD/pUlkkNajh52ydzktlSB+7Jj38FvcP40kbjreGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/tH0HoArU3RvD5wiQ+gRGNndllLq72B1or3uFZzBFfP6CcDuQxkm4uFYZwdLnzS+99ZBk/lDTLDBc4AYnldGyU3nMQ0vvIIkMe1e3sZj7cmYlDn3ggPwx6NFmC8ks9IzICmtOI48IgnbPMIwN+si/YfSymSSEXbKLzRQYTU5Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3C98C60337; Thu, 04 Jun 2026 17:10:13 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 2/5] netfilter: nf_conncount: prepare for per-tree seqcount
Date: Thu,  4 Jun 2026 17:03:35 +0200
Message-ID: <20260604150338.163592-3-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260604150338.163592-1-fw@strlen.de>
References: <20260604150338.163592-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This change is supposed to not have any actual changes, it
merely replaces rb_root by a new container structure.

Followup patch will add and use a sequence counter.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: no changes.
 net/netfilter/nf_conncount.c | 43 ++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 81e4a4e20df5..9617f0b4bdfa 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -56,10 +56,14 @@ struct nf_conncount_rb {
 
 static spinlock_t nf_conncount_locks[CONNCOUNT_SLOTS] __cacheline_aligned_in_smp;
 
+struct nf_conncount_root {
+	struct rb_root root;
+};
+
 struct nf_conncount_data {
 	unsigned int keylen;
 	u32 initval;
-	struct rb_root root[CONNCOUNT_SLOTS];
+	struct nf_conncount_root root[CONNCOUNT_SLOTS];
 	struct net *net;
 	struct work_struct gc_work;
 	unsigned long pending_trees[BITS_TO_LONGS(CONNCOUNT_SLOTS)];
@@ -368,7 +372,7 @@ static void __tree_nodes_free(struct rcu_head *h)
 }
 
 /* caller must hold tree nf_conncount_locks[] lock */
-static void tree_nodes_free(struct rb_root *root,
+static void tree_nodes_free(struct nf_conncount_root *root,
 			    struct nf_conncount_rb *gc_nodes[],
 			    unsigned int gc_count)
 {
@@ -378,7 +382,7 @@ static void tree_nodes_free(struct rb_root *root,
 		rbconn = gc_nodes[--gc_count];
 		spin_lock(&rbconn->list.list_lock);
 		if (!rbconn->list.count) {
-			rb_erase(&rbconn->node, root);
+			rb_erase(&rbconn->node, &root->root);
 			call_rcu(&rbconn->rcu_head, __tree_nodes_free);
 		}
 		spin_unlock(&rbconn->list.list_lock);
@@ -396,10 +400,10 @@ insert_tree(struct net *net,
 	    const struct sk_buff *skb,
 	    u16 l3num,
 	    struct nf_conncount_data *data,
-	    struct rb_root *root,
 	    unsigned int hash,
 	    const u32 *key)
 {
+	struct nf_conncount_root *root = &data->root[hash];
 	struct nf_conncount_rb *gc_nodes[CONNCOUNT_GC_MAX_NODES];
 	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
 	bool do_gc = true, refcounted = false;
@@ -413,7 +417,7 @@ insert_tree(struct net *net,
 	spin_lock_bh(&nf_conncount_locks[hash]);
 restart:
 	parent = NULL;
-	rbnode = &(root->rb_node);
+	rbnode = &root->root.rb_node;
 	while (*rbnode) {
 		int diff;
 		rbconn = rb_entry(*rbnode, struct nf_conncount_rb, node);
@@ -475,7 +479,7 @@ insert_tree(struct net *net,
 		rbconn->list.count = count;
 
 		rb_link_node_rcu(&rbconn->node, parent, rbnode);
-		rb_insert_color(&rbconn->node, root);
+		rb_insert_color(&rbconn->node, &root->root);
 	}
 out_unlock:
 	if (refcounted)
@@ -491,7 +495,7 @@ count_tree(struct net *net,
 	   struct nf_conncount_data *data,
 	   const u32 *key)
 {
-	struct rb_root *root;
+	struct nf_conncount_root *root;
 	struct rb_node *parent;
 	struct nf_conncount_rb *rbconn;
 	unsigned int hash;
@@ -499,7 +503,7 @@ count_tree(struct net *net,
 	hash = jhash2(key, data->keylen, data->initval) % CONNCOUNT_SLOTS;
 	root = &data->root[hash];
 
-	parent = rcu_dereference(root->rb_node);
+	parent = rcu_dereference(root->root.rb_node);
 	while (parent) {
 		int diff;
 
@@ -544,14 +548,14 @@ count_tree(struct net *net,
 	if (!skb)
 		return 0;
 
-	return insert_tree(net, skb, l3num, data, root, hash, key);
+	return insert_tree(net, skb, l3num, data, hash, key);
 }
 
 static void tree_gc_worker(struct work_struct *work)
 {
 	struct nf_conncount_data *data = container_of(work, struct nf_conncount_data, gc_work);
 	struct nf_conncount_rb *gc_nodes[CONNCOUNT_GC_MAX_NODES], *rbconn;
-	struct rb_root *root;
+	struct nf_conncount_root *root;
 	struct rb_node *node;
 	unsigned int tree, next_tree, gc_count = 0;
 
@@ -560,7 +564,7 @@ static void tree_gc_worker(struct work_struct *work)
 
 	local_bh_disable();
 	rcu_read_lock();
-	for (node = rb_first(root); node != NULL; node = rb_next(node)) {
+	for (node = rb_first(&root->root); node ; node = rb_next(node)) {
 		rbconn = rb_entry(node, struct nf_conncount_rb, node);
 		if (nf_conncount_gc_list(data->net, &rbconn->list))
 			gc_count++;
@@ -575,7 +579,7 @@ static void tree_gc_worker(struct work_struct *work)
 		goto next; /* do not bother */
 
 	gc_count = 0;
-	node = rb_first(root);
+	node = rb_first(&root->root);
 	while (node != NULL) {
 		rbconn = rb_entry(node, struct nf_conncount_rb, node);
 		node = rb_next(node);
@@ -620,6 +624,11 @@ unsigned int nf_conncount_count_skb(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_conncount_count_skb);
 
+static void nf_conncount_root_init(struct nf_conncount_root *r)
+{
+	r->root = RB_ROOT;
+}
+
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen)
 {
 	struct nf_conncount_data *data;
@@ -635,13 +644,15 @@ struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen
 		return ERR_PTR(-ENOMEM);
 
 	for (i = 0; i < ARRAY_SIZE(data->root); ++i)
-		data->root[i] = RB_ROOT;
+		nf_conncount_root_init(&data->root[i]);
 
 	data->keylen = keylen / sizeof(u32);
 	data->net = net;
 	data->initval = get_random_u32();
 	INIT_WORK(&data->gc_work, tree_gc_worker);
 
+	BUILD_BUG_ON(ARRAY_SIZE(data->root) != ARRAY_SIZE(nf_conncount_locks));
+
 	return data;
 }
 EXPORT_SYMBOL_GPL(nf_conncount_init);
@@ -655,15 +666,15 @@ void nf_conncount_cache_free(struct nf_conncount_list *list)
 }
 EXPORT_SYMBOL_GPL(nf_conncount_cache_free);
 
-static void destroy_tree(struct rb_root *r)
+static void destroy_tree(struct nf_conncount_root *r)
 {
 	struct nf_conncount_rb *rbconn;
 	struct rb_node *node;
 
-	while ((node = rb_first(r)) != NULL) {
+	while ((node = rb_first(&r->root)) != NULL) {
 		rbconn = rb_entry(node, struct nf_conncount_rb, node);
 
-		rb_erase(node, r);
+		rb_erase(node, &r->root);
 
 		nf_conncount_cache_free(&rbconn->list);
 
-- 
2.54.0

