Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397A525774
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707315357; cv=none; b=YGit3ugfplnQkNksLHw7NLSdWtYM1f94gJMUvRJlsRrIlS6UNVqnIYnOTMrPII0noMCRurFR6WrOuLGBsK2HzjuNPqtR/LYJJrf9SwMrrMISLEYnZkXywq7mwdIxXXCRsDIURy4YQ8mcBv4WCl780M4T6rvLCJghVGfR0gO9kCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707315357; c=relaxed/simple;
	bh=tNiaFccimnosHzb0+Kn10dXZ25MFXgFFHY1QZ0zACVI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZ2TLmMG/ZEjIQVpWOlG5WVJ1JRrrgM3rZG0obuLer0FZbFjftQiHjyGSGLxh+Csh/f1n5ujnoB6YQE7NIhoo/JYnjugDBhcmEDojSA9+NDEpsj25smohsMiOwMiFZ23boQjbelHI8Q69w2iz6yIgZQFN41rSSOGivXrJrzq8p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gA2cFrME; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gA2cFrME"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707315354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJ85fz8XFnXsRA0UBQ180zkMxthzbgvcYj2V6IPp6EI=;
	b=gA2cFrMEgydRlwgYR0DNhaEP99mpLV+s7+TgCj2iuj5/AoFJr2/W1VNw30jp298/KShEtb
	IwWjxTjzL9RsH17wE3yVnaduLEyOvmxdcwSaivqCm9ADoMvCFMw6e2V79b7j479avSr/gx
	Y9PidhPpt15M/XHm14Mpyp3hgosSD4M=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-gJvwkji8PPCbORRdV84Ksw-1; Wed, 07 Feb 2024 09:15:52 -0500
X-MC-Unique: gJvwkji8PPCbORRdV84Ksw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a2fba67ec20so46406766b.3
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Feb 2024 06:15:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707315351; x=1707920151;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FJ85fz8XFnXsRA0UBQ180zkMxthzbgvcYj2V6IPp6EI=;
        b=b0fQbzr1jTN1hwwXyxA7NRCyGwGIESnQOk01+yPVd+fQuE+mksGotAvsiFkCTVcC02
         gQ7S98gE61Ov1e1GafxP3jAnG3cuirYzNJ3Kjg27+zSStQNITE7fYU+vC4Z1aXBNCh/X
         2sAvcbmFWaDy6eSV1vvThHiFGTmNv4/v+Qpx3t1WdYzh02iu8DDXUFlaPhzdxgf8s3WM
         oZ6kbpeia1MnjU4YpqSl5YBrdkVo27tYJUT2SapoqFnNOPIeAYbB5j7QjUhbO2dvcBnf
         tUpfIRb2DARHL6SUrcPkBslrzCIl9J0FwjO5alEPQWMfXzDHYgUGLfjyl1kfm1ySRHCm
         hy3A==
X-Gm-Message-State: AOJu0YxPargemTRjoNcdzWjqKwJNgyoW+owxrG4PojWcwyBls/hhlgyc
	Fa7dToc4Gvaay2vsxUZ7WuO2cLBcoMNyGFjdnwWbUWQowzMOgCP/r3QJ5F/20oReoHZbI0sVmY+
	jPfKOCDhI9mlRgH16PzUL5gnJBodCVhKWdI6ZAtiRtcylJAp/4GHLKuVcP01NagVsvg==
X-Received: by 2002:a17:907:800e:b0:a36:ff9f:4256 with SMTP id ft14-20020a170907800e00b00a36ff9f4256mr3339117ejc.54.1707315350755;
        Wed, 07 Feb 2024 06:15:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHYpMy5mXqRtLt8aBqrA8CRRLGnGN3b24sWyTFrPV+MRqLIgpCBtDxCRptM6grdT/n6CAlGTg==
X-Received: by 2002:a17:907:800e:b0:a36:ff9f:4256 with SMTP id ft14-20020a170907800e00b00a36ff9f4256mr3339095ejc.54.1707315350099;
        Wed, 07 Feb 2024 06:15:50 -0800 (PST)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id ss11-20020a170907c00b00b00a3868b8e78dsm807470ejc.52.2024.02.07.06.15.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Feb 2024 06:15:49 -0800 (PST)
