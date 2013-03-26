From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH] nf_tables: Transaction API proposal
Date: Tue, 26 Mar 2013 12:19:04 +0200
Message-ID: <1364293144-4147-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1362092898-23306-1-git-send-email-pablo@netfilter.org>
 <1364293144-4147-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: kaber@trash.net, pablo@netfilter.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:3491 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322Ab3CZKTZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Mar 2013 06:19:25 -0400
In-Reply-To: <1364293144-4147-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It reworks the current atomic API:
- proposes START/COMMIT/ABORT transaction messages
- removes rule flags: rule manipalution is part of a transaction once
  one has been started
- make use of nfnl socket user data: enables transaction per-nfnetlink
  connection
---
 include/net/netfilter/nf_tables.h        |   9 ++
 include/uapi/linux/netfilter/nf_tables.h |  11 +-
 net/netfilter/nf_tables_api.c            | 170 +++++++++++++++++--------------
 3 files changed, 106 insertions(+), 84 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 69cb5ea..490acb0 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -354,6 +354,15 @@ struct nft_rule_update {
 	struct net			*net;
 };
 
+/**
+ * struct nft_transaction - nf_tables transaction
+ *
+ * @updates: list of rule updates for the current transaction
+ */
+struct nft_transaction {
+	struct list_head		updates;
+};
+
 static inline struct nft_expr *nft_expr_first(const struct nft_rule *rule)
 {
 	return (struct nft_expr *)&rule->data[0];
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 76b215f..8f8d6a6 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -37,8 +37,9 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWSETELEM,
 	NFT_MSG_GETSETELEM,
 	NFT_MSG_DELSETELEM,
-	NFT_MSG_COMMIT,
-	NFT_MSG_ABORT,
+	NFT_MSG_START_TRANSACTION,
+	NFT_MSG_COMMIT_TRANSACTION,
+	NFT_MSG_ABORT_TRANSACTION,
 	NFT_MSG_MAX,
 };
 
@@ -88,18 +89,12 @@ enum nft_chain_attributes {
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
index d2da5df..7d2cbd5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1264,7 +1264,6 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
 	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
-	[NFTA_RULE_FLAGS]	= { .type = NLA_U32 },
 	[NFTA_RULE_COMPAT]	= { .type = NLA_NESTED },
 };
 
@@ -1518,16 +1517,12 @@ static void nf_tables_rule_destroy(struct nft_rule *rule)
 
 static struct nft_expr_info *info;
 
-static int nf_tables_dirty_add(struct nft_rule *rule, const struct nft_ctx *ctx)
+static int nf_tables_transaction_add(const struct nft_ctx *ctx,
+				     struct nft_transaction *transaction,
+				     struct nft_rule *rule)
 {
 	struct nft_rule_update *rupd;
 
-	/* Another socket owns the dirty list? */
-	if (!ctx->net->nft.pid_owner)
-		ctx->net->nft.pid_owner = ctx->nlh->nlmsg_pid;
-	else if (ctx->net->nft.pid_owner != ctx->nlh->nlmsg_pid)
-		return -EBUSY;
-
 	rupd = kmalloc(sizeof(struct nft_rule_update), GFP_KERNEL);
 	if (rupd == NULL)
 		return -ENOMEM;
@@ -1536,7 +1531,7 @@ static int nf_tables_dirty_add(struct nft_rule *rule, const struct nft_ctx *ctx)
 	rupd->table = ctx->table;
 	rupd->rule = rule;
 	rupd->net = ctx->net;
-	list_add(&rupd->list, &ctx->net->nft.dirty_rules);
+	list_add(&rupd->list, &transaction->updates);
 
 	return 0;
 }
@@ -1547,6 +1542,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	const struct nft_af_info *afi;
+	struct nft_transaction *transaction = nlsk->sk_user_data;
 	struct net *net = sock_net(skb->sk);
 	struct nft_table *table;
 	struct nft_chain *chain;
@@ -1557,7 +1553,6 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	unsigned int size, i, n;
 	int err, rem;
 	bool create;
-	u32 flags = 0;
 	u64 handle;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
@@ -1616,15 +1611,6 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
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
-
 	rule->handle = handle;
 	rule->dlen   = size;
 
@@ -1637,8 +1623,11 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 		expr = nft_expr_next(expr);
 	}
 
