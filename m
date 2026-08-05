Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666DF36195A;
	Wed,  5 Aug 2026 07:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785915208; cv=none; b=hkEl++ZKBaXcw1AxwcEG+ydFIhj/T5NEWIRrXMSHbxzFJp/9hMlRw096ymAThX/WrmBgKzHRF+iYQBQCrzXU6tkhdCUCKTJJyFVzyuidVYBhlTrBgYGb/Wmk3gzm1sTCCd5ghmcTv0eu1y3vEnfskrh6ZItVA5f0Ze+zLK5WFH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785915208; c=relaxed/simple;
	bh=M8YrUsjeBHss+QC0jNU4fE/I1ztrK6EIaxiEmSJIbQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vh+0ExKnwyBZz7H/KaGsyBuAyItQDDDhGWYBpNrWDU7eZukjvsVSAbotqRSuAd9BYVWZF/nxJkwOQn7ijUgZPq8FAS1ZC62GloRD95XLn+fxJeiDi1EI/GMSaV+ZOQXtUw8qPY9GBF6Hb/vLO/xUpkM50NXy27UdfzH0zH7hE24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AA129602B9; Wed, 05 Aug 2026 09:33:23 +0200 (CEST)
Date: Wed, 5 Aug 2026 09:33:23 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org
Subject: Re: [PATCH net 03/10] netfilter: ipset: rework cidr bookkeeping
Message-ID: <anLnQ5yVe1hE3VvM@strlen.de>
References: <20260731151806.849724-4-pablo@netfilter.org>
 <20260805001531.3978750-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805001531.3978750-1-kuba@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: ipset: rework cidr bookkeeping
> 
> The prefix bookkeeping of the hash:net* set types is moved out of struct
> htype into separately allocated, RCU published struct net_prefixes arrays.
> The in-place shifting of the cidr array is replaced by allocate-copy-publish,
> with a documented fallback to leaving holes when the allocation fails.
> 
> A few questions about the new bookkeeping below.

Sigh.  I knew this would happen, but what am I supposed to do now?

I explicitly noted that this isn't perfect and that I'm doing a
large series to convert ip_set_hash_gen.h over to rhashtable.

This series ATM has 19 patches.

What is your advice?  Should i squashmerge unrelated patches into one
thing?  Send the entire thing directly to net?  Make a PR just with that
entire thing?

I have no idea how to make progress here.

> > -/* cidr + 1 is stored in net_prefixes to support /0 */
> > -#define NCIDR_PUT(cidr)		((cidr) + 1)
> > -#define NCIDR_GET(cidr)		((cidr) - 1)
> > -
> >  #ifdef IP_SET_HASH_WITH_NETS_PACKED
> >  /* When cidr is packed with nomatch, cidr - 1 is stored in the data entry */
> >  #define DCIDR_PUT(cidr)		((cidr) - 1)
> > @@ -141,21 +142,11 @@ htable_size(u8 hbits)
> >  #define DCIDR_GET(cidr, i)	__CIDR(cidr, i)
> >  #endif
> >  
> > -#define INIT_CIDR(cidr, host_mask)	\
> > -	DCIDR_PUT(((cidr) ? NCIDR_GET(cidr) : host_mask))
> > -
> > -#ifdef IP_SET_HASH_WITH_NET0
> > -/* cidr from 0 to HOST_MASK value and c = cidr + 1 */
> > -#define NLEN			(HOST_MASK + 1)
> > -#define CIDR_POS(c)		((c) - 1)
> > -#else
> > -/* cidr from 1 to HOST_MASK value and c = cidr + 1 */
> > -#define NLEN			HOST_MASK
> > -#define CIDR_POS(c)		((c) - 2)
> > -#endif
> 
> [Severity: Low]
> This isn't a bug, but these were the only readers of
> IP_SET_HASH_WITH_NET0, and the flag is still defined by
> ip_set_hash_netiface.c and ip_set_hash_netportnet.c:

This sucks.  What am I supposed to do with this?

Do you want me to munge this patch to also zap this in the same commit?

> [Severity: Medium]
> Should INIT_CIDR() also look at nets[0].count?

Yes, but its not *that* simple.  Let alone better for
readability to change this here as well.

tentative direction to address this is:
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260804170214.27237-1-fw@strlen.de/

I think I can squashmerge this one but it will be more difficult
to explain all that is going on at the same time.

> Two states created by this patch leave len non-zero with count == 0 at
> index 0:
> 
>   - mtype_del_cidr() on allocation failure:
> 
> 	tmp = kzalloc_flex(*tmp, nets, len, GFP_ATOMIC);
> 	if (!tmp)
> 		/* Leave a hole */
> 		goto unlock;

This is remove in the patch linked above.

>   - mtype_flush() on allocation failure, which zeroes the counts but keeps
>     len and the stored cidr values.

Won't do this after rhashtable conversion.

> The commit message says the hole possibility "is taken into account at
> evaluation time" - that holds for mtype_test_cidrs(), but does it hold for
> INIT_CIDR()?  This is unchanged at the end of the series (3a0d9fd64b67).

The series is partial.  The ipset -> rhashtable conversion patch set is large:
20 files changed, 931 insertions(+), 1271 deletions(-)

> [Severity: Low]
> Does the memsize reported to userspace need updating too?  The bookkeeping
> is no longer part of struct htype, but mtype_ahash_memsize() still only
> accounts for sizeof(*h):
> 
> 	return sizeof(*h) + sizeof(*t) + ahash_sizeof_regions(t->htable_bits);

I can munge this, sure.

