From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 2/3] netfilter: nf_tables: fix *leak* when expr clone fail
Date: Sat, 22 Oct 2016 18:51:25 +0800
Message-ID: <1477133486-60686-3-git-send-email-zlpnobody@163.com>
References: <1477133486-60686-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:33186 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934338AbcJVKwM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Oct 2016 06:52:12 -0400
In-Reply-To: <1477133486-60686-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

When nft_expr_clone failed, a series of problems will happen:

1. module refcnt will leak, we call __module_get at the beginning but
   we forget to put it back if ops->clone returns fail
2. memory will be leaked, if clone fail, we just return NULL and forget
   to free the alloced element
3. set->nelems will become incorrect when set->size is specified. If
   clone fail, we should decrease the set->nelems

Now this patch fixes these problems. And fortunately, clone fail will
only happen on counter expression when memory is exhausted.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 include/net/netfilter/nf_tables.h |  6 ++++--
 net/netfilter/nf_tables_api.c     | 11 ++++++-----
 net/netfilter/nft_dynset.c        | 16 ++++++++++------
 net/netfilter/nft_set_hash.c      |  4 ++--
 net/netfilter/nft_set_rbtree.c    |  2 +-
 5 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5031e07..741dcde 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -542,7 +542,8 @@ void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *data,
 			u64 timeout, gfp_t gfp);
-void nft_set_elem_destroy(const struct nft_set *set, void *elem);
+void nft_set_elem_destroy(const struct nft_set *set, void *elem,
+			  bool destroy_expr);
 
 /**
  *	struct nft_set_gc_batch_head - nf_tables set garbage collection batch
@@ -693,7 +694,6 @@ static inline int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
 {
 	int err;
 
-	__module_get(src->ops->type->owner);
 	if (src->ops->clone) {
 		dst->ops = src->ops;
 		err = src->ops->clone(dst, src);
@@ -702,6 +702,8 @@ static inline int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
 	} else {
 		memcpy(dst, src, src->ops->size);
 	}
+
+	__module_get(src->ops->type->owner);
 	return 0;
 }
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b70d3ea..9de155a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3452,14 +3452,15 @@ void *nft_set_elem_init(const struct nft_set *set,
 	return elem;
 }
 
-void nft_set_elem_destroy(const struct nft_set *set, void *elem)
+void nft_set_elem_destroy(const struct nft_set *set, void *elem,
+			  bool destroy_expr)
 {
 	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
 
 	nft_data_uninit(nft_set_ext_key(ext), NFT_DATA_VALUE);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_uninit(nft_set_ext_data(ext), set->dtype);
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
+	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
 		nf_tables_expr_destroy(NULL, nft_set_ext_expr(ext));
 
 	kfree(elem);
@@ -3812,7 +3813,7 @@ void nft_set_gc_batch_release(struct rcu_head *rcu)
 
 	gcb = container_of(rcu, struct nft_set_gc_batch, head.rcu);
 	for (i = 0; i < gcb->head.cnt; i++)
-		nft_set_elem_destroy(gcb->head.set, gcb->elems[i]);
+		nft_set_elem_destroy(gcb->head.set, gcb->elems[i], true);
 	kfree(gcb);
 }
 EXPORT_SYMBOL_GPL(nft_set_gc_batch_release);
@@ -4030,7 +4031,7 @@ static void nf_tables_commit_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_DELSETELEM:
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
-				     nft_trans_elem(trans).priv);
+				     nft_trans_elem(trans).priv, true);
 		break;
 	}
 	kfree(trans);
@@ -4171,7 +4172,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_NEWSETELEM:
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
-				     nft_trans_elem(trans).priv);
+				     nft_trans_elem(trans).priv, true);
 		break;
 	}
 	kfree(trans);
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 6a631cb..a918482 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -44,18 +44,22 @@ static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 				 &regs->data[priv->sreg_key],
 				 &regs->data[priv->sreg_data],
 				 timeout, GFP_ATOMIC);
-	if (elem == NULL) {
-		if (set->size)
-			atomic_dec(&set->nelems);
-		return NULL;
-	}
+	if (elem == NULL)
+		goto err1;
 
 	ext = nft_set_elem_ext(set, elem);
 	if (priv->expr != NULL &&
 	    nft_expr_clone(nft_set_ext_expr(ext), priv->expr) < 0)
-		return NULL;
+		goto err2;
 
 	return elem;
+
+err2:
+	nft_set_elem_destroy(set, elem, false);
+err1:
+	if (set->size)
+		atomic_dec(&set->nelems);
+	return NULL;
 }
 
 static void nft_dynset_eval(const struct nft_expr *expr,
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 3794cb2..88d9fc8 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -120,7 +120,7 @@ static bool nft_hash_update(struct nft_set *set, const u32 *key,
 	return true;
 
 err2:
-	nft_set_elem_destroy(set, he);
+	nft_set_elem_destroy(set, he, true);
 err1:
 	return false;
 }
@@ -332,7 +332,7 @@ static int nft_hash_init(const struct nft_set *set,
 
 static void nft_hash_elem_destroy(void *ptr, void *arg)
 {
-	nft_set_elem_destroy((const struct nft_set *)arg, ptr);
+	nft_set_elem_destroy((const struct nft_set *)arg, ptr, true);
 }
 
 static void nft_hash_destroy(const struct nft_set *set)
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 38b5bda..36493a7 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -266,7 +266,7 @@ static void nft_rbtree_destroy(const struct nft_set *set)
 	while ((node = priv->root.rb_node) != NULL) {
 		rb_erase(node, &priv->root);
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
-		nft_set_elem_destroy(set, rbe);
+		nft_set_elem_destroy(set, rbe, true);
 	}
 }
 
-- 
2.5.5


