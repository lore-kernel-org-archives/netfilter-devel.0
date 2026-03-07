Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DB839C630
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Mar 2026 12:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772888402; cv=none; b=iKq+s95C75+QjCcJib82WEr2gFZbIN0QQfD6CuzxQh8zMAAEB9j8gL40Y83jaI7sNiT0S4NK3Ys9AXqpg2Sz0/YjHp62alDG9YR96m7ksUQcK4iNq72u3qabAcggKG9ZkmNjFHe2wlTPPgJNweH9XwCb8e5qvODpYlRM9YqS8Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772888402; c=relaxed/simple;
	bh=LIcc+7T5yPX57xKtBcyJTuRDnXDqX8zav/F+g5czW4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oles1hCiodpMb+1nummTgdssmAcEYJYk++Badwf6fdHNKh+udWYns0OqrRukK5M+HffcCXNDoBvjcvk/ws16Ak0o4F56GRKzFozbD+f4d811EZiDuPJ5Z91azj8d1b+uEZP3VkHEOe6ps6JzwiyIJvXEK1aroArzVEZnVz1w1Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RIiaMyft; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RIiaMyft"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C522360299;
	Sat,  7 Mar 2026 13:59:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772888390;
	bh=1gJOv9taWnSCrdTB2AKhR81bw6igiz2KIcuGpwh5iLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RIiaMyfts83/kvPACTX9f1JUC8j9+QhTDyWBxn6e7+1gUao4lkwrXWc+7XxJ4j6cB
	 I0GUwCoOBNXDwbAUjNzdva05hwYrDM742c8KSVtLumRmjAhGjSMEiUJg5EWTn4hjt1
	 PtASn/vA9gYTXJUmdp0F/JhQdRraIzxEy6pZRzT9mPxT4Fj04+LTI68u58ONpqmbmd
	 sKv2eoG/ZXH6H/Lk7Ix/R/9AD938RLnV1ALskA2PA0aMz9jQ02Vc+BgPGDzSrJYNpW
	 Hd86Sn55c9j09C0zocOO4N0e0wnYQ3U7xpnAymrJD98u1No0CxhcuUaZ16EgiyKlXi
	 2SQcQ/kLlzmFw==
Date: Sat, 7 Mar 2026 13:59:48 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, carges@cloudflare.com
Subject: Re: [PATCH nf,v2] netfilter: nft_set_rbtree: allocate same array
 size on updates
Message-ID: <aawhRH5SLVzNTots@chamomile>
References: <20260307001124.2897063-1-pablo@netfilter.org>
 <aavqwA_H032EaiRg@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aavqwA_H032EaiRg@strlen.de>

On Sat, Mar 07, 2026 at 10:07:12AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > v2: fix crash with new sets, reported by Florian.
> > 
> >  net/netfilter/nft_set_rbtree.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> > index 853ff30a208c..bdcea649467f 100644
> > --- a/net/netfilter/nft_set_rbtree.c
> > +++ b/net/netfilter/nft_set_rbtree.c
> > @@ -646,7 +646,12 @@ static int nft_array_may_resize(const struct nft_set *set)
> >  	struct nft_array *array;
> >  
> >  	if (!priv->array_next) {
> > -		array = nft_array_alloc(nelems + NFT_ARRAY_EXTRA_SIZE);
> > +		if (priv->array)
> > +			new_max_intervals = priv->array->max_intervals;
> > +		else
> > +			new_max_intervals = NFT_ARRAY_EXTRA_SIZE;
> > +
> > +		array = nft_array_alloc(new_max_intervals);
> >  		if (!array)
> >  			return -ENOMEM;
> >  
> 
> I wonder if rbtree code should try harder to compact memory.
> 
> We can't defer allocation to commit hook because commit hook can't fail.
> But its the only location where we know the exact memory size needed:
> 
> 1. To-be-removed elements have been unlinked from the tree
> 2. Expired elements have been unlinked too
> 
> So, after the tree walk, num_intervals is the actual needed count and
> no longer a worst-case estimate.
> 
> What if this would check num_intervals vs.
> priv->array_next->num_intervals, and, if the difference is say, more
> than 10% or more than 1 page of memory, try to allocate a better size?
> 
> If the allocation fails, too bad, use the existing one.
> If it works, copy the elements over, free the larger allocation and
> use the "better fit".
> 
> netlink has similar approach via netlink_trim() to avoid stuffing
> large allocations into socket queues.
> 
> An even better way would be to just kvrealloc() but in the vmalloc case
> this code path doesn't shrink the VM area in case new requested size
> is smaller than the existing one, so that would require work on mm side
> first.
> 
> One issue is that if you have a large rbtree, and the userspace pattern
> is:
> 
> "flush set t s; add element t s { $huge }" then rbtree will roughly have
> double the memory size that it would actually need: it will
> first allocate the existing element size, then continue to realloc to
> accomodate the new incoming elements, but, since the flush only takes
> effect post-commit, can't account for the reduced size post-commit.

There is also set->ndeact that provides a hint on deactivated
elements.

And NFT_ARRAY_EXTRA_SIZE and resize can be revisited to allocate
memory areas that fit into the corresponding kmalloc slab.

So yes, there are smarter things that can be done here, but as for
this patch, my initial approach in this fix series was intentionally
simple.

As for this patch, I am just targetting at fixing the current linear
growth in memory consumption of this array on each update.
