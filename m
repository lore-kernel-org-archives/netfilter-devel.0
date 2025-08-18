Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687A8334718
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 16:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755534756; cv=none; b=feEnggIiPSU31yjtU5o6lWKLCa01SIRJofBG7krwz4cK0U402UidNNutzNigsFpzan6dPsvpki1SuJjl07o4EMewrvbodtGrVqBAyZ5xDK7BOJk33x5G87El3QTpWV/aS5ufeyEDo0h1io3UPUr9OM5lEuSpBtG00FOYtRFdHMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755534756; c=relaxed/simple;
	bh=4xQZ8NC6GAxEXRLOSsADix2Ef2hxtfz6B50xQgeBumg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=deyuItWzKn/LvgtrApxuXXW8rcD5fS7NQW/7RQiFIC6+1DXiIXw7b2pjUeREGVyIrqRjDe81nHRmbj58AEwLZLgG8WVYN+tbjP6582RAFX8rgPCDnFtiFle89oCb7y5K4HutNuAvOJ8Mpfzuu2GK4lBbxshGhU7PkL25SQZpPq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IC4NUVM3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IC4NUVM3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755534753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NTGIApxM/P3yH9/2tPAKkH0scqTjp82wqXnmmrdMOgA=;
	b=IC4NUVM3mH0ziO8ZPaaf45b5npFQTbfzCehXsiUouWiXTqHEG3zATQSaCt/2+9riBi1RJ+
	rD9OaBDLP06v3jsaKLGg0D+lF6aF/1YTiNFHDURfODHsWfeCmIeDTRkWUd2Ybb0m5WFI2e
	wwOE9UGM8eJk5s5iCttKMbo0wCM13gQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-YHbJIaQ1M8KDHjyrPPKFcw-1; Mon, 18 Aug 2025 12:32:31 -0400
X-MC-Unique: YHbJIaQ1M8KDHjyrPPKFcw-1
X-Mimecast-MFC-AGG-ID: YHbJIaQ1M8KDHjyrPPKFcw_1755534750
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9edf34ad0so2404560f8f.3
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 09:32:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755534750; x=1756139550;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NTGIApxM/P3yH9/2tPAKkH0scqTjp82wqXnmmrdMOgA=;
        b=bOBtLItlnrpgkgoRgimyQbF81iFAK/lOjioiDpBF/zVz+vRb6yRcE0IsmmFfQCq5dm
         p531ngkKO5rKZyCN49yHyfcxYYyScAZoNy6kUR7E6RWWoSNGyi1fiIYCXibzOfnkg6PO
         Y7xCqxTTuQTOp3yNBEH7UJa4V44WBQdneczP6TXG0nN2dtizjLKW/pN5pO22KrrUFanN
         p/KAiwpLqCxhzncT4I1OY++MAn8E3b7wtyQYTkbamDSMwiZ3AKgVpmvsQKCoVvu9NuB+
         AwiwPyfCTXYJQTDgF6HqmmouMPckAdzvukWs9aQvgt81LLya7fD7Gckmh1+YWw8BJgI2
         8NiA==
X-Gm-Message-State: AOJu0Yw81E3DKF9KWJ2AAgVlOrCPdmwJqYAmYBP8NitUgQ4IIaNQp1k9
	/Avf0BUeTsLiv/bSwM1RgFYOkeN/qNREgSdH6bHsIrI07cha6YJqqgmnJ0JSFQavWLYSmNqjYiv
	O67pQQ/8ETfA+9TNvRaidjjqsRIX3N/7pkE5AUtMh7aq9oPPzi8J7lZzHXRvpjHmXHQfScZBcBU
	ellw==
X-Gm-Gg: ASbGncvNA9/YQIMg8ydog/ZjkpMLXoo/lr7vJlIRAaBXw261m+47Wu4EcfINupSdwIs
	vOTNciMu1YVMAzs5pZU8oyBnuo9GlFWCtgExDvNJIW1KKVqnEcqWv1lZRm+O7fLcQqMqQXKCj47
	w1lDP4ToFLauVM3rm8YuhEt6jBSAHY+jEwzeZog1LsE7082o/eIpydb6OTV/9mofOE2gOWtYMpm
	Y5eCfiNUzVmW6RYmFBUMi5LeZrOfHJOwwCbVazvn9CGutcuK8nlloOyXFfNGrkOZJF9gwasmOFj
	atV9G8zUTuX1TBy625bflFpq8bLGHDTPMIzFHcfmBnPyUj9Z8zMdYq7Bl2+pADgK0LBw
X-Received: by 2002:a05:6000:2f82:b0:3b8:f8e5:f6be with SMTP id ffacd0b85a97d-3c07e213947mr50678f8f.4.1755534749594;
        Mon, 18 Aug 2025 09:32:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDxCLwuh4vxbZ00R47Cz96es55DhzqFExXYHA9yEEsSOK69SbzFOMH/4NilRUwVSJZYssgOQ==
X-Received: by 2002:a05:6000:2f82:b0:3b8:f8e5:f6be with SMTP id ffacd0b85a97d-3c07e213947mr50650f8f.4.1755534749122;
        Mon, 18 Aug 2025 09:32:29 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c074d43987sm171110f8f.16.2025.08.18.09.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 09:32:28 -0700 (PDT)
Date: Mon, 18 Aug 2025 18:32:27 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 2/2] netfilter: nft_set_pipapo: use avx2
 algorithm for insertions too
Message-ID: <20250818183227.28dfa525@elisabeth>
In-Reply-To: <20250815143702.17272-3-fw@strlen.de>
References: <20250815143702.17272-1-fw@strlen.de>
	<20250815143702.17272-3-fw@strlen.de>
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

On Fri, 15 Aug 2025 16:36:58 +0200
Florian Westphal <fw@strlen.de> wrote:

