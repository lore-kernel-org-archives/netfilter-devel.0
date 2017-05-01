From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next v2 2/4] netfilter: nf_tables: simplify nft_set_elem_destroy()
Date: Mon,  1 May 2017 10:58:01 +0200
Message-ID: <1493629083-2847-2-git-send-email-pablo@netfilter.org>
References: <1493629083-2847-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48442 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S376354AbdEAI6S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2017 04:58:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 20F421F4B7D
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 10:58:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D31DFC3DC
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 10:58:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17DDBFF2C1
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 10:58:08 +0200 (CEST)
In-Reply-To: <1493629083-2847-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Only nft_dynset needs not to release NFT_SET_EXT_EXPR, add
nft_dynset_elem_destroy() that just releases what we need.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  3 +--
 net/netfilter/nf_tables_api.c     | 11 +++++------
 net/netfilter/nft_dynset.c        | 13 ++++++++++++-
 net/netfilter/nft_set_bitmap.c    |  2 +-
 net/netfilter/nft_set_hash.c      |  6 +++---
 net/netfilter/nft_set_rbtree.c    |  2 +-
 6 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0136028652bd..1b0a2268da55 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -603,8 +603,7 @@ void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *data,
 			u64 timeout, gfp_t gfp);
-void nft_set_elem_destroy(const struct nft_set *set, void *elem,
-			  bool destroy_expr);
+void nft_set_elem_destroy(const struct nft_set *set, void *elem);
 
 /**
  *	struct nft_set_gc_batch_head - nf_tables set garbage collection batch
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 83f97602977c..0e34e88b65c6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3556,15 +3556,14 @@ void *nft_set_elem_init(const struct nft_set *set,
 	return elem;
 }
 
-void nft_set_elem_destroy(const struct nft_set *set, void *elem,
-			  bool destroy_expr)
+void nft_set_elem_destroy(const struct nft_set *set, void *elem)
 {
 	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
 
 	nft_data_uninit(nft_set_ext_key(ext), NFT_DATA_VALUE);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_uninit(nft_set_ext_data(ext), set->dtype);
-	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
 		nf_tables_expr_destroy(NULL, nft_set_ext_expr(ext));
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
 		(*nft_set_ext_obj(ext))->use--;
@@ -3978,7 +3977,7 @@ void nft_set_gc_batch_release(struct rcu_head *rcu)
 
 	gcb = container_of(rcu, struct nft_set_gc_batch, head.rcu);
 	for (i = 0; i < gcb->head.cnt; i++)
-		nft_set_elem_destroy(gcb->head.set, gcb->elems[i], true);
+		nft_set_elem_destroy(gcb->head.set, gcb->elems[i]);
 	kfree(gcb);
 }
 EXPORT_SYMBOL_GPL(nft_set_gc_batch_release);
@@ -4704,7 +4703,7 @@ static void nf_tables_commit_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_DELSETELEM:
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
-				     nft_trans_elem(trans).priv, true);
+				     nft_trans_elem(trans).priv);
 		break;
 	case NFT_MSG_DELOBJ:
 		nft_obj_destroy(nft_trans_obj(trans));
@@ -4859,7 +4858,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_NEWSETELEM:
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
-				     nft_trans_elem(trans).priv, true);
+				     nft_trans_elem(trans).priv);
 		break;
 	case NFT_MSG_NEWOBJ:
 		nft_obj_destroy(nft_trans_obj(trans));
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index fafbeea3ed04..319d2fe8f69f 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -28,6 +28,17 @@ struct nft_dynset {
 	struct nft_set_binding		binding;
 };
 
+static void nft_dynset_elem_destroy(const struct nft_set *set, void *elem)
+{
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
+
+	nft_data_uninit(nft_set_ext_key(ext), set->ktype);
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
+		nft_data_uninit(nft_set_ext_data(ext), set->dtype);
+	/* NFT_SET_EXT_EXPR refers to the template, do not release it here. */
+	kfree(elem);
+}
+
 static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 			    struct nft_regs *regs)
 {
@@ -55,7 +66,7 @@ static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 	return elem;
 
 err2:
-	nft_set_elem_destroy(set, elem, false);
+	nft_dynset_elem_destroy(set, elem);
 err1:
 	if (set->size)
 		atomic_dec(&set->nelems);
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index b988162b5b15..98073616ed27 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -261,7 +261,7 @@ static void nft_bitmap_destroy(const struct nft_set *set)
 	struct nft_bitmap_elem *be, *n;
 
 	list_for_each_entry_safe(be, n, &priv->list, head)
-		nft_set_elem_destroy(set, be, true);
+		nft_set_elem_destroy(set, be);
 }
 
 static bool nft_bitmap_estimate(const struct nft_set_desc *desc, u32 features,
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 5f652720fc78..fd8304b37ab1 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -120,7 +120,7 @@ static bool nft_hash_update(struct nft_set *set, const u32 *key,
 
 	/* Another cpu may race to insert the element with the same key */
 	if (prev) {
-		nft_set_elem_destroy(set, he, true);
+		nft_set_elem_destroy(set, he);
 		he = prev;
 	}
 
@@ -129,7 +129,7 @@ static bool nft_hash_update(struct nft_set *set, const u32 *key,
 	return true;
 
 err2:
-	nft_set_elem_destroy(set, he, true);
+	nft_set_elem_destroy(set, he);
 err1:
 	return false;
 }
@@ -352,7 +352,7 @@ static int nft_hash_init(const struct nft_set *set,
 
 static void nft_hash_elem_destroy(void *ptr, void *arg)
 {
-	nft_set_elem_destroy((const struct nft_set *)arg, ptr, true);
+	nft_set_elem_destroy((const struct nft_set *)arg, ptr);
 }
 
 static void nft_hash_destroy(const struct nft_set *set)
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 78dfbf9588b3..345abee5749a 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -275,7 +275,7 @@ static void nft_rbtree_destroy(const struct nft_set *set)
 	while ((node = priv->root.rb_node) != NULL) {
 		rb_erase(node, &priv->root);
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
-		nft_set_elem_destroy(set, rbe, true);
+		nft_set_elem_destroy(set, rbe);
 	}
 }
 
-- 
2.1.4

