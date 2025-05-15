Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0912253B2
	for <netfilter-devel@vger.kernel.org>; Thu, 15 May 2025 12:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747312376; cv=none; b=PJv3tV9c8AQoq7AXjR1umHh4bKCe05ZnhXEUprdnrLQRDOOT1Ohl4B1V0sfpzro3W0QSDIIjKcYYQAhFJ5ySEaK5jrce2Q7V+UPLkkeqdQAqpBKOTJImIdcL6juzlUiSTIvqC8nXfZF912bzIfv+s5DcCAAu/DGsh67OQxYFIo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747312376; c=relaxed/simple;
	bh=Oia03EfadkNRmsbMb/st2++RHcnuvFjX8Q5FdDgccgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hfvMa3pKQV+wz3Q6x+9V4hklhqmEfJhrFSzQcZciHV1xYeaQ+xO7IcxV0iRK/UgjUjclu1NJafumc9qPU7U8Y7S9cAdmchK4R89OCs0qLv6AunP3E7hyBC94wDqStHkhLMz3hi8P+TfhmbHJSKCqAD7uzYqQAIuENlXNu6JUV8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=BoJw59gD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="BoJw59gD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vDgAb/Lz+O+KT0QCcTf2uKIe3EVvqjmpbv2GOnW+7NY=; b=BoJw59gD9MRQnXUOl5fXX3Is1L
	dbKcdUKLZq5ruDE3/MiMC+xWLCPmyjWEk/0pN51QNeggQip6jW/Nfd8ykbHdRKs0SpT+qgfpQHCbn
	CFwXAXmkuShxRXJbSU2aPWqxLPxwfH8OYfoTPvfO04DG0YfTkscaTwn+9Od7Ja1p6smX0gUfNPR/0
	grR8RBWLnPLulMdHEP5a93m3XIWWx1NJDkfHUTAbmPEBqgqlBdMx5ag42i6838tV6+8mqwjWM+jOQ
	bry3fgFm0HLsPGwWPCS2vZFCXLk3Xbma2gJkRtBwXTeKZJMAgy/Ar1XRu3E+o2TIUWEMKO8VT8EfM
	ZF1h+ngw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uFXla-000000007ad-42O4;
	Thu, 15 May 2025 14:32:51 +0200
Date: Thu, 15 May 2025 14:32:50 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v1 4/6] netfilter: nf_tables: add new binding
 infrastructure
Message-ID: <aCXe8vmQ-P6EQqN2@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250514214216.828862-1-pablo@netfilter.org>
 <20250514214216.828862-5-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514214216.828862-5-pablo@netfilter.org>

