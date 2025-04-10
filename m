Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C651EF363
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2025 17:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744305885; cv=none; b=WOpPhPLv4vpoumP5r7k/Y7i1m1VhyLvM6r9v++4d3Zxf/q1/a7PjZGX0x7cQtVhDYcbOn6Hwp6GU9c+HLbxxd11EJgAMXzOsf0CCc1YLYTTthlKQPC5EnNpSamRLtsOQy5SaFCfFOIleFILv5ocOYdG1MnDfiVThv1pQGeh/aMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744305885; c=relaxed/simple;
	bh=E1QkVM8sUa1BCS53kFKb92qG45GzS61zx0y2JIhQBDY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TLrZwMtPIEvYXwK1Jv9nskVxTyRhI0gEgmZZ3Moh89mBw+k1u4EZthpf4Zb8tBh7o0AwLetd0aY9+l3Z/fUbaxAB6XwkFMzkqQLWKoWxrsqo5c/ii3IzokCR2EsuYQVzHdevUS7ozAGsvFAROwduKVIFGrg9PbSc9a5I+XoUqkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P3cxGDx1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P3cxGDx1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744305882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jZNK/OO70clT3CdiXwISiTuSI2wBChBbGwNdkWDc/j0=;
	b=P3cxGDx16zaEQ4czZtfZS219tNVKj2XFNaPh8aK0pDLkkDDPd5uzjTWHuCcj1W590rFfRR
	melPpjhfgnZtEA6leNIJV4K7VXTwMzJets+o7oXE0Ca0ZQFfTjY5XQLieOluz+OxqXEoGj
	eYarRs8Ta6zTMS6TEGT6jUuBm/TbS1w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-IYl8I6slP-KyXnx13T7QXA-1; Thu, 10 Apr 2025 13:24:41 -0400
X-MC-Unique: IYl8I6slP-KyXnx13T7QXA-1
X-Mimecast-MFC-AGG-ID: IYl8I6slP-KyXnx13T7QXA_1744305880
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3914bc0cc4aso613920f8f.3
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2025 10:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744305879; x=1744910679;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jZNK/OO70clT3CdiXwISiTuSI2wBChBbGwNdkWDc/j0=;
        b=nUC07odyQVyeCoEkwYChI5hPtCaH7XfZoihSGEC4GhTlwSwWflirLgpJJTF182rWDt
         te9Z//fJh44BfFZizHKfVB62GbeBdOJMVeOyvFfvWv514ayR+M1KJ3aJEf6OOtONHvx2
         Ovb0Y2S+ygFqA/YcoNnA2eBWkZdr8LWcRgsgPPWIAshzUP+XwEEDAuaTuv+1Mlg7Ki31
         2QbJim76i3+maT/akQBq6FiWGyaOLaiPwbOHJfhN+QBrxcDe+tJ4323udlTnwDrpfhmy
         nW3LdsU89/yGp3iUpIhaDUNo6Ouz0MhLsYbR6ydMa7r2FcTKkdnn1HYVyke8Cy+1i+nf
         XuCQ==
X-Gm-Message-State: AOJu0YzetvuhdxQ8AHajVskCq/JwdqBG2tMkN9kI2975cW3K/RfvcLIG
	dgiiNUpCoS/GDSwWX5nkktnP4rsFavryYeaEmUuu64H/Pb0rIZ+oi1R3Q/jEc2xrKhnsqBtGT+o
	yumRd27Y2E1JNYpysLfbrhP9r1hnLfQW2H3DhrmSovL0YbdDr5zYyFphlTm0l7UVIO1m37BkfWw
	==
X-Gm-Gg: ASbGncth8HiWOK403a/w2KHvHADTQspliGPRtaNF/JDPkZWcSnA+ksgK/3MdvY/DP5O
	le0bB+TXft0YrbCEe90DzyuW9sh5jblzsFJP+m4J8lsUo6C62eLvd+CXB11NbFM5+ej50yLPvXa
	jlFFP4ZJnjbbZkMqXhW/ElPbBvJ9vHpxA+i5qtcP17o0Niq6ysE6eAIIJC9DmJphp+feu6S0nx9
	Fn0vqAsrdPhbklLtb51PMrjzrvAnSgiqXcizhGDZt1FuiLNrMVm3Mcl3v4Uf7MG/dbCloKnUrgF
	5uykDTpWf8O70Cmxli8UAWAMq6eX048TMXJzrR0D
