From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 050/103] netfilter: xtables2: initial table skeletal functions
Date: Tue,  4 Aug 2009 09:25:34 +0200
Message-ID: <1249370787-17583-51-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50630 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579AbZHDH11 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:27 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the xt2 table functions. Of course this does not do
anything useful yet, chain and rule support directly follow.

Locking is currently only done at the table level, and that should be
at this point given I seek to get it running with the iptables
interfaces first, which do not manipulate rules while a table is
live.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   50 ++++++++++++
 include/net/net_namespace.h        |    1 +
 include/net/netns/x_tables.h       |    6 ++
 net/netfilter/x_tables.c           |  145 +++++++++++++++++++++++++++++++++++-
 4 files changed, 201 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 62cce82..35d137b 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -407,6 +407,39 @@ struct xt_table_info
 	void *entries[1];
 };
 
+/**
+ * For xt2_tlink_lookup/xt2_table_lookup:
+ *
+ * %XT2_NO_RCULOCK:	Drop the RCU read lock after search. This is used for
+ * 			when the mutex is already held, or for basic
+ * 			presence-only checks.
+ * %XT2_TAKE_RCULOCK:	Just a mnemonic for !XT2_NO_RCULOCK.
+ */
+enum {
+	XT2_NO_RCULOCK   = 1 << 0,
+	XT2_TAKE_RCULOCK = 0,
+};
+
+/**
+ * @name:		name of this table
+ * @nfproto:		nfproto the table is used exclusively with
+ * @owner:		encompassing module
+ */
+struct xt2_table {
+	char name[11];
+	uint8_t nfproto;
+	struct module *owner;
+};
+
+/**
+ * We need this as a permanent anchor point for external pointers, e.g.
+ * netns->xt2.ipv6_filter, or whatever else holds a pointer to a table.
+ */
+struct xt2_table_link {
+	struct list_head anchor;
+	struct xt2_table *table;
+};
+
 #define XT_TABLE_INFO_SZ (offsetof(struct xt_table_info, entries) \
 			  + nr_cpu_ids * sizeof(char *))
 extern int xt_register_target(struct xt_target *target);
@@ -548,6 +581,23 @@ extern struct nf_hook_ops *xt_hook_link(const struct xt_table *, nf_hookfn *);
 extern void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
 extern void *xt_repldata_create(const struct xt_table *);
 
+extern struct xt2_table *xt2_table_new(void);
+extern struct xt2_table_link *xt2_tlink_lookup(struct net *, const char *,
+	uint8_t, unsigned int);
+extern int xt2_table_register(struct net *, struct xt2_table *);
+extern struct xt2_table *xt2_table_replace(struct net *, struct xt2_table *);
+extern void xt2_table_destroy(struct net *, struct xt2_table *);
+
+static inline struct xt2_table *
+xt2_table_lookup(struct net *net, const char *name, uint8_t nfproto,
+                 unsigned int lock_mask)
+{
+	struct xt2_table_link *link;
+
+	link = xt2_tlink_lookup(net, name, nfproto, lock_mask);
+	return (link != NULL) ? link->table : NULL;
+}
+
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index ded434b..dc15df8 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -71,6 +71,7 @@ struct net {
 #endif
 #ifdef CONFIG_NETFILTER
 	struct netns_xt		xt;
+	struct netns_xt2	xt2;
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	struct netns_ct		ct;
 #endif
diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.h
index 9554a64..f2edc37 100644
--- a/include/net/netns/x_tables.h
+++ b/include/net/netns/x_tables.h
@@ -12,4 +12,10 @@ struct netns_xt {
 	struct ebt_table *frame_filter;
 	struct ebt_table *frame_nat;
 };
+
+struct netns_xt2 {
+	struct mutex table_lock;
+	struct list_head table_list[NFPROTO_NUMPROTO];
+};
+
 #endif
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 9ee6770..247285b 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -17,6 +17,7 @@
 #include <linux/socket.h>
 #include <linux/net.h>
 #include <linux/proc_fs.h>
+#include <linux/rcupdate.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
@@ -1294,6 +1295,144 @@ void *xt_repldata_create(const struct xt_table *info)
 }
 EXPORT_SYMBOL_GPL(xt_repldata_create);
 