On Wed, May 14, 2025 at 11:42:14PM +0200, Pablo Neira Ayuso wrote:
> Add new binding infrastructure to build a graph that relates chains and
> sets via jump/goto such as:
> 
> - chain to chain, ie. rule jump/goto chain.
> - set to chain, ie. set element jump/goto chain.
> - chain to set, ie. rule lookup to set.
> 
> The binding is composed of two tuples that describe [ from, to ], each
> component of this tuple is defined as the object type and the pointer to
> the object. This patch adds a hashtable for bindings per table to allow
> for lookups of existing bindings in the preparation phase.
> 
> The bindings allows to backtrack to the basechain that refers to
> this object for validation, and to go forward to check for loops
> and to perform the rule validation.
> 
> This patch adds interfaces to deactivate/activate these bindings during
> the preparation phase. Reference counter of zero tells us this binding
> will be removed after this transaction.
> 
> This is still a preparation patch, a follow patch uses this infrastructure.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_tables.h |  45 ++++
>  net/netfilter/nf_tables_api.c     | 352 ++++++++++++++++++++++++++++++
>  2 files changed, 397 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index d391990d1a96..807097746d24 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -585,6 +585,8 @@ struct nft_set_elem_expr {
>  struct nft_set {
>  	struct list_head		list;
>  	struct list_head		bindings;
> +	struct list_head		binding_list;
> +	struct list_head		backbinding_list;
>  	refcount_t			refs;
>  	struct nft_table		*table;
>  	possible_net_t			net;
> @@ -1117,6 +1119,8 @@ struct nft_rule_blob {
>  struct nft_chain {
>  	struct nft_rule_blob		__rcu *blob_gen_0;
>  	struct nft_rule_blob		__rcu *blob_gen_1;
> +	struct list_head		binding_list;
> +	struct list_head		backbinding_list;
>  	struct list_head		rules;
>  	struct list_head		list;
>  	struct list_head		validate_list;

One could get away with just a single list by inserting the reverse ones
up front and appending the forward ones. While traversing, one would
either traverse forward or reverse and stop once the 'to' or 'from'
pointer doesn't match the current chain/set anymore. Maybe not worth to
save the 16B per set and chain, though.

> @@ -1293,6 +1297,7 @@ struct nft_table {
>  	struct list_head		sets;
>  	struct list_head		objects;
>  	struct list_head		flowtables;
> +	struct rhashtable		bindings_ht;
>  	u64				hgenerator;
>  	u64				handle;
>  	u32				use;
> @@ -1628,6 +1633,46 @@ static inline int nft_set_elem_is_dead(const struct nft_set_ext *ext)
>  	return test_bit(NFT_SET_ELEM_DEAD_BIT, word);
>  }
>  
> +enum nft_binding_type {
> +        NFT_BIND_CHAIN	= 0,
> +        NFT_BIND_SET,
> +};
> +
> +/* Bindings. */
> +struct nft_binding_key {
> +	union {
> +		const struct nft_chain	*chain;
> +		const struct nft_set	*set;
> +		const void		*ptr;
> +	};
> +	enum nft_binding_type		type;
> +};
> +
> +struct nft_binding {
> +	struct rhash_head		node;
> +	struct list_head		list;
> +	struct list_head		backlist;
> +	struct nft_binding_key		from;
> +	struct nft_binding_key		to;
> +	uint32_t			use;
> +};
> +
> +struct nft_chain;
> +struct nft_set;
> +
> +int nft_add_chain_binding(struct nft_chain *chain1, struct nft_chain *chain2);
> +void nft_activate_chain_binding(struct nft_chain *chain1, struct nft_chain *chain2);
> +void nft_deactivate_chain_binding(struct nft_chain *chain1, struct nft_chain *chain2);
> +void nft_del_chain_binding(struct nft_chain *chain1, struct nft_chain *chain2);
> +int nft_add_chain_set_binding(struct nft_chain *chain, struct nft_set *set);
> +void nft_deactivate_chain_set_binding(struct nft_chain *chain, struct nft_set *set);
> +void nft_activate_chain_set_binding(struct nft_chain *chain, struct nft_set *set);
> +void nft_del_chain_set_binding(struct nft_chain *chain, struct nft_set *set);
> +int nft_add_set_chain_binding(struct nft_set *set, struct nft_chain *chain);
> +void nft_deactivate_set_chain_binding(struct nft_set *set, struct nft_chain *chain);
> +void nft_activate_set_chain_binding(struct nft_set *set, struct nft_chain *chain);
> +void nft_del_set_chain_binding(struct nft_set *set, struct nft_chain *chain);
> +
>  /**
>   * struct nft_trans - nf_tables object update in transaction
>   *
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index d35cad55c99b..463ee7b4ec19 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -954,6 +954,347 @@ void __nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg)
>  }
>  EXPORT_SYMBOL_GPL(__nft_reg_track_cancel);
>  
> +struct nft_binding_cmp_key {
> +	const struct nft_binding_key	*from;
> +	const struct nft_binding_key	*to;
> +};
> +
> +static u32 nft_binding_hash(const void *data, u32 len, u32 seed)
> +{
> +	const struct nft_binding_cmp_key *key = data;
> +	unsigned long tuple[4];
> +
> +	tuple[0] = (unsigned long)key->from->ptr;
> +	tuple[1] = (unsigned long)key->from->type;
> +	tuple[2] = (unsigned long)key->to->ptr;
> +	tuple[3] = (unsigned long)key->to->type;
> +
> +	return jhash(tuple, sizeof(tuple), seed);
> +}
> +
> +static u32 nft_binding_hash_obj(const void *data, u32 len, u32 seed)
> +{
> +	const struct nft_binding *binding = data;
> +	unsigned long tuple[4];
> +
> +	tuple[0] = (unsigned long)binding->from.ptr;
> +	tuple[1] = (unsigned long)binding->from.type;
> +	tuple[2] = (unsigned long)binding->to.ptr;
> +	tuple[3] = (unsigned long)binding->to.type;
> +
> +	return jhash(tuple, sizeof(tuple), seed);
> +}
> +
> +static int nft_binding_hash_cmp(struct rhashtable_compare_arg *arg,
> +				const void *ptr)
> +{
> +	const struct nft_binding_cmp_key *key = arg->key;
> +	const struct nft_binding *binding = ptr;
> +
> +	return key->from->ptr != binding->from.ptr ||
> +	       key->from->type != binding->from.type ||
> +	       key->to->ptr != binding->to.ptr ||
> +	       key->to->type != binding->to.type;
> +}
> +
> +static const struct rhashtable_params nft_binding_ht_params = {
> +	.head_offset		= offsetof(struct nft_binding, node),
> +	.hashfn			= nft_binding_hash,
> +	.obj_hashfn		= nft_binding_hash_obj,
> +	.obj_cmpfn		= nft_binding_hash_cmp,
> +	.automatic_shrinking	= true,
> +};
> +
> +static struct nft_binding *nft_binding_lookup(struct nft_table *table,
> +					      const struct nft_binding_key *from,
> +					      const struct nft_binding_key *to)
> +{
> +	struct nft_binding_cmp_key key = {
> +		.from	= from,
> +		.to	= to,
> +	};
> +
> +	return rhashtable_lookup_fast(&table->bindings_ht, &key,
> +				      nft_binding_ht_params);
> +}
> +
> +static void nft_deactivate_binding(struct nft_table *table,
> +				   const struct nft_binding_key *from,
> +				   const struct nft_binding_key *to)

Changing the signature to:

| static void nft_deactivate_binding(struct nft_table *table,
|				     void *from, enum nft_binding_type typef,
|				     void *to, enum nft_binding_type typet)

> +{
> +	struct nft_binding *binding;

And creating the keys here:

|	struct nft_binding_key from = { .ptr = from, .type = typef };
|	struct nft_binding_key to = { .ptr = to, .type = typet };

> +
> +	binding = nft_binding_lookup(table, from, to);
> +	if (WARN_ON_ONCE(!binding))
> +		return;
> +	if (WARN_ON_ONCE(binding->use == 0))
> +		return;
> +
> +	binding->use--;
> +}
> +
> +void nft_deactivate_chain_binding(struct nft_chain *chain1,
> +				  struct nft_chain *chain2)
> +{
> +	struct nft_binding_key from = {
> +		.ptr	= chain1,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +	struct nft_binding_key to = {
> +		.ptr	= chain2,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +
> +	nft_deactivate_binding(chain1->table, &from, &to);
> +}

Would reduce the above and following functions to one-line wrappers,
like:

| {
|	nft_deactivate_binding(chain1->table,
|			       chain1, NFT_BIND_CHAIN,
|			       chain2, NFT_BIND_CHAIN);
| }

This could also be just a macro, too.

> +
> +void nft_deactivate_chain_set_binding(struct nft_chain *chain,
> +				      struct nft_set *set)
> +{
> +	struct nft_binding_key from = {
> +		.ptr	= chain,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +	struct nft_binding_key to = {
> +		.ptr	= set,
> +		.type	= NFT_BIND_SET,
> +	};
> +
> +	nft_deactivate_binding(chain->table, &from, &to);
> +}
> +
> +void nft_deactivate_set_chain_binding(struct nft_set *set,
> +				      struct nft_chain *chain)
> +{
> +	struct nft_binding_key from = {
> +		.ptr	= set,
> +		.type	= NFT_BIND_SET,
> +	};
> +	struct nft_binding_key to = {
> +		.ptr	= chain,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +
> +	nft_deactivate_binding(chain->table, &from, &to);
> +}
> +
> +static void nft_activate_binding(struct nft_table *table,
> +				 const struct nft_binding_key *from,
> +				 const struct nft_binding_key *to)
> +{
> +	struct nft_binding *binding;
> +
> +	binding = nft_binding_lookup(table, from, to);
> +	if (WARN_ON_ONCE(!binding))
> +		return;
> +
> +	binding->use++;
> +}
> +
> +void nft_activate_chain_binding(struct nft_chain *chain1,
> +				struct nft_chain *chain2)
> +{
> +	struct nft_binding_key from = {
> +		.ptr	= chain1,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +	struct nft_binding_key to = {
> +		.ptr	= chain2,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +
> +	nft_activate_binding(chain1->table, &from, &to);
> +}
> +
> +void nft_activate_chain_set_binding(struct nft_chain *chain,
> +				    struct nft_set *set)
> +{
> +	struct nft_binding_key from = {
> +		.ptr	= chain,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +	struct nft_binding_key to = {
> +		.ptr	= set,
> +		.type	= NFT_BIND_SET,
> +	};
> +
> +	nft_activate_binding(chain->table, &from, &to);
> +}
> +
> +void nft_activate_set_chain_binding(struct nft_set *set,
> +				    struct nft_chain *chain)
> +{
> +	struct nft_binding_key from = {
> +		.ptr	= set,
> +		.type	= NFT_BIND_SET,
> +	};
> +	struct nft_binding_key to = {
> +		.ptr	= chain,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +
> +	nft_activate_binding(chain->table, &from, &to);
> +}
> +
> +static void nft_del_binding(struct nft_table *table,
> +			    const struct nft_binding_key *from,
> +			    const struct nft_binding_key *to)
> +{
> +	struct nft_binding *binding;
> +	int err;
> +
> +	binding = nft_binding_lookup(table, from, to);
> +	/* With several references to object, deactivate deals to zero use,
> +	 * then first delete binding call remove it.
> +	 */
> +	if (!binding)
> +		return;
> +
> +	if (binding->use != 0)
> +		return;

The asymmetry between add and del in that add increments the use-counter
while del does not decrement is a bit confusing. I believe it is an
optimization since add is always followed by enable otherwise?

I also wonder, does the code expectedly call del for enabled bindings or
is this a bug and there should be a warning above?

Cheers, Phil

> +
> +	list_del(&binding->list);
> +	list_del(&binding->backlist);
> +
> +	err = rhashtable_remove_fast(&table->bindings_ht,
> +				     &binding->node, nft_binding_ht_params);
> +	if (WARN_ON_ONCE(err < 0))
> +		return;
> +
> +	kfree(binding);
> +}
> +
> +void nft_del_chain_binding(struct nft_chain *chain1, struct nft_chain *chain2)
> +{
> +	struct nft_binding_key from = {
> +		.ptr	= chain1,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +	struct nft_binding_key to = {
> +		.ptr	= chain2,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +
> +	nft_del_binding(chain1->table, &from, &to);
> +}
> +
> +void nft_del_chain_set_binding(struct nft_chain *chain, struct nft_set *set)
> +{
> +	struct nft_binding_key from = {
> +		.ptr	= chain,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +	struct nft_binding_key to = {
> +		.ptr	= set,
> +		.type	= NFT_BIND_SET,
> +	};
> +
> +	nft_del_binding(chain->table, &from, &to);
> +}
> +
> +void nft_del_set_chain_binding(struct nft_set *set, struct nft_chain *chain)
> +{
> +	struct nft_binding_key from = {
> +		.ptr	= set,
> +		.type	= NFT_BIND_SET,
> +	};
> +	struct nft_binding_key to = {
> +		.ptr	= chain,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +
> +	nft_del_binding(chain->table, &from, &to);
> +}
> +
> +static int __nft_add_binding(struct nft_table *table,
> +			     const struct nft_binding_key *from,
> +			     const struct nft_binding_key *to,
> +			     struct list_head *binding_list,
> +			     struct list_head *backbinding_list)
> +{
> +	struct nft_binding *binding;
> +
> +	binding = kzalloc(sizeof(struct nft_binding), GFP_KERNEL);
> +	if (!binding)
> +		return -ENOMEM;
> +
> +	binding->from = *from;
> +	binding->to = *to;
> +	binding->use++;
> +
> +	list_add_tail(&binding->list, binding_list);
> +	list_add_tail(&binding->backlist, backbinding_list);
> +
> +	return rhashtable_insert_fast(&table->bindings_ht, &binding->node,
> +				      nft_binding_ht_params);
> +}
> +
> +static int nft_add_binding(struct nft_table *table,
> +			   const struct nft_binding_key *from,
> +			   const struct nft_binding_key *to,
> +			   struct list_head *binding_list,
> +			   struct list_head *backbinding_list)
> +{
> +	struct nft_binding *binding;
> +
> +	binding = nft_binding_lookup(table, from, to);
> +	if (!binding)
> +		return __nft_add_binding(table, from, to,
> +					 binding_list, backbinding_list);
> +
> +	if (binding->use == UINT_MAX)
> +		return -EOVERFLOW;
> +
> +	binding->use++;
> +
> +	return 0;
> +}
> +
> +int nft_add_chain_binding(struct nft_chain *chain1, struct nft_chain *chain2)
> +{
> +	struct nft_binding_key from = {
> +		.ptr	= chain1,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +	struct nft_binding_key to = {
> +		.ptr	= chain2,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +
> +	return nft_add_binding(chain1->table, &from, &to,
> +			       &chain1->binding_list, &chain2->backbinding_list);
> +}
> +
> +int nft_add_chain_set_binding(struct nft_chain *chain, struct nft_set *set)
> +{
> +	struct nft_binding_key from = {
> +		.ptr	= chain,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +	struct nft_binding_key to = {
> +		.ptr	= set,
> +		.type	= NFT_BIND_SET,
> +	};
> +
> +	return nft_add_binding(chain->table, &from, &to,
> +			       &chain->binding_list, &set->backbinding_list);
> +}
> +
> +int nft_add_set_chain_binding(struct nft_set *set, struct nft_chain *chain)
> +{
> +	struct nft_binding_key from = {
> +		.ptr	= set,
> +		.type	= NFT_BIND_SET,
> +	};
> +	struct nft_binding_key to = {
> +		.ptr	= chain,
> +		.type	= NFT_BIND_CHAIN,
> +	};
> +
> +	return nft_add_binding(chain->table, &from, &to,
> +			       &set->binding_list, &chain->backbinding_list);
> +}
> +
>  /*
>   * Tables
>   */
> @@ -1611,6 +1952,10 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
>  	if (err)
>  		goto err_chain_ht;
>  
> +	err = rhashtable_init(&table->bindings_ht, &nft_binding_ht_params);
> +	if (err)
> +		goto err_binding_ht;
> +
>  	INIT_LIST_HEAD(&table->chains);
>  	INIT_LIST_HEAD(&table->sets);
>  	INIT_LIST_HEAD(&table->objects);
> @@ -1629,6 +1974,8 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
>  	list_add_tail_rcu(&table->list, &nft_net->tables);
>  	return 0;
>  err_trans:
> +	rhashtable_destroy(&table->bindings_ht);
> +err_binding_ht:
>  	rhltable_destroy(&table->chains_ht);
>  err_chain_ht:
>  	kfree(table->udata);
> @@ -1794,6 +2141,7 @@ static void nf_tables_table_destroy(struct nft_table *table)
>  	if (WARN_ON(table->use > 0))
>  		return;
>  
> +	rhashtable_destroy(&table->bindings_ht);
>  	rhltable_destroy(&table->chains_ht);
>  	kfree(table->name);
>  	kfree(table->udata);
> @@ -2691,6 +3039,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
>  	ctx->chain = chain;
>  
>  	INIT_LIST_HEAD(&chain->rules);
> +	INIT_LIST_HEAD(&chain->binding_list);
> +	INIT_LIST_HEAD(&chain->backbinding_list);
>  	chain->handle = nf_tables_alloc_handle(table);
>  	chain->table = table;
>  
> @@ -5523,6 +5873,8 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
>  	}
>  
>  	INIT_LIST_HEAD(&set->bindings);
> +	INIT_LIST_HEAD(&set->binding_list);
> +	INIT_LIST_HEAD(&set->backbinding_list);
>  	INIT_LIST_HEAD(&set->catchall_list);
>  	refcount_set(&set->refs, 1);
>  	set->table = table;
> -- 
> 2.30.2
> 
> 
> 
