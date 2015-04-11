From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 09/14] netfilter: nf_tables: kill nft_data_cmp()
Date: Sat, 11 Apr 2015 02:27:34 +0100
Message-ID: <1428715659-31358-10-git-send-email-kaber@trash.net>
References: <1428715659-31358-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46126 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbbDKB14 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Apr 2015 21:27:56 -0400
In-Reply-To: <1428715659-31358-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Only needlessly complicates things due to requiring specific argument
types. Use memcmp directly.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h |  7 -------
 net/netfilter/nft_cmp.c           |  2 +-
 net/netfilter/nft_hash.c          |  2 +-
 net/netfilter/nft_rbtree.c        | 11 +++++------
 4 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 81cd816..fca0b5d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -69,13 +69,6 @@ struct nft_regs {
 	};
 };
 
-static inline int nft_data_cmp(const struct nft_data *d1,
-			       const struct nft_data *d2,
-			       unsigned int len)
-{
-	return memcmp(d1->data, d2->data, len);
-}
-
 static inline void nft_data_copy(struct nft_data *dst,
 				 const struct nft_data *src)
 {
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 59391e6..b7e1c58 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -31,7 +31,7 @@ static void nft_cmp_eval(const struct nft_expr *expr,
 	const struct nft_cmp_expr *priv = nft_expr_priv(expr);
 	int d;
 
-	d = nft_data_cmp(&regs->data[priv->sreg], &priv->data, priv->len);
+	d = memcmp(&regs->data[priv->sreg], &priv->data, priv->len);
 	switch (priv->op) {
 	case NFT_CMP_EQ:
 		if (d != 0)
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index bbbe87c..c26844d 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -62,7 +62,7 @@ static inline int nft_hash_cmp(struct rhashtable_compare_arg *arg,
 	const struct nft_hash_cmp_arg *x = arg->key;
 	const struct nft_hash_elem *he = ptr;
 
-	if (nft_data_cmp(nft_set_ext_key(&he->ext), x->key, x->set->klen))
+	if (memcmp(nft_set_ext_key(&he->ext), x->key, x->set->klen))
 		return 1;
 	if (nft_set_elem_expired(&he->ext))
 		return 1;
diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index 42d0ca4..b398f1a 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -45,7 +45,7 @@ static bool nft_rbtree_lookup(const struct nft_set *set,
 	while (parent != NULL) {
 		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
 
-		d = nft_data_cmp(nft_set_ext_key(&rbe->ext), key, set->klen);
+		d = memcmp(nft_set_ext_key(&rbe->ext), key, set->klen);
 		if (d < 0) {
 			parent = parent->rb_left;
 			interval = rbe;
@@ -91,9 +91,9 @@ static int __nft_rbtree_insert(const struct nft_set *set,
 	while (*p != NULL) {
 		parent = *p;
 		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
-		d = nft_data_cmp(nft_set_ext_key(&rbe->ext),
-				 nft_set_ext_key(&new->ext),
-				 set->klen);
+		d = memcmp(nft_set_ext_key(&rbe->ext),
+			   nft_set_ext_key(&new->ext),
+			   set->klen);
 		if (d < 0)
 			p = &parent->rb_left;
 		else if (d > 0)
@@ -153,8 +153,7 @@ static void *nft_rbtree_deactivate(const struct nft_set *set,
 	while (parent != NULL) {
 		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
 
-		d = nft_data_cmp(nft_set_ext_key(&rbe->ext), &elem->key,
-				 set->klen);
+		d = memcmp(nft_set_ext_key(&rbe->ext), &elem->key, set->klen);
 		if (d < 0)
 			parent = parent->rb_left;
 		else if (d > 0)
-- 
2.1.0

