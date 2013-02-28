From: pablo@netfilter.org
Subject: [PATCH 1/2] netfilter: nf_tables: partially rework commit and abort operation
Date: Fri,  1 Mar 2013 00:08:17 +0100
Message-ID: <1362092898-23306-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33351 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464Ab3B1XIe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:08:34 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch partially reworks the commit operation (added in 1577831)
to get rid of the extra struct list_head per rule as discussed with
Patrick McHardy.

With this patch, a temporary object is allocated to store the rule
update information.

The commit and abort loops have been also simplified from ideas
extracted after discusion with Tomasz Bursztyka. Basically, there
is a single list per net namespace that contains pending rule
updates.

The dirty list is now owned by the netlink socket portid that adds
the first rule that waits to be committed. If another socket is
open to add a rule-set in an atomic fashion, it will hit -EBUSY.
Note that pending updates, if not committed, are destroyed on
socket removal.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   21 ++++-
 include/net/netns/nftables.h      |    2 +
 net/netfilter/nf_tables_api.c     |  185 +++++++++++++++++++++++++------------
 3 files changed, 145 insertions(+), 63 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3782777..69cb5ea 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -321,7 +321,6 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
  *	struct nft_rule - nf_tables rule
  *
  *	@list: used internally
- *	@dirty_list: this rule needs an update after new generation
  *	@rcu_head: used internally for rcu
  *	@handle: rule handle
  *	@genmask: generation mask
