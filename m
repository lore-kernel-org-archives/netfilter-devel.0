Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA0032C84
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 13:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707830315; cv=none; b=rVSmA2ztx8hV2vzZRCHDIrE03Uc5mbLnX6/q6nhNYR+hhPbqncfEv7if1u/CahZ11DSBPeoS1AjHMMTdL3ERQalMJYOzbWxFjncRzAXALzOXQpfaJLupisIBtHg93tlrj5bj27YcM3H/Xy0zcUDRrkNKI8Hu80ynvKTketfZC1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707830315; c=relaxed/simple;
	bh=I8wfBiLDhYagnjLBjFG7/bPOk28N6fvsRtE4NczwHKE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rRHR7E10HcPS6T5CAfa4hIiQsNxGaq7KJYEt8P2itoP3+vdW6qXV/2XJSWYCp8N7V+6BUmVUae5mWxCF4I38Mb3cUyLNrSPEexrN6eGQJDYqsgZOcSyz/do0ifOM8fQXdfK4/vOMNgmlWta+UHTSnwFvoWYIvH2aqBuzhYGa7jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PWUleAQY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PWUleAQY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707830312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wn+xteQf2ZJWhl61SOQRUx/UM6A1oFaz559FwBuLkXQ=;
	b=PWUleAQYeAeOffSbrLFQ8auvBgjbNXaqnaKnMmcoGQd3Lv94ZpDZgp0B/xfs7a+yHuihZq
	ATR7iE4yWGkj6yLHrvQf4/Epf+/NHb6NojvHX7ooKbQaBcChb3847qqcQijqjPrfGJhxnf
	Q/RbLI4xcAkFVloEi2xm8F3qQkPSYLo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-x0CZPghQMiudXbaccPsh9Q-1; Tue, 13 Feb 2024 08:18:30 -0500
X-MC-Unique: x0CZPghQMiudXbaccPsh9Q-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a2f1d0c3389so280269166b.0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 05:18:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707830309; x=1708435109;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wn+xteQf2ZJWhl61SOQRUx/UM6A1oFaz559FwBuLkXQ=;
        b=WK0jRW2TiMQfA5aG4VBz47WVnCQRwQB+8b00PdLB+VjjCoBUqEW+eKiJsg7SGxDZbT
         HgdlXxFx9gRdcfwcBtkYn6MzTPG4W+Zms4dgU34uUZl6dnkjfsFR3zHABNoxxBJKejgk
         MlaCwQL7uLkKHZuziB7JhSk3j3dQRTra4cBMLJ120wJCXRWbRzGZLg1BA6HexGSTy0l/
         GKCJBIUC3U1pExb3tJyX6QM1075pJQay9YuchZ4ls0m4jjOoYt/It5oimdq/BizVs+kk
         9kpus7dfZKOoBHwBMI0TeiQha7NQ0PROv2OtItQhIqQfPr8In6y203uKlss1ovir3JjS
         pZWQ==
X-Gm-Message-State: AOJu0Yxl+u5qeFFmKOSa+4IsQyzWv0i2OhZUkhbGm3z7qeqhg0XgQmxl
	Qvz6MBUcTia4NuSMr06qLORZc5za2OtzZWthDW951m7UHydblK1RqfG4XK6xuXEFqp0fvgC822q
	G3wnD8MDHW07R9r6NykdTpNk9h/62z3JGeF2EVe4xPi+e2Sd3ZiYAJotq2YeUtpI+1nGTXzN1R6
	J2
X-Received: by 2002:a17:906:b78d:b0:a3c:bc86:c419 with SMTP id dt13-20020a170906b78d00b00a3cbc86c419mr3238981ejb.38.1707830308772;
        Tue, 13 Feb 2024 05:18:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFZHi/JtMQM1ntzFGQCrkqp0XM3bu2DC4bqVByB4AW8wB8ryQ7RvSuOd6zE+VlZTR7UYzdsUA==
X-Received: by 2002:a17:906:b78d:b0:a3c:bc86:c419 with SMTP id dt13-20020a170906b78d00b00a3cbc86c419mr3238967ejb.38.1707830308395;
        Tue, 13 Feb 2024 05:18:28 -0800 (PST)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id u15-20020a170906408f00b00a3bc368ca7esm1288081ejj.53.2024.02.13.05.18.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Feb 2024 05:18:27 -0800 (PST)
Date: Tue, 13 Feb 2024 14:17:53 +0100
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 4/4] netfilter: nft_set_pipapo: speed up bulk
 element insertions
Message-ID: <20240213141753.17ef27a6@elisabeth>
In-Reply-To: <20240212100202.10116-5-fw@strlen.de>
References: <20240212100202.10116-1-fw@strlen.de>
	<20240212100202.10116-5-fw@strlen.de>
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