X-Received: by 2002:a05:6000:2906:b0:391:45e9:face with SMTP id ffacd0b85a97d-39d8fda74a6mr3040686f8f.54.1744305879385;
        Thu, 10 Apr 2025 10:24:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiooZjj6740lDoh+vFWLOzm/kaOgmKI44k6UPDT/m1UyrgCRhES9WMMnjvWyl3xWToPdH1oA==
X-Received: by 2002:a05:6000:2906:b0:391:45e9:face with SMTP id ffacd0b85a97d-39d8fda74a6mr3040667f8f.54.1744305878920;
        Thu, 10 Apr 2025 10:24:38 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39d89363066sm5382216f8f.7.2025.04.10.10.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Apr 2025 10:24:38 -0700 (PDT)
Date: Thu, 10 Apr 2025 19:24:35 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf-next,v2 1/2] netfilter: nft_set_pipapo: prevent
 overflow in lookup table allocation
Message-ID: <20250410192435.10052452@elisabeth>
In-Reply-To: <20250410100456.1029111-1-pablo@netfilter.org>
References: <20250410100456.1029111-1-pablo@netfilter.org>
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

On Thu, 10 Apr 2025 12:04:55 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> When calculating the lookup table size, ensure the following
> multiplication does not overflow:
> 
> - desc->field_len[] maximum value is U8_MAX multiplied by
>   NFT_PIPAPO_GROUPS_PER_BYTE(f) that can be 2, worst case.
> - NFT_PIPAPO_BUCKETS(f->bb) is 2^8, worst case.
> - sizeof(unsigned long), from sizeof(*f->lt), lt in
>   struct nft_pipapo_field.
> 
> Then, use check_mul_overflow() to multiply by bucket size and then use
> check_add_overflow() to the alignment for avx2 (if needed). Finally, add
> lt_size_check_overflow() helper and use it to consolidate this.
> 
> While at it, replace leftover allocation using the GFP_KERNEL to
> GFP_KERNEL_ACCOUNT for consistency, in pipapo_resize().
> 
> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: detach chunk to ensure allocation below INT_MAX.
> 
>  net/netfilter/nft_set_pipapo.c | 48 +++++++++++++++++++++++++---------
>  1 file changed, 35 insertions(+), 13 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 7be342b495f5..1b5c498468c5 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -683,6 +683,22 @@ static int pipapo_realloc_mt(struct nft_pipapo_field *f,
>  	return 0;
>  }
>  
> +static bool lt_size_check_overflow(unsigned int groups, unsigned int bb,
> +				   unsigned int bsize, size_t size,
> +				   size_t *lt_size)

It looks good to me except for one consideration: I found it quite
confusing that this changes lt_size but at a first glance it appears to
check things only, so I've been wondering for a while if you
accidentally dropped the alignment headroom.

By the way, 'size' is always sizeof(long) (because 'bsize' is in longs).

I haven't tested this (not even build tested, sorry), but what about:

/**
 * lt_calculate_size() - Get storage size for lookup table with overflow check
 * @groups:	Amount of bit groups
 * @bb:		Number of bits grouped together in lookup table buckets
 * @bsize:	Size of each bucket in lookup table, in longs
 *
 * Return: allocation size including alignment overhead, negative on overflow
 */
static ssize_t lt_size_check_overflow(unsigned int groups, unsigned int bb,
				      unsigned int bsize)
{
	ssize_t ret = groups * NFT_PIPAPO_BUCKETS(bb) * sizeof(long);

	if (check_mul_overflow(ret, bsize, &ret))
		return -1;
	if (check_add_overflow(ret, NFT_PIPAPO_ALIGN_HEADROOM, &ret))
		return -1;
	if (ret > INT_MAX)
		return -1;

	return ret;
}

?

