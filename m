Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B6DEAE7
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Apr 2025 07:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744097401; cv=none; b=eX/W5x0GSuI+Y3rxClSLXCY0yHTM8OjjiwlMO27oauuQA5kaI+GZ/i9zqtPcsUda3apkzWIw+0TxON+yZTbL+2kKcRx83dVSCsdZ8k6YpFbsJfkEeWC9umZZkpl1M01vcI0nQnco7fDY6iV3yJRVbtrtfY3Gmr44ef2VN7PmkxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744097401; c=relaxed/simple;
	bh=XXLXMmSiAJUTAt54Slwyl2OKV/YotWW5BB65uqc9L8s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ldICcyS3c1oBMAzSp981f64SRh1J3Gp9Tz4jolQYD59zPS3L0m/TDE7l+zzSIcdRgpMQObbdAw0E26PyhQxgPlEExVi+hCamKMexzdOb/8ksY4AS81O/wwxpqL0yMGF5lxBIgbmKCX7opUldmpm48/pJgxDlLEzNBU7rdVckZ64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GRT1cS5Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GRT1cS5Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744097396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EiyAqxNtp9ECN1lK4p7LdnTSfCipru5QIK5T1bLbdWc=;
	b=GRT1cS5QHgNMKEazFbD1m8aLUJrbOeM+3Dtau3ZhWLGpWYUKtikgN7VL3dNfNC4abMMDJ3
	KfRV2eL8WMq7QW3VlfEJGtAqnLFb8CIztUVNz8yXglvbOTyNM/v0tQmZTkJlx8NmAWuoI9
	BCNtaWjLtR+eni4TGyGVKfHDkwitf0Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-4e2RLeNXPemx8O4lGs07cg-1; Tue, 08 Apr 2025 03:29:54 -0400
X-MC-Unique: 4e2RLeNXPemx8O4lGs07cg-1
X-Mimecast-MFC-AGG-ID: 4e2RLeNXPemx8O4lGs07cg_1744097393
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d733063cdso44205525e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Apr 2025 00:29:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744097391; x=1744702191;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EiyAqxNtp9ECN1lK4p7LdnTSfCipru5QIK5T1bLbdWc=;
        b=A0C4fgyEq/5Q7WWJS8kq1MTGMcvRHJij1VjkYwrUmchC55fQx6uFkJLl0sc6SbLvaG
         d6bOpFgwxzk57qBtYqAUmblPqqtMy452q/C3rHTcT1XQ7ugFcAaf1JuWponrWAME+WbF
         zjarTWnUZyBrLaWtMh3eKogVGl2wpD3t7MZ2heuU03bWDGSP/KLSsQPVCpFmVzffOV3g
         NXvQCtDzawB73+nwR6d26a1n7AoHInMoExHugSkks0YER0vZDI6qftnccNKazITCXptO
         4CzD18vGCyg6HiQk/7qrJY2qr7JdYjuXLI1HQ24WGUkz8l08v5j+u3qFxewq/Fdy+Eht
         0iSw==
X-Gm-Message-State: AOJu0YwRTr5nFb5sw7U6bvUa9+5041OrNMxwY/St9mVceBg7s2JMMD/M
	+FHAAINNHHuR7Kf04kdaLNe3o6P/NEB3YUnkd7NS5i6lBfhibu4oN/rH3X4Q16mW7Rht6jZybuD
	i28GpFiLgtT/Rd7vC5GbOYBliHM+QrslW/sCkOUNpfHhz47l/+sTJeNvR7VXXENkE5XVUeRVkOw
	==
X-Gm-Gg: ASbGncsiQxvueREY+ZBAI392xjsL5aqqUZK5YdUXRmFhhMTZal5MBRR6QzrEg+A03/k
	m6KBq9FFvGMgetnxB39xQBUih8vc8dlgIVE2ia58HNXt3Xvh28inSC8Jx28G4Rus8kmCqdsdGoD
	9z54O6yHi6r4cjN9axFj+UlUVZu/Ckz+SBl2UdCz/Y4DCRwoHTLsanFOZeiqPFmk+N36+LNV0TC
	mRBmacnLIRQy4+3O0mCqqmtDvIcbu7PVAbn0XEtgUBoKb9K4X+rHRdBc1un9GXYlRBo+VxzRaaz
	ZnyletBIX2Ui8BcRwlyV1INNA5d8x08AkcW8oUkxr2ec
