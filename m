From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 052/103] netfilter: xtables2: initial rule skeletal functions
Date: Tue,  4 Aug 2009 09:25:36 +0200
Message-ID: <1249370787-17583-53-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56940 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580AbZHDH1a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:30 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Whereas iptables and its derivates (collectively, Xtables1) used a
serialized binary blob, Xtables2's internal layout will be linked
lists. This makes it possible to easily edit single rules later on
without userspace having to upload an entire table if it does not
want to.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   15 +++++++++++++++
 net/netfilter/x_tables.c           |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 5c9a034..5119768 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -410,12 +410,22 @@ struct xt_table_info
 struct xt2_table;
 
 /**
+ * @anchor:		list anchor for parent (xt2_chain.rule_list)
+ */
+struct xt2_rule {
+	struct list_head anchor;
+	struct xt2_chain *chain;
+};
+
+/**
  * @anchor:	list anchor for parent (xt2_table.chain_list)
+ * @rule_list:	list of struct xt2_rule
  * @name:	name of chain
  * @table:	back link to table chain is contained in
  */
 struct xt2_chain {
 	struct list_head anchor;
+	struct list_head rule_list;
 	char name[31];
 	struct xt2_table *table;
 };
@@ -438,6 +448,7 @@ enum {
  * @name:		name of this table
  * @nfproto:		nfproto the table is used exclusively with
  * @entrypoint:		start chains for hooks
+ * @underflow:		base chain policy (rule)
  * @owner:		encompassing module
  */
 struct xt2_table {
@@ -445,6 +456,7 @@ struct xt2_table {
 	char name[11];
 	uint8_t nfproto;
 	const struct xt2_chain *entrypoint[NF_INET_NUMHOOKS];
+	const struct xt2_rule *underflow[NF_INET_NUMHOOKS];
 	struct module *owner;
 };
 
@@ -598,7 +610,10 @@ extern struct nf_hook_ops *xt_hook_link(const struct xt_table *, nf_hookfn *);
 extern void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
 extern void *xt_repldata_create(const struct xt_table *);
 
+extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
+
 extern struct xt2_chain *xt2_chain_new(struct xt2_table *, const char *);
+extern void xt2_chain_append(struct xt2_rule *);
 
 extern struct xt2_table *xt2_table_new(void);
 extern struct xt2_table_link *xt2_tlink_lookup(struct net *, const char *,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index f2b0bc2..9e001c7 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1295,6 +1295,26 @@ void *xt_repldata_create(const struct xt_table *info)
 }
 EXPORT_SYMBOL_GPL(xt_repldata_create);
 
+struct xt2_rule *xt2_rule_new(struct xt2_chain *chain)
+{
+	struct xt2_rule *rule;
+
+	rule = kmalloc(sizeof(*rule), GFP_KERNEL);
+	if (rule == NULL)
+		return NULL;
+
+	rule->chain = chain;
+	INIT_LIST_HEAD(&rule->anchor);
+	return rule;
+}
+EXPORT_SYMBOL_GPL(xt2_rule_new);
+
+static void xt2_rule_free(struct xt2_rule *rule)
+{
+	list_del(&rule->anchor);
+	kfree(rule);
+}
+
 struct xt2_chain *xt2_chain_new(struct xt2_table *table, const char *name)
 {
 	struct xt2_chain *chain;
@@ -1305,6 +1325,7 @@ struct xt2_chain *xt2_chain_new(struct xt2_table *table, const char *name)
 
 	chain->table = table;
 	INIT_LIST_HEAD(&chain->anchor);
+	INIT_LIST_HEAD(&chain->rule_list);
 	if (name != NULL)
 		strncpy(chain->name, name, sizeof(chain->name));
 	else
@@ -1315,9 +1336,23 @@ struct xt2_chain *xt2_chain_new(struct xt2_table *table, const char *name)
 }
 EXPORT_SYMBOL_GPL(xt2_chain_new);
 
+/**
+ * Rules are completely constructed first before appending to the chain,
+ * to avoid incomplete rules being run through in xt2_do_action.
+ */
+void xt2_chain_append(struct xt2_rule *rule)
+{
+	list_add_tail(&rule->anchor, &rule->chain->rule_list);
+}
+EXPORT_SYMBOL_GPL(xt2_chain_append);
+
 static void xt2_chain_free(struct xt2_chain *chain)
 {
+	struct xt2_rule *rule, *next_rule;
+
 	list_del(&chain->anchor);
+	list_for_each_entry_safe(rule, next_rule, &chain->rule_list, anchor)
+		xt2_rule_free(rule);
 	kfree(chain);
 }
 
-- 
1.6.3.3

