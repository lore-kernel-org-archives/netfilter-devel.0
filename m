From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 059/103] netfilter: xtables2: table traversal
Date: Tue,  4 Aug 2009 09:25:43 +0200
Message-ID: <1249370787-17583-60-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56943 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589AbZHDH1g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:36 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    4 +
 net/netfilter/x_tables.c           |  115 ++++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index f94820c..0608e64 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -702,6 +702,10 @@ extern int xt2_table_register(struct net *, struct xt2_table *);
 extern struct xt2_table *xt2_table_replace(struct net *, struct xt2_table *);
 extern void xt2_table_destroy(struct net *, struct xt2_table *);
 
+extern unsigned int xt2_do_table(struct sk_buff *, unsigned int,
+	const struct net_device *, const struct net_device *,
+	const struct xt2_table *);
+
 static inline bool xt2_special_target(const struct xt_target *t)
 {
 	return IS_ERR(t);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 574d562..105039a 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -61,6 +61,17 @@ static struct xt_af *xt;
 #define duprintf(format, args...)
 #endif
 
+/***
+ * xt2 internal decisions -
+ *
+ * %XT_START_CHAIN:	used to implement jump/goto after chain got switched
+ */
+enum {
+	XT_START_CHAIN = 0xFFFFFFF9,
+	/* XT_RETURN   = 0xFFFFFFFB, */ /* reminder (x_tables.h) */
+	/* XT_CONTINUE = 0xFFFFFFFF, */ /* reminder (x_tables.h) */
+};
+
 static const char *const xt_prefix[NFPROTO_NUMPROTO] = {
 	[NFPROTO_UNSPEC] = "x",
 	[NFPROTO_IPV4]   = "ip",
@@ -1702,6 +1713,7 @@ struct xt2_table *xt2_table_replace(struct net *net, struct xt2_table *table)
 {
 	struct xt2_table_link *link;
 	struct xt2_table *old_table;
+	int ret;
 
 	if (*table->name == '\0')
 		return ERR_PTR(-EINVAL);
@@ -1710,6 +1722,11 @@ struct xt2_table *xt2_table_replace(struct net *net, struct xt2_table *table)
 	       XT2_TAKE_RCULOCK);
 	if (link == NULL)
 		return ERR_PTR(-ENOENT);
+	ret = xt2_jumpstack_alloc(table);
+	if (ret < 0) {
+		rcu_read_unlock();
+		return ERR_PTR(ret);
+	}
 
 	mutex_lock(&net->xt2.table_lock);
 	old_table = rcu_dereference(link->table);
@@ -1763,6 +1780,104 @@ void xt2_table_destroy(struct net *net, struct xt2_table *table)
 }
 EXPORT_SYMBOL_GPL(xt2_table_destroy);
 
+static unsigned int
+xt2_do_actions(struct sk_buff *skb, struct xt_action_param *acpar,
+               const struct xt2_rule *rule, const struct xt2_chain **chain_ptr,
+               unsigned int *stackptr, unsigned int stacksize,
+               const struct xt2_rule **jumpstack)
+{
+	const struct xt2_entry_target *etarget;
+	const struct xt2_entry_match *ematch;
+	/* For rules without targets: */
+	unsigned int verdict = XT_CONTINUE;
+	bool ret;
+
+	list_for_each_entry(ematch, &rule->match_list, anchor) {
+		acpar->match     = ematch->ext;
+		acpar->matchinfo = ematch->data;
+		ret = ematch->ext->match(skb, acpar);
+		if (acpar->hotdrop)
+			return NF_DROP;
+		else if (!ret)
+			return XT_CONTINUE;
+	}
+
+	list_for_each_entry(etarget, &rule->target_list, anchor) {
+		if (etarget->ext == XT2_ACTION_GOTO) {
+			*chain_ptr = etarget->r_goto;
+			return XT_START_CHAIN;
+		} else if (etarget->ext == XT2_ACTION_JUMP) {
+			if (*stackptr >= stacksize)
+				return NF_DROP;
+			jumpstack[(*stackptr)++] = rule;
+			*chain_ptr = etarget->r_jump;
+			return XT_START_CHAIN;
+		} else if (etarget->ext == XT2_FINAL_VERDICT) {
+			verdict = etarget->verdict;
+		} else {
+			acpar->target   = etarget->ext;
+			acpar->targinfo = etarget->data;
+			verdict = etarget->ext->target(skb, acpar);
+		}
+		if (verdict != XT_CONTINUE)
+			break;
+	}
+
+	return verdict;
+}
+
+unsigned int
+xt2_do_table(struct sk_buff *skb, unsigned int hook,
+             const struct net_device *in, const struct net_device *out,
+             const struct xt2_table *table)
+{
+	int cpu = smp_processor_id();
+	const struct xt2_rule **jumpstack = table->jumpstack[cpu];
+	unsigned int *stackptr = &table->stackptr[cpu];
+	unsigned int verdict = NF_DROP;
+	const struct xt2_chain *chain;
+	const struct xt2_rule *rule;
+	struct xt_action_param acpar = {
+		.family  = table->nfproto,
+		.in      = in,
+		.out     = out,
+		.hooknum = hook,
+	};
+
+	chain = table->entrypoint[hook];
+ do_chain:
+	rule = list_first_entry(&chain->rule_list, typeof(*rule), anchor);
+ do_rule:
+	if (&rule->anchor == &chain->rule_list)
+		/* End of chain */
+		verdict = XT_RETURN;
+	else
+		verdict = xt2_do_actions(skb, &acpar, rule, &chain,
+		          stackptr, table->stacksize, jumpstack);
+
+	switch (verdict) {
+	case XT_START_CHAIN:
+		goto do_chain;
+	case XT_RETURN:
+		if (*stackptr == 0) {
+			rule = table->underflow[hook];
+			chain = rule->chain;
+			goto do_rule;
+		}
+		/* What was on the stack was where we left... */
+		--*stackptr;
+		rule  = jumpstack[*stackptr];
+		chain = rule->chain;
+		/* ...fallthru to advance */
+	case XT_CONTINUE:
+		rule = list_entry(rule->anchor.next, typeof(*rule), anchor);
+		goto do_rule;
+	}
+
+	return verdict;
+}
+EXPORT_SYMBOL_GPL(xt2_do_table);
+
 int xt_proto_init(struct net *net, u_int8_t af)
 {
 #ifdef CONFIG_PROC_FS
-- 
1.6.3.3

