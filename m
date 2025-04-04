Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9D81F2B94
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Apr 2025 13:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743774889; cv=none; b=iXk5q54k/MrIiCQl5/L3a9yYl0li0pqSGbEKfDXAma7rGbS8AknIqcQ93mpWL7ff4C62oNGYR83M0GRlA8E0bMGvpVvBC4meq8jqL5bFFTPWhcD/PAGzE7NeBknDwg9g16PhQdbsMf4VCKhxnXNBC/kEwaCduDAK9qwbvQ4cDqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743774889; c=relaxed/simple;
	bh=DjfOutTo5pE4kmMIRn/sZYsa66iYDiKXWUOsiN8S9Sc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZllpxellIRWdVWQR4pSmKFPR116CW6+0XrzWZ7znN1D6pq2Muez7hR61Fab+NlEvOuxoq/f39zTtslcELUu2DPn0sd4YdSUoJb7VqnWpQ9PSo9CS/5n5d7X0Kj8pe6CPimqxzaK0WzJ5Jv2vrRucEQvpCiHPupJC1/g+ALmmqZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LHGLGnl2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LHGLGnl2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743774885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sSSqP161FnLQgoMkHYJb6nWTt4IyK86LmiNcPZZjGNw=;
	b=LHGLGnl20kSNKYOSpnT5ueC1qd4PjJ45clHLHaJ2bIxSt7bUflUIj3eosvWVg4YnNGIR3I
	vfdQhPESMwOx2TGwSoUA4h4W8cmrrDccYh/CyyOMrXfAbdD+a6ZRJ2/0mxSu5HFKvUxy7h
	6nZewpZKXHWtSaH38QH2rDz5eUvoesc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-PRt0M9yONNGTdZFvHhNtpA-1; Fri, 04 Apr 2025 09:54:43 -0400
X-MC-Unique: PRt0M9yONNGTdZFvHhNtpA-1
X-Mimecast-MFC-AGG-ID: PRt0M9yONNGTdZFvHhNtpA_1743774882
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43d733063cdso16974145e9.0
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Apr 2025 06:54:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743774882; x=1744379682;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sSSqP161FnLQgoMkHYJb6nWTt4IyK86LmiNcPZZjGNw=;
        b=HBOiEjEuenN/Fgoi/fmaN9D/sVKlCTX8uysCwJ5LnbO74/vqy+LfqFU5sW/J7CrBGX
         jlWUdQA9fqj4DWHdZBLGuUL2isUtx5PE7KXoK9yulWf96AJ6Xyi470D5C88CKRFlU89U
         vShZIdup/2yqsnjxLJlilrcMswVWa/N6RP3N7SI0MYXK/xg1caP/8pJlzk5JzNbG9VSk
         bwzA2WuJc/6IT/HtZDb3NUyyBo40OCpUMesyH7vQ/U/VBeFMtyCoClmhBOxWKEULfKQN
         lvsK2Ocb2CHjdlPXNdP8vMmhcR9qZcBW4X88uzx3rRcxFfvPD6AdnYokQSKgj+wCvovD
         39Lg==
X-Gm-Message-State: AOJu0Yxn75Eb9sahyg4WoU04/fehcFwpvF+OQwjpndz6D+3hRDs4uD1h
	oYTkWQwvZL1Bapg0O9fry0NeUDG9fBh84u5uQrPcp/q+G/osWOifH10DFDLa8dOqnXZCIQp8PeJ
	50s45dtqhxq4RdIE1+RSywsbHncf1wA1+wGCLFr5KYwc3WG1wff6ocj186/WuC5v3aw==
X-Gm-Gg: ASbGnctErUA/HM8LfKHhcQeRUBdjFOxdpJWNgzrV2a9OcchKv1jxgHJ3Qj82/P4frhY
	2caSaN+KozFvL7MYjdTi4L4mloLkAfRMeqvhUrObwbS0aJ/5of1uoWoGsCK/NVRXdH5CYgQB4W5
	2rr3nNHJw9Mw+u39UObnbRMtkegSAoRjqI8bWFbodXwEPHoaL4MtGR+9GmGXrqDBFlD+6pxv8e9
	+/Iqdaj/yADoTP7Af2uQgl1QEJtfP4B+Mnmc6Lljm+zCdtWKx+uE46wOwHjkSeuqWFL/spfVPmN
	TxUlWMiA3nHg+Tsux2qo+ILgeGHkEGuBSR8c1WkPgRZZ
