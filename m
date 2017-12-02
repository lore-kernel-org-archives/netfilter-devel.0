From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2] netfilter: connlimit: split xt_connlimit into front/backend
Date: Sat,  2 Dec 2017 10:49:14 +0100
Message-ID: <20171202094914.11364-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44954 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751555AbdLBJtp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Dec 2017 04:49:45 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows to reuse xt_connlimit infrastructure from nf_tables.

The upcoming nf_tables frontend can just pass in an nftables register
as input key, this allows limiting by arbitrary keys via concatenations.

For xt_connlimit, pass in the zone and the ip/ipv6 address as key
to keep same behaviour.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 V2: add missing EXPORT_SYMBOL annotations

 include/net/netfilter/nf_conntrack_count.h  |  13 +
 include/uapi/linux/netfilter/xt_connlimit.h |   2 +-
 net/netfilter/Kconfig                       |   3 +
 net/netfilter/Makefile                      |   2 +
 net/netfilter/nf_conncount.c                | 371 ++++++++++++++++++++++++++++
 net/netfilter/xt_connlimit.c                | 367 ++-------------------------
 6 files changed, 414 insertions(+), 344 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_count.h
 create mode 100644 net/netfilter/nf_conncount.c

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
new file mode 100644
index 000000000000..eafaabb9e2f9
--- /dev/null
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -0,0 +1,13 @@
+struct nf_conncount_data;
+
+struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family,
+					    unsigned int keylen);
+void nf_conncount_destroy(struct net *net, unsigned int family,
+			  struct nf_conncount_data *data);
+
+unsigned int nf_conncount_count(struct net *net,
+				struct nf_conncount_data *data,
+				const u32 *key,
+				unsigned int family,
+				const struct nf_conntrack_tuple *tuple,
+				const struct nf_conntrack_zone *zone);
diff --git a/include/uapi/linux/netfilter/xt_connlimit.h b/include/uapi/linux/netfilter/xt_connlimit.h
index 07e5e9d47882..d4d1943dcd11 100644
--- a/include/uapi/linux/netfilter/xt_connlimit.h
+++ b/include/uapi/linux/netfilter/xt_connlimit.h
@@ -27,7 +27,7 @@ struct xt_connlimit_info {
 	__u32 flags;
 
 	/* Used internally by the kernel */
-	struct xt_connlimit_data *data __attribute__((aligned(8)));
+	struct nf_conncount_data *data __attribute__((aligned(8)));
 };
 
 #endif /* _XT_CONNLIMIT_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index e4a13cc8a2e7..8a043b85fc07 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -62,6 +62,8 @@ config NF_LOG_NETDEV
 	select NF_LOG_COMMON
 
 if NF_CONNTRACK
+config NETFILTER_CONNCOUNT
+	tristate
 
 config NF_CONNTRACK_MARK
 	bool  'Connection mark tracking support'
@@ -1120,6 +1122,7 @@ config NETFILTER_XT_MATCH_CONNLIMIT
 	tristate '"connlimit" match support'
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_CONNCOUNT
 	---help---
 	  This match allows you to match against the number of parallel
 	  connections to a server per client IP address (or address block).
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index f78ed2470831..490a55e7166d 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -67,6 +67,8 @@ obj-$(CONFIG_NF_NAT_TFTP) += nf_nat_tftp.o
 # SYNPROXY
 obj-$(CONFIG_NETFILTER_SYNPROXY) += nf_synproxy_core.o
 
