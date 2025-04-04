Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC431101EE
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Apr 2025 10:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743763214; cv=none; b=stj8HpxgKtNow4i9DqUVR3qlrl6SpW0ZiMfleB3M525zqX9Vzk2DwJX5TIUKwYY0ABqCvSSMZzVIVIRnTWXmvNXpfjyfU5CHncYC6bAAT8oWDx6au7gie13WLHosS0OGDTDJW363+Aa+Cg0fNwFBcsPH2tIxTSlFZBblH+/yMyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743763214; c=relaxed/simple;
	bh=rqRr/ndV4ZVOFUoEVozBOhTRCK0xcUkfA1rea+hLGKY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AJ0BIYdYj8W2aMxI6qYXtuvI6ysYoC5JjI9P6haihjhZMmvXs3CnnrCVwURS+g9OSIj2m4xRT5/tEjAvElpbvoGcC0dUVwIOJeVRhS9a00dG/fr5S2nB/LHjmhzp5aQW9iR4M/3OzY2ORRiWRV4Muk6VA2g54KpVb2QPlJy7llc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EpjpEfnv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EpjpEfnv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743763210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ehm9XCpIymN6mqh0BZxDc8th7eCKTjEG0IvwCBXT2AY=;
	b=EpjpEfnv/Pn7Ss63DUKDGZgVxur3zbStDhAZxMI/4NruDYqFcHEr42AH/0j0hVnHaG0RNf
	kKverpDl1aIGbnKIHN/TlkSvVkntz9De1tl14G8RmfK5p/s/ZzmV7puNiggCIZyhumaOy0
	Qh86875M3sLU2FpxqCGaD4E7Br853ME=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-siEfOhyrPxemDGhT6HiFtw-1; Fri, 04 Apr 2025 06:40:09 -0400
X-MC-Unique: siEfOhyrPxemDGhT6HiFtw-1
X-Mimecast-MFC-AGG-ID: siEfOhyrPxemDGhT6HiFtw_1743763209
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43bd0586a73so12682465e9.2
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Apr 2025 03:40:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743763208; x=1744368008;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ehm9XCpIymN6mqh0BZxDc8th7eCKTjEG0IvwCBXT2AY=;
        b=sVck+PvwiwAQ3aDYfmsh33CBgGHVRk8xyuKnZjIINHvGHWjjuPuS1C7E/gXp/MmEUR
         RZiTfT+GAqX1OZAucPKGvkvSM2J2YUmW5am3TkwSWxjzvCjLbd395y2YxYZn9zWbjF+l
         G0Uj7hYnVnYIFIfz0Xl2ZwJzJr2YyQGwlQU4uCEUZmGmE3CsrDM6qedD2OWR03pE3KRs
         8usJlICeXczzs/dKolUllVlovQsyEPNHIQrK5riL0+NZCaApRfx7CRGNVXRtVr4Fxpuw
         k+TmAcYGt2PiVht1sdjc7zuXzwbT9H9K/QIu82+whA6MHPNv52BXQpx3HKURbrbbc2pw
         e3wA==
X-Gm-Message-State: AOJu0YwVZnxeadsqcx+c6X4Khe015ZFxaLGJlDkRQx+8uy/fUeKYjmnN
	s8LyIT+AMasP03ve0QDCvKMIABLFlE3cFYNvthZoUNnuxiZqvXs947Ax/2SjmIUpSpkIct+h9nK
	N6/HWadenMHjC+oligAudTuSyVL5MkKcU1SX3y7sX66PgZb9TT4gJaj77PXB6E252MGjtZGiYIA
	==
X-Gm-Gg: ASbGncsb7dBoLN5CcMNbhw28eLfKhiSODummdRlt4bV/mzITqF5LCeZwCeSNhvR4tr3
	6Q/KyR/xq618iryEUwLZtTCdrB42Tfjm7eaWHUUw6c/q8Xq8ExzQ+NqDBw6s9YgKSVAYdLkMZjK
	EkL+8O4ZIRp1rQvOj3lzBwFa8QCzZKAk0U/Ml2UMKEfgnNBv+45y/8FXW64xnUFhNYgr/8m/yre
	dgfXxejXjAU9Kma+b/GR9G8Utc35ckuj90RtoXvzi68+y0+If66nChE3/vgjmDohu+qtIfgDqIz
	0JLxRoQ/yR8TrnVGmT84NGmW5hY=
