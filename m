Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869FF2206B7
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 06:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751954967; cv=none; b=q5ERh8Cqj7qV1HUy1/rb03AHW7sgoTbiBpDpQj6I29wmhYMXAKkO9gfvhJX/m4qM+RbyX7lM4d1hwHTQtmSA3tOI7UPHRWNTSIp8Mw9UqOYSsZIIVR+2W5cWM6zXcpkXRb3vAPlyUyDa8E/FJqmd/Z/a9tFcgHubXxiKOkeDcRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751954967; c=relaxed/simple;
	bh=U9S4Vdp0ozQluCArk2bMoOn7wX6dAzxNGIVVvXn1VWI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WsjDnK1Gf1kg8HZZJw4Hrf2sy+1/vcwlM1YCDZ0JD88qq9gO+EtJEU69w4WcMT+6lM2++FbAQZtnELVajcBHtKWh9QWTxV3WKvVzNrpb55J8uro2ViKon0c9P67TGG2pgSctww+sonv4w2GkplOyA00kZyQLSXqMAvvX5q1iwMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dDKKLhdM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dDKKLhdM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751954964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KOaMaRbJZJ8W1vpyf/5zsEQwSwqbnJv1qFzmKrSLNAw=;
	b=dDKKLhdMHKwkvkhbEdgECufNbXCbMErQzt5wRpGLjvwV/8w7LrIaQF0cIOYPf7fFL90mkY
	O4UORoAt0sHDrz0Yph3TaP2PFHuRszROFQUAcLwvBoorhAUpBl/boRIETOOYTATtmOcghr
	nGD2Dbai42eRZV5xxub14QFyJsNEpEY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-m84nRxzlMEq8vqUuefxjGg-1; Tue, 08 Jul 2025 02:09:22 -0400
X-MC-Unique: m84nRxzlMEq8vqUuefxjGg-1
X-Mimecast-MFC-AGG-ID: m84nRxzlMEq8vqUuefxjGg_1751954961
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4eec544c6so1947418f8f.0
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Jul 2025 23:09:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751954960; x=1752559760;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KOaMaRbJZJ8W1vpyf/5zsEQwSwqbnJv1qFzmKrSLNAw=;
        b=avPLUtoQYDkOzuAtGLtuViCFqL0Vk/8EryUKo8eeAPbIoJyLgreF4y2rUv/fT6zQoh
         9My2D4qvGEvbiugvZ86fsaPo2j0NXDEycXvdruBrEBTvRPL+xSdzfnIdWieQ8Ro/ENUY
         M9NOLiVG0dkyBLTVjYP5vtndrz3DIcsWxvBCRyOf+d1ATlq6+GpoodjPQ0UvIwyvTNND
         gj2lFCBu+zEHlH2uuAhuVAMcW8Qx4I3pqqDe+vh5Ip2/ESv9qwfkI4kIFEBU1UO01BFj
         mwbwYAHkx74YKmY4+1Q8QPJZ8qbetB8Wo45qUXv6p712nMft6eaokWTmLjWXzXMx6iVx
         ZgKA==
X-Gm-Message-State: AOJu0YxZgK9hYqi0HIuJW0xL750o7ZsEUB5ObAqi4XRJ8k7AHSdWsRi5
	stZmspiZrAVcgyNoT3xatCFWTRTx+yAk5gCBfZuC2iKwwpc2W0uIJ/6gsxTFzxDiVGlDiDrWGsm
	3uYgZm/Yx2a75vdxy9QZnaYIL2ssEk3a7gVhHwfhE43x7OqJyy6MxOughCLHidkpcv7IUkGoi8L
	NyXQ==
X-Gm-Gg: ASbGnctiIFI+bJs73uxyWWz10UZx4rsFcx0GqD/nxLPptiShT3++Z7OeIPaHswM3r3P
	3qzHWgC71BkRRAgjQ8qk+XAqmC104otp/4bawRG+GP7EO9sIlYEXOPw4B1JXoXUDBsWfCqwRY6A
	/7j3JTt75NfwC78oM1E7oSI3ECO0rCeTvTHWFvPitOBNhkAWdD6cEKjUhEN9nJnMVchB3nBNkAu
	KveM4PICOiYCTPYL8nmbRKQr05xag/M4Gy9h5JTOKdwaT8/n46c0G2P4Wd2bmRvbyOflZK+eCHu
	XqlrEGZkxxsqvNwRiLr3A6wCnQ77bWwXo+G5lAdRVC8baaAetC8=
