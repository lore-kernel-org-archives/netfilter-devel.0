Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4E755C15
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 13:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707830945; cv=none; b=k10A4X7EBqfOLsq01cQSBqSDAlG1yU8EXE5K8O6GZsaKNSEcJrc0rWP/uzxgCkI0XtbddUF5Uh88C78MfNn41z22l7sPprRwyc2zD8S5Z5WyGT/DAHxnwU1LeoAETkKjTrKLwbwZSmiJXHjE4soz843Op8ghg2//MmjLpm7/RX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707830945; c=relaxed/simple;
	bh=phYMMYjPHNbNU5D8ch2HKq5W/1qX77igobXLuWdipdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eomiv8tIVhEdGlwBBhmoT7dgrET8zfxPNM6duvAegZM9BG5jl3AMUQQ/+VVMUq3S4WZqONBPgyqbPQRZOy0otCZlLB6Zq36uBJk8sCG8q3XItW6lMqEzB0cVJYaNZKjcObFgP/fQsENKQq0O4UZmGeGuIJvfbeyL9ayRrur2TxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rZsqK-0008IB-Gq; Tue, 13 Feb 2024 14:29:00 +0100
Date: Tue, 13 Feb 2024 14:29:00 +0100
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 4/4] netfilter: nft_set_pipapo: speed up bulk
 element insertions
Message-ID: <20240213132900.GE5775@breakpoint.cc>
References: <20240212100202.10116-1-fw@strlen.de>
 <20240212100202.10116-5-fw@strlen.de>
 <20240213141753.17ef27a6@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213141753.17ef27a6@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)

Stefano Brivio <sbrivio@redhat.com> wrote:
> /* pipapo_realloc_mt() - Reallocate mapping table if needed upon resize
>  * @f:		Field containing mapping table
>  * @old_rules:	Amount of existing mapped rules
>  * @rules:	Amount of new rules to map
>  *
>  * Return: 0 on success, negative error code on failure.
>  */

Thanks, I'll steal this for v2.

> static int pipapo_realloc_mt(struct nft_pipapo_field *f,
> 			     unsigned int old_rules, unsigned int rules)
> 
> > +{
> > +	union nft_pipapo_map_bucket *new_mt = NULL, *old_mt = f->mt;
> > +	unsigned int extra = 4096 / sizeof(*new_mt);
> 
> Shouldn't we actually use PAGE_SIZE? I think the one-page limit is
> somewhat arbitrary but makes sense, so it should be 64k on e.g.
> CONFIG_PPC_64K_PAGES=y.

I wasn't sure if it would make sense to to use 64k for this batching,
I guess kvmalloc will use vmalloc anyway for such huge sets so I'll
change it back to PAGE_SIZE.

> > +	BUILD_BUG_ON(extra < 32);
> 
> I'm not entirely sure why this would be a problem. I mean, 'extra' at
> this point is the number of extra rules, not the amount of extra
> bytes, right?

Its a leftover from a version where this was bytes. I'll remove it.

> > +	/* small sets get precise count, else add extra slack
> > +	 * to avoid frequent reallocations.  Extra slack is
> > +	 * currently one 4k page worth of rules.
> > +	 *
> > +	 * Use no slack if the set only has a small number
> > +	 * of rules.
> 
> This isn't always true: if we slightly decrease the size of a small
> mapping table, we might leave some slack, because we might hit the
> (remove < (2u * extra)) condition above. Is that intended? It doesn't
> look problematic to me, by the way.

Ok. I'll ammend the comment then.

> > +	if (old_mt)
> > +		memcpy(new_mt, old_mt, min(old_rules, rules) * sizeof(*new_mt));
> > +
> > +	if (rules > old_rules)
> 
> Nit: curly braces around multi-line block (for consistency).

Oh?  Guess I'll see if checkpatch complains...

> >  		if (src->rules > 0) {
> > -			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt), GFP_KERNEL);
> > +			dst->mt = kvmalloc_array(src->rules_alloc, sizeof(*src->mt), GFP_KERNEL);
> >  			if (!dst->mt)
> >  				goto out_mt;
> >  
> >  			memcpy(dst->mt, src->mt, src->rules * sizeof(*src->mt));
> > +			dst->rules_alloc = src->rules_alloc;
> > +			dst->rules = src->rules;
> 
> These two, and setting rules_alloc below, shouldn't be needed, because we
> already copy everything in the source field before the lookup table, above.

Ah you mean:
    memcpy(dst, src, offsetof(struct nft_pipapo_field, lt));

.. above.  Ok, I'll remove those lines then.

Thanks for reviewing!