+obj-$(CONFIG_NETFILTER_CONNCOUNT) += nf_conncount.o
+
 # generic packet duplication from netdev family
 obj-$(CONFIG_NF_DUP_NETDEV)	+= nf_dup_netdev.o
 
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
new file mode 100644
index 000000000000..a2d853ebe5ef
--- /dev/null
+++ b/net/netfilter/nf_conncount.c
@@ -0,0 +1,371 @@
+/*
+ * count the number of connections matching an arbitrary key.
+ *
+ * (C) 2017 Red Hat GmbH
+ * Author: Florian Westphal <fw@strlen.de>
+ *
+ * split from xt_connlimit.c:
+ *   (c) 2000 Gerd Knorr <kraxel@bytesex.org>
+ *   Nov 2002: Martin Bene <martin.bene@icomedias.com>:
+ *		only ignore TIME_WAIT or gone connections
+ *   (C) CC Computer Consultants GmbH, 2007
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/jhash.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/rbtree.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/netfilter/nf_conntrack_tcp.h>
+#include <linux/netfilter/x_tables.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_count.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/netfilter/nf_conntrack_zones.h>
+
+#define CONNCOUNT_SLOTS		256U
+
+#ifdef CONFIG_LOCKDEP
+#define CONNCOUNT_LOCK_SLOTS	8U
+#else
+#define CONNCOUNT_LOCK_SLOTS	256U
+#endif
+
+#define CONNCOUNT_GC_MAX_NODES	8
+#define MAX_KEYLEN		5
+
+/* we will save the tuples of all connections we care about */
+struct nf_conncount_tuple {
+	struct hlist_node		node;
+	struct nf_conntrack_tuple	tuple;
+};
+
+struct nf_conncount_rb {
+	struct rb_node node;
+	struct hlist_head hhead; /* connections/hosts in same subnet */
+	u32 key[MAX_KEYLEN];
+};
+
+static spinlock_t nf_conncount_locks[CONNCOUNT_LOCK_SLOTS] __cacheline_aligned_in_smp;
+
+struct nf_conncount_data {
+	unsigned int keylen;
+	struct rb_root root[CONNCOUNT_SLOTS];
+};
+
+static u_int32_t conncount_rnd __read_mostly;
+static struct kmem_cache *conncount_rb_cachep __read_mostly;
+static struct kmem_cache *conncount_conn_cachep __read_mostly;
+
+static inline bool already_closed(const struct nf_conn *conn)
+{
+	if (nf_ct_protonum(conn) == IPPROTO_TCP)
+		return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT ||
+		       conn->proto.tcp.state == TCP_CONNTRACK_CLOSE;
+	else
+		return 0;
+}
+
+static int key_diff(const u32 *a, const u32 *b, unsigned int klen)
+{
+	return memcmp(a, b, klen * sizeof(u32));
+}
+
+static bool add_hlist(struct hlist_head *head,
+		      const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conncount_tuple *conn;
+
+	conn = kmem_cache_alloc(conncount_conn_cachep, GFP_ATOMIC);
+	if (conn == NULL)
+		return false;
+	conn->tuple = *tuple;
+	hlist_add_head(&conn->node, head);
+	return true;
+}
+
+static unsigned int check_hlist(struct net *net,
+				struct hlist_head *head,
+				const struct nf_conntrack_tuple *tuple,
+				const struct nf_conntrack_zone *zone,
+				bool *addit)
+{
+	const struct nf_conntrack_tuple_hash *found;
+	struct nf_conncount_tuple *conn;
+	struct hlist_node *n;
+	struct nf_conn *found_ct;
+	unsigned int length = 0;
+
+	*addit = true;
+
+	/* check the saved connections */
+	hlist_for_each_entry_safe(conn, n, head, node) {
+		found = nf_conntrack_find_get(net, zone, &conn->tuple);
+		if (found == NULL) {
+			hlist_del(&conn->node);
+			kmem_cache_free(conncount_conn_cachep, conn);
+			continue;
+		}
+
+		found_ct = nf_ct_tuplehash_to_ctrack(found);
+
+		if (nf_ct_tuple_equal(&conn->tuple, tuple)) {
+			/*
+			 * Just to be sure we have it only once in the list.
+			 * We should not see tuples twice unless someone hooks
+			 * this into a table without "-p tcp --syn".
+			 */
+			*addit = false;
+		} else if (already_closed(found_ct)) {
+			/*
+			 * we do not care about connections which are
+			 * closed already -> ditch it
+			 */
+			nf_ct_put(found_ct);
+			hlist_del(&conn->node);
+			kmem_cache_free(conncount_conn_cachep, conn);
+			continue;
+		}
+
+		nf_ct_put(found_ct);
+		length++;
+	}
+
+	return length;
+}
+
+static void tree_nodes_free(struct rb_root *root,
+			    struct nf_conncount_rb *gc_nodes[],
+			    unsigned int gc_count)
+{
+	struct nf_conncount_rb *rbconn;
+
+	while (gc_count) {
+		rbconn = gc_nodes[--gc_count];
+		rb_erase(&rbconn->node, root);
+		kmem_cache_free(conncount_rb_cachep, rbconn);
+	}
+}
+
+static unsigned int
+count_tree(struct net *net, struct rb_root *root,
+	   const u32 *key, u8 keylen,
+	   u8 family,
+	   const struct nf_conntrack_tuple *tuple,
+	   const struct nf_conntrack_zone *zone)
+{
+	struct nf_conncount_rb *gc_nodes[CONNCOUNT_GC_MAX_NODES];
+	struct rb_node **rbnode, *parent;
+	struct nf_conncount_rb *rbconn;
+	struct nf_conncount_tuple *conn;
+	unsigned int gc_count;
+	bool no_gc = false;
+
+ restart:
+	gc_count = 0;
+	parent = NULL;
+	rbnode = &(root->rb_node);
+	while (*rbnode) {
+		int diff;
+		bool addit;
+
+		rbconn = rb_entry(*rbnode, struct nf_conncount_rb, node);
+
+		parent = *rbnode;
+		diff = key_diff(key, rbconn->key, keylen);
+		if (diff < 0) {
+			rbnode = &((*rbnode)->rb_left);
+		} else if (diff > 0) {
+			rbnode = &((*rbnode)->rb_right);
+		} else {
+			/* same source network -> be counted! */
+			unsigned int count;
+			count = check_hlist(net, &rbconn->hhead, tuple, zone, &addit);
+
+			tree_nodes_free(root, gc_nodes, gc_count);
+			if (!addit)
+				return count;
+
+			if (!add_hlist(&rbconn->hhead, tuple))
+				return 0; /* hotdrop */
+
+			return count + 1;
+		}
+
+		if (no_gc || gc_count >= ARRAY_SIZE(gc_nodes))
+			continue;
+
+		/* only used for GC on hhead, retval and 'addit' ignored */
+		check_hlist(net, &rbconn->hhead, tuple, zone, &addit);
+		if (hlist_empty(&rbconn->hhead))
+			gc_nodes[gc_count++] = rbconn;
+	}
+
+	if (gc_count) {
+		no_gc = true;
+		tree_nodes_free(root, gc_nodes, gc_count);
+		/* tree_node_free before new allocation permits
+		 * allocator to re-use newly free'd object.
+		 *
+		 * This is a rare event; in most cases we will find
+		 * existing node to re-use. (or gc_count is 0).
+		 */
+		goto restart;
+	}
+
+	/* no match, need to insert new node */
+	rbconn = kmem_cache_alloc(conncount_rb_cachep, GFP_ATOMIC);
+	if (rbconn == NULL)
+		return 0;
+
+	conn = kmem_cache_alloc(conncount_conn_cachep, GFP_ATOMIC);
+	if (conn == NULL) {
+		kmem_cache_free(conncount_rb_cachep, rbconn);
+		return 0;
+	}
+
+	conn->tuple = *tuple;
+	memcpy(rbconn->key, key, sizeof(u32) * keylen);
+
+	INIT_HLIST_HEAD(&rbconn->hhead);
+	hlist_add_head(&conn->node, &rbconn->hhead);
+
+	rb_link_node(&rbconn->node, parent, rbnode);
+	rb_insert_color(&rbconn->node, root);
+	return 1;
+}
+
+unsigned int nf_conncount_count(struct net *net,
+				struct nf_conncount_data *data,
+				const u32 *key,
+				unsigned int family,
+				const struct nf_conntrack_tuple *tuple,
+				const struct nf_conntrack_zone *zone)
+{
+	struct rb_root *root;
+	int count;
+	u32 hash;
+
+	hash = jhash2(key, data->keylen, conncount_rnd) % CONNCOUNT_SLOTS;
+	root = &data->root[hash];
+
+	spin_lock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
+
+	count = count_tree(net, root, key, data->keylen, family, tuple, zone);
+
+	spin_unlock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(nf_conncount_count);
+
+struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family,
+					    unsigned int keylen)
+{
+	struct nf_conncount_data *data;
+	int ret, i;
+
+	if (keylen % sizeof(u32) ||
+	    keylen / sizeof(u32) > MAX_KEYLEN ||
+	    keylen == 0)
+		return ERR_PTR(-EINVAL);
+
+	net_get_random_once(&conncount_rnd, sizeof(conncount_rnd));
+
+	ret = nf_ct_netns_get(net, family);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < ARRAY_SIZE(data->root); ++i)
+		data->root[i] = RB_ROOT;
+
+	data->keylen = keylen / sizeof(u32);
+
+	return data;
+}
+EXPORT_SYMBOL_GPL(nf_conncount_init);
+
+static void destroy_tree(struct rb_root *r)
+{
+	struct nf_conncount_tuple *conn;
+	struct nf_conncount_rb *rbconn;
+	struct hlist_node *n;
+	struct rb_node *node;
+
+	while ((node = rb_first(r)) != NULL) {
+		rbconn = rb_entry(node, struct nf_conncount_rb, node);
+
+		rb_erase(node, r);
+
+		hlist_for_each_entry_safe(conn, n, &rbconn->hhead, node)
+			kmem_cache_free(conncount_conn_cachep, conn);
+
+		kmem_cache_free(conncount_rb_cachep, rbconn);
+	}
+}
+
+void nf_conncount_destroy(struct net *net, unsigned int family,
+			  struct nf_conncount_data *data)
+{
+	unsigned int i;
+
+	nf_ct_netns_put(net, family);
+
+	for (i = 0; i < ARRAY_SIZE(data->root); ++i)
+		destroy_tree(&data->root[i]);
+
+	kfree(data);
+}
+EXPORT_SYMBOL_GPL(nf_conncount_destroy);
+
+static int __init nf_conncount_modinit(void)
+{
+	int ret, i;
+
+	BUILD_BUG_ON(CONNCOUNT_LOCK_SLOTS > CONNCOUNT_SLOTS);
+	BUILD_BUG_ON((CONNCOUNT_SLOTS % CONNCOUNT_LOCK_SLOTS) != 0);
+
+	for (i = 0; i < CONNCOUNT_LOCK_SLOTS; ++i)
+		spin_lock_init(&nf_conncount_locks[i]);
+
+	conncount_conn_cachep = kmem_cache_create("nf_conncount_tuple",
+					   sizeof(struct nf_conncount_tuple),
+					   0, 0, NULL);
+	if (!conncount_conn_cachep)
+		return -ENOMEM;
+
+	conncount_rb_cachep = kmem_cache_create("nf_conncount_rb",
+					   sizeof(struct nf_conncount_rb),
+					   0, 0, NULL);
+	if (!conncount_rb_cachep) {
+		kmem_cache_destroy(conncount_conn_cachep);
+		return -ENOMEM;
+	}
+
+	return ret;
+}
+
+static void __exit nf_conncount_modexit(void)
+{
+	kmem_cache_destroy(conncount_conn_cachep);
+	kmem_cache_destroy(conncount_rb_cachep);
+}
+
+module_init(nf_conncount_modinit);
+module_exit(nf_conncount_modexit);
+MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
+MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
+MODULE_DESCRIPTION("netfilter: count number of connections matching a key");
+MODULE_LICENSE("GPL");
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index a6214f235333..d69e2f41aaa6 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -12,292 +12,30 @@
  * GPL (C) 1999  Rusty Russell (rusty@rustcorp.com.au).
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#include <linux/in.h>
-#include <linux/in6.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <linux/jhash.h>
-#include <linux/slab.h>
-#include <linux/list.h>
-#include <linux/rbtree.h>
+
 #include <linux/module.h>
