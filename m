From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 10/14] netfilter: nf_tables: convert sets to u32 data pointers
Date: Sat, 11 Apr 2015 02:27:35 +0100
Message-ID: <1428715659-31358-11-git-send-email-kaber@trash.net>
References: <1428715659-31358-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46128 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbbDKB15 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Apr 2015 21:27:57 -0400
In-Reply-To: <1428715659-31358-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Simple conversion to use u32 pointers to the beginning of the data
area to keep follow up patches smaller.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h |  4 ++--
 net/netfilter/nft_hash.c          | 11 +++++------
 net/netfilter/nft_rbtree.c        |  3 +--
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fca0b5d..efcf46d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -231,10 +231,10 @@ struct nft_expr;
  */
 struct nft_set_ops {
 	bool				(*lookup)(const struct nft_set *set,
-						  const struct nft_data *key,
+						  const u32 *key,
 						  const struct nft_set_ext **ext);
 	bool				(*update)(struct nft_set *set,
-						  const struct nft_data *key,
+						  const u32 *key,
 						  void *(*new)(struct nft_set *,
 							       const struct nft_expr *,
 							       struct nft_regs *),
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index c26844d..c4b4475 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -36,7 +36,7 @@ struct nft_hash_elem {
 
 struct nft_hash_cmp_arg {
 	const struct nft_set		*set;
-	const struct nft_data		*key;
+	const u32			*key;
 	u8				genmask;
 };
 
@@ -71,8 +71,7 @@ static inline int nft_hash_cmp(struct rhashtable_compare_arg *arg,
 	return 0;
 }
 
-static bool nft_hash_lookup(const struct nft_set *set,
-			    const struct nft_data *key,
+static bool nft_hash_lookup(const struct nft_set *set, const u32 *key,
 			    const struct nft_set_ext **ext)
 {
 	struct nft_hash *priv = nft_set_priv(set);
@@ -90,7 +89,7 @@ static bool nft_hash_lookup(const struct nft_set *set,
 	return !!he;
 }
 
-static bool nft_hash_update(struct nft_set *set, const struct nft_data *key,
+static bool nft_hash_update(struct nft_set *set, const u32 *key,
 			    void *(*new)(struct nft_set *,
 					 const struct nft_expr *,
 					 struct nft_regs *regs),
@@ -134,7 +133,7 @@ static int nft_hash_insert(const struct nft_set *set,
 	struct nft_hash_cmp_arg arg = {
 		.genmask = nft_genmask_next(read_pnet(&set->pnet)),
 		.set	 = set,
-		.key	 = &elem->key,
+		.key	 = elem->key.data,
 	};
 
 	return rhashtable_lookup_insert_key(&priv->ht, &arg, &he->node,
@@ -158,7 +157,7 @@ static void *nft_hash_deactivate(const struct nft_set *set,
 	struct nft_hash_cmp_arg arg = {
 		.genmask = nft_genmask_next(read_pnet(&set->pnet)),
 		.set	 = set,
-		.key	 = &elem->key,
+		.key	 = elem->key.data,
 	};
 
 	rcu_read_lock();
diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index b398f1a..b888e0c 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -30,8 +30,7 @@ struct nft_rbtree_elem {
 };
 
 
-static bool nft_rbtree_lookup(const struct nft_set *set,
-			      const struct nft_data *key,
+static bool nft_rbtree_lookup(const struct nft_set *set, const u32 *key,
 			      const struct nft_set_ext **ext)
 {
 	const struct nft_rbtree *priv = nft_set_priv(set);
-- 
2.1.0

