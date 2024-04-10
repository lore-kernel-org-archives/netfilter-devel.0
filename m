Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF1D2E405
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Apr 2024 18:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712774267; cv=none; b=MQEoqQFv5mXChkedDov0pMDZ/Qev0tIC+rlWz5aN85vuzpaZgyWh2uF+qbkZmlS+F6mXF416jJNz8LlSAhvAuVLiZWMwjjTpEkC5dijjwSM1zepn9znuVMOAALxRLRdwG7wRiSRvpcusdTWjPn7PLjXxlMs9LZ9rYpsCFD9mocs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712774267; c=relaxed/simple;
	bh=VG+Y1dTyDhJaqewtl6tXk7V+ZLLucOasvP3cRKLXx84=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B2il8gqlYlVJuxiyPU2tWDw2P/pECIlwzqq4gZWwvN17rT41PUp6motZiiSJtMBjJKDau1AsEXnSf+bLW9jptMYXZCLudfh9JMMR6LZ6ZVwOzXHhmSxDSvDezUmXyZ2k9JFBOr3sHgp7ZlG7ecv6fXxaED6sQmKscjg+HnLfGHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W2wPHVrX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W2wPHVrX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712774263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FbG9hRPgMZ1tuAtsYyYDxijxioJWyYXWffEzHkzo07k=;
	b=W2wPHVrXtSgfalsAEJ0w8B3d/NlioeVoRI3wD7pWWKD1CzSABZULecmmqAlfdprZ28FPvD
	6FtlpXiZ1XuBG4KiRkMNLuil7XX6v4m6p7OfNT8riWq8F38/73kw73+m25Z/gBUvDNtzmi
	MEIJcs/sdFlHb7/oSPpW5QqUDMNFMUs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-rX_oEFynMkiA4zyh046m6g-1; Wed, 10 Apr 2024 14:37:42 -0400
X-MC-Unique: rX_oEFynMkiA4zyh046m6g-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-56e40f82436so1839801a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Apr 2024 11:37:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712774261; x=1713379061;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FbG9hRPgMZ1tuAtsYyYDxijxioJWyYXWffEzHkzo07k=;
        b=KwcneJMNr7+gv0ZPjQNNGNOMv3qwTHekXRAdMPYOdNP101O598wt6Z9lAIa+KFg8eu
         E/ZkwYy175LT4SJF4wJRJgOruuPTXZdeeMGsnp8yXJfQA2wZEuyIV+a8wPCWsdiq/b07
         3gOB0Dngq8YUoKmVYu+qoRIcURSt3Q8Zo4a6bKzJCw2hyfONURucc6G3JXOiEpOHlNjr
         949o+DJmEL0CQofK/9J/x4qDLf4nXUiIRXc8/BPN3rbMe2tYT2q0zydF3y0y8NwY+QIE
         W6iih0eqCtLPApmO3rRjGPUV0irJTLhZQjCJ4jFMVSuJSkCGDFuJyX9t3A2rNmQPz0/K
         qQ9w==
X-Gm-Message-State: AOJu0Yya6vLi6NFMVKn/rNsBVtjEXF0kNj5+6+IcAL3wdk/Fs/izyIRZ
	/QHbZRlDIY6xP2wS2fskdk3+yuPbl2FUqG+oJ/pgxucywumfMX3jGXVFMNEgR1z1orqkv5ywhHH
	cw4DzHNAkvJslwPu7ouHvz8r6ikoMltJXLFdzWngYYbj8rY1t/RECa3D1JGv7sP2vryIxKm1eCn
	Wv5MQ=
X-Received: by 2002:a50:871c:0:b0:56e:3088:49a with SMTP id i28-20020a50871c000000b0056e3088049amr2883059edb.37.1712774260774;
        Wed, 10 Apr 2024 11:37:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqB2jMGMFN6zevkohooZf/7br4g54miiSHRfzmrcdzDRQYcBwFTc2jS8nOfxVbuYqjiC9DCA==
X-Received: by 2002:a50:871c:0:b0:56e:3088:49a with SMTP id i28-20020a50871c000000b0056e3088049amr2883036edb.37.1712774260137;
        Wed, 10 Apr 2024 11:37:40 -0700 (PDT)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id o13-20020aa7d3cd000000b0056e67aa7118sm3247232edr.52.2024.04.10.11.37.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Apr 2024 11:37:39 -0700 (PDT)
Date: Wed, 10 Apr 2024 20:37:05 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>, Pablo Neira Ayuso
 <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: do not free live element
Message-ID: <20240410203705.2e5ae36b@elisabeth>
In-Reply-To: <20240410144853.462-1-fw@strlen.de>
References: <20240410144853.462-1-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.36; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 Apr 2024 16:48:49 +0200
Florian Westphal <fw@strlen.de> wrote:

> Pablo reports a crash with large batches of elements with a
> back-to-back add/remove pattern.  Quoting Pablo:
> 
>   add_elem("00000000") timeout 100 ms
>   ...
>   add_elem("0000000X") timeout 100 ms
>   del_elem("0000000X") <---------------- delete one that was just added
>   ...
>   add_elem("00005000") timeout 100 ms
> 
>   1) nft_pipapo_remove() removes element 0000000X
>   Then, KASAN shows a splat.
> 
> Looking at the remove function there is a chance that we will drop a
> rule that maps to a non-deactivated element.
> 
> Removal happens in two steps, first we do a lookup for key k and return the
> to-be-removed element and mark it as inactive in the next generation.
> Then, in a second step, the element gets removed from the set/map.
> 
> The _remove function does not work correctly if we have more than one
> element that share the same key.
> 
> This can happen if we insert an element into a set when the set already
> holds an element with same key, but the element mapping to the existing
> key has timed out or is not active in the next generation.

Uh-oh, I didn't imagine that could happen, thanks for fixing this.

The fix looks correct to me. Just one nit:

> In such case its possible that removal will unmap the wrong element.
> If this happens, we will leak the non-deactivated element, it becomes
> unreachable.
> 
> The element that got deactivated (and will be freed later) will
> remain reachable in the set data structure, this can result in
> a crash when such an element is retrieved during lookup (stale
> pointer).
> 
> Add a check that the fully matching key does in fact map to the element
> that we have marked as inactive in the deactivation step.
> If not, we need to continue searching.
> 
> Add a bug/warn trap at the end of the function as well, the remove
> function must not ever be called with an invisible/unreachable/non-existent
> element.
> 
> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index df8de5090246..09c3eedc879b 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -2077,6 +2077,8 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
>  		rules_fx = rules_f0;
>  
>  		nft_pipapo_for_each_field(f, i, m) {
> +			bool last = i == m->field_count - 1;
> +
>  			if (!pipapo_match_field(f, start, rules_fx,
>  						match_start, match_end))
>  				break;
> @@ -2089,16 +2091,22 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
>  
>  			match_start += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
>  			match_end += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
> -		}
>  
> -		if (i == m->field_count) {
> -			priv->dirty = true;
> -			pipapo_drop(m, rulemap);
> -			return;
> +			if (last) {
> +				const struct nft_pipapo_elem *this = f->mt[rulemap[i].to].e;
> +
> +				if (this == e) {

To avoid this very long line, we could probably assign 'this' on a
separate line, or even just:

				if (f->mt[rulemap[i].to].e == e) {

which I find equally readable.

Either way,

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