+struct xt2_table *xt2_table_new(void)
+{
+	struct xt2_table *table;
+
+	table = kzalloc(sizeof(*table), GFP_KERNEL);
+	if (table == NULL)
+		return NULL;
+
+	return table;
+}
+EXPORT_SYMBOL_GPL(xt2_table_new);
+
+/**
+ * @net:	Netspace to search in
+ * @name:
+ * @table:	Name/nfproto to search for
+ * @lock_mask:	Locking instructions (%XT2_GET_MODULE, %XT2_NO_RCULOCK)
+ */
+struct xt2_table_link *
+xt2_tlink_lookup(struct net *net, const char *name, uint8_t nfproto,
+                 unsigned int lock_mask)
+{
+	struct xt2_table_link *link;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(link, &net->xt2.table_list[nfproto], anchor) {
+		if (strcmp(link->table->name, name) != 0)
+			continue;
+		if (lock_mask & XT2_NO_RCULOCK)
+			rcu_read_unlock();
+		return link;
+	}
+	rcu_read_unlock();
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(xt2_tlink_lookup);
+
+int xt2_table_register(struct net *net, struct xt2_table *table)
+{
+	struct xt2_table_link *link;
+	int ret = 0;
+
+	if (*table->name == '\0')
+		/* Empty names don't fly with our strcmp. */
+		return -EINVAL;
+
+	mutex_lock(&net->xt2.table_lock);
+	if (xt2_table_lookup(net, table->name,
+	    table->nfproto, XT2_NO_RCULOCK) != NULL) {
+		ret = -EEXIST;
+		goto out;
+	}
+
+	link = kmalloc(sizeof(*link), GFP_KERNEL);
+	if (link == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	INIT_LIST_HEAD(&link->anchor);
+	link->table = table;
+	list_add_tail_rcu(&link->anchor, &net->xt2.table_list[table->nfproto]);
+ out:
+	mutex_unlock(&net->xt2.table_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(xt2_table_register);
+
+/**
+ * @net:	accompanying net namespace
+ * @table:	new table
+ *
+ * Replace existing table by a new one. The old one is found by scanning the
+ * list for a table with the same name as the new one.
+ * The old table is disconnected from its net namespace and hence, one must
+ * pass %NULL for the first argument to xt2_table_destroy for tables returned
+ * by xt2_table_replace.
+ */
+struct xt2_table *xt2_table_replace(struct net *net, struct xt2_table *table)
+{
+	struct xt2_table_link *link;
+	struct xt2_table *old_table;
+
+	if (*table->name == '\0')
+		return ERR_PTR(-EINVAL);
+
+	link = xt2_tlink_lookup(net, table->name, table->nfproto,
+	       XT2_TAKE_RCULOCK);
+	if (link == NULL)
+		return ERR_PTR(-ENOENT);
+
+	mutex_lock(&net->xt2.table_lock);
+	old_table = rcu_dereference(link->table);
+	rcu_assign_pointer(link->table, table);
+	mutex_unlock(&net->xt2.table_lock);
+	rcu_read_unlock();
+	synchronize_rcu();
+	return old_table;
+}
+EXPORT_SYMBOL_GPL(xt2_table_replace);
+
+/**
+ * Unlink a table from the list of known tables. Synchronize RCU so that when
+ * execution in the caller xt2_table_destroy continues, it can free the table
+ * without worry.
+ */
+static void xt2_table_unregister(struct net *net, struct xt2_table *table)
+{
+	struct xt2_table_link *link;
+
+	if (*table->name == '\0')
+		return;
+
+	mutex_lock(&net->xt2.table_lock);
+	link = xt2_tlink_lookup(net, table->name, table->nfproto,
+	       XT2_NO_RCULOCK);
+	if (link == NULL) {
+		pr_warning("%s: table %s not found in netns?!\n",
+			__func__, table->name);
+		mutex_unlock(&net->xt2.table_lock);
+		return;
+	}
+	list_del_rcu(&link->anchor);
+	mutex_unlock(&net->xt2.table_lock);
+	synchronize_rcu();
+	link->table = (void *)NETFILTER_LINK_POISON;
+	kfree(link);
+}
+
+void xt2_table_destroy(struct net *net, struct xt2_table *table)
+{
+	if (net != NULL)
+		xt2_table_unregister(net, table);
+
+	kfree(table);
+}
+EXPORT_SYMBOL_GPL(xt2_table_destroy);
+
 int xt_proto_init(struct net *net, u_int8_t af)
 {
 #ifdef CONFIG_PROC_FS
@@ -1370,8 +1509,12 @@ static int __net_init xt_net_init(struct net *net)
 {
 	int i;
 
-	for (i = 0; i < NFPROTO_NUMPROTO; i++)
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
 		INIT_LIST_HEAD(&net->xt.tables[i]);
+		INIT_LIST_HEAD(&net->xt2.table_list[i]);
+	}
+
+	mutex_init(&net->xt2.table_lock);
 	return 0;
 }
 
-- 
1.6.3.3

