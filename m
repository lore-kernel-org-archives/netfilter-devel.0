From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 15/50]: nf_conntrack: introduce extension infrastructure
Date: Sat,  7 Jul 2007 14:23:22 +0200 (MEST)
Message-ID: <20070707122237.1589.45262.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: introduce extension infrastructure

Old space allocator of conntrack had problems about extensibility.
- It required slab cache per combination of extensions.
- It expected what extensions would be assigned, but it was impossible
  to expect that completely, then we allocated bigger memory object than
  really required.
- It needed to search helper twice due to lock issue.

Now basic informations of a connection are stored in 'struct nf_conn'.
And a storage for extension (helper, NAT) is allocated by kmalloc.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0baa5facd90815aacb6b1f7daaa92658b390b853
tree d97ed2789588bd6fb15fabe4cb0cb9fe7697dbd7
parent e9c14f81268617f64722e73f180eb8b79d928a06
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 07 Jul 2007 12:15:27 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:27 +0200

 include/net/netfilter/nf_conntrack.h        |    3 
 include/net/netfilter/nf_conntrack_extend.h |   80 +++++++++++
 net/netfilter/Makefile                      |    2 
 net/netfilter/nf_conntrack_core.c           |    4 +
 net/netfilter/nf_conntrack_extend.c         |  195 +++++++++++++++++++++++++++
 5 files changed, 283 insertions(+), 1 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 12a0e79..c31382d 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -131,6 +131,9 @@ struct nf_conn
 	/* Storage reserved for other modules: */
 	union nf_conntrack_proto proto;
 
