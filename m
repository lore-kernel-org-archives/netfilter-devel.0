Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8418930EF75
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Apr 2026 10:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775903424; cv=none; b=n3KDQTHcudvNaFfdcvYQ0cyNUA08Ug1V08IX827qUpV3hMfMoBEgl86R/E3l6hHkJ8oZKKW3feo5nNDqAn5ymsx9gOEoD5VWBiBq2yZ/E8/jH38GXvLS/NMISXfCYcLN4+NpDo+GdadtX5B7638hFl3I5bd/ZdF5Cpb6EHfHO4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775903424; c=relaxed/simple;
	bh=BlsDnIpyQ2edA+Mw8uvEGYf7h9c+Qvrb9vOoXqC6qX4=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Date; b=hvK9+TgbaXCWvw3GiVgUQnTC4r/6SLTUFhNeHtBmqk+2hFzvRi9Q/1pKe8ExcaJGqE4pROx6XkcwuZrawpxOSiAscx2CZHSCRboDPdTOXSyIScYnE+Nal+eH0t7Uwo1s8ExuJhaTelePQGkCMn41H202pg8zeo1fUeDRhSB2Dgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NUidx1Em; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QP2imZAH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NUidx1Em";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QP2imZAH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775903421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zttWfNAU9bszYDSLsKexMXSNRnsuZv27wEPXhEv3yRU=;
	b=NUidx1EmJsc0He1iCroGe0N8V5cellLRK4lZItigr3qDExRYT8WsM79mYGV6ID5otUWfPe
	zKyYnyBwPEEjAbE6sF03nfE5E+kSQG6/pgb4LZlsX/31t1xbhzqUliklTawHiAXltiu8Oq
	kXYS6JhVHJJSCDvfXjlvubcF+X4eS5Y=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-l5ldTnL1Myi8ptaF5gYyFg-1; Sat, 11 Apr 2026 06:30:20 -0400
X-MC-Unique: l5ldTnL1Myi8ptaF5gYyFg-1
X-Mimecast-MFC-AGG-ID: l5ldTnL1Myi8ptaF5gYyFg_1775903419
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488c2764f83so19724625e9.2
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Apr 2026 03:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775903419; x=1776508219; darn=vger.kernel.org;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zttWfNAU9bszYDSLsKexMXSNRnsuZv27wEPXhEv3yRU=;
        b=QP2imZAH30IoR7iTNoVYpUGHsvs+1kL5esIHONqgKN5qqUtuzWvLyeZ0wI3atXieQ+
         q+47B6gupNizcf2cMRdqgWTGhyo86cvLtI84EJJMaSPH1/Kxrf4CTuk6wL7UsAN7lTax
         MLkJl/zGYW6gw6w1/YD8kNKriYIXkTHzg1PIuI1sed7NpwXePDsofOqMLOcfJGCmd+hh
         ibYB3x3jDnpjKGvDCAlN3EK1hLpJW86KJGafae4hZoExtLx69lGjZX3f9X9y70uL8+nC
         efU15guhDX615ak6sR75Q47ZI+J7EK5wKBbXzCXQt90ntQBGYMi1cAMEYfk6fftNjHT0
         njiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775903419; x=1776508219;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zttWfNAU9bszYDSLsKexMXSNRnsuZv27wEPXhEv3yRU=;
        b=gJ7uLf1P0nHjChUJNggKRYjz2RU9ygXjJOWymlQwzw3S4E0i/Ldh3Kq1x/9XPiW4r9
         bQqpS4uVtswg28Cx9PQgs1+jd0p02s+AnsmL1mXyOE472PEDneeClvE0r4c+8UtORA4h
         rm/CulkON9YVOB3TzoUs5JFKZjoy/KI69koNMEw+7IwQPR/XmhBoAu1v1N14Knkr5fK9
         yq6V+METetWycboSe4ay1NPvAzd2Wpw8YTiPPgUPMdVDDDKtdfi1wjK2QzZ0bzHFZleb
         gVlA5d1UyPAZOUsg6tP/1PxHoaMlNK4RbAPLbc5AL983ETacMi/UN414Rrp76ruPxBPU
         /Eyw==
X-Gm-Message-State: AOJu0Yw0JtHkNHSprHw1snj5R5SN7W+j9cu9TFaxwzMnsdWNMy2tWyUV
	fCNZaQlAvhWvreY5q93sfjXqXe4xIh39ZfWZ1bAbrJS1icIOBFIEuyDkYXTMsoP9y26N7wdev4Y
	I1Dc6VBa+0WmqgCRMdra4fIqSPbo6nXTm/9P0Tzu3LWfvocmQBHt5kDdnDpIvH89oVG6BYg==
