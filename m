From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: nf_tables: fix refcount leak when jump to chain is used
Date: Wed, 18 Feb 2015 04:52:25 +0100
Message-ID: <1424231546-4886-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37970 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbbBRDtN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2015 22:49:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to uninit() the data part of the element, otherwise we may
hit a bug trap in the abort path depending on the ruleset.

RIP: 0010:[<ffffffffa07b0547>]  [<ffffffffa07b0547>] nf_tables_chain_destroy+0x24/0x55 [nf_tables]
[...]
Call Trace:
 [<ffffffffa07b0f2d>] nf_tables_abort+0x245/0x287 [nf_tables]
 [<ffffffffa06378ee>] nfnetlink_rcv_batch+0x2c8/0x457 [nfnetlink]
 [<ffffffffa06379a7>] ? nfnetlink_rcv_batch+0x381/0x457 [nfnetlink]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_hash.c   |    2 +-
 net/netfilter/nft_rbtree.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 61e6c40..87ec456 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -86,7 +86,7 @@ static void nft_hash_remove(const struct nft_set *set,
 
 	rhashtable_remove(priv, elem->cookie);
 	synchronize_rcu();
-	kfree(elem->cookie);
+	nft_hash_elem_destroy(set, elem->cookie);
 }
 
 struct nft_compare_arg {
diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index 46214f2..5089f55 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -148,7 +148,7 @@ static void nft_rbtree_remove(const struct nft_set *set,
 	spin_lock_bh(&nft_rbtree_lock);
 	rb_erase(&rbe->node, &priv->root);
 	spin_unlock_bh(&nft_rbtree_lock);
-	kfree(rbe);
+	nft_rbtree_elem_destroy(set, rbe);
 }
 
 static int nft_rbtree_get(const struct nft_set *set, struct nft_set_elem *elem)
-- 
1.7.10.4