> +{
> +	*lt_size = groups * NFT_PIPAPO_BUCKETS(bb) * size;
> +
> +	if (check_mul_overflow(*lt_size, bsize, lt_size))
> +		return true;
> +	if (check_add_overflow(*lt_size, NFT_PIPAPO_ALIGN_HEADROOM, lt_size))
> +		return true;
> +	if (*lt_size > INT_MAX)
> +		return true;
> +
> +	return false;
> +}
> +
>  /**
>   * pipapo_resize() - Resize lookup or mapping table, or both
>   * @f:		Field containing lookup and mapping tables
> @@ -701,6 +717,7 @@ static int pipapo_resize(struct nft_pipapo_field *f,
>  	long *new_lt = NULL, *new_p, *old_lt = f->lt, *old_p;
>  	unsigned int new_bucket_size, copy;
>  	int group, bucket, err;
> +	size_t lt_size;
>  
>  	if (rules >= NFT_PIPAPO_RULE0_MAX)
>  		return -ENOSPC;
> @@ -719,10 +736,11 @@ static int pipapo_resize(struct nft_pipapo_field *f,
>  	else
>  		copy = new_bucket_size;
>  
> -	new_lt = kvzalloc(f->groups * NFT_PIPAPO_BUCKETS(f->bb) *
> -			  new_bucket_size * sizeof(*new_lt) +
> -			  NFT_PIPAPO_ALIGN_HEADROOM,
> -			  GFP_KERNEL);
> +	if (lt_size_check_overflow(f->groups, f->bb, new_bucket_size,
> +				   sizeof(*new_lt), &lt_size))
> +		return -ENOMEM;
> +
> +	new_lt = kvzalloc(lt_size, GFP_KERNEL_ACCOUNT);
>  	if (!new_lt)
>  		return -ENOMEM;
>  
> @@ -917,15 +935,17 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
>  		groups = f->groups * 2;
>  		bb = NFT_PIPAPO_GROUP_BITS_LARGE_SET;
>  
> -		lt_size = groups * NFT_PIPAPO_BUCKETS(bb) * f->bsize *
> -			  sizeof(*f->lt);
> +		if (lt_size_check_overflow(groups, bb, f->bsize,
> +					   sizeof(*f->lt), &lt_size))
> +			return;
>  	} else if (f->bb == NFT_PIPAPO_GROUP_BITS_LARGE_SET &&
>  		   lt_size < NFT_PIPAPO_LT_SIZE_LOW) {
>  		groups = f->groups / 2;
>  		bb = NFT_PIPAPO_GROUP_BITS_SMALL_SET;
>  
> -		lt_size = groups * NFT_PIPAPO_BUCKETS(bb) * f->bsize *
> -			  sizeof(*f->lt);
> +		if (lt_size_check_overflow(groups, bb, f->bsize,
> +					   sizeof(*f->lt), &lt_size))
> +			return;
>  
>  		/* Don't increase group width if the resulting lookup table size
>  		 * would exceed the upper size threshold for a "small" set.
> @@ -936,7 +956,7 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
>  		return;
>  	}
>  
> -	new_lt = kvzalloc(lt_size + NFT_PIPAPO_ALIGN_HEADROOM, GFP_KERNEL_ACCOUNT);
> +	new_lt = kvzalloc(lt_size, GFP_KERNEL_ACCOUNT);
>  	if (!new_lt)
>  		return;
>  
> @@ -1451,13 +1471,15 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
>  
>  	for (i = 0; i < old->field_count; i++) {
>  		unsigned long *new_lt;
> +		size_t lt_size;
>  
>  		memcpy(dst, src, offsetof(struct nft_pipapo_field, lt));
>  
> -		new_lt = kvzalloc(src->groups * NFT_PIPAPO_BUCKETS(src->bb) *
> -				  src->bsize * sizeof(*dst->lt) +
> -				  NFT_PIPAPO_ALIGN_HEADROOM,
> -				  GFP_KERNEL_ACCOUNT);
> +		if (lt_size_check_overflow(src->groups, src->bb, src->bsize,
> +					   sizeof(*dst->lt), &lt_size))
> +			goto out_lt;
> +
> +		new_lt = kvzalloc(lt_size, GFP_KERNEL_ACCOUNT);
>  		if (!new_lt)
>  			goto out_lt;
>  

The rest looks good to me, thanks for fixing this!

-- 
Stefano

