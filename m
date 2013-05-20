From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC 2/2] netfilter: nf_tables: improvements for the existing transaction approach
Date: Mon, 20 May 2013 15:00:43 +0200
Message-ID: <1369054843-14591-2-git-send-email-pablo@netfilter.org>
References: <1369054843-14591-1-git-send-email-pablo@netfilter.org>
Cc: tomasz.bursztyka@linux.intel.com, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47798 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab3ETNA5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 May 2013 09:00:57 -0400
In-Reply-To: <1369054843-14591-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* One transaction comes in one batch packet composed of several
  netlink messages from user-space.

* All rule updates are handled as transactions.

* No need for explicit begin, commit and abort commands.

* Get rid of the extra struct list_head per rule: a temporary
  object is allocated to store the rule update information.

* There is a single list per net namespace that contains pending
  rule updates.

* The transaction list is now owned by the netlink socket portid
  that adds the first rule that waits to be committed. If another
  process wants to perform some rule-set update, it hits -EBUSY.
  Chances to hit this are low, as it is limited to the time that
  is required to process a batch.

Thanks to Patrick McHardy and Tomasz Burstyka for feedback and
brainstorming on this patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h      |    1 +
 include/net/netfilter/nf_tables.h        |   21 ++-
 include/net/netns/nftables.h             |    2 +
 include/uapi/linux/netfilter/nf_tables.h |    8 --
 net/netfilter/nf_tables_api.c            |  223 ++++++++++++------------------
 5 files changed, 111 insertions(+), 144 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 4966dde..b719fa8 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -22,6 +22,7 @@ struct nfnetlink_subsystem {
 	const char *name;
 	__u8 subsys_id;			/* nfnetlink subsystem ID */
 	__u8 cb_count;			/* number of callbacks */
+	int (*commit)(struct sk_buff *, struct net *);
 	const struct nfnl_callback *cb;	/* callback for individual types */
 };
 
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3782777..4baa84f 100644
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
+ *	struct nft_rule_trans - nf_tables rule update in transaction
+ *
+ *	@list: used internally
+ *	@rule: rule that needs to be updated
+ *	@chain: chain that this rule belongs to
+ *	@table: table for which this chain applies
+ *	@net: the net namespace that this rule updates belongs to
+ */
+struct nft_rule_trans {
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
index cc79f82..14d9f14 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -10,6 +10,8 @@ struct netns_nftables {
 	struct nft_af_info	*ipv4;
 	struct nft_af_info	*ipv6;
 	struct nft_af_info	*bridge;
+	u32			transaction_owner;
+	struct list_head	transaction_rules;
 	u8			gencursor;
 	u8			genctr;
 };
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 76b215f..43e8be1 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -37,8 +37,6 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWSETELEM,
 	NFT_MSG_GETSETELEM,
 	NFT_MSG_DELSETELEM,
-	NFT_MSG_COMMIT,
-	NFT_MSG_ABORT,
 	NFT_MSG_MAX,
 };
 
@@ -88,18 +86,12 @@ enum nft_chain_attributes {
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
 
-enum {
-	NFT_RULE_F_COMMIT	= (1 << 0),
-	NFT_RULE_F_MASK		= NFT_RULE_F_COMMIT,
-};
-
 enum nft_rule_attributes {
 	NFTA_RULE_UNSPEC,
 	NFTA_RULE_TABLE,
 	NFTA_RULE_CHAIN,
 	NFTA_RULE_HANDLE,
 	NFTA_RULE_EXPRESSIONS,
-	NFTA_RULE_FLAGS,
 	NFTA_RULE_COMPAT,
 	__NFTA_RULE_MAX
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9ed4db1..3cb8227 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -970,7 +970,6 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	INIT_LIST_HEAD(&chain->rules);
-	INIT_LIST_HEAD(&chain->dirty_rules);
 	chain->handle = nf_tables_alloc_handle(table);
 	chain->net = net;
 	chain->table = table;
@@ -1265,7 +1264,6 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
 	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
-	[NFTA_RULE_FLAGS]	= { .type = NLA_U32 },
 	[NFTA_RULE_COMPAT]	= { .type = NLA_NESTED },
 };
 
@@ -1520,6 +1518,35 @@ static void nf_tables_rule_destroy(struct nft_rule *rule)
 
 static struct nft_expr_info *info;
 
+static int nf_tables_trans_begin(struct net *net,
+				 const struct nlmsghdr *nlh)
+{
+	/* Check if another process is performing a transaction */
+	if (!net->nft.transaction_owner)
+		net->nft.transaction_owner = nlh->nlmsg_pid;
+	else if (net->nft.transaction_owner != nlh->nlmsg_pid)
+		return -EBUSY;
+
+	return 0;
+}
+
+static int nf_tables_trans_add(struct nft_rule *rule, const struct nft_ctx *ctx)
+{
+	struct nft_rule_trans *rupd;
+
+	rupd = kmalloc(sizeof(struct nft_rule_trans), GFP_KERNEL);
+	if (rupd == NULL)
+		return -ENOMEM;
+
+	rupd->chain = ctx->chain;
+	rupd->table = ctx->table;
+	rupd->rule = rule;
+	rupd->net = ctx->net;
+	list_add(&rupd->list, &ctx->net->nft.transaction_rules);
+
+	return 0;
+}
+
 static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 			     const struct nlmsghdr *nlh,
 			     const struct nlattr * const nla[])
