From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] netfilter: conntrack: handle initial extension alloc via krealloc
Date: Wed, 19 Apr 2017 23:44:38 +0200
Message-ID: <20170419214438.20938-4-fw@strlen.de>
References: <20170419214438.20938-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45110 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S969734AbdDSVoa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 17:44:30 -0400
In-Reply-To: <20170419214438.20938-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

krealloc(NULL, ..) is same as kmalloc(), so we can avoid special-casing
the initial allocation after the prealloc removal (we had to use
->alloc_len as the initial allocation size).

This also means we do not zero the preallocated memory anymore; only
offsets[].  Existing code makes sure the new (used) extension space gets
zeroed out.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_extend.c | 51 +++++++++++--------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 5c66816eb965..9114d51fae2e 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -44,49 +44,24 @@ void __nf_ct_ext_destroy(struct nf_conn *ct)
 }
 EXPORT_SYMBOL(__nf_ct_ext_destroy);
 
-static void *
-nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
-{
-	unsigned int off, len, alloc;
-	struct nf_ct_ext_type *t;
-
-	rcu_read_lock();
-	t = rcu_dereference(nf_ct_ext_types[id]);
-	if (!t) {
-		rcu_read_unlock();
-		return NULL;
-	}
-
-	off = ALIGN(sizeof(struct nf_ct_ext), t->align);
-	len = off + t->len;
-	rcu_read_unlock();
-
-	alloc = max(len, NF_CT_EXT_PREALLOC);
-	*ext = kzalloc(alloc, gfp);
-	if (!*ext)
-		return NULL;
-
-	(*ext)->offset[id] = off;
-	(*ext)->len = len;
-
-	return (void *)(*ext) + off;
-}
-
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
+	unsigned int newlen, newoff, oldlen, alloc;
 	struct nf_ct_ext *old, *new;
-	int newlen, newoff;
 	struct nf_ct_ext_type *t;
 
 	/* Conntrack must not be confirmed to avoid races on reallocation. */
 	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
 
 	old = ct->ext;
-	if (!old)
-		return nf_ct_ext_create(&ct->ext, id, gfp);
 
-	if (__nf_ct_ext_exist(old, id))
-		return NULL;
+	if (old) {
+		if (__nf_ct_ext_exist(old, id))
+			return NULL;
+		oldlen = old->len;
+	} else {
+		oldlen = sizeof(*new);
+	}
 
 	rcu_read_lock();
 	t = rcu_dereference(nf_ct_ext_types[id]);
@@ -95,15 +70,19 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 		return NULL;
 	}
 
-	newoff = ALIGN(old->len, t->align);
+	newoff = ALIGN(oldlen, t->align);
 	newlen = newoff + t->len;
 	rcu_read_unlock();
 
-	new = __krealloc(old, newlen, gfp);
+	alloc = max(newlen, NF_CT_EXT_PREALLOC);
+	new = __krealloc(old, alloc, gfp);
 	if (!new)
 		return NULL;
 
-	if (new != old) {
+	if (!old) {
+		RCU_INIT_POINTER(ct->ext, new);
+		memset(new->offset, 0, sizeof(new->offset));
+	} else if (new != old) {
 		kfree_rcu(old, rcu);
 		rcu_assign_pointer(ct->ext, new);
 	}
-- 
2.10.2

