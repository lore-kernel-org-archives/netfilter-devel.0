From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 01/11] Split out expectation handling
Date: Wed, 01 Nov 2006 22:08:46 +0100
Message-ID: <20061101210912.081332234@wlug.westbo.se>
References: <20061101210845.337590368@wlug.westbo.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline; filename=nf_conntrack-split-expect
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

This patch splits out expectation handling into its own file
nf_conntrack_expect.c

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

---
 include/net/netfilter/nf_conntrack.h        |   49 ---
 include/net/netfilter/nf_conntrack_core.h   |    7 
 include/net/netfilter/nf_conntrack_expect.h |   72 +++++
 include/net/netfilter/nf_conntrack_helper.h |   10 
 net/netfilter/Makefile                      |    2 
 net/netfilter/nf_conntrack_core.c           |  265 --------------------
 net/netfilter/nf_conntrack_expect.c         |  367 ++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_ftp.c            |    1 
 net/netfilter/nf_conntrack_netlink.c        |    1 
 net/netfilter/nf_conntrack_standalone.c     |   81 ------
 10 files changed, 454 insertions(+), 401 deletions(-)

Index: linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack.h
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/include/net/netfilter/nf_conntrack.h	2006-10-29 12:29:17.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack.h	2006-11-01 18:03:10.000000000 +0100
@@ -124,44 +124,6 @@ struct nf_conn
 	char data[0];
 };
 
-struct nf_conntrack_expect
-{
-	/* Internal linked list (global expectation list) */
-	struct list_head list;
-
-	/* We expect this tuple, with the following mask */
-	struct nf_conntrack_tuple tuple, mask;
- 
-	/* Function to call after setup and insertion */
-	void (*expectfn)(struct nf_conn *new,
-			 struct nf_conntrack_expect *this);
-
-	/* The conntrack of the master connection */
-	struct nf_conn *master;
-
-	/* Timer function; deletes the expectation. */
-	struct timer_list timeout;
-
-	/* Usage count. */
-	atomic_t use;
-
-	/* Unique ID */
-	unsigned int id;
-
-	/* Flags */
-	unsigned int flags;
-
-#ifdef CONFIG_NF_NAT_NEEDED
-	/* This is the original per-proto part, used to map the
-	 * expected connection the way the recipient expects. */
-	union nf_conntrack_manip_proto saved_proto;
-	/* Direction relative to the master connection. */
-	enum ip_conntrack_dir dir;
-#endif
-};
-
-#define NF_CT_EXPECT_PERMANENT 0x1
-
 static inline struct nf_conn *
 nf_ct_tuplehash_to_ctrack(const struct nf_conntrack_tuple_hash *hash)
 {
@@ -208,16 +170,6 @@ __nf_conntrack_find(const struct nf_conn
 
 extern void nf_conntrack_hash_insert(struct nf_conn *ct);
 
-extern struct nf_conntrack_expect *
-__nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple);
-
-extern struct nf_conntrack_expect *
-nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple);
-
-extern void nf_ct_unlink_expect(struct nf_conntrack_expect *exp);
-
-extern void nf_ct_remove_expectations(struct nf_conn *ct);
-
 extern void nf_conntrack_flush(void);
 
 extern struct nf_conntrack_helper *
@@ -295,6 +247,7 @@ extern int nf_conntrack_checksum;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 #include <linux/notifier.h>
 #include <linux/interrupt.h>
