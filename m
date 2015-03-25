From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/4] netfilter: nf_tables: return set extensions from ->lookup()
Date: Wed, 25 Mar 2015 14:08:48 +0000
Message-ID: <1427292530-28529-3-git-send-email-kaber@trash.net>
References: <1427292530-28529-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48913 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbbCYOIz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 10:08:55 -0400
In-Reply-To: <1427292530-28529-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Return the extension area from the ->lookup() function to allow to
consolidate common actions.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h | 4 +++-
 net/netfilter/nft_hash.c          | 6 +++---
 net/netfilter/nft_lookup.c        | 6 +++++-
 net/netfilter/nft_rbtree.c        | 7 +++----
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 6ac6332..f190d26 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -200,6 +200,8 @@ struct nft_set_estimate {
 	enum nft_set_class	class;
 };
 
+struct nft_set_ext;
+
 /**
  *	struct nft_set_ops - nf_tables set operations
  *
@@ -218,7 +220,7 @@ struct nft_set_estimate {
 struct nft_set_ops {
 	bool				(*lookup)(const struct nft_set *set,
 						  const struct nft_data *key,
-						  struct nft_data *data);
+						  const struct nft_set_ext **ext);
 	int				(*get)(const struct nft_set *set,
 					       struct nft_set_elem *elem);
 	int				(*insert)(const struct nft_set *set,
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 94bf25d..5bee821 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -66,7 +66,7 @@ static inline int nft_hash_cmp(struct rhashtable_compare_arg *arg,
 
 static bool nft_hash_lookup(const struct nft_set *set,
 			    const struct nft_data *key,
-			    struct nft_data *data)
+			    const struct nft_set_ext **ext)
 {
 	struct nft_hash *priv = nft_set_priv(set);
 	const struct nft_hash_elem *he;
@@ -76,8 +76,8 @@ static bool nft_hash_lookup(const struct nft_set *set,
 	};
 
 	he = rhashtable_lookup_fast(&priv->ht, &arg, nft_hash_params);
-	if (he && set->flags & NFT_SET_MAP)
-		nft_data_copy(data, nft_set_ext_data(&he->ext));
+	if (he != NULL)
+		*ext = &he->ext;
 
 	return !!he;
 }
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 9615b8b..a5f30b8 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -31,9 +31,13 @@ static void nft_lookup_eval(const struct nft_expr *expr,
 {
 	const struct nft_lookup *priv = nft_expr_priv(expr);
 	const struct nft_set *set = priv->set;
+	const struct nft_set_ext *ext;
 
-	if (set->ops->lookup(set, &data[priv->sreg], &data[priv->dreg]))
+	if (set->ops->lookup(set, &data[priv->sreg], &ext)) {
+		if (set->flags & NFT_SET_MAP)
+			nft_data_copy(&data[priv->dreg], nft_set_ext_data(ext));
 		return;
+	}
 	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
 
diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index 332c6af..cbba755 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -31,7 +31,7 @@ struct nft_rbtree_elem {
 
 static bool nft_rbtree_lookup(const struct nft_set *set,
 			      const struct nft_data *key,
-			      struct nft_data *data)
+			      const struct nft_set_ext **ext)
 {
 	const struct nft_rbtree *priv = nft_set_priv(set);
 	const struct nft_rbtree_elem *rbe, *interval = NULL;
@@ -55,10 +55,9 @@ found:
 			    *nft_set_ext_flags(&rbe->ext) &
 			    NFT_SET_ELEM_INTERVAL_END)
 				goto out;
-			if (set->flags & NFT_SET_MAP)
-				nft_data_copy(data, nft_set_ext_data(&rbe->ext));
-
 			spin_unlock_bh(&nft_rbtree_lock);
+
+			*ext = &rbe->ext;
 			return true;
 		}
 	}
-- 
2.1.0

