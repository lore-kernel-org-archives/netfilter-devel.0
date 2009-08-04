From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 055/103] netfilter: xtables2: per-rule match skeletal functions
Date: Tue,  4 Aug 2009 09:25:39 +0200
Message-ID: <1249370787-17583-56-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56943 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578AbZHDH1d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:33 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Notes: In xt2 rules, the layer-2/3 match structure (e.g. struct
ip6t_ip6) is now a standalone entry_match, together with the
recently-transformed layer-2/3 matches.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   34 +++++++++++
 net/netfilter/x_tables.c           |  116 ++++++++++++++++++++++++++++++++++++
 2 files changed, 150 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 8addd6f..fbea89c 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -409,12 +409,34 @@ struct xt_table_info
 
 struct xt2_table;
 
+enum {
+	XT2_INV_L4PROTO = 1 << 0,
+};
+
 /**
  * @anchor:		list anchor for parent (xt2_chain.rule_list)
+ * @match_list:		list of called match extensions (xt2_entry_match)
+ * @l4proto:		layer-4 protocol used (needed for xt_check_*)
+ * @flags:		extra flags (see above)
  */
 struct xt2_rule {
 	struct list_head anchor;
+	struct list_head match_list;
 	struct xt2_chain *chain;
+	uint8_t l4proto, flags;
+};
+
+/**
+ * @anchor:	list anchor for parent (xt2_rule.match_list)
+ * @ext:	pointer to extension
+ * @data:	parameter block for extension (aka. "matchinfo")
+ * @dsize:	size of @data (since @ext->matchsize may be -1)
+ */
+struct xt2_entry_match {
+	struct list_head anchor;
+	const struct xt_match *ext;
+	void *data;
+	unsigned int dsize;
 };
 
 /**
@@ -422,12 +444,15 @@ struct xt2_rule {
  * @rule_list:	list of struct xt2_rule
  * @name:	name of chain
  * @table:	back link to table chain is contained in
+ * @comefrom:	bitmask from which hooks the chain is entered
+ * 		(currently needed for xt_check_*)
  */
 struct xt2_chain {
 	struct list_head anchor;
 	struct list_head rule_list;
 	char name[31];
 	struct xt2_table *table;
+	unsigned int comefrom;
 };
 
 /**
@@ -613,6 +638,8 @@ extern void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
 extern void *xt_repldata_create(const struct xt_table *);
 
 extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
+extern int xt2_rule_add_match(struct xt2_rule *, const char *, uint8_t,
+	const void *, unsigned int, bool);
 
 extern struct xt2_chain *xt2_chain_new(struct xt2_table *, const char *);
 extern void xt2_chain_append(struct xt2_rule *);
@@ -624,6 +651,13 @@ extern int xt2_table_register(struct net *, struct xt2_table *);
 extern struct xt2_table *xt2_table_replace(struct net *, struct xt2_table *);
 extern void xt2_table_destroy(struct net *, struct xt2_table *);
 
+static inline int
+xt2_rule_add_oldmatch(struct xt2_rule *rule, const struct xt_entry_match *m)
+{
+	return xt2_rule_add_match(rule, m->u.user.name, m->u.user.revision,
+	       m->data, m->u.match_size - sizeof(*m), true);
+}
+
 static inline struct xt2_table *
 xt2_table_lookup(struct net *net, const char *name, uint8_t nfproto,
                  unsigned int lock_mask)
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 3906dfb..0d50942 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1308,15 +1308,131 @@ struct xt2_rule *xt2_rule_new(struct xt2_chain *chain)
 	if (rule == NULL)
 		return NULL;
 
+	rule->l4proto = 0;
+	rule->flags = 0;
 	rule->chain = chain;
 	INIT_LIST_HEAD(&rule->anchor);
+	INIT_LIST_HEAD(&rule->match_list);
 	return rule;
 }
 EXPORT_SYMBOL_GPL(xt2_rule_new);
 
+/**
+ * Find the struct ip6t_ip6 from an xt2 rule. Compat needs this, for now.
+ * Returns %NULL if not found.
+ */
+static void *xt2_entryinfo_mt_get(const struct xt2_rule *rule)
+{
+	const struct xt2_entry_match *ematch;
+
+	if (list_empty(&rule->match_list))
+		return NULL;
+	ematch = list_first_entry(&rule->match_list, typeof(*ematch), anchor);
+
+	/* The entryinfo is always in first place in xt1-compat mode. */
+	switch (rule->chain->table->nfproto) {
+	case NFPROTO_IPV4:
+		if (strcmp(ematch->ext->name, "ipv4") != 0)
+			return NULL;
+		break;
+	case NFPROTO_IPV6:
+		if (strcmp(ematch->ext->name, "ipv6") != 0)
+			return NULL;
+		break;
+	case NFPROTO_ARP:
+		if (strcmp(ematch->ext->name, "arp") != 0)
+			return NULL;
+		break;
+	case NFPROTO_BRIDGE:
+		if (strcmp(ematch->ext->name, "eth") != 0)
+			return NULL;
+		break;
+	default:
+		return NULL;
+	}
+
+	return ematch->data;
+}
+
+/**
+ * @ext_name:	name of extension
+ * @ext_rev:	requested revision
+ * @data:	private extension data block (parameters, etc.)
+ * @dsize:	size of supplied data
+ */
+int xt2_rule_add_match(struct xt2_rule *rule, const char *ext_name,
+                       uint8_t ext_rev, const void *data, unsigned int dsize,
+                       bool check_pad)
+{
+	const uint8_t nfproto = rule->chain->table->nfproto;
+	struct xt2_entry_match *ematch;
+	struct xt_mtchk_param mtpar;
+	const struct xt_match *ext;
+	int ret;
+
+	ext = try_then_request_module(xt_find_match(nfproto,
+	      ext_name, ext_rev), "%st_%s", xt_prefix[nfproto], ext_name);
+	if (ext == NULL)
+		return -ENOENT;
+	if (IS_ERR(ext))
+		return PTR_ERR(ext);
+
+	ret = -ENOMEM;
+	ematch = kmalloc(sizeof(*ematch), GFP_KERNEL);
+	if (ematch == NULL)
+		goto put_module;
+	ematch->ext   = ext;
+	ematch->data  = kmemdup(data, dsize, GFP_KERNEL);
+	ematch->dsize = dsize;
+	if (ematch->data == NULL)
+		goto free_ematch;
+
+	mtpar.table     = rule->chain->table->name;
+	mtpar.match     = ext;
+	mtpar.matchinfo = ematch->data;
+	mtpar.hook_mask = rule->chain->comefrom;
+	mtpar.family    = rule->chain->table->nfproto;
+	mtpar.entryinfo = xt2_entryinfo_mt_get(rule);
+	ret = xt_check_match(&mtpar, dsize, rule->l4proto,
+	      rule->flags & XT2_INV_L4PROTO, check_pad);
+	if (ret < 0)
+		goto free_edata;
+
+	INIT_LIST_HEAD(&ematch->anchor);
+	list_add_tail(&ematch->anchor, &rule->match_list);
+	return 0;
+
+ free_edata:
+	kfree(ematch->data);
+ free_ematch:
+	kfree(ematch);
+ put_module:
+	module_put(ext->me);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(xt2_rule_add_match);
+
 static void xt2_rule_free(struct xt2_rule *rule)
 {
+	struct xt2_entry_match *ematch, *next_ematch;
+	struct xt_mtdtor_param mtpar;
+
+	mtpar.family = rule->chain->table->nfproto;
 	list_del(&rule->anchor);
+
+	list_for_each_entry_safe(ematch, next_ematch,
+	    &rule->match_list, anchor) {
+		list_del(&ematch->anchor);
+		/* Note: ematch->ext is never NULL. */
+		if (ematch->ext->destroy != NULL) {
+			mtpar.match     = ematch->ext;
+			mtpar.matchinfo = ematch->data;
+			ematch->ext->destroy(&mtpar);
+		}
+		module_put(ematch->ext->me);
+		kfree(ematch->data);
+		kfree(ematch);
+	}
 	kfree(rule);
 }
 
-- 
1.6.3.3

