From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 4/5] netfilter: nft_hash: restore struct nft_hash
Date: Sat, 21 Mar 2015 15:19:17 +0000
Message-ID: <1426951158-18168-5-git-send-email-kaber@trash.net>
References: <1426951158-18168-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46429 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbbCUPTY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Mar 2015 11:19:24 -0400
In-Reply-To: <1426951158-18168-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Following patches will add new private members, restore struct nft_hash
as preparation.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nft_hash.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 4585c57..80a6a6d 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -23,6 +23,10 @@
 /* We target a hash table size of 4, element hint is 75% of final size */
 #define NFT_HASH_ELEMENT_HINT 3
 
+struct nft_hash {
+	struct rhashtable		ht;
+};
+
 struct nft_hash_elem {
 	struct rhash_head		node;
 	struct nft_data			key;
@@ -35,10 +39,10 @@ static bool nft_hash_lookup(const struct nft_set *set,
 			    const struct nft_data *key,
 			    struct nft_data *data)
 {
-	struct rhashtable *priv = nft_set_priv(set);
+	struct nft_hash *priv = nft_set_priv(set);
 	const struct nft_hash_elem *he;
 
-	he = rhashtable_lookup_fast(priv, key, nft_hash_params);
+	he = rhashtable_lookup_fast(&priv->ht, key, nft_hash_params);
 	if (he && set->flags & NFT_SET_MAP)
 		nft_data_copy(data, he->data);
 
@@ -48,7 +52,7 @@ static bool nft_hash_lookup(const struct nft_set *set,
 static int nft_hash_insert(const struct nft_set *set,
 			   const struct nft_set_elem *elem)
 {
-	struct rhashtable *priv = nft_set_priv(set);
+	struct nft_hash *priv = nft_set_priv(set);
 	struct nft_hash_elem *he;
 	unsigned int size;
 	int err;
@@ -68,7 +72,7 @@ static int nft_hash_insert(const struct nft_set *set,
 	if (set->flags & NFT_SET_MAP)
 		nft_data_copy(he->data, &elem->data);
 
-	err = rhashtable_insert_fast(priv, &he->node, nft_hash_params);
+	err = rhashtable_insert_fast(&priv->ht, &he->node, nft_hash_params);
 	if (err)
 		kfree(he);
 
@@ -87,19 +91,19 @@ static void nft_hash_elem_destroy(const struct nft_set *set,
 static void nft_hash_remove(const struct nft_set *set,
 			    const struct nft_set_elem *elem)
 {
-	struct rhashtable *priv = nft_set_priv(set);
+	struct nft_hash *priv = nft_set_priv(set);
 
-	rhashtable_remove_fast(priv, elem->cookie, nft_hash_params);
+	rhashtable_remove_fast(&priv->ht, elem->cookie, nft_hash_params);
 	synchronize_rcu();
 	kfree(elem->cookie);
 }
 
 static int nft_hash_get(const struct nft_set *set, struct nft_set_elem *elem)
 {
-	struct rhashtable *priv = nft_set_priv(set);
+	struct nft_hash *priv = nft_set_priv(set);
 	struct nft_hash_elem *he;
 
-	he = rhashtable_lookup_fast(priv, &elem->key, nft_hash_params);
+	he = rhashtable_lookup_fast(&priv->ht, &elem->key, nft_hash_params);
 	if (!he)
 		return -ENOENT;
 
@@ -114,13 +118,13 @@ static int nft_hash_get(const struct nft_set *set, struct nft_set_elem *elem)
 static void nft_hash_walk(const struct nft_ctx *ctx, const struct nft_set *set,
 			  struct nft_set_iter *iter)
 {
-	struct rhashtable *priv = nft_set_priv(set);
+	struct nft_hash *priv = nft_set_priv(set);
 	const struct nft_hash_elem *he;
 	struct rhashtable_iter hti;
 	struct nft_set_elem elem;
 	int err;
 
-	err = rhashtable_walk_init(priv, &hti);
+	err = rhashtable_walk_init(&priv->ht, &hti);
 	iter->err = err;
 	if (err)
 		return;
@@ -163,7 +167,7 @@ out:
 
 static unsigned int nft_hash_privsize(const struct nlattr * const nla[])
 {
-	return sizeof(struct rhashtable);
+	return sizeof(struct nft_hash);
 }
 
 static const struct rhashtable_params nft_hash_params = {
@@ -176,35 +180,35 @@ static int nft_hash_init(const struct nft_set *set,
 			 const struct nft_set_desc *desc,
 			 const struct nlattr * const tb[])
 {
-	struct rhashtable *priv = nft_set_priv(set);
+	struct nft_hash *priv = nft_set_priv(set);
 	struct rhashtable_params params = nft_hash_params;
 
 	params.nelem_hint = desc->size ?: NFT_HASH_ELEMENT_HINT;
 	params.key_len = set->klen;
 
-	return rhashtable_init(priv, &params);
+	return rhashtable_init(&priv->ht, &params);
 }
 
 static void nft_hash_destroy(const struct nft_set *set)
 {
-	struct rhashtable *priv = nft_set_priv(set);
+	struct nft_hash *priv = nft_set_priv(set);
 	const struct bucket_table *tbl;
 	struct nft_hash_elem *he;
 	struct rhash_head *pos, *next;
 	unsigned int i;
 
 	/* Stop an eventual async resizing */
-	priv->being_destroyed = true;
-	mutex_lock(&priv->mutex);
+	priv->ht.being_destroyed = true;
+	mutex_lock(&priv->ht.mutex);
 
-	tbl = rht_dereference(priv->tbl, priv);
+	tbl = rht_dereference(priv->ht.tbl, &priv->ht);
 	for (i = 0; i < tbl->size; i++) {
 		rht_for_each_entry_safe(he, pos, next, tbl, i, node)
 			nft_hash_elem_destroy(set, he);
 	}
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->ht.mutex);
 
-	rhashtable_destroy(priv);
+	rhashtable_destroy(&priv->ht);
 }
 
 static bool nft_hash_estimate(const struct nft_set_desc *desc, u32 features,
@@ -217,7 +221,7 @@ static bool nft_hash_estimate(const struct nft_set_desc *desc, u32 features,
 		esize += FIELD_SIZEOF(struct nft_hash_elem, data[0]);
 
 	if (desc->size) {
-		est->size = sizeof(struct rhashtable) +
+		est->size = sizeof(struct nft_hash) +
 			    roundup_pow_of_two(desc->size * 4 / 3) *
 			    sizeof(struct nft_hash_elem *) +
 			    desc->size * esize;
-- 
2.1.0

