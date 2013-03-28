From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [RFC v2] nf_tables: Transaction API proposal
Date: Thu, 28 Mar 2013 15:52:53 +0200
Message-ID: <1364478773-13302-1-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <20130328100415.GA7848@localhost>
Cc: kaber@trash.net, pablo@netfilter.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22900 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab3C1NxO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:53:14 -0400
In-Reply-To: <20130328100415.GA7848@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It reworks the current atomic API:
- propose START/COMMIT/ABORT transaction messages
- remove rule flags: rule manipalution is part of a transaction once
  one has been started
- Enable 1 transaction per-client
- 1 commit at a time (mutex based)
---

Hi,

Ok I tried now to fix a bit better the proposal.
The nft message first are more like the other ones:
 -> not too long, and the meaningful part is concatenated.

@Pablo: I took your idea of "BEGIN" instead of "START", it sounds better.

I still believe we should enable 1 transaction per-client so now instead
of the bogus sk_user_data pointer, it stores the client transaction in a local
list. I did not yet put a limit on how many clients can start a transaction actually,
it has to be added.

It's actually cleaner that way. 

I also refactored a bit the nf_tables_newrule(), it's cleaner and optimized.
(no list_del_rcu(rule) in case of not added properly to the transaction)

About the commit, you are right Pablo: only one at a time, this is mandatory. 
I missed the point on my first proposal.
 
To do so I introduced a mutex. If it's already locked it return -EAGAIN, so it's up
to the client to retry. I guess this is anyway not going to happen very often.
I don't know if we could get something better here, at least now no client can
lock up the other indefinitely, it enables per-client transaction... 

Please review,

 include/net/netfilter/nf_tables.h        |  11 ++
 include/uapi/linux/netfilter/nf_tables.h |  11 +-
 net/netfilter/nf_tables_api.c            | 216 +++++++++++++++++++------------
 3 files changed, 150 insertions(+), 88 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 69cb5ea..028f832 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -354,6 +354,17 @@ struct nft_rule_update {
 	struct net			*net;
 };
 
+/**
+ * struct nft_transaction - nf_tables transaction
+ *
+ * @updates: list of rule updates for the current transaction
+ */
+struct nft_transaction {
+	struct list_head                list;
+	struct list_head		updates;
+	u32                             pid_owner;
+};
+
 static inline struct nft_expr *nft_expr_first(const struct nft_rule *rule)
 {
 	return (struct nft_expr *)&rule->data[0];
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 76b215f..5f3251b 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -37,8 +37,9 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWSETELEM,
 	NFT_MSG_GETSETELEM,
 	NFT_MSG_DELSETELEM,
-	NFT_MSG_COMMIT,
-	NFT_MSG_ABORT,
+	NFT_MSG_BEGINTRANSACT,
+	NFT_MSG_COMMITTRANSACT,
+	NFT_MSG_ABORTTRANSACT,
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
index d2da5df..0bc6318 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
@@ -22,6 +23,8 @@
 #include <net/sock.h>
 
 static LIST_HEAD(nf_tables_expressions);
+static LIST_HEAD(nf_tables_transactions);
+static DEFINE_MUTEX(nf_tables_commit_lock);
 
 /**
  *	nft_register_afinfo - register nf_tables address family info
@@ -1264,7 +1267,6 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
 	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
-	[NFTA_RULE_FLAGS]	= { .type = NLA_U32 },
 	[NFTA_RULE_COMPAT]	= { .type = NLA_NESTED },
 };
 
@@ -1518,15 +1520,35 @@ static void nf_tables_rule_destroy(struct nft_rule *rule)
 
 static struct nft_expr_info *info;
 
-static int nf_tables_dirty_add(struct nft_rule *rule, const struct nft_ctx *ctx)
+static struct nft_transaction *nf_tables_transaction_lookup(u32 pid_owner)
 {
-	struct nft_rule_update *rupd;
+	struct nft_transaction *transaction;
 
-	/* Another socket owns the dirty list? */
-	if (!ctx->net->nft.pid_owner)
-		ctx->net->nft.pid_owner = ctx->nlh->nlmsg_pid;
-	else if (ctx->net->nft.pid_owner != ctx->nlh->nlmsg_pid)
-		return -EBUSY;
+	if (list_empty(&nf_tables_transactions))
+		return NULL;
+
+	list_for_each_entry(transaction, &nf_tables_transactions, list) {
+		if (pid_owner == transaction->pid_owner)
+			return transaction;
+	}
+
+	return NULL;
+}
+
+static void nf_tables_transaction_remove(struct nft_transaction *transaction)
+{
+	nfnl_lock();
+	list_del(&transaction->list);
+	nfnl_unlock();
+
+	kfree(transaction);
+}
+
+static int nf_tables_transaction_add(const struct nft_ctx *ctx,
+				     struct nft_transaction *transaction,
+				     struct nft_rule *rule)
+{
+	struct nft_rule_update *rupd;
 
 	rupd = kmalloc(sizeof(struct nft_rule_update), GFP_KERNEL);
 	if (rupd == NULL)
@@ -1536,7 +1558,7 @@ static int nf_tables_dirty_add(struct nft_rule *rule, const struct nft_ctx *ctx)
 	rupd->table = ctx->table;
 	rupd->rule = rule;
 	rupd->net = ctx->net;
-	list_add(&rupd->list, &ctx->net->nft.dirty_rules);
+	list_add(&rupd->list, &transaction->updates);
 
 	return 0;
 }
