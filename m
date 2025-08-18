Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4427B2475D0
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 16:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755534581; cv=none; b=gbb2gJwPZnOdSOB8rK+Q9EPLXMh7S+AGjjY2ZAHZ6By3AveD0PUvKLEryU3Ue54+O7wZDG+RKwu1b3ozoeTyYlR/2WJmd0c4azS5pUA9LJbCwQitNTk1zVflP4Wew5UYAPQKG9NgDVjgmD5NRZqoU3e2ns4Ie7L/sn70qV/As8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755534581; c=relaxed/simple;
	bh=w5+aRj5FQR+pgrKHbNvW5fE1AbhPS6Sh7GaC4Cl0gPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f2C57yXR2h2BKxj9KaVBOEFheUPBSE2LDLgGKPrJeVhPD7QFdDKB9liXPH0M8R14bvdLbJ8UPnGd595+AcitvAHRBu2uq5wcvN1yXcptFaxvQFNUl1Wb5atjgWwzOq3OoOuSjr/3V3BR0URyxkmoNHBvuqWztgg83WsyKwFrsj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IArpXc/d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IArpXc/d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755534578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6R3CPEPQgXBLhtPg+YZQbVWz/qrSwxfY6OV4cCLJtJ8=;
	b=IArpXc/dJT788VM9WpQHfah3DWGyHSAmh3jZjN1HtIkPkZsrFYnyzUfX7m8cjgtXlXNjnN
	thA3lnvYrV9PYquPZHm1vka/6ufzuTAD9ASPZdYBxlLNiDNH+BNJAalFhRyDFKOgQ36mXk
	isuvoy7Bi9aK2+Hb8Ge/O6ZmqL0qrpc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-vpCD3PxSNcaNv0tvukQJsg-1; Mon, 18 Aug 2025 12:29:36 -0400
X-MC-Unique: vpCD3PxSNcaNv0tvukQJsg-1
X-Mimecast-MFC-AGG-ID: vpCD3PxSNcaNv0tvukQJsg_1755534575
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b05b15eso30437365e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 09:29:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755534575; x=1756139375;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6R3CPEPQgXBLhtPg+YZQbVWz/qrSwxfY6OV4cCLJtJ8=;
        b=OTjNb0TpBJcuw+uyee1KcDhAMjesrKUt3ZoCMMOC3XJzsYpJq8Ssip949cT7Y1CuyD
         qbUOXf5LCpL9jltWOaIko/zBbFSi1BhrJRWclzVf5z2fXktg3sRCWSygxozVz1e+qErz
         2b0wlIby/MQgud3PXUjrFBPTTxQnl9VQVSOwAnirCeriXgVLI0ptGs169iMtzy/I/gtq
         SDCznW273YKCxiVwoCfezOMh5udYg8bVV3Cvtm0cd93xeurFKwN18nlL5vnQuLF83PU+
         6TtO4VIIAhfzB0vfXhVsT6nH2h3R7kScvk4Tyz08QFHrT035I+zlQltgkDyIdR61m9qU
         AX5A==
X-Gm-Message-State: AOJu0Yws779/O1baLv0Lz72O8dEHQVHY6QThqdR28RODOWPm/ydgueVx
	11SMK/GcIMtQhj+HCtmFnr8nLde38V+VyjYy0aT2AViDA5V7Fb1xdMFSK8BMAlNSI9cl/FmXGk/
	kebLigPNXnCZVNy3npdVEjKhl14BAm6zhWQGfP+Y+xr3uqH59mONM3dBiW7RzvJjyR9pDtkQJ7G
	WAbA==
X-Gm-Gg: ASbGnctImcAevxIE+rhqa2Olq6urFQ+Dt7QsxzIkUYEEP/G68MpFCZHYsGa6knNqFdz
	hweSHIymXxXF6qEuqEF3SAJiebfVctte3jgcZ8oSgWvocHKnYHyzNoMc+lRk7nlMmSdOFVaMawL
	6ow9VW3SQXJHYuH15hIgPmFpPBMluCcALPLbWofSptq4HOlwitTUii8mGqUEImsBIp2UNRmMYkS
	lRlaMmqoryUvVnjZ6f8YJdhrbR/qgjLQ2KcvfxingyevonYbCXNuXHEjbjTEudiU8jw11D887+1
	ZV5BIHzYYtSowsD+gQhfZT2E3pWjReWLSl1mttzPw7qT77m4fmQ=
X-Received: by 2002:a05:600c:c4b7:b0:456:1006:5418 with SMTP id 5b1f17b1804b1-45a267445eamr78671985e9.13.1755534574562;
        Mon, 18 Aug 2025 09:29:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEAPJVei2YncoCnxUTfC4q1ADJRXbTpZmLpgn53qIOAoftpdqL9bsCM9LeUDmmX/tGzIO9/og==
