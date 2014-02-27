From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] netfilter: nft_hash: bug fixes and resizing
Date: Thu, 27 Feb 2014 11:47:34 -0800
Message-ID: <20140227194734.GV8264@linux.vnet.ibm.com>
References: <1393512980-28780-1-git-send-email-kaber@trash.net>
 <1393512980-28780-2-git-send-email-kaber@trash.net>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	josh@joshtriplett.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:59544 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaB0Tri (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:47:38 -0500
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
	Thu, 27 Feb 2014 12:47:37 -0700
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 05DD519D8036
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2014 12:47:34 -0700 (MST)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by b03cxnp07029.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1RHisET11731214
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2014 18:44:54 +0100
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id s1RJp3cI006107
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2014 12:51:03 -0700
Content-Disposition: inline
In-Reply-To: <1393512980-28780-2-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 27, 2014 at 02:56:20PM +0000, Patrick McHardy wrote:
> The hash set type is very broken and was never meant to be merged in this
> state. Missing RCU synchronization on element removal, leaking chain
> refcounts when used as a verdict map, races during lookups, a fixed table
> size are probably just some of the problems. Luckily it is currently
> never chosen by the kernel when the rbtree type is also available.
> 
> Rewrite it to be usable.
> 
> The new implementation supports automatic hash table resizing using RCU,
> based on Paul McKenney's and Josh Triplett's algorithm "Optimized Resizing
> For RCU-Protected Hash Tables" described in [1].
> 
> Resizing doesn't require a second list head in the elements, it works by
> chosing a hash function that remaps elements to a predictable set of buckets,
> only resizing by integral factors and
> 
> - during expansion: linking new buckets to the old bucket that contains
>   elements for any of the new buckets, thereby creating imprecise chains,
>   then incrementally seperating the elements until the new buckets only
>   contain elements that hash directly to them.
> 
> - during shrinking: linking the hash chains of all old buckets that hash
>   to the same new bucket to form a single chain.
> 
> Expansion requires at most the number of elements in the longest hash chain
> grace periods, shrinking requires a single grace period.
> 
> Due to the requirement of having hash chains/elements linked to multiple
> buckets during resizing, homemade single linked lists are used instead of
> the existing list helpers, that don't support this in a clean fashion.
> As a side effect, the amount of memory required per element is reduced by
> one pointer.
> 
> Expansion is triggered when the load factors exceeds 75%, shrinking when
> the load factor goes below 30%. Both operations are allowed to fail and
> will be retried on the next insertion or removal if their respective
> conditions still hold.
> 
> [1] http://dl.acm.org/citation.cfm?id=2002181.2002192
> 
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

A few comments below, one suggested change.  With or without that change,
but with the changes suggested by Josh Triplett:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  net/netfilter/nft_hash.c | 249 ++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 203 insertions(+), 46 deletions(-)
> 
> diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
> index 3d3f8fc..9e289d1 100644
> --- a/net/netfilter/nft_hash.c
> +++ b/net/netfilter/nft_hash.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
> + * Copyright (c) 2008-2014 Patrick McHardy <kaber@trash.net>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -18,17 +18,29 @@
>  #include <linux/netfilter/nf_tables.h>
>  #include <net/netfilter/nf_tables.h>
> 
> +#define NFT_HASH_MIN_SIZE	4
> +
>  struct nft_hash {
> -	struct hlist_head	*hash;
> -	unsigned int		hsize;
> +	struct nft_hash_table __rcu	*tbl;
> +};
> +
> +struct nft_hash_table {
> +	unsigned int			size;
> +	unsigned int			elements;
> +	struct nft_hash_elem __rcu	*buckets[];
>  };
> 
>  struct nft_hash_elem {
> -	struct hlist_node	hnode;
> -	struct nft_data		key;
> -	struct nft_data		data[];
> +	struct nft_hash_elem __rcu	*next;
> +	struct nft_data			key;
> +	struct nft_data			data[];
>  };
> 
> +#define nft_hash_for_each_entry(i, head) \
> +	for (i = nft_dereference(head); i != NULL; i = nft_dereference(i->next))
> +#define nft_hash_for_each_entry_rcu(i, head) \
> +	for (i = rcu_dereference(head); i != NULL; i = rcu_dereference(i->next))
> +
>  static u32 nft_hash_rnd __read_mostly;
>  static bool nft_hash_rnd_initted __read_mostly;
> 
> @@ -38,7 +50,7 @@ static unsigned int nft_hash_data(const struct nft_data *data,
>  	unsigned int h;
> 
>  	h = jhash(data->data, len, nft_hash_rnd);
> -	return ((u64)h * hsize) >> 32;
> +	return h & (hsize - 1);
>  }
> 
>  static bool nft_hash_lookup(const struct nft_set *set,
> @@ -46,11 +58,12 @@ static bool nft_hash_lookup(const struct nft_set *set,
>  			    struct nft_data *data)
>  {
>  	const struct nft_hash *priv = nft_set_priv(set);
> +	const struct nft_hash_table *tbl = rcu_dereference(priv->tbl);
>  	const struct nft_hash_elem *he;
>  	unsigned int h;
> 
> -	h = nft_hash_data(key, priv->hsize, set->klen);
> -	hlist_for_each_entry(he, &priv->hash[h], hnode) {
> +	h = nft_hash_data(key, tbl->size, set->klen);
> +	nft_hash_for_each_entry_rcu(he, tbl->buckets[h]) {
>  		if (nft_data_cmp(&he->key, key, set->klen))
>  			continue;
>  		if (set->flags & NFT_SET_MAP)
> @@ -60,19 +73,137 @@ static bool nft_hash_lookup(const struct nft_set *set,
>  	return false;
>  }
> 
> -static void nft_hash_elem_destroy(const struct nft_set *set,
> -				  struct nft_hash_elem *he)
> +static struct nft_hash_table *nft_hash_tbl_alloc(unsigned int size)
>  {
> -	nft_data_uninit(&he->key, NFT_DATA_VALUE);
> -	if (set->flags & NFT_SET_MAP)
> -		nft_data_uninit(he->data, set->dtype);
> -	kfree(he);
> +	struct nft_hash_table *tbl;
> +
> +	tbl = kzalloc(sizeof(*tbl) + size * sizeof(tbl->buckets[0]),
> +		      GFP_KERNEL);
> +	if (tbl == NULL)
> +		return NULL;
> +	tbl->size = size;
> +
> +	return tbl;
> +}
> +
> +static void nft_hash_chain_unzip(const struct nft_set *set,
> +				 const struct nft_hash_table *ntbl,
> +				 struct nft_hash_table *tbl, unsigned int n)
> +{
> +	struct nft_hash_elem *he, *last, *next;
> +	unsigned int h;

Not seeing any per-hash-chain locking, so the table is presumably globally
locked.  (Also no locks in the hash-bucket data structure, so to be
expected.)  This would mean that insertions and deletions can be blocked
for some milliseconds by resize operations, but presumably this is OK
for your workload.

> +
> +	he = nft_dereference(tbl->buckets[n]);
> +	if (he == NULL)
> +		return;
> +	h = nft_hash_data(&he->key, ntbl->size, set->klen);
> +
> +	/* Find last element of first chain hashing to bucket h */
> +	last = he;
> +	nft_hash_for_each_entry(he, he->next) {
> +		if (nft_hash_data(&he->key, ntbl->size, set->klen) != h)
> +			break;
> +		last = he;
> +	}
> +
> +	/* Unlink first chain from the old table */
> +	RCU_INIT_POINTER(tbl->buckets[n], last->next);

The above surprised me, but reading further, I see that you have a
synchronized_rcu() in nft_hash_tbl_expand() between publishing the new
hash table and doing the first round of unzip.

(And no, it should not have surprised me, given that this is exactly
what the paper says to do, but hey!)

RCU_INIT_POINTER() is correct here because the data being linked is
already exposed to readers.  Ditto for the other RCU_INIT_POINTER()
instances in this patch.

> +
> +	/* If end of chain reached, done */
> +	if (he == NULL)
> +		return;
> +
> +	/* Find first element of second chain hashing to bucket h */
> +	next = NULL;
> +	nft_hash_for_each_entry(he, he->next) {
> +		if (nft_hash_data(&he->key, ntbl->size, set->klen) != h)
> +			continue;
> +		next = he;
> +		break;
> +	}
> +
> +	/* Link the two chains */
> +	RCU_INIT_POINTER(last->next, next);
> +}
> +
> +static int nft_hash_tbl_expand(const struct nft_set *set, struct nft_hash *priv)
> +{
> +	struct nft_hash_table *tbl = nft_dereference(priv->tbl), *ntbl;
> +	struct nft_hash_elem *he;
> +	unsigned int i, h;
> +	bool complete;
> +
> +	ntbl = nft_hash_tbl_alloc(tbl->size * 2);
> +	if (ntbl == NULL)
> +		return -ENOMEM;
> +
> +	/* Link new table's buckets to first element in the old table
> +	 * hashing to the new bucket.
> +	 */
> +	for (i = 0; i < ntbl->size; i++) {
> +		h = i < tbl->size ? i : i - tbl->size;
> +		nft_hash_for_each_entry(he, tbl->buckets[h]) {
> +			if (nft_hash_data(&he->key, ntbl->size, set->klen) != i)
> +				continue;
> +			RCU_INIT_POINTER(ntbl->buckets[i], he);
> +			break;
> +		}
> +	}
> +	ntbl->elements = tbl->elements;
> +
> +	/* Publish new table */
> +	rcu_assign_pointer(priv->tbl, ntbl);
> +
> +	/* Unzip interleaved hash chains */
> +	do {
> +		/* Wait for readers to use new table/unzipped chains */
> +		synchronize_rcu();
> +
> +		complete = true;
> +		for (i = 0; i < tbl->size; i++) {
> +			nft_hash_chain_unzip(set, ntbl, tbl, i);
> +			if (tbl->buckets[i] != NULL)
> +				complete = false;

Probably not worth it, but you could track the first and last elements
needing unzipping.

> +		}
> +	} while (!complete);
> +
> +	kfree(tbl);
> +	return 0;
> +}
> +
> +static int nft_hash_tbl_shrink(const struct nft_set *set, struct nft_hash *priv)
> +{
> +	struct nft_hash_table *tbl = nft_dereference(priv->tbl), *ntbl;
> +	struct nft_hash_elem __rcu **pprev;
> +	unsigned int i;
> +
> +	ntbl = nft_hash_tbl_alloc(tbl->size / 2);
> +	if (ntbl == NULL)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < ntbl->size; i++) {
> +		ntbl->buckets[i] = tbl->buckets[i];
> +
> +		for (pprev = &ntbl->buckets[i]; *pprev != NULL;
> +		     pprev = &nft_dereference(*pprev)->next)
> +			;
> +		RCU_INIT_POINTER(*pprev, tbl->buckets[i + ntbl->size]);
> +	}
> +	ntbl->elements = tbl->elements;
> +
> +	/* Publish new table */
> +	rcu_assign_pointer(priv->tbl, ntbl);
> +	synchronize_rcu();
> +
> +	kfree(tbl);
> +	return 0;
>  }
> 
>  static int nft_hash_insert(const struct nft_set *set,
>  			   const struct nft_set_elem *elem)
>  {
>  	struct nft_hash *priv = nft_set_priv(set);
> +	struct nft_hash_table *tbl = nft_dereference(priv->tbl);
>  	struct nft_hash_elem *he;
>  	unsigned int size, h;
> 
> @@ -91,33 +222,66 @@ static int nft_hash_insert(const struct nft_set *set,
>  	if (set->flags & NFT_SET_MAP)
>  		nft_data_copy(he->data, &elem->data);
> 
> -	h = nft_hash_data(&he->key, priv->hsize, set->klen);
> -	hlist_add_head_rcu(&he->hnode, &priv->hash[h]);
> +	h = nft_hash_data(&he->key, tbl->size, set->klen);
> +	RCU_INIT_POINTER(he->next, tbl->buckets[h]);
> +	rcu_assign_pointer(tbl->buckets[h], he);
> +	tbl->elements++;
> +
> +	/* Expand table when exceeding 75% load */
> +	if (tbl->elements * 4 / 3 > tbl->size)
> +		nft_hash_tbl_expand(set, priv);
> +
>  	return 0;
>  }
> 
> +static void nft_hash_elem_destroy(const struct nft_set *set,
> +				  struct nft_hash_elem *he)
> +{
> +	nft_data_uninit(&he->key, NFT_DATA_VALUE);
> +	if (set->flags & NFT_SET_MAP)
> +		nft_data_uninit(he->data, set->dtype);
> +	kfree(he);
> +}
> +
>  static void nft_hash_remove(const struct nft_set *set,
>  			    const struct nft_set_elem *elem)
>  {
> -	struct nft_hash_elem *he = elem->cookie;
> +	struct nft_hash *priv = nft_set_priv(set);
> +	struct nft_hash_table *tbl = nft_dereference(priv->tbl);
> +	struct nft_hash_elem *he, __rcu **pprev;
> 
> -	hlist_del_rcu(&he->hnode);
> +	pprev = elem->cookie;
> +	he = nft_dereference((*pprev));
> +
> +	RCU_INIT_POINTER(*pprev, he->next);
> +	synchronize_rcu();
>  	kfree(he);
> +	tbl->elements--;
> +
> +	/* Shrink table beneath 30% load */
> +	if (tbl->elements * 10 / 3 < tbl->size &&
> +	    tbl->size > NFT_HASH_MIN_SIZE)
> +		nft_hash_tbl_shrink(set, priv);
>  }
> 
>  static int nft_hash_get(const struct nft_set *set, struct nft_set_elem *elem)
>  {
>  	const struct nft_hash *priv = nft_set_priv(set);
> +	const struct nft_hash_table *tbl = nft_dereference(priv->tbl);
> +	struct nft_hash_elem __rcu * const *pprev;
>  	struct nft_hash_elem *he;
>  	unsigned int h;
> 
> -	h = nft_hash_data(&elem->key, priv->hsize, set->klen);
> -	hlist_for_each_entry(he, &priv->hash[h], hnode) {
> -		if (nft_data_cmp(&he->key, &elem->key, set->klen))
> +	h = nft_hash_data(&elem->key, tbl->size, set->klen);
> +	pprev = &tbl->buckets[h];
> +	nft_hash_for_each_entry(he, tbl->buckets[h]) {
> +		if (nft_data_cmp(&he->key, &elem->key, set->klen)) {
> +			pprev = &he->next;
>  			continue;
> +		}
> 
> -		elem->cookie = he;
> -		elem->flags  = 0;
> +		elem->cookie = (void *)pprev;
> +		elem->flags = 0;
>  		if (set->flags & NFT_SET_MAP)
>  			nft_data_copy(&elem->data, he->data);
>  		return 0;
> @@ -129,12 +293,13 @@ static void nft_hash_walk(const struct nft_ctx *ctx, const struct nft_set *set,
>  			  struct nft_set_iter *iter)
>  {
>  	const struct nft_hash *priv = nft_set_priv(set);
> +	const struct nft_hash_table *tbl = nft_dereference(priv->tbl);
>  	const struct nft_hash_elem *he;
>  	struct nft_set_elem elem;
>  	unsigned int i;
> 
> -	for (i = 0; i < priv->hsize; i++) {
> -		hlist_for_each_entry(he, &priv->hash[i], hnode) {
> +	for (i = 0; i < tbl->size; i++) {
> +		nft_hash_for_each_entry(he, tbl->buckets[i]) {
>  			if (iter->count < iter->skip)
>  				goto cont;

I might be confused, but it looks like the "iter->count++" in the code
below this (not in this patch) could be added to the for() statement,
the "goto cont" be made into "continue", and the "cont" label eliminated.

> @@ -161,43 +326,35 @@ static int nft_hash_init(const struct nft_set *set,
>  			 const struct nlattr * const tb[])
>  {
>  	struct nft_hash *priv = nft_set_priv(set);
> -	unsigned int cnt, i;
> +	struct nft_hash_table *tbl;
> 
>  	if (unlikely(!nft_hash_rnd_initted)) {
>  		get_random_bytes(&nft_hash_rnd, 4);
>  		nft_hash_rnd_initted = true;
>  	}
> 
> -	/* Aim for a load factor of 0.75 */
> -	// FIXME: temporarily broken until we have set descriptions
> -	cnt = 100;
> -	cnt = cnt * 4 / 3;
> -
> -	priv->hash = kcalloc(cnt, sizeof(struct hlist_head), GFP_KERNEL);
> -	if (priv->hash == NULL)
> +	tbl = nft_hash_tbl_alloc(NFT_HASH_MIN_SIZE);
> +	if (tbl == NULL)
>  		return -ENOMEM;
> -	priv->hsize = cnt;
> -
> -	for (i = 0; i < cnt; i++)
> -		INIT_HLIST_HEAD(&priv->hash[i]);
> -
> +	RCU_INIT_POINTER(priv->tbl, tbl);
>  	return 0;
>  }
> 
>  static void nft_hash_destroy(const struct nft_set *set)
>  {
>  	const struct nft_hash *priv = nft_set_priv(set);
> -	const struct hlist_node *next;
> -	struct nft_hash_elem *elem;
> +	const struct nft_hash_table *tbl = nft_dereference(priv->tbl);
> +	struct nft_hash_elem *he, *next;
>  	unsigned int i;
> 
> -	for (i = 0; i < priv->hsize; i++) {
> -		hlist_for_each_entry_safe(elem, next, &priv->hash[i], hnode) {
> -			hlist_del(&elem->hnode);
> -			nft_hash_elem_destroy(set, elem);
> +	for (i = 0; i < tbl->size; i++) {
> +		for (he = nft_dereference(tbl->buckets[i]); he != NULL;
> +		     he = next) {
> +			next = nft_dereference(he->next);
> +			nft_hash_elem_destroy(set, he);
>  		}
>  	}
> -	kfree(priv->hash);
> +	kfree(tbl);
>  }
> 
>  static struct nft_set_ops nft_hash_ops __read_mostly = {
> -- 
> 1.8.5.3
> 

