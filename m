From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 22/47] netfilter: Refactor nf_conncount
Date: Fri, 30 Mar 2018 13:43:09 +0200
Message-ID: <20180330114334.18664-3-pablo@netfilter.org>
References: <20180330114334.18664-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114334.18664-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Yi-Hung Wei <yihung.wei@gmail.com>

Remove parameter 'family' in nf_conncount_count() and count_tree().
It is because the parameter is not useful after commit 625c556118f3
("netfilter: connlimit: split xt_connlimit into front and backend").

Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_count.h | 1 -
 net/netfilter/nf_conncount.c               | 4 +---
 net/netfilter/xt_connlimit.c               | 4 ++--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index adf8db44cf86..e61184fbfb71 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -11,7 +11,6 @@ void nf_conncount_destroy(struct net *net, unsigned int family,
 unsigned int nf_conncount_count(struct net *net,
 				struct nf_conncount_data *data,
 				const u32 *key,
-				unsigned int family,
 				const struct nf_conntrack_tuple *tuple,
 				const struct nf_conntrack_zone *zone);
 #endif
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 6d65389e308f..9305a08b4422 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -158,7 +158,6 @@ static void tree_nodes_free(struct rb_root *root,
 static unsigned int
 count_tree(struct net *net, struct rb_root *root,
 	   const u32 *key, u8 keylen,
-	   u8 family,
 	   const struct nf_conntrack_tuple *tuple,
 	   const struct nf_conntrack_zone *zone)
 {
@@ -246,7 +245,6 @@ count_tree(struct net *net, struct rb_root *root,
 unsigned int nf_conncount_count(struct net *net,
 				struct nf_conncount_data *data,
 				const u32 *key,
-				unsigned int family,
 				const struct nf_conntrack_tuple *tuple,
 				const struct nf_conntrack_zone *zone)
 {
@@ -259,7 +257,7 @@ unsigned int nf_conncount_count(struct net *net,
 
 	spin_lock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
 
-	count = count_tree(net, root, key, data->keylen, family, tuple, zone);
+	count = count_tree(net, root, key, data->keylen, tuple, zone);
 
 	spin_unlock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
 
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index b1b17b9353e1..6275106ccf50 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -67,8 +67,8 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		key[1] = zone->id;
 	}
 
-	connections = nf_conncount_count(net, info->data, key,
-					 xt_family(par), tuple_ptr, zone);
+	connections = nf_conncount_count(net, info->data, key, tuple_ptr,
+					 zone);
 	if (connections == 0)
 		/* kmalloc failed, drop it entirely */
 		goto hotdrop;
-- 
2.11.0
