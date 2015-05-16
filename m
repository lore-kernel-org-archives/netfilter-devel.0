From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable] netfilter: nft_rbtree: fix locking
Date: Sat, 16 May 2015 20:50:51 +0200
Message-ID: <1431802251-4781-7-git-send-email-pablo@netfilter.org>
References: <1431802251-4781-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1431802251-4781-1-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>

[ upstream commit 16c45eda96038aae848b6cfd42e2bf4b5e80f365 ]

Fix a race condition and unnecessary locking:

* the root rb_node must only be accessed under the lock in nft_rbtree_lookup()
* the lock is not needed in lookup functions in netlink context

Cc: <stable@vger.kernel.org> # 3.18.x
Cc: <stable@vger.kernel.org> # 3.19.x
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_rbtree.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index 46214f2..2c75361 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -37,10 +37,11 @@ static bool nft_rbtree_lookup(const struct nft_set *set,
 {
 	const struct nft_rbtree *priv = nft_set_priv(set);
 	const struct nft_rbtree_elem *rbe, *interval = NULL;
-	const struct rb_node *parent = priv->root.rb_node;
+	const struct rb_node *parent;
 	int d;
 
 	spin_lock_bh(&nft_rbtree_lock);
+	parent = priv->root.rb_node;
 	while (parent != NULL) {
 		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
 
@@ -158,7 +159,6 @@ static int nft_rbtree_get(const struct nft_set *set, struct nft_set_elem *elem)
 	struct nft_rbtree_elem *rbe;
 	int d;
 
-	spin_lock_bh(&nft_rbtree_lock);
 	while (parent != NULL) {
 		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
 
@@ -173,11 +173,9 @@ static int nft_rbtree_get(const struct nft_set *set, struct nft_set_elem *elem)
 			    !(rbe->flags & NFT_SET_ELEM_INTERVAL_END))
 				nft_data_copy(&elem->data, rbe->data);
 			elem->flags = rbe->flags;
-			spin_unlock_bh(&nft_rbtree_lock);
 			return 0;
 		}
 	}
-	spin_unlock_bh(&nft_rbtree_lock);
 	return -ENOENT;
 }
 
-- 
1.7.10.4
