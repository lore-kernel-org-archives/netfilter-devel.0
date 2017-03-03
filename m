From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/4] netfilter: nft_set_rbtree: incorrect assumption on lower interval lookups
Date: Fri,  3 Mar 2017 20:22:24 +0100
Message-ID: <1488568945-4177-4-git-send-email-pablo@netfilter.org>
References: <1488568945-4177-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1488568945-4177-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

In case of adjacent ranges, we may indeed see either the high part of
the range in first place or the low part of it. Remove this incorrect
assumption, let's make sure we annotate the low part of the interval in
case of we have adjacent interva intervals so we hit a matching in
lookups.

Reported-by: Simon Hanisch <hanisch@wh2.tu-dresden.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 71e8fb886a73..78dfbf9588b3 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -60,11 +60,10 @@ static bool nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
 		d = memcmp(this, key, set->klen);
 		if (d < 0) {
 			parent = parent->rb_left;
-			/* In case of adjacent ranges, we always see the high
-			 * part of the range in first place, before the low one.
-			 * So don't update interval if the keys are equal.
-			 */
-			if (interval && nft_rbtree_equal(set, this, interval))
+			if (interval &&
+			    nft_rbtree_equal(set, this, interval) &&
+			    nft_rbtree_interval_end(this) &&
+			    !nft_rbtree_interval_end(interval))
 				continue;
 			interval = rbe;
 		} else if (d > 0)
-- 
2.1.4
