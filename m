Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D04D27E
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Apr 2025 14:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743775368; cv=none; b=Cx2f3H6TwRf6T2qzzmMkghs0MYmMmXuT+T94B7YaKUn+nwBunkJdnw1vFGVKCNHEZh5NSymMrCrQn8qDsO1AvM9Qc4OBDt15a+EwNn7qEXPVlWmPtACS16Mq0R+kpD9YhG2v/fKI+6cdJIeyneNDEJrBbB4y8EIAfbYJRo/Zgk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743775368; c=relaxed/simple;
	bh=ffnPGdfpuYvGIM0d+Q458hcZZyMCpTyJGDVeRIvcxHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ldCHSkH9+3MlK4IWlRJpCEVo7twCqPjSFNSBROS6N8p1F5atHTl0V6IQaLmLXf8XnulVkyPxotqP3nwPSxum+FBg1I+sK1fXl2WV3JhgIreRU40mveKU9tuqiPAKOdC5ijsBEXiYT1WzFOG4dizlJc6bx4+5LRXKqkiwENIfHFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u0hd6-0001Jh-8O; Fri, 04 Apr 2025 16:02:44 +0200
Date: Fri, 4 Apr 2025 16:02:44 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf 1/3] nft_set_pipapo: add avx register usage
 tracking for NET_DEBUG builds
Message-ID: <20250404140244.GA4931@breakpoint.cc>
References: <20250404133229.12395-1-fw@strlen.de>
 <20250404133229.12395-2-fw@strlen.de>
 <20250404155437.58ff9b26@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250404155437.58ff9b26@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)

Stefano Brivio <sbrivio@redhat.com> wrote:
> > +#ifdef CONFIG_DEBUG_NET
> > +/* YYM15 is used as an always-0-register, see nft_pipapo_avx2_prepare */
> 
> It's really YMM (or ymm), with two m's and one y. :) That's what I was
> referring to in my previous comment.

Grr, my brain autocorrects this for some reason :-/

I'll fix it in v3 on Monday.

> > +#define NFT_PIPAPO_AVX2_DEBUG_MAP                                       \
> > +	struct nft_pipapo_debug_regmap __pipapo_debug_regmap = {        \
> > +		.tmp = BIT(15),                                         \
> > +	}
> 
> This mixes spaces and tabs (I guess from copy and paste).

Thanks, will fix it too.

> > +#ifdef CONFIG_DEBUG_NET
> > +	bool holds_and_result = BIT(reg) & r->tmp;
> > +
> > +        NFT_PIPAPO_WARN(!holds_and_result, reg, r, line, "unused");
> 
> This is indented with spaces.

Indeed, will fix.

> > @@ -687,6 +871,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
> >  
> >  		if (first) {
> >  			NFT_PIPAPO_AVX2_BUCKET_LOAD8(2, lt, 0, pkt[0], bsize);
> > +			nft_pipapo_avx2_force_tmp(2, &__pipapo_debug_regmap);
> 
> Right, that's because we have an 8-bit bucket and we're comparing 8
> bits, so in this case we don't need to AND any value in the first
> iteration.

Thanks for confirming.
