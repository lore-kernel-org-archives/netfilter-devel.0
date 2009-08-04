From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 056/103] netfilter: xtables2: per-rule target skeletal functions
Date: Tue,  4 Aug 2009 09:25:40 +0200
Message-ID: <1249370787-17583-57-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56942 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583AbZHDH1d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:33 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch also introduces the possibly to use multiple targets
in a rule, an often-wanted feature (such as -j LOG -j DROP).

Loop detection and Origin Tracing is not included here yet. xt1
modules, e.g. ip6_tables, will (continue to) do the loop checking and
"comefrom" marking for the time being.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   43 ++++++++++++++++++++++
 net/netfilter/x_tables.c           |   69 +++++++++++++++++++++++++++++++++++-
 2 files changed, 111 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index fbea89c..e71a84e 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -407,6 +407,14 @@ struct xt_table_info
 	void *entries[1];
 };
 
+/*
+ * The use of low negative numbers means we can use IS_ERR()
+ * (See xt2_special_target below.)
+ */
+#define XT2_ACTION_JUMP   ((const struct xt_target *)(-2))
+#define XT2_ACTION_GOTO   ((const struct xt_target *)(-3))
+#define XT2_FINAL_VERDICT ((const struct xt_target *)(-4))
+
 struct xt2_table;
 
 enum {
@@ -416,12 +424,14 @@ enum {
 /**
  * @anchor:		list anchor for parent (xt2_chain.rule_list)
  * @match_list:		list of called match extensions (xt2_entry_match)
+ * @target_list:	list of called target extensions (xt2_entry_targets)
  * @l4proto:		layer-4 protocol used (needed for xt_check_*)
  * @flags:		extra flags (see above)
  */
 struct xt2_rule {
 	struct list_head anchor;
 	struct list_head match_list;
+	struct list_head target_list;
 	struct xt2_chain *chain;
 	uint8_t l4proto, flags;
 };
@@ -440,6 +450,25 @@ struct xt2_entry_match {
 };
 
 /**
+ * @anchor:	list anchor for parent (xt2_rule.target_list)
+ * @ext:	pointer to extension
+ * @data:	parameter block for extension (aka. "targetinfo")
+ * @r_jump:	jump target; requires that @ext is %XT2_ACTION_JUMP
+ * @r_goto:	goto target; requires that @ext is %XT2_ACTION_GOTO
+ * @verdict:	final verdict (%XT_* or %NF_*);
+ * 		requires that @ext is %XT2_FINAL_VERDICT
+ */
+struct xt2_entry_target {
+	struct list_head anchor;
+	const struct xt_target *ext;
+	union {
+		void *data;
+		const struct xt2_chain *r_jump, *r_goto;
+		unsigned int verdict;
+	};
+};
+
+/**
  * @anchor:	list anchor for parent (xt2_table.chain_list)
  * @rule_list:	list of struct xt2_rule
  * @name:	name of chain
@@ -640,6 +669,8 @@ extern void *xt_repldata_create(const struct xt_table *);
 extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
 extern int xt2_rule_add_match(struct xt2_rule *, const char *, uint8_t,
 	const void *, unsigned int, bool);
+extern int xt2_rule_add_target(struct xt2_rule *, const char *, uint8_t,
+	const void *, unsigned int, bool);
 
 extern struct xt2_chain *xt2_chain_new(struct xt2_table *, const char *);
 extern void xt2_chain_append(struct xt2_rule *);
@@ -651,6 +682,11 @@ extern int xt2_table_register(struct net *, struct xt2_table *);
 extern struct xt2_table *xt2_table_replace(struct net *, struct xt2_table *);
 extern void xt2_table_destroy(struct net *, struct xt2_table *);
 
+static inline bool xt2_special_target(const struct xt_target *t)
+{
+	return IS_ERR(t);
+}
+
 static inline int
 xt2_rule_add_oldmatch(struct xt2_rule *rule, const struct xt_entry_match *m)
 {
@@ -658,6 +694,13 @@ xt2_rule_add_oldmatch(struct xt2_rule *rule, const struct xt_entry_match *m)
 	       m->data, m->u.match_size - sizeof(*m), true);
 }
 
+static inline int
+xt2_rule_add_oldtarget(struct xt2_rule *rule, const struct xt_entry_target *t)
+{
+	return xt2_rule_add_target(rule, t->u.user.name, t->u.user.revision,
+	       t->data, t->u.target_size - sizeof(*t), true);
+}
+
 static inline struct xt2_table *
 xt2_table_lookup(struct net *net, const char *name, uint8_t nfproto,
                  unsigned int lock_mask)
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 0d50942..1e57517 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1313,6 +1313,7 @@ struct xt2_rule *xt2_rule_new(struct xt2_chain *chain)
 	rule->chain = chain;
 	INIT_LIST_HEAD(&rule->anchor);
 	INIT_LIST_HEAD(&rule->match_list);
+	INIT_LIST_HEAD(&rule->target_list);
 	return rule;
 }
 EXPORT_SYMBOL_GPL(xt2_rule_new);
@@ -1412,14 +1413,80 @@ int xt2_rule_add_match(struct xt2_rule *rule, const char *ext_name,
 }
 EXPORT_SYMBOL_GPL(xt2_rule_add_match);
 
+int xt2_rule_add_target(struct xt2_rule *rule, const char *ext_name,
+                        uint8_t ext_rev, const void *data, unsigned int dsize,
+                        bool check_pad)
+{
+	const uint8_t nfproto = rule->chain->table->nfproto;
+	struct xt2_entry_target *etarget;
+	const struct xt_target *ext;
+	struct xt_tgchk_param tgpar;
+	int ret;
+
+	ext = try_then_request_module(xt_find_target(nfproto,
+	      ext_name, ext_rev), "%st_%s", xt_prefix[nfproto], ext_name);
+	if (ext == NULL)
+		return -ENOENT;
+	if (IS_ERR(ext))
+		return PTR_ERR(ext);
+
+	ret = -ENOMEM;
+	etarget = kmalloc(sizeof(*etarget), GFP_KERNEL);
+	if (etarget == NULL)
+		goto put_module;
+	etarget->ext  = ext;
+	etarget->data = kmemdup(data, dsize, GFP_KERNEL);
+	if (etarget->data == NULL)
+		goto free_etarget;
+
+	tgpar.table     = rule->chain->table->name;
+	tgpar.target    = ext;
+	tgpar.targinfo  = etarget->data;
+	tgpar.hook_mask = rule->chain->comefrom;
+	tgpar.family    = rule->chain->table->nfproto;
+	ret = xt_check_target(&tgpar, dsize, rule->l4proto,
+	      rule->flags & XT2_INV_L4PROTO, check_pad);
+	if (ret < 0)
+		goto free_edata;
+
+	INIT_LIST_HEAD(&etarget->anchor);
+	list_add_tail(&etarget->anchor, &rule->target_list);
+	return 0;
+
+ free_edata:
+	kfree(etarget->data);
+ free_etarget:
+	kfree(etarget);
+ put_module:
+	module_put(ext->me);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(xt2_rule_add_target);
+
 static void xt2_rule_free(struct xt2_rule *rule)
 {
+	struct xt2_entry_target *etarget, *next_etarget;
 	struct xt2_entry_match *ematch, *next_ematch;
 	struct xt_mtdtor_param mtpar;
+	struct xt_tgdtor_param tgpar;
 
-	mtpar.family = rule->chain->table->nfproto;
+	mtpar.family = tgpar.family = rule->chain->table->nfproto;
 	list_del(&rule->anchor);
 
+	list_for_each_entry_safe(etarget, next_etarget,
+	    &rule->target_list, anchor) {
+		list_del(&etarget->anchor);
+		if (!xt2_special_target(etarget->ext)) {
+			if (etarget->ext->destroy != NULL) {
+				tgpar.target   = etarget->ext;
+				tgpar.targinfo = etarget->data;
+				etarget->ext->destroy(&tgpar);
+			}
+			module_put(etarget->ext->me);
+			kfree(etarget->data);
+		}
+		kfree(etarget);
+	}
 	list_for_each_entry_safe(ematch, next_ematch,
 	    &rule->match_list, anchor) {
 		list_del(&ematch->anchor);
-- 
1.6.3.3