@@ -1547,6 +1569,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	const struct nft_af_info *afi;
+	struct nft_transaction *transaction;
 	struct net *net = sock_net(skb->sk);
 	struct nft_table *table;
 	struct nft_chain *chain;
@@ -1557,7 +1580,6 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	unsigned int size, i, n;
 	int err, rem;
 	bool create;
-	u32 flags = 0;
 	u64 handle;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
@@ -1616,15 +1638,6 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
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
 
@@ -1637,8 +1650,16 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 		expr = nft_expr_next(expr);
 	}
 
+	transaction = nf_tables_transaction_lookup(nlh->nlmsg_pid);
+	if (transaction != NULL) {
+		err = nf_tables_transaction_add(&ctx, transaction, rule);
+		if (err < 0)
+			goto err2;
+		nft_rule_activate_next(net, rule);
+	}
+
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
-		if (flags & NFT_RULE_F_COMMIT) {
+		if (transaction != NULL) {
 			nft_rule_disactivate_next(net, old_rule);
 			list_add_tail_rcu(&rule->list, &chain->rules);
 		} else {
@@ -1650,16 +1671,11 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	else
 		list_add_rcu(&rule->list, &chain->rules);
 
-	if (flags & NFT_RULE_F_COMMIT) {
-		err = nf_tables_dirty_add(rule, &ctx);
-		if (err < 0) {
-			list_del_rcu(&rule->list);
-			goto err2;
-		}
-	} else {
+	if (transaction == NULL) {
 		nf_tables_rule_notify(skb, nlh, table, chain, rule,
 				      NFT_MSG_NEWRULE,
-				      nlh->nlmsg_flags & (NLM_F_APPEND | NLM_F_REPLACE),
+				      nlh->nlmsg_flags &
+				      (NLM_F_APPEND | NLM_F_REPLACE),
 				      nfmsg->nfgen_family);
 	}
 	return 0;
@@ -1674,17 +1690,18 @@ err1:
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
@@ -1703,13 +1720,13 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	const struct nft_af_info *afi;
+	struct nft_transaction *transaction;
 	struct net *net = sock_net(skb->sk);
 	const struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_rule *rule, *tmp;
 	int family = nfmsg->nfgen_family, err;
 	struct nft_ctx ctx;
-	u32 flags = 0;
 
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
@@ -1725,44 +1742,68 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 
 	nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
 
-	if (nla[NFTA_RULE_FLAGS]) {
-		flags = ntohl(nla_get_be32(nla[NFTA_RULE_FLAGS]));
-
-		if (flags & ~NFT_RULE_F_MASK)
-			return -EINVAL;
-	}
+	transaction = nf_tables_transaction_lookup(nlh->nlmsg_pid);
 
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
+static int nf_tables_begin_transaction(struct sock *nlsk, struct sk_buff *skb,
+				       const struct nlmsghdr *nlh,
+				       const struct nlattr * const nla[])
+{
+	struct nft_transaction *transaction;
+
+	transaction = nf_tables_transaction_lookup(nlh->nlmsg_pid);
+	if (transaction != NULL)
+		return -EALREADY;
+
+	transaction = kmalloc(sizeof(struct nft_transaction), GFP_KERNEL);
+	if (transaction == NULL)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&transaction->list);
+	INIT_LIST_HEAD(&transaction->updates);
+	transaction->pid_owner = nlh->nlmsg_pid;
+
+	nfnl_lock();
+	list_add_tail(&transaction->list, &nf_tables_transactions);
+	nfnl_unlock();
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
+	struct nft_transaction *transaction;
 	struct net *net = sock_net(skb->sk);
 	struct nft_rule_update *rupd, *tmp;
 	int family = nfmsg->nfgen_family;
 	bool create;
 
-	/* Are you the owner of the dirty list? */
-	if (nlh->nlmsg_pid != net->nft.pid_owner)
-		return -EBUSY;
+	transaction = nf_tables_transaction_lookup(nlh->nlmsg_pid);
+	if (transaction == NULL)
+		return -EINVAL;
+
+	if (list_empty(&transaction->updates))
+		goto done;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
@@ -1770,6 +1811,10 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
+	/* Check if a commit is on-going */
+	if (mutex_trylock(&nf_tables_commit_lock))
+		return -EAGAIN;
+
 	/* Bump generation counter, invalidate any dump in progress */
 	net->nft.genctr++;
 
@@ -1781,7 +1826,7 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 	 */
 	synchronize_rcu();
 
-	list_for_each_entry_safe(rupd, tmp, &net->nft.dirty_rules, list) {
+	list_for_each_entry_safe(rupd, tmp, &transaction->updates, list) {
 		/* Delete this rule from the dirty list */
 		list_del(&rupd->list);
 
@@ -1806,47 +1851,49 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 		nf_tables_rule_destroy(rupd->rule);
 		kfree(rupd);
 	}
-	/* Clear owner of this dirty list */
-	net->nft.pid_owner = 0;
 
+	/* Release the commit lock */
+	mutex_unlock(&nf_tables_commit_lock);
+
+done:
+	nf_tables_transaction_remove(transaction);
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
+	struct nft_transaction *transaction;
 	struct net *net = sock_net(skb->sk);
 	bool create;
 
-	/* Are you the owner of the dirty list? */
-	if (nlh->nlmsg_pid != net->nft.pid_owner)
-		return -EBUSY;
+	transaction = nf_tables_transaction_lookup(nlh->nlmsg_pid);
+	if (transaction == NULL)
+		return -EINVAL;
+
+	if (list_empty(&transaction->updates))
+		goto done;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
@@ -1854,24 +1901,28 @@ static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	nf_tables_abort_all(net);
+	nf_tables_abort_all(transaction);
 
+done:
+	nf_tables_transaction_remove(transaction);
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
+	transaction = nf_tables_transaction_lookup(n->net->nft.pid_owner);
+	if (transaction != NULL) {
+		if (!list_empty(&transaction->updates))
+			nf_tables_abort_all(transaction);
+		nf_tables_transaction_remove(transaction);
+	}
 
 	return NOTIFY_DONE;
 }
@@ -2840,13 +2891,18 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
-	[NFT_MSG_COMMIT] = {
-		.call		= nf_tables_commit,
+	[NFT_MSG_BEGINTRANSACT] = {
+		.call           = nf_tables_begin_transaction,
+		.attr_count     = NFTA_TABLE_MAX,
+		.policy         = nft_rule_policy,
+	},
+	[NFT_MSG_COMMITTRANSACT] = {
+		.call		= nf_tables_commit_transaction,
 		.attr_count	= NFTA_TABLE_MAX,
 		.policy		= nft_rule_policy,
 	},
-	[NFT_MSG_ABORT] = {
-		.call		= nf_tables_abort,
+	[NFT_MSG_ABORTTRANSACT] = {
+		.call		= nf_tables_abort_transaction,
 		.attr_count	= NFTA_TABLE_MAX,
 		.policy		= nft_rule_policy,
 	},
-- 
1.8.1.5

