From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 02/11] Split out helper handling
Date: Wed, 01 Nov 2006 22:08:47 +0100
Message-ID: <20061101210912.625786427@wlug.westbo.se>
References: <20061101210845.337590368@wlug.westbo.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline; filename=nf_conntrack-split-helper
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

This patch splits out handling of helpers into its own file
nf_conntrack_helper.c

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

---
 include/net/netfilter/nf_conntrack_core.h   |    2 
 include/net/netfilter/nf_conntrack_helper.h |   10 +
 net/netfilter/Makefile                      |    2 
 net/netfilter/nf_conntrack_core.c           |  120 ----------------------
 net/netfilter/nf_conntrack_helper.c         |  152 ++++++++++++++++++++++++++++
 5 files changed, 166 insertions(+), 120 deletions(-)

Index: linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_helper.h
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/include/net/netfilter/nf_conntrack_helper.h	2006-11-01 18:03:10.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_helper.h	2006-11-01 18:05:35.000000000 +0100
@@ -37,6 +37,16 @@ struct nf_conntrack_helper
 	int (*to_nfattr)(struct sk_buff *skb, const struct nf_conn *ct);
 };
 
+extern struct nf_conntrack_helper *
+__nf_ct_helper_find(const struct nf_conntrack_tuple *tuple);
+
+extern struct nf_conntrack_helper *
+nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple);
+
+extern struct nf_conntrack_helper *
+__nf_conntrack_helper_find_byname(const char *name);
+
+extern void nf_ct_helper_put(struct nf_conntrack_helper *helper);
 extern int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 extern void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
 
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_core.c	2006-11-01 18:03:10.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c	2006-11-01 18:05:35.000000000 +0100
@@ -75,13 +75,12 @@ atomic_t nf_conntrack_count = ATOMIC_INI
 void (*nf_conntrack_destroyed)(struct nf_conn *conntrack) = NULL;
 struct nf_conntrack_protocol **nf_ct_protos[PF_MAX] __read_mostly;
 struct nf_conntrack_l3proto *nf_ct_l3protos[PF_MAX] __read_mostly;
-static LIST_HEAD(helpers);
 unsigned int nf_conntrack_htable_size __read_mostly = 0;
 int nf_conntrack_max __read_mostly;
 struct list_head *nf_conntrack_hash __read_mostly;
 struct nf_conn nf_conntrack_untracked;
 unsigned int nf_ct_log_invalid __read_mostly;
-static LIST_HEAD(unconfirmed);
+LIST_HEAD(unconfirmed);
 static int nf_conntrack_vmalloc __read_mostly;
 
 static unsigned int nf_conntrack_next_id;
@@ -696,46 +695,6 @@ static int early_drop(struct list_head *
 	return dropped;
 }
 
-static struct nf_conntrack_helper *
-__nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
-{
-	struct nf_conntrack_helper *h;
-
-	list_for_each_entry(h, &helpers, list) {
-		if (nf_ct_tuple_mask_cmp(tuple, &h->tuple, &h->mask))
-			return h;
-	}
-	return NULL;
-}
-
-struct nf_conntrack_helper *
-nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple)
-{
-	struct nf_conntrack_helper *helper;
-
-	/* need nf_conntrack_lock to assure that helper exists until
-	 * try_module_get() is called */
-	read_lock_bh(&nf_conntrack_lock);
-
-	helper = __nf_ct_helper_find(tuple);
-	if (helper) {
-		/* need to increase module usage count to assure helper will
-		 * not go away while the caller is e.g. busy putting a
-		 * conntrack in the hash that uses the helper */
-		if (!try_module_get(helper->me))
-			helper = NULL;
-	}
-
-	read_unlock_bh(&nf_conntrack_lock);
-
-	return helper;
-}
-
-void nf_ct_helper_put(struct nf_conntrack_helper *helper)
-{
-	module_put(helper->me);
-}
-
 static struct nf_conn *
 __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 		     const struct nf_conntrack_tuple *repl,
