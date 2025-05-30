Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030C91DA5F
	for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2025 10:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748600768; cv=none; b=RwRnuj/djSOXiBiXE3DqKG8RoLDMcxR2VNqajqmPuo1ZINItzgM4lZ3m0Ndd3SXA6txJGpaSXL4mflzz/natUxSG7U6Iamzv9/legQQXzwnP6X/t0cgTOyEMrOAJXHHEX6HgbFXZ5bw0/MXzZ0UjgxGXd1qlhFWOedL1OWSUSI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748600768; c=relaxed/simple;
	bh=3bi5E1pceg8XoWY3HYDMb4xTrl/7o+/53F76Y5m8vgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EhoaLX0zyD9Ohkqlx25swsJfm670QwJ2KBI487RNIQXW6Od9JPkD7/ZZe2OTHZkNQ6vsUyCyMurG7pTw23RCw+QA1/RXgitiuIC3XoBoYuMe1lMqWxW0hPq54lT9DKkDbVf50ysVDc4IawqtnEDFP8MdzcTTk+uoF7VaYHFnRTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8C4A660489; Fri, 30 May 2025 12:26:02 +0200 (CEST)
Date: Fri, 30 May 2025 12:26:02 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, sbrivio@redhat.com
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_set_pipapo_avx2: fix initial
 map fill
Message-ID: <aDmHujriOCTXAVgb@strlen.de>
References: <20250523122051.20315-1-fw@strlen.de>
 <20250523122051.20315-2-fw@strlen.de>
 <aDlM5DVjAc02aIwd@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aDlM5DVjAc02aIwd@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +	/* Starting map doesn't need to be set to all-ones for this implementation,
> > +	 * but we do need to zero the remaining bits, if any.
> > +	 */
> > +	for (i = f->bsize; i < m->bsize_max; i++)
> > +		res_map[i] = 0ul;
> > +}
> > +
> >  /**
> >   * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
> >   * @net:	Network namespace
> > @@ -1171,7 +1190,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
> >  	res  = scratch->map + (map_index ? m->bsize_max : 0);
> >  	fill = scratch->map + (map_index ? 0 : m->bsize_max);
> >  
> > -	/* Starting map doesn't need to be set for this implementation */
> > +	pipapo_resmap_init_avx2(m, res);
> 
> nitpick:
> 
> nft_pipapo_avx2_lookup_slow() calls pipapo_resmap_init() for
> non-optimized fields, eg. 8 bytes, which is unlikely to be seen.
> IIUC this resets it again.

Yes.  We have no test case for this function.
Can you come up with an example that would exercise this function?
It would be good to cover it in selftests.

> Maybe revisit this in nf-next? Would be worth to cover this avx2 path
> with 8 bytes in tests?

Not sure its worth it.  pipapo_resmap_init_avx2(), in most cases, is
a no-op as usually m->bsize_max is the same as f->bsize.

But yes, we could add yet another version of pipapo_resmap_init()
that only has the one-fill part.