+#include <net/netfilter/nf_conntrack_expect.h>
 
 struct nf_conntrack_ecache {
 	struct nf_conn *ct;
Index: linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_expect.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_expect.h	2006-11-01 18:04:21.000000000 +0100
@@ -0,0 +1,72 @@
+/*
+ * connection tracking expectations.
+ */
+
+#ifndef _NF_CONNTRACK_EXPECT_H
+#define _NF_CONNTRACK_EXPECT_H
+#include <net/netfilter/nf_conntrack.h>
+
+extern struct list_head nf_conntrack_expect_list;
+extern kmem_cache_t *nf_conntrack_expect_cachep;
+extern struct file_operations exp_file_ops;
+
+struct nf_conntrack_expect
+{
+	/* Internal linked list (global expectation list) */
+	struct list_head list;
+
+	/* We expect this tuple, with the following mask */
+	struct nf_conntrack_tuple tuple, mask;
+
+	/* Function to call after setup and insertion */
+	void (*expectfn)(struct nf_conn *new,
+			 struct nf_conntrack_expect *this);
+
+	/* The conntrack of the master connection */
+	struct nf_conn *master;
+
+	/* Timer function; deletes the expectation. */
+	struct timer_list timeout;
+
+	/* Usage count. */
+	atomic_t use;
+
+	/* Unique ID */
+	unsigned int id;
+
+	/* Flags */
+	unsigned int flags;
+
+#ifdef CONFIG_NF_NAT_NEEDED
+	/* This is the original per-proto part, used to map the
+	 * expected connection the way the recipient expects. */
+	union nf_conntrack_manip_proto saved_proto;
+	/* Direction relative to the master connection. */
+	enum ip_conntrack_dir dir;
+#endif
+};
+
+#define NF_CT_EXPECT_PERMANENT 0x1
+
+
+struct nf_conntrack_expect *
+__nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple);
+
+struct nf_conntrack_expect *
+nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple);
+
+struct nf_conntrack_expect *
+find_expectation(const struct nf_conntrack_tuple *tuple);
+
+void nf_ct_unlink_expect(struct nf_conntrack_expect *exp);
+void nf_ct_remove_expectations(struct nf_conn *ct);
+void nf_conntrack_unexpect_related(struct nf_conntrack_expect *exp);
+
+/* Allocate space for an expectation: this is mandatory before calling
+   nf_conntrack_expect_related.  You will have to call put afterwards. */
+struct nf_conntrack_expect *nf_conntrack_expect_alloc(struct nf_conn *me);
+void nf_conntrack_expect_put(struct nf_conntrack_expect *exp);
+int nf_conntrack_expect_related(struct nf_conntrack_expect *expect);
+
+#endif /*_NF_CONNTRACK_EXPECT_H*/
+
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/Makefile
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/Makefile	2006-10-29 12:29:17.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/Makefile	2006-11-01 18:03:10.000000000 +0100
@@ -1,5 +1,5 @@
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o
-nf_conntrack-objs	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o
+nf_conntrack-objs	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
 
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_core.c	2006-10-29 11:47:41.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c	2006-11-01 18:03:10.000000000 +0100
@@ -55,6 +55,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
@@ -72,21 +73,19 @@ DEFINE_RWLOCK(nf_conntrack_lock);
 atomic_t nf_conntrack_count = ATOMIC_INIT(0);
 
 void (*nf_conntrack_destroyed)(struct nf_conn *conntrack) = NULL;
-LIST_HEAD(nf_conntrack_expect_list);
 struct nf_conntrack_protocol **nf_ct_protos[PF_MAX] __read_mostly;
 struct nf_conntrack_l3proto *nf_ct_l3protos[PF_MAX] __read_mostly;
 static LIST_HEAD(helpers);
 unsigned int nf_conntrack_htable_size __read_mostly = 0;
 int nf_conntrack_max __read_mostly;
 struct list_head *nf_conntrack_hash __read_mostly;
-static kmem_cache_t *nf_conntrack_expect_cachep __read_mostly;
 struct nf_conn nf_conntrack_untracked;
 unsigned int nf_ct_log_invalid __read_mostly;
 static LIST_HEAD(unconfirmed);
 static int nf_conntrack_vmalloc __read_mostly;
 
 static unsigned int nf_conntrack_next_id;
-static unsigned int nf_conntrack_expect_next_id;
+
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 ATOMIC_NOTIFIER_HEAD(nf_conntrack_chain);
 ATOMIC_NOTIFIER_HEAD(nf_conntrack_expect_chain);
@@ -438,103 +437,6 @@ nf_ct_invert_tuple(struct nf_conntrack_t
 	return protocol->invert_tuple(inverse, orig);
 }
 
