From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 4/6] netfilter: nft_hash: convert to use rhashtable callbacks
Date: Wed, 25 Mar 2015 13:07:48 +0000
Message-ID: <1427288870-26336-5-git-send-email-kaber@trash.net>
References: <1427288870-26336-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48266 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbbCYNH5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 09:07:57 -0400
In-Reply-To: <1427288870-26336-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A following patch will convert sets to use so called set extensions,
where the key is not located in a fixed position anymore. This will
require rhashtable hashing and comparison callbacks to be used.

As preparation, convert nft_hash to use these callbacks without any
functional changes.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nft_hash.c | 54 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index e35f0b2..dc96a7e 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -33,16 +33,50 @@ struct nft_hash_elem {
 	struct nft_data			data[];
 };
 
+struct nft_hash_cmp_arg {
+	const struct nft_set		*set;
+	const struct nft_data		*key;
+};
+
 static const struct rhashtable_params nft_hash_params;
 
+static inline u32 nft_hash_key(const void *data, u32 len, u32 seed)
+{
+	const struct nft_hash_cmp_arg *arg = data;
+
+	return jhash(arg->key, len, seed);
+}
+
+static inline u32 nft_hash_obj(const void *data, u32 len, u32 seed)
+{
+	const struct nft_hash_elem *he = data;
+
+	return jhash(&he->key, len, seed);
+}
+
+static inline int nft_hash_cmp(struct rhashtable_compare_arg *arg,
+			       const void *ptr)
+{
+	const struct nft_hash_cmp_arg *x = arg->key;
+	const struct nft_hash_elem *he = ptr;
+
+	if (nft_data_cmp(&he->key, x->key, x->set->klen))
+		return 1;
+	return 0;
+}
+
 static bool nft_hash_lookup(const struct nft_set *set,
 			    const struct nft_data *key,
 			    struct nft_data *data)
 {
 	struct nft_hash *priv = nft_set_priv(set);
 	const struct nft_hash_elem *he;
+	struct nft_hash_cmp_arg arg = {
+		.set	 = set,
+		.key	 = key,
+	};
 
-	he = rhashtable_lookup_fast(&priv->ht, key, nft_hash_params);
+	he = rhashtable_lookup_fast(&priv->ht, &arg, nft_hash_params);
 	if (he && set->flags & NFT_SET_MAP)
 		nft_data_copy(data, he->data);
 
@@ -54,6 +88,10 @@ static int nft_hash_insert(const struct nft_set *set,
 {
 	struct nft_hash *priv = nft_set_priv(set);
 	struct nft_hash_elem *he;
+	struct nft_hash_cmp_arg arg = {
+		.set	 = set,
+		.key	 = &elem->key,
+	};
 	unsigned int size;
 	int err;
 
@@ -72,7 +110,8 @@ static int nft_hash_insert(const struct nft_set *set,
 	if (set->flags & NFT_SET_MAP)
 		nft_data_copy(he->data, &elem->data);
 
-	err = rhashtable_insert_fast(&priv->ht, &he->node, nft_hash_params);
+	err = rhashtable_lookup_insert_key(&priv->ht, &arg, &he->node,
+					   nft_hash_params);
 	if (err)
 		kfree(he);
 
@@ -102,8 +141,12 @@ static int nft_hash_get(const struct nft_set *set, struct nft_set_elem *elem)
 {
 	struct nft_hash *priv = nft_set_priv(set);
 	struct nft_hash_elem *he;
+	struct nft_hash_cmp_arg arg = {
+		.set	 = set,
+		.key	 = &elem->key,
+	};
 
-	he = rhashtable_lookup_fast(&priv->ht, &elem->key, nft_hash_params);
+	he = rhashtable_lookup_fast(&priv->ht, &arg, nft_hash_params);
 	if (!he)
 		return -ENOENT;
 
@@ -174,8 +217,9 @@ static unsigned int nft_hash_privsize(const struct nlattr * const nla[])
 
 static const struct rhashtable_params nft_hash_params = {
 	.head_offset		= offsetof(struct nft_hash_elem, node),
-	.key_offset		= offsetof(struct nft_hash_elem, key),
-	.hashfn			= jhash,
+	.hashfn			= nft_hash_key,
+	.obj_hashfn		= nft_hash_obj,
+	.obj_cmpfn		= nft_hash_cmp,
 	.automatic_shrinking	= true,
 };
 
-- 
2.1.0

