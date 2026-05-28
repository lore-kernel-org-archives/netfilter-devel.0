Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140DF322B8F
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 10:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779962620; cv=none; b=U+YEw+RxKZ6F2PagWQx9vHdWEpiSe8eAq38ggABWwS/lG5BwzepHlryhIywLpzbs31SePmY+4UGua4XBfmADR97WFoY7FO01uQvzXK3/KbkiiODIPzTSvvCMhlf4ZTtoNHdYNTqnGr1awl0COzAOvc4Fln/Ee5XXZFfpj3hSbxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779962620; c=relaxed/simple;
	bh=E8R+Xe3AzrfqukaPHLL1e5r8ig6XP15qOi8LO4GeYn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XR8fhKm3W8VegpBrr8eCeJHjwA70ex1Pkmc4Qk1+OBw6c4JvT3qjffiLeee2zCYqE481quVGFYItSGXSRx92P0D2kDmN3Q2Jt+FGZm7A4tJQJaIzCx6Eb5PFfhi3SLossJ9ESMd6tfVx7yj05o9VO2KdNkLA+6+D6brQbRE87G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ifx5B/Md; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ifx5B/Md"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 165D16017D;
	Thu, 28 May 2026 12:03:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779962615;
	bh=tQv+2ic4s/qib0BlClRiTMAV0C275EaivTvQYoJM4rw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ifx5B/Md70I9if7vOMWUh+Yz/GOkUBh5kIIWZSROrCZKje1bZZNi/ghHaT72V4Xpm
	 0ZAteGDF9uMqXW23QWs54oLC04U6Nyg2OqPplhGu78ySVcOuvqfa1RNJhSI16XWSWI
	 9TqCmRTpAUGR2dCy4Q9yVA9Em/MnXJB+xYwUzEZR4tdoQh3752lGoMYHwxBgF9GEDl
	 VvoVCfz/TV7T4p6bdB3GMOupsLV0fq/vGDH2CsOmS8wPTnTA1e0Awwh03892lxgkeJ
	 grXpsoWrrp26HnxuA8qse0wvcPPVoB86Nn/GRY1HMo9nTK06bZ2+VpC0lIqid2Dg23
	 U+Q+JVkJZfFhQ==
Date: Thu, 28 May 2026 12:03:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_ct: fix OOB in NFT_CT_SRC/DST eval
Message-ID: <ahgS9K_8Q9AHhQ0K@chamomile>
References: <20260528042620.263828-1-jiayuan.chen@linux.dev>
 <ahfQGCNs8hl6FlHL@strlen.de>
 <ahfV6K6KrG0akLUZ@strlen.de>
 <88abc4d7-8316-4c9e-aca0-351fe0ecb2b0@linux.dev>
 <ahfqfM6xQKZr_xbA@strlen.de>
 <58fc5150-76e7-46e5-a72f-41133c408109@linux.dev>
 <ahf2XAmRnsjK0krp@strlen.de>
 <c1383a3a-6c76-411a-8ae3-1dfe90052fb7@linux.dev>
 <ahgLdDKloq01r7lK@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ahgLdDKloq01r7lK@strlen.de>

On Thu, May 28, 2026 at 11:31:32AM +0200, Florian Westphal wrote:
> Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> 
> [ CC Pablo ]
> 
> > > https://sashiko.dev/#/patchset/20260528042620.263828-1-jiayuan.chen%40linux.dev
> > > 
> > > "This is a pre-existing issue, but does copying only addr_len bytes when
> > > priv->len is larger leave the remainder of the register uninitialized?
> > > In nft_do_chain(), the register array is allocated on the kernel stack
> > > without zero-initialization. If priv->len is 16 and addr_len is 4, only
> > > the first 4 bytes are written."
> > 
> > I just spotted that too.  I think copying priv->len unconditionally
> > is enough -- tuple->{src,dst} is zeroed in nf_ct_get_tuple() before the
> > protocol pkt_to_tuple callback fills in only the relevant leading bytes,
> > so the trailing bytes of tuple->{src,dst}.u3.all are well-defined zeros
> > and no wrapper is needed.
> 
> Pablo, whats your take?
> 
> chain c {
>  type filter hook output priority -300; policy accept;
>  ct zone set 1
>  ct original saddr 0.0.0.0 counter accept
> }
> 
> Then: ping -c 1 127.0.0.1
> 
> should the rule match the template or not?

I don't think so, no matching on the template conntrack.

> If not, we need:
> 
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -78,7 +78,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
>  		break;
>  	}
>  
> -	if (ct == NULL)
> +	if (!ct || nf_ct_is_template(ct))
>  		goto err;
>  
>  	switch (priv->key) {
> diff --git a/net/netfilter/nft_ct_fast.c b/net/netfilter/nft_ct_fast.c
> index e684c8a91848..ecf7b3a404be 100644
> --- a/net/netfilter/nft_ct_fast.c
> +++ b/net/netfilter/nft_ct_fast.c
> @@ -30,7 +30,7 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
>  		break;
>  	}
>  
> -	if (!ct) {
> +	if (!ct || nf_ct_is_template(ct)) {
>  		regs->verdict.code = NFT_BREAK;
>  		return;
>  	}
> 

This patch LGTM.