X-Received: by 2002:a05:6000:1a8e:b0:391:39bd:a381 with SMTP id ffacd0b85a97d-39d6fc7b796mr9975911f8f.30.1744097391077;
        Tue, 08 Apr 2025 00:29:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGv/PuZsNlFmh8WXz7tJood/kE+5oMX0uxTvlsNCS+eYmOfE7jY3Gb3L2gKWR5rlr+M9uIHuA==
X-Received: by 2002:a05:6000:1a8e:b0:391:39bd:a381 with SMTP id ffacd0b85a97d-39d6fc7b796mr9975885f8f.30.1744097390563;
        Tue, 08 Apr 2025 00:29:50 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301b760bsm14162879f8f.55.2025.04.08.00.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 00:29:50 -0700 (PDT)
Date: Tue, 8 Apr 2025 09:29:49 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH v3 nf 3/3] nft_set_pipapo: add avx register usage
 tracking for NET_DEBUG builds
Message-ID: <20250408092949.1afdee61@elisabeth>
In-Reply-To: <20250407174048.21272-4-fw@strlen.de>
References: <20250407174048.21272-1-fw@strlen.de>
	<20250407174048.21272-4-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

It took me a bit to decipher some parts, but it looks functionally good
to me. A few comments below.

I wonder, by the way, if 1/3 and 2/3 shouldn't be applied meanwhile
(perhaps that was the reason for moving this at the end...?).

On Mon,  7 Apr 2025 19:40:20 +0200
Florian Westphal <fw@strlen.de> wrote:

> Add ymm register tracking for avx2 helpers.
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
> e) There is an unprocessed register left when the function
>    returns (only mem bit is set).

I think d) and e) are pretty valuable, indeed.

