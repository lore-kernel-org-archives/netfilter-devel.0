Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5822D0600
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769703864; cv=none; b=mI1JkD4U0S/jpOO1tlQmGLaBR07GChtKv2mfeWzbIh8qRL+VO2Q6OqBtXWe6V3fSntrDzHz6Io3ihD2i+ajGp1GTClaxcWWc/pHSBT1wn10QZS5NHFt1GBxpbNdWH9o+Crbt88c6nAYvwZMMp6PCfXJOpeGYX3J4ih8rumeaem4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769703864; c=relaxed/simple;
	bh=jdLSp/JoUkRrA1hwVnVtxwTBZId3MikSmnzeAYFMOoA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AGIeSxD2eMcJ376gsLVsuDagvsDceWKUVBiN/MqQc9oqYHY3Vf27SyEjewOUqFhwqj9GYF3otzoe4dK0Wpfuxfo7Lx4Ww6mRr9g6QwP5dfIsgzzmVdVH/6G4MKONHYQ5hXplb03H+Opnv3BIJhPTfcl0wUpzC6RNWAgoe+22gBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C90C960516; Thu, 29 Jan 2026 17:24:19 +0100 (CET)
Date: Thu, 29 Jan 2026 17:24:14 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] ruleparse: arp: Fix for all-zero mask on Big
 Endian
Message-ID: <aXuJrrv26473uyeM@strlen.de>
References: <20260128214443.27971-1-phil@nwl.cc>
 <aXt1mToz6_7g9P88@strlen.de>
 <aXt7mLPPbsRN_H8R@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXt7mLPPbsRN_H8R@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> On Thu, Jan 29, 2026 at 03:58:33PM +0100, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > With 16bit mask values, the first two bytes of bitwise.mask in struct
> > > nft_xt_ctx_reg are significant. Reading the first 32bit-sized field
> > > works only on Little Endian, on Big Endian the mask appears in the upper
> > > two bytes which are discarded when assigning to a 16bit variable.
> > 
> > nft-ruleparse-arp.c: In function 'nft_arp_parse_payload':
> > nft-ruleparse-arp.c:93:77: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
> >    93 |                         fw->arp.arhrd_mask = ((uint16_t *)reg->bitwise.mask)[0];
> >       |                                                                             ^
> > nft-ruleparse-arp.c:102:77: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
> >   102 |                         fw->arp.arpro_mask = ((uint16_t *)reg->bitwise.mask)[0];
> >       |                                                                             ^
> > nft-ruleparse-arp.c:111:77: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
> >   111 |                         fw->arp.arpop_mask = ((uint16_t *)reg->bitwise.mask)[0];
> >       |                                                                             ^
> 
> Oops! I didn't notice this because my build script passed -O0 in CFLAGS,
> probably from code coverage analysis. So back to the previous approach
> involving a union which I had deemed too much for just those four cases:
> 
> diff --git a/iptables/nft-ruleparse.h b/iptables/nft-ruleparse.h
> index 0377e4ae17a6e..dc755b361ec72 100644
> --- a/iptables/nft-ruleparse.h
> +++ b/iptables/nft-ruleparse.h
> @@ -36,7 +36,11 @@ struct nft_xt_ctx_reg {
>         };
>  
>         struct {
> -               uint32_t mask[4];
> +               union {
> +                       uint32_t mask[4];
> +                       uint16_t mask16[];
> +                       uint8_t  mask8[];
> +               };
>                 uint32_t xor[4];
>                 bool set;
>         } bitwise;
> 
> Or simply use mempcy() instead of the assignment?

Or add:

static uint16_t get_u16p(uint32_t *t) { const uint16_t *p = (uint16_t *)t; return *p; }
static uint8_t get_u8p(uint32_t *t) { const uint8_t *p = (uint8_t *)t; return *p; }

... and use that.  But up to you.