X-Received: by 2002:a05:600c:500c:b0:43c:f575:e305 with SMTP id 5b1f17b1804b1-43ecf89e286mr27918965e9.8.1743763207750;
        Fri, 04 Apr 2025 03:40:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqym6s5WupbbEgqWtfJ3Beui84BuCfi/W6O+PnVDpp/8gAevQWGP2FlmQ/VE5cOD3Pxchjtw==
X-Received: by 2002:a05:600c:500c:b0:43c:f575:e305 with SMTP id 5b1f17b1804b1-43ecf89e286mr27918675e9.8.1743763207310;
        Fri, 04 Apr 2025 03:40:07 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec163106fsm46708975e9.4.2025.04.04.03.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 03:40:06 -0700 (PDT)
Date: Fri, 4 Apr 2025 12:40:05 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>, sontu21@gmail.com
Subject: Re: [PATCH nf 1/3] nft_set_pipapo: add avx register usage tracking
 for NET_DEBUG builds
Message-ID: <20250404124005.75ed1949@elisabeth>
In-Reply-To: <20250404062105.4285-2-fw@strlen.de>
References: <20250404062105.4285-1-fw@strlen.de>
	<20250404062105.4285-2-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Mostly nits:

On Fri,  4 Apr 2025 08:20:52 +0200
Florian Westphal <fw@strlen.de> wrote:

> Add rudimentary register tracking for avx2 helpers.
> 
> A register can have following states:
> - mem (contains packet data)
> - and (was consumed, value folded into other register)
> - tmp (holds result of folding operation)
> 
> Warn if
> a) register store happens while register has 'mem' bit set
>    but 'and' unset
> b) register is examined but wasn't written to
> c) register is folded into another register but wasn't written to

Thanks, this looks very useful... especially in hindsight. :)

> This is off unless NET_DEBUG=y is set.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo_avx2.c | 136 +++++++++++++++++++++++++++-
>  1 file changed, 131 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> index b8d3c3213efe..8ce7154b678a 100644
> --- a/net/netfilter/nft_set_pipapo_avx2.c
> +++ b/net/netfilter/nft_set_pipapo_avx2.c
> @@ -26,6 +26,109 @@
>  
>  #define NFT_PIPAPO_LONGS_PER_M256	(XSAVE_YMM_SIZE / BITS_PER_LONG)
>  
> +#if defined(CONFIG_DEBUG_NET)

This made me wonder if there's any specific reason why we would need
#if defined(x) here instead of a common #ifdef x. It looks like there
isn't a reason, so maybe #ifdef CONFIG_DEBUG_NET is more... expected.

> +struct nft_pipapo_debug_regmap {

It would be nice to have those comments in kerneldoc style for
consistency with everything else:

/**
 * struct nft_pipapo_debug_regmap - Bitmaps representing sets of YMM registers

> +	unsigned long mem;			/* register store: reg := mem (packet data) */

...and here it took me a while to understand that, if the bit is set,
the register was *already used* for a store, perhaps:

 * @mem:	n-th bit set if YMM<n> was loaded from memory (packet data)

> +	unsigned long and;			/* register used as and operator */
> +	unsigned long tmp;			/* register used as and destination */

Capitalising "and" would make this more readable I think, say:

 * @and:	YMM<n> already used as AND operand

Perhaps those could all be uint16_t to reflect that it's YMM registers,
and nft_pipapo_avx2_debug_usable() could simply promote them to
unsigned long as needed by test_bit().

They could even be uint32_t to represent ZMM registers (or extended
YMM) if we want to make this AVX512-ready, I'm not sure.

> +};
> +
> +/* yym15 is used as an always-0-register, see nft_pipapo_avx2_prepare */

That's ymm15 or YMM15. nft_pipapo_avx2_prepare().

> +#define	NFT_PIPAPO_AVX2_DEBUG_MAP	struct nft_pipapo_debug_regmap __pipapo_debug_regmap = { .mem = 1 << 15 }

I guess it would be nice to have all this wrapped to 80 columns unless
it particularly bothers you. If it doesn't:

#define NFT_PIPAPO_AVX2_DEBUG_MAP					\
	struct nft_pipapo_debug_regmap __pipapo_debug_regmap = {	\
		.mem = BIT(15),						\
	}

