From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/56] netfilter: xtables2: initial rule skeletal functions
Date: Tue, 29 Jun 2010 10:42:47 +0200
Message-ID: <1277801017-30600-8-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44226 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab0F2Inq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:43:46 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
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
index a55d4a4..2d21185 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -407,12 +407,22 @@ struct xt_table_info {
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
 	char name[XT_EXTENSION_MAXNAMELEN];
 	struct xt2_table *table;
 };
@@ -439,6 +449,7 @@ enum {
  * @name:		name of this table
  * @nfproto:		nfproto the table is used exclusively with
  * @entrypoint:		start chains for hooks
+ * @underflow:		base chain policy (rule)
  * @owner:		encompassing module
  */
 struct xt2_table {
@@ -446,6 +457,7 @@ struct xt2_table {
 	char name[11];
 	uint8_t nfproto;
 	const struct xt2_chain *entrypoint[NF_INET_NUMHOOKS];
+	const struct xt2_rule *underflow[NF_INET_NUMHOOKS];
 	struct module *owner;
 };
 
@@ -599,7 +611,10 @@ static inline unsigned long ifname_compare_aligned(const char *_a,
 extern struct nf_hook_ops *xt_hook_link(const struct xt_table *, nf_hookfn *);
 extern void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
 
+extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
+
 extern struct xt2_chain *xt2_chain_new(struct xt2_table *, const char *);
+extern void xt2_chain_append(struct xt2_rule *);
 
 extern struct xt2_table *xt2_table_new(void);
 extern struct xt2_table_link *xt2_tlink_lookup(struct net *, const char *,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index e807312..f23195e 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1238,6 +1238,26 @@ void xt_hook_unlink(const struct xt_table *table, struct nf_hook_ops *ops)
 }
 EXPORT_SYMBOL_GPL(xt_hook_unlink);
 
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
@@ -1248,6 +1268,7 @@ struct xt2_chain *xt2_chain_new(struct xt2_table *table, const char *name)
 
 	chain->table = table;
 	INIT_LIST_HEAD(&chain->anchor);
+	INIT_LIST_HEAD(&chain->rule_list);
 	if (name != NULL)
 		strncpy(chain->name, name, sizeof(chain->name));
 	else
@@ -1258,9 +1279,23 @@ struct xt2_chain *xt2_chain_new(struct xt2_table *table, const char *name)
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
1.7.1