@@ -1536,9 +1563,12 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	unsigned int size, i, n;
 	int err, rem;
 	bool create;
-	u32 flags = 0;
 	u64 handle;
 
+	err = nf_tables_trans_begin(net, nlh);
+	if (err < 0)
+		return err;
+
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
 	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
@@ -1595,14 +1625,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	if (rule == NULL)
 		goto err1;
 
-	if (nla[NFTA_RULE_FLAGS]) {
-		flags = ntohl(nla_get_be32(nla[NFTA_RULE_FLAGS]));
-		if (flags & ~NFT_RULE_F_MASK)
-			return -EINVAL;
-
-		if (flags & NFT_RULE_F_COMMIT)
-			nft_rule_activate_next(net, rule);
-	}
+	nft_rule_activate_next(net, rule);
 
 	rule->handle = handle;
 	rule->dlen   = size;
@@ -1617,25 +1640,17 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
-		if (flags & NFT_RULE_F_COMMIT) {
-			nft_rule_disactivate_next(net, old_rule);
-			list_add_tail_rcu(&rule->list, &chain->rules);
-		} else {
-			list_replace_rcu(&old_rule->list, &rule->list);
-			nf_tables_rule_destroy(old_rule);
-		}
+		nft_rule_disactivate_next(net, old_rule);
+		list_add_tail_rcu(&rule->list, &chain->rules);
 	} else if (nlh->nlmsg_flags & NLM_F_APPEND)
 		list_add_tail_rcu(&rule->list, &chain->rules);
 	else
 		list_add_rcu(&rule->list, &chain->rules);
 
-	if (flags & NFT_RULE_F_COMMIT)
-		list_add(&rule->dirty_list, &chain->dirty_rules);
-	else {
-		nf_tables_rule_notify(skb, nlh, table, chain, rule,
-				      NFT_MSG_NEWRULE,
-				      nlh->nlmsg_flags & (NLM_F_APPEND | NLM_F_REPLACE),
-				      nfmsg->nfgen_family);
+	err = nf_tables_trans_add(rule, &ctx);
+	if (err < 0) {
+		list_del_rcu(&rule->list);
+		goto err2;
 	}
 	return 0;
 
@@ -1649,21 +1664,20 @@ err1:
 	return err;
 }
 
-static void
+static int
 nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule, u32 flags)
 {
-	if (flags & NFT_RULE_F_COMMIT) {
-		struct nft_chain *chain = (struct nft_chain *)ctx->chain;
+	int ret = 0;
+
+	/* Will be deleted already in the next generation, skip */
+	if (!nft_rule_is_active_next(ctx->net, rule))
+		return 0;
 
+	ret = nf_tables_trans_add(rule, ctx);
+	if (ret >= 0)
 		nft_rule_disactivate_next(ctx->net, rule);
-		list_add(&rule->dirty_list, &chain->dirty_rules);
-	} else {
-		list_del_rcu(&rule->list);
-		nf_tables_rule_notify(ctx->skb, ctx->nlh, ctx->table,
-				      ctx->chain, rule, NFT_MSG_DELRULE,
-				      0, ctx->afi->family);
-		nf_tables_rule_destroy(rule);
-	}
+
+	return ret;
 }
 
 static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
@@ -1676,10 +1690,14 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	const struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_rule *rule, *tmp;
-	int family = nfmsg->nfgen_family;
+	int family = nfmsg->nfgen_family, err;
 	struct nft_ctx ctx;
 	u32 flags = 0;
 