X-Received: by 2002:a05:600c:3d97:b0:43b:c284:5bc2 with SMTP id 5b1f17b1804b1-43ecf57fb5emr35154045e9.0.1743774882363;
        Fri, 04 Apr 2025 06:54:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHmTr++tQ0Mb9lByg5Qw8xvCGcTgU6ZiFrsWZ3r1CMZfcW19ewDSDrNjIDvxbVElkXe3K2kQ==
X-Received: by 2002:a05:600c:3d97:b0:43b:c284:5bc2 with SMTP id 5b1f17b1804b1-43ecf57fb5emr35153795e9.0.1743774881902;
        Fri, 04 Apr 2025 06:54:41 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec34a895fsm46724535e9.13.2025.04.04.06.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 06:54:41 -0700 (PDT)
Date: Fri, 4 Apr 2025 15:54:37 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH v2 nf 1/3] nft_set_pipapo: add avx register usage
 tracking for NET_DEBUG builds
Message-ID: <20250404155437.58ff9b26@elisabeth>
In-Reply-To: <20250404133229.12395-2-fw@strlen.de>
References: <20250404133229.12395-1-fw@strlen.de>
	<20250404133229.12395-2-fw@strlen.de>
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

On Fri,  4 Apr 2025 15:32:24 +0200
Florian Westphal <fw@strlen.de> wrote:

> Add rudimentary register tracking for avx2 helpers.
> 
> A register can have following states:
> - mem (contains packet data)
> - and (was consumed, value folded into other register)
> - tmp (holds result of folding operation)
> 
> mem and tmp are mutually exclusive.
> 
> Warn if
> a) register store happens while register has 'mem' bit set
>    but 'and' unset.
>    This detects clobbering of a register with new
>    packet data before the previous load has been processed.
> b) register is read but wasn't written to before
>    This detects operations happening on undefined register
>    content, such as AND or GOTOs.
> c) register is saved to memory, but it doesn't hold result
>    of an AND operation.
>    This detects erroneous stores to the memory scratch map.
> d) register is used for goto, but it doesn't contain result
>    of earlier AND operation.
> 
> This is disabled for NET_DEBUG=n builds.
> 
> v2: Improve kdoc (Stefano Brivio)
>     Use u16 (Stefano Brivio)
>     Reduce macro usage in favor of inline helpers
>     warn if we store register to memory but its not holding
>     result of AND operation
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Thanks, it looks much clearer (at least to me) now. Just some
exceedingly minor nits below. Other than that,

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

> ---
>  v2: major changes as per Stefano
> 
>  Stores to memory or GOTOs now cause a splat unless the register
>  result of AND operation.

Ah, oops, I thought that was the intention in v1 too! :)

>  This triggers in 1 case but I think code is fine, I added
>  nft_pipapo_avx2_force_tmp() helper and use it in the relevant spot.

It makes sense to me, details below.

> 
>  net/netfilter/nft_set_pipapo_avx2.c | 217 ++++++++++++++++++++++++++--
>  1 file changed, 203 insertions(+), 14 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> index b8d3c3213efe..334d16096d00 100644
> --- a/net/netfilter/nft_set_pipapo_avx2.c
> +++ b/net/netfilter/nft_set_pipapo_avx2.c
> @@ -26,6 +26,160 @@
>  
>  #define NFT_PIPAPO_LONGS_PER_M256	(XSAVE_YMM_SIZE / BITS_PER_LONG)
>  
> +/**
> + * struct nft_pipapo_debug_regmap - Bitmaps representing sets of YMM registers
> + *
> + * @mem: n-th bit set if YMM<n> contains packet data loaded from memory
> + * @and: n-th bit set if YMM<n> was folded (AND operation done)
> + * @tmp: n-th bit set if YMM<n> contains folded data (result of AND operation)
> + */
> +struct nft_pipapo_debug_regmap {
> +#ifdef CONFIG_DEBUG_NET
> +	u16 mem;
> +	u16 and;
> +	u16 tmp;
> +#endif
> +};
> +
> +#ifdef CONFIG_DEBUG_NET
> +/* YYM15 is used as an always-0-register, see nft_pipapo_avx2_prepare */

