Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B028B6AD6
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 07:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707808849; cv=none; b=qlj/AXO9vFZV1qYLGMg4vZQ8/7sL4kcNjt2zaQbEXdmh5+J8px4WnZfAR1UHs6lFRziolrlYHkgzXtjUPu7GDWPuf+EGr1hLehl7u/Q1YGMse8uzpqq+DFdR+qyFTDEI/eUTm9r0rB9J+9mcZFGSEvR6NUL9eLjfXQHIOOrCeBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707808849; c=relaxed/simple;
	bh=+ySOO6jhlLuL9MmlKcswQxjhlQugKx/xWvf4qFcEGtg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OOqlzA4VRO6xACwUiDrukw6BCX1WT6AQxDidKkny/l3GmCydxu18nzaj5wTxNTgboTLLteJi2G8AwaE6fbg+Szf7mZrA76CTPqzlcXvbL2kjDZGYukGrnv5MkIWKPheQK0ys3GsdWk24ttCFnUnr96uFTijM0XOYIBPmXZMSYHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CGQSNr4j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CGQSNr4j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707808846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=On33J96JeBQFXAl8bVdwbcNDjArGvn9oZ3ZlqtL44ec=;
	b=CGQSNr4jjAvhbM5asPq3Sx2qvNWjfGtb/fL8l6Ya8AK8/og4AzFbjyXqceWLWl1p0cHFDm
	icUIOWKpXuq0o5lqadY5FY7OMv1xn2DBS5DFjW78NYmEze3su+pBwxPV1fZcX06uOpRFTD
	NobBlFzIk7SW8Q84gg+jixRTm6j7a3w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-9Uu9Pa8JNx6ZAuhzE8LhNQ-1; Tue, 13 Feb 2024 02:20:44 -0500
X-MC-Unique: 9Uu9Pa8JNx6ZAuhzE8LhNQ-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-559391de41bso3035126a12.3
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Feb 2024 23:20:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707808842; x=1708413642;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=On33J96JeBQFXAl8bVdwbcNDjArGvn9oZ3ZlqtL44ec=;
        b=kXeKKn9PyE3zX3u4DBB0UbYc3GYQnQemC1YpR0quBeZ1F3JIQCEZznFariFr3gzbSJ
         Xfia5jULsESqnGKuapmewmuvP1gxgJ4NF0WB8usHKk8mZIeDTjOmmwnu0oypyphLbtRm
         tRHEMVPOQmdeoAClO9S+IW8l/QtBWMqFP8Q2V+Yls6YPw2vHBa38S/9b9nuyFQQiw+ww
         g0IpYeqezo2XKbU05GFucKgzTgbEbN2lGWCAGIk/wO64mWq574nVCMM8vh3j1iHN5rp6
         38Dvdds5oYAaH+YxmRzFHYiS0RKrJpZhoJGK89t6aE8P8NDt3EWgePydlirTGooq+W4Z
         f6vA==
X-Gm-Message-State: AOJu0Ywm6dgdV8Sj3wBITyNM1Ual/nNkWHCM92L1m3WYn7pQF+7+r3a5
	w6Dc2rNnpONZHTScyoYQ01StmwtukKdA87FNDJ+UqDm50m2cw2QiNinti0yhlpXqZBDzcyxJOYx
	tghdoPJyUftiN90VY8XrcSxLCgrrU8JBdXId5y3vAfMU4IQGGt+xhhqdn4TP/u0ddJpDbZp0lQ0
	eX
X-Received: by 2002:a05:6402:1293:b0:560:be95:aa64 with SMTP id w19-20020a056402129300b00560be95aa64mr6101409edv.37.1707808842229;
        Mon, 12 Feb 2024 23:20:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE/7gc01Na+LI6lGWVOC8BznoUA5EPXZiZUrBSJCJtF24dxnkzqFk/ZXlkViakSo3lS6CNZog==
X-Received: by 2002:a05:6402:1293:b0:560:be95:aa64 with SMTP id w19-20020a056402129300b00560be95aa64mr6101396edv.37.1707808841894;
        Mon, 12 Feb 2024 23:20:41 -0800 (PST)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id y24-20020a056402135800b005606b3d835fsm3480038edw.50.2024.02.12.23.20.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Feb 2024 23:20:41 -0800 (PST)
Date: Tue, 13 Feb 2024 08:20:07 +0100
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 2/4] netfilter: nft_set_pipapo: do not rely on
 ZERO_SIZE_PTR
Message-ID: <20240213082007.3f4e689d@elisabeth>
In-Reply-To: <20240212100202.10116-3-fw@strlen.de>
References: <20240212100202.10116-1-fw@strlen.de>
	<20240212100202.10116-3-fw@strlen.de>
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

On Mon, 12 Feb 2024 11:01:51 +0100
Florian Westphal <fw@strlen.de> wrote:

> pipapo relies on kmalloc(0) returning ZERO_SIZE_PTR (i.e., not NULL
> but pointer is invalid).
> 
> Rework this to not call slab allocator when we'd request a 0-byte
> allocation.
> 
> While at it, also use GFP_KERNEL allocations here, this is only called
> from control plane.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 395420fa71e5..6a79ec98de86 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -526,13 +526,16 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
>  	const struct nft_pipapo_field *f;
>  	int i;
>  
> -	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
> +	if (m->bsize_max == 0)
> +		return ret;
> +
> +	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_KERNEL);
>  	if (!res_map) {
>  		ret = ERR_PTR(-ENOMEM);
>  		goto out;
>  	}
>  
> -	fill_map = kcalloc(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
> +	fill_map = kcalloc(m->bsize_max, sizeof(*res_map), GFP_KERNEL);

I haven't re-checked the whole logic, but can't nft_pipapo_deactivate()
(hence pipapo_deactivate() and pipapo_get()) be called from the data
path for some reason?

If I recall correctly that's why I used GFP_ATOMIC here, but I'm not
sure anymore and I guess you know better.

>  	if (!fill_map) {
>  		ret = ERR_PTR(-ENOMEM);
>  		goto out;
> @@ -1367,11 +1370,16 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
>  		       src->bsize * sizeof(*dst->lt) *
>  		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
>  
> -		dst->mt = kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL);
> -		if (!dst->mt)
> -			goto out_mt;
> +		if (src->rules > 0) {
> +			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt), GFP_KERNEL);

Nit: equally readable within 80 columns:

			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt),
						 GFP_KERNEL);

> +			if (!dst->mt)
> +				goto out_mt;
> +
> +			memcpy(dst->mt, src->mt, src->rules * sizeof(*src->mt));
> +		} else {
> +			dst->mt = NULL;
> +		}
>  
> -		memcpy(dst->mt, src->mt, src->rules * sizeof(*src->mt));
>  		src++;
>  		dst++;
>  	}

-- 
Stefano