> [Severity: Low]
> This isn't a bug, but the comment still describes the encoding this patch
> removes.  NCIDR_PUT()/NCIDR_GET() are gone and all call sites now pass the
> raw value, for example:
> 
> 	mtype_add_cidr(set, h, DCIDR_GET(d->cidr, i), i);
> 
> Could the comment be updated to describe the new invariants instead
> (descending cidr order, count == 0 marks a hole, len is the number of
> allocated slots, /0 distinguished by count)?  The stale text is still
> present at the end of the series (3a0d9fd64b67).

I can munge this.

> [Severity: Low]
> This isn't a bug on any supported architecture, but this increment (and
> the matching decrement in mtype_del_cidr(), plus the bulk zeroing in the
> mtype_flush() fallback) still mutates the already published object in
> place, with plain stores and no WRITE_ONCE().

Sigh.  Will inflate diff size even more.

> Since count now decides whether an entry is a live prefix or a hole, is it
> worth annotating these accesses?

Well, is it?

> One way to reach the decrement of a zero count: mtype_flush() clears the
> buckets first, a concurrent SET target add registers a cidr and inserts an
> element, the flush fallback afterwards zeroes that count, and the later
> delete of the still present element decrements zero.  The skew caused by the
> ignored -ENOMEM of mtype_add_cidr() (see below) gets there as well.

All of this is rewritten with the rhashtable conversion.

After conversion, mtype_flush no longer performs point-blank-clobbering,
and only entries that are successfuly detached from the rhashtable have
their cidr count changed under lock.

> > @@ -402,6 +433,9 @@ static void
> >  mtype_flush(struct ip_set *set)
> >  {
> >  	struct htype *h = set->data;
> > +#ifdef IP_SET_HASH_WITH_NETS
> > +	struct net_prefixes *nets, *tmp;
> > +#endif
> >  	struct htable *t;
> >  	struct hbucket *n;
> >  	u32 r, i;
> > @@ -425,7 +459,19 @@ mtype_flush(struct ip_set *set)
> >  		spin_unlock_bh(&t->hregion[r].lock);
> >  	}
> >  #ifdef IP_SET_HASH_WITH_NETS
> > -	memset(h->nets, 0, sizeof(h->nets));
> > +	for (i = 0; i < IPSET_NET_COUNT; i++) {
> > +		nets = ipset_dereference_nfnl(h->rnets[i]);
> > +		tmp = kzalloc_obj(*tmp, GFP_ATOMIC);
> > +		if (!tmp) {
> > +			u8 j;
> > +
> > +			for (j = 0; j < nets->len; j++)
> > +				nets->nets[j].count = 0;
> > +		} else {
> > +			rcu_assign_pointer(h->rnets[i], tmp);
> > +			kfree_rcu(nets, rcu);
> > +		}
> > +	}
> >  #endif
> >  }
> 
> [Severity: Critical]
> Does this replacement need set->lock?
> 
> mtype_add_cidr() and mtype_del_cidr() do the same read, publish and free
> sequence under spin_lock_bh(&set->lock), but here only the nfnetlink mutex
> is held.  For the hash types set->variant->region_lock is true, and
> ip_set_lock() is then a no-op:

Yes and no.  After rhashtable conversion, this mtype_flush replacement
is gone and so are region locks.

I can munge this but I considered a waste of time.

> net/netfilter/ipset/ip_set_core.c:
> static inline void
> ip_set_lock(struct ip_set *set)
> {
> 	if (!set->variant->region_lock)
> 		spin_lock_bh(&set->lock);
> }
> 
> so ip_set_flush_set() -> mtype_flush() gets no serialization against the
> cidr writers.  Those writers do not take the nfnl mutex either:

Yes, thats why all of this is on the chopping block...

> CPU0 (ipset flush)                  CPU1 (SET target, softirq)
> nets = ipset_dereference_nfnl(...)
>                                     spin_lock_bh(&set->lock);
>                                     nets = __ipset_dereference(h->rnets[n]);
> rcu_assign_pointer(h->rnets[i], tmp)
> kfree_rcu(nets, rcu);
>                                     rcu_assign_pointer(h->rnets[n], tmp);
>                                     kfree_rcu(nets, rcu);   /* same object */
> 
> That queues the same rcu_head twice, and the concurrent update is lost as
> well.  The !tmp fallback above also writes nets->nets[j].count = 0 into an
> object the other side may already have unpublished and passed to
> kfree_rcu().

I don't see how this is possible AFTER rhashtable conversion.

> [Severity: High]
> mtype_add_cidr() changed from void to int and can now fail:
> 
> 	tmp = kzalloc_flex(*tmp, nets, len, GFP_ATOMIC);
> 	if (!tmp) {
> 		ret = -ENOMEM;
> 		goto unlock;
> 	}
> 
> Should this caller check the return value?  The memcpy() commits the
> element unconditionally, so on allocation failure the element sits in the
> bucket with no prefix registered in h->rnets[].

Yes, I added this later in the series.  I can munge this here but it
again delays progress.  I had hoped to get this in but it increasingly
looks like this will have to be delayed to nf-next/net-next or even
further.  I hate this, as good as AI reviews are for finding issues they
also start to effectively prevent bug fixes from making the tree because
they are not meeting AI perfectness standards, whatever that means.

> mtype_test_cidrs() only probes cidrs that are present with count != 0:
> 
> 	for (j = 0; j < nets0->len && !multi; j++) {
> 		if (!nets0->nets[j].count)
> 			continue;
> 
> so does such an element become permanently unmatchable, while still being
> listable and deletable?

No idea.  I tire of reading AI mumbo jumbo.
