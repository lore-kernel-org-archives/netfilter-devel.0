From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: conntrack: remove prealloc support
Date: Wed, 19 Apr 2017 23:44:36 +0200
Message-ID: <20170419214438.20938-2-fw@strlen.de>
References: <20170419214438.20938-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45096 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1763577AbdDSVoX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 17:44:23 -0400
In-Reply-To: <20170419214438.20938-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It was used by the nat extension, but since commit 7c9664351980
("netfilter: move nat hlist_head to nf_conn") its only needed
for connections that use MASQUERADE target or a nat helper.

Also it seems a lot easier to preallocate a fixed size instead.

With default settings, conntrack first adds ecache extension (sysctl
defaults to 1), so we get 32(ct extension header) + 24 (ecache) == 56 byte
on x86_64 for initial allocation.

Followup patches can constify the extension structs and avoid
the initial zeroing of the entire extension area.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_extend.h |  6 ----
 net/netfilter/nf_conntrack_extend.c         | 49 +++--------------------------
 net/netfilter/nf_nat_core.c                 |  1 -
 3 files changed, 4 insertions(+), 52 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 5fc908dc9f32..dd776bf9e2fa 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -88,21 +88,15 @@ static inline void nf_ct_ext_free(struct nf_conn *ct)
 /* Add this type, returns pointer to data or NULL. */
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp);
 
-#define NF_CT_EXT_F_PREALLOC	0x0001
-
 struct nf_ct_ext_type {
 	/* Destroys relationships (can be NULL). */
 	void (*destroy)(struct nf_conn *ct);
 
 	enum nf_ct_ext_id id;
 
-	unsigned int flags;
-
 	/* Length and min alignment. */
 	u8 len;
 	u8 align;
-	/* initial size of nf_ct_ext. */
-	u8 alloc_size;
 };
 
 int nf_ct_extend_register(struct nf_ct_ext_type *type);
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index b5879a9c748d..2e4b41bc67a0 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -18,6 +18,7 @@
 
 static struct nf_ct_ext_type __rcu *nf_ct_ext_types[NF_CT_EXT_NUM];
 static DEFINE_MUTEX(nf_ct_ext_type_mutex);
+#define NF_CT_EXT_PREALLOC	128u /* conntrack events are on by default */
 
 void __nf_ct_ext_destroy(struct nf_conn *ct)
 {
@@ -46,9 +47,8 @@ EXPORT_SYMBOL(__nf_ct_ext_destroy);
 static void *
 nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
 {
-	unsigned int off, len;
+	unsigned int off, len, alloc;
 	struct nf_ct_ext_type *t;
-	size_t alloc_size;
 
 	rcu_read_lock();
 	t = rcu_dereference(nf_ct_ext_types[id]);
@@ -59,10 +59,10 @@ nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
 
 	off = ALIGN(sizeof(struct nf_ct_ext), t->align);
 	len = off + t->len;
-	alloc_size = t->alloc_size;
 	rcu_read_unlock();
 
-	*ext = kzalloc(alloc_size, gfp);
+	alloc = max(len, NF_CT_EXT_PREALLOC);
+	*ext = kzalloc(alloc, gfp);
 	if (!*ext)
 		return NULL;
 
@@ -115,41 +115,6 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 }
 EXPORT_SYMBOL(nf_ct_ext_add);
 
-static void update_alloc_size(struct nf_ct_ext_type *type)
-{
-	int i, j;
-	struct nf_ct_ext_type *t1, *t2;
-	enum nf_ct_ext_id min = 0, max = NF_CT_EXT_NUM - 1;
-
-	/* unnecessary to update all types */
-	if ((type->flags & NF_CT_EXT_F_PREALLOC) == 0) {
-		min = type->id;
-		max = type->id;
-	}
-
-	/* This assumes that extended areas in conntrack for the types
-	   whose NF_CT_EXT_F_PREALLOC bit set are allocated in order */
-	for (i = min; i <= max; i++) {
-		t1 = rcu_dereference_protected(nf_ct_ext_types[i],
-				lockdep_is_held(&nf_ct_ext_type_mutex));
-		if (!t1)
-			continue;
-
-		t1->alloc_size = ALIGN(sizeof(struct nf_ct_ext), t1->align) +
-				 t1->len;
-		for (j = 0; j < NF_CT_EXT_NUM; j++) {
-			t2 = rcu_dereference_protected(nf_ct_ext_types[j],
-				lockdep_is_held(&nf_ct_ext_type_mutex));
-			if (t2 == NULL || t2 == t1 ||
-			    (t2->flags & NF_CT_EXT_F_PREALLOC) == 0)
-				continue;
-
-			t1->alloc_size = ALIGN(t1->alloc_size, t2->align)
-					 + t2->len;
-		}
-	}
-}
-
 /* This MUST be called in process context. */
 int nf_ct_extend_register(struct nf_ct_ext_type *type)
 {
@@ -161,12 +126,7 @@ int nf_ct_extend_register(struct nf_ct_ext_type *type)
 		goto out;
 	}
 
-	/* This ensures that nf_ct_ext_create() can allocate enough area
-	   before updating alloc_size */
-	type->alloc_size = ALIGN(sizeof(struct nf_ct_ext), type->align)
-			   + type->len;
 	rcu_assign_pointer(nf_ct_ext_types[type->id], type);
-	update_alloc_size(type);
 out:
 	mutex_unlock(&nf_ct_ext_type_mutex);
 	return ret;
@@ -178,7 +138,6 @@ void nf_ct_extend_unregister(struct nf_ct_ext_type *type)
 {
 	mutex_lock(&nf_ct_ext_type_mutex);
 	RCU_INIT_POINTER(nf_ct_ext_types[type->id], NULL);
-	update_alloc_size(type);
 	mutex_unlock(&nf_ct_ext_type_mutex);
 	synchronize_rcu();
 }
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 9cbf49f9c1b7..86eeacbb4793 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -717,7 +717,6 @@ static struct nf_ct_ext_type nat_extend __read_mostly = {
 	.align		= __alignof__(struct nf_conn_nat),
 	.destroy	= nf_nat_cleanup_conntrack,
 	.id		= NF_CT_EXT_NAT,
-	.flags		= NF_CT_EXT_F_PREALLOC,
 };
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-- 
2.10.2