-/* nf_conntrack_expect helper functions */
-void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
-{
-	struct nf_conn_help *master_help = nfct_help(exp->master);
-
-	NF_CT_ASSERT(master_help);
-	ASSERT_WRITE_LOCK(&nf_conntrack_lock);
-	NF_CT_ASSERT(!timer_pending(&exp->timeout));
-
-	list_del(&exp->list);
-	NF_CT_STAT_INC(expect_delete);
-	master_help->expecting--;
-	nf_conntrack_expect_put(exp);
-}
-
-static void expectation_timed_out(unsigned long ul_expect)
-{
-	struct nf_conntrack_expect *exp = (void *)ul_expect;
-
-	write_lock_bh(&nf_conntrack_lock);
-	nf_ct_unlink_expect(exp);
-	write_unlock_bh(&nf_conntrack_lock);
-	nf_conntrack_expect_put(exp);
-}
-
-struct nf_conntrack_expect *
-__nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple)
-{
-	struct nf_conntrack_expect *i;
-	
-	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
-		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)) {
-			atomic_inc(&i->use);
-			return i;
-		}
-	}
-	return NULL;
-}
-
-/* Just find a expectation corresponding to a tuple. */
-struct nf_conntrack_expect *
-nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple)
-{
-	struct nf_conntrack_expect *i;
-	
-	read_lock_bh(&nf_conntrack_lock);
-	i = __nf_conntrack_expect_find(tuple);
-	read_unlock_bh(&nf_conntrack_lock);
-
-	return i;
-}
-
-/* If an expectation for this connection is found, it gets delete from
- * global list then returned. */
-static struct nf_conntrack_expect *
-find_expectation(const struct nf_conntrack_tuple *tuple)
-{
-	struct nf_conntrack_expect *i;
-
-	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
-	/* If master is not in hash table yet (ie. packet hasn't left
-	   this machine yet), how can other end know about expected?
-	   Hence these are not the droids you are looking for (if
-	   master ct never got confirmed, we'd hold a reference to it
-	   and weird things would happen to future packets). */
-		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)
-		    && nf_ct_is_confirmed(i->master)) {
-			if (i->flags & NF_CT_EXPECT_PERMANENT) {
-				atomic_inc(&i->use);
-				return i;
-			} else if (del_timer(&i->timeout)) {
-				nf_ct_unlink_expect(i);
-				return i;
-			}
-		}
-	}
-	return NULL;
-}
-
-/* delete all expectations for this conntrack */
-void nf_ct_remove_expectations(struct nf_conn *ct)
-{
-	struct nf_conntrack_expect *i, *tmp;
-	struct nf_conn_help *help = nfct_help(ct);
-
-	/* Optimization: most connection never expect any others. */
-	if (!help || help->expecting == 0)
-		return;
-
-	list_for_each_entry_safe(i, tmp, &nf_conntrack_expect_list, list) {
-		if (i->master == ct && del_timer(&i->timeout)) {
-			nf_ct_unlink_expect(i);
-			nf_conntrack_expect_put(i);
- 		}
-	}
-}
-
 static void
 clean_from_lists(struct nf_conn *ct)
 {
@@ -1134,169 +1036,6 @@ int nf_ct_invert_tuplepr(struct nf_connt
 						     orig->dst.protonum));
 }
 
