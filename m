From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/7]: nf_conntrack: Introduces a extension infrastructure
Date: Mon, 07 May 2007 21:00:50 +0900 (JST)
Message-ID: <200705071200.l47C0p6J016120@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, kaber@trash.net, pablo@netfilter.org,
	kadlec@blackhole.kfki.hu
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


Old space allocator of conntrack had problems about extensibility.
- It required slab cache per combination of extensions.
- It expected what extensions would be assigned, but it was impossible
  to expect that completely, then we allocated bigger memory object than
  really required.
- It needed to search helper twice due to lock issue.

Now basic informations of a connection are stored in 'struct nf_conn'.
And a storage for extension (helper, NAT) is allocated by kmalloc.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/net/netfilter/nf_conntrack.h        |    4 +
 include/net/netfilter/nf_conntrack_extend.h |   72 +++++++++++++
 net/netfilter/Makefile                      |    2 +-
 net/netfilter/nf_conntrack_core.c           |    4 +
 net/netfilter/nf_conntrack_extend.c         |  148 +++++++++++++++++++++++++++
 5 files changed, 229 insertions(+), 1 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 4732432..fdab317 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -22,6 +22,7 @@
 #include <linux/netfilter/nf_conntrack_tcp.h>
 #include <linux/netfilter/nf_conntrack_sctp.h>
 #include <linux/netfilter/nf_conntrack_proto_gre.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/ipv4/nf_conntrack_icmp.h>
 #include <net/netfilter/ipv6/nf_conntrack_icmpv6.h>
 
@@ -131,6 +132,9 @@ struct nf_conn
 	/* Storage reserved for other modules: */
 	union nf_conntrack_proto proto;
 