X-Received: by 2002:a05:600c:c4b7:b0:456:1006:5418 with SMTP id 5b1f17b1804b1-45a267445eamr78671755e9.13.1755534573968;
        Mon, 18 Aug 2025 09:29:33 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c077789c2asm132848f8f.57.2025.08.18.09.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 09:29:33 -0700 (PDT)
Date: Mon, 18 Aug 2025 18:29:31 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: nft_set_pipapo_avx2: split
 lookup function in two parts
Message-ID: <20250818182931.1dcaf62a@elisabeth>
In-Reply-To: <20250815143702.17272-2-fw@strlen.de>
References: <20250815143702.17272-1-fw@strlen.de>
	<20250815143702.17272-2-fw@strlen.de>
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

On Fri, 15 Aug 2025 16:36:57 +0200
Florian Westphal <fw@strlen.de> wrote:

> Split the main avx2 lookup function into a helper.
> 
> This is a preparation patch: followup change will use the new helper
> from the insertion path if possible.  This greatly improves insertion
> performance when avx2 is supported.

Ah, nice. This was on my to-do list at some point, but then I thought
insertion time didn't matter as much, now clearly disproved by the
numbers from 2/2.

One actual concern and a few nits:

> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo_avx2.c | 127 +++++++++++++++++-----------
>  1 file changed, 76 insertions(+), 51 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> index 2f090e253caf..d512877cc211 100644
> --- a/net/netfilter/nft_set_pipapo_avx2.c
> +++ b/net/netfilter/nft_set_pipapo_avx2.c
> @@ -1133,58 +1133,35 @@ static inline void pipapo_resmap_init_avx2(const struct nft_pipapo_match *m, uns
>  }
>  
>  /**
> - * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
> - * @net:	Network namespace
> - * @set:	nftables API set representation
> - * @key:	nftables API element representation containing key data
> + * pipapo_get_avx2() - Lookup function for AVX2 implementation
> + * @m:		storage containing the set elements
> + * @data:	Key data to be matched against existing elements
> + * @genmask:	If set, check that element is active in given genmask
> + * @tstamp:	timestamp to check for expired elements

Nits: Storage, Timestamp (or all lowercase, for consistency with the
other ones).

>   *
>   * For more details, see DOC: Theory of Operation in nft_set_pipapo.c.
>   *
>   * This implementation exploits the repetitive characteristic of the algorithm
>   * to provide a fast, vectorised version using the AVX2 SIMD instruction set.
>   *
> - * Return: true on match, false otherwise.
> + * The caller MUST check that the fpu is usable.

FPU

> + * This function must be called with BH disabled.
> + *
> + * Return: pointer to &struct nft_pipapo_elem on match, NULL otherwise.
>   */
> -const struct nft_set_ext *
> -nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
> -		       const u32 *key)
> +static struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
> +					       const u8 *data, u8 genmask,
> +					       u64 tstamp)
>  {
> -	struct nft_pipapo *priv = nft_set_priv(set);
> -	const struct nft_set_ext *ext = NULL;
>  	struct nft_pipapo_scratch *scratch;
> -	u8 genmask = nft_genmask_cur(net);
> -	const struct nft_pipapo_match *m;
>  	const struct nft_pipapo_field *f;
> -	const u8 *rp = (const u8 *)key;
>  	unsigned long *res, *fill;
>  	bool map_index;
>  	int i;
>  
> -	local_bh_disable();
> -
> -	if (unlikely(!irq_fpu_usable())) {
> -		ext = nft_pipapo_lookup(net, set, key);
> -
> -		local_bh_enable();
> -		return ext;
> -	}
> -
> -	m = rcu_dereference(priv->match);
> -
> -	/* This also protects access to all data related to scratch maps.
> -	 *
> -	 * Note that we don't need a valid MXCSR state for any of the
> -	 * operations we use here, so pass 0 as mask and spare a LDMXCSR
> -	 * instruction.
> -	 */
> -	kernel_fpu_begin_mask(0);
> -
>  	scratch = *raw_cpu_ptr(m->scratch);
> -	if (unlikely(!scratch)) {
> -		kernel_fpu_end();
> -		local_bh_enable();
> +	if (unlikely(!scratch))
>  		return NULL;
> -	}
>  
>  	map_index = scratch->map_index;
>  
> @@ -1202,7 +1179,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
>  
>  #define NFT_SET_PIPAPO_AVX2_LOOKUP(b, n)				\
>  		(ret = nft_pipapo_avx2_lookup_##b##b_##n(res, fill, f,	\
> -							 ret, rp,	\
> +							 ret, data,	\
>  							 first, last))
>  
>  		if (likely(f->bb == 8)) {
> @@ -1218,7 +1195,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
>  				NFT_SET_PIPAPO_AVX2_LOOKUP(8, 16);
>  			} else {
>  				ret = nft_pipapo_avx2_lookup_slow(m, res, fill, f,
> -								  ret, rp,
> +								  ret, data,
>  								  first, last);
>  			}
>  		} else {
> @@ -1234,7 +1211,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
>  				NFT_SET_PIPAPO_AVX2_LOOKUP(4, 32);
>  			} else {
>  				ret = nft_pipapo_avx2_lookup_slow(m, res, fill, f,
> -								  ret, rp,
> +								  ret, data,
>  								  first, last);
>  			}
>  		}
> @@ -1242,29 +1219,77 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
>  
>  #undef NFT_SET_PIPAPO_AVX2_LOOKUP
>  
> -		if (ret < 0)
> -			goto out;
> +		if (ret < 0) {
> +			scratch->map_index = map_index;
> +			return NULL;
> +		}
>  
>  		if (last) {
> -			const struct nft_set_ext *e = &f->mt[ret].e->ext;
> +			struct nft_pipapo_elem *e;
>  
> -			if (unlikely(nft_set_elem_expired(e) ||
> -				     !nft_set_elem_active(e, genmask)))
> +			e = f->mt[ret].e;
> +			if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||

Here's the actual concern, even if I haven't tested this: I guess you now
pass the timestamp to this function instead of getting it with each
nft_set_elem_expired() call for either correctness (it should be done at
the beginning of the insertion?) or as an optimisation (if BITS_PER_LONG < 64
the overhead isn't necessarily trivial).

As long as machines supporting AVX2 are concerned, we can assume in general
that BITS_PER_LONG >= 64 (even though I'm not sure about x32).

But with 2/2, you need to call get_jiffies_64() as a result, from non-AVX2
code, even for sets without a timeout (without NFT_SET_EXT_TIMEOUT
extension).

Does that risk causing a regression on non-AVX2? If it's for correctness,
I think we shouldn't care, but if it's done as an optimisation, perhaps
it's not a universal one.

> +				     !nft_set_elem_active(&e->ext, genmask)))
>  				goto next_match;
>  
> -			ext = e;
> -			goto out;
> +			scratch->map_index = map_index;
> +			return e;
>  		}
>  
> +		map_index = !map_index;
>  		swap(res, fill);
> -		rp += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
> +		data += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
> +	}
> +
> +	return NULL;
> +}
> +
> +/**
> + * nft_pipapo_avx2_lookup() - Dataplane frontend for AVX2 implementation
> + * @net:	Network namespace
> + * @set:	nftables API set representation
> + * @key:	nftables API element representation containing key data
> + *
> + * This function is called from the data path.  It will search for
> + * an element matching the given key in the current active copy using
> + * the avx2 routines if the fpu is usable or fall back to the generic

AVX2, FPU

> + * implementation of the algorithm otherwise.
> + *
> + * Return: ntables API extension pointer or NULL if no match.

nftables

> + */
> +const struct nft_set_ext *
> +nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
> +		       const u32 *key)
> +{
> +	struct nft_pipapo *priv = nft_set_priv(set);
> +	u8 genmask = nft_genmask_cur(net);
> +	const struct nft_pipapo_match *m;
> +	const u8 *rp = (const u8 *)key;
> +	const struct nft_pipapo_elem *e;
> +
> +	local_bh_disable();
> +
> +	if (unlikely(!irq_fpu_usable())) {
> +		const struct nft_set_ext *ext;
> +
> +		ext = nft_pipapo_lookup(net, set, key);
> +
> +		local_bh_enable();
> +		return ext;
>  	}
>  
> -out:
> -	if (i % 2)
> -		scratch->map_index = !map_index;

I originally did it like this to avoid an assignment in the fast path,
but the amount of time I just spent figuring out why I did this shows
that perhaps setting map_index = !map_index as you do now is worth it.

> +	m = rcu_dereference(priv->match);
> +
> +	/* This also protects access to all data related to scratch maps.
> +	 *
> +	 * Note that we don't need a valid MXCSR state for any of the
> +	 * operations we use here, so pass 0 as mask and spare a LDMXCSR
> +	 * instruction.
> +	 */
> +	kernel_fpu_begin_mask(0);

I would leave an empty line here so that it's clear what "This" in the
comment refers to (it always sounds a bit confusing to me that
kernel_fpu_begin_mask() actually does that, hence the comment).

> +	e = pipapo_get_avx2(m, rp, genmask, get_jiffies_64());
>  	kernel_fpu_end();
>  	local_bh_enable();
>  
> -	return ext;
> +	return e ? &e->ext : NULL;
>  }

-- 
Stefano