-/* Would two expected things clash? */
-static inline int expect_clash(const struct nf_conntrack_expect *a,
-			       const struct nf_conntrack_expect *b)
-{
-	/* Part covered by intersection of masks must be unequal,
-	   otherwise they clash */
-	struct nf_conntrack_tuple intersect_mask;
-	int count;
-
-	intersect_mask.src.l3num = a->mask.src.l3num & b->mask.src.l3num;
-	intersect_mask.src.u.all = a->mask.src.u.all & b->mask.src.u.all;
-	intersect_mask.dst.u.all = a->mask.dst.u.all & b->mask.dst.u.all;
-	intersect_mask.dst.protonum = a->mask.dst.protonum
-					& b->mask.dst.protonum;
-
-	for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++){
-		intersect_mask.src.u3.all[count] =
-			a->mask.src.u3.all[count] & b->mask.src.u3.all[count];
-	}
-
-	for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++){
-		intersect_mask.dst.u3.all[count] =
-			a->mask.dst.u3.all[count] & b->mask.dst.u3.all[count];
-	}
-
-	return nf_ct_tuple_mask_cmp(&a->tuple, &b->tuple, &intersect_mask);
-}
-
-static inline int expect_matches(const struct nf_conntrack_expect *a,
-				 const struct nf_conntrack_expect *b)
-{
-	return a->master == b->master
-		&& nf_ct_tuple_equal(&a->tuple, &b->tuple)
-		&& nf_ct_tuple_equal(&a->mask, &b->mask);
-}
-
-/* Generally a bad idea to call this: could have matched already. */
-void nf_conntrack_unexpect_related(struct nf_conntrack_expect *exp)
-{
-	struct nf_conntrack_expect *i;
-
-	write_lock_bh(&nf_conntrack_lock);
-	/* choose the the oldest expectation to evict */
-	list_for_each_entry_reverse(i, &nf_conntrack_expect_list, list) {
-		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
-			nf_ct_unlink_expect(i);
-			write_unlock_bh(&nf_conntrack_lock);
-			nf_conntrack_expect_put(i);
-			return;
-		}
-	}
-	write_unlock_bh(&nf_conntrack_lock);
-}
-
-/* We don't increase the master conntrack refcount for non-fulfilled
- * conntracks. During the conntrack destruction, the expectations are
- * always killed before the conntrack itself */
-struct nf_conntrack_expect *nf_conntrack_expect_alloc(struct nf_conn *me)
-{
-	struct nf_conntrack_expect *new;
-
-	new = kmem_cache_alloc(nf_conntrack_expect_cachep, GFP_ATOMIC);
-	if (!new) {
-		DEBUGP("expect_related: OOM allocating expect\n");
-		return NULL;
-	}
-	new->master = me;
-	atomic_set(&new->use, 1);
-	return new;
-}
-
-void nf_conntrack_expect_put(struct nf_conntrack_expect *exp)
-{
-	if (atomic_dec_and_test(&exp->use))
-		kmem_cache_free(nf_conntrack_expect_cachep, exp);
-}
-
-static void nf_conntrack_expect_insert(struct nf_conntrack_expect *exp)
-{
-	struct nf_conn_help *master_help = nfct_help(exp->master);
-
-	atomic_inc(&exp->use);
-	master_help->expecting++;
-	list_add(&exp->list, &nf_conntrack_expect_list);
-
-	init_timer(&exp->timeout);
-	exp->timeout.data = (unsigned long)exp;
-	exp->timeout.function = expectation_timed_out;
-	exp->timeout.expires = jiffies + master_help->helper->timeout * HZ;
-	add_timer(&exp->timeout);
-
-	exp->id = ++nf_conntrack_expect_next_id;
-	atomic_inc(&exp->use);
-	NF_CT_STAT_INC(expect_create);
-}
-
-/* Race with expectations being used means we could have none to find; OK. */
-static void evict_oldest_expect(struct nf_conn *master)
-{
-	struct nf_conntrack_expect *i;
-
-	list_for_each_entry_reverse(i, &nf_conntrack_expect_list, list) {
-		if (i->master == master) {
-			if (del_timer(&i->timeout)) {
-				nf_ct_unlink_expect(i);
-				nf_conntrack_expect_put(i);
-			}
-			break;
-		}
-	}
-}
-
-static inline int refresh_timer(struct nf_conntrack_expect *i)
-{
-	struct nf_conn_help *master_help = nfct_help(i->master);
-
-	if (!del_timer(&i->timeout))
-		return 0;
-
-	i->timeout.expires = jiffies + master_help->helper->timeout*HZ;
-	add_timer(&i->timeout);
-	return 1;
-}
-
-int nf_conntrack_expect_related(struct nf_conntrack_expect *expect)
-{
-	struct nf_conntrack_expect *i;
-	struct nf_conn *master = expect->master;
-	struct nf_conn_help *master_help = nfct_help(master);
-	int ret;
-
-	NF_CT_ASSERT(master_help);
-
-	DEBUGP("nf_conntrack_expect_related %p\n", related_to);
-	DEBUGP("tuple: "); NF_CT_DUMP_TUPLE(&expect->tuple);
-	DEBUGP("mask:  "); NF_CT_DUMP_TUPLE(&expect->mask);
-
-	write_lock_bh(&nf_conntrack_lock);
-	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
-		if (expect_matches(i, expect)) {
-			/* Refresh timer: if it's dying, ignore.. */
-			if (refresh_timer(i)) {
-				ret = 0;
-				goto out;
-			}
-		} else if (expect_clash(i, expect)) {
-			ret = -EBUSY;
-			goto out;
-		}
-	}
-	/* Will be over limit? */
-	if (master_help->helper->max_expected &&
-	    master_help->expecting >= master_help->helper->max_expected)
-		evict_oldest_expect(master);
-
-	nf_conntrack_expect_insert(expect);
-	nf_conntrack_expect_event(IPEXP_NEW, expect);
-	ret = 0;
-out:
-	write_unlock_bh(&nf_conntrack_lock);
-	return ret;
-}
-
 int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
 	int ret;
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_expect.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_expect.c	2006-11-01 18:05:27.000000000 +0100
@@ -0,0 +1,367 @@
+/* Expectation handling for nf_conntrack. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ * (C) 2003,2004 USAGI/WIDE Project <http://www.linux-ipv6.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/netfilter.h>
+#include <linux/skbuff.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/stddef.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/percpu.h>
+#include <linux/kernel.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+
+LIST_HEAD(nf_conntrack_expect_list);
+kmem_cache_t *nf_conntrack_expect_cachep __read_mostly;
+DECLARE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
+static unsigned int nf_conntrack_expect_next_id;
+
+/* nf_conntrack_expect helper functions */
+void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
+{
+	struct nf_conn_help *master_help = nfct_help(exp->master);
+
+	NF_CT_ASSERT(master_help);
+	NF_CT_ASSERT(!timer_pending(&exp->timeout));
+
+	list_del(&exp->list);
+	NF_CT_STAT_INC(expect_delete);
+	master_help->expecting--;
+	nf_conntrack_expect_put(exp);
+}
+
+static void expectation_timed_out(unsigned long ul_expect)
+{
+	struct nf_conntrack_expect *exp = (void *)ul_expect;
+
+	write_lock_bh(&nf_conntrack_lock);
+	nf_ct_unlink_expect(exp);
+	write_unlock_bh(&nf_conntrack_lock);
+	nf_conntrack_expect_put(exp);
+}
+
+struct nf_conntrack_expect *
+__nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_expect *i;
+
+	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
+		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)) {
+			atomic_inc(&i->use);
+			return i;
+		}
+	}
+	return NULL;
+}
+
+/* Just find a expectation corresponding to a tuple. */
+struct nf_conntrack_expect *
+nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_expect *i;
+
+	read_lock_bh(&nf_conntrack_lock);
+	i = __nf_conntrack_expect_find(tuple);
+	read_unlock_bh(&nf_conntrack_lock);
+
+	return i;
+}
+
+/* If an expectation for this connection is found, it gets delete from
+ * global list then returned. */
+struct nf_conntrack_expect *
+find_expectation(const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_expect *i;
+
+	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
+	/* If master is not in hash table yet (ie. packet hasn't left
+	   this machine yet), how can other end know about expected?
+	   Hence these are not the droids you are looking for (if
+	   master ct never got confirmed, we'd hold a reference to it
+	   and weird things would happen to future packets). */
+		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)
+		    && nf_ct_is_confirmed(i->master)) {
+			if (i->flags & NF_CT_EXPECT_PERMANENT) {
+				atomic_inc(&i->use);
+				return i;
+			} else if (del_timer(&i->timeout)) {
+				nf_ct_unlink_expect(i);
+				return i;
+			}
+		}
+	}
+	return NULL;
+}
+
+/* delete all expectations for this conntrack */
+void nf_ct_remove_expectations(struct nf_conn *ct)
+{
+	struct nf_conntrack_expect *i, *tmp;
+	struct nf_conn_help *help = nfct_help(ct);
+
+	/* Optimization: most connection never expect any others. */
+	if (!help || help->expecting == 0)
+		return;
+
+	list_for_each_entry_safe(i, tmp, &nf_conntrack_expect_list, list) {
+		if (i->master == ct && del_timer(&i->timeout)) {
+			nf_ct_unlink_expect(i);
+			nf_conntrack_expect_put(i);
+ 		}
+	}
+}
+
+/* Would two expected things clash? */
+static inline int expect_clash(const struct nf_conntrack_expect *a,
+			       const struct nf_conntrack_expect *b)
+{
+	/* Part covered by intersection of masks must be unequal,
+	   otherwise they clash */
+	struct nf_conntrack_tuple intersect_mask;
+	int count;
+
+	intersect_mask.src.l3num = a->mask.src.l3num & b->mask.src.l3num;
+	intersect_mask.src.u.all = a->mask.src.u.all & b->mask.src.u.all;
+	intersect_mask.dst.u.all = a->mask.dst.u.all & b->mask.dst.u.all;
+	intersect_mask.dst.protonum = a->mask.dst.protonum
+					& b->mask.dst.protonum;
+
+	for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++){
+		intersect_mask.src.u3.all[count] =
+			a->mask.src.u3.all[count] & b->mask.src.u3.all[count];
+	}
+
+	for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++){
+		intersect_mask.dst.u3.all[count] =
+			a->mask.dst.u3.all[count] & b->mask.dst.u3.all[count];
+	}
+
+	return nf_ct_tuple_mask_cmp(&a->tuple, &b->tuple, &intersect_mask);
+}
+
+static inline int expect_matches(const struct nf_conntrack_expect *a,
+				 const struct nf_conntrack_expect *b)
+{
+	return a->master == b->master
+		&& nf_ct_tuple_equal(&a->tuple, &b->tuple)
+		&& nf_ct_tuple_equal(&a->mask, &b->mask);
+}
+
+/* Generally a bad idea to call this: could have matched already. */
+void nf_conntrack_unexpect_related(struct nf_conntrack_expect *exp)
+{
+	struct nf_conntrack_expect *i;
+
+	write_lock_bh(&nf_conntrack_lock);
+	/* choose the the oldest expectation to evict */
+	list_for_each_entry_reverse(i, &nf_conntrack_expect_list, list) {
+		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
+			nf_ct_unlink_expect(i);
+			write_unlock_bh(&nf_conntrack_lock);
+			nf_conntrack_expect_put(i);
+			return;
+		}
+	}
+	write_unlock_bh(&nf_conntrack_lock);
+}
+
+/* We don't increase the master conntrack refcount for non-fulfilled
+ * conntracks. During the conntrack destruction, the expectations are
+ * always killed before the conntrack itself */
+struct nf_conntrack_expect *nf_conntrack_expect_alloc(struct nf_conn *me)
+{
+	struct nf_conntrack_expect *new;
+
+	new = kmem_cache_alloc(nf_conntrack_expect_cachep, GFP_ATOMIC);
+	if (!new)
+		return NULL;
+
+	new->master = me;
+	atomic_set(&new->use, 1);
+	return new;
+}
+
+void nf_conntrack_expect_put(struct nf_conntrack_expect *exp)
+{
+	if (atomic_dec_and_test(&exp->use))
+		kmem_cache_free(nf_conntrack_expect_cachep, exp);
+}
+
+static void nf_conntrack_expect_insert(struct nf_conntrack_expect *exp)
+{
+	struct nf_conn_help *master_help = nfct_help(exp->master);
+
+	atomic_inc(&exp->use);
+	master_help->expecting++;
+	list_add(&exp->list, &nf_conntrack_expect_list);
+
+	init_timer(&exp->timeout);
+	exp->timeout.data = (unsigned long)exp;
+	exp->timeout.function = expectation_timed_out;
+	exp->timeout.expires = jiffies + master_help->helper->timeout * HZ;
+	add_timer(&exp->timeout);
+
+	exp->id = ++nf_conntrack_expect_next_id;
+	atomic_inc(&exp->use);
+	NF_CT_STAT_INC(expect_create);
+}
+
+/* Race with expectations being used means we could have none to find; OK. */
+static void evict_oldest_expect(struct nf_conn *master)
+{
+	struct nf_conntrack_expect *i;
+
+	list_for_each_entry_reverse(i, &nf_conntrack_expect_list, list) {
+		if (i->master == master) {
+			if (del_timer(&i->timeout)) {
+				nf_ct_unlink_expect(i);
+				nf_conntrack_expect_put(i);
+			}
+			break;
+		}
+	}
+}
+
+static inline int refresh_timer(struct nf_conntrack_expect *i)
+{
+	struct nf_conn_help *master_help = nfct_help(i->master);
+
+	if (!del_timer(&i->timeout))
+		return 0;
+
+	i->timeout.expires = jiffies + master_help->helper->timeout*HZ;
+	add_timer(&i->timeout);
+	return 1;
+}
+
+int nf_conntrack_expect_related(struct nf_conntrack_expect *expect)
+{
+	struct nf_conntrack_expect *i;
+	struct nf_conn *master = expect->master;
+	struct nf_conn_help *master_help = nfct_help(master);
+	int ret;
+
+	NF_CT_ASSERT(master_help);
+
+	write_lock_bh(&nf_conntrack_lock);
+	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
+		if (expect_matches(i, expect)) {
+			/* Refresh timer: if it's dying, ignore.. */
+			if (refresh_timer(i)) {
+				ret = 0;
+				goto out;
+			}
+		} else if (expect_clash(i, expect)) {
+			ret = -EBUSY;
+			goto out;
+		}
+	}
+	/* Will be over limit? */
+	if (master_help->helper->max_expected &&
+	    master_help->expecting >= master_help->helper->max_expected)
+		evict_oldest_expect(master);
+
+	nf_conntrack_expect_insert(expect);
+	nf_conntrack_expect_event(IPEXP_NEW, expect);
+	ret = 0;
+out:
+	write_unlock_bh(&nf_conntrack_lock);
+	return ret;
+}
+
+#ifdef CONFIG_PROC_FS
+static void *exp_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct list_head *e = &nf_conntrack_expect_list;
+	loff_t i;
+
+	/* strange seq_file api calls stop even if we fail,
+	 * thus we need to grab lock since stop unlocks */
+	read_lock_bh(&nf_conntrack_lock);
+
+	if (list_empty(e))
+		return NULL;
+
+	for (i = 0; i <= *pos; i++) {
+		e = e->next;
+		if (e == &nf_conntrack_expect_list)
+			return NULL;
+	}
+	return e;
+}
+
+static void *exp_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct list_head *e = v;
+
+	++*pos;
+	e = e->next;
+
+	if (e == &nf_conntrack_expect_list)
+		return NULL;
+
+	return e;
+}
+
+static void exp_seq_stop(struct seq_file *s, void *v)
+{
+	read_unlock_bh(&nf_conntrack_lock);
+}
+
+static int exp_seq_show(struct seq_file *s, void *v)
+{
+	struct nf_conntrack_expect *expect = v;
+
+	if (expect->timeout.function)
+		seq_printf(s, "%ld ", timer_pending(&expect->timeout)
+			   ? (long)(expect->timeout.expires - jiffies)/HZ : 0);
+	else
+		seq_printf(s, "- ");
+	seq_printf(s, "l3proto = %u proto=%u ",
+		   expect->tuple.src.l3num,
+		   expect->tuple.dst.protonum);
+	print_tuple(s, &expect->tuple,
+		    __nf_ct_l3proto_find(expect->tuple.src.l3num),
+		    __nf_ct_proto_find(expect->tuple.src.l3num,
+				       expect->tuple.dst.protonum));
+	return seq_putc(s, '\n');
+}
+
+static struct seq_operations exp_seq_ops = {
+	.start = exp_seq_start,
+	.next = exp_seq_next,
+	.stop = exp_seq_stop,
+	.show = exp_seq_show
+};
+
+static int exp_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &exp_seq_ops);
+}
+
+struct file_operations exp_file_ops = {
+	.owner   = THIS_MODULE,
+	.open    = exp_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release
+};
+#endif /* CONFIG_PROC_FS */
+
+
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_ftp.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_ftp.c	2006-10-29 12:29:17.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_ftp.c	2006-11-01 18:03:10.000000000 +0100
@@ -26,6 +26,7 @@
 #include <net/tcp.h>
 
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <linux/netfilter/nf_conntrack_ftp.h>
 
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_netlink.c	2006-10-29 12:29:17.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_netlink.c	2006-10-29 22:58:57.000000000 +0100
@@ -35,6 +35,7 @@
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_protocol.h>
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_standalone.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_standalone.c	2006-10-29 12:29:17.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_standalone.c	2006-11-01 18:03:10.000000000 +0100
@@ -36,6 +36,7 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_protocol.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 
 #if 0
