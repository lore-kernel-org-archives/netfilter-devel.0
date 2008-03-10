From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/09]: nf_conntrack: replace horrible hack with ksize()
Date: Mon, 10 Mar 2008 19:26:21 +0100 (MET)
Message-ID: <20080310182623.20404.30919.sendpatchset@localhost.localdomain>
References: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34270 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYCJS0W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:26:22 -0400
In-Reply-To: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: replace horrible hack with ksize()

There's a horrible slab abuse in net/netfilter/nf_conntrack_extend.c that
can be replaced with a call to ksize().

Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2bb076fe75d4f6542d7a769c6430a8332b776896
tree b1449912958a87758aceea5fe8581e38425a448d
parent 6cc9434319dd0ea32cc6e1969523a1a77043379c
author Pekka Enberg <penberg@cs.helsinki.fi> Mon, 10 Mar 2008 18:51:26 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 10 Mar 2008 18:51:26 +0100

 include/net/netfilter/nf_conntrack_extend.h |    1 -
 net/netfilter/nf_conntrack_extend.c         |   19 +++----------------
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 49aac63..f736e84 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -17,7 +17,6 @@ enum nf_ct_ext_id
 struct nf_ct_ext {
 	u8 offset[NF_CT_EXT_NUM];
 	u8 len;
-	u8 real_len;
 	char data[0];
 };
 
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 8b9be1e..2bd9963 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -19,14 +19,6 @@
 static struct nf_ct_ext_type *nf_ct_ext_types[NF_CT_EXT_NUM];
 static DEFINE_MUTEX(nf_ct_ext_type_mutex);
 
-/* Horrible trick to figure out smallest amount worth kmallocing. */
-#define CACHE(x) (x) + 0 *
-enum {
-	NF_CT_EXT_MIN_SIZE =
-#include <linux/kmalloc_sizes.h>
-	1 };
-#undef CACHE
-
 void __nf_ct_ext_destroy(struct nf_conn *ct)
 {
 	unsigned int i;
@@ -53,7 +45,7 @@ EXPORT_SYMBOL(__nf_ct_ext_destroy);
 static void *
 nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
 {
-	unsigned int off, len, real_len;
+	unsigned int off, len;
 	struct nf_ct_ext_type *t;
 
 	rcu_read_lock();
@@ -61,16 +53,14 @@ nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
 	BUG_ON(t == NULL);
 	off = ALIGN(sizeof(struct nf_ct_ext), t->align);
 	len = off + t->len;
-	real_len = t->alloc_size;
 	rcu_read_unlock();
 
-	*ext = kzalloc(real_len, gfp);
+	*ext = kzalloc(t->alloc_size, gfp);
 	if (!*ext)
 		return NULL;
 
 	(*ext)->offset[id] = off;
 	(*ext)->len = len;
-	(*ext)->real_len = real_len;
 
 	return (void *)(*ext) + off;
 }
@@ -95,7 +85,7 @@ void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	newlen = newoff + t->len;
 	rcu_read_unlock();
 
-	if (newlen >= ct->ext->real_len) {
+	if (newlen >= ksize(ct->ext)) {
 		new = kmalloc(newlen, gfp);
 		if (!new)
 			return NULL;
@@ -114,7 +104,6 @@ void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 			rcu_read_unlock();
 		}
 		kfree(ct->ext);
-		new->real_len = newlen;
 		ct->ext = new;
 	}
 
@@ -156,8 +145,6 @@ static void update_alloc_size(struct nf_ct_ext_type *type)
 			t1->alloc_size = ALIGN(t1->alloc_size, t2->align)
 					 + t2->len;
 		}
-		if (t1->alloc_size < NF_CT_EXT_MIN_SIZE)
-			t1->alloc_size = NF_CT_EXT_MIN_SIZE;
 	}
 }
 