+	err = nf_tables_trans_begin(net, nlh);
+	if (err < 0)
+		return err;
+
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
@@ -1694,19 +1712,14 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 
 	nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
 
-	if (nla[NFTA_RULE_FLAGS]) {
-		flags = ntohl(nla_get_be32(nla[NFTA_RULE_FLAGS]));
-
-		if (flags & ~NFT_RULE_F_MASK)
-			return -EINVAL;
-	}
-
 	if (nla[NFTA_RULE_HANDLE]) {
 		rule = nf_tables_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
 		if (IS_ERR(rule))
 			return PTR_ERR(rule);
 
-		nf_tables_delrule_one(&ctx, rule, flags);
+		err = nf_tables_delrule_one(&ctx, rule, flags);
+		if (err < 0)
+			return err;
 	} else {
 		/* Remove all rules in this chain */
 		list_for_each_entry_safe(rule, tmp, &chain->rules, list)
@@ -1716,24 +1729,19 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	return 0;
 }
 
-static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
-			    const struct nlmsghdr *nlh,
-			    const struct nlattr * const nla[])
+static int nf_tables_commit(struct sk_buff *skb, struct net *net)
 {
+	struct nlmsghdr *nlh = nlmsg_hdr(skb);
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	const struct nft_af_info *afi;
-	struct net *net = sock_net(skb->sk);
-	struct nft_table *table;
-	struct nft_chain *chain;
-	struct nft_rule *rule, *tmp;
+	struct nft_rule_trans *rupd, *tmp;
 	int family = nfmsg->nfgen_family;
 	bool create;
 
-	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
+	/* Are you the owner of this transaction? */
+	if (nlh->nlmsg_pid != net->nft.transaction_owner)
+		return -EBUSY;
 
-	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
+	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
 	/* Bump generation counter, invalidate any dump in progress */
 	net->nft.genctr++;
@@ -1746,75 +1754,34 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
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
+	list_for_each_entry_safe(rupd, tmp, &net->nft.transaction_rules, list) {
+		/* Delete this rule from the transaction list */
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
-	}
-
-	return 0;
-}
 
-static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
-			   const struct nlmsghdr *nlh,
-			   const struct nlattr * const nla[])
-{
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	const struct nft_af_info *afi;
-	struct net *net = sock_net(skb->sk);
-	struct nft_table *table;
-	struct nft_chain *chain;
-	struct nft_rule *rule, *tmp;
-	bool create;
-
-	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
-
-	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
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
-
-				/* This rule is inactive, get rid of it */
-				list_del_rcu(&rule->list);
-				nf_tables_rule_destroy(rule);
-			}
-		}
+		/* This rule is in the past, get rid of it */
+		list_del_rcu(&rupd->rule->list);
+		nf_tables_rule_notify(skb, nlh, rupd->table, rupd->chain,
+				      rupd->rule, NFT_MSG_DELRULE, 0, family);
+		nf_tables_rule_destroy(rupd->rule);
+		kfree(rupd);
 	}
+	/* Clear owner of this transaction list */
+	net->nft.transaction_owner = 0;
+
 	return 0;
 }
 
@@ -2777,16 +2744,6 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
-	[NFT_MSG_COMMIT] = {
-		.call		= nf_tables_commit,
-		.attr_count	= NFTA_TABLE_MAX,
-		.policy		= nft_rule_policy,
-	},
-	[NFT_MSG_ABORT] = {
-		.call		= nf_tables_abort,
-		.attr_count	= NFTA_TABLE_MAX,
-		.policy		= nft_rule_policy,
-	},
 };
 
 static const struct nfnetlink_subsystem nf_tables_subsys = {
@@ -2794,6 +2751,7 @@ static const struct nfnetlink_subsystem nf_tables_subsys = {
 	.subsys_id	= NFNL_SUBSYS_NFTABLES,
 	.cb_count	= NFT_MSG_MAX,
 	.cb		= nf_tables_cb,
+	.commit		= nf_tables_commit,
 };
 
 /*
@@ -3165,6 +3123,7 @@ EXPORT_SYMBOL_GPL(nft_data_dump);
 static int nf_tables_init_net(struct net *net)
 {
 	INIT_LIST_HEAD(&net->nft.af_info);
+	INIT_LIST_HEAD(&net->nft.transaction_rules);
 	return 0;
 }
 
-- 
1.7.10.4