@@ -66,7 +67,7 @@ static int kill_proto(struct nf_conn *i,
 }
 
 #ifdef CONFIG_PROC_FS
-static int
+int
 print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 	    struct nf_conntrack_l3proto *l3proto,
 	    struct nf_conntrack_protocol *proto)
@@ -258,84 +259,6 @@ static struct file_operations ct_file_op
 	.release = seq_release_private,
 };
 
-/* expects */
-static void *exp_seq_start(struct seq_file *s, loff_t *pos)
-{
-	struct list_head *e = &nf_conntrack_expect_list;
-	loff_t i;
-
-	/* strange seq_file api calls stop even if we fail,
-	 * thus we need to grab lock since stop unlocks */
-	read_lock_bh(&nf_conntrack_lock);
-
-	if (list_empty(e))
-		return NULL;
-
-	for (i = 0; i <= *pos; i++) {
-		e = e->next;
-		if (e == &nf_conntrack_expect_list)
-			return NULL;
-	}
-	return e;
-}
-
-static void *exp_seq_next(struct seq_file *s, void *v, loff_t *pos)
-{
-	struct list_head *e = v;
-
-	++*pos;
-	e = e->next;
-
-	if (e == &nf_conntrack_expect_list)
-		return NULL;
-
-	return e;
-}
-
-static void exp_seq_stop(struct seq_file *s, void *v)
-{
-	read_unlock_bh(&nf_conntrack_lock);
-}
-
-static int exp_seq_show(struct seq_file *s, void *v)
-{
-	struct nf_conntrack_expect *expect = v;
-
-	if (expect->timeout.function)
-		seq_printf(s, "%ld ", timer_pending(&expect->timeout)
-			   ? (long)(expect->timeout.expires - jiffies)/HZ : 0);
-	else
-		seq_printf(s, "- ");
-	seq_printf(s, "l3proto = %u proto=%u ",
-		   expect->tuple.src.l3num,
-		   expect->tuple.dst.protonum);
-	print_tuple(s, &expect->tuple,
-		    __nf_ct_l3proto_find(expect->tuple.src.l3num),
-		    __nf_ct_proto_find(expect->tuple.src.l3num,
-				       expect->tuple.dst.protonum));
-	return seq_putc(s, '\n');
-}
-
-static struct seq_operations exp_seq_ops = {
-	.start = exp_seq_start,
-	.next = exp_seq_next,
-	.stop = exp_seq_stop,
-	.show = exp_seq_show
-};
-
-static int exp_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &exp_seq_ops);
-}
-
-static struct file_operations exp_file_ops = {
-	.owner   = THIS_MODULE,
-	.open    = exp_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release
-};
-
 static void *ct_cpu_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	int cpu;
