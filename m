From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] netfilter: nft_rbtree: no need for spinlock from set destroy path
Date: Tue,  2 Sep 2014 11:38:40 +0200
Message-ID: <1409650721-9621-2-git-send-email-pablo@netfilter.org>
References: <1409650721-9621-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tgraf@suug.ch
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34672 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbaIBJh5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:37:57 -0400
In-Reply-To: <1409650721-9621-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The sets are released from the rcu callback, after the rule is removed
from the chain list, which implies that nfnetlink cannot update the
rbtree and no packets are walking on the set anymore. Thus, we can get
rid of the spinlock in the set destroy path there.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_rbtree.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index e1836ff..46214f2 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -234,13 +234,11 @@ static void nft_rbtree_destroy(const struct nft_set *set)
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *node;
 
-	spin_lock_bh(&nft_rbtree_lock);
 	while ((node = priv->root.rb_node) != NULL) {
 		rb_erase(node, &priv->root);
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
 		nft_rbtree_elem_destroy(set, rbe);
 	}
-	spin_unlock_bh(&nft_rbtree_lock);
 }
 
 static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 features,
-- 
1.7.10.4

