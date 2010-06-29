From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/56] netfilter: xtables2: initial chain skeletal functions
Date: Tue, 29 Jun 2010 10:42:46 +0200
Message-ID: <1277801017-30600-7-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44236 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab0F2Inp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:43:45 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   19 +++++++++++++++++++
 net/netfilter/x_tables.c           |   31 +++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 638ab33..a55d4a4 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -404,6 +404,19 @@ struct xt_table_info {
 	void *entries[1];
 };
 
+struct xt2_table;
+
+/**
+ * @anchor:	list anchor for parent (xt2_table.chain_list)
+ * @name:	name of chain
+ * @table:	back link to table chain is contained in
+ */
+struct xt2_chain {
+	struct list_head anchor;
+	char name[XT_EXTENSION_MAXNAMELEN];
+	struct xt2_table *table;
+};
+
 /**
  * For xt2_tlink_lookup/xt2_table_lookup:
  *
@@ -422,13 +435,17 @@ enum {
 };
 
 /**
+ * @chain_list:		list of chains (struct xt2_chain)
  * @name:		name of this table
  * @nfproto:		nfproto the table is used exclusively with
+ * @entrypoint:		start chains for hooks
  * @owner:		encompassing module
  */
 struct xt2_table {
+	struct list_head chain_list;
 	char name[11];
 	uint8_t nfproto;
+	const struct xt2_chain *entrypoint[NF_INET_NUMHOOKS];
 	struct module *owner;
 };
 
@@ -582,6 +599,8 @@ static inline unsigned long ifname_compare_aligned(const char *_a,
 extern struct nf_hook_ops *xt_hook_link(const struct xt_table *, nf_hookfn *);
 extern void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
 
+extern struct xt2_chain *xt2_chain_new(struct xt2_table *, const char *);
+
 extern struct xt2_table *xt2_table_new(void);
 extern struct xt2_table_link *xt2_tlink_lookup(struct net *, const char *,
 					       uint8_t, unsigned int);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 0bd6a6c..e807312 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1238,6 +1238,32 @@ void xt_hook_unlink(const struct xt_table *table, struct nf_hook_ops *ops)
 }
 EXPORT_SYMBOL_GPL(xt_hook_unlink);
 
+struct xt2_chain *xt2_chain_new(struct xt2_table *table, const char *name)
+{
+	struct xt2_chain *chain;
+
+	chain = kmalloc(sizeof(*chain), GFP_KERNEL);
+	if (chain == NULL)
+		return NULL;
+
+	chain->table = table;
+	INIT_LIST_HEAD(&chain->anchor);
+	if (name != NULL)
+		strncpy(chain->name, name, sizeof(chain->name));
+	else
+		chain->name[0] = '\0';
+	chain->name[sizeof(chain->name)-1] = '\0';
+	list_add_tail(&chain->anchor, &table->chain_list);
+	return chain;
+}
+EXPORT_SYMBOL_GPL(xt2_chain_new);
+
+static void xt2_chain_free(struct xt2_chain *chain)
+{
+	list_del(&chain->anchor);
+	kfree(chain);
+}
+
 struct xt2_table *xt2_table_new(void)
 {
 	struct xt2_table *table;
@@ -1246,6 +1272,7 @@ struct xt2_table *xt2_table_new(void)
 	if (table == NULL)
 		return NULL;
 
+	INIT_LIST_HEAD(&table->chain_list);
 	return table;
 }
 EXPORT_SYMBOL_GPL(xt2_table_new);
@@ -1369,9 +1396,13 @@ static void xt2_table_unregister(struct net *net, struct xt2_table *table)
 
 void xt2_table_destroy(struct net *net, struct xt2_table *table)
 {
+	struct xt2_chain *chain, *next_chain;
+
 	if (net != NULL)
 		xt2_table_unregister(net, table);
 
+	list_for_each_entry_safe(chain, next_chain, &table->chain_list, anchor)
+		xt2_chain_free(chain);
 	kfree(table);
 }
 EXPORT_SYMBOL_GPL(xt2_table_destroy);
-- 
1.7.1