> +
> +#define NFT_PIPAPO_WARN(cond, reg, message)						\
> +	DEBUG_NET_WARN_ONCE((cond), "reg %d %s, mem %08lx, and %08lx tmp %08lx",	\
> +		  (reg), (message), __pipapo_debug_regmap.mem, __pipapo_debug_regmap.and, __pipapo_debug_regmap.tmp)
> +
> +/**
> + * nft_pipapo_avx2_debug_load() - record a store to reg

I would say it does more than that, say,

 * nft_pipapo_avx2_debug_load() - Record a store to register, check its validity

?

> + *
> + * @reg: the register being written to

 * @r: Current bitmap of registers for debugging purposes

> + *
> + * Return: true if splat needs to be triggered
> + */
> +static inline bool nft_pipapo_avx2_debug_load(unsigned int reg,
> +					      struct nft_pipapo_debug_regmap *r)
> +{
> +	bool anded, used, tmp;
> +
> +	anded = test_bit(reg, &r->and);
> +	used = test_bit(reg, &r->mem);
> +	tmp = test_bit(reg, &r->tmp);

These shouldn't touch the bitmaps, so...

> +	anded = test_and_clear_bit(reg, &r->and);
> +	tmp = test_and_clear_bit(reg, &r->tmp);
> +	used = test_and_set_bit(reg, &r->mem);

it looks like the test_bit() checks above are a left-over without
effect, unless I'm missing something.

Shouldn't we warn if tmp is true, and, in nft_pipapo_avx2_debug_and(),
clear the bit once the destination/temporary register was in turn ANDed?

Otherwise we could clobber a valid temporary register, I guess.

> +
> +	if (!used) /* Not used -> ok, no warning needs to be emitted. */
> +		return false;
> +
> +	/* Register is clobbered, Warning needs to be emitted if it wasn't AND'ed */

warning

> +	return !anded;
> +}
> +
> +/**
> + * nft_pipapo_avx2_debug_and() - mark registers as being ANDed
> + *
> + * @reg1: the register being written to
> + * @reg2: the first register being anded
> + * @reg3: the second register being anded

NFT_PIPAPO_AVX2_AND() uses @dst, @a, @b. We could use the same here for
consistency.

> + *
> + * Tags @reg2 and @reg3 as ANDed register
> + * Tags @reg1 as containing AND result
> + *
> + * Return: true if splat needs to be triggered
> + */
> +static inline bool nft_pipapo_avx2_debug_and(unsigned int reg1, unsigned int reg2,
> +					     unsigned int reg3,
> +					     struct nft_pipapo_debug_regmap *r)
> +{
> +	bool r2_and = test_and_set_bit(reg2, &r->and);
> +	bool r3_and = test_and_set_bit(reg3, &r->and);
> +	bool r2_tmp = test_and_set_bit(reg2, &r->tmp);
> +	bool r3_tmp = test_and_set_bit(reg3, &r->tmp);

I thought you would just set BIT(reg1) in r->tmp as a result: r2 and r3
are not used as destination/temporary. Or maybe I misunderstood the
description of 'tmp'.

> +	bool r2_mem = test_bit(reg2, &r->mem);
> +	bool r3_mem = test_bit(reg3, &r->mem);
> +
> +	clear_bit(reg1, &r->mem);
> +	set_bit(reg1, &r->tmp);
> +
> +	return (!r2_mem && !r2_and && !r2_tmp) || (!r3_mem && !r3_and && !r3_tmp);
> +}
> +
> +/* saw a load, ok if register hasn't been used (mem bit not set)
> + * or if the register was anded to another register (mem_and is set).
> + */
> +#define	NFT_PIPAPO_AVX2_SAW_LOAD(reg)	({	\
> +	unsigned int r__ = (reg);		\
> +	NFT_PIPAPO_WARN(nft_pipapo_avx2_debug_load(r__, &__pipapo_debug_regmap), r__, "busy");\

Same here, I would wrap at 80 columns if doable and not annoying.

> +})
> +

/**
 * nft_pipapo_avx2_debug_usable() - @reg usable as temporary or for memory load?
 * @reg:	Index of register
 * Return: true if register is free for usage
 */

> +static inline bool nft_pipapo_avx2_debug_usable(unsigned int reg,
> +						const struct nft_pipapo_debug_regmap *r)
> +{
> +	unsigned long u = r->mem | r->and | r->tmp;
> +
> +	return !test_bit(reg, &u);
> +}
> +
> +#define NFT_PIPAPO_AVX2_USABLE(reg) ({			\
> +	unsigned int r__ = (reg);			\
> +	NFT_PIPAPO_WARN(nft_pipapo_avx2_debug_usable(r__, &__pipapo_debug_regmap), r__, "undef");\
> +})
> +
> +#define NFT_PIPAPO_AVX2_AND_DEBUG(dst, a, b) ({		\
> +	unsigned int r__ = (dst);			\
> +	NFT_PIPAPO_WARN(nft_pipapo_avx2_debug_and(r__, (a), (b), &__pipapo_debug_regmap), r__, "invalid sreg");\
> +})
> +
> +#else