> Always prefer the avx2 implementation if its available.
> This greatly improves insertion performance (each insertion
> checks if the new element would overlap with an existing one):
> 
> time nft -f - <<EOF
> table ip pipapo {
> 	set s {
> 		typeof ip saddr . tcp dport
> 		flags interval
> 		size 800000
> 		elements = { 10.1.1.1 - 10.1.1.4 . 3996,
> [.. 800k entries elided .. ]
> 
> before:
> real    1m55.993s
> user    0m2.505s
> sys     1m53.296s
> 
> after:
> real    0m42.586s
> user    0m2.554s
> sys     0m39.811s
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo.c      | 47 ++++++++++++++++++++++++++---
>  net/netfilter/nft_set_pipapo_avx2.c |  6 ++--
>  net/netfilter/nft_set_pipapo_avx2.h |  4 +++
>  3 files changed, 49 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 9a10251228fd..affa473b13a6 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -397,7 +397,7 @@ int pipapo_refill(unsigned long *map, unsigned int len, unsigned int rules,
>  }
>  
>  /**
> - * pipapo_get() - Get matching element reference given key data
> + * pipapo_get_slow() - Get matching element reference given key data
>   * @m:		storage containing the set elements
>   * @data:	Key data to be matched against existing elements
>   * @genmask:	If set, check that element is active in given genmask
> @@ -414,9 +414,9 @@ int pipapo_refill(unsigned long *map, unsigned int len, unsigned int rules,
>   *
>   * Return: pointer to &struct nft_pipapo_elem on match, NULL otherwise.
>   */
> -static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
> -					  const u8 *data, u8 genmask,
> -					  u64 tstamp)
> +static struct nft_pipapo_elem *pipapo_get_slow(const struct nft_pipapo_match *m,
> +					       const u8 *data, u8 genmask,
> +					       u64 tstamp)
>  {
>  	struct nft_pipapo_scratch *scratch;
>  	unsigned long *res_map, *fill_map;
> @@ -502,6 +502,43 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
>  	return NULL;
>  }
>  
> +/**
> + * pipapo_get() - Get matching element reference given key data
> + * @m:		storage containing the set elements
> + * @data:	Key data to be matched against existing elements
> + * @genmask:	If set, check that element is active in given genmask
> + * @tstamp:	timestamp to check for expired elements
> + *
> + * This is a dispatcher function, either calling out the generic C
> + * implementation or, if available, the avx2 one.
> + * This helper is only called from the control plane, with either rcu

Nit: AVX2, RCU

> + * read lock or transaction mutex held.
> + *
> + * Return: pointer to &struct nft_pipapo_elem on match, NULL otherwise.
> + */
> +static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
> +					  const u8 *data, u8 genmask,
> +					  u64 tstamp)
> +{
> +	struct nft_pipapo_elem *e;
> +
> +	local_bh_disable();
> +
> +#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
> +	if (boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX) &&

I don't have any straightforward idea on how to avoid introducing AVX2
stuff (even if compiled out) in the generic function, which we had
managed to avoid so far. I don't think it's a big deal, though.

> +	    irq_fpu_usable()) {
> +		kernel_fpu_begin_mask(0);
> +		e = pipapo_get_avx2(m, data, genmask, tstamp);
> +		kernel_fpu_end();
> +		local_bh_enable();
> +		return e;
> +	}
> +#endif
> +	e = pipapo_get_slow(m, data, genmask, tstamp);
> +	local_bh_enable();
> +	return e;
> +}
> +
>  /**
>   * nft_pipapo_lookup() - Dataplane fronted for main lookup function
>   * @net:	Network namespace
> @@ -523,7 +560,7 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>  	const struct nft_pipapo_elem *e;
>  
>  	m = rcu_dereference(priv->match);
> -	e = pipapo_get(m, (const u8 *)key, genmask, get_jiffies_64());
> +	e = pipapo_get_slow(m, (const u8 *)key, genmask, get_jiffies_64());
>  
>  	return e ? &e->ext : NULL;
>  }
> diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> index d512877cc211..7a9900f8ce2f 100644
> --- a/net/netfilter/nft_set_pipapo_avx2.c
> +++ b/net/netfilter/nft_set_pipapo_avx2.c
> @@ -1149,9 +1149,9 @@ static inline void pipapo_resmap_init_avx2(const struct nft_pipapo_match *m, uns
>   *
>   * Return: pointer to &struct nft_pipapo_elem on match, NULL otherwise.
>   */
> -static struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
> -					       const u8 *data, u8 genmask,
> -					       u64 tstamp)
> +struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
> +					const u8 *data, u8 genmask,
> +					u64 tstamp)
>  {
>  	struct nft_pipapo_scratch *scratch;
>  	const struct nft_pipapo_field *f;
> diff --git a/net/netfilter/nft_set_pipapo_avx2.h b/net/netfilter/nft_set_pipapo_avx2.h
> index dbb6aaca8a7a..c2999b63da3f 100644
> --- a/net/netfilter/nft_set_pipapo_avx2.h
> +++ b/net/netfilter/nft_set_pipapo_avx2.h
> @@ -5,8 +5,12 @@
>  #include <asm/fpu/xstate.h>
>  #define NFT_PIPAPO_ALIGN	(XSAVE_YMM_SIZE / BITS_PER_BYTE)
>  
> +struct nft_pipapo_match;
>  bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
>  			      struct nft_set_estimate *est);
> +struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
> +					const u8 *data, u8 genmask,
> +					u64 tstamp);
>  #endif /* defined(CONFIG_X86_64) && !defined(CONFIG_UML) */
>  
>  #endif /* _NFT_SET_PIPAPO_AVX2_H */

-- 
Stefano

