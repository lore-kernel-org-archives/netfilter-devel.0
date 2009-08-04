From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 051/103] netfilter: xtables2: initial chain skeletal functions
Date: Tue,  4 Aug 2009 09:25:35 +0200
Message-ID: <1249370787-17583-52-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50631 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbZHDH12 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:28 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   19 +++++++++++++++++++
 net/netfilter/x_tables.c           |   31 +++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 35d137b..5c9a034 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -407,6 +407,19 @@ struct xt_table_info
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
+	char name[31];
+	struct xt2_table *table;
+};
+
 /**
  * For xt2_tlink_lookup/xt2_table_lookup:
  *
@@ -421,13 +434,17 @@ enum {
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
 
@@ -581,6 +598,8 @@ extern struct nf_hook_ops *xt_hook_link(const struct xt_table *, nf_hookfn *);
 extern void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
 extern void *xt_repldata_create(const struct xt_table *);
 
+extern struct xt2_chain *xt2_chain_new(struct xt2_table *, const char *);
+
 extern struct xt2_table *xt2_table_new(void);
 extern struct xt2_table_link *xt2_tlink_lookup(struct net *, const char *,
 	uint8_t, unsigned int);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 247285b..f2b0bc2 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1295,6 +1295,32 @@ void *xt_repldata_create(const struct xt_table *info)
 }
 EXPORT_SYMBOL_GPL(xt_repldata_create);
 
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
@@ -1303,6 +1329,7 @@ struct xt2_table *xt2_table_new(void)
 	if (table == NULL)
 		return NULL;
 
+	INIT_LIST_HEAD(&table->chain_list);
 	return table;
 }
 EXPORT_SYMBOL_GPL(xt2_table_new);
@@ -1426,9 +1453,13 @@ static void xt2_table_unregister(struct net *net, struct xt2_table *table)
 
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
1.6.3.3