+	/* Extensions */
+	struct ct_extend *ext;
+
 	/* features dynamically at the end: helper, nat (both optional) */
 	char data[0];
 };
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
new file mode 100644
index 0000000..1bfc87c
--- /dev/null
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -0,0 +1,72 @@
+#ifndef _NF_CONNTRACK_EXTEND_H
+#define _NF_CONNTRACK_EXTEND_H
+
+enum ct_ext_type
+{
+	CTE_HELPER,
+	CTE_MAX,
+} __attribute__((packed));
+
+#define CTE_HELPER_TYPE struct nf_conn_help
+
+/* Extensions: optional stuff which isn't permanently in struct. */
+struct ct_extend {
+	u8 offset[CTE_MAX];
+	u8 len;
+	char data[0];
+};
+
+static inline int cte_exist(const struct ct_extend *ext, u8 type)
+{
+	return (ext->offset[type] != 0);
+}
+
+static inline void *__ct_extend_find(const struct ct_extend *ext, u8 type)
+{
+	if (ext == NULL || !cte_exist(ext, type))
+		return NULL;
+
+	return (void *)ext + ext->offset[type];
+}
+#define ct_extend_find(ext, type) ((type##_TYPE *)__ct_extend_find(ext, type))
+
+/* Destroy all relationships */
+extern void __ct_extend_destroy(struct ct_extend *ext);
+static inline void ct_extend_destroy(struct ct_extend *ext)
+{
+	if (ext)
+		__ct_extend_destroy(ext);
+}
+
+/* Free operation. If you want to free a object referred from private area,
+ * please implement __ct_extend_free() and call it.
+ */
+static inline void ct_extend_free(struct ct_extend *ext)
+{
+	if (ext)
+		kfree(ext);
+}
+
+/* Add this type, returns pointer to data or NULL. */
+void *__ct_extend_add(struct ct_extend **ext, enum ct_ext_type type, int gfp);
+#define ct_extend_add(ext, type, gfp) \
+	((type##_TYPE *)__ct_extend_add(ext, type, gfp))
+
+struct ct_extend_type
+{
+	/* Length and min alignment. */
+	u8 len;
+	u8 align;
+
+	/* Destroys relationships (can be NULL). */
+	void (*destroy)(struct ct_extend *ext);
+	/* Called when realloacted (can be NULL).
+	   Contents has already been moved. */
+	void (*move)(struct ct_extend *new, struct ct_extend *old);
+
+	enum ct_ext_type type;
+};
+
+int ct_extend_type_register(struct ct_extend_type *);
+void ct_extend_type_unregister(struct ct_extend_type *);
+#endif /* _NF_CONNTRACK_EXTEND_H */
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index b2b5c75..17b1d2c 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -1,6 +1,6 @@
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o
 
-nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o
+nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e8b5c2d..919ef2c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -36,6 +36,7 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 
 #define NF_CONNTRACK_VERSION	"0.5.0"
 
@@ -321,6 +322,8 @@ destroy_conntrack(struct nf_conntrack *n
 	if (l4proto && l4proto->destroy)
 		l4proto->destroy(ct);
 
+	ct_extend_destroy(ct->ext);
+
 	destroyed = rcu_dereference(nf_conntrack_destroyed);
 	if (destroyed)
 		destroyed(ct);
@@ -644,6 +647,7 @@ void nf_conntrack_free(struct nf_conn *c
 {
 	u_int32_t features = conntrack->features;
 	NF_CT_ASSERT(features >= NF_CT_F_BASIC && features < NF_CT_F_NUM);
+	ct_extend_free(conntrack->ext);
 	DEBUGP("nf_conntrack_free: features = 0x%x, conntrack=%p\n", features,
 	       conntrack);
 	kmem_cache_free(nf_ct_cache[features].cachep, conntrack);
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
new file mode 100644
index 0000000..209cd7a
--- /dev/null
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -0,0 +1,148 @@
+/* Structure dynamic extension infrastructure
+ * Copyright (C) 2004 Rusty Russell IBM Corporation
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
+#include <net/netfilter/nf_conntrack_extend.h>
+
+static struct ct_extend_type *cte_types[CTE_MAX];
+static DEFINE_MUTEX(cte_type_mutex);
+
+/* Horrible trick to figure out smallest amount worth kmallocing. */
+#define CACHE(x) (x) + 0 *
+enum {
+	CT_EXTEND_MIN_SIZE =
+#include <linux/kmalloc_sizes.h>
+	1 };
+#undef CACHE
+
+void __ct_extend_destroy(struct ct_extend *ext)
+{
+	unsigned int i;
+	struct ct_extend_type *t;
+
+	for (i = 0; i < CTE_MAX; i++) {
+		if (!cte_exist(ext, i))
+			continue;
+
+		rcu_read_lock();
+		t = rcu_dereference(cte_types[i]);
+
+		/* Here the ct_extend_type might have been unregisterd.
+		 * I.e., it has responsible to cleanup private
+		 * area in all conntracks when it is unregisterd.
+		 */
+		if (t && t->destroy)
+			t->destroy(ext);
+		rcu_read_unlock();
+	}
+}
+EXPORT_SYMBOL(__ct_extend_destroy);
+
+static void *cte_create(struct ct_extend **ext, enum ct_ext_type type, int gfp)
+{
+	unsigned int off, len;
+	struct ct_extend_type *t;
+
+	rcu_read_lock();
+	t = rcu_dereference(cte_types[type]);
+	BUG_ON(t == NULL);
+	off = ALIGN(sizeof(struct ct_extend), t->align);
+	len = off + t->len;
+	rcu_read_unlock();
+
+	*ext = kmalloc(max_t(unsigned int, CT_EXTEND_MIN_SIZE, len), gfp);
+	if (!*ext)
+		return NULL;
+
+	memset(*ext, 0, len);
+
+	(*ext)->offset[type] = off;
+	/* not real allocated size, but required size */
+	(*ext)->len = len;
+
+	return (void *)(*ext) + off;
+}
+
+void *__ct_extend_add(struct ct_extend **ext, enum ct_ext_type type, int gfp)
+{
+	struct ct_extend *new;
+	int i, newlen, newoff;
+	struct ct_extend_type *t;
+
+	if (!*ext)
+		return cte_create(ext, type, gfp);
+
+	if (cte_exist((*ext), type))
+		return NULL;
+
+	rcu_read_lock();
+	t = rcu_dereference(cte_types[type]);
+	BUG_ON(t == NULL);
+
+	newoff = ALIGN((*ext)->len, t->align);
+	newlen = newoff + t->len;
+	rcu_read_unlock();
+
+	if (newlen >= CT_EXTEND_MIN_SIZE) {
+		new = kmalloc(newlen, gfp);
+		if (!new)
+			return NULL;
+
+		memcpy(new, (*ext), (*ext)->len);
+
+		for (i = 0; i < CTE_MAX; i++) {
+			if (!cte_exist((*ext), i))
+				continue;
+
+			rcu_read_lock();
+			t = rcu_dereference(cte_types[i]);
+			if (t && t->move)
+				t->move(new, *ext);
+			rcu_read_unlock();
+		}
+		kfree(*ext);
+		*ext = new;
+	}
+
+	(*ext)->offset[type] = newoff;
+	(*ext)->len = newlen;
+	memset((void *)(*ext) + newoff, 0, newlen - newoff);
+	return (void *)(*ext) + newoff;
+}
+EXPORT_SYMBOL(__ct_extend_add);
+
+/* This MUST be called in process context. */
+int ct_extend_type_register(struct ct_extend_type *ext)
+{
+	int ret = 0;
+
+	mutex_lock(&cte_type_mutex);
+	if (cte_types[ext->type]) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	rcu_assign_pointer(cte_types[ext->type], ext);
+out:
+	mutex_unlock(&cte_type_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ct_extend_type_register);
+
+/* This MUST be called in process context. */
+void ct_extend_type_unregister(struct ct_extend_type *ext)
+{
+	mutex_lock(&cte_type_mutex);
+	rcu_assign_pointer(cte_types[ext->type], NULL);
+	mutex_unlock(&cte_type_mutex);
+}
+EXPORT_SYMBOL_GPL(ct_extend_type_unregister);
-- 
1.4.4
