From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH 2/2] netfilter: nft_hash: use set global element counter instead of private one
Date: Tue,  4 Mar 2014 16:41:07 +0100
Message-ID: <1393947667-6143-3-git-send-email-kaber@trash.net>
References: <1393947667-6143-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41020 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaCDPlu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:41:50 -0500
In-Reply-To: <1393947667-6143-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that nf_tables performs global accounting of set elements, it is not
needed in the hash type anymore.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nft_hash.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index c0ede25b..bfb732d 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -27,7 +27,6 @@ struct nft_hash {
 
 struct nft_hash_table {
 	unsigned int			size;
-	unsigned int			elements;
 	struct nft_hash_elem __rcu	*buckets[];
 };
 
@@ -166,7 +165,6 @@ static int nft_hash_tbl_expand(const struct nft_set *set, struct nft_hash *priv)
 			break;
 		}
 	}
-	ntbl->elements = tbl->elements;
 
 	/* Publish new table */
 	rcu_assign_pointer(priv->tbl, ntbl);
@@ -206,7 +204,6 @@ static int nft_hash_tbl_shrink(const struct nft_set *set, struct nft_hash *priv)
 			;
 		RCU_INIT_POINTER(*pprev, tbl->buckets[i + ntbl->size]);
 	}
-	ntbl->elements = tbl->elements;
 
 	/* Publish new table */
 	rcu_assign_pointer(priv->tbl, ntbl);
@@ -242,10 +239,9 @@ static int nft_hash_insert(const struct nft_set *set,
 	h = nft_hash_data(&he->key, tbl->size, set->klen);
 	RCU_INIT_POINTER(he->next, tbl->buckets[h]);
 	rcu_assign_pointer(tbl->buckets[h], he);
-	tbl->elements++;
 
 	/* Expand table when exceeding 75% load */
-	if (tbl->elements > tbl->size / 4 * 3)
+	if (set->nelems + 1 > tbl->size / 4 * 3)
 		nft_hash_tbl_expand(set, priv);
 
 	return 0;
@@ -273,10 +269,9 @@ static void nft_hash_remove(const struct nft_set *set,
 	RCU_INIT_POINTER(*pprev, he->next);
 	synchronize_rcu();
 	kfree(he);
-	tbl->elements--;
 
 	/* Shrink table beneath 30% load */
-	if (tbl->elements < tbl->size * 3 / 10 &&
+	if (set->nelems - 1 < tbl->size * 3 / 10 &&
 	    tbl->size > NFT_HASH_MIN_SIZE)
 		nft_hash_tbl_shrink(set, priv);
 }
-- 
1.8.5.3