X-Received: by 2002:a05:6000:2501:b0:3a4:dd02:f724 with SMTP id ffacd0b85a97d-3b5ddef3b91mr1105524f8f.43.1751954960015;
        Mon, 07 Jul 2025 23:09:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH63l3KlVKQ9eddWnbwGUDRu9B2LuNPmIp4qOgEURUp/qaMUjcXpee1dPjZCTYjMqOvGJMaPg==
X-Received: by 2002:a05:6000:2501:b0:3a4:dd02:f724 with SMTP id ffacd0b85a97d-3b5ddef3b91mr1105481f8f.43.1751954959282;
        Mon, 07 Jul 2025 23:09:19 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47225a720sm12076268f8f.77.2025.07.07.23.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 23:09:18 -0700 (PDT)
Date: Tue, 8 Jul 2025 08:09:17 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 4/5] netfilter: nft_set_pipapo: merge
 pipapo_get/lookup
Message-ID: <20250708080917.41f4b693@elisabeth>
In-Reply-To: <20250701185245.31370-5-fw@strlen.de>
References: <20250701185245.31370-1-fw@strlen.de>
	<20250701185245.31370-5-fw@strlen.de>
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

On Tue,  1 Jul 2025 20:52:41 +0200
Florian Westphal <fw@strlen.de> wrote:

> The matching algorithm has implemented thrice:
> 1. data path lookup, generic version
> 2. data path lookup, avx2 version
> 3. control plane lookup
> 
> Merge 1 and 3 by refactoring pipapo_get as a common helper, then make
> nft_pipapo_lookup and nft_pipapo_get both call the common helper.
> 
> Aside from the code savings this has the benefit that we no longer allocate
> temporary scratch maps for each control plane get and insertion operation.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Some nits below, but other than those:

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