> Also print a notice when we have a never-used-register,
> it would hint at some way to optimize code.
> For those helpers that don't process enough data fields
> to fill all, this error is suppressed -- they pass the
> highest inuse register.
> 
> There is one exception for c) in the code (where we only
> have one byte to process.  The helper
> nft_pipapo_avx2_force_tmp() is used for this to forcibly
> convert the state from 'mem' to 'tmp'.
> 
> This is disabled for NET_DEBUG=n builds.
> 
> v3: add additional 'done' test to check all registers
>     were handled
>     fix macro space/tab indent in a few places (Stefano)
>     fix yym typos (Stefano)
>     make this change last in the series
> 
> v2: Improve kdoc (Stefano Brivio)
>     Use u16, not long (Stefano Brivio)
>     Reduce macro usage in favor of inline helpers
>     warn if we store register to memory but its not holding
>     result of AND operation
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo_avx2.c | 300 +++++++++++++++++++++++++---
>  1 file changed, 269 insertions(+), 31 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> index c15db28c5ebc..d2e321cc870f 100644
> --- a/net/netfilter/nft_set_pipapo_avx2.c
> +++ b/net/netfilter/nft_set_pipapo_avx2.c
> @@ -26,7 +26,209 @@
>  
>  #define NFT_PIPAPO_LONGS_PER_M256	(XSAVE_YMM_SIZE / BITS_PER_LONG)
>  
> -/* Load from memory into YMM register with non-temporal hint ("stream load"),
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
> +/* ymm15 is used as an always-0-register, see nft_pipapo_avx2_prepare */
> +#define NFT_PIPAPO_AVX2_DEBUG_MAP					\
> +	struct nft_pipapo_debug_regmap __pipapo_debug_regmap = {	\
> +		.tmp = BIT(15),						\
> +	}
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

Nit: kerneldoc style usually aligns argument descriptions, say:

 * @reg:	...
 * @r:		...

> + * @r: Current bitmap of registers for debugging purposes
> + * @line: __LINE__ number filled via AVX2 macro
> + *
> + * Mark reg as holding packet data.
> + * Check reg is unused or had an AND operation performed on it.

...and those should be @reg.

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
> +					     struct nft_pipapo_debug_regmap *r)
> +{
> +#ifdef CONFIG_DEBUG_NET
> +	r->tmp |= BIT(reg);
> +	r->mem &= ~BIT(reg);
> +#endif
> +}
> +
> +/**
> + * nft_pipapo_avx2_load_tmp() - Check and record scratchmap restore

I'm not sure if we should call this "scratchmap restore", it's more
like a generic load to a register (from a bucket, perhaps no need to
specify this).

> + *
> + * @reg: Index of register being written to
> + * @r: Current bitmap of registers for debugging purposes
> + * @line: __LINE__ number filled via AVX2 macro
> + *
> + * Mark reg as holding temporary data.
> + * Check reg is unused or had an AND operation performed on it.

Same as above (@reg).

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

I wonder if it wouldn't be more obvious to open code the bitmap
setting/clearing here, because nft_pipapo_avx2_force_tmp() has a
different purpose in general.

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

registers

> + * Tags @reg1 as containing AND result

Those are @a, @b, @c now (sorry, I missed this during review of v2). By
the way, just as a reminder, NFT_PIPAPO_AVX2_AND() uses @dst, @a, @b,
but maybe you have a good reason to deviate from that.

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
> +	NFT_PIPAPO_WARN(!holds_and_result, reg, r, line, "unused");
> +#endif
> +}
> +
> +/**
> + * nft_pipapo_avx2_debug_map_done() - Check all registers were used
> + * @ret: Return value
> + * @r: Current bitmap of registers for debugging purposes
> + * @reg_hi: The highest ymm register used (0: all are used)
> + * @line: __LINE__ number filled via AVX2 macro
> + *
> + * Raises a warning if a register hasn't been processed (AND'ed).
> + * Prints a notice if it finds an unused register, this hints at
> + * possible optimization.
> + */
> +static inline int nft_pipapo_avx2_debug_map_done(int ret, struct nft_pipapo_debug_regmap *r,
> +						 unsigned int reg_hi,
> +						 unsigned int line)
> +{
> +#ifdef CONFIG_DEBUG_NET
> +	static const unsigned int ymm_regs = 16;
> +	u16 reg_bad, reg_ok;
> +	unsigned int i;
> +
> +	reg_ok = r->and | r->tmp;
> +	reg_bad = r->mem;
> +
> +	reg_hi = reg_hi > 0 ? reg_hi + 1 : ymm_regs;
> +
> +	for (i = 0; i < reg_hi; i++) {
> +		if (BIT(i) & reg_ok)
> +			continue;
> +
> +		if (BIT(i) & reg_bad)
> +			NFT_PIPAPO_WARN(1, i, r, line, "unprocessed");
> +		else
> +			pr_info_once("%s: at %u: reg %u unused\n", __func__, line, i);
> +	}
> +
> +	r->mem = 0;
> +	r->and = 0;
> +	r->tmp = 0;
> +#endif
> +
> +	return ret;
> +}
> +
> +#define NFT_PIPAPO_AVX2_DEBUG_MAP_DONE(ret) \
> +	nft_pipapo_avx2_debug_map_done((ret), &__pipapo_debug_regmap, 0, __LINE__)
> +#define NFT_PIPAPO_AVX2_DEBUG_MAP_DONE2(ret, hr) \
> +	nft_pipapo_avx2_debug_map_done((ret), &__pipapo_debug_regmap, (hr), __LINE__)

Should 'hr' be 'reg_hi' as it is for nft_pipapo_avx2_debug_map_done(),
or 'rmax' or 'max_reg' or something like that?

Otherwise it's a bit difficult (for me at least) to understand how this
macro should be used (without following the whole path). Alternatively,
a comment could also fix that I guess.

