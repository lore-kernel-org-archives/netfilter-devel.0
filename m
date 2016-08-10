From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/9] netfilter: nft_rbtree: ignore inactive matching element with no descendants
Date: Wed, 10 Aug 2016 21:16:39 +0200
Message-ID: <1470856605-7903-4-git-send-email-pablo@netfilter.org>
References: <1470856605-7903-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1470856605-7903-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

If we find a matching element that is inactive with no descendants, we
jump to the found label, then crash because of nul-dereference on the
left branch.

Fix this by checking that the element is active and not an interval end
and skipping the logic that only applies to the tree iteration.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Tested-by: Anders K. Pedersen <akp@akp.dk>
---
 net/netfilter/nft_rbtree.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index 6473936..ffe9ae0 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -70,7 +70,6 @@ static bool nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
 		} else if (d > 0)
 			parent = parent->rb_right;
 		else {
-found:
 			if (!nft_set_elem_active(&rbe->ext, genmask)) {
 				parent = parent->rb_left;
 				continue;
@@ -84,9 +83,12 @@ found:
 		}
 	}
 
-	if (set->flags & NFT_SET_INTERVAL && interval != NULL) {
-		rbe = interval;
-		goto found;
+	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
+	    nft_set_elem_active(&interval->ext, genmask) &&
+	    !nft_rbtree_interval_end(interval)) {
+		spin_unlock_bh(&nft_rbtree_lock);
+		*ext = &interval->ext;
+		return true;
 	}
 out:
 	spin_unlock_bh(&nft_rbtree_lock);
-- 
2.1.4