It's really YMM (or ymm), with two m's and one y. :) That's what I was
referring to in my previous comment.

> +#define NFT_PIPAPO_AVX2_DEBUG_MAP                                       \
> +	struct nft_pipapo_debug_regmap __pipapo_debug_regmap = {        \
> +		.tmp = BIT(15),                                         \
> +	}

This mixes spaces and tabs (I guess from copy and paste).

> +
> +#define NFT_PIPAPO_WARN(cond, reg, rmap, line, message)	({			\
> +	const struct nft_pipapo_debug_regmap *rm__ = (rmap);			\
> +	DEBUG_NET_WARN_ONCE((cond), "reg %d line %u %s, mem %04x, and %04x tmp %04x",\
> +		  (reg), (line), (message), rm__->mem, rm__->and, rm__->tmp);	\
> +})
> +#else /* !CONFIG_DEBUG_NET */
> +#define NFT_PIPAPO_AVX2_DEBUG_MAP                                       \
> +	struct nft_pipapo_debug_regmap __pipapo_debug_regmap
> +#endif
> +
> +/**
> + * nft_pipapo_avx2_load_packet() - Check and record packet data store
> + *
> + * @reg: Index of register being written to
> + * @r: Current bitmap of registers for debugging purposes
> + * @line: __LINE__ number filled via AVX2 macro
> + *
> + * Mark reg as holding packet data.
> + * Check reg is unused or had an AND operation performed on it.
> + */
> +static inline void nft_pipapo_avx2_load_packet(unsigned int reg,
> +					       struct nft_pipapo_debug_regmap *r,
> +					       unsigned int line)
> +{
> +#ifdef CONFIG_DEBUG_NET
> +	bool used = BIT(reg) & (r->mem | r->tmp);
> +	bool anded = BIT(reg) & r->and;
> +
> +	r->and &= ~BIT(reg);
> +	r->tmp &= ~BIT(reg);
> +	r->mem |= BIT(reg);
> +
> +	if (used)
> +		NFT_PIPAPO_WARN(!anded, reg, r, line, "busy");
> +#endif
> +}
> +
> +/**
> + * nft_pipapo_avx2_force_tmp() - Mark @reg as holding result of AND operation
> + * @reg: Index of register
> + * @r: Current bitmap of registers for debugging purposes
> + *
> + * Mark reg as holding temporary data, no checks are performed.
> + */
> +static inline void nft_pipapo_avx2_force_tmp(unsigned int reg,
> +					   struct nft_pipapo_debug_regmap *r)
> +{
> +#ifdef CONFIG_DEBUG_NET
> +	r->tmp |= BIT(reg);
> +	r->mem &= ~BIT(reg);
> +#endif
> +}
> +
> +/**
> + * nft_pipapo_avx2_load_tmp() - Check and record scratchmap restore
> + *
> + * @reg: Index of register being written to
> + * @r: Current bitmap of registers for debugging purposes
> + * @line: __LINE__ number filled via AVX2 macro
> + *
> + * Mark reg as holding temporary data.
> + * Check reg is unused or had an AND operation performed on it.
> + */
> +static inline void nft_pipapo_avx2_load_tmp(unsigned int reg,
> +					    struct nft_pipapo_debug_regmap *r,
> +					    unsigned int line)
> +{
> +#ifdef CONFIG_DEBUG_NET
> +	bool used = BIT(reg) & (r->mem | r->tmp);
> +	bool anded = BIT(reg) & r->and;
> +
> +	r->and &= ~BIT(reg);
> +
> +	nft_pipapo_avx2_force_tmp(reg, r);
> +
> +	if (used)
> +		NFT_PIPAPO_WARN(!anded, reg, r, line, "busy");
> +#endif
> +}
> +
> +/**
> + * nft_pipapo_avx2_debug_and() - Mark registers as being ANDed
> + *
> + * @a: Index of register being written to
> + * @b: Index of first register being ANDed
> + * @c: Index of second register being ANDed
> + * @r: Current bitmap of registers for debugging purposes
> + * @line: __LINE__ number filled via AVX2 macro
> + *
> + * Tags @reg2 and @reg3 as ANDed register
> + * Tags @reg1 as containing AND result
> + */
> +static inline void nft_pipapo_avx2_debug_and(unsigned int a, unsigned int b,
> +					     unsigned int c,
> +					     struct nft_pipapo_debug_regmap *r,
> +					     unsigned int line)
> +{
> +#ifdef CONFIG_DEBUG_NET
> +	bool b_and = BIT(b) & r->and;
> +	bool c_and = BIT(c) & r->and;
> +	bool b_tmp = BIT(b) & r->tmp;
> +	bool c_tmp = BIT(c) & r->tmp;
> +	bool b_mem = BIT(b) & r->mem;
> +	bool c_mem = BIT(c) & r->mem;
> +
> +	r->and |= BIT(b);
> +	r->and |= BIT(c);
> +
> +	nft_pipapo_avx2_force_tmp(a, r);
> +
> +	NFT_PIPAPO_WARN((!b_mem && !b_and && !b_tmp), b, r, line, "unused");
> +	NFT_PIPAPO_WARN((!c_mem && !c_and && !c_tmp), c, r, line, "unused");
> +#endif
> +}
> +
> +/**
> + * nft_pipapo_avx2_reg_tmp() - Check that @reg holds result of AND operation
> + * @reg: Index of register
> + * @r: Current bitmap of registers for debugging purposes
> + * @line: __LINE__ number filled via AVX2 macro
> + */
> +static inline void nft_pipapo_avx2_reg_tmp(unsigned int reg,
> +					   const struct nft_pipapo_debug_regmap *r,
> +					   unsigned int line)
> +{
> +#ifdef CONFIG_DEBUG_NET
> +	bool holds_and_result = BIT(reg) & r->tmp;
> +
> +        NFT_PIPAPO_WARN(!holds_and_result, reg, r, line, "unused");

This is indented with spaces.

> +#endif
> +}
> +
>  /* Load from memory into YMM register with non-temporal hint ("stream load"),
>   * that is, don't fetch lines from memory into the cache. This avoids pushing
>   * precious packet data out of the cache hierarchy, and is appropriate when:
> @@ -36,36 +190,60 @@
>   * - loading the result bitmap from the previous field, as it's never used
>   *   again
>   */
> -#define NFT_PIPAPO_AVX2_LOAD(reg, loc)					\
> -	asm volatile("vmovntdqa %0, %%ymm" #reg : : "m" (loc))
> +#define __NFT_PIPAPO_AVX2_LOAD(reg, loc)				\
> +	asm volatile("vmovntdqa %0, %%ymm" #reg : : "m" (loc));		\
> +
> +#define NFT_PIPAPO_AVX2_LOAD(reg, loc) do {				\
> +	nft_pipapo_avx2_load_tmp(reg,					\
> +				 &__pipapo_debug_regmap, __LINE__);	\
> +	__NFT_PIPAPO_AVX2_LOAD(reg, loc);				\
> +} while (0)
>  
>  /* Stream a single lookup table bucket into YMM register given lookup table,
>   * group index, value of packet bits, bucket size.
>   */
> -#define NFT_PIPAPO_AVX2_BUCKET_LOAD4(reg, lt, group, v, bsize)		\
> -	NFT_PIPAPO_AVX2_LOAD(reg,					\
> -			     lt[((group) * NFT_PIPAPO_BUCKETS(4) +	\
> -				 (v)) * (bsize)])
> -#define NFT_PIPAPO_AVX2_BUCKET_LOAD8(reg, lt, group, v, bsize)		\
> -	NFT_PIPAPO_AVX2_LOAD(reg,					\
> -			     lt[((group) * NFT_PIPAPO_BUCKETS(8) +	\
> -				 (v)) * (bsize)])
> +#define NFT_PIPAPO_AVX2_BUCKET_LOAD4(reg, lt, group, v, bsize) do {	\
> +	nft_pipapo_avx2_load_packet(reg,				\
> +				    &__pipapo_debug_regmap, __LINE__);	\
> +	__NFT_PIPAPO_AVX2_LOAD(reg,					\
> +			       lt[((group) * NFT_PIPAPO_BUCKETS(4) +	\
> +			       (v)) * (bsize)]);			\
> +} while (0)
> +
> +#define NFT_PIPAPO_AVX2_BUCKET_LOAD8(reg, lt, group, v, bsize) do {	\
> +	nft_pipapo_avx2_load_packet(reg,				\
> +				    &__pipapo_debug_regmap, __LINE__);	\
> +	__NFT_PIPAPO_AVX2_LOAD(reg,					\
> +			       lt[((group) * NFT_PIPAPO_BUCKETS(8) +	\
> +			       (v)) * (bsize)])				\
> +} while (0)
>  
>  /* Bitwise AND: the staple operation of this algorithm */
>  #define NFT_PIPAPO_AVX2_AND(dst, a, b)					\
> -	asm volatile("vpand %ymm" #a ", %ymm" #b ", %ymm" #dst)
> +do {									\
> +	BUILD_BUG_ON(a == b);						\
> +	asm volatile("vpand %ymm" #a ", %ymm" #b ", %ymm" #dst);	\
> +	nft_pipapo_avx2_debug_and(dst, a, b,				\
> +				  &__pipapo_debug_regmap, __LINE__);	\
> +} while (0)
>  
>  /* Jump to label if @reg is zero */
>  #define NFT_PIPAPO_AVX2_NOMATCH_GOTO(reg, label)			\
> -	asm goto("vptest %%ymm" #reg ", %%ymm" #reg ";"	\
> -			  "je %l[" #label "]" : : : : label)
> +do {									\
> +	nft_pipapo_avx2_reg_tmp(reg, &__pipapo_debug_regmap, __LINE__);	\
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
> +	nft_pipapo_avx2_reg_tmp(reg, &__pipapo_debug_regmap, __LINE__);	\
> +	asm volatile("vmovdqa %%ymm" #reg ", %0" : "=m" (loc));		\
> +} while (0)
>  
>  /* Zero out a complete YMM register, @reg */
>  #define NFT_PIPAPO_AVX2_ZERO(reg)					\
> @@ -219,6 +397,7 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	u8 pg[2] = { pkt[0] >> 4, pkt[0] & 0xf };
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -282,6 +461,7 @@ static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	u8 pg[4] = { pkt[0] >> 4, pkt[0] & 0xf, pkt[1] >> 4, pkt[1] & 0xf };
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -361,6 +541,7 @@ static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
>  		   };
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -458,6 +639,7 @@ static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
>  		    };
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -553,6 +735,7 @@ static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
>  		    };
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -680,6 +863,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -687,6 +871,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
>  
>  		if (first) {
>  			NFT_PIPAPO_AVX2_BUCKET_LOAD8(2, lt, 0, pkt[0], bsize);
> +			nft_pipapo_avx2_force_tmp(2, &__pipapo_debug_regmap);

Right, that's because we have an 8-bit bucket and we're comparing 8
bits, so in this case we don't need to AND any value in the first
iteration.

>  		} else {
>  			NFT_PIPAPO_AVX2_BUCKET_LOAD8(0, lt, 0, pkt[0], bsize);
>  			NFT_PIPAPO_AVX2_LOAD(1, map[i_ul]);
> @@ -738,6 +923,7 @@ static int nft_pipapo_avx2_lookup_8b_2(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -803,6 +989,7 @@ static int nft_pipapo_avx2_lookup_8b_4(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -879,6 +1066,7 @@ static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -965,6 +1153,7 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {

-- 
Stefano