-#include <linux/random.h>
 #include <linux/skbuff.h>
-#include <linux/spinlock.h>
-#include <linux/netfilter/nf_conntrack_tcp.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_connlimit.h>
+
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_zones.h>
-
-#define CONNLIMIT_SLOTS		256U
-
-#ifdef CONFIG_LOCKDEP
-#define CONNLIMIT_LOCK_SLOTS	8U
-#else
-#define CONNLIMIT_LOCK_SLOTS	256U
-#endif
-
-#define CONNLIMIT_GC_MAX_NODES	8
-
-/* we will save the tuples of all connections we care about */
-struct xt_connlimit_conn {
-	struct hlist_node		node;
-	struct nf_conntrack_tuple	tuple;
-};
-
-struct xt_connlimit_rb {
-	struct rb_node node;
-	struct hlist_head hhead; /* connections/hosts in same subnet */
-	union nf_inet_addr addr; /* search key */
-};
-
-static spinlock_t xt_connlimit_locks[CONNLIMIT_LOCK_SLOTS] __cacheline_aligned_in_smp;
-
-struct xt_connlimit_data {
-	struct rb_root climit_root[CONNLIMIT_SLOTS];
-};
-
-static u_int32_t connlimit_rnd __read_mostly;
-static struct kmem_cache *connlimit_rb_cachep __read_mostly;
-static struct kmem_cache *connlimit_conn_cachep __read_mostly;
-
-static inline unsigned int connlimit_iphash(__be32 addr)
-{
-	return jhash_1word((__force __u32)addr,
-			    connlimit_rnd) % CONNLIMIT_SLOTS;
-}
-
-static inline unsigned int
-connlimit_iphash6(const union nf_inet_addr *addr)
-{
-	return jhash2((u32 *)addr->ip6, ARRAY_SIZE(addr->ip6),
-		       connlimit_rnd) % CONNLIMIT_SLOTS;
-}
-
-static inline bool already_closed(const struct nf_conn *conn)
-{
-	if (nf_ct_protonum(conn) == IPPROTO_TCP)
-		return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT ||
-		       conn->proto.tcp.state == TCP_CONNTRACK_CLOSE;
-	else
-		return 0;
-}
-
-static int
-same_source(const union nf_inet_addr *addr,
-	    const union nf_inet_addr *u3, u_int8_t family)
-{
-	if (family == NFPROTO_IPV4)
-		return ntohl(addr->ip) - ntohl(u3->ip);
-
-	return memcmp(addr->ip6, u3->ip6, sizeof(addr->ip6));
-}
-
-static bool add_hlist(struct hlist_head *head,
-		      const struct nf_conntrack_tuple *tuple,
-		      const union nf_inet_addr *addr)
-{
-	struct xt_connlimit_conn *conn;
-
-	conn = kmem_cache_alloc(connlimit_conn_cachep, GFP_ATOMIC);
-	if (conn == NULL)
-		return false;
-	conn->tuple = *tuple;
-	hlist_add_head(&conn->node, head);
-	return true;
-}
-
-static unsigned int check_hlist(struct net *net,
-				struct hlist_head *head,
-				const struct nf_conntrack_tuple *tuple,
-				const struct nf_conntrack_zone *zone,
-				bool *addit)
-{
-	const struct nf_conntrack_tuple_hash *found;
-	struct xt_connlimit_conn *conn;
-	struct hlist_node *n;
-	struct nf_conn *found_ct;
-	unsigned int length = 0;
-
-	*addit = true;
-
-	/* check the saved connections */
-	hlist_for_each_entry_safe(conn, n, head, node) {
-		found = nf_conntrack_find_get(net, zone, &conn->tuple);
-		if (found == NULL) {
-			hlist_del(&conn->node);
-			kmem_cache_free(connlimit_conn_cachep, conn);
-			continue;
-		}
-
-		found_ct = nf_ct_tuplehash_to_ctrack(found);
-
-		if (nf_ct_tuple_equal(&conn->tuple, tuple)) {
-			/*
-			 * Just to be sure we have it only once in the list.
-			 * We should not see tuples twice unless someone hooks
-			 * this into a table without "-p tcp --syn".
-			 */
-			*addit = false;
-		} else if (already_closed(found_ct)) {
-			/*
-			 * we do not care about connections which are
-			 * closed already -> ditch it
-			 */
-			nf_ct_put(found_ct);
-			hlist_del(&conn->node);
-			kmem_cache_free(connlimit_conn_cachep, conn);
-			continue;
-		}
-
-		nf_ct_put(found_ct);
-		length++;
-	}
-
-	return length;
-}
-
-static void tree_nodes_free(struct rb_root *root,
-			    struct xt_connlimit_rb *gc_nodes[],
-			    unsigned int gc_count)
-{
-	struct xt_connlimit_rb *rbconn;
-
-	while (gc_count) {
-		rbconn = gc_nodes[--gc_count];
-		rb_erase(&rbconn->node, root);
-		kmem_cache_free(connlimit_rb_cachep, rbconn);
-	}
-}
-
-static unsigned int
-count_tree(struct net *net, struct rb_root *root,
-	   const struct nf_conntrack_tuple *tuple,
-	   const union nf_inet_addr *addr,
-	   u8 family, const struct nf_conntrack_zone *zone)
-{
-	struct xt_connlimit_rb *gc_nodes[CONNLIMIT_GC_MAX_NODES];
-	struct rb_node **rbnode, *parent;
-	struct xt_connlimit_rb *rbconn;
-	struct xt_connlimit_conn *conn;
-	unsigned int gc_count;
-	bool no_gc = false;
-
- restart:
-	gc_count = 0;
-	parent = NULL;
-	rbnode = &(root->rb_node);
-	while (*rbnode) {
-		int diff;
-		bool addit;
-
-		rbconn = rb_entry(*rbnode, struct xt_connlimit_rb, node);
-
-		parent = *rbnode;
-		diff = same_source(addr, &rbconn->addr, family);
-		if (diff < 0) {
-			rbnode = &((*rbnode)->rb_left);
-		} else if (diff > 0) {
-			rbnode = &((*rbnode)->rb_right);
-		} else {
-			/* same source network -> be counted! */
-			unsigned int count;
-			count = check_hlist(net, &rbconn->hhead, tuple, zone, &addit);
-
-			tree_nodes_free(root, gc_nodes, gc_count);
-			if (!addit)
-				return count;
-
-			if (!add_hlist(&rbconn->hhead, tuple, addr))
-				return 0; /* hotdrop */
-
-			return count + 1;
-		}
-
-		if (no_gc || gc_count >= ARRAY_SIZE(gc_nodes))
-			continue;
-
-		/* only used for GC on hhead, retval and 'addit' ignored */
-		check_hlist(net, &rbconn->hhead, tuple, zone, &addit);
-		if (hlist_empty(&rbconn->hhead))
-			gc_nodes[gc_count++] = rbconn;
-	}
-
-	if (gc_count) {
-		no_gc = true;
-		tree_nodes_free(root, gc_nodes, gc_count);
-		/* tree_node_free before new allocation permits
-		 * allocator to re-use newly free'd object.
-		 *
-		 * This is a rare event; in most cases we will find
-		 * existing node to re-use. (or gc_count is 0).
-		 */
-		goto restart;
-	}
-
-	/* no match, need to insert new node */
-	rbconn = kmem_cache_alloc(connlimit_rb_cachep, GFP_ATOMIC);
-	if (rbconn == NULL)
-		return 0;
-
-	conn = kmem_cache_alloc(connlimit_conn_cachep, GFP_ATOMIC);
-	if (conn == NULL) {
-		kmem_cache_free(connlimit_rb_cachep, rbconn);
-		return 0;
-	}
-
-	conn->tuple = *tuple;
-	rbconn->addr = *addr;
-
-	INIT_HLIST_HEAD(&rbconn->hhead);
-	hlist_add_head(&conn->node, &rbconn->hhead);
-
-	rb_link_node(&rbconn->node, parent, rbnode);
-	rb_insert_color(&rbconn->node, root);
-	return 1;
-}
-
-static int count_them(struct net *net,
-		      struct xt_connlimit_data *data,
-		      const struct nf_conntrack_tuple *tuple,
-		      const union nf_inet_addr *addr,
-		      u_int8_t family,
-		      const struct nf_conntrack_zone *zone)
-{
-	struct rb_root *root;
-	int count;
-	u32 hash;
-
-	if (family == NFPROTO_IPV6)
-		hash = connlimit_iphash6(addr);
-	else
-		hash = connlimit_iphash(addr->ip);
-	root = &data->climit_root[hash];
-
-	spin_lock_bh(&xt_connlimit_locks[hash % CONNLIMIT_LOCK_SLOTS]);
-
-	count = count_tree(net, root, tuple, addr, family, zone);
-
-	spin_unlock_bh(&xt_connlimit_locks[hash % CONNLIMIT_LOCK_SLOTS]);
-
-	return count;
-}
+#include <net/netfilter/nf_conntrack_count.h>
 
 static bool
 connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct net *net = xt_net(par);
 	const struct xt_connlimit_info *info = par->matchinfo;