> +
> +/* Load from memory into ymm register with non-temporal hint ("stream load"),
>   * that is, don't fetch lines from memory into the cache. This avoids pushing
>   * precious packet data out of the cache hierarchy, and is appropriate when:
>   *
> @@ -36,38 +238,59 @@
>   * - loading the result bitmap from the previous field, as it's never used
>   *   again
>   */
> -#define NFT_PIPAPO_AVX2_LOAD(reg, loc)					\
> +#define __NFT_PIPAPO_AVX2_LOAD(reg, loc)				\
>  	asm volatile("vmovntdqa %0, %%ymm" #reg : : "m" (loc))
>  
> -/* Stream a single lookup table bucket into YMM register given lookup table,
> +#define NFT_PIPAPO_AVX2_LOAD(reg, loc) do {				\
> +	nft_pipapo_avx2_load_tmp(reg,					\
> +				 &__pipapo_debug_regmap, __LINE__);	\
> +	__NFT_PIPAPO_AVX2_LOAD(reg, loc);				\
> +} while (0)
> +
> +/* Stream a single lookup table bucket into ymm register given lookup table,
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
> +			       (v)) * (bsize)]);			\
> +} while (0)
>  
>  /* Bitwise AND: the staple operation of this algorithm */
> -#define NFT_PIPAPO_AVX2_AND(dst, a, b)					\
> -	asm volatile("vpand %ymm" #a ", %ymm" #b ", %ymm" #dst)
> +#define NFT_PIPAPO_AVX2_AND(dst, a, b) do {				\
> +	BUILD_BUG_ON((a) == (b));					\
> +	asm volatile("vpand %ymm" #a ", %ymm" #b ", %ymm" #dst);	\
> +	nft_pipapo_avx2_debug_and(dst, a, b,				\
> +				  &__pipapo_debug_regmap, __LINE__);	\
> +} while (0)
>  
>  /* Jump to label if @reg is zero */
> -#define NFT_PIPAPO_AVX2_NOMATCH_GOTO(reg, label)			\
> -	asm goto("vptest %%ymm" #reg ", %%ymm" #reg ";"	\
> -			  "je %l[" #label "]" : : : : label)
> +#define NFT_PIPAPO_AVX2_NOMATCH_GOTO(reg, label) do {			\
> +	nft_pipapo_avx2_reg_tmp(reg, &__pipapo_debug_regmap, __LINE__);	\
> +	asm goto("vptest %%ymm" #reg ", %%ymm" #reg ";"			\
> +			  "je %l[" #label "]" : : : : label);		\
> +} while (0)
>  
> -/* Store 256 bits from YMM register into memory. Contrary to bucket load
> +/* Store 256 bits from ymm register into memory. Contrary to bucket load
>   * operation, we don't bypass the cache here, as stored matching results
>   * are always used shortly after.
>   */
> -#define NFT_PIPAPO_AVX2_STORE(loc, reg)					\
> -	asm volatile("vmovdqa %%ymm" #reg ", %0" : "=m" (loc))
> +#define NFT_PIPAPO_AVX2_STORE(loc, reg) do {				\
> +	nft_pipapo_avx2_reg_tmp(reg, &__pipapo_debug_regmap, __LINE__);	\
> +	asm volatile("vmovdqa %%ymm" #reg ", %0" : "=m" (loc));		\
> +} while (0)
>  
> -/* Zero out a complete YMM register, @reg */
> +/* Zero out a complete ymm register, @reg */
>  #define NFT_PIPAPO_AVX2_ZERO(reg)					\
>  	asm volatile("vpxor %ymm" #reg ", %ymm" #reg ", %ymm" #reg)
>  
> @@ -219,6 +442,7 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	u8 pg[2] = { pkt[0] >> 4, pkt[0] & 0xf };
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -242,7 +466,7 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
>  
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
> -			return b;
> +			return NFT_PIPAPO_AVX2_DEBUG_MAP_DONE2(b, 4);
>  
>  		if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
> @@ -254,7 +478,7 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
>  		;
>  	}
>  
> -	return ret;
> +	return NFT_PIPAPO_AVX2_DEBUG_MAP_DONE2(ret, 4);
>  }
>  
>  /**
> @@ -282,6 +506,7 @@ static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	u8 pg[4] = { pkt[0] >> 4, pkt[0] & 0xf, pkt[1] >> 4, pkt[1] & 0xf };
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -319,7 +544,7 @@ static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
>  
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
> -			return b;
> +			return NFT_PIPAPO_AVX2_DEBUG_MAP_DONE2(b, 7);
>  
>  		if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
> @@ -331,6 +556,7 @@ static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
>  		;
>  	}
>  
> +	NFT_PIPAPO_AVX2_DEBUG_MAP_DONE2(ret, 7);
>  	return ret;
>  }
>  
> @@ -361,6 +587,7 @@ static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
>  		   };
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -414,7 +641,7 @@ static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
>  
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
> -			return b;
> +			return NFT_PIPAPO_AVX2_DEBUG_MAP_DONE(b);
>  
>  		if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
> @@ -427,7 +654,7 @@ static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
>  		;
>  	}
>  
> -	return ret;
> +	return NFT_PIPAPO_AVX2_DEBUG_MAP_DONE(ret);
>  }
>  
>  /**
> @@ -458,6 +685,7 @@ static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
>  		    };
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -505,7 +733,7 @@ static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
>  
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
> -			return b;
> +			return NFT_PIPAPO_AVX2_DEBUG_MAP_DONE(b);
>  
>  		if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
> @@ -517,7 +745,7 @@ static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
>  		;
>  	}
>  
> -	return ret;
> +	return NFT_PIPAPO_AVX2_DEBUG_MAP_DONE(ret);
>  }
>  
>  /**
> @@ -553,6 +781,7 @@ static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
>  		    };
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -641,7 +870,7 @@ static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
>  
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
> -			return b;
> +			return NFT_PIPAPO_AVX2_DEBUG_MAP_DONE(b);
>  
>  		if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
> @@ -653,7 +882,7 @@ static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
>  		;
>  	}
>  
> -	return ret;
> +	return NFT_PIPAPO_AVX2_DEBUG_MAP_DONE(ret);
>  }
>  
>  /**
> @@ -680,6 +909,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -687,6 +917,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
>  
>  		if (first) {
>  			NFT_PIPAPO_AVX2_BUCKET_LOAD8(2, lt, 0, pkt[0], bsize);
> +			nft_pipapo_avx2_force_tmp(2, &__pipapo_debug_regmap);
>  		} else {
>  			NFT_PIPAPO_AVX2_BUCKET_LOAD8(0, lt, 0, pkt[0], bsize);
>  			NFT_PIPAPO_AVX2_LOAD(1, map[i_ul]);
> @@ -699,7 +930,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
>  
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
> -			return b;
> +			return NFT_PIPAPO_AVX2_DEBUG_MAP_DONE2(b, 2);
>  
>  		if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
> @@ -711,7 +942,10 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
>  		;
>  	}
>  
> -	return ret;
> +	if (first)
> +		return ret;
> +
> +	return NFT_PIPAPO_AVX2_DEBUG_MAP_DONE2(ret, 2);
>  }
>  
>  /**
> @@ -738,6 +972,7 @@ static int nft_pipapo_avx2_lookup_8b_2(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -803,6 +1038,7 @@ static int nft_pipapo_avx2_lookup_8b_4(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -879,6 +1115,7 @@ static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {
> @@ -965,6 +1202,7 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
>  	unsigned long *lt = f->lt, bsize = f->bsize;
> +	NFT_PIPAPO_AVX2_DEBUG_MAP;
>  
>  	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
>  	for (i = offset; i < m256_size; i++, lt += NFT_PIPAPO_LONGS_PER_M256) {

Everything else looks good to me, thanks for all the improvements!

-- 
Stefano