+	if (transaction != NULL)
+		nft_rule_activate_next(net, rule);
+
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
-		if (flags & NFT_RULE_F_COMMIT) {
+		if (transaction != NULL) {
 			nft_rule_disactivate_next(net, old_rule);
 			list_add_tail_rcu(&rule->list, &chain->rules);
 		} else {
@@ -1650,8 +1639,8 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	else
 		list_add_rcu(&rule->list, &chain->rules);
 
-	if (flags & NFT_RULE_F_COMMIT) {
-		err = nf_tables_dirty_add(rule, &ctx);
+	if (transaction != NULL) {
+		err = nf_tables_transaction_add(&ctx, transaction, rule);
 		if (err < 0) {
 			list_del_rcu(&rule->list);
 			goto err2;
@@ -1659,7 +1648,8 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	} else {
 		nf_tables_rule_notify(skb, nlh, table, chain, rule,
 				      NFT_MSG_NEWRULE,
-				      nlh->nlmsg_flags & (NLM_F_APPEND | NLM_F_REPLACE),
+				      nlh->nlmsg_flags &
+				      (NLM_F_APPEND | NLM_F_REPLACE),
 				      nfmsg->nfgen_family);
 	}
 	return 0;
@@ -1674,17 +1664,18 @@ err1:
 	return err;
 }
 
-static int
-nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule, u32 flags)
+static int nf_tables_delrule_one(struct nft_ctx *ctx,
+				 struct nft_transaction *transaction,
+				 struct nft_rule *rule)
 {
 	int ret = 0;
 
-	if (flags & NFT_RULE_F_COMMIT) {
+	if (transaction != NULL) {
 		/* Will be deleted already in the next generation */
 		if (!nft_rule_is_active_next(ctx->net, rule))
 			return -EBUSY;
 
-		ret = nf_tables_dirty_add(rule, ctx);
+		ret = nf_tables_transaction_add(ctx, transaction, rule);
 		if (ret >= 0)
 			nft_rule_disactivate_next(ctx->net, rule);
 	} else {
@@ -1703,13 +1694,13 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	const struct nft_af_info *afi;
+	struct nft_transaction *transaction = nlsk->sk_user_data;
 	struct net *net = sock_net(skb->sk);
 	const struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_rule *rule, *tmp;
 	int family = nfmsg->nfgen_family, err;
 	struct nft_ctx ctx;
-	u32 flags = 0;
 
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
@@ -1725,44 +1716,59 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 
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
 
-		err = nf_tables_delrule_one(&ctx, rule, flags);
+		err = nf_tables_delrule_one(&ctx, transaction, rule);
 		if (err < 0)
 			return err;
 	} else {
 		/* Remove all rules in this chain */
 		list_for_each_entry_safe(rule, tmp, &chain->rules, list)
-			nf_tables_delrule_one(&ctx, rule, flags);
+			nf_tables_delrule_one(&ctx, transaction, rule);
 	}
 
 	return 0;
 }
 
-static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
-			    const struct nlmsghdr *nlh,
-			    const struct nlattr * const nla[])
+static int nf_tables_start_transaction(struct sock *nlsk, struct sk_buff *skb,
+				       const struct nlmsghdr *nlh,
+				       const struct nlattr * const nla[])
+{
+	struct nft_transaction *transaction;
+
+	if (nlsk->sk_user_data != NULL)
+		return -EALREADY;
+
+	transaction = kmalloc(sizeof(struct nft_transaction), GFP_KERNEL);
+	if (transaction == NULL)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&transaction->updates);
+	nlsk->sk_user_data = transaction;
+
+	return 0;
+}
+
+static int nf_tables_commit_transaction(struct sock *nlsk, struct sk_buff *skb,
+					const struct nlmsghdr *nlh,
+					const struct nlattr * const nla[])
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	const struct nft_af_info *afi;
+	struct nft_transaction *transaction = nlsk->sk_user_data;
 	struct net *net = sock_net(skb->sk);
 	struct nft_rule_update *rupd, *tmp;
 	int family = nfmsg->nfgen_family;
 	bool create;
 
-	/* Are you the owner of the dirty list? */
-	if (nlh->nlmsg_pid != net->nft.pid_owner)
-		return -EBUSY;
+	if (transaction == NULL)
+		return -EINVAL;
+
+	if (list_empty(&transaction->updates))
+		goto done;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
@@ -1781,7 +1787,7 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 	 */
 	synchronize_rcu();
 
-	list_for_each_entry_safe(rupd, tmp, &net->nft.dirty_rules, list) {
+	list_for_each_entry_safe(rupd, tmp, &transaction->updates, list) {
 		/* Delete this rule from the dirty list */
 		list_del(&rupd->list);
 
@@ -1806,47 +1812,47 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 		nf_tables_rule_destroy(rupd->rule);
 		kfree(rupd);
 	}
-	/* Clear owner of this dirty list */
-	net->nft.pid_owner = 0;
+
+done:
+	kfree(transaction);
+	nlsk->sk_user_data = NULL;
 
 	return 0;
 }
 
-static void nf_tables_abort_all(struct net *net)
+static void nf_tables_abort_all(struct nft_transaction *transaction)
 {
 	struct nft_rule_update *rupd, *tmp;
 
-	list_for_each_entry_safe(rupd, tmp, &net->nft.dirty_rules, list) {
-		/* Delete all rules from the dirty list */
+	list_for_each_entry_safe(rupd, tmp, &transaction->updates, list) {
+		/* Delete all rules from the update list */
 		list_del(&rupd->list);
 
-		if (!nft_rule_is_active_next(rupd->net, rupd->rule)) {
+		if (nft_rule_is_active_next(rupd->net, rupd->rule)) {
+			list_del_rcu(&rupd->rule->list);
+			nf_tables_rule_destroy(rupd->rule);
+		} else
 			nft_rule_clear(rupd->net, rupd->rule);
-			kfree(rupd);
-			return;
-		}
 
-		/* This rule is inactive, get rid of it */
-		list_del_rcu(&rupd->rule->list);
-		nf_tables_rule_destroy(rupd->rule);
 		kfree(rupd);
 	}
-	/* Clear the owner of the dirty list */
-	net->nft.pid_owner = 0;
 }
 
-static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
-			   const struct nlmsghdr *nlh,
-			   const struct nlattr * const nla[])
+static int nf_tables_abort_transaction(struct sock *nlsk, struct sk_buff *skb,
+				       const struct nlmsghdr *nlh,
+				       const struct nlattr * const nla[])
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	const struct nft_af_info *afi;
+	struct nft_transaction *transaction = nlsk->sk_user_data;
 	struct net *net = sock_net(skb->sk);
 	bool create;
 
-	/* Are you the owner of the dirty list? */
-	if (nlh->nlmsg_pid != net->nft.pid_owner)
-		return -EBUSY;
+	if (transaction == NULL)
+		return -EINVAL;
+
+	if (list_empty(&transaction->updates))
+		goto done;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
@@ -1854,24 +1860,31 @@ static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	nf_tables_abort_all(net);
+	nf_tables_abort_all(transaction);
+
+done:
+	kfree(transaction);
+	nlsk->sk_user_data = NULL;
 
 	return 0;
 }
 