> ---
>  net/netfilter/nft_set_pipapo.c | 189 ++++++++++-----------------------
>  1 file changed, 59 insertions(+), 130 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 36a4de11995b..ebd142d8d4d4 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -397,35 +397,37 @@ int pipapo_refill(unsigned long *map, unsigned int len, unsigned int rules,
>  }
>  
>  /**
> - * nft_pipapo_lookup() - Lookup function
> - * @net:	Network namespace
> - * @set:	nftables API set representation
> - * @key:	nftables API element representation containing key data
> - * @ext:	nftables API extension pointer, filled with matching reference
> + * pipapo_get() - Get matching element reference given key data
> + * @m:		storage containing the set elements
> + * @data:	Key data to be matched against existing elements
> + * @genmask:	If set, check that element is active in given genmask
> + * @tstamp:	timestamp to check for expired elements
>   *
>   * For more details, see DOC: Theory of Operation.
>   *
> - * Return: true on match, false otherwise.
> + * This is the main lookup function.  It matches key data either against
> + * the working match set or the uncomitted copy, depending on what the
> + * caller passed to us.

Here and below: uncommitted.

I think clearer: "It matches key data against either ... or ...".

> + * nft_pipapo_get (lookup from userspace/control plane) and nft_pipapo_lookup
> + * (datapath lookup) pass the active copy.
> + * The insertion path will pass the uncomitted working copy.
> + *
> + * Return: pointer to &struct nft_pipapo_elem on match, NULL otherwise.
>   */
> -const struct nft_set_ext *
> -nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
> -		  const u32 *key)
> +static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
> +					  const u8 *data, u8 genmask,
> +					  u64 tstamp)
>  {
> -	struct nft_pipapo *priv = nft_set_priv(set);
>  	struct nft_pipapo_scratch *scratch;
>  	unsigned long *res_map, *fill_map;
> -	u8 genmask = nft_genmask_cur(net);
> -	const struct nft_pipapo_match *m;
>  	const struct nft_pipapo_field *f;
> -	const u8 *rp = (const u8 *)key;
>  	bool map_index;
>  	int i;
>  
>  	local_bh_disable();
>  
> -	m = rcu_dereference(priv->match);
> -
> -	if (unlikely(!m || !*raw_cpu_ptr(m->scratch)))
> +	/* XXX: fix this, prealloc and remove this check */
> +	if (unlikely(!raw_cpu_ptr(m->scratch)))

The check should be cheap, but sure, why not. I'm just asking if you
accidentally left the XXX: here in this version or if you meant it as a
TODO: for the future.

>  		goto out;
>  
>  	scratch = *raw_cpu_ptr(m->scratch);
> @@ -445,12 +447,12 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>  		 * packet bytes value, then AND bucket value
>  		 */
>  		if (likely(f->bb == 8))
> -			pipapo_and_field_buckets_8bit(f, res_map, rp);
> +			pipapo_and_field_buckets_8bit(f, res_map, data);
>  		else
> -			pipapo_and_field_buckets_4bit(f, res_map, rp);
> +			pipapo_and_field_buckets_4bit(f, res_map, data);
>  		NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4;
>  
> -		rp += f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
> +		data += f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
>  
>  		/* Now populate the bitmap for the next field, unless this is
>  		 * the last field, in which case return the matched 'ext'
> @@ -470,11 +472,11 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>  		}
>  
>  		if (last) {
> -			const struct nft_set_ext *ext;
> +			struct nft_pipapo_elem *e;
>  
> -			ext = &f->mt[b].e->ext;
> -			if (unlikely(nft_set_elem_expired(ext) ||
> -				     !nft_set_elem_active(ext, genmask)))
> +			e = f->mt[b].e;
> +			if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||
> +				     !nft_set_elem_active(&e->ext, genmask)))
>  				goto next_match;
>  
>  			/* Last field: we're just returning the key without
> @@ -484,8 +486,7 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>  			 */
>  			scratch->map_index = map_index;
>  			local_bh_enable();
> -
> -			return ext;
> +			return e;
>  		}
>  
>  		/* Swap bitmap indices: res_map is the initial bitmap for the
> @@ -495,7 +496,7 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>  		map_index = !map_index;
>  		swap(res_map, fill_map);
>  
> -		rp += NFT_PIPAPO_GROUPS_PADDING(f);
> +		data += NFT_PIPAPO_GROUPS_PADDING(f);
>  	}
>  
>  out:
> @@ -504,99 +505,29 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>  }
>  
>  /**
> - * pipapo_get() - Get matching element reference given key data
> - * @m:		storage containing active/existing elements
> - * @data:	Key data to be matched against existing elements
> - * @genmask:	If set, check that element is active in given genmask
> - * @tstamp:	timestamp to check for expired elements
> - * @gfp:	the type of memory to allocate (see kmalloc).
> + * nft_pipapo_lookup() - Dataplane fronted for main lookup function
> + * @net:	Network namespace
> + * @set:	nftables API set representation
> + * @key:	pointer to nft registers containing key data
>   *
> - * This is essentially the same as the lookup function, except that it matches
> - * key data against the uncommitted copy and doesn't use preallocated maps for
> - * bitmap results.
> + * This function is called from the data path.  It will search for
> + * an element matching the given key in the current active copy.
>   *
> - * Return: pointer to &struct nft_pipapo_elem on match, error pointer otherwise.
> + * Return: ntables API extension pointer or NULL if no match.
>   */
> -static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
> -					  const u8 *data, u8 genmask,
> -					  u64 tstamp, gfp_t gfp)
> +const struct nft_set_ext *
> +nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
> +		  const u32 *key)
>  {
> -	struct nft_pipapo_elem *ret = ERR_PTR(-ENOENT);
> -	unsigned long *res_map, *fill_map = NULL;
> -	const struct nft_pipapo_field *f;
> -	int i;
> -
> -	if (m->bsize_max == 0)
> -		return ret;
> -
> -	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), gfp);
> -	if (!res_map) {
> -		ret = ERR_PTR(-ENOMEM);
> -		goto out;
> -	}
> -
> -	fill_map = kcalloc(m->bsize_max, sizeof(*res_map), gfp);
> -	if (!fill_map) {
> -		ret = ERR_PTR(-ENOMEM);
> -		goto out;
> -	}
> -
> -	pipapo_resmap_init(m, res_map);
> -
> -	nft_pipapo_for_each_field(f, i, m) {
> -		bool last = i == m->field_count - 1;
> -		int b;
> -
> -		/* For each bit group: select lookup table bucket depending on
> -		 * packet bytes value, then AND bucket value
> -		 */
> -		if (f->bb == 8)
> -			pipapo_and_field_buckets_8bit(f, res_map, data);
> -		else if (f->bb == 4)
> -			pipapo_and_field_buckets_4bit(f, res_map, data);
> -		else
> -			BUG();
> -
> -		data += f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
> -
> -		/* Now populate the bitmap for the next field, unless this is
> -		 * the last field, in which case return the matched 'ext'
> -		 * pointer if any.
> -		 *
> -		 * Now res_map contains the matching bitmap, and fill_map is the
> -		 * bitmap for the next field.
> -		 */
> -next_match:
> -		b = pipapo_refill(res_map, f->bsize, f->rules, fill_map, f->mt,
> -				  last);
> -		if (b < 0)
> -			goto out;
> -
> -		if (last) {
> -			if (__nft_set_elem_expired(&f->mt[b].e->ext, tstamp))
> -				goto next_match;
> -			if ((genmask &&
> -			     !nft_set_elem_active(&f->mt[b].e->ext, genmask)))
> -				goto next_match;
> -
> -			ret = f->mt[b].e;
> -			goto out;
> -		}
> -
> -		data += NFT_PIPAPO_GROUPS_PADDING(f);
> +	struct nft_pipapo *priv = nft_set_priv(set);
> +	u8 genmask = nft_genmask_cur(net);
> +	const struct nft_pipapo_match *m;
> +	const struct nft_pipapo_elem *e;
>  
> -		/* Swap bitmap indices: fill_map will be the initial bitmap for
> -		 * the next field (i.e. the new res_map), and res_map is
> -		 * guaranteed to be all-zeroes at this point, ready to be filled
> -		 * according to the next mapping table.
> -		 */
> -		swap(res_map, fill_map);
> -	}
> +	m = rcu_dereference(priv->match);
> +	e = pipapo_get(m, (const u8 *)key, genmask, get_jiffies_64());
>  
> -out:
> -	kfree(fill_map);
> -	kfree(res_map);
> -	return ret;
> +	return e ? &e->ext : NULL;
>  }
>  
>  /**
> @@ -605,6 +536,11 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
>   * @set:	nftables API set representation
>   * @elem:	nftables API element representation containing key data
>   * @flags:	Unused
> + *
> + * This function is called from the control plane path under
> + * RCU read lock.
> + *
> + * Return: set element private pointer; ERR_PTR if no match.

Conceptually, we rather return -ENOENT, I'd mention that instead.

>   */
>  static struct nft_elem_priv *
>  nft_pipapo_get(const struct net *net, const struct nft_set *set,
> @@ -615,10 +551,9 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
>  	struct nft_pipapo_elem *e;
>  
>  	e = pipapo_get(m, (const u8 *)elem->key.val.data,
> -		       nft_genmask_cur(net), get_jiffies_64(),
> -		       GFP_ATOMIC);
> -	if (IS_ERR(e))
> -		return ERR_CAST(e);
> +		       nft_genmask_cur(net), get_jiffies_64());
> +	if (!e)
> +		return ERR_PTR(-ENOENT);
>  
>  	return &e->priv;
>  }
> @@ -1344,8 +1279,8 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
>  	else
>  		end = start;
>  
> -	dup = pipapo_get(m, start, genmask, tstamp, GFP_KERNEL);
> -	if (!IS_ERR(dup)) {
> +	dup = pipapo_get(m, start, genmask, tstamp);
> +	if (dup) {
>  		/* Check if we already have the same exact entry */
>  		const struct nft_data *dup_key, *dup_end;
>  
> @@ -1364,15 +1299,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
>  		return -ENOTEMPTY;
>  	}
>  
> -	if (PTR_ERR(dup) == -ENOENT) {
> -		/* Look for partially overlapping entries */
> -		dup = pipapo_get(m, end, nft_genmask_next(net), tstamp,
> -				 GFP_KERNEL);
> -	}
> -
> -	if (PTR_ERR(dup) != -ENOENT) {
> -		if (IS_ERR(dup))
> -			return PTR_ERR(dup);
> +	/* Look for partially overlapping entries */
> +	dup = pipapo_get(m, end, nft_genmask_next(net), tstamp);
> +	if (dup) {
>  		*elem_priv = &dup->priv;
>  		return -ENOTEMPTY;
>  	}
> @@ -1914,8 +1843,8 @@ nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
>  		return NULL;
>  
>  	e = pipapo_get(m, (const u8 *)elem->key.val.data,
> -		       nft_genmask_next(net), nft_net_tstamp(net), GFP_KERNEL);
> -	if (IS_ERR(e))
> +		       nft_genmask_next(net), nft_net_tstamp(net));
> +	if (!e)
>  		return NULL;
>  
>  	nft_set_elem_change_active(net, set, &e->ext);

-- 
Stefano

