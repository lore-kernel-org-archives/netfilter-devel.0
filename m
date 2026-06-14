Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFACF3A0B13;
	Sun, 14 Jun 2026 11:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781437578; cv=none; b=kcvA+qJ/I91UK6qQminoU3RcC3WvrKHaiN2v02H4Mrr9Qv/ykqI9/meaEj6pwgiTqIUntyVv74Usy23Wkm2FfQnTPuK5hoQ6bLUXR7q8K0mP9t/vHH5v1KF0qCGcVTr9LpMwgmAgP+uxrhIRTGbPuDdoIwzbFcBCc1jcyXrCqmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781437578; c=relaxed/simple;
	bh=XCW8oUBZO4r8mr1t1u49gFa1Yn7Z3ofwyfo+K48fu5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZEjTzSYbvSo6KI0/LdDPaQBbNKfoVWL+Z7BJB/RefVGP5IGf9RMLb+YZPRuBhxp8klFQmMdCbBTPVqppChMGbulU2GKylhKLCboV6df2I480sfhH9DCk5f04Ls+blIj+HIZA2MAabTs6GMkcJ9pOu8fF/McDFf+larUccyHRJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=G5qQiS5J; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="G5qQiS5J"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 920AE6019D;
	Sun, 14 Jun 2026 13:46:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781437575;
	bh=kii4uWqqJhPW5/tR89OvtRd2UBP/6BKo+ykuBOxj1RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5qQiS5JVlOg6WCaFQpSVzRk4xA3yS6aivueqeWPTMnv1XTXxPFbiqzFiBMj8lQFI
	 En8BiVp25XAPz84UI+bTW+M/qafRdhDhSAP3dsSK+6+0sNInJQbEzKgZBzwHqpT+It
	 f4H6wFc82DrMFGPdcosuDKAnTKQpOHGo9QTTcELGWgzuxdGKSE6AnFRga0x0RGQhNh
	 hz+yg40qdJSOTuAqAKP/Czd19xcUfLUY62ICEvl6Y9OCjZ9hw7kVVOTj+lqs2gxYZP
	 /drmkoIV83Z0PTVdrTEJCd5TeVoehUlFzN1Vdm69pefD70iwNpdC5k+csQ3H6V6zlS
	 sjxnL0C852KeA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 04/11] netfilter: nf_conncount: use per nf_conncount_data spinlocks
Date: Sun, 14 Jun 2026 13:45:58 +0200
Message-ID: <20260614114605.474783-5-pablo@netfilter.org>
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

This change replaces the rb_root with a new container structure.
Instead of an array of locks shared by all nf_conncount_data objects,
each tree gains its own dedicated lock.

