From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/6] netfilter: nf_tables: add generation mask to
 tables
Date: Wed, 22 Jun 2016 13:50:58 +0200
Message-ID: <20160622115058.GA12031@salvia>
References: <1466594072-24043-1-git-send-email-pablo@netfilter.org>
 <1466594072-24043-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57682 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbcFVMAw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 08:00:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D85F2C22E5
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:51:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BB4449EBA9
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:51:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AD5B89EBA9
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:50:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1466594072-24043-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 22, 2016 at 01:14:28PM +0200, Pablo Neira Ayuso wrote:
> 2) We don't allow adding and deleting object a given object X in the
>    same batch.

I'm revisiting this statement, which is actually not true. This is
indeed working, what is currently broken (and this patch fixes) is:

        add table x
        add table x { flags dormant\; }

ie. add and update in the same transaction via nft -f.

Same thing with the follow up patch for chains, eg.

        add chain x y { type filter hook input priority 0\; }
        add chain x y { policy drop\; }

which is a valid sequence that currently doesn't work.

So I'm rewriting this patch description to the following below.

-o-

netfilter: nf_tables: add generation mask to tables

This patch addresses two problems:

1) The netlink dump is inconsistent when interfering with an ongoing
   transaction update for several reasons:

1.a) We don't honor the internal NFT_TABLE_INACTIVE flag, and we should
     be skipping these inactive objects in the dump.

1.b) We perform speculative deletion during the preparation phase, that
     may result in skipping active objects.

1.c) The listing order changes, which generates noise when tracking
     incremental ruleset update via tools like git or our own
     testsuite.

2) We don't allow to add and to update the object in the same batch,
   eg. add table x; add table x { flags dormant\; }.

In order to resolve these problems:

1) If the user requests a deletion, the object becomes inactive in the
   next generation. Then, ignore objects that scheduled to be deleted
   from the lookup path, as they will be effectively removed in the
   next generation.

2) From the get/dump path, if the object is not currently active, we
   skip it.

3) Support 'add X -> update X' sequence from a transaction.

