Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDB27FBB5
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 15:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707319419; cv=none; b=bbCiH9C7YeACLBhZku1MzZPnKXVVHkO7hi8wdxtr+UfEN8gY5JtGK4BA+v+DQOf7GKpTWqpMdKXtNhJWjOHZUUfE3l1tfiOnTBUk251ke2Lg9Mp3tFbylyGEGRheeTI+7RzWhyN0DXkEoiMdGAvYUXhfSVde/u1QxsCg4JQ21E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707319419; c=relaxed/simple;
	bh=iiOl9zMDgDiJdrNO3eNEf+0Jzhx93WgXVf7IKYAtNHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jfi4471HS0+SX8v5LzJHy58f4/SctouV9pHvjcAu8TuSIuK8BADqtOk1c0sQhICc0FIYv4juiJTAfNfBTHdCoZ2UCsO3QGR3ZdQaBXDGCajXuY9ij/zecMQVxiKdVm2JEwxxIhMraYtyMWv4Y71NOIJ1MsmIciBwsUDKIUVC8h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rXjlo-0003WG-Jg; Wed, 07 Feb 2024 16:23:28 +0100
Date: Wed, 7 Feb 2024 16:23:28 +0100
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/3] netfilter: nft_set_pipapo: store index in scratch
 maps
Message-ID: <20240207152328.GA11077@breakpoint.cc>
References: <20240206122531.21972-1-fw@strlen.de>
 <20240206122531.21972-2-fw@strlen.de>
 <20240207151514.790c6cf3@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207151514.790c6cf3@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)

Stefano Brivio <sbrivio@redhat.com> wrote:
> > This isn't reliable.
> 
> Uh oh. In hindsight, this sounds so obvious now...

Thats a recurring theme with a lot of bugs.
So, no, it was not obvious.

> > There can be multiple sets and we can't be sure that the upper
> > and lower half of all set scratch map is always in sync (lookups
> > can be conditional), so one set might have swapped, but other might
> > not have been queried.
> > 
> > Thus we need to keep the index per-set-and-cpu, just like the
> > scratchpad.
> > 
> > Note that this bug fix is incomplete, there is a related issue.
> > 
> > avx2 and normal implementation might use slightly different areas of the
> > map array space due to the avx2 alignment requirements, so
> > m->scratch (generic/fallback implementation) and ->scratch_aligned
> > (avx) may partially overlap. scratch and scratch_aligned are not distinct
> > objects, the latter is just the aligned address of the former.
> > 
> > After this change, write to scratch_align->map_index may write to
> > scratch->map, so this issue becomes more prominent, we can set to 1
> > a bit in the supposedly-all-zero area of scratch->map[].
> > 
> > A followup patch will remove the scratch_aligned and makes generic and
> > avx code use the same (aligned) area.
> > 
> > Its done in a separate change to ease review.
> > 
> > Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Minus one nit (not worth respinning) and one half-doubt below,
> 
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
> 
> ...I'm still reviewing the rest.

Thanks for reviewing.

> >  #ifdef NFT_PIPAPO_ALIGN
> > -		scratch_aligned = NFT_PIPAPO_LT_ALIGN(scratch);
> > +		scratch_aligned = NFT_PIPAPO_LT_ALIGN(&scratch->map);
> > +		/* Need to align ->map start, not start of structure itself */
> > +		scratch_aligned -= offsetof(struct nft_pipapo_scratch, map);
> 
> This should be fine with the current version of
> NFT_PIPAPO_ALIGN_HEADROOM, but it took me quite some pondering, reasoning
> below if you feel like double checking.

Good point.

> Let's say ARCH_KMALLOC_MINALIGN is 4, NFT_PIPAPO_LT_ALIGN is 32, we
> need 100 bytes for the scratch map (existing implementation), and the
> address, x, we get from kzalloc_node() is k + 28, with k aligned to 32
> bytes.
> Then, we'll ask to allocate 32 - 4 = 28 extra bytes
> (NFT_PIPAPO_ALIGN_HEADROOM), that is, 128 bytes, and we'll start using
> the area at x + 4 (aligned to 32 bytes), with 124 bytes in front of us.
>
> With this change, and the current NFT_PIPAPO_ALIGN_HEADROOM, we'll
> allocate (usually) 4 bytes more, 132 bytes, and we'll start using the
> area at x + 4 anyway, with 128 bytes in front of us, and we could have
> asked to allocate less, which made me think for a moment that
> NFT_PIPAPO_ALIGN_HEADROOM needed to be adjusted too.

We'll allocate sizeof(long) more space (map_index), which is 4 bytes in
your example.

> However, 'scratch' at k + 28 is not the worst case: k + 32 is. At that
> point, we need anyway to ask for 28 extra bytes, because 'map_index'
> will force us to start from x + 32.

Wait.  k + 32 is really "k" for old code: slab gave us an aligned
address.

In new code, k+4 is the perfect "already-aligned" address where we would
'no-op' the address on a ARCH_KMALLOC_MINALIGN == 4 system.

Lets assume we get address k, and that address is the worst
possible aligned one (with minalign 4), so we align
(k + 4) (&scratch->map[0]), then subtract the index/struct head,
which means we store (align(k+4) - 4), which would be 28.

Worst case aligned value allocator can provide for new code
is k or k + 32 (make no difference):

Lets say address we got from allocator is 0x4:

NFT_PIPAPO_LT_ALIGN(&scratch->map); -> aligned to 32, we store 28
as start of struct, so ->map[0] is at address 32.

Lets say address we got from allocator is 0x20 (32):
NFT_PIPAPO_LT_ALIGN(&scratch->map); -> aligned to 64, we store 60
as start of struct, so ->map[0] at 64.

In both cases ALIGN() ate 28 bytes of the allocation, which we accounted
for as NFT_PIPAPO_ALIGN_HEADROOM.

Maybe thats what you were saying.  I could try to add/expand the
comments here for the alignment calculations.

> > -	res  = scratch + (map_index ? m->bsize_max : 0);
> > -	fill = scratch + (map_index ? 0 : m->bsize_max);
> > +	map_index = scratch->map_index;
> > +
> > +	res = scratch->map + (map_index ? m->bsize_max : 0);
> > +	fill = scratch->map + (map_index ? 0 : m->bsize_max);
> 
> Nit (if you respin for any reason): the existing version had one extra
> space to highlight the symmetry between 'res' and 'fill' in the right
> operand. You kept that in nft_pipapo_lookup(), but dropped it here.

Oh, indeed, i'll fix this up.