-	union nf_inet_addr addr;
 	struct nf_conntrack_tuple tuple;
 	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
 	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
 	unsigned int connections;
+	u32 key[5];
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct != NULL) {
@@ -310,6 +48,7 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 	if (xt_family(par) == NFPROTO_IPV6) {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
+		union nf_inet_addr addr;
 		unsigned int i;
 
 		memcpy(&addr.ip6, (info->flags & XT_CONNLIMIT_DADDR) ?
@@ -317,22 +56,24 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 		for (i = 0; i < ARRAY_SIZE(addr.ip6); ++i)
 			addr.ip6[i] &= info->mask.ip6[i];
+		memcpy(key, &addr, sizeof(addr.ip6));
+		key[4] = zone->id;
 	} else {
 		const struct iphdr *iph = ip_hdr(skb);
-		addr.ip = (info->flags & XT_CONNLIMIT_DADDR) ?
+		key[0] = (info->flags & XT_CONNLIMIT_DADDR) ?
 			  iph->daddr : iph->saddr;
 
-		addr.ip &= info->mask.ip;
+		key[0] &= info->mask.ip;
+		key[1] = zone->id;
 	}
 
-	connections = count_them(net, info->data, tuple_ptr, &addr,
-				 xt_family(par), zone);
+	connections = nf_conncount_count(net, info->data, key,
+					 xt_family(par), tuple_ptr, zone);
 	if (connections == 0)
 		/* kmalloc failed, drop it entirely */
 		goto hotdrop;
 
-	return (connections > info->limit) ^
-	       !!(info->flags & XT_CONNLIMIT_INVERT);
+	return (connections > info->limit) ^ !!(info->flags & XT_CONNLIMIT_INVERT);
 
  hotdrop:
 	par->hotdrop = true;
@@ -342,61 +83,29 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 static int connlimit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_connlimit_info *info = par->matchinfo;
-	unsigned int i;
-	int ret;
+	unsigned int keylen;
 
-	net_get_random_once(&connlimit_rnd, sizeof(connlimit_rnd));
-
-	ret = nf_ct_netns_get(par->net, par->family);
-	if (ret < 0) {
-		pr_info("cannot load conntrack support for "
-			"address family %u\n", par->family);
-		return ret;
-	}
+	keylen = sizeof(u32);
+	if (par->family == NFPROTO_IPV6)
+		keylen += sizeof(struct in6_addr);
+	else
+		keylen += sizeof(struct in_addr);
 
 	/* init private data */
-	info->data = kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);
-	if (info->data == NULL) {
-		nf_ct_netns_put(par->net, par->family);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < ARRAY_SIZE(info->data->climit_root); ++i)
-		info->data->climit_root[i] = RB_ROOT;
+	info->data = nf_conncount_init(par->net, par->family, keylen);
+	if (IS_ERR(info->data))
+		return PTR_ERR(info->data);
 
 	return 0;
 }
 