After this update, we obtain a consistent list as long as we stay
in the same generation. The userspace side can detect interferences
through the generation counter so it can restart the dumping.
> 
> In order to resolve these problems:
> 
> 1) If the user requests a deletion, the object becomes inactive in the
>    next generation. Then, ignore objects that scheduled to be deleted
>    from the lookup path, as they will be effectively removed in the
>    next generation.
> 
> 2) From the get/dump path, if the object is not currently active, we
>    skip it.
> 
> 3) Support 'add X -> delete X -> add X' sequences from a transaction,
>    they are valid since robot may trigger these kind of incremental
>    updates.
> 
> After this update, we obtain a consistent list as long as we stay
> in the same generation. The userspace side can detect interferences
> through the generation counter so it can restart the dumping.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_tables.h |   6 ++-
>  net/netfilter/nf_tables_api.c     | 101 +++++++++++++++++++++-----------------
>  2 files changed, 62 insertions(+), 45 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 6b7ce3a..5b802f8 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -839,6 +839,7 @@ unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
>   *	@hgenerator: handle generator state
>   *	@use: number of chain references to this table
>   *	@flags: table flag (see enum nft_table_flags)
> + *	@genmask: generation mask
>   *	@name: name of the table
>   */
>  struct nft_table {
> @@ -847,7 +848,8 @@ struct nft_table {
>  	struct list_head		sets;
>  	u64				hgenerator;
>  	u32				use;
> -	u16				flags;
> +	u16				flags:14,
> +					genmask:2;
>  	char				name[NFT_TABLE_MAXNAMELEN];
>  };
>  
> @@ -993,6 +995,8 @@ static inline u8 nft_genmask_cur(const struct net *net)
>  /* After committing the ruleset, clear the stale generation bit. */
>  #define nft_clear(__net, __obj)					\
>  	(__obj)->genmask &= ~nft_genmask_next(__net)
> +#define nft_active_genmask(__obj, __genmask)			\
> +	!((__obj)->genmask & __genmask)
>  
>  /*
>   * Set element transaction helpers
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index bae7d67..4cdc591 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -175,9 +175,6 @@ static void nf_tables_unregister_hooks(const struct nft_table *table,
>  	nft_unregister_basechain(nft_base_chain(chain), hook_nops);
>  }
>  
> -/* Internal table flags */
> -#define NFT_TABLE_INACTIVE	(1 << 15)
> -
>  static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
>  {
>  	struct nft_trans *trans;
> @@ -187,7 +184,7 @@ static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
>  		return -ENOMEM;
>  
>  	if (msg_type == NFT_MSG_NEWTABLE)
> -		ctx->table->flags |= NFT_TABLE_INACTIVE;
> +		nft_activate_next(ctx->net, ctx->table);
>  
>  	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
>  	return 0;
> @@ -201,7 +198,7 @@ static int nft_deltable(struct nft_ctx *ctx)
>  	if (err < 0)
>  		return err;
>  
> -	list_del_rcu(&ctx->table->list);
> +	nft_deactivate_next(ctx->net, ctx->table);
>  	return err;
>  }
>  
> @@ -334,26 +331,29 @@ static int nft_delset(struct nft_ctx *ctx, struct nft_set *set)
>   */
>  
>  static struct nft_table *nft_table_lookup(const struct nft_af_info *afi,
> -					  const struct nlattr *nla)
> +					  const struct nlattr *nla,
> +					  u8 genmask)
>  {
>  	struct nft_table *table;
>  
>  	list_for_each_entry(table, &afi->tables, list) {
> -		if (!nla_strcmp(nla, table->name))
> +		if (!nla_strcmp(nla, table->name) &&
> +		    nft_active_genmask(table, genmask))
>  			return table;
>  	}
>  	return NULL;
>  }
>  
>  static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
> -						const struct nlattr *nla)
> +						const struct nlattr *nla,
> +						u8 genmask)
>  {
>  	struct nft_table *table;
>  
>  	if (nla == NULL)
>  		return ERR_PTR(-EINVAL);
>  
> -	table = nft_table_lookup(afi, nla);
> +	table = nft_table_lookup(afi, nla, genmask);
>  	if (table != NULL)
>  		return table;
>  
> @@ -494,6 +494,8 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
>  			if (idx > s_idx)
>  				memset(&cb->args[1], 0,
>  				       sizeof(cb->args) - sizeof(cb->args[0]));
> +			if (!nft_is_active(net, table))
> +				continue;
>  			if (nf_tables_fill_table_info(skb, net,
>  						      NETLINK_CB(cb->skb).portid,
>  						      cb->nlh->nlmsg_seq,
> @@ -518,6 +520,7 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
>  			      const struct nlattr * const nla[])
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	u8 genmask = nft_genmask_cur(net);
>  	const struct nft_af_info *afi;
>  	const struct nft_table *table;
>  	struct sk_buff *skb2;
> @@ -535,11 +538,9 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
>  	if (IS_ERR(afi))
>  		return PTR_ERR(afi);
>  
> -	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME]);
> +	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME], genmask);
>  	if (IS_ERR(table))
>  		return PTR_ERR(table);
> -	if (table->flags & NFT_TABLE_INACTIVE)
> -		return -ENOENT;
>  
>  	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
>  	if (!skb2)
> @@ -648,6 +649,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
>  			      const struct nlattr * const nla[])
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	u8 genmask = nft_genmask_next(net);
>  	const struct nlattr *name;
>  	struct nft_af_info *afi;
>  	struct nft_table *table;
> @@ -661,7 +663,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
>  		return PTR_ERR(afi);
>  
>  	name = nla[NFTA_TABLE_NAME];
> -	table = nf_tables_table_lookup(afi, name);
> +	table = nf_tables_table_lookup(afi, name, genmask);
>  	if (IS_ERR(table)) {
>  		if (PTR_ERR(table) != -ENOENT)
>  			return PTR_ERR(table);
> @@ -669,8 +671,6 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
>  	}
>  
>  	if (table != NULL) {
> -		if (table->flags & NFT_TABLE_INACTIVE)
> -			return -ENOENT;
>  		if (nlh->nlmsg_flags & NLM_F_EXCL)
>  			return -EEXIST;
>  		if (nlh->nlmsg_flags & NLM_F_REPLACE)
> @@ -765,6 +765,9 @@ static int nft_flush(struct nft_ctx *ctx, int family)
>  
>  		ctx->afi = afi;
>  		list_for_each_entry_safe(table, nt, &afi->tables, list) {
> +			if (!nft_is_active_next(ctx->net, table))
> +				continue;
> +
>  			if (nla[NFTA_TABLE_NAME] &&
>  			    nla_strcmp(nla[NFTA_TABLE_NAME], table->name) != 0)
>  				continue;
> @@ -785,6 +788,7 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
>  			      const struct nlattr * const nla[])
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	u8 genmask = nft_genmask_next(net);
>  	struct nft_af_info *afi;
>  	struct nft_table *table;
>  	int family = nfmsg->nfgen_family;
> @@ -798,7 +802,7 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
>  	if (IS_ERR(afi))
>  		return PTR_ERR(afi);
>  
> -	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME]);
> +	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME], genmask);
>  	if (IS_ERR(table))
>  		return PTR_ERR(table);
>  
> @@ -1074,6 +1078,7 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
>  			      const struct nlattr * const nla[])
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	u8 genmask = nft_genmask_cur(net);
>  	const struct nft_af_info *afi;
>  	const struct nft_table *table;
>  	const struct nft_chain *chain;
> @@ -1092,11 +1097,9 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
>  	if (IS_ERR(afi))
>  		return PTR_ERR(afi);
>  
> -	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE]);
> +	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE], genmask);
>  	if (IS_ERR(table))
>  		return PTR_ERR(table);
> -	if (table->flags & NFT_TABLE_INACTIVE)
> -		return -ENOENT;
>  
>  	chain = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME]);
>  	if (IS_ERR(chain))
> @@ -1201,6 +1204,7 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
>  	struct nft_chain *chain;
>  	struct nft_base_chain *basechain = NULL;
>  	struct nlattr *ha[NFTA_HOOK_MAX + 1];
> +	u8 genmask = nft_genmask_next(net);
>  	int family = nfmsg->nfgen_family;
>  	struct net_device *dev = NULL;
>  	u8 policy = NF_ACCEPT;
> @@ -1217,7 +1221,7 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
>  	if (IS_ERR(afi))
>  		return PTR_ERR(afi);
>  
> -	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE]);
> +	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE], genmask);
>  	if (IS_ERR(table))
>  		return PTR_ERR(table);
>  
> @@ -1449,6 +1453,7 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
>  			      const struct nlattr * const nla[])
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	u8 genmask = nft_genmask_next(net);
>  	struct nft_af_info *afi;
>  	struct nft_table *table;
>  	struct nft_chain *chain;
> @@ -1459,7 +1464,7 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
>  	if (IS_ERR(afi))
>  		return PTR_ERR(afi);
>  
> -	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE]);
> +	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE], genmask);
>  	if (IS_ERR(table))
>  		return PTR_ERR(table);
>  
> @@ -1901,6 +1906,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
>  			     const struct nlattr * const nla[])
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	u8 genmask = nft_genmask_cur(net);
>  	const struct nft_af_info *afi;
>  	const struct nft_table *table;
>  	const struct nft_chain *chain;
> @@ -1920,11 +1926,9 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
>  	if (IS_ERR(afi))
>  		return PTR_ERR(afi);
>  
> -	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE]);
> +	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE], genmask);
>  	if (IS_ERR(table))
>  		return PTR_ERR(table);
> -	if (table->flags & NFT_TABLE_INACTIVE)
> -		return -ENOENT;
>  
>  	chain = nf_tables_chain_lookup(table, nla[NFTA_RULE_CHAIN]);
>  	if (IS_ERR(chain))
> @@ -1979,6 +1983,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
>  			     const struct nlattr * const nla[])
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	u8 genmask = nft_genmask_next(net);
>  	struct nft_af_info *afi;
>  	struct nft_table *table;
>  	struct nft_chain *chain;
> @@ -1999,7 +2004,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
>  	if (IS_ERR(afi))
>  		return PTR_ERR(afi);
>  
> -	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE]);
> +	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE], genmask);
>  	if (IS_ERR(table))
>  		return PTR_ERR(table);
>  
> @@ -2144,6 +2149,7 @@ static int nf_tables_delrule(struct net *net, struct sock *nlsk,
>  			     const struct nlattr * const nla[])
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	u8 genmask = nft_genmask_next(net);
>  	struct nft_af_info *afi;
>  	struct nft_table *table;
>  	struct nft_chain *chain = NULL;
> @@ -2155,7 +2161,7 @@ static int nf_tables_delrule(struct net *net, struct sock *nlsk,
>  	if (IS_ERR(afi))
>  		return PTR_ERR(afi);
>  
> -	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE]);
> +	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE], genmask);
>  	if (IS_ERR(table))
>  		return PTR_ERR(table);
>  
> @@ -2309,7 +2315,8 @@ static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
>  static int nft_ctx_init_from_setattr(struct nft_ctx *ctx, struct net *net,
>  				     const struct sk_buff *skb,
>  				     const struct nlmsghdr *nlh,
> -				     const struct nlattr * const nla[])
> +				     const struct nlattr * const nla[],
> +				     u8 genmask)
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
>  	struct nft_af_info *afi = NULL;
> @@ -2325,7 +2332,8 @@ static int nft_ctx_init_from_setattr(struct nft_ctx *ctx, struct net *net,
>  		if (afi == NULL)
>  			return -EAFNOSUPPORT;
>  
> -		table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE]);
> +		table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE],
> +					       genmask);
>  		if (IS_ERR(table))
>  			return PTR_ERR(table);
>  	}
> @@ -2586,6 +2594,7 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
>  			    struct sk_buff *skb, const struct nlmsghdr *nlh,
>  			    const struct nlattr * const nla[])
>  {
> +	u8 genmask = nft_genmask_cur(net);
>  	const struct nft_set *set;
>  	struct nft_ctx ctx;
>  	struct sk_buff *skb2;
> @@ -2593,7 +2602,7 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
>  	int err;
>  
>  	/* Verify existence before starting dump */
> -	err = nft_ctx_init_from_setattr(&ctx, net, skb, nlh, nla);
> +	err = nft_ctx_init_from_setattr(&ctx, net, skb, nlh, nla, genmask);
>  	if (err < 0)
>  		return err;
>  
> @@ -2663,6 +2672,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
>  			    const struct nlattr * const nla[])
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	u8 genmask = nft_genmask_next(net);
>  	const struct nft_set_ops *ops;
>  	struct nft_af_info *afi;
>  	struct nft_table *table;
> @@ -2760,7 +2770,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
>  	if (IS_ERR(afi))
>  		return PTR_ERR(afi);
>  
> -	table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE]);
> +	table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE], genmask);
>  	if (IS_ERR(table))
>  		return PTR_ERR(table);
>  
> @@ -2865,6 +2875,7 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
>  			    const struct nlattr * const nla[])
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	u8 genmask = nft_genmask_next(net);
>  	struct nft_set *set;
>  	struct nft_ctx ctx;
>  	int err;
> @@ -2874,7 +2885,7 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
>  	if (nla[NFTA_SET_TABLE] == NULL)
>  		return -EINVAL;
>  
> -	err = nft_ctx_init_from_setattr(&ctx, net, skb, nlh, nla);
> +	err = nft_ctx_init_from_setattr(&ctx, net, skb, nlh, nla, genmask);
>  	if (err < 0)
>  		return err;
>  
> @@ -2999,7 +3010,8 @@ static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX +
>  static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx, struct net *net,
>  				      const struct sk_buff *skb,
>  				      const struct nlmsghdr *nlh,
> -				      const struct nlattr * const nla[])
> +				      const struct nlattr * const nla[],
> +				      u8 genmask)
>  {
>  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
>  	struct nft_af_info *afi;
> @@ -3009,7 +3021,8 @@ static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx, struct net *net,
>  	if (IS_ERR(afi))
>  		return PTR_ERR(afi);
>  
> -	table = nf_tables_table_lookup(afi, nla[NFTA_SET_ELEM_LIST_TABLE]);
> +	table = nf_tables_table_lookup(afi, nla[NFTA_SET_ELEM_LIST_TABLE],
> +				       genmask);
>  	if (IS_ERR(table))
>  		return PTR_ERR(table);
>  
> @@ -3106,6 +3119,7 @@ static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
>  static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
>  {
>  	struct net *net = sock_net(skb->sk);
> +	u8 genmask = nft_genmask_cur(net);
>  	const struct nft_set *set;
>  	struct nft_set_dump_args args;
>  	struct nft_ctx ctx;
> @@ -3122,11 +3136,9 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
>  		return err;
>  
>  	err = nft_ctx_init_from_elemattr(&ctx, net, cb->skb, cb->nlh,
> -					 (void *)nla);
> +					 (void *)nla, genmask);
>  	if (err < 0)
>  		return err;
> -	if (ctx.table->flags & NFT_TABLE_INACTIVE)
> -		return -ENOENT;
>  
>  	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET]);
>  	if (IS_ERR(set))
> @@ -3186,15 +3198,14 @@ static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
>  				struct sk_buff *skb, const struct nlmsghdr *nlh,
>  				const struct nlattr * const nla[])
>  {
> +	u8 genmask = nft_genmask_cur(net);
>  	const struct nft_set *set;
>  	struct nft_ctx ctx;
>  	int err;
>  
> -	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla);
> +	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, genmask);
>  	if (err < 0)
>  		return err;
> -	if (ctx.table->flags & NFT_TABLE_INACTIVE)
> -		return -ENOENT;
>  
>  	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET]);
>  	if (IS_ERR(set))
> @@ -3518,6 +3529,7 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
>  				struct sk_buff *skb, const struct nlmsghdr *nlh,
>  				const struct nlattr * const nla[])
>  {
> +	u8 genmask = nft_genmask_next(net);
>  	const struct nlattr *attr;
>  	struct nft_set *set;
>  	struct nft_ctx ctx;
> @@ -3526,7 +3538,7 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
>  	if (nla[NFTA_SET_ELEM_LIST_ELEMENTS] == NULL)
>  		return -EINVAL;
>  
> -	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla);
> +	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, genmask);
>  	if (err < 0)
>  		return err;
>  
> @@ -3640,6 +3652,7 @@ static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
>  				struct sk_buff *skb, const struct nlmsghdr *nlh,
>  				const struct nlattr * const nla[])
>  {
> +	u8 genmask = nft_genmask_next(net);
>  	const struct nlattr *attr;
>  	struct nft_set *set;
>  	struct nft_ctx ctx;
> @@ -3648,7 +3661,7 @@ static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
>  	if (nla[NFTA_SET_ELEM_LIST_ELEMENTS] == NULL)
>  		return -EINVAL;
>  
> -	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla);
> +	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, genmask);
>  	if (err < 0)
>  		return err;
>  
> @@ -3925,12 +3938,13 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  					trans->ctx.table->flags |= NFT_TABLE_F_DORMANT;
>  				}
>  			} else {
> -				trans->ctx.table->flags &= ~NFT_TABLE_INACTIVE;
> +				nft_clear(net, trans->ctx.table);
>  			}
>  			nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE);
>  			nft_trans_destroy(trans);
>  			break;
>  		case NFT_MSG_DELTABLE:
> +			list_del_rcu(&trans->ctx.table->list);
>  			nf_tables_table_notify(&trans->ctx, NFT_MSG_DELTABLE);
>  			break;
>  		case NFT_MSG_NEWCHAIN:
> @@ -4056,8 +4070,7 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb)
>  			}
>  			break;
>  		case NFT_MSG_DELTABLE:
> -			list_add_tail_rcu(&trans->ctx.table->list,
> -					  &trans->ctx.afi->tables);
> +			nft_clear(trans->ctx.net, trans->ctx.table);
>  			nft_trans_destroy(trans);
>  			break;
>  		case NFT_MSG_NEWCHAIN:
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