Downside: nf_conncount_data increases in size.  Before this change:
 struct nf_conncount_data {
        [..]
        /* --- cacheline 33 boundary (2112 bytes) was 16 bytes ago --- */
        unsigned int               gc_tree;              /*  2128     4 */
        /* size: 2136, cachelines: 34, members: 7 */
        /* padding: 4 */

After:
        /* size: 4184, cachelines: 66, members: 7 */
        /* padding: 4 */

On LOCKDEP enabled kernels, this is even worse:
	/* size: 18560, cachelines: 290, members: 7 */

(due to lockdep map in each spinlock).

For this reason also switch to kvzalloc.  The zeroing variant is needed
to not start with random (heap memory content) in the ->pending_trees
bitmap.

Followup patch will add and use a sequence counter.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 63 +++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 29 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 81e4a4e20df5..faecc05d34d4 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -54,12 +54,15 @@ struct nf_conncount_rb {
 	struct rcu_head rcu_head;
 };
 
-static spinlock_t nf_conncount_locks[CONNCOUNT_SLOTS] __cacheline_aligned_in_smp;
+struct nf_conncount_root {
+	struct rb_root root;
+	spinlock_t lock;
+};
 
 struct nf_conncount_data {
 	unsigned int keylen;
 	u32 initval;
-	struct rb_root root[CONNCOUNT_SLOTS];
+	struct nf_conncount_root root[CONNCOUNT_SLOTS];
 	struct net *net;
 	struct work_struct gc_work;
 	unsigned long pending_trees[BITS_TO_LONGS(CONNCOUNT_SLOTS)];
@@ -367,18 +370,19 @@ static void __tree_nodes_free(struct rcu_head *h)
 	kmem_cache_free(conncount_rb_cachep, rbconn);
 }
 
-/* caller must hold tree nf_conncount_locks[] lock */
-static void tree_nodes_free(struct rb_root *root,
+static void tree_nodes_free(struct nf_conncount_root *root,
 			    struct nf_conncount_rb *gc_nodes[],
 			    unsigned int gc_count)
 {
 	struct nf_conncount_rb *rbconn;
 
+	lockdep_assert_held(&root->lock);
+
 	while (gc_count) {
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
@@ -410,10 +414,10 @@ insert_tree(struct net *net,
 	struct nf_conncount_rb *rbconn;
 	struct nf_conn *ct = NULL;
 
-	spin_lock_bh(&nf_conncount_locks[hash]);
+	spin_lock_bh(&root->lock);
 restart:
 	parent = NULL;
-	rbnode = &(root->rb_node);
+	rbnode = &root->root.rb_node;
 	while (*rbnode) {
 		int diff;
 		rbconn = rb_entry(*rbnode, struct nf_conncount_rb, node);
@@ -475,12 +479,12 @@ insert_tree(struct net *net,
 		rbconn->list.count = count;
 
 		rb_link_node_rcu(&rbconn->node, parent, rbnode);
-		rb_insert_color(&rbconn->node, root);
+		rb_insert_color(&rbconn->node, &root->root);
 	}
 out_unlock:
 	if (refcounted)
 		nf_ct_put(ct);
-	spin_unlock_bh(&nf_conncount_locks[hash]);
+	spin_unlock_bh(&root->lock);
 	return count;
 }
 
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
@@ -570,12 +574,12 @@ static void tree_gc_worker(struct work_struct *work)
 
 	cond_resched();
 
-	spin_lock_bh(&nf_conncount_locks[tree]);
+	spin_lock_bh(&root->lock);
 	if (gc_count < ARRAY_SIZE(gc_nodes))
 		goto next; /* do not bother */
 
 	gc_count = 0;
-	node = rb_first(root);
+	node = rb_first(&root->root);
 	while (node != NULL) {
 		rbconn = rb_entry(node, struct nf_conncount_rb, node);
 		node = rb_next(node);
@@ -602,7 +606,7 @@ static void tree_gc_worker(struct work_struct *work)
 		schedule_work(work);
 	}
 
-	spin_unlock_bh(&nf_conncount_locks[tree]);
+	spin_unlock_bh(&root->lock);
 }
 
 /* Count and return number of conntrack entries in 'net' with particular 'key'.
@@ -620,6 +624,12 @@ unsigned int nf_conncount_count_skb(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_conncount_count_skb);
 
+static void nf_conncount_root_init(struct nf_conncount_root *r)
+{
+	r->root = RB_ROOT;
+	spin_lock_init(&r->lock);
+}
+
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen)
 {
 	struct nf_conncount_data *data;
@@ -630,12 +640,12 @@ struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen
 	    keylen == 0)
 		return ERR_PTR(-EINVAL);
 
-	data = kmalloc_obj(*data);
+	data = kvzalloc_obj(*data);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
 
 	for (i = 0; i < ARRAY_SIZE(data->root); ++i)
-		data->root[i] = RB_ROOT;
+		nf_conncount_root_init(&data->root[i]);
 
 	data->keylen = keylen / sizeof(u32);
 	data->net = net;
@@ -655,15 +665,15 @@ void nf_conncount_cache_free(struct nf_conncount_list *list)
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
 
@@ -680,17 +690,12 @@ void nf_conncount_destroy(struct net *net, struct nf_conncount_data *data)
 	for (i = 0; i < ARRAY_SIZE(data->root); ++i)
 		destroy_tree(&data->root[i]);
 
-	kfree(data);
+	kvfree(data);
 }
 EXPORT_SYMBOL_GPL(nf_conncount_destroy);
 
 static int __init nf_conncount_modinit(void)
 {
-	int i;
-
-	for (i = 0; i < CONNCOUNT_SLOTS; ++i)
-		spin_lock_init(&nf_conncount_locks[i]);
-
 	conncount_conn_cachep = KMEM_CACHE(nf_conncount_tuple, 0);
 	if (!conncount_conn_cachep)
 		return -ENOMEM;
-- 
2.47.3

