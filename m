From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 9/9] netfilter: nf_conncount: Fix garbage collection with zones
Date: Wed, 13 Jun 2018 12:57:00 +0200
Message-ID: <20180613105700.12894-10-pablo@netfilter.org>
References: <20180613105700.12894-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180613105700.12894-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Yi-Hung Wei <yihung.wei@gmail.com>

Currently, we use check_hlist() for garbage colleciton. However, we
use the ‘zone’ from the counted entry to query the existence of
existing entries in the hlist. This could be wrong when they are in
different zones, and this patch fixes this issue.

Fixes: e59ea3df3fc2 ("netfilter: xt_connlimit: honor conntrack zone if available")
Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_count.h |  3 ++-
 net/netfilter/nf_conncount.c               | 13 +++++++++----
 net/netfilter/nft_connlimit.c              |  2 +-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index 1910b6572430..3a188a0923a3 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -20,7 +20,8 @@ unsigned int nf_conncount_lookup(struct net *net, struct hlist_head *head,
 				 bool *addit);
 
 bool nf_conncount_add(struct hlist_head *head,
-		      const struct nf_conntrack_tuple *tuple);
+		      const struct nf_conntrack_tuple *tuple,
+		      const struct nf_conntrack_zone *zone);
 
 void nf_conncount_cache_free(struct hlist_head *hhead);
 
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 3b5059a8dcdd..d8383609fe28 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -46,6 +46,7 @@
 struct nf_conncount_tuple {
 	struct hlist_node		node;
 	struct nf_conntrack_tuple	tuple;
+	struct nf_conntrack_zone	zone;
 };
 
 struct nf_conncount_rb {
@@ -80,7 +81,8 @@ static int key_diff(const u32 *a, const u32 *b, unsigned int klen)
 }
 
 bool nf_conncount_add(struct hlist_head *head,
-		      const struct nf_conntrack_tuple *tuple)
+		      const struct nf_conntrack_tuple *tuple,
+		      const struct nf_conntrack_zone *zone)
 {
 	struct nf_conncount_tuple *conn;
 
@@ -88,6 +90,7 @@ bool nf_conncount_add(struct hlist_head *head,
 	if (conn == NULL)
 		return false;
 	conn->tuple = *tuple;
+	conn->zone = *zone;
 	hlist_add_head(&conn->node, head);
 	return true;
 }
@@ -108,7 +111,7 @@ unsigned int nf_conncount_lookup(struct net *net, struct hlist_head *head,
 
 	/* check the saved connections */
 	hlist_for_each_entry_safe(conn, n, head, node) {
-		found = nf_conntrack_find_get(net, zone, &conn->tuple);
+		found = nf_conntrack_find_get(net, &conn->zone, &conn->tuple);
 		if (found == NULL) {
 			hlist_del(&conn->node);
 			kmem_cache_free(conncount_conn_cachep, conn);
@@ -117,7 +120,8 @@ unsigned int nf_conncount_lookup(struct net *net, struct hlist_head *head,
 
 		found_ct = nf_ct_tuplehash_to_ctrack(found);
 
-		if (tuple && nf_ct_tuple_equal(&conn->tuple, tuple)) {
+		if (tuple && nf_ct_tuple_equal(&conn->tuple, tuple) &&
+		    nf_ct_zone_equal(found_ct, zone, zone->dir)) {
 			/*
 			 * Just to be sure we have it only once in the list.
 			 * We should not see tuples twice unless someone hooks
@@ -196,7 +200,7 @@ count_tree(struct net *net, struct rb_root *root,
 			if (!addit)
 				return count;
 
-			if (!nf_conncount_add(&rbconn->hhead, tuple))
+			if (!nf_conncount_add(&rbconn->hhead, tuple, zone))
 				return 0; /* hotdrop */
 
 			return count + 1;
@@ -238,6 +242,7 @@ count_tree(struct net *net, struct rb_root *root,
 	}
 
 	conn->tuple = *tuple;
+	conn->zone = *zone;
 	memcpy(rbconn->key, key, sizeof(u32) * keylen);
 
 	INIT_HLIST_HEAD(&rbconn->hhead);
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 50c068d660e5..a832c59f0a9c 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -52,7 +52,7 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 	if (!addit)
 		goto out;
 
-	if (!nf_conncount_add(&priv->hhead, tuple_ptr)) {
+	if (!nf_conncount_add(&priv->hhead, tuple_ptr, zone)) {
 		regs->verdict.code = NF_DROP;
 		spin_unlock_bh(&priv->lock);
 		return;
-- 
2.11.0
