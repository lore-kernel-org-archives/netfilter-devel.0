Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 644F4CDB47E
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Oct 2023 12:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjJMMSj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Oct 2023 08:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjJMMSi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Oct 2023 08:18:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2417C0
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Oct 2023 05:18:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qrH7j-0007eT-9q; Fri, 13 Oct 2023 14:18:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: nft_set_rbtree: rename gc deactivate+erase function
Date:   Fri, 13 Oct 2023 14:18:15 +0200
Message-ID: <20231013121821.31322-3-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231013121821.31322-1-fw@strlen.de>
References: <20231013121821.31322-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Next patch adds a cllaer that doesn't hold the priv->write lock and
will need a similar function.

Rename the existing function to make it clear that it can only
be used for opportunistic gc during insertion.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_rbtree.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 2660ceab3759..e137a0fd4179 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -221,14 +221,15 @@ static void *nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	return rbe;
 }
 
-static void nft_rbtree_gc_remove(struct net *net, struct nft_set *set,
-				 struct nft_rbtree *priv,
-				 struct nft_rbtree_elem *rbe)
+static void nft_rbtree_gc_elem_remove(struct net *net, struct nft_set *set,
+				      struct nft_rbtree *priv,
+				      struct nft_rbtree_elem *rbe)
 {
 	struct nft_set_elem elem = {
 		.priv	= rbe,
 	};
 
+	lockdep_assert_held_write(&priv->lock);
 	nft_setelem_data_deactivate(net, set, &elem);
 	rb_erase(&rbe->node, &priv->root);
 }
@@ -263,7 +264,7 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 	rbe_prev = NULL;
 	if (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
-		nft_rbtree_gc_remove(net, set, priv, rbe_prev);
+		nft_rbtree_gc_elem_remove(net, set, priv, rbe_prev);
 
 		/* There is always room in this trans gc for this element,
 		 * memory allocation never actually happens, hence, the warning
@@ -277,7 +278,7 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 		nft_trans_gc_elem_add(gc, rbe_prev);
 	}
 
-	nft_rbtree_gc_remove(net, set, priv, rbe);
+	nft_rbtree_gc_elem_remove(net, set, priv, rbe);
 	gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
 	if (WARN_ON_ONCE(!gc))
 		return ERR_PTR(-ENOMEM);
-- 
2.41.0