On Mon, 12 Feb 2024 11:01:53 +0100
Florian Westphal <fw@strlen.de> wrote:

> Insertions into the set are slow when we try to add many elements.
> For 800k elements I get:
> 
> time nft -f pipapo_800k
> real    19m34.849s
> user    0m2.390s
> sys     19m12.828s

Whoops.

> perf stats:
>  --95.39%--nft_pipapo_insert
>      |--76.60%--pipapo_insert
>      |           --76.37%--pipapo_resize
>      |                     |--72.87%--memcpy_orig
>      |                     |--1.88%--__free_pages_ok
>      |                     |          --0.89%--free_tail_page_prepare
>      |                      --1.38%--kvmalloc_node
>      ..
>      --18.56%--pipapo_get.isra.0
>      |--13.91%--__bitmap_and
>      |--3.01%--pipapo_refill
>      |--0.81%--__kmalloc
>      |           --0.74%--__kmalloc_large_node
>      |                      --0.66%--__alloc_pages
>      ..
>      --0.52%--memset_orig
> 
> So lots of time is spent in copying exising elements to make space for
> the next one.
> 
> Instead of allocating to the exact size of the new rule count, allocate
> extra slack to reduce alloc/copy/free overhead.
> 
> After:
> time nft -f pipapo_800k
> real    1m54.110s
> user    0m2.515s
> sys     1m51.377s

That's quite an improvement, thanks for fixing this!

> 
>  --80.46%--nft_pipapo_insert
>      |--73.45%--pipapo_get.isra.0
>      |--57.63%--__bitmap_and
>      |          |--8.52%--pipapo_refill
>      |--3.45%--__kmalloc
>      |           --3.05%--__kmalloc_large_node
>      |                      --2.58%--__alloc_pages
>      --2.59%--memset_orig
>      |--6.51%--pipapo_insert
>             --5.96%--pipapo_resize
>                      |--3.63%--memcpy_orig
>                      --2.13%--kvmalloc_node
> 
> The new @rules_alloc fills a hole, so struct size doesn't go up.
> Also make it so rule removal doesn't shrink unless the free/extra space
> exceeds two pages.  This should be safe as well:
> 
> When a rule gets removed, the attempt to lower the allocated size is
> already allowed to fail.
> 
> Exception: do exact allocations as long as set is very small (less
> than one page needed).
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo.c | 80 +++++++++++++++++++++++++++-------
>  net/netfilter/nft_set_pipapo.h |  2 +
>  2 files changed, 67 insertions(+), 15 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index a0ddf24a8052..25cdf64a3139 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -622,6 +622,62 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
>  	return &e->priv;
>  }
>  
> +static int pipapo_realloc_mt(struct nft_pipapo_field *f, unsigned int old_rules, unsigned int rules)

Nit:

/* pipapo_realloc_mt() - Reallocate mapping table if needed upon resize
 * @f:		Field containing mapping table
 * @old_rules:	Amount of existing mapped rules
 * @rules:	Amount of new rules to map
 *
 * Return: 0 on success, negative error code on failure.
 */
static int pipapo_realloc_mt(struct nft_pipapo_field *f,
			     unsigned int old_rules, unsigned int rules)