I guess it would be practical to mark this as /* !CONFIG_DEBUG_NET */

> +#define	NFT_PIPAPO_AVX2_SAW_LOAD(reg)		BUILD_BUG_ON_INVALID(reg)
> +#define	NFT_PIPAPO_AVX2_USABLE(reg)		BUILD_BUG_ON_INVALID(reg)

I'm not sure if there's much value in indenting those with an extra tab.

> +#define NFT_PIPAPO_AVX2_AND_DEBUG(dst, a, b)	BUILD_BUG_ON_INVALID((dst) | (a) | (b))
> +#define	NFT_PIPAPO_AVX2_DEBUG_MAP		do { } while (0)
> +#endif
> +
>  /* Load from memory into YMM register with non-temporal hint ("stream load"),
>   * that is, don't fetch lines from memory into the cache. This avoids pushing
>   * precious packet data out of the cache hierarchy, and is appropriate when:
> @@ -37,7 +140,10 @@
>   *   again
>   */
>  #define NFT_PIPAPO_AVX2_LOAD(reg, loc)					\
> -	asm volatile("vmovntdqa %0, %%ymm" #reg : : "m" (loc))
> +do {									\
> +	asm volatile("vmovntdqa %0, %%ymm" #reg : : "m" (loc));		\
> +	NFT_PIPAPO_AVX2_SAW_LOAD(reg);					\
> +} while (0)
>  
>  /* Stream a single lookup table bucket into YMM register given lookup table,
>   * group index, value of packet bits, bucket size.
> @@ -53,19 +159,29 @@
>  
>  /* Bitwise AND: the staple operation of this algorithm */
>  #define NFT_PIPAPO_AVX2_AND(dst, a, b)					\
> -	asm volatile("vpand %ymm" #a ", %ymm" #b ", %ymm" #dst)
> +do {									\
> +	BUILD_BUG_ON(a == b);						\
> +	asm volatile("vpand %ymm" #a ", %ymm" #b ", %ymm" #dst);	\
> +	NFT_PIPAPO_AVX2_AND_DEBUG(dst, a, b);				\
> +} while (0)
>  
>  /* Jump to label if @reg is zero */
>  #define NFT_PIPAPO_AVX2_NOMATCH_GOTO(reg, label)			\
> -	asm goto("vptest %%ymm" #reg ", %%ymm" #reg ";"	\
> -			  "je %l[" #label "]" : : : : label)
> +do {									\
> +	NFT_PIPAPO_AVX2_USABLE(reg);					\

Here, I'm definitely missing something, because this works but I'm not
sure why.

I thought that nft_pipapo_avx2_debug_usable() would return true iff the
register is _free_.

But it must be a valid temporary (in 'tmp', right?) if we use vptest on
it. So it should *not* be "usable" (as destination), right? Or maybe I
misunderstood the role of 'tmp' altogether.

> +	asm goto("vptest %%ymm" #reg ", %%ymm" #reg ";"			\
> +			  "je %l[" #label "]" : : : : label);		\
> +} while (0)
>  
>  /* Store 256 bits from YMM register into memory. Contrary to bucket load
>   * operation, we don't bypass the cache here, as stored matching results
>   * are always used shortly after.
>   */
>  #define NFT_PIPAPO_AVX2_STORE(loc, reg)					\
> -	asm volatile("vmovdqa %%ymm" #reg ", %0" : "=m" (loc))
> +do {									\
> +	NFT_PIPAPO_AVX2_USABLE(reg);					\
> +	asm volatile("vmovdqa %%ymm" #reg ", %0" : "=m" (loc));		\
> +} while (0)
>  
>  /* Zero out a complete YMM register, @reg */
>  #define NFT_PIPAPO_AVX2_ZERO(reg)					\
> @@ -219,6 +335,7 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	u8 pg[2] = { pkt[0] >> 4, pkt[0] & 0xf };
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -282,6 +399,7 @@ static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	u8 pg[4] = { pkt[0] >> 4, pkt[0] & 0xf, pkt[1] >> 4, pkt[1] & 0xf };
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -361,6 +479,7 @@ static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
>  		   };
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -458,6 +577,7 @@ static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
>  		    };
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -553,6 +673,7 @@ static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
>  		    };
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -680,6 +801,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -738,6 +860,7 @@ static int nft_pipapo_avx2_lookup_8b_2(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -803,6 +926,7 @@ static int nft_pipapo_avx2_lookup_8b_4(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -879,6 +1003,7 @@ static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -965,6 +1090,7 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {

-- 
Stefano