+	/* Extensions */
+	struct nf_ct_ext *ext;
+
 	/* features dynamically at the end: helper, nat (both optional) */
 	char data[0];
 };
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
new file mode 100644
index 0000000..8a988d1
--- /dev/null
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -0,0 +1,80 @@
+#ifndef _NF_CONNTRACK_EXTEND_H
+#define _NF_CONNTRACK_EXTEND_H
+
+#include <net/netfilter/nf_conntrack.h>
+
+enum nf_ct_ext_id
+{
+	NF_CT_EXT_NUM,
+};
+
+/* Extensions: optional stuff which isn't permanently in struct. */
+struct nf_ct_ext {
+	u8 offset[NF_CT_EXT_NUM];
+	u8 len;
+	u8 real_len;
+	char data[0];
+};
+
+static inline int nf_ct_ext_exist(const struct nf_conn *ct, u8 id)
+{
+	return (ct->ext && ct->ext->offset[id]);
+}
+
+static inline void *__nf_ct_ext_find(const struct nf_conn *ct, u8 id)
+{
+	if (!nf_ct_ext_exist(ct, id))
+		return NULL;
+
+	return (void *)ct->ext + ct->ext->offset[id];
+}
+#define nf_ct_ext_find(ext, id)	\
+	((id##_TYPE *)__nf_ct_ext_find((ext), (id)))
+
+/* Destroy all relationships */
+extern void __nf_ct_ext_destroy(struct nf_conn *ct);
+static inline void nf_ct_ext_destroy(struct nf_conn *ct)
+{
+	if (ct->ext)
+		__nf_ct_ext_destroy(ct);
+}
+
+/* Free operation. If you want to free a object referred from private area,
+ * please implement __nf_ct_ext_free() and call it.
+ */
+static inline void nf_ct_ext_free(struct nf_conn *ct)
+{
+	if (ct->ext)
+		kfree(ct->ext);
+}
+
+/* Add this type, returns pointer to data or NULL. */
+void *
+__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp);
+#define nf_ct_ext_add(ct, id, gfp) \
+	((id##_TYPE *)__nf_ct_ext_add((ct), (id), (gfp)))
+
+#define NF_CT_EXT_F_PREALLOC	0x0001
+
+struct nf_ct_ext_type
+{
+	/* Destroys relationships (can be NULL). */
+	void (*destroy)(struct nf_conn *ct);
+	/* Called when realloacted (can be NULL).
+	   Contents has already been moved. */
+	void (*move)(struct nf_conn *ct, void *old);
+
+	enum nf_ct_ext_id id;
+
+	unsigned int flags;
+
+	/* Length and min alignment. */
+	u8 len;
+	u8 align;
+	/* initial size of nf_ct_ext. */
+	u8 alloc_size;
+};
+
+int nf_ct_extend_register(struct nf_ct_ext_type *type);
+void nf_ct_extend_unregister(struct nf_ct_ext_type *type);
+#endif /* _NF_CONNTRACK_EXTEND_H */
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 3b79268..58b4245 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -1,6 +1,6 @@
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o
 
-nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o
+nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7a15e30..b56f954 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -36,6 +36,7 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 
 #define NF_CONNTRACK_VERSION	"0.5.0"
 
@@ -317,6 +318,8 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	if (l4proto && l4proto->destroy)
 		l4proto->destroy(ct);
 
+	nf_ct_ext_destroy(ct);
+
 	destroyed = rcu_dereference(nf_conntrack_destroyed);
 	if (destroyed)
 		destroyed(ct);
@@ -650,6 +653,7 @@ void nf_conntrack_free(struct nf_conn *conntrack)
 {
 	u_int32_t features = conntrack->features;
 	NF_CT_ASSERT(features >= NF_CT_F_BASIC && features < NF_CT_F_NUM);
+	nf_ct_ext_free(conntrack);
 	DEBUGP("nf_conntrack_free: features = 0x%x, conntrack=%p\n", features,
 	       conntrack);
 	kmem_cache_free(nf_ct_cache[features].cachep, conntrack);
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
new file mode 100644
index 0000000..a1a65a1
--- /dev/null
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -0,0 +1,195 @@
+/* Structure dynamic extension infrastructure
+ * Copyright (C) 2004 Rusty Russell IBM Corporation
+ * Copyright (C) 2007 Netfilter Core Team <coreteam@netfilter.org>
+ * Copyright (C) 2007 USAGI/WIDE Project <http://www.linux-ipv6.org>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
+#include <linux/slab.h>
+#include <linux/skbuff.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+
+static struct nf_ct_ext_type *nf_ct_ext_types[NF_CT_EXT_NUM];
+static DEFINE_MUTEX(nf_ct_ext_type_mutex);
+
+/* Horrible trick to figure out smallest amount worth kmallocing. */
+#define CACHE(x) (x) + 0 *
+enum {
+	NF_CT_EXT_MIN_SIZE =
+#include <linux/kmalloc_sizes.h>
+	1 };
+#undef CACHE
+
+void __nf_ct_ext_destroy(struct nf_conn *ct)
+{
+	unsigned int i;
+	struct nf_ct_ext_type *t;
+
+	for (i = 0; i < NF_CT_EXT_NUM; i++) {
+		if (!nf_ct_ext_exist(ct, i))
+			continue;
+
+		rcu_read_lock();
+		t = rcu_dereference(nf_ct_ext_types[i]);
+
+		/* Here the nf_ct_ext_type might have been unregisterd.
+		 * I.e., it has responsible to cleanup private
+		 * area in all conntracks when it is unregisterd.
+		 */
+		if (t && t->destroy)
+			t->destroy(ct);
+		rcu_read_unlock();
+	}
+}
+EXPORT_SYMBOL(__nf_ct_ext_destroy);
+
+static void *
+nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
+{
+	unsigned int off, len, real_len;
+	struct nf_ct_ext_type *t;
+
+	rcu_read_lock();
+	t = rcu_dereference(nf_ct_ext_types[id]);
+	BUG_ON(t == NULL);
+	off = ALIGN(sizeof(struct nf_ct_ext), t->align);
+	len = off + t->len;
+	real_len = t->alloc_size;
+	rcu_read_unlock();
+
+	*ext = kzalloc(real_len, gfp);
+	if (!*ext)
+		return NULL;
+
+	(*ext)->offset[id] = off;
+	(*ext)->len = len;
+	(*ext)->real_len = real_len;
+
+	return (void *)(*ext) + off;
+}
+
+void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
+{
+	struct nf_ct_ext *new;
+	int i, newlen, newoff;
+	struct nf_ct_ext_type *t;
+
+	if (!ct->ext)
+		return nf_ct_ext_create(&ct->ext, id, gfp);
+
+	if (nf_ct_ext_exist(ct, id))
+		return NULL;
+
+	rcu_read_lock();
+	t = rcu_dereference(nf_ct_ext_types[id]);
+	BUG_ON(t == NULL);
+
+	newoff = ALIGN(ct->ext->len, t->align);
+	newlen = newoff + t->len;
+	rcu_read_unlock();
+
+	if (newlen >= ct->ext->real_len) {
+		new = kmalloc(newlen, gfp);
+		if (!new)
+			return NULL;
+
+		memcpy(new, ct->ext, ct->ext->len);
+
+		for (i = 0; i < NF_CT_EXT_NUM; i++) {
+			if (!nf_ct_ext_exist(ct, i))
+				continue;
+
+			rcu_read_lock();
+			t = rcu_dereference(nf_ct_ext_types[i]);
+			if (t && t->move)
+				t->move(ct, ct->ext + ct->ext->offset[id]);
+			rcu_read_unlock();
+		}
+		kfree(ct->ext);
+		new->real_len = newlen;
+		ct->ext = new;
+	}
+
+	ct->ext->offset[id] = newoff;
+	ct->ext->len = newlen;
+	memset((void *)ct->ext + newoff, 0, newlen - newoff);
+	return (void *)ct->ext + newoff;
+}
+EXPORT_SYMBOL(__nf_ct_ext_add);
+
+static void update_alloc_size(struct nf_ct_ext_type *type)
+{
+	int i, j;
+	struct nf_ct_ext_type *t1, *t2;
+	enum nf_ct_ext_id min = 0, max = NF_CT_EXT_NUM - 1;
+
+	/* unnecessary to update all types */
+	if ((type->flags & NF_CT_EXT_F_PREALLOC) == 0) {
+		min = type->id;
+		max = type->id;
+	}
+
+	/* This assumes that extended areas in conntrack for the types
+	   whose NF_CT_EXT_F_PREALLOC bit set are allocated in order */
+	for (i = min; i <= max; i++) {
+		t1 = nf_ct_ext_types[i];
+		if (!t1)
+			continue;
+
+		t1->alloc_size = sizeof(struct nf_ct_ext)
+				 + ALIGN(sizeof(struct nf_ct_ext), t1->align)
+				 + t1->len;
+		for (j = 0; j < NF_CT_EXT_NUM; j++) {
+			t2 = nf_ct_ext_types[j];
+			if (t2 == NULL || t2 == t1 ||
+			    (t2->flags & NF_CT_EXT_F_PREALLOC) == 0)
+				continue;
+
+			t1->alloc_size = ALIGN(t1->alloc_size, t2->align)
+					 + t2->len;
+		}
+		if (t1->alloc_size < NF_CT_EXT_MIN_SIZE)
+			t1->alloc_size = NF_CT_EXT_MIN_SIZE;
+	}
+}
+
+/* This MUST be called in process context. */
+int nf_ct_extend_register(struct nf_ct_ext_type *type)
+{
+	int ret = 0;
+
+	mutex_lock(&nf_ct_ext_type_mutex);
+	if (nf_ct_ext_types[type->id]) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	/* This ensures that nf_ct_ext_create() can allocate enough area
+	   before updating alloc_size */
+	type->alloc_size = ALIGN(sizeof(struct nf_ct_ext), type->align)
+			   + type->len;
+	rcu_assign_pointer(nf_ct_ext_types[type->id], type);
+	update_alloc_size(type);
+out:
+	mutex_unlock(&nf_ct_ext_type_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_ct_extend_register);
+
+/* This MUST be called in process context. */
+void nf_ct_extend_unregister(struct nf_ct_ext_type *type)
+{
+	mutex_lock(&nf_ct_ext_type_mutex);
+	rcu_assign_pointer(nf_ct_ext_types[type->id], NULL);
+	update_alloc_size(type);
+	mutex_unlock(&nf_ct_ext_type_mutex);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(nf_ct_extend_unregister);
