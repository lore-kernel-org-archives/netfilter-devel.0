From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/8] netfilter: nft_set_rbtree: allow loose matching of closing element in interval
Date: Mon, 22 Oct 2018 22:07:17 +0200
Message-ID: <20181022200724.25806-2-pablo@netfilter.org>
References: <20181022200724.25806-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181022200724.25806-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Allow to find closest matching for the right side of an interval (end
flag set on) so we allow lookups in inner ranges, eg. 10-20 in 5-25.

Fixes: ba0e4d9917b4 ("netfilter: nf_tables: get set elements via netlink")
Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 0e5ec126f6ad..fa61208371f8 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -135,9 +135,12 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 		d = memcmp(this, key, set->klen);
 		if (d < 0) {
 			parent = rcu_dereference_raw(parent->rb_left);
-			interval = rbe;
+			if (!(flags & NFT_SET_ELEM_INTERVAL_END))
+				interval = rbe;
 		} else if (d > 0) {
 			parent = rcu_dereference_raw(parent->rb_right);
+			if (flags & NFT_SET_ELEM_INTERVAL_END)
+				interval = rbe;
 		} else {
 			if (!nft_set_elem_active(&rbe->ext, genmask))
 				parent = rcu_dereference_raw(parent->rb_left);
@@ -154,7 +157,10 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
-	    !nft_rbtree_interval_end(interval)) {
+	    ((!nft_rbtree_interval_end(interval) &&
+	      !(flags & NFT_SET_ELEM_INTERVAL_END)) ||
+	     (nft_rbtree_interval_end(interval) &&
+	      (flags & NFT_SET_ELEM_INTERVAL_END)))) {
 		*elem = interval;
 		return true;
 	}
-- 
2.11.0
