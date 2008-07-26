From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 05/06: fix double-free and use-after free
Date: Sun, 27 Jul 2008 01:37:14 +0200 (MEST)
Message-ID: <20080726233712.15283.88177.sendpatchset@localhost.localdomain>
References: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43540 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbYGZXhP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 19:37:15 -0400
In-Reply-To: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: fix double-free and use-after free

As suggested by Patrick McHardy, introduce a __krealloc() that doesn't
free the original buffer to fix a double-free and use-after-free bug
introduced by me in netfilter that uses RCU.

Reported-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Tested-by: Dieter Ries <clip2@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit dfecb922fa57237ef11bad7b95cbbceb5fdaccce
tree 37d85ce138cda2eca377980bbf110ec6826f77fe
parent ea52606851cacfc5bcd6437ac0d97a22494279ac
author Pekka Enberg <penberg@cs.helsinki.fi> Sun, 27 Jul 2008 00:40:14 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 27 Jul 2008 00:40:14 +0200

 include/linux/slab.h                |    1 +
 mm/util.c                           |   44 +++++++++++++++++++++++++++--------
 net/netfilter/nf_conntrack_extend.c |    2 +-
 3 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 9aa90a6..be6f1d4 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -96,6 +96,7 @@ int kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr);
 /*
  * Common kmalloc functions provided by all allocators
  */
+void * __must_check __krealloc(const void *, size_t, gfp_t);
 void * __must_check krealloc(const void *, size_t, gfp_t);
 void kfree(const void *);
 size_t ksize(const void *);
diff --git a/mm/util.c b/mm/util.c
index 8f18683..6ef9e99 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -68,25 +68,22 @@ void *kmemdup(const void *src, size_t len, gfp_t gfp)
 EXPORT_SYMBOL(kmemdup);
 
 /**
- * krealloc - reallocate memory. The contents will remain unchanged.
+ * __krealloc - like krealloc() but don't free @p.
  * @p: object to reallocate memory for.
  * @new_size: how many bytes of memory are required.
  * @flags: the type of memory to allocate.
  *
- * The contents of the object pointed to are preserved up to the
- * lesser of the new and old sizes.  If @p is %NULL, krealloc()
- * behaves exactly like kmalloc().  If @size is 0 and @p is not a
- * %NULL pointer, the object pointed to is freed.
+ * This function is like krealloc() except it never frees the originally
+ * allocated buffer. Use this if you don't want to free the buffer immediately
+ * like, for example, with RCU.
  */
-void *krealloc(const void *p, size_t new_size, gfp_t flags)
+void *__krealloc(const void *p, size_t new_size, gfp_t flags)
 {
 	void *ret;
 	size_t ks = 0;
 
-	if (unlikely(!new_size)) {
-		kfree(p);
+	if (unlikely(!new_size))
 		return ZERO_SIZE_PTR;
-	}
 
 	if (p)
 		ks = ksize(p);
@@ -95,10 +92,37 @@ void *krealloc(const void *p, size_t new_size, gfp_t flags)
 		return (void *)p;
 
 	ret = kmalloc_track_caller(new_size, flags);
-	if (ret && p) {
+	if (ret && p)
 		memcpy(ret, p, ks);
+
+	return ret;
+}
+EXPORT_SYMBOL(__krealloc);
+
+/**
+ * krealloc - reallocate memory. The contents will remain unchanged.
+ * @p: object to reallocate memory for.
+ * @new_size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate.
+ *
+ * The contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.  If @p is %NULL, krealloc()
+ * behaves exactly like kmalloc().  If @size is 0 and @p is not a
+ * %NULL pointer, the object pointed to is freed.
+ */
+void *krealloc(const void *p, size_t new_size, gfp_t flags)
+{
+	void *ret;
+
+	if (unlikely(!new_size)) {
 		kfree(p);
+		return ZERO_SIZE_PTR;
 	}
+
+	ret = __krealloc(p, new_size, flags);
+	if (ret && p != ret)
+		kfree(p);
+
 	return ret;
 }
 EXPORT_SYMBOL(krealloc);
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 3469bc7..c956ef7 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -95,7 +95,7 @@ void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	newlen = newoff + t->len;
 	rcu_read_unlock();
 
-	new = krealloc(ct->ext, newlen, gfp);
+	new = __krealloc(ct->ext, newlen, gfp);
 	if (!new)
 		return NULL;
 
