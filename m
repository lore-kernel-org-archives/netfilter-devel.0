Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352122DC762
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Sep 2025 20:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757794664; cv=none; b=rvwhIuaUCUvkouwqfCtO291phVr7PZPYupk5UhL+CA4MLceXceGi3VRKZj7ikPGEiJqAUjqZCOrov730+MrkMKL87OBzvwvpJ/iwqffmi24tTfMmhLjQwn2G2UYWIeQq4zA+vJz4MAqSbaebo8zL+6XnD6pXnYvTDkxzgAeunKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757794664; c=relaxed/simple;
	bh=gqkRns6ff8E6ijVFY41VtNJjZ2JuUDE3GSU3CMPYYBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TXC0uoc01yvaPmtTg9U3J66A+sFolYibv1fRyvXhhPm/9OI4WW4f6yZdmVQieuIWFpboggSJwKkBcluTfVcHa6ND3yhIxQJrm0BBAQxxfr68Xy+MWX6d64u8w0zboN2o4ghgJ/hX2Z9D6dvBkjT4S3XWJpsQMCZrc4TaoQbS5Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 35E5760309; Sat, 13 Sep 2025 22:17:32 +0200 (CEST)
Date: Sat, 13 Sep 2025 22:17:31 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC nf-next 1/2] netfilter: nft_set_pipapo_avx2: fix skip
 of expired entries
Message-ID: <aMXRW5N6eyQLzmjs@strlen.de>
References: <20250912132004.7925-1-fw@strlen.de>
 <20250913021326.52fc3ca6@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250913021326.52fc3ca6@elisabeth>

Stefano Brivio <sbrivio@redhat.com> wrote:
> On Fri, 12 Sep 2025 15:19:59 +0200
> Florian Westphal <fw@strlen.de> wrote:
> By the way, you're referring to 'rp' here, and nothing else, right?

Yes, sorry.

> Could you mention that explicitly if that's the case? I have to say
> that "data (...) has already been incremented" took me a while to
> understand.

Apologies, I will rephrase it.

> > The restart logic in AVX2 is different compared to the plain C
> > implementation, but both should follow the same logic.
> 
> That's because I wanted to avoid calling pipapo_refill() from the AVX2
> lookup path, as it was significantly slower than re-doing the full
> lookup, at least for "net, port" sets which I assumed would be the most
> common.
> 
> On the other hand, it should always be a corner case (right?), so I
> guess simplicity / consistency should prevail.

Yes, I don't think we ever have a duplicate to begin with, insert path
returns -EEXIST or ignores the insertion request.

They exist in the clone/copy for the case when one transaction asked for
remoal of "e" (and marks it as invalid in new generation) followed by
a re-insert of "e".

In that case, The "e" re-insert should find and skip the old result
and continue to search for a matching result.

Thats also what the test case does:
insert e
<end of transaction>
flush set x <mark e invalid>
insert e    <find e-old, continue search, find no result>, insert ok
insert e    <find e-old, continue search, find e-new, fail transaction

I think I'll extend the test case to also check that "flush set x;
insert e" works on a set that already contained e before.

> > The C implementation just calls pipapo_refill() again to check the next
> > entry.  Do the same in the AVX2 implementation.
> 
> An alternative would be to reset rp = key, but maybe what you're doing
> is actually saner, see above.

Nope, that doesn't work.  If you reset rp = key, it fixes the splat
but results in infinite loop.

> > Note that with this change, due to implementation differences of
> > pipapo_refill vs. nft_pipapo_avx2_refill, the refill call will return
> > the same element again,
> > then, on the next call it will move to the next
> > entry as expected.  This is because avx2_refill doesn't clear the bitmap
> > in the 'last' conditional.

Note last sentence, its important the bitmap is toggled to off in the
"last" case so the next attempt won't result in rediscovery of that
element.

After this patch, the sequence is: (in case you have key matching both e1
and e2):

	1. find e1, test, expired -> call pipapo_refill
       	2. find e1 again, expired -> call pipapo_refill
        3. find e2, test, valid -> return e2 as matching entry

without this patch, its:
	find e1, test, expired -> goto next (restart loop)
	find no matching entry (rp not reset so its searching for
	something else)
	-> duplicate insertion passes as e2 not be found

with full restart but fixed rp assignment:
	1) find e1, test, expired -> reset key
        2) goto 1

... so i opted for the first solution.
For the packet path, the "pipapo_refill" call will happen when
the element is expired (timed out).
I don't see many users mixing pipapo entries with timeouts.

> > -				     !nft_set_elem_active(&e->ext, genmask)))
> > -				goto next_match;
> > +				     !nft_set_elem_active(&e->ext, genmask))) {
> > +				ret = pipapo_refill(res, f->bsize, f->rules, fill, f->mt, last);
> 
> It could be wrapped like this:
> 
> 				ret = pipapo_refill(res, f->bsize, f->rules,
> 						    fill, f->mt, last);

I have to resend anyway so I will fix this up, thanks.

> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

Thanks for reviewing!
