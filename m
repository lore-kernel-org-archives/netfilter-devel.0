From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 5/6] netfilter: remove last traces of variable-sized extensions
Date: Sun, 16 Apr 2017 01:29:18 +0200
Message-ID: <20170415232919.13671-6-fw@strlen.de>
References: <20170415232919.13671-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57840 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755116AbdDOX3T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 19:29:19 -0400
In-Reply-To: <20170415232919.13671-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

get rid of the (now unused) nf_ct_ext_add_length define and also
rename the function to plain nf_ct_ext_add().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_extend.h |  8 +-------
 net/netfilter/nf_conntrack_extend.c         | 16 +++++++---------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 1c3035dda31f..4ec645c8b647 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -86,13 +86,7 @@ static inline void nf_ct_ext_free(struct nf_conn *ct)
 }
 
 /* Add this type, returns pointer to data or NULL. */
-void *__nf_ct_ext_add_length(struct nf_conn *ct, enum nf_ct_ext_id id,
-			     size_t var_alloc_len, gfp_t gfp);
-
-#define nf_ct_ext_add(ct, id, gfp) \
-	((id##_TYPE *)__nf_ct_ext_add_length((ct), (id), 0, (gfp)))
-#define nf_ct_ext_add_length(ct, id, len, gfp) \
-	((id##_TYPE *)__nf_ct_ext_add_length((ct), (id), (len), (gfp)))
+void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp);
 
 #define NF_CT_EXT_F_PREALLOC	0x0001
 
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 008299b7f78f..b5879a9c748d 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -44,8 +44,7 @@ void __nf_ct_ext_destroy(struct nf_conn *ct)
 EXPORT_SYMBOL(__nf_ct_ext_destroy);
 
 static void *
-nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id,
-		 size_t var_alloc_len, gfp_t gfp)
+nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
 {
 	unsigned int off, len;
 	struct nf_ct_ext_type *t;
@@ -59,8 +58,8 @@ nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id,
 	}
 
 	off = ALIGN(sizeof(struct nf_ct_ext), t->align);
-	len = off + t->len + var_alloc_len;
-	alloc_size = t->alloc_size + var_alloc_len;
+	len = off + t->len;
+	alloc_size = t->alloc_size;
 	rcu_read_unlock();
 
 	*ext = kzalloc(alloc_size, gfp);
@@ -73,8 +72,7 @@ nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id,
 	return (void *)(*ext) + off;
 }
 
-void *__nf_ct_ext_add_length(struct nf_conn *ct, enum nf_ct_ext_id id,
-			     size_t var_alloc_len, gfp_t gfp)
+void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
 	struct nf_ct_ext *old, *new;
 	int newlen, newoff;
@@ -85,7 +83,7 @@ void *__nf_ct_ext_add_length(struct nf_conn *ct, enum nf_ct_ext_id id,
 
 	old = ct->ext;
 	if (!old)
-		return nf_ct_ext_create(&ct->ext, id, var_alloc_len, gfp);
+		return nf_ct_ext_create(&ct->ext, id, gfp);
 
 	if (__nf_ct_ext_exist(old, id))
 		return NULL;
@@ -98,7 +96,7 @@ void *__nf_ct_ext_add_length(struct nf_conn *ct, enum nf_ct_ext_id id,
 	}
 
 	newoff = ALIGN(old->len, t->align);
-	newlen = newoff + t->len + var_alloc_len;
+	newlen = newoff + t->len;
 	rcu_read_unlock();
 
 	new = __krealloc(old, newlen, gfp);
@@ -115,7 +113,7 @@ void *__nf_ct_ext_add_length(struct nf_conn *ct, enum nf_ct_ext_id id,
 	memset((void *)new + newoff, 0, newlen - newoff);
 	return (void *)new + newoff;
 }
-EXPORT_SYMBOL(__nf_ct_ext_add_length);
+EXPORT_SYMBOL(nf_ct_ext_add);
 
 static void update_alloc_size(struct nf_ct_ext_type *type)
 {
-- 
2.10.2