@@ -1036,83 +995,6 @@ int nf_ct_invert_tuplepr(struct nf_connt
 						     orig->dst.protonum));
 }
 
-int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
-{
-	int ret;
-	BUG_ON(me->timeout == 0);
-
-	ret = nf_conntrack_register_cache(NF_CT_F_HELP, "nf_conntrack:help",
-					  sizeof(struct nf_conn)
-					  + sizeof(struct nf_conn_help)
-					  + __alignof__(struct nf_conn_help));
-	if (ret < 0) {
-		printk(KERN_ERR "nf_conntrack_helper_reigster: Unable to create slab cache for conntracks\n");
-		return ret;
-	}
-	write_lock_bh(&nf_conntrack_lock);
-	list_add(&me->list, &helpers);
-	write_unlock_bh(&nf_conntrack_lock);
-
-	return 0;
-}
-
-struct nf_conntrack_helper *
-__nf_conntrack_helper_find_byname(const char *name)
-{
-	struct nf_conntrack_helper *h;
-
-	list_for_each_entry(h, &helpers, list) {
-		if (!strcmp(h->name, name))
-			return h;
-	}
-
-	return NULL;
-}
-
-static inline void unhelp(struct nf_conntrack_tuple_hash *i,
-			  const struct nf_conntrack_helper *me)
-{
-	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(i);
-	struct nf_conn_help *help = nfct_help(ct);
-
-	if (help && help->helper == me) {
-		nf_conntrack_event(IPCT_HELPER, ct);
-		help->helper = NULL;
-	}
-}
-
-void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
-{
-	unsigned int i;
-	struct nf_conntrack_tuple_hash *h;
-	struct nf_conntrack_expect *exp, *tmp;
-
-	/* Need write lock here, to delete helper. */
-	write_lock_bh(&nf_conntrack_lock);
-	list_del(&me->list);
-
-	/* Get rid of expectations */
-	list_for_each_entry_safe(exp, tmp, &nf_conntrack_expect_list, list) {
-		struct nf_conn_help *help = nfct_help(exp->master);
-		if (help->helper == me && del_timer(&exp->timeout)) {
-			nf_ct_unlink_expect(exp);
-			nf_conntrack_expect_put(exp);
-		}
-	}
-
-	/* Get rid of expecteds, set helpers to NULL. */
-	list_for_each_entry(h, &unconfirmed, list)
-		unhelp(h, me);
-	for (i = 0; i < nf_conntrack_htable_size; i++) {
-		list_for_each_entry(h, &nf_conntrack_hash[i], list)
-			unhelp(h, me);
-	}
-	write_unlock_bh(&nf_conntrack_lock);
-
-	/* Someone could be still looking at the helper in a bh. */
-	synchronize_net();
-}
-
 /* Refresh conntrack for this many jiffies and do accounting if do_acct is 1 */
 void __nf_ct_refresh_acct(struct nf_conn *ct,
 			  enum ip_conntrack_info ctinfo,
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_helper.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_helper.c	2006-11-01 18:05:43.000000000 +0100
@@ -0,0 +1,152 @@
+/* Helper handling for netfilter. */
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
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/vmalloc.h>
+#include <linux/stddef.h>
+#include <linux/slab.h>
+#include <linux/random.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_l3proto.h>
+#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_core.h>
+
+static LIST_HEAD(helpers);
+
+struct nf_conntrack_helper *
+__nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_helper *h;
+
+	list_for_each_entry(h, &helpers, list) {
+		if (nf_ct_tuple_mask_cmp(tuple, &h->tuple, &h->mask))
+			return h;
+	}
+	return NULL;
+}
+
+struct nf_conntrack_helper *
+nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_helper *helper;
+
+	/* need nf_conntrack_lock to assure that helper exists until
+	 * try_module_get() is called */
+	read_lock_bh(&nf_conntrack_lock);
+
+	helper = __nf_ct_helper_find(tuple);
+	if (helper) {
+		/* need to increase module usage count to assure helper will
+		 * not go away while the caller is e.g. busy putting a
+		 * conntrack in the hash that uses the helper */
+		if (!try_module_get(helper->me))
+			helper = NULL;
+	}
+
+	read_unlock_bh(&nf_conntrack_lock);
+
+	return helper;
+}
+
+void nf_ct_helper_put(struct nf_conntrack_helper *helper)
+{
+	module_put(helper->me);
+}
+
+struct nf_conntrack_helper *
+__nf_conntrack_helper_find_byname(const char *name)
+{
+	struct nf_conntrack_helper *h;
+
+	list_for_each_entry(h, &helpers, list) {
+		if (!strcmp(h->name, name))
+			return h;
+	}
+
+	return NULL;
+}
+
+static inline int unhelp(struct nf_conntrack_tuple_hash *i,
+			 const struct nf_conntrack_helper *me)
+{
+	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(i);
+	struct nf_conn_help *help = nfct_help(ct);
+
+	if (help && help->helper == me) {
+		nf_conntrack_event(IPCT_HELPER, ct);
+		help->helper = NULL;
+	}
+	return 0;
+}
+
+int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
+{
+	int ret;
+	BUG_ON(me->timeout == 0);
+
+	ret = nf_conntrack_register_cache(NF_CT_F_HELP, "nf_conntrack:help",
+					  sizeof(struct nf_conn)
+					  + sizeof(struct nf_conn_help)
+					  + __alignof__(struct nf_conn_help));
+	if (ret < 0) {
+		printk(KERN_ERR "nf_conntrack_helper_reigster: Unable to create slab cache for conntracks\n");
+		return ret;
+	}
+	write_lock_bh(&nf_conntrack_lock);
+	list_add(&me->list, &helpers);
+	write_unlock_bh(&nf_conntrack_lock);
+
+	return 0;
+}
+
+void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
+{
+	unsigned int i;
+	struct nf_conntrack_tuple_hash *h;
+	struct nf_conntrack_expect *exp, *tmp;
+
+	/* Need write lock here, to delete helper. */
+	write_lock_bh(&nf_conntrack_lock);
+	list_del(&me->list);
+
+	/* Get rid of expectations */
+	list_for_each_entry_safe(exp, tmp, &nf_conntrack_expect_list, list) {
+		struct nf_conn_help *help = nfct_help(exp->master);
+		if (help->helper == me && del_timer(&exp->timeout)) {
+			nf_ct_unlink_expect(exp);
+			nf_conntrack_expect_put(exp);
+		}
+	}
+
+	/* Get rid of expecteds, set helpers to NULL. */
+	list_for_each_entry(h, &unconfirmed, list)
+		unhelp(h, me);
+	for (i = 0; i < nf_conntrack_htable_size; i++) {
+		list_for_each_entry(h, &nf_conntrack_hash[i], list)
+			unhelp(h, me);
+	}
+	write_unlock_bh(&nf_conntrack_lock);
+
+	/* Someone could be still looking at the helper in a bh. */
+	synchronize_net();
+}
+
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/Makefile
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/Makefile	2006-11-01 18:03:10.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/Makefile	2006-11-01 18:05:35.000000000 +0100
@@ -1,5 +1,5 @@
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o
-nf_conntrack-objs	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o
+nf_conntrack-objs	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
 
Index: linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_core.h
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/include/net/netfilter/nf_conntrack_core.h	2006-11-01 18:03:10.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_core.h	2006-11-01 18:05:35.000000000 +0100
@@ -80,4 +80,6 @@ print_tuple(struct seq_file *s, const st
 extern struct list_head *nf_conntrack_hash;
 extern struct list_head nf_conntrack_expect_list;
 extern rwlock_t nf_conntrack_lock ;
+extern struct list_head unconfirmed;
+
 #endif /* _NF_CONNTRACK_CORE_H */

--
/Martin
