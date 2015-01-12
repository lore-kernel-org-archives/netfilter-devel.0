From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next] netfilter: acct: add support to accounters in nftables
Date: Mon, 12 Jan 2015 12:31:35 +0100
Message-ID: <20150112113135.GA3279@salvia>
References: <cover.1421059771.git.ana@soleta.eu>
 <99c6e9b457ccc93fb761f6fa7f87fb9e6affc4ee.1421059771.git.ana@soleta.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: ana@soleta.eu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42719 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbbALL2z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:28:55 -0500
Content-Disposition: inline
In-Reply-To: <99c6e9b457ccc93fb761f6fa7f87fb9e6affc4ee.1421059771.git.ana@soleta.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 12, 2015 at 11:55:51AM +0100, ana@soleta.eu wrote:
> From: Ana Rey <ana@soleta.eu>
> 
> This adds accounting objects support to allow us to manipulate the nftables's
> extended accounting intraestructure.

I really think it's worth to provide some examples in the patch
description so people understand better what this is about.

> Signed-off-by: Ana Rey Botello <ana@soleta.eu>
> ---
>  include/net/netfilter/nf_tables.h        |   41 +++
>  include/uapi/linux/netfilter/nf_tables.h |   41 +++
>  net/netfilter/Kconfig                    |    7 +
>  net/netfilter/Makefile                   |    1 +
>  net/netfilter/nf_tables_api.c            |  485 +++++++++++++++++++++++++++++-
>  net/netfilter/nft_acct.c                 |  109 +++++++
>  6 files changed, 679 insertions(+), 5 deletions(-)
>  create mode 100644 net/netfilter/nft_acct.c
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 3ae969e..96f5292 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -408,6 +408,17 @@ struct nft_trans {
>  	char				data[0];
>  };
>  
> +

Remove extra line break, not needed.

