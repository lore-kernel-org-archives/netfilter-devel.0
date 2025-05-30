Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F5D1EC01B
	for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2025 06:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748585728; cv=none; b=MJLugQfbnJeazKlINNd6VX/bDePA0/KQ6+jfbATiz2w9Egqf0K+l9rGVErsRdaydeV+BlbIQ82K3bjr6mrkcVVHju4riwfKXa0ZSYg0okvuqBA/QzuDDeILr6P3XdbB/IPLYq/LNvCYwROTNEXwoJGIL3dDcJQo0MD6wQIWvrLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748585728; c=relaxed/simple;
	bh=EHbIMQJTfFTNt2KX+wbKVzvNC5QzD+jA67pZAH7qupU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGAlHml7rzHwamvH5JEFt+yg9B+mzhs5AOtk7QlbRiLgnt+YxmQZfUCupiR+o9xpltc+yH6h9RMbh47+0ThU3mo6Z+Cay46vLZsg8KtP5CxQ1TyxCsNi0RI4SC5ASJOmRiEK3yAxNaqPWeMRJ8pKwsw/q5P14t2zCDOpjybU+aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ghie1ylU; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BV7pJFRl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ghie1ylU";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BV7pJFRl"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 96AC360812; Fri, 30 May 2025 08:15:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748585721;
	bh=Uyf0tvRQ2PlXfb6MyZZvKnWMnF83gB5osIy/HPNPSO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ghie1ylUsrgoka4NxyTXmJkb+BVcFUCiG5N7iZAgjxpa4zJyNPFwIS4D30fboX851
	 rpnLpS5834G4VqyqGN+eFSY7pozHkqERqmt4gl1RQuQf4meqtn/tuSik9ba0NuBq9Z
	 Tz+qgP5OvowfCnG+VJUlW7L8LCdTgf/QkxOZcc7yXH769jqQfS0qQM3qXh4Pum+IxT
	 kITgcgzxqRWQeeU2qXYoOxfErje7twAsDul/vT0ZS7gMzVohMk/xc2KsDxA9kiZCQ3
	 fwX62iQtZ7c6REtTD5lyJZJ/xW+6fifnJeR6jtE8/Hij+S36QklEanD9m+5hDg3BkC
	 CAuufeIQRpHIQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B3C3F6080F;
	Fri, 30 May 2025 08:15:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748585720;
	bh=Uyf0tvRQ2PlXfb6MyZZvKnWMnF83gB5osIy/HPNPSO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BV7pJFRll5A3/h86cAH0eFeYyoWdkH2s0LPJzQ8tK1408XlHRiNWIt4AImX4auIkn
	 KwMoxQVSJF+ruH2hy3D9ZRdZgOuviFE/952jUVMmmX9WKaPxpSFlFRoEfmP1uOsqp+
	 XamnSUTxoUHx5izjpdSjuy70gMaDrvaGRTwkphcRdpGJlPsXpZZSOH/a250q3khIoz
	 z/l2nXGPalN60jB4CziHuYJwpkQJ07sKeKMwgbAzASYoVOvJuD25X5miEvKQEEFVzD
	 uF+5jOIFEmsTsuP6IYyu0msEa5+pp1muM/Dqo8RQmEeS4UC1MivBXzE3n2ryNbjFXx
	 xpta1PWgzqr7w==
Date: Fri, 30 May 2025 08:15:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, sbrivio@redhat.com
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_set_pipapo_avx2: fix initial
 map fill
Message-ID: <aDlM5DVjAc02aIwd@calendula>
References: <20250523122051.20315-1-fw@strlen.de>
 <20250523122051.20315-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250523122051.20315-2-fw@strlen.de>

Hi Florian, Stefano,

On Fri, May 23, 2025 at 02:20:44PM +0200, Florian Westphal wrote:
> If the first field doesn't cover the entire start map, then we must zero
> out the remainder, else we leak those bits into the next match round map.
> 
> The earlie fix was incomplete and did only fix up the generic C
> implementation.
> 
> A followup patch adds a test case to nft_concat_range.sh.
> 
> Fixes: 791a615b7ad2 ("netfilter: nf_set_pipapo: fix initial map fill")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo_avx2.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> index c15db28c5ebc..be7c16c79f71 100644
> --- a/net/netfilter/nft_set_pipapo_avx2.c
> +++ b/net/netfilter/nft_set_pipapo_avx2.c
> @@ -1113,6 +1113,25 @@ bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
>  	return true;
>  }
>  
> +/**
> + * pipapo_resmap_init_avx2() - Initialise result map before first use
> + * @m:		Matching data, including mapping table
> + * @res_map:	Result map
> + *
> + * Like pipapo_resmap_init() but do not set start map bits covered by the first field.
> + */
> +static inline void pipapo_resmap_init_avx2(const struct nft_pipapo_match *m, unsigned long *res_map)
> +{
> +	const struct nft_pipapo_field *f = m->f;
> +	int i;
> +
> +	/* Starting map doesn't need to be set to all-ones for this implementation,
> +	 * but we do need to zero the remaining bits, if any.
> +	 */
> +	for (i = f->bsize; i < m->bsize_max; i++)
> +		res_map[i] = 0ul;
> +}
> +
>  /**
>   * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
>   * @net:	Network namespace
> @@ -1171,7 +1190,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
>  	res  = scratch->map + (map_index ? m->bsize_max : 0);
>  	fill = scratch->map + (map_index ? 0 : m->bsize_max);
>  
> -	/* Starting map doesn't need to be set for this implementation */
> +	pipapo_resmap_init_avx2(m, res);

nitpick:

nft_pipapo_avx2_lookup_slow() calls pipapo_resmap_init() for
non-optimized fields, eg. 8 bytes, which is unlikely to be seen.
IIUC this resets it again.

Maybe revisit this in nf-next? Would be worth to cover this avx2 path
with 8 bytes in tests?

Thanks.

>  
>  	nft_pipapo_avx2_prepare();
>  
> -- 
> 2.49.0
> 
> 