Date: Wed, 7 Feb 2024 15:15:14 +0100
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf 1/3] netfilter: nft_set_pipapo: store index in
 scratch maps
Message-ID: <20240207151514.790c6cf3@elisabeth>
In-Reply-To: <20240206122531.21972-2-fw@strlen.de>
References: <20240206122531.21972-1-fw@strlen.de>
	<20240206122531.21972-2-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  6 Feb 2024 13:23:06 +0100
Florian Westphal <fw@strlen.de> wrote:

> Pipapo needs a scratchpad area to keep state during matching.
> This state can be large and thus cannot reside on stack.
> 
> Each set preallocates percpu areas for this.
> 
> On each match stage, one scratchpad half starts with all-zero and the other
> is inited to all-ones.
> 
> At the end of each stage, the half that starts with all-ones is
> always zero.  Before next field is tested, pointers to the two halves
> are swapped, i.e.  resmap pointer turns into fill pointer and vice versa.
> 
> After the last field has been processed, pipapo stashes the
> index toggle in a percpu variable, with assumption that next packet
> will start with the all-zero half and sets all bits in the other to 1.
> 
> This isn't reliable.

Uh oh. In hindsight, this sounds so obvious now...

> There can be multiple sets and we can't be sure that the upper
> and lower half of all set scratch map is always in sync (lookups
> can be conditional), so one set might have swapped, but other might
> not have been queried.
> 
> Thus we need to keep the index per-set-and-cpu, just like the
> scratchpad.
> 
> Note that this bug fix is incomplete, there is a related issue.
> 
> avx2 and normal implementation might use slightly different areas of the
> map array space due to the avx2 alignment requirements, so
> m->scratch (generic/fallback implementation) and ->scratch_aligned
> (avx) may partially overlap. scratch and scratch_aligned are not distinct
> objects, the latter is just the aligned address of the former.
> 
> After this change, write to scratch_align->map_index may write to
> scratch->map, so this issue becomes more prominent, we can set to 1
> a bit in the supposedly-all-zero area of scratch->map[].
> 
> A followup patch will remove the scratch_aligned and makes generic and
> avx code use the same (aligned) area.
> 
> Its done in a separate change to ease review.
> 
> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Minus one nit (not worth respinning) and one half-doubt below,

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

...I'm still reviewing the rest.

