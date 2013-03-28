From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC v2] nf_tables: Transaction API proposal
Date: Thu, 28 Mar 2013 18:02:17 +0100
Message-ID: <20130328170217.GA8859@localhost>
References: <20130328100415.GA7848@localhost>
 <1364478773-13302-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34133 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388Ab3C1RCZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:25 -0400
Content-Disposition: inline
In-Reply-To: <1364478773-13302-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 28, 2013 at 03:52:53PM +0200, Tomasz Bursztyka wrote:
> It reworks the current atomic API:
> - propose START/COMMIT/ABORT transaction messages
> - remove rule flags: rule manipalution is part of a transaction once
>   one has been started
> - Enable 1 transaction per-client
> - 1 commit at a time (mutex based)
> ---
> 
> Hi,
> 
> Ok I tried now to fix a bit better the proposal.
> The nft message first are more like the other ones:
>  -> not too long, and the meaningful part is concatenated.
> 
> @Pablo: I took your idea of "BEGIN" instead of "START", it sounds better.
> 
> I still believe we should enable 1 transaction per-client so now instead
> of the bogus sk_user_data pointer, it stores the client transaction in a local
> list. I did not yet put a limit on how many clients can start a transaction actually,
> it has to be added.
>
> It's actually cleaner that way. 
> 
> I also refactored a bit the nf_tables_newrule(), it's cleaner and optimized.
> (no list_del_rcu(rule) in case of not added properly to the transaction)
> 
> About the commit, you are right Pablo: only one at a time, this is mandatory. 
> I missed the point on my first proposal.
>  
> To do so I introduced a mutex. If it's already locked it return -EAGAIN, so it's up
> to the client to retry. I guess this is anyway not going to happen very often.
> I don't know if we could get something better here, at least now no client can
> lock up the other indefinitely, it enables per-client transaction...

Races may still occur if we try to support simultaneous transactions.

client 1
start transaction                 client 2
add rule X1, table Y1, chain Z1   start transaction
... more rule updates             delete all rules in table Y1, chain Z1
... more rule updates             commit
commit

client 2 will see rules in table Y1, chain Z1 after its commit but
will not know why. However, if it hits -EBUSY because another client
was performing a transaction, it can retry a fresh update with the
current rule-set, not based on the stale one.

Regarding your patch:

> Please review,
> 
>  include/net/netfilter/nf_tables.h        |  11 ++
>  include/uapi/linux/netfilter/nf_tables.h |  11 +-
>  net/netfilter/nf_tables_api.c            | 216 +++++++++++++++++++------------
>  3 files changed, 150 insertions(+), 88 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 69cb5ea..028f832 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -354,6 +354,17 @@ struct nft_rule_update {
>  	struct net			*net;
>  };
>  
> +/**
> + * struct nft_transaction - nf_tables transaction
> + *
> + * @updates: list of rule updates for the current transaction
> + */
> +struct nft_transaction {
> +	struct list_head                list;
> +	struct list_head		updates;
> +	u32                             pid_owner;
> +};
> +
>  static inline struct nft_expr *nft_expr_first(const struct nft_rule *rule)
>  {
>  	return (struct nft_expr *)&rule->data[0];
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 76b215f..5f3251b 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -37,8 +37,9 @@ enum nf_tables_msg_types {
>  	NFT_MSG_NEWSETELEM,
>  	NFT_MSG_GETSETELEM,
>  	NFT_MSG_DELSETELEM,
> -	NFT_MSG_COMMIT,
> -	NFT_MSG_ABORT,
> +	NFT_MSG_BEGINTRANSACT,
> +	NFT_MSG_COMMITTRANSACT,
> +	NFT_MSG_ABORTTRANSACT,
>  	NFT_MSG_MAX,
>  };
>  
> @@ -88,18 +89,12 @@ enum nft_chain_attributes {
>  };
>  #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
>  
> -enum {
> -	NFT_RULE_F_COMMIT	= (1 << 0),
> -	NFT_RULE_F_MASK		= NFT_RULE_F_COMMIT,
> -};
> -
>  enum nft_rule_attributes {
>  	NFTA_RULE_UNSPEC,
>  	NFTA_RULE_TABLE,
>  	NFTA_RULE_CHAIN,
>  	NFTA_RULE_HANDLE,
>  	NFTA_RULE_EXPRESSIONS,
> -	NFTA_RULE_FLAGS,
>  	NFTA_RULE_COMPAT,
>  	__NFTA_RULE_MAX
>  };
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index d2da5df..0bc6318 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -11,6 +11,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/list.h>
> +#include <linux/mutex.h>
>  #include <linux/skbuff.h>
>  #include <linux/netlink.h>
>  #include <linux/netfilter.h>
> @@ -22,6 +23,8 @@
>  #include <net/sock.h>
>  
>  static LIST_HEAD(nf_tables_expressions);
> +static LIST_HEAD(nf_tables_transactions);
> +static DEFINE_MUTEX(nf_tables_commit_lock);
>  
>  /**
>   *	nft_register_afinfo - register nf_tables address family info
> @@ -1264,7 +1267,6 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
>  				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
>  	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
>  	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
> -	[NFTA_RULE_FLAGS]	= { .type = NLA_U32 },
>  	[NFTA_RULE_COMPAT]	= { .type = NLA_NESTED },
>  };
>  
> @@ -1518,15 +1520,35 @@ static void nf_tables_rule_destroy(struct nft_rule *rule)
>  
>  static struct nft_expr_info *info;
>  
> -static int nf_tables_dirty_add(struct nft_rule *rule, const struct nft_ctx *ctx)
> +static struct nft_transaction *nf_tables_transaction_lookup(u32 pid_owner)
>  {
> -	struct nft_rule_update *rupd;
> +	struct nft_transaction *transaction;
>  
> -	/* Another socket owns the dirty list? */
> -	if (!ctx->net->nft.pid_owner)
> -		ctx->net->nft.pid_owner = ctx->nlh->nlmsg_pid;
> -	else if (ctx->net->nft.pid_owner != ctx->nlh->nlmsg_pid)
> -		return -EBUSY;
> +	if (list_empty(&nf_tables_transactions))
> +		return NULL;
> +
> +	list_for_each_entry(transaction, &nf_tables_transactions, list) {
> +		if (pid_owner == transaction->pid_owner)
> +			return transaction;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void nf_tables_transaction_remove(struct nft_transaction *transaction)
> +{
> +	nfnl_lock();

Won't work. nfnl_lock is already held when calling this function. Note
that all nfnetlink functions are currently protected by nfnl_lock.

> +	list_del(&transaction->list);
> +	nfnl_unlock();
> +
> +	kfree(transaction);
> +}
> +
> +static int nf_tables_transaction_add(const struct nft_ctx *ctx,
> +				     struct nft_transaction *transaction,
> +				     struct nft_rule *rule)
> +{
> +	struct nft_rule_update *rupd;
>  
>  	rupd = kmalloc(sizeof(struct nft_rule_update), GFP_KERNEL);
>  	if (rupd == NULL)
> @@ -1536,7 +1558,7 @@ static int nf_tables_dirty_add(struct nft_rule *rule, const struct nft_ctx *ctx)
>  	rupd->table = ctx->table;
>  	rupd->rule = rule;
>  	rupd->net = ctx->net;
> -	list_add(&rupd->list, &ctx->net->nft.dirty_rules);
> +	list_add(&rupd->list, &transaction->updates);
>  
>  	return 0;
>  }
> @@ -1547,6 +1569,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
>  	const struct nft_af_info *afi;
> +	struct nft_transaction *transaction;
>  	struct net *net = sock_net(skb->sk);
>  	struct nft_table *table;
>  	struct nft_chain *chain;
> @@ -1557,7 +1580,6 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
>  	unsigned int size, i, n;
>  	int err, rem;
>  	bool create;
> -	u32 flags = 0;
>  	u64 handle;
>  
>  	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
> @@ -1616,15 +1638,6 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
>  	if (rule == NULL)
>  		goto err1;
>  
> -	if (nla[NFTA_RULE_FLAGS]) {
> -		flags = ntohl(nla_get_be32(nla[NFTA_RULE_FLAGS]));
> -		if (flags & ~NFT_RULE_F_MASK)
> -			return -EINVAL;
> -
> -		if (flags & NFT_RULE_F_COMMIT)
> -			nft_rule_activate_next(net, rule);
> -	}
> -
>  	rule->handle = handle;
>  	rule->dlen   = size;
>  
> @@ -1637,8 +1650,16 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
>  		expr = nft_expr_next(expr);
>  	}
>  
> +	transaction = nf_tables_transaction_lookup(nlh->nlmsg_pid);
> +	if (transaction != NULL) {
> +		err = nf_tables_transaction_add(&ctx, transaction, rule);
> +		if (err < 0)
> +			goto err2;
> +		nft_rule_activate_next(net, rule);
> +	}
> +
>  	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
> -		if (flags & NFT_RULE_F_COMMIT) {
> +		if (transaction != NULL) {
>  			nft_rule_disactivate_next(net, old_rule);
>  			list_add_tail_rcu(&rule->list, &chain->rules);
>  		} else {
> @@ -1650,16 +1671,11 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
>  	else
>  		list_add_rcu(&rule->list, &chain->rules);
>  
> -	if (flags & NFT_RULE_F_COMMIT) {
> -		err = nf_tables_dirty_add(rule, &ctx);
> -		if (err < 0) {
> -			list_del_rcu(&rule->list);
> -			goto err2;
> -		}
> -	} else {
> +	if (transaction == NULL) {
>  		nf_tables_rule_notify(skb, nlh, table, chain, rule,
>  				      NFT_MSG_NEWRULE,
> -				      nlh->nlmsg_flags & (NLM_F_APPEND | NLM_F_REPLACE),
> +				      nlh->nlmsg_flags &
> +				      (NLM_F_APPEND | NLM_F_REPLACE),
>  				      nfmsg->nfgen_family);
>  	}
>  	return 0;
> @@ -1674,17 +1690,18 @@ err1:
>  	return err;
>  }
>  
> -static int
> -nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule, u32 flags)
> +static int nf_tables_delrule_one(struct nft_ctx *ctx,
> +				 struct nft_transaction *transaction,
> +				 struct nft_rule *rule)
>  {
>  	int ret = 0;
>  
> -	if (flags & NFT_RULE_F_COMMIT) {
> +	if (transaction != NULL) {
>  		/* Will be deleted already in the next generation */
>  		if (!nft_rule_is_active_next(ctx->net, rule))
>  			return -EBUSY;
>  
> -		ret = nf_tables_dirty_add(rule, ctx);
> +		ret = nf_tables_transaction_add(ctx, transaction, rule);
>  		if (ret >= 0)
>  			nft_rule_disactivate_next(ctx->net, rule);
>  	} else {
> @@ -1703,13 +1720,13 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
>  	const struct nft_af_info *afi;
> +	struct nft_transaction *transaction;
>  	struct net *net = sock_net(skb->sk);
>  	const struct nft_table *table;
>  	struct nft_chain *chain;
>  	struct nft_rule *rule, *tmp;
>  	int family = nfmsg->nfgen_family, err;
>  	struct nft_ctx ctx;
> -	u32 flags = 0;
>  
>  	afi = nf_tables_afinfo_lookup(net, family, false);
>  	if (IS_ERR(afi))
> @@ -1725,44 +1742,68 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
>  
>  	nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
>  
> -	if (nla[NFTA_RULE_FLAGS]) {
> -		flags = ntohl(nla_get_be32(nla[NFTA_RULE_FLAGS]));
> -
> -		if (flags & ~NFT_RULE_F_MASK)
> -			return -EINVAL;
> -	}
> +	transaction = nf_tables_transaction_lookup(nlh->nlmsg_pid);
>  
>  	if (nla[NFTA_RULE_HANDLE]) {
>  		rule = nf_tables_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
>  		if (IS_ERR(rule))
>  			return PTR_ERR(rule);
>  
> -		err = nf_tables_delrule_one(&ctx, rule, flags);
> +		err = nf_tables_delrule_one(&ctx, transaction, rule);
>  		if (err < 0)
>  			return err;
>  	} else {
>  		/* Remove all rules in this chain */
>  		list_for_each_entry_safe(rule, tmp, &chain->rules, list)
> -			nf_tables_delrule_one(&ctx, rule, flags);
> +			nf_tables_delrule_one(&ctx, transaction, rule);
>  	}
>  
>  	return 0;
>  }
>  
> -static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
> -			    const struct nlmsghdr *nlh,
> -			    const struct nlattr * const nla[])
> +static int nf_tables_begin_transaction(struct sock *nlsk, struct sk_buff *skb,
> +				       const struct nlmsghdr *nlh,
> +				       const struct nlattr * const nla[])
> +{
> +	struct nft_transaction *transaction;
> +
> +	transaction = nf_tables_transaction_lookup(nlh->nlmsg_pid);
> +	if (transaction != NULL)
> +		return -EALREADY;
> +
> +	transaction = kmalloc(sizeof(struct nft_transaction), GFP_KERNEL);
> +	if (transaction == NULL)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&transaction->list);
> +	INIT_LIST_HEAD(&transaction->updates);
> +	transaction->pid_owner = nlh->nlmsg_pid;
> +
> +	nfnl_lock();

Same thing as above.

> +	list_add_tail(&transaction->list, &nf_tables_transactions);
> +	nfnl_unlock();
> +
> +	return 0;
> +}
> +
> +static int nf_tables_commit_transaction(struct sock *nlsk, struct sk_buff *skb,
> +					const struct nlmsghdr *nlh,
> +					const struct nlattr * const nla[])
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
>  	const struct nft_af_info *afi;
> +	struct nft_transaction *transaction;
>  	struct net *net = sock_net(skb->sk);
>  	struct nft_rule_update *rupd, *tmp;
>  	int family = nfmsg->nfgen_family;
>  	bool create;
>  
> -	/* Are you the owner of the dirty list? */
> -	if (nlh->nlmsg_pid != net->nft.pid_owner)
> -		return -EBUSY;
> +	transaction = nf_tables_transaction_lookup(nlh->nlmsg_pid);
> +	if (transaction == NULL)
> +		return -EINVAL;
> +
> +	if (list_empty(&transaction->updates))
> +		goto done;
>  
>  	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
>  
> @@ -1770,6 +1811,10 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
>  	if (IS_ERR(afi))
>  		return PTR_ERR(afi);
>  
> +	/* Check if a commit is on-going */
> +	if (mutex_trylock(&nf_tables_commit_lock))
> +		return -EAGAIN;

You should use -EBUSY. -EAGAIN is used internally by nfnetlink to
retry on module autoload.

Note that this is just delaying the moment at which the client hits
an error.

I'm attaching a patch that removes the commit flag and add the
explicit begin operation.

--n8g4imXOkfNTN/H1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_tables-add-explicit-begin-operation-for.patch"

>From 5723a577c90810435937173f256dbccd015e3b34 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 28 Mar 2013 17:50:04 +0100
Subject: [PATCH] netfilter: nf_tables: add explicit begin operation for
 transactions

This patch removes the NFT_RULE_F_COMMIT flag and it adds an explicit
begin operation to start transactions, as suggested by Tomasz.

You hit -EBUSY if another process started a transaction before you try to
perform an incremental (ie. one single rule) or transactional update.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |    7 +---
 net/netfilter/nf_tables_api.c            |   59 +++++++++++++++++-------------
 2 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 76b215f..1461a42 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -37,6 +37,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWSETELEM,
 	NFT_MSG_GETSETELEM,
 	NFT_MSG_DELSETELEM,
+	NFT_MSG_BEGIN,
 	NFT_MSG_COMMIT,
 	NFT_MSG_ABORT,
 	NFT_MSG_MAX,
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
index 57d28cb..57cfc74 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1264,7 +1264,6 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
 	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
-	[NFTA_RULE_FLAGS]	= { .type = NLA_U32 },
 	[NFTA_RULE_COMPAT]	= { .type = NLA_NESTED },
 };
 
@@ -1523,12 +1522,6 @@ static int nf_tables_dirty_add(struct nft_rule *rule, const struct nft_ctx *ctx)
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
@@ -1558,9 +1551,12 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	unsigned int size, i, n;
 	int err, rem;
 	bool create;
-	u32 flags = 0;
 	u64 handle;
 
+	/* A transaction is happening, tell this process that it should retry */
+	if (net->nft.pid_owner && net->nft.pid_owner != nlh->nlmsg_pid)
+		return -EBUSY;
+
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
 	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
@@ -1617,14 +1613,8 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
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
+	if (net->nft.pid_owner)
+		nft_rule_activate_next(net, rule);
 
 	rule->handle = handle;
 	rule->dlen   = size;
@@ -1639,7 +1629,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
-		if (flags & NFT_RULE_F_COMMIT) {
+		if (net->nft.pid_owner) {
 			nft_rule_disactivate_next(net, old_rule);
 			list_add_tail_rcu(&rule->list, &chain->rules);
 		} else {
@@ -1651,7 +1641,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	else
 		list_add_rcu(&rule->list, &chain->rules);
 
-	if (flags & NFT_RULE_F_COMMIT) {
+	if (net->nft.pid_owner) {
 		err = nf_tables_dirty_add(rule, &ctx);
 		if (err < 0) {
 			list_del_rcu(&rule->list);
@@ -1680,7 +1670,7 @@ nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule, u32 flags)
 {
 	int ret = 0;
 
-	if (flags & NFT_RULE_F_COMMIT) {
+	if (ctx->net->nft.pid_owner) {
 		/* Will be deleted already in the next generation */
 		if (!nft_rule_is_active_next(ctx->net, rule))
 			return -EBUSY;
@@ -1712,6 +1702,10 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_ctx ctx;
 	u32 flags = 0;
 
+	/* A transaction is happening, tell this process that it should retry */
+	if (net->nft.pid_owner && net->nft.pid_owner != nlh->nlmsg_pid)
+		return -EBUSY;
+
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
@@ -1726,13 +1720,6 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 
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
@@ -1750,6 +1737,21 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	return 0;
 }
 
+static int nf_tables_begin(struct sock *nlsk, struct sk_buff *skb,
+			   const struct nlmsghdr *nlh,
+			   const struct nlattr * const nla[])
+{
+	struct net *net = sock_net(skb->sk);
+
+	/* Check if another process is performing a transaction */
+	if (!net->nft.pid_owner)
+		net->nft.pid_owner = nlh->nlmsg_pid;
+	else if (net->nft.pid_owner != nlh->nlmsg_pid)
+		return -EBUSY;
+
+	return 0;
+}
+
 static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 			    const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[])
@@ -2840,6 +2842,11 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
+	[NFT_MSG_BEGIN] = {
+		.call		= nf_tables_begin,
+		.attr_count	= NFTA_TABLE_MAX,
+		.policy		= nft_rule_policy,
+	},
 	[NFT_MSG_COMMIT] = {
 		.call		= nf_tables_commit,
 		.attr_count	= NFTA_TABLE_MAX,
-- 
1.7.10.4


--n8g4imXOkfNTN/H1--