-static void destroy_tree(struct rb_root *r)
-{
-	struct xt_connlimit_conn *conn;
-	struct xt_connlimit_rb *rbconn;
-	struct hlist_node *n;
-	struct rb_node *node;
-
-	while ((node = rb_first(r)) != NULL) {
-		rbconn = rb_entry(node, struct xt_connlimit_rb, node);
-
-		rb_erase(node, r);
-
-		hlist_for_each_entry_safe(conn, n, &rbconn->hhead, node)
-			kmem_cache_free(connlimit_conn_cachep, conn);
-
-		kmem_cache_free(connlimit_rb_cachep, rbconn);
-	}
-}
-
 static void connlimit_mt_destroy(const struct xt_mtdtor_param *par)
 {
 	const struct xt_connlimit_info *info = par->matchinfo;
-	unsigned int i;
 
 	nf_ct_netns_put(par->net, par->family);
 
-	for (i = 0; i < ARRAY_SIZE(info->data->climit_root); ++i)
-		destroy_tree(&info->data->climit_root[i]);
-
-	kfree(info->data);
+	nf_conncount_destroy(par->net, par->family, info->data);
 }
 
 static struct xt_match connlimit_mt_reg __read_mostly = {
@@ -413,40 +122,12 @@ static struct xt_match connlimit_mt_reg __read_mostly = {
 
 static int __init connlimit_mt_init(void)
 {
-	int ret, i;
-
-	BUILD_BUG_ON(CONNLIMIT_LOCK_SLOTS > CONNLIMIT_SLOTS);
-	BUILD_BUG_ON((CONNLIMIT_SLOTS % CONNLIMIT_LOCK_SLOTS) != 0);
-
-	for (i = 0; i < CONNLIMIT_LOCK_SLOTS; ++i)
-		spin_lock_init(&xt_connlimit_locks[i]);
-
-	connlimit_conn_cachep = kmem_cache_create("xt_connlimit_conn",
-					   sizeof(struct xt_connlimit_conn),
-					   0, 0, NULL);
-	if (!connlimit_conn_cachep)
-		return -ENOMEM;
-
-	connlimit_rb_cachep = kmem_cache_create("xt_connlimit_rb",
-					   sizeof(struct xt_connlimit_rb),
-					   0, 0, NULL);
-	if (!connlimit_rb_cachep) {
-		kmem_cache_destroy(connlimit_conn_cachep);
-		return -ENOMEM;
-	}
-	ret = xt_register_match(&connlimit_mt_reg);
-	if (ret != 0) {
-		kmem_cache_destroy(connlimit_conn_cachep);
-		kmem_cache_destroy(connlimit_rb_cachep);
-	}
-	return ret;
+	return xt_register_match(&connlimit_mt_reg);
 }
 
 static void __exit connlimit_mt_exit(void)
 {
 	xt_unregister_match(&connlimit_mt_reg);
-	kmem_cache_destroy(connlimit_conn_cachep);
-	kmem_cache_destroy(connlimit_rb_cachep);
 }
 
 module_init(connlimit_mt_init);
-- 
2.13.6