> ---
>  net/netfilter/nft_set_pipapo.c      | 34 +++++++++++++++--------------
>  net/netfilter/nft_set_pipapo.h      | 14 ++++++++++--
>  net/netfilter/nft_set_pipapo_avx2.c | 15 ++++++-------
>  3 files changed, 37 insertions(+), 26 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index efd523496be4..a8aa915f3f0b 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -342,9 +342,6 @@
>  #include "nft_set_pipapo_avx2.h"
>  #include "nft_set_pipapo.h"
>  
> -/* Current working bitmap index, toggled between field matches */
> -static DEFINE_PER_CPU(bool, nft_pipapo_scratch_index);
> -
>  /**
>   * pipapo_refill() - For each set bit, set bits from selected mapping table item
>   * @map:	Bitmap to be scanned for set bits
> @@ -412,6 +409,7 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>  		       const u32 *key, const struct nft_set_ext **ext)
>  {
>  	struct nft_pipapo *priv = nft_set_priv(set);
> +	struct nft_pipapo_scratch *scratch;
>  	unsigned long *res_map, *fill_map;
>  	u8 genmask = nft_genmask_cur(net);
>  	const u8 *rp = (const u8 *)key;
> @@ -422,15 +420,17 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>  
>  	local_bh_disable();
>  
> -	map_index = raw_cpu_read(nft_pipapo_scratch_index);
> -
>  	m = rcu_dereference(priv->match);
>  
>  	if (unlikely(!m || !*raw_cpu_ptr(m->scratch)))
>  		goto out;
>  
> -	res_map  = *raw_cpu_ptr(m->scratch) + (map_index ? m->bsize_max : 0);
> -	fill_map = *raw_cpu_ptr(m->scratch) + (map_index ? 0 : m->bsize_max);
> +	scratch = *raw_cpu_ptr(m->scratch);
> +
> +	map_index = scratch->map_index;
> +
> +	res_map  = scratch->map + (map_index ? m->bsize_max : 0);
> +	fill_map = scratch->map + (map_index ? 0 : m->bsize_max);
>  
>  	memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
>  
> @@ -460,7 +460,7 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>  		b = pipapo_refill(res_map, f->bsize, f->rules, fill_map, f->mt,
>  				  last);
>  		if (b < 0) {
> -			raw_cpu_write(nft_pipapo_scratch_index, map_index);
> +			scratch->map_index = map_index;
>  			local_bh_enable();
>  
>  			return false;
> @@ -477,7 +477,7 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>  			 * current inactive bitmap is clean and can be reused as
>  			 * *next* bitmap (not initial) for the next packet.
>  			 */
> -			raw_cpu_write(nft_pipapo_scratch_index, map_index);
> +			scratch->map_index = map_index;
>  			local_bh_enable();
>  
>  			return true;
> @@ -1121,12 +1121,12 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
>  	int i;
>  
>  	for_each_possible_cpu(i) {
> -		unsigned long *scratch;
> +		struct nft_pipapo_scratch *scratch;
>  #ifdef NFT_PIPAPO_ALIGN
> -		unsigned long *scratch_aligned;
> +		void *scratch_aligned;
>  #endif
> -
> -		scratch = kzalloc_node(bsize_max * sizeof(*scratch) * 2 +
> +		scratch = kzalloc_node(struct_size(scratch, map,
> +						   bsize_max * 2) +
>  				       NFT_PIPAPO_ALIGN_HEADROOM,
>  				       GFP_KERNEL, cpu_to_node(i));
>  		if (!scratch) {
> @@ -1145,7 +1145,9 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
>  		*per_cpu_ptr(clone->scratch, i) = scratch;
>  
>  #ifdef NFT_PIPAPO_ALIGN
> -		scratch_aligned = NFT_PIPAPO_LT_ALIGN(scratch);
> +		scratch_aligned = NFT_PIPAPO_LT_ALIGN(&scratch->map);
> +		/* Need to align ->map start, not start of structure itself */
> +		scratch_aligned -= offsetof(struct nft_pipapo_scratch, map);

This should be fine with the current version of
NFT_PIPAPO_ALIGN_HEADROOM, but it took me quite some pondering, reasoning
below if you feel like double checking.

Let's say ARCH_KMALLOC_MINALIGN is 4, NFT_PIPAPO_LT_ALIGN is 32, we
need 100 bytes for the scratch map (existing implementation), and the
address, x, we get from kzalloc_node() is k + 28, with k aligned to 32
bytes.

Then, we'll ask to allocate 32 - 4 = 28 extra bytes
(NFT_PIPAPO_ALIGN_HEADROOM), that is, 128 bytes, and we'll start using
the area at x + 4 (aligned to 32 bytes), with 124 bytes in front of us.

With this change, and the current NFT_PIPAPO_ALIGN_HEADROOM, we'll
allocate (usually) 4 bytes more, 132 bytes, and we'll start using the
area at x + 4 anyway, with 128 bytes in front of us, and we could have
asked to allocate less, which made me think for a moment that
NFT_PIPAPO_ALIGN_HEADROOM needed to be adjusted too.

However, 'scratch' at k + 28 is not the worst case: k + 32 is. At that
point, we need anyway to ask for 28 extra bytes, because 'map_index'
will force us to start from x + 32.

>  		*per_cpu_ptr(clone->scratch_aligned, i) = scratch_aligned;
>  #endif
>  	}
> @@ -2132,7 +2134,7 @@ static int nft_pipapo_init(const struct nft_set *set,
>  	m->field_count = field_count;
>  	m->bsize_max = 0;
>  
> -	m->scratch = alloc_percpu(unsigned long *);
> +	m->scratch = alloc_percpu(struct nft_pipapo_scratch *);
>  	if (!m->scratch) {
>  		err = -ENOMEM;
>  		goto out_scratch;
> @@ -2141,7 +2143,7 @@ static int nft_pipapo_init(const struct nft_set *set,
>  		*per_cpu_ptr(m->scratch, i) = NULL;
>  
>  #ifdef NFT_PIPAPO_ALIGN
> -	m->scratch_aligned = alloc_percpu(unsigned long *);
> +	m->scratch_aligned = alloc_percpu(struct nft_pipapo_scratch *);
>  	if (!m->scratch_aligned) {
>  		err = -ENOMEM;
>  		goto out_free;
> diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
> index 1040223da5fa..144b186c4caf 100644
> --- a/net/netfilter/nft_set_pipapo.h
> +++ b/net/netfilter/nft_set_pipapo.h
> @@ -130,6 +130,16 @@ struct nft_pipapo_field {
>  	union nft_pipapo_map_bucket *mt;
>  };
>  
> +/**
> + * struct nft_pipapo_scratch - percpu data used for lookup and matching
> + * @map_index	Current working bitmap index, toggled between field matches
> + * @map		store partial matching results during lookup
> + */
> +struct nft_pipapo_scratch {
> +	u8 map_index;
> +	unsigned long map[];
> +};
> +
>  /**
>   * struct nft_pipapo_match - Data used for lookup and matching
>   * @field_count		Amount of fields in set
> @@ -142,9 +152,9 @@ struct nft_pipapo_field {
>  struct nft_pipapo_match {
>  	int field_count;
>  #ifdef NFT_PIPAPO_ALIGN
> -	unsigned long * __percpu *scratch_aligned;
> +	struct nft_pipapo_scratch * __percpu *scratch_aligned;
>  #endif
> -	unsigned long * __percpu *scratch;
> +	struct nft_pipapo_scratch * __percpu *scratch;
>  	size_t bsize_max;
>  	struct rcu_head rcu;
>  	struct nft_pipapo_field f[] __counted_by(field_count);
> diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> index 52e0d026d30a..8cad7b2e759d 100644
> --- a/net/netfilter/nft_set_pipapo_avx2.c
> +++ b/net/netfilter/nft_set_pipapo_avx2.c
> @@ -71,9 +71,6 @@
>  #define NFT_PIPAPO_AVX2_ZERO(reg)					\
>  	asm volatile("vpxor %ymm" #reg ", %ymm" #reg ", %ymm" #reg)
>  
> -/* Current working bitmap index, toggled between field matches */
> -static DEFINE_PER_CPU(bool, nft_pipapo_avx2_scratch_index);
> -
>  /**
>   * nft_pipapo_avx2_prepare() - Prepare before main algorithm body
>   *
> @@ -1120,11 +1117,12 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
>  			    const u32 *key, const struct nft_set_ext **ext)
>  {
>  	struct nft_pipapo *priv = nft_set_priv(set);
> -	unsigned long *res, *fill, *scratch;
> +	struct nft_pipapo_scratch *scratch;
>  	u8 genmask = nft_genmask_cur(net);
>  	const u8 *rp = (const u8 *)key;
>  	struct nft_pipapo_match *m;
>  	struct nft_pipapo_field *f;
> +	unsigned long *res, *fill;
>  	bool map_index;
>  	int i, ret = 0;
>  
> @@ -1146,10 +1144,11 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
>  		kernel_fpu_end();
>  		return false;
>  	}
> -	map_index = raw_cpu_read(nft_pipapo_avx2_scratch_index);
>  
> -	res  = scratch + (map_index ? m->bsize_max : 0);
> -	fill = scratch + (map_index ? 0 : m->bsize_max);
> +	map_index = scratch->map_index;
> +
> +	res = scratch->map + (map_index ? m->bsize_max : 0);
> +	fill = scratch->map + (map_index ? 0 : m->bsize_max);

Nit (if you respin for any reason): the existing version had one extra
space to highlight the symmetry between 'res' and 'fill' in the right
operand. You kept that in nft_pipapo_lookup(), but dropped it here.

>  
>  	/* Starting map doesn't need to be set for this implementation */
>  
> @@ -1221,7 +1220,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
>  
>  out:
>  	if (i % 2)
> -		raw_cpu_write(nft_pipapo_avx2_scratch_index, !map_index);
> +		scratch->map_index = !map_index;
>  	kernel_fpu_end();
>  
>  	return ret >= 0;

-- 
Stefano