X-Gm-Gg: AeBDies+9COtJODg0CocvXtdGbLHzp0G7RagRrq3PQ348JuWfyPTjCqI3CZFmHtZ743
	GMaEyHmTQPe+3sttAoBgzAnOkt3y9JiA4a5y6a/SNeoe4gU1tcdWNRifULoXP2Zjf1SnDBnxN11
	3bT86mXt3MsHa5I9Ac4+92RYDxp2nmjO+tfWbvFE/5mZm5+ETe7ufe27QhzpaND167WoZkQnJ4D
	u6sTKa5wwzbEDkvA4o/2yI52hCkXaXN7s/w3bwys7njjpbdbZKeYrl/wCTSlMpKEyQVDm8A03s8
	7y5yUre7ZWtMcizVOGnYvDex4G5s7lLnkVy/9Z1I+2UwN1/tiayPGw2Atprin7n+GT7/8KKdByP
	HnO+fNKk8TWWiBtlUQpOiptUTu1AjbAq918QE+qD+lcffLny1vg==
X-Received: by 2002:a05:600d:d:b0:485:4eaf:eb54 with SMTP id 5b1f17b1804b1-488d684b88amr66106505e9.20.1775903418573;
        Sat, 11 Apr 2026 03:30:18 -0700 (PDT)
X-Received: by 2002:a05:600d:d:b0:485:4eaf:eb54 with SMTP id 5b1f17b1804b1-488d684b88amr66106105e9.20.1775903417883;
        Sat, 11 Apr 2026 03:30:17 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5d80bafsm45856325e9.5.2026.04.11.03.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2026 03:30:16 -0700 (PDT)
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: nft_set_pipapo_avx2: restore
 performance optimization
Message-ID: <20260411123015.4a78f491@elisabeth>
In-Reply-To: <20260401110230.19226-1-fw@strlen.de>
References: <20260401110230.19226-1-fw@strlen.de>
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
Date: Sat, 11 Apr 2026 12:30:16 +0200 (CEST)

Sorry for the late review.

On Wed,  1 Apr 2026 13:02:27 +0200
Florian Westphal <fw@strlen.de> wrote:

> The avx2 lookup routines get the next map index to process passes as a
> function argument, but this isn't bery obvious because its hidden in the

Nits: very, it's

> lookup macro.

...right, I'm not exactly proud of it, but if we don't hide that stuff
the amount of visual noise explodes. I couldn't think of any better
solution.

> In commit 17a20e09f086 ("netfilter: nft_set: remove one argument from
> lookup and update functions") I incorrectly moved the "ret" scope into
> the loop.

This took me quite a bit to review because I stupidly assumed that that
commit was the same as the "return b;" -> "ret = b;" recent change :)
...that part is my fault of course, I didn't read the reference.

I really couldn't understand how turning those into "else if" would have
anything to do with the scope "ret"... until I realised and actually
read your reference. Oops.

But I have to say this was triggered by reading the next part which had
little to do with this...

> This has no effect on the correctness, but it can (depending on map sizes)
> cause a redundant repeat of an earlier processing step.
> 
> Restore the intended 'pass map index' instead of always-0.
> Note that I did not see any change in performance numbers, so
> an alternative would be to axe this optimization and go with
> slightly simpler code instead.

This probably depends a lot on the data set we're using. I'm not sure
if the current performance tests would consistently trigger a sparse
intermediate matching bitmap (between fields) with a lot of leading
zeroes.

By the way, I don't think a branch predictor could figure that out. So
all in all I would keep the optimisation you're restoring here.

> Additionally, a recent LLM review pointed out following "bug":
>  -------------------------------------------------------------
>  >               b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  >               if (last)
>  > -                     return b;
>  > +                     ret = b;
>  >
>  >               if (unlikely(ret == -1))
>  >                       ret = b / XSAVE_YMM_SIZE;  
> 
>  Does this change introduce a logic error when last=true and no match is
>  found? The old code used 'return b;' which immediately exited the loop. The
>  new code changes this to 'ret = b;' to allow loop continuation, but when
>  last=true and nft_pipapo_avx2_refill() returns -1 (no match found), the
>  execution flow becomes:
> 
>  1. ret = -1 (from 'if (last) ret = b;')
>  2. The condition 'if (unlikely(ret == -1))' evaluates to TRUE
>  3. ret = -1 / XSAVE_YMM_SIZE = -1 / 32 = 0 (integer division)
>  4. Loop continues with ret=0
> 
>  [..]
> 
>  Should this be changed to an else-if structure instead?
>  -------------------------------------------------------------
> 
> All call sites invoke nft_pipapo_avx2_refill() only when at least one
> bit in the map is set, i.e. nft_pipapo_avx2_refill() never returns -1.

