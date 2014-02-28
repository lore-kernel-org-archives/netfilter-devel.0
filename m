From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nft_hash: bug fixes and resizing
Date: Fri, 28 Feb 2014 11:28:32 +0000
Message-ID: <20140228112831.GC697@macbook.localnet>
References: <1393512980-28780-1-git-send-email-kaber@trash.net>
 <1393512980-28780-2-git-send-email-kaber@trash.net>
 <20140227194734.GV8264@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	josh@joshtriplett.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33509 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaB1L2f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:28:35 -0500
Content-Disposition: inline
In-Reply-To: <20140227194734.GV8264@linux.vnet.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 27, 2014 at 11:47:34AM -0800, Paul E. McKenney wrote:
> On Thu, Feb 27, 2014 at 02:56:20PM +0000, Patrick McHardy wrote:
> 
> A few comments below, one suggested change.  With or without that change,
> but with the changes suggested by Josh Triplett:
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks Paul!

> > +static void nft_hash_chain_unzip(const struct nft_set *set,
> > +				 const struct nft_hash_table *ntbl,
> > +				 struct nft_hash_table *tbl, unsigned int n)
> > +{
> > +	struct nft_hash_elem *he, *last, *next;
> > +	unsigned int h;
> 
> Not seeing any per-hash-chain locking, so the table is presumably globally
> locked.  (Also no locks in the hash-bucket data structure, so to be
> expected.)  This would mean that insertions and deletions can be blocked
> for some milliseconds by resize operations, but presumably this is OK
> for your workload.

Correct, all nftables operations are serialized by the nfnetlink nftables
mutex. The number of grace periods required should be very low (1-2), so
hopefully this won't matter. We do require more in other contexts already.

> > +	he = nft_dereference(tbl->buckets[n]);
> > +	if (he == NULL)
> > +		return;
> > +	h = nft_hash_data(&he->key, ntbl->size, set->klen);
> > +
> > +	/* Find last element of first chain hashing to bucket h */
> > +	last = he;
> > +	nft_hash_for_each_entry(he, he->next) {
> > +		if (nft_hash_data(&he->key, ntbl->size, set->klen) != h)
> > +			break;
> > +		last = he;
> > +	}
> > +
> > +	/* Unlink first chain from the old table */
> > +	RCU_INIT_POINTER(tbl->buckets[n], last->next);
> 
> The above surprised me, but reading further, I see that you have a
> synchronized_rcu() in nft_hash_tbl_expand() between publishing the new
> hash table and doing the first round of unzip.
> 
> (And no, it should not have surprised me, given that this is exactly
> what the paper says to do, but hey!)
> 
> RCU_INIT_POINTER() is correct here because the data being linked is
> already exposed to readers.  Ditto for the other RCU_INIT_POINTER()
> instances in this patch.

Thanks! I've put the synchonrize_rcu() in the caller to make it more obvious
at which points it synchronizes.

> > +static int nft_hash_tbl_expand(const struct nft_set *set, struct nft_hash *priv)
> > +{
> > +	struct nft_hash_table *tbl = nft_dereference(priv->tbl), *ntbl;
> > +	struct nft_hash_elem *he;
> > +	unsigned int i, h;
> > +	bool complete;
> > +
> > +	ntbl = nft_hash_tbl_alloc(tbl->size * 2);
> > +	if (ntbl == NULL)
> > +		return -ENOMEM;
> > +
> > +	/* Link new table's buckets to first element in the old table
> > +	 * hashing to the new bucket.
> > +	 */
> > +	for (i = 0; i < ntbl->size; i++) {
> > +		h = i < tbl->size ? i : i - tbl->size;
> > +		nft_hash_for_each_entry(he, tbl->buckets[h]) {
> > +			if (nft_hash_data(&he->key, ntbl->size, set->klen) != i)
> > +				continue;
> > +			RCU_INIT_POINTER(ntbl->buckets[i], he);
> > +			break;
> > +		}
> > +	}
> > +	ntbl->elements = tbl->elements;
> > +
> > +	/* Publish new table */
> > +	rcu_assign_pointer(priv->tbl, ntbl);
> > +
> > +	/* Unzip interleaved hash chains */
> > +	do {
> > +		/* Wait for readers to use new table/unzipped chains */
> > +		synchronize_rcu();
> > +
> > +		complete = true;
> > +		for (i = 0; i < tbl->size; i++) {
> > +			nft_hash_chain_unzip(set, ntbl, tbl, i);
> > +			if (tbl->buckets[i] != NULL)
> > +				complete = false;
> 
> Probably not worth it, but you could track the first and last elements
> needing unzipping.

Do you mean for the table iteration? Yeah, good point, I didn't think of
that. Will try whether it can be done easily without affecting readability
too much.

> > @@ -129,12 +293,13 @@ static void nft_hash_walk(const struct nft_ctx *ctx, const struct nft_set *set,
> >  			  struct nft_set_iter *iter)
> >  {
> >  	const struct nft_hash *priv = nft_set_priv(set);
> > +	const struct nft_hash_table *tbl = nft_dereference(priv->tbl);
> >  	const struct nft_hash_elem *he;
> >  	struct nft_set_elem elem;
> >  	unsigned int i;
> > 
> > -	for (i = 0; i < priv->hsize; i++) {
> > -		hlist_for_each_entry(he, &priv->hash[i], hnode) {
> > +	for (i = 0; i < tbl->size; i++) {
> > +		nft_hash_for_each_entry(he, tbl->buckets[i]) {
> >  			if (iter->count < iter->skip)
> >  				goto cont;
> 
> I might be confused, but it looks like the "iter->count++" in the code
> below this (not in this patch) could be added to the for() statement,
> the "goto cont" be made into "continue", and the "cont" label eliminated.

Not entirely. ->walk() is used for netlink dumps and loop checks. In case
of netlink dumps, it can be interrupted if the dump skb is full. In that
case we need to skip the amount of elements we've already dumped. Since
we don't know the amounts of elements in each chain, we really need to
iterate over all of them and count them.

What would be possible is to store two values, the hash bucket number and
the amounts of elements to skip within that bucket. I'm considering this
for other reasons as well, but it will need an API change, so if I change
it I will do it at a later point.

Thanks for your review!
