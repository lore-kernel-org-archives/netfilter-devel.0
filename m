Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6672FC0032E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 21:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjJYV0I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 17:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjJYV0H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 17:26:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 919BA132;
        Wed, 25 Oct 2023 14:26:02 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net-next 01/19] netfilter: nft_set_rbtree: rename gc deactivate+erase function
Date:   Wed, 25 Oct 2023 23:25:37 +0200
Message-Id: <20231025212555.132775-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231025212555.132775-1-pablo@netfilter.org>
References: <20231025212555.132775-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Next patch adds a cllaer that doesn't hold the priv->write lock and
will need a similar function.

Rename the existing function to make it clear that it can only
be used for opportunistic gc during insertion.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index e34662f4a71e..d59be2bc6e6c 100644
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
2.30.2

