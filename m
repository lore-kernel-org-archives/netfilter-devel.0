From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH v2 2/5] netfilter: nf_tables: Unlimit table name
 length
Date: Tue, 25 Jul 2017 18:10:02 +0200
Message-ID: <20170725161002.GA3489@salvia>
References: <20170724185651.24063-1-phil@nwl.cc>
 <20170724185651.24063-3-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42126 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752243AbdGYQKQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 12:10:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7F2D117D420
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 18:10:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6EE93D1CAA
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 18:10:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA384DA57F
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 18:09:58 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170724185651.24063-3-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

I think you can rename patch title to "allow table names up to 256
chars". This is not unlimited anymore since v2.

A couple more comments below.

On Mon, Jul 24, 2017 at 08:56:48PM +0200, Phil Sutter wrote:
> Allocate all table names dynamically to allow for arbitrary lengths but
> introduce NFT_NAME_MAXLEN as an upper sanity boundary. It's value was
> chosen to allow using a domain name as per RFC 1035.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/net/netfilter/nf_tables.h        |  2 +-
>  include/uapi/linux/netfilter/nf_tables.h |  2 +-
>  net/netfilter/nf_tables_api.c            | 61 ++++++++++++++++++++++----------
>  net/netfilter/nf_tables_trace.c          |  4 ++-
>  4 files changed, 47 insertions(+), 22 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index bd5be0d691d51..05ecf78ec0787 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -957,7 +957,7 @@ struct nft_table {
>  	u32				use;
>  	u16				flags:14,
>  					genmask:2;
> -	char				name[NFT_TABLE_MAXNAMELEN];
> +	char				*name;
>  };
>  
>  enum nft_af_flags {
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 683f6f88fcace..35d1d9a21508e 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -1,7 +1,7 @@
>  #ifndef _LINUX_NF_TABLES_H
>  #define _LINUX_NF_TABLES_H
>  
> -#define NFT_TABLE_MAXNAMELEN	32
> +#define NFT_NAME_MAXLEN		256

I understand NFT_*_MAXNAMELEN per object is probably too much, but
given this is uapi, I think we have to keep it around, ie.

#define NFT_NAME_MAXLEN		256
#define NFT_TABLE_MAXNAMELEN    NFT_NAME_MAXLEN

And so on.

>  #define NFT_CHAIN_MAXNAMELEN	32
>  #define NFT_SET_MAXNAMELEN	32
>  #define NFT_OBJ_MAXNAMELEN	32
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 7843efa33c598..cf12f63606aaf 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -428,7 +428,7 @@ nf_tables_chain_type_lookup(const struct nft_af_info *afi,
>  
>  static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
>  	[NFTA_TABLE_NAME]	= { .type = NLA_STRING,
> -				    .len = NFT_TABLE_MAXNAMELEN - 1 },
> +				    .len = NFT_NAME_MAXLEN - 1 },
>  	[NFTA_TABLE_FLAGS]	= { .type = NLA_U32 },
>  };
>  
> @@ -726,7 +726,10 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
>  	if (table == NULL)
>  		goto err2;
>  
> -	nla_strlcpy(table->name, name, NFT_TABLE_MAXNAMELEN);
> +	table->name = nla_strdup(name, GFP_KERNEL);
> +	if (table->name == NULL)
> +		goto err3;
> +
>  	INIT_LIST_HEAD(&table->chains);
>  	INIT_LIST_HEAD(&table->sets);
>  	INIT_LIST_HEAD(&table->objects);
> @@ -735,10 +738,12 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
>  	nft_ctx_init(&ctx, net, skb, nlh, afi, table, NULL, nla);
>  	err = nft_trans_table_add(&ctx, NFT_MSG_NEWTABLE);
>  	if (err < 0)
> -		goto err3;
> +		goto err4;
>  
>  	list_add_tail_rcu(&table->list, &afi->tables);
>  	return 0;
> +err4:
> +	kfree(table->name);
>  err3:
>  	kfree(table);
>  err2:
> @@ -865,6 +870,7 @@ static void nf_tables_table_destroy(struct nft_ctx *ctx)
>  {
>  	BUG_ON(ctx->table->use > 0);
>  
> +	kfree(ctx->table->name);
>  	kfree(ctx->table);
>  	module_put(ctx->afi->owner);
>  }
> @@ -935,7 +941,7 @@ static struct nft_chain *nf_tables_chain_lookup(const struct nft_table *table,
>  
>  static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
>  	[NFTA_CHAIN_TABLE]	= { .type = NLA_STRING,
> -				    .len = NFT_TABLE_MAXNAMELEN - 1 },
> +				    .len = NFT_NAME_MAXLEN - 1 },
>  	[NFTA_CHAIN_HANDLE]	= { .type = NLA_U64 },
>  	[NFTA_CHAIN_NAME]	= { .type = NLA_STRING,
>  				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
> @@ -1873,7 +1879,7 @@ static struct nft_rule *nf_tables_rule_lookup(const struct nft_chain *chain,
>  
>  static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
>  	[NFTA_RULE_TABLE]	= { .type = NLA_STRING,
> -				    .len = NFT_TABLE_MAXNAMELEN - 1 },
> +				    .len = NFT_NAME_MAXLEN - 1 },
>  	[NFTA_RULE_CHAIN]	= { .type = NLA_STRING,
>  				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
>  	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
> @@ -1977,7 +1983,7 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
>  }
>  
>  struct nft_rule_dump_ctx {
> -	char table[NFT_TABLE_MAXNAMELEN];
> +	char *table;
>  	char chain[NFT_CHAIN_MAXNAMELEN];
>  };
>  
> @@ -2002,7 +2008,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
>  			continue;
>  
>  		list_for_each_entry_rcu(table, &afi->tables, list) {
> -			if (ctx && ctx->table[0] &&
> +			if (ctx && ctx->table &&
>  			    strcmp(ctx->table, table->name) != 0)
>  				continue;
>  
> @@ -2042,7 +2048,12 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
>  
>  static int nf_tables_dump_rules_done(struct netlink_callback *cb)
>  {
> -	kfree(cb->data);
> +	struct nft_rule_dump_ctx *ctx = cb->data;
> +
> +	if (ctx) {
> +		kfree(ctx->table);
> +		kfree(ctx);
> +	}
>  	return 0;
>  }
>  
> @@ -2074,9 +2085,14 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
>  			if (!ctx)
>  				return -ENOMEM;
>  
> -			if (nla[NFTA_RULE_TABLE])
> -				nla_strlcpy(ctx->table, nla[NFTA_RULE_TABLE],
> -					    sizeof(ctx->table));
> +			if (nla[NFTA_RULE_TABLE]) {
> +				ctx->table = nla_strdup(nla[NFTA_RULE_TABLE],
> +							GFP_KERNEL);
> +				if (!ctx->table) {
> +					kfree(ctx);
> +					return -ENOMEM;
> +				}
> +			}
>  			if (nla[NFTA_RULE_CHAIN])
>  				nla_strlcpy(ctx->chain, nla[NFTA_RULE_CHAIN],
>  					    sizeof(ctx->chain));
> @@ -2508,7 +2524,7 @@ nft_select_set_ops(const struct nft_ctx *ctx,
>  
>  static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
>  	[NFTA_SET_TABLE]		= { .type = NLA_STRING,
> -					    .len = NFT_TABLE_MAXNAMELEN - 1 },
> +					    .len = NFT_NAME_MAXLEN - 1 },
>  	[NFTA_SET_NAME]			= { .type = NLA_STRING,
>  					    .len = NFT_SET_MAXNAMELEN - 1 },
>  	[NFTA_SET_FLAGS]		= { .type = NLA_U32 },
> @@ -3275,7 +3291,7 @@ static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
>  
>  static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX + 1] = {
>  	[NFTA_SET_ELEM_LIST_TABLE]	= { .type = NLA_STRING,
> -					    .len = NFT_TABLE_MAXNAMELEN - 1 },
> +					    .len = NFT_NAME_MAXLEN - 1 },
>  	[NFTA_SET_ELEM_LIST_SET]	= { .type = NLA_STRING,
>  					    .len = NFT_SET_MAXNAMELEN - 1 },
>  	[NFTA_SET_ELEM_LIST_ELEMENTS]	= { .type = NLA_NESTED },
> @@ -4219,7 +4235,7 @@ EXPORT_SYMBOL_GPL(nf_tables_obj_lookup);
>  
>  static const struct nla_policy nft_obj_policy[NFTA_OBJ_MAX + 1] = {
>  	[NFTA_OBJ_TABLE]	= { .type = NLA_STRING,
> -				    .len = NFT_TABLE_MAXNAMELEN - 1 },
> +				    .len = NFT_NAME_MAXLEN - 1 },
>  	[NFTA_OBJ_NAME]		= { .type = NLA_STRING,
>  				    .len = NFT_OBJ_MAXNAMELEN - 1 },
>  	[NFTA_OBJ_TYPE]		= { .type = NLA_U32 },
> @@ -4415,7 +4431,7 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
>  }
>  
>  struct nft_obj_filter {
> -	char		table[NFT_OBJ_MAXNAMELEN];
> +	char		*table;
>  	u32		type;
>  };
>  
> @@ -4480,7 +4496,10 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
>  
>  static int nf_tables_dump_obj_done(struct netlink_callback *cb)
>  {
> -	kfree(cb->data);
> +	struct nft_obj_filter *filter = cb->data;
> +
> +	kfree(filter->table);
> +	kfree(filter);
>  
>  	return 0;
>  }
> @@ -4494,9 +4513,13 @@ nft_obj_filter_alloc(const struct nlattr * const nla[])
>  	if (!filter)
>  		return ERR_PTR(-ENOMEM);
>  
> -	if (nla[NFTA_OBJ_TABLE])
> -		nla_strlcpy(filter->table, nla[NFTA_OBJ_TABLE],
> -			    NFT_TABLE_MAXNAMELEN);
> +	if (nla[NFTA_OBJ_TABLE]) {
> +		filter->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_KERNEL);
> +		if (!filter->table) {
> +			kfree(filter);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +	}
>  	if (nla[NFTA_OBJ_TYPE])
>  		filter->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
>  
> diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
> index e1b15e7a5793f..e95098c1faaf0 100644
> --- a/net/netfilter/nf_tables_trace.c
> +++ b/net/netfilter/nf_tables_trace.c
> @@ -175,7 +175,6 @@ void nft_trace_notify(struct nft_traceinfo *info)
>  		return;
>  
>  	size = nlmsg_total_size(sizeof(struct nfgenmsg)) +
> -		nla_total_size(NFT_TABLE_MAXNAMELEN) +
>  		nla_total_size(NFT_CHAIN_MAXNAMELEN) +
>  		nla_total_size_64bit(sizeof(__be64)) +	/* rule handle */
>  		nla_total_size(sizeof(__be32)) +	/* trace type */
> @@ -194,6 +193,9 @@ void nft_trace_notify(struct nft_traceinfo *info)
>  		nla_total_size(sizeof(u32)) +		/* nfproto */
>  		nla_total_size(sizeof(u32));		/* policy */
>  
> +	if (info->chain)
> +		size += nla_total_size(strlen(info->chain->table->name));

Do we need a branch here? I think info->chain is always set in traces,
right?

Thanks!