@@ -330,7 +329,6 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
  */
 struct nft_rule {
 	struct list_head		list;
-	struct list_head		dirty_list;
 	struct rcu_head			rcu_head;
 	u64				handle:46,
 					genmask:2,
@@ -339,6 +337,23 @@ struct nft_rule {
 		__attribute__((aligned(__alignof__(struct nft_expr))));
 };
 
+/**
+ *	struct nft_rule_update - nf_tables rule update
+ *
+ *	@list: used internally
+ *	@rule: rule that needs to be updated
+ *	@chain: chain that this rule belongs to
+ *	@table: table for which this chain applies
+ *	@net: the net namespace that this rule updates belongs to
+ */
+struct nft_rule_update {
+	struct list_head		list;
+	struct nft_rule			*rule;
+	const struct nft_chain		*chain;
+	const struct nft_table		*table;
+	struct net			*net;
+};
+
 static inline struct nft_expr *nft_expr_first(const struct nft_rule *rule)
 {
 	return (struct nft_expr *)&rule->data[0];
@@ -372,7 +387,6 @@ enum nft_chain_flags {
  *	struct nft_chain - nf_tables chain
  *
  *	@rules: list of rules in the chain
- *	@dirty_rules: rules that need an update after next generation
  *	@list: used internally
  *	@rcu_head: used internally
  *	@net: net namespace that this chain belongs to
@@ -385,7 +399,6 @@ enum nft_chain_flags {
  */
 struct nft_chain {
 	struct list_head		rules;
-	struct list_head		dirty_rules;
 	struct list_head		list;
 	struct rcu_head			rcu_head;
 	struct net			*net;
diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index fe919c7..97992fb 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -10,6 +10,8 @@ struct netns_nftables {
 	struct nft_af_info	*ipv4;
 	struct nft_af_info	*ipv6;
 	struct nft_af_info	*bridge;
+	u32			pid_owner;
+	struct list_head	dirty_rules;
 	u8			gencursor:1,
 				genctr:7;
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 40d94e2..beace28 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -961,7 +961,6 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	INIT_LIST_HEAD(&chain->rules);
-	INIT_LIST_HEAD(&chain->dirty_rules);
 	chain->handle = nf_tables_alloc_handle(table);
 	chain->net = net;
 	chain->table = table;
@@ -1510,6 +1509,29 @@ static void nf_tables_rule_destroy(struct nft_rule *rule)
 
 static struct nft_expr_info *info;
 
+static int nf_tables_dirty_add(struct nft_rule *rule, const struct nft_ctx *ctx)
+{
+	struct nft_rule_update *rupd;
+
+	/* Another socket owns the dirty list? */
+	if (!ctx->net->nft.pid_owner)
+		ctx->net->nft.pid_owner = ctx->nlh->nlmsg_pid;
+	else if (ctx->net->nft.pid_owner != ctx->nlh->nlmsg_pid)
+		return -EBUSY;
+
+	rupd = kmalloc(sizeof(struct nft_rule_update), GFP_KERNEL);
+	if (rupd == NULL)
+		return -ENOMEM;
+
+	rupd->chain = ctx->chain;
+	rupd->table = ctx->table;
+	rupd->rule = rule;
+	rupd->net = ctx->net;
+	list_add(&rupd->list, &ctx->net->nft.dirty_rules);
+
+	return 0;
+}
+
 static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 			     const struct nlmsghdr *nlh,
 			     const struct nlattr * const nla[])
@@ -1619,9 +1641,13 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	else
 		list_add_rcu(&rule->list, &chain->rules);
 
-	if (flags & NFT_RULE_F_COMMIT)
-		list_add(&rule->dirty_list, &chain->dirty_rules);
-	else {
+	if (flags & NFT_RULE_F_COMMIT) {
+		err = nf_tables_dirty_add(rule, &ctx);
+		if (err < 0) {
+			list_del_rcu(&rule->list);
+			goto err2;
+		}
+	} else {
 		nf_tables_rule_notify(skb, nlh, table, chain, rule,
 				      NFT_MSG_NEWRULE,
 				      nlh->nlmsg_flags & (NLM_F_APPEND | NLM_F_REPLACE),
@@ -1639,14 +1665,19 @@ err1:
 	return err;
 }
 
-static void
+static int
 nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule, u32 flags)
 {
+	int ret = 0;
+
 	if (flags & NFT_RULE_F_COMMIT) {
-		struct nft_chain *chain = (struct nft_chain *)ctx->chain;
+		/* Will be deleted already in the next generation */
+		if (!nft_rule_is_active_next(ctx->net, rule))
+			return -EBUSY;
 
-		nft_rule_disactivate_next(ctx->net, rule);
-		list_add(&rule->dirty_list, &chain->dirty_rules);
+		ret = nf_tables_dirty_add(rule, ctx);
+		if (ret >= 0)
+			nft_rule_disactivate_next(ctx->net, rule);
 	} else {
 		list_del_rcu(&rule->list);
 		nf_tables_rule_notify(ctx->skb, ctx->nlh, ctx->table,
@@ -1654,6 +1685,7 @@ nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule, u32 flags)
 				      0, ctx->afi->family);
 		nf_tables_rule_destroy(rule);
 	}
+	return ret;
 }
 
 static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
@@ -1666,7 +1698,7 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	const struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_rule *rule, *tmp;
-	int family = nfmsg->nfgen_family;
+	int family = nfmsg->nfgen_family, err;
 	struct nft_ctx ctx;
 	u32 flags = 0;
 
@@ -1696,7 +1728,9 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 		if (IS_ERR(rule))
 			return PTR_ERR(rule);
 
-		nf_tables_delrule_one(&ctx, rule, flags);
+		err = nf_tables_delrule_one(&ctx, rule, flags);
+		if (err < 0)
+			return err;
 	} else {
 		/* Remove all rules in this chain */
 		list_for_each_entry_safe(rule, tmp, &chain->rules, list)
@@ -1713,12 +1747,14 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	const struct nft_af_info *afi;
 	struct net *net = sock_net(skb->sk);
-	struct nft_table *table;
-	struct nft_chain *chain;
-	struct nft_rule *rule, *tmp;
+	struct nft_rule_update *rupd, *tmp;
 	int family = nfmsg->nfgen_family;
 	bool create;
 
+	/* Are you the owner of the dirty list? */
+	if (nlh->nlmsg_pid != net->nft.pid_owner)
+		return -EBUSY;
+
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
 	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
@@ -1736,40 +1772,60 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 	 */
 	synchronize_rcu();
 
-	list_for_each_entry(table, &afi->tables, list) {
-		list_for_each_entry(chain, &table->chains, list) {
-			list_for_each_entry_safe(rule, tmp, &chain->dirty_rules, dirty_list) {
-				/* Delete this rule from the dirty list */
-				list_del(&rule->dirty_list);
-
-				/* This rule was inactive in the past and just
-				 * became active. Clear the next bit of the
-				 * genmask since its meaning has changed, now
-				 * it is the future.
-				 */
-				if (nft_rule_is_active(net, rule)) {
-					nft_rule_clear(net, rule);
-					nf_tables_rule_notify(skb, nlh, table,
-							      chain, rule,
-							      NFT_MSG_NEWRULE,
-							      0,
-							      nfmsg->nfgen_family);
-					continue;
-				}
+	list_for_each_entry_safe(rupd, tmp, &net->nft.dirty_rules, list) {
+		/* Delete this rule from the dirty list */
+		list_del(&rupd->list);
 
-				/* This rule is in the past, get rid of it */
-				list_del_rcu(&rule->list);
-				nf_tables_rule_notify(skb, nlh, table, chain,
-						      rule, NFT_MSG_DELRULE, 0,
-						      family);
-				nf_tables_rule_destroy(rule);
-			}
+		/* This rule was inactive in the past and just became active.
+		 * Clear the next bit of the genmask since its meaning has
+		 * changed, now it is the future.
+		 */
+		if (nft_rule_is_active(net, rupd->rule)) {
+			nft_rule_clear(net, rupd->rule);
+			nf_tables_rule_notify(skb, nlh, rupd->table,
+					      rupd->chain, rupd->rule,
+					      NFT_MSG_NEWRULE, 0,
+					      nfmsg->nfgen_family);
+			kfree(rupd);
+			continue;
 		}
+
+		/* This rule is in the past, get rid of it */
+		list_del_rcu(&rupd->rule->list);
+		nf_tables_rule_notify(skb, nlh, rupd->table, rupd->chain,
+				      rupd->rule, NFT_MSG_DELRULE, 0, family);
+		nf_tables_rule_destroy(rupd->rule);
+		kfree(rupd);
 	}
+	/* Clear owner of this dirty list */
+	net->nft.pid_owner = 0;
 
 	return 0;
 }
 
+static void nf_tables_abort_all(struct net *net)
+{
+	struct nft_rule_update *rupd, *tmp;
+
+	list_for_each_entry_safe(rupd, tmp, &net->nft.dirty_rules, list) {
+		/* Delete all rules from the dirty list */
+		list_del(&rupd->list);
+
+		if (!nft_rule_is_active_next(rupd->net, rupd->rule)) {
+			nft_rule_clear(rupd->net, rupd->rule);
+			kfree(rupd);
+			return;
+		}
+
+		/* This rule is inactive, get rid of it */
+		list_del_rcu(&rupd->rule->list);
+		nf_tables_rule_destroy(rupd->rule);
+		kfree(rupd);
+	}
+	/* Clear the owner of the dirty list */
+	net->nft.pid_owner = 0;
+}
+
 static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
 			   const struct nlmsghdr *nlh,
 			   const struct nlattr * const nla[])
@@ -1777,37 +1833,44 @@ static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	const struct nft_af_info *afi;
 	struct net *net = sock_net(skb->sk);
-	struct nft_table *table;
-	struct nft_chain *chain;
-	struct nft_rule *rule, *tmp;
 	bool create;
 
+	/* Are you the owner of the dirty list? */
+	if (nlh->nlmsg_pid != net->nft.pid_owner)
+		return -EBUSY;
+
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
 	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	list_for_each_entry(table, &afi->tables, list) {
-		list_for_each_entry(chain, &table->chains, list) {
-			list_for_each_entry_safe(rule, tmp, &chain->dirty_rules, dirty_list) {
-				/* Delete all rules from the dirty list */
-				list_del(&rule->dirty_list);
-
-				if (!nft_rule_is_active_next(net, rule)) {
-					nft_rule_clear(net, rule);
-					continue;
-				}
+	nf_tables_abort_all(net);
 
-				/* This rule is inactive, get rid of it */
-				list_del_rcu(&rule->list);
-				nf_tables_rule_destroy(rule);
-			}
-		}
-	}
 	return 0;
 }
 
+static int
+nf_tables_rcv_nl_event(struct notifier_block *this,
+		       unsigned long event, void *ptr)
+{
+	struct netlink_notify *n = ptr;
+
+	if (event != NETLINK_URELEASE || n->protocol != NETLINK_NETFILTER)
+		return NOTIFY_DONE;
+
+	if (n->portid != n->net->nft.pid_owner)
+		return NOTIFY_DONE;
+
+	nf_tables_abort_all(n->net);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block nf_tables_notifier = {
+	.notifier_call	= nf_tables_rcv_nl_event,
+};
+
 /*
  * Sets
  */
@@ -3156,6 +3219,7 @@ EXPORT_SYMBOL_GPL(nft_data_dump);
 static int nf_tables_init_net(struct net *net)
 {
 	INIT_LIST_HEAD(&net->nft.af_info);
+	INIT_LIST_HEAD(&net->nft.dirty_rules);
 	return 0;
 }
 
@@ -3182,6 +3246,8 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		goto err3;
 
+	netlink_register_notifier(&nf_tables_notifier);
+
 	pr_info("nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>\n");
 	return register_pernet_subsys(&nf_tables_net_ops);
 err3:
@@ -3195,6 +3261,7 @@ err1:
 static void __exit nf_tables_module_exit(void)
 {
 	unregister_pernet_subsys(&nf_tables_net_ops);
+	netlink_unregister_notifier(&nf_tables_notifier);
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
 	nf_tables_core_module_exit();
 	kfree(info);
-- 
1.7.10.4