Index: linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_core.h
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/include/net/netfilter/nf_conntrack_core.h	2006-10-29 12:29:17.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_core.h	2006-11-01 18:03:10.000000000 +0100
@@ -13,6 +13,8 @@
 #define _NF_CONNTRACK_CORE_H
 
 #include <linux/netfilter.h>
+#include <net/netfilter/nf_conntrack_l3proto.h>
+#include <net/netfilter/nf_conntrack_protocol.h>
 
 /* This header is used to share core functionality between the
    standalone connection tracking module, and the compatibility layer's use
@@ -70,6 +72,11 @@ static inline int nf_conntrack_confirm(s
 
 extern void __nf_conntrack_attach(struct sk_buff *nskb, struct sk_buff *skb);
 
+int
+print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
+	    struct nf_conntrack_l3proto *l3proto,
+	    struct nf_conntrack_protocol *proto);
+
 extern struct list_head *nf_conntrack_hash;
 extern struct list_head nf_conntrack_expect_list;
 extern rwlock_t nf_conntrack_lock ;
Index: linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_helper.h
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/include/net/netfilter/nf_conntrack_helper.h	2006-10-29 12:29:17.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_helper.h	2006-11-01 18:03:10.000000000 +0100
@@ -40,14 +40,4 @@ struct nf_conntrack_helper
 extern int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 extern void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
 
-/* Allocate space for an expectation: this is mandatory before calling
-   nf_conntrack_expect_related.  You will have to call put afterwards. */
-extern struct nf_conntrack_expect *
-nf_conntrack_expect_alloc(struct nf_conn *master);
-extern void nf_conntrack_expect_put(struct nf_conntrack_expect *exp);
-
-/* Add an expected connection: can have more than one per connection */
-extern int nf_conntrack_expect_related(struct nf_conntrack_expect *exp);
-extern void nf_conntrack_unexpect_related(struct nf_conntrack_expect *exp);
-
 #endif /*_NF_CONNTRACK_HELPER_H*/

--
/Martin
