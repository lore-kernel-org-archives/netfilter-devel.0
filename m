Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422CA266EFC
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 11:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754566196; cv=none; b=b2qVfZiFedAWvxqPH1sY8DKw2siT7GaD3KwZY3XR4574B23zNcD5GQDZFTOs31vfMlIIyH6UgiqKuorG1vPZhJemYHbKYHS1t9ZsH5FBGNoEtNDnhfN6ZjeWi2pKglNk+Dz+HAt7k3elBDf45IvvX4D5CncG/nnqVJNbhpgpxGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754566196; c=relaxed/simple;
	bh=ZMWBe7ewN1kggr+FKq2gDPa1aAUts3ZlEjYkekHSgfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=siZsMLX9fzsgxoDEToW83byhVp6HQ8eM1w59Y6p8hxddWRkc6OV9LYWE03++IEYogJwe7YnMqiBa9hAOa5dsjYnhmLVKARI2ZDU9ryNTQu6+hppoNg1moge8hYojLzRw4x9DAeOxSpvCKVOQn5m2AA+vSdHOld0QRqxOTQlDzL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6EC4060532; Thu,  7 Aug 2025 13:29:51 +0200 (CEST)
Date: Thu, 7 Aug 2025 13:29:51 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/2] netfilter: ctnetlink: fix refcount leak on table
 dump
Message-ID: <aJSOLzS5WJU1U8ys@strlen.de>
References: <20250801152515.20172-1-fw@strlen.de>
 <20250801152515.20172-2-fw@strlen.de>
 <aJSGlBD36tgRNWpT@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJSGlBD36tgRNWpT@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Aug 01, 2025 at 05:25:08PM +0200, Florian Westphal wrote:
> > There is a reference count leak in ctnetlink_dump_table():
> >       if (res < 0) {
> >                 nf_conntrack_get(&ct->ct_general); // HERE
> >                 cb->args[1] = (unsigned long)ct;
> >                 ...
>                   goto out;
> 
> >
> > While its very unlikely, its possible that ct == last.
> 
> out:
>         ...
>         if (last) {
>                 /* nf ct hash resize happened, now clear the leftover. */
>                 if ((struct nf_conn *)cb->args[1] == last) {
>                         cb->args[1] = 0;
>                 }
> 
>                 nf_ct_put(last);
>         }
> 
> I think problem was introduced here:
> 
>   fefa92679dbe ("netfilter: ctnetlink: fix incorrect nf_ct_put during hash resize")

I think you'r right, the 'clear the leftover' is only correct if
we hit cb->args[0] >= htable_size condition.
OTOH reverting it gives the problem that commit fixed.

So I think that this code is just way too complicated,
i have no idea why this ever used reference counts, they do not buy
anything but headaches.

> cookie is indeed safer approach.
> 
> IIRC, the concern is that cookie could result in providing a bogus
> conntrack listing due to object recycling, which is more likely to
> happen with SLAB_TYPESAFE_BY_RCU.

Maybe, but even if this code would just store the address, the probability
of a recycle happening in such a way that a conntrack oject happens to be
stored, and then on next dump got re-added at exactly this slot is
almost 0.

And even if it would have been, the worst that can happen is that we
dump another entry a second time.  /proc code uses to walk the entire
table from start, counting dumped-entries and I'm not aware of 'dup'
complaints.

> Then, it should be very unlikely that such recycling that leads to
> picking up from the wrong conntrack object because two conntrack
> objects in the same memory spot will have different id.

Yes, it considers the tuples for the hash too, so its exteremly
unlikely for a recycle to result in same u32 hash value.