-static int
-nf_tables_rcv_nl_event(struct notifier_block *this,
-		       unsigned long event, void *ptr)
+static int nf_tables_rcv_nl_event(struct notifier_block *this,
+				  unsigned long event, void *ptr)
 {
 	struct netlink_notify *n = ptr;
+	struct nft_transaction *transaction;
 
 	if (event != NETLINK_URELEASE || n->protocol != NETLINK_NETFILTER)
 		return NOTIFY_DONE;
 
-	if (n->portid != n->net->nft.pid_owner)
-		return NOTIFY_DONE;
-
-	nf_tables_abort_all(n->net);
+	transaction = n->net->nfnl->sk_user_data;
+	if (transaction != NULL) {
+		if (!list_empty(&transaction->updates))
+			nf_tables_abort_all(transaction);
+		kfree(transaction);
+		n->net->nfnl->sk_user_data = NULL;
+	}
 
 	return NOTIFY_DONE;
 }
@@ -2840,13 +2853,18 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
-	[NFT_MSG_COMMIT] = {
-		.call		= nf_tables_commit,
+	[NFT_MSG_START_TRANSACTION] = {
+		.call           = nf_tables_start_transaction,
+		.attr_count     = NFTA_TABLE_MAX,
+		.policy         = nft_rule_policy,
+	},
+	[NFT_MSG_COMMIT_TRANSACTION] = {
+		.call		= nf_tables_commit_transaction,
 		.attr_count	= NFTA_TABLE_MAX,
 		.policy		= nft_rule_policy,
 	},
-	[NFT_MSG_ABORT] = {
-		.call		= nf_tables_abort,
+	[NFT_MSG_ABORT_TRANSACTION] = {
+		.call		= nf_tables_abort_transaction,
 		.attr_count	= NFTA_TABLE_MAX,
 		.policy		= nft_rule_policy,
 	},
-- 
1.8.1.5