> +struct nft_trans_acct {
> +	struct nft_acct	*acct;
> +	u32		acct_id;
> +};
> +
> +#define nft_trans_acct(trans)	\
> +	(((struct nft_trans_acct *)trans->data)->acct)
> +#define nft_trans_acct_id(trans)	\
> +	(((struct nft_trans_acct *)trans->data)->acct_id)
> +
>  struct nft_trans_rule {
>  	struct nft_rule			*rule;
>  };
> @@ -570,6 +581,7 @@ unsigned int nft_do_chain(struct nft_pktinfo *pkt,
>   *	@list: used internally
>   *	@chains: chains in the table
>   *	@sets: sets in the table
> + *	@accts: accts in the table
>   *	@hgenerator: handle generator state
>   *	@use: number of chain references to this table
>   *	@flags: table flag (see enum nft_table_flags)
> @@ -579,6 +591,7 @@ struct nft_table {
>  	struct list_head		list;
>  	struct list_head		chains;
>  	struct list_head		sets;
> +	struct list_head		accts;
>  	u64				hgenerator;
>  	u32				use;
>  	u16				flags;
> @@ -637,6 +650,31 @@ void nft_unregister_chain_type(const struct nf_chain_type *);
>  int nft_register_expr(struct nft_expr_type *);
>  void nft_unregister_expr(struct nft_expr_type *);
>  
> +/**
> + * struct nft_acct - nf_tables acct instance
> + *
> + * @list: table acct list node
> + * @name: name of the acct
> + * @pkts:  number of packets
> + * @bytes:  number of bytes
> + * use: number of rule references to this acct
> + */
> +struct nft_acct {
> +	struct list_head	list;
> +	char                    name[NFT_ACCT_MAXNAMELEN];

NFT_ACCT_MAXNAMELEN needs to be limited to 16 bytes, so we can easily
use acct objects from mappings.

> +	atomic64_t		pkts;
> +	atomic64_t		bytes;
> +	u32			use;
> +};
> +
> +struct nft_acct *nf_tables_acct_lookup(const struct nft_table *table,
> +				       const struct nlattr *nla);
> +struct nft_acct *nft_acct_find_get(const struct nft_ctx *ctx,
> +				   const char *acct_name);
> +void nft_acct_update(const struct sk_buff *skb, struct nft_acct *acct);

This is a dead definition.

> +void nft_acct_put(struct nft_acct *acct);
> +int nft_acct_get(struct nft_acct *acct);
> +
>  #define nft_dereference(p)					\
>  	nfnl_dereference(p, NFNL_SUBSYS_NFTABLES)
>  
> @@ -655,4 +693,7 @@ void nft_unregister_expr(struct nft_expr_type *);
>  #define MODULE_ALIAS_NFT_SET() \
>  	MODULE_ALIAS("nft-set")
>  
> +#define MODULE_ALIAS_NFT_ACCT() \
> +	MODULE_ALIAS("nft-acct")
> +
>  #endif /* _NET_NF_TABLES_H */
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 832bc46..b5e17a0 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -2,6 +2,7 @@
>  #define _LINUX_NF_TABLES_H
>  
>  #define NFT_CHAIN_MAXNAMELEN	32
> +#define NFT_ACCT_MAXNAMELEN	32
>  #define NFT_USERDATA_MAXLEN	256
>  
>  enum nft_registers {
> @@ -53,6 +54,10 @@ enum nft_verdicts {
>   * @NFT_MSG_DELSETELEM: delete a set element (enum nft_set_elem_attributes)
>   * @NFT_MSG_NEWGEN: announce a new generation, only for events (enum nft_gen_attributes)
>   * @NFT_MSG_GETGEN: get the rule-set generation (enum nft_gen_attributes)
> + * @NFT_MSG_NEWACCT: create a new account (enum nft_acct_attributes)
> + * @NFT_MSG_GETACCT: get a account (enum nft_acct_attributes)
> + * @NFT_MSG_GETACCT_ZERO: get a reset accounter (enum nft_acct_attributes)
> + * @NFT_MSG_DELACCT: delete a account (enum nft_acct_attributes)
>   */
>  enum nf_tables_msg_types {
>  	NFT_MSG_NEWTABLE,
> @@ -72,6 +77,10 @@ enum nf_tables_msg_types {
>  	NFT_MSG_DELSETELEM,
>  	NFT_MSG_NEWGEN,
>  	NFT_MSG_GETGEN,
> +	NFT_MSG_NEWACCT,
> +	NFT_MSG_GETACCT,
> +	NFT_MSG_GETACCT_ZERO,
> +	NFT_MSG_DELACCT,
>  	NFT_MSG_MAX,
>  };
>  
> @@ -867,4 +876,36 @@ enum nft_gen_attributes {
>  };
>  #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
>  
> +/**
> + * enum nft_acct_attributes - nf_tables acct netlink attributes
> + *
> + * @NFTA_ACCT_NAME: name of the accounter (NLA_STRING)
> + * @NFTA_ACCT_TABLE: table name (NLA_STRING)
> + * @NFTA_ACCT_BYTES: number of bytes (NLA_U64)
> + * @NFTA_ACCT_PACKETS: number of packets (NLA_U64)
> + * @NFTA_ACCT_USE: number of rules using this account object (NLA_U32)
> + * @NFTA_ACCT_ID: uniquely identifies a acct in a transaction (NLA_U32)
> + */
> +enum nft_acct_attributes {
> +	NFTA_ACCT_UNSPEC,
> +	NFTA_ACCT_NAME,
> +	NFTA_ACCT_TABLE,
> +	NFTA_ACCT_BYTES,
> +	NFTA_ACCT_PACKETS,
> +	NFTA_ACCT_USE,
> +	NFTA_ACCT_ID,
> +	__NFTA_ACCT_MAX
> +};
> +#define NFTA_ACCT_MAX		(__NFTA_ACCT_MAX - 1)
> +
> +enum nft_acct_expr_attr {
> +	NFTA_ACCT_EXPR_UNSPEC,
> +	NFTA_ACCT_EXPR_NAME,
> +	__NFTA_ACCT_EXPR_MAX
> +};
> +#define NFTA_ACCT_EXPR_MAX        (__NFTA_ACCT_EXPR_MAX - 1)
> +
> +#ifndef NFTA_ACCT_NAME_MAX
> +#define NFTA_ACCT_NAME_MAX	32
> +#endif
>  #endif /* _LINUX_NF_TABLES_H */
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index b02660f..f0eeb89 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -446,6 +446,13 @@ config NF_TABLES_INET
>  	help
>  	  This option enables support for a mixed IPv4/IPv6 "inet" table.
>  
> +config NFT_ACCT
> +	depends on NF_TABLES
> +	tristate "Netfilter nf_tables acct module"
> +	help
> +	  This option adds the "acct" expression that you can use to update
> +	  packet accounting objects.
> +
>  config NFT_EXTHDR
>  	depends on NF_TABLES
>  	tristate "Netfilter nf_tables IPv6 exthdr module"
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 89f73a9..fcc483f 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -90,6 +90,7 @@ obj-$(CONFIG_NFT_COUNTER)	+= nft_counter.o
>  obj-$(CONFIG_NFT_LOG)		+= nft_log.o
>  obj-$(CONFIG_NFT_MASQ)		+= nft_masq.o
>  obj-$(CONFIG_NFT_REDIR)		+= nft_redir.o
> +obj-$(CONFIG_NFT_ACCT)          += nft_acct.o
                         ^--------^
                       I see spaces there, not indents.

>  
>  # generic X tables 
>  obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 3b3ddb4..faf970a 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -239,6 +239,7 @@ nf_tables_delrule_deactivate(struct nft_ctx *ctx, struct nft_rule *rule)
>  		ctx->chain->use--;
>  		return 0;
>  	}
> +

This change has nothing to do with this, please remove it.

>  	return -ENOENT;
>  }
>  
> @@ -325,6 +326,39 @@ static int nft_delset(struct nft_ctx *ctx, struct nft_set *set)
>  	return err;
>  }
>  
> +static int nft_trans_acct_add(struct nft_ctx *ctx, int msg_type,
> +			      struct nft_acct *acct)
> +{
> +	struct nft_trans *trans;
> +
> +	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_acct));
> +	if (!trans)
> +		return -ENOMEM;
> +
> +	if (msg_type == NFT_MSG_NEWACCT && ctx->nla[NFTA_ACCT_ID]) {
> +		nft_trans_acct_id(trans) =
> +			ntohl(nla_get_be32(ctx->nla[NFTA_ACCT_ID]));
> +	}
> +	nft_trans_acct(trans) = acct;
> +	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
> +
> +	return 0;
> +}
> +
> +static int nft_delacct(struct nft_ctx *ctx, struct nft_acct *acct)
> +{
> +	int err;
> +
> +	err = nft_trans_acct_add(ctx, NFT_MSG_DELACCT, acct);
> +	if (err < 0)
> +		return err;
> +
> +	list_del_rcu(&acct->list);
> +	ctx->table->use--;
> +
> +	return err;
> +}
> +
>  /*
>   * Tables
>   */
> @@ -694,6 +728,7 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
>  	nla_strlcpy(table->name, name, nla_len(name));
>  	INIT_LIST_HEAD(&table->chains);
>  	INIT_LIST_HEAD(&table->sets);
> +	INIT_LIST_HEAD(&table->accts);
>  	table->flags = flags;
>  
>  	nft_ctx_init(&ctx, skb, nlh, afi, table, NULL, nla);
> @@ -712,13 +747,18 @@ static int nft_flush_table(struct nft_ctx *ctx)
>  	int err;
>  	struct nft_chain *chain, *nc;
>  	struct nft_set *set, *ns;
> +	struct nft_acct *acct, *na;
>  
> -	list_for_each_entry(chain, &ctx->table->chains, list) {
> +	list_for_each_entry_safe(chain, nc, &ctx->table->chains, list) {

This changes has nothing to do with this patch.

>  		ctx->chain = chain;
>  
>  		err = nft_delrule_by_chain(ctx);
>  		if (err < 0)
>  			goto out;
> +
> +		err = nft_delchain(ctx);
> +		if (err < 0)
> +			goto out;

Same thing here, this chunks has nothing to do with it.

>  	}
>  
>  	list_for_each_entry_safe(set, ns, &ctx->table->sets, list) {
> @@ -731,10 +771,8 @@ static int nft_flush_table(struct nft_ctx *ctx)
>  			goto out;
>  	}
>  
> -	list_for_each_entry_safe(chain, nc, &ctx->table->chains, list) {
> -		ctx->chain = chain;
> -
> -		err = nft_delchain(ctx);
> +	list_for_each_entry_safe(acct, na, &ctx->table->accts, list) {
> +		err = nft_delacct(ctx, acct);

This change doesn't make sense. You're removing chain handling and
replacing it by doing something with acct objects...

>  		if (err < 0)
>  			goto out;
>  	}
> @@ -3386,6 +3424,396 @@ err:
>  	return err;
>  }
>  
> +static const struct nla_policy nft_acct_policy[NFTA_ACCT_MAX + 1] = {
> +	[NFTA_ACCT_NAME]	= { .type = NLA_NUL_STRING,
> +				   .len = NFTA_ACCT_NAME_MAX - 1 },
> +	[NFTA_ACCT_BYTES]	= { .type = NLA_U64 },
> +	[NFTA_ACCT_PACKETS]	= { .type = NLA_U64 },
> +	[NFTA_ACCT_ID]		= { .type = NLA_U32 },
> +};
> +
> +struct nft_acct *nf_tables_acct_lookup(const struct nft_table *table,
> +				       const struct nlattr *nla)
> +{
> +	struct nft_acct *acct;
> +
> +	if (!nla)
> +		return ERR_PTR(-EINVAL);
> +
> +	list_for_each_entry(acct, &table->accts, list) {
> +		if (!nla_strcmp(nla, acct->name))
> +			return acct;
> +	}
> +
> +	return ERR_PTR(-ENOENT);
> +}
> +
> +struct nft_acct *nft_acct_find_get(const struct nft_ctx *ctx,
> +				   const char *acct_name)

You can kill this function a use acct_lookup all the time.

> +{
> +	struct nft_acct *cur, *acct = NULL;
> +	struct nft_table *table = ctx->table;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(cur, &table->accts, list) {
> +		if (strncmp(cur->name, acct_name, NFTA_ACCT_NAME_MAX) != 0)
> +			continue;
> +
> +		acct = cur;
> +		break;
> +	}
> +	rcu_read_unlock();
> +
> +	return acct;
> +}
> +EXPORT_SYMBOL_GPL(nft_acct_find_get);
> +
> +static int nft_ctx_init_from_acct(struct nft_ctx *ctx,
> +				  const struct sk_buff *skb,

Please, align the parameters.

> +				  const struct nlmsghdr *nlh,
> +				  const struct nlattr * const nla[])
> +{
> +	struct net *net = sock_net(skb->sk);
> +	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	struct nft_af_info *afi = NULL;
> +	struct nft_table *table = NULL;
> +
> +	if (nfmsg->nfgen_family != NFPROTO_UNSPEC) {
> +		afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, false);
> +		if (IS_ERR(afi))
> +			return PTR_ERR(afi);
> +	}
> +
> +	if (nla[NFTA_ACCT_TABLE]) {
> +		if (!afi)
> +			return -EAFNOSUPPORT;
> +
> +		table = nf_tables_table_lookup(afi, nla[NFTA_ACCT_TABLE]);
> +		if (IS_ERR(table))
> +			return PTR_ERR(table);
> +		if (table->flags & NFT_TABLE_INACTIVE)
> +			return -ENOENT;
> +	}
> +
> +	nft_ctx_init(ctx, skb, nlh, afi, table, NULL, nla);
> +
> +	return 0;
> +}
> +
> +static int nf_tables_newacct(struct sock *nlsk, struct sk_buff *skb,
> +			     const struct nlmsghdr *nlh,
> +			     const struct nlattr * const nla[])
> +{
> +	struct nft_ctx ctx;
> +	const struct nlattr *name;
> +	struct nft_acct *acct, *matching;
> +	unsigned int size = 0;

This is always zero, remove it.

> +	int err;
> +
> +	if (!nla[NFTA_ACCT_NAME] || !nla[NFTA_ACCT_TABLE])
> +		return -EINVAL;
> +
> +	err = nft_ctx_init_from_acct(&ctx, skb, nlh, nla);
> +	if (err < 0)
> +		return err;
> +
> +	matching = nf_tables_acct_lookup(ctx.table, nla[NFTA_ACCT_NAME]);
> +
> +	if (!IS_ERR(matching)) {
> +		if (nlh->nlmsg_flags & NLM_F_EXCL)
> +			return -EEXIST;
> +		if (nlh->nlmsg_flags & NLM_F_REPLACE)
> +			return 0;
> +		else
> +			return -EBUSY;
> +	}
> +
> +	if (!(nlh->nlmsg_flags & NLM_F_CREATE))
> +		return -ENOENT;
> +
> +	acct = kzalloc(sizeof(*acct) + size, GFP_KERNEL);
> +	if (!acct)
> +		return -ENOMEM;
> +
> +	name = nla[NFTA_ACCT_NAME];
> +	nla_strlcpy(acct->name, name, nla_len(name));

Use NFT_ACCT_NAMEMAX instead of nla_len(name).

> +
> +	if (nla[NFTA_ACCT_BYTES]) {
> +		atomic64_set(&acct->bytes,
> +			     be64_to_cpu(nla_get_be64(nla[NFTA_ACCT_BYTES])));
> +	}
> +	if (nla[NFTA_ACCT_PACKETS]) {
> +		atomic64_set(&acct->pkts,
> +			     be64_to_cpu(nla_get_be64(nla[NFTA_ACCT_PACKETS])));
> +	}
> +
> +	err = nft_trans_acct_add(&ctx, NFT_MSG_NEWACCT, acct);
> +	if (err < 0)
> +		goto err;
> +
> +	list_add_tail_rcu(&acct->list, &ctx.table->accts);
> +	ctx.table->use++;
> +
> +	return 0;
> +err:
> +	kfree(acct);
> +	return err;
> +}
> +
> +static int nf_tables_fill_acct(struct sk_buff *skb, const struct nft_ctx *ctx,
> +			       const struct nft_acct *acct,
> +			       u16 event, u16 flags, u32 type)
> +{
> +	struct nfgenmsg *nfmsg;
> +	struct nlmsghdr *nlh;
> +	u32 portid = ctx->portid;
> +	u32 seq = ctx->seq;
> +	u64 pkts, bytes;
> +
> +	event |= NFNL_SUBSYS_NFTABLES << 8;
> +	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
> +			flags);
> +	if (!nlh)
> +		goto nla_put_failure;
> +
> +	nfmsg = nlmsg_data(nlh);
> +	nfmsg->nfgen_family	= ctx->afi->family;
> +	nfmsg->version		= NFNETLINK_V0;
> +	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
> +
> +	if (nla_put_string(skb, NFTA_ACCT_TABLE, ctx->table->name))
> +		goto nla_put_failure;
> +	if (nla_put_string(skb, NFTA_ACCT_NAME, acct->name))
> +		goto nla_put_failure;
> +
> +	if (type == NFT_MSG_GETACCT_ZERO) {
> +		pkts = atomic64_xchg(&((struct nft_acct *)acct)->pkts, 0);
> +		bytes = atomic64_xchg(&((struct nft_acct *)acct)->bytes, 0);
> +	} else {
> +		pkts = atomic64_read(&acct->pkts);
> +		bytes = atomic64_read(&acct->bytes);
> +	}
> +
> +	if (nla_put_be64(skb, NFTA_ACCT_PACKETS, cpu_to_be64(pkts)) ||
> +	    nla_put_be64(skb, NFTA_ACCT_BYTES, cpu_to_be64(bytes)) ||
> +	    nla_put_be32(skb, NFTA_ACCT_USE, htonl(acct->use)))
> +		goto nla_put_failure;
> +
> +	nlmsg_end(skb, nlh);
> +
> +	return skb->len;
> +
> +nla_put_failure:
> +	nlmsg_trim(skb, nlh);
> +	return -1;
> +}
> +
> +static int nf_tables_acct_notify(const struct nft_ctx *ctx,
> +				 const struct nft_acct *acct,
> +				 int event, gfp_t gfp_flags)
> +{
> +	struct sk_buff *skb;
> +	u32 portid = ctx->portid;
> +	int err;
> +
> +	if (!ctx->report &&
> +	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
> +		return 0;
> +
> +	err = -ENOBUFS;
> +	skb = nlmsg_new(NLMSG_GOODSIZE, gfp_flags);
> +	if (!skb)
> +		goto err;
> +
> +	err = nf_tables_fill_acct(skb, ctx, acct, event, 0, 0);
> +	if (err < 0) {
> +		kfree_skb(skb);
> +		goto err;
> +	}
> +
> +	err = nfnetlink_send(skb, ctx->net, portid, NFNLGRP_NFTABLES,
> +			     ctx->report, gfp_flags);
> +err:
> +	if (err < 0)
> +		nfnetlink_set_err(ctx->net, portid, NFNLGRP_NFTABLES, err);
> +	return err;
> +}
> +
> +static int nf_tables_delacct(struct sock *nlsk, struct sk_buff *skb,
> +			     const struct nlmsghdr *nlh,
> +			     const struct nlattr * const nla[])
> +{
> +	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	struct nft_acct *acct;
> +	struct nft_ctx ctx;
> +	int err;
> +
> +	if (nfmsg->nfgen_family == NFPROTO_UNSPEC)
> +		return -EAFNOSUPPORT;
> +	if (!nla[NFTA_ACCT_TABLE])
> +		return -EINVAL;
> +
> +	err = nft_ctx_init_from_acct(&ctx, skb, nlh, nla);
> +	if (err < 0)
> +		return err;
> +
> +	acct = nf_tables_acct_lookup(ctx.table, nla[NFTA_ACCT_NAME]);
> +	if (IS_ERR(acct))
> +		return PTR_ERR(acct);
> +
> +	if (acct->use > 0)
> +		return -EBUSY;
> +
> +	return nft_delacct(&ctx, acct);
> +}
> +
> +static int nf_tables_dump_acct(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	const struct nft_acct *acct;
> +	unsigned int idx, s_idx = cb->args[0];
> +	struct nft_af_info *afi;
> +	struct nft_table *table, *cur_table = (struct nft_table *)cb->args[2];
> +	struct net *net = sock_net(skb->sk);
> +	int cur_family = cb->args[3];
> +	struct nft_ctx *ctx = cb->data, ctx_acct;
> +	u32 type;
> +
> +	if (cb->args[1])
> +		return skb->len;
> +
> +	rcu_read_lock();
> +	cb->seq = net->nft.base_seq;
> +
> +	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
> +		if (ctx->afi && ctx->afi != afi)
> +			continue;
> +
> +		if (cur_family) {
> +			if (afi->family != cur_family)
> +				continue;
> +
> +			cur_family = 0;
> +		}
> +		list_for_each_entry_rcu(table, &afi->tables, list) {
> +			if (ctx->table && ctx->table != table)
> +				continue;
> +
> +			if (cur_table) {
> +				if (cur_table != table)
> +					continue;
> +
> +				cur_table = NULL;
> +			}
> +			idx = 0;
> +			list_for_each_entry_rcu(acct, &table->accts, list) {
> +				if (idx < s_idx)
> +					goto cont;
> +
> +				ctx_acct = *ctx;
> +				ctx_acct.table = table;
> +				ctx_acct.afi = afi;
> +				type = NFNL_MSG_TYPE(cb->nlh->nlmsg_type);
> +				if (nf_tables_fill_acct(skb, &ctx_acct, acct,
> +							NFT_MSG_NEWACCT,
> +							NLM_F_MULTI, 0) < 0) {
> +					cb->args[0] = idx;
> +					cb->args[2] = (unsigned long)table;
> +					cb->args[3] = afi->family;
> +					goto done;
> +				}
> +				nl_dump_check_consistent(cb, nlmsg_hdr(skb));
> +cont:
> +				idx++;
> +			}
> +			if (s_idx)
> +				s_idx = 0;
> +		}
> +	}
> +	cb->args[1] = 1;
> +done:
> +	rcu_read_unlock();
> +	return skb->len;
> +}
> +
> +static int nf_tables_dump_acct_done(struct netlink_callback *cb)
> +{
> +	kfree(cb->data);
> +
> +	return 0;
> +}
> +
> +static int nf_tables_getacct(struct sock *nlsk, struct sk_buff *skb,
> +			     const struct nlmsghdr *nlh,
> +			     const struct nlattr * const nla[])

fix alignment:

static int foo(...
               ...
               ...)
{
        ...
}
