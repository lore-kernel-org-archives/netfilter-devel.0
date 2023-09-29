Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852BBE728CA
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 16:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbjI2QoO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 12:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbjI2QoN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 12:44:13 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3F02199
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 09:44:10 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf 2/2] netfilter: nft_set_rbtree: remove async GC
Date:   Fri, 29 Sep 2023 18:44:04 +0200
Message-Id: <20230929164404.172081-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230929164404.172081-1-pablo@netfilter.org>
References: <20230929164404.172081-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Let sync GC remove entries from the tree instead. The sync GC read
spinlock might still stall an update from the control plane with a
sufficiently large tree.

Fixes: 96b33300fba8 ("netfilter: nft_set_rbtree: use read spinlock to avoid datapath contention")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Hi Florian,

You asked for this.

 net/netfilter/nft_set_rbtree.c | 90 ----------------------------------
 1 file changed, 90 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index de6d812fc790..17500f4f6f1d 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -19,7 +19,6 @@ struct nft_rbtree {
 	struct rb_root		root;
 	rwlock_t		lock;
 	seqcount_rwlock_t	count;
-	struct delayed_work	gc_work;
 };
 
 struct nft_rbtree_elem {
@@ -626,89 +625,6 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 	read_unlock_bh(&priv->lock);
 }
 
-static void nft_rbtree_gc(struct work_struct *work)
-{
-	struct nft_rbtree_elem *rbe, *rbe_end = NULL;
-	struct nftables_pernet *nft_net;
-	struct nft_rbtree *priv;
-	struct nft_trans_gc *gc;
-	struct rb_node *node;
-	struct nft_set *set;
-	unsigned int gc_seq;
-	struct net *net;
-
-	priv = container_of(work, struct nft_rbtree, gc_work.work);
-	set  = nft_set_container_of(priv);
-	net  = read_pnet(&set->net);
-	nft_net = nft_pernet(net);
-	gc_seq  = READ_ONCE(nft_net->gc_seq);
-
-	if (nft_set_gc_is_pending(set))
-		goto done;
-
-	gc = nft_trans_gc_alloc(set, gc_seq, GFP_KERNEL);
-	if (!gc)
-		goto done;
-
-	read_lock_bh(&priv->lock);
-	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
-
-		/* Ruleset has been updated, try later. */
-		if (READ_ONCE(nft_net->gc_seq) != gc_seq) {
-			nft_trans_gc_destroy(gc);
-			gc = NULL;
-			goto try_later;
-		}
-
-		rbe = rb_entry(node, struct nft_rbtree_elem, node);
-
-		if (nft_set_elem_is_dead(&rbe->ext))
-			goto dead_elem;
-
-		/* elements are reversed in the rbtree for historical reasons,
-		 * from highest to lowest value, that is why end element is
-		 * always visited before the start element.
-		 */
-		if (nft_rbtree_interval_end(rbe)) {
-			rbe_end = rbe;
-			continue;
-		}
-		if (!nft_set_elem_expired(&rbe->ext))
-			continue;
-
-		nft_set_elem_dead(&rbe->ext);
-
-		if (!rbe_end)
-			continue;
-
-		nft_set_elem_dead(&rbe_end->ext);
-
-		gc = nft_trans_gc_queue_async(gc, gc_seq, GFP_ATOMIC);
-		if (!gc)
-			goto try_later;
-
-		nft_trans_gc_elem_add(gc, rbe_end);
-		rbe_end = NULL;
-dead_elem:
-		gc = nft_trans_gc_queue_async(gc, gc_seq, GFP_ATOMIC);
-		if (!gc)
-			goto try_later;
-
-		nft_trans_gc_elem_add(gc, rbe);
-	}
-
-	gc = nft_trans_gc_catchall_async(gc, gc_seq);
-
-try_later:
-	read_unlock_bh(&priv->lock);
-
-	if (gc)
-		nft_trans_gc_queue_async_done(gc);
-done:
-	queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
-			   nft_set_gc_interval(set));
-}
-
 static u64 nft_rbtree_privsize(const struct nlattr * const nla[],
 			       const struct nft_set_desc *desc)
 {
@@ -725,11 +641,6 @@ static int nft_rbtree_init(const struct nft_set *set,
 	seqcount_rwlock_init(&priv->count, &priv->lock);
 	priv->root = RB_ROOT;
 
-	INIT_DEFERRABLE_WORK(&priv->gc_work, nft_rbtree_gc);
-	if (set->flags & NFT_SET_TIMEOUT)
-		queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
-				   nft_set_gc_interval(set));
-
 	return 0;
 }
 
@@ -740,7 +651,6 @@ static void nft_rbtree_destroy(const struct nft_ctx *ctx,
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *node;
 
-	cancel_delayed_work_sync(&priv->gc_work);
 	rcu_barrier();
 	while ((node = priv->root.rb_node) != NULL) {
 		rb_erase(node, &priv->root);
-- 
2.30.2