> +{
> +	union nft_pipapo_map_bucket *new_mt = NULL, *old_mt = f->mt;
> +	unsigned int extra = 4096 / sizeof(*new_mt);

Shouldn't we actually use PAGE_SIZE? I think the one-page limit is
somewhat arbitrary but makes sense, so it should be 64k on e.g.
CONFIG_PPC_64K_PAGES=y.

> +	unsigned int rules_alloc = rules;
> +
> +	might_sleep();
> +
> +	BUILD_BUG_ON(extra < 32);

I'm not entirely sure why this would be a problem. I mean, 'extra' at
this point is the number of extra rules, not the amount of extra
bytes, right?

> +
> +	if (unlikely(rules == 0))
> +		goto out_free;
> +
> +	/* growing and enough space left, no action needed */
> +	if (rules > old_rules && f->rules_alloc > rules)
> +		return 0;
> +
> +	/* downsize and extra slack has not grown too large */
> +	if (rules < old_rules) {
> +		unsigned int remove = f->rules_alloc - rules;
> +
> +		if (remove < (2u * extra))
> +			return 0;
> +	}
> +
> +	/* small sets get precise count, else add extra slack
> +	 * to avoid frequent reallocations.  Extra slack is
> +	 * currently one 4k page worth of rules.
> +	 *
> +	 * Use no slack if the set only has a small number
> +	 * of rules.

This isn't always true: if we slightly decrease the size of a small
mapping table, we might leave some slack, because we might hit the
(remove < (2u * extra)) condition above. Is that intended? It doesn't
look problematic to me, by the way.

> +	 */
> +	if (rules > extra &&
> +	    check_add_overflow(rules, extra, &rules_alloc))
> +		return -EOVERFLOW;
> +
> +	new_mt = kvmalloc_array(rules_alloc, sizeof(*new_mt), GFP_KERNEL);
> +	if (!new_mt)
> +		return -ENOMEM;
> +
> +	if (old_mt)
> +		memcpy(new_mt, old_mt, min(old_rules, rules) * sizeof(*new_mt));
> +
> +	if (rules > old_rules)

Nit: curly braces around multi-line block (for consistency).

> +		memset(new_mt + old_rules, 0,
> +		       (rules - old_rules) * sizeof(*new_mt));
> +
> +out_free:
> +	f->rules_alloc = rules_alloc;
> +	f->mt = new_mt;
> +
> +	kvfree(old_mt);
> +
> +	return 0;
> +}
> +
>  /**
>   * pipapo_resize() - Resize lookup or mapping table, or both
>   * @f:		Field containing lookup and mapping tables
> @@ -637,9 +693,8 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
>  static int pipapo_resize(struct nft_pipapo_field *f, unsigned int old_rules, unsigned int rules)
>  {
>  	long *new_lt = NULL, *new_p, *old_lt = f->lt, *old_p;
> -	union nft_pipapo_map_bucket *new_mt, *old_mt = f->mt;
>  	unsigned int new_bucket_size, copy;
> -	int group, bucket;
> +	int group, bucket, err;
>  
>  	if (rules >= NFT_PIPAPO_RULE0_MAX)
>  		return -ENOSPC;
> @@ -682,16 +737,10 @@ static int pipapo_resize(struct nft_pipapo_field *f, unsigned int old_rules, uns
>  	}
>  
>  mt:
> -	new_mt = kvmalloc(rules * sizeof(*new_mt), GFP_KERNEL);
> -	if (!new_mt) {
> +	err = pipapo_realloc_mt(f, old_rules, rules);
> +	if (err) {
>  		kvfree(new_lt);
> -		return -ENOMEM;
> -	}
> -
> -	memcpy(new_mt, f->mt, min(old_rules, rules) * sizeof(*new_mt));
> -	if (rules > old_rules) {
> -		memset(new_mt + old_rules, 0,
> -		       (rules - old_rules) * sizeof(*new_mt));
> +		return err;
>  	}
>  
>  	if (new_lt) {
> @@ -700,9 +749,6 @@ static int pipapo_resize(struct nft_pipapo_field *f, unsigned int old_rules, uns
>  		kvfree(old_lt);
>  	}
>  
> -	f->mt = new_mt;
> -	kvfree(old_mt);
> -
>  	return 0;
>  }
>  
> @@ -1382,13 +1428,16 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
>  		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
>  
>  		if (src->rules > 0) {
> -			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt), GFP_KERNEL);
> +			dst->mt = kvmalloc_array(src->rules_alloc, sizeof(*src->mt), GFP_KERNEL);
>  			if (!dst->mt)
>  				goto out_mt;
>  
>  			memcpy(dst->mt, src->mt, src->rules * sizeof(*src->mt));
> +			dst->rules_alloc = src->rules_alloc;
> +			dst->rules = src->rules;

These two, and setting rules_alloc below, shouldn't be needed, because we
already copy everything in the source field before the lookup table, above.

>  		} else {
>  			dst->mt = NULL;
> +			dst->rules_alloc = 0;
>  		}
>  
>  		src++;
> @@ -2203,6 +2252,7 @@ static int nft_pipapo_init(const struct nft_set *set,
>  
>  		f->bsize = 0;
>  		f->rules = 0;
> +		f->rules_alloc = 0;
>  		f->lt = NULL;
>  		f->mt = NULL;
>  	}
> diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
> index 8d9486ae0c01..bbcac2b38167 100644
> --- a/net/netfilter/nft_set_pipapo.h
> +++ b/net/netfilter/nft_set_pipapo.h
> @@ -106,6 +106,7 @@ union nft_pipapo_map_bucket {
>   * struct nft_pipapo_field - Lookup, mapping tables and related data for a field
>   * @rules:	Number of inserted rules
>   * @bsize:	Size of each bucket in lookup table, in longs
> + * @rules_alloc Number of allocated rules, always >= rules
>   * @groups:	Amount of bit groups
>   * @bb:		Number of bits grouped together in lookup table buckets
>   * @lt:		Lookup table: 'groups' rows of buckets
> @@ -114,6 +115,7 @@ union nft_pipapo_map_bucket {
>  struct nft_pipapo_field {
>  	unsigned int rules;
>  	unsigned int bsize;
> +	unsigned int rules_alloc;
>  	u8 groups;
>  	u8 bb;
>  	unsigned long *lt;

-- 
Stefano