It also took me a while to understand the actual reason behind this LLM
report.

It simply seems to be inferring that your patch introduced a control
flow change in a case that would never happen anyway, so that wasn't
expected, and even though it doesn't happen now either, it reports that
it was unexpected... not exactly useful.

But anyway:

> Add a runtime debug check that fires if we'd return -1 as additional
> documentation and also make the suggested change, code might be easier
> to understand this way.

...for me it's exactly as readable as before. If you think that it
might be easier to understand this way, though, I guess that's a good
indication that it's better to change it. So, either way:

> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

> ---
>  net/netfilter/nft_set_pipapo_avx2.c | 35 ++++++++++++-----------------
>  1 file changed, 14 insertions(+), 21 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> index dad265807b8b..b3f105520a85 100644
> --- a/net/netfilter/nft_set_pipapo_avx2.c
> +++ b/net/netfilter/nft_set_pipapo_avx2.c
> @@ -144,6 +144,7 @@ static void nft_pipapo_avx2_fill(unsigned long *data, int start, int len)
>   * This is an alternative implementation of pipapo_refill() suitable for usage
>   * with AVX2 lookup routines: we know there are four words to be scanned, at
>   * a given offset inside the map, for each matching iteration.
> + * The caller must ensure at least one bit in the four words is set.
>   *
>   * This function doesn't actually use any AVX2 instruction.
>   *
> @@ -179,6 +180,7 @@ static int nft_pipapo_avx2_refill(int offset, unsigned long *map,
>  	NFT_PIPAPO_AVX2_REFILL_ONE_WORD(3);
>  #undef NFT_PIPAPO_AVX2_REFILL_ONE_WORD
>  
> +	DEBUG_NET_WARN_ON_ONCE(ret < 0);
>  	return ret;
>  }
>  
> @@ -243,8 +245,7 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
>  			ret = b;
> -
> -		if (unlikely(ret == -1))
> +		else if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
>  
>  		continue;
> @@ -320,8 +321,7 @@ static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
>  			ret = b;
> -
> -		if (unlikely(ret == -1))
> +		else if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
>  
>  		continue;
> @@ -415,8 +415,7 @@ static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
>  			ret = b;
> -
> -		if (unlikely(ret == -1))
> +		else if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
>  
>  		continue;
> @@ -506,8 +505,7 @@ static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
>  			ret = b;
> -
> -		if (unlikely(ret == -1))
> +		else if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
>  
>  		continue;
> @@ -642,8 +640,7 @@ static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
>  			ret = b;
> -
> -		if (unlikely(ret == -1))
> +		else if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
>  
>  		continue;
> @@ -700,8 +697,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
>  			ret = b;
> -
> -		if (unlikely(ret == -1))
> +		else if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
>  
>  		continue;
> @@ -765,8 +761,7 @@ static int nft_pipapo_avx2_lookup_8b_2(unsigned long *map, unsigned long *fill,
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
>  			ret = b;
> -
> -		if (unlikely(ret == -1))
> +		else if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
>  
>  		continue;
> @@ -840,8 +835,7 @@ static int nft_pipapo_avx2_lookup_8b_4(unsigned long *map, unsigned long *fill,
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
>  			ret = b;
> -
> -		if (unlikely(ret == -1))
> +		else if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
>  
>  		continue;
> @@ -926,8 +920,7 @@ static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
>  			ret = b;
> -
> -		if (unlikely(ret == -1))
> +		else if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
>  
>  		continue;
> @@ -1020,8 +1013,7 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
>  			ret = b;
> -
> -		if (unlikely(ret == -1))
> +		else if (unlikely(ret == -1))
>  			ret = b / XSAVE_YMM_SIZE;
>  
>  		continue;
> @@ -1143,6 +1135,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
>  	const struct nft_pipapo_field *f;
>  	unsigned long *res, *fill, *map;
>  	bool map_index;
> +	int ret = 0;
>  	int i;
>  
>  	scratch = *raw_cpu_ptr(m->scratch);
> @@ -1167,8 +1160,8 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
>  
>  	nft_pipapo_for_each_field(f, i, m) {
>  		bool last = i == m->field_count - 1, first = !i;
> -		int ret = 0;
>  
> +		/* NB: previous round @ret is passed to avx2 lookup fn */
>  #define NFT_SET_PIPAPO_AVX2_LOOKUP(b, n)				\
>  		(ret = nft_pipapo_avx2_lookup_##b##b_##n(res, fill, f,	\
>  							 ret, data,	\

-- 
Stefano

