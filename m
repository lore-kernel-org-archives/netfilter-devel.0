Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CCF192590
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 14:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774103115; cv=none; b=EZPy/JW80yP2ztKTRAv/OGby2QywaTYQFFX0Gx+z7kU5lH8FKGcrOzd2bHRec66PjvxCiWdZOO859oqEs6g07U5WCMJQEqbY+4I12n121IpSDYcgYMl7+NVmjHGTStZa/NuZ8nFaIwvJBqu5gn819wQESV3+Z0GtRgJTP4Ohv64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774103115; c=relaxed/simple;
	bh=E73RFIY7CtPcup/Lt3JsX5xUpf0eC0CkkL37SRBckzk=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Date; b=hHph5ENEWzH2LyqBGLntmSa7IcSU1ArAA+Kpro4LCaO1lEDfUmYOgeH3DZs+0F4HYwfqXY57mXVmyYw/FpWCgU8SNb97hsIQFyeyriGPiHuksYzKhTdhknStfvgppkhYrdNnshwUeR/E1Nm3HH8Dqr4qpEIm+v7mgM1Fj3wHPMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HkpZ1YIr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q1U8xwOS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HkpZ1YIr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q1U8xwOS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774103113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wkISwhNpYjYzGuPlz05CYC0bcb2vMc8u+l+cpPrqhyE=;
	b=HkpZ1YIrcp+8VZn+JVtNpuWWoQoo4rOL+tuWx2w1h95pOvyY7f3AL0xq9CPmgVLwX5hVKC
	K+RKB2KGg+GQeztjaqPU6PrHb7uwUypotJ2mj7OMUyzsgQ7H9hkEOQ6bmm+hynmbXytY2f
	4divN1zVA2jVy6O75YrvlValzjc/nNk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-fZeZRcAkN1-7TQR6MG_Jtw-1; Sat, 21 Mar 2026 10:25:11 -0400
X-MC-Unique: fZeZRcAkN1-7TQR6MG_Jtw-1
X-Mimecast-MFC-AGG-ID: fZeZRcAkN1-7TQR6MG_Jtw_1774103110
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-439b8bc43aeso1833849f8f.1
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 07:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774103110; x=1774707910; darn=vger.kernel.org;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wkISwhNpYjYzGuPlz05CYC0bcb2vMc8u+l+cpPrqhyE=;
        b=Q1U8xwOSebcWD4jvYuMDr1FguRFbZkShpNQMxCpzF3BpxkCoqQvtFGJFSLjDs20KmK
         /sYQZDdBwJv/vQP3KokTyoNhGJpi06LoIduCAbSUA1cWuBpFEwUi6OUZvwjomd6f2DNH
         RmBjq7Z945CzwgShIdNKFC/zNBLl7xZjhWyKL6kcthKlcEZzjdMCxNrY+tU0SNpchJhU
         oruiKh7U63WYXtiy41tqpTlAMmf9TQ8uVy3RzDko4mdLklcCLaSynE6i5cN8+Gd5FbFN
         trVnrNCbetTtZFaUbYrA4Q5nQbqfJs0s7aNwRmepQKG7eMFjIBahMb31saK1nXzL4rJA
         oqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774103110; x=1774707910;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wkISwhNpYjYzGuPlz05CYC0bcb2vMc8u+l+cpPrqhyE=;
        b=Tt99zuHssOZybs4x3HBSVXtuAs58617TeJNe/d6Vw5s+FrIc2rAdLucz0ABjvcZAq1
         +D2K7aQy9vN2EyUYotWcN6iNUzVkxRuuf+xrWvhl98HRf9J6+TDHTIY7QMmFbIidCKuG
         +79PDVAe3hzXlUKHmLBJnjzQBgUWjRt751X5ivY8IAvjf4/yyA9ei7eaJt/1fKG+FiVb
         eO9tUa2Rpr9IOdnZtUNfkA/1BHyEXy1HR9nqv1yxMDYyZRe55exKBLW1wMCqoHeaOlwU
         pr3WLjpgQa3eTmmhC6vjzvfTc0dgcf97FJoCc31zidqtc64APzkX1CjTpOquhNV27FPu
         rdkA==
X-Gm-Message-State: AOJu0YxHBpbTC5CdLqU27MXqRVBoCzn7nk70m7n+3YZXnd54pLKC94ol
	ixP/ZqkjXMQOrt5y2ZvEmF2NSjsNNucb0DD8JFILYHyOQk8jiZ/gxTBwTPDyY+2bJtp/irRaJTP
	xO+Zn0fZTlcTvEPC+FcEeUGt5Tu+lAEwijpGzDy4r1GfgTrTzgkge0Tvn2e8Yi+cNd9HFUR0aVu
	JbNA==
X-Gm-Gg: ATEYQzw8F2Rqd8LqE6VrZGDcNpmvqve8k1iNIq3e29vH0UGdhWpv2p9QjwyOHP1cyFh
	xf525jSliJt9pc726IxxTUu9Ak1U+CELXjx7kKtfgZSFiJceDe7GsOZuYtqcnriu5zG2tcQ0peq
	2ig5rChLmPWuha27abR1cYkFVwqZRsiNveGOTLnXRmeduX6ZK+R3vShdBcPvcT47Rx9JNX+KRDY
	z8pstuirqTEuzKXy3ukrcVA+qt4oXhU3z2C26MaJtPjHEtzRCLf9qkfjgn1mnqvlu16+tqEL5fu
	GDmQheaG/gsTkDwsICQNUX9dSPNepAXRBrD9TlTt5A4t++zT4m06WS4Hsoi/uZvE2QTYOrbbsO5
	+3scbjA6H9oqcsDc626d5tqR+cxwO4A/2
X-Received: by 2002:a05:6000:26cd:b0:439:de1d:74c6 with SMTP id ffacd0b85a97d-43b6424a89amr10850539f8f.19.1774103109806;
        Sat, 21 Mar 2026 07:25:09 -0700 (PDT)
X-Received: by 2002:a05:6000:26cd:b0:439:de1d:74c6 with SMTP id ffacd0b85a97d-43b6424a89amr10850497f8f.19.1774103109272;
        Sat, 21 Mar 2026 07:25:09 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644bdaf8sm16484884f8f.13.2026.03.21.07.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 07:25:08 -0700 (PDT)
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf 1/2] netfilter: nft_set_pipapo_avx2: don't return
 non-matching entry on expiry
Message-ID: <20260321152506.037f68c0@elisabeth>
In-Reply-To: <20260318132417.31661-2-fw@strlen.de>
References: <20260318132417.31661-1-fw@strlen.de>
	<20260318132417.31661-2-fw@strlen.de>
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
Date: Sat, 21 Mar 2026 15:25:07 +0100 (CET)

On Wed, 18 Mar 2026 14:24:13 +0100
Florian Westphal <fw@strlen.de> wrote:

> New test case fails unexpectedly when avx2 matching functions are used.
> 
> The test first loads a ranomly generated pipapo set
> with 'ipv4 . port' key, i.e.  nft -f foo.
> 
> This works.  Then, it reloads the set after a flush:
> (echo flush set t s; cat foo) | nft -f -
> 
> This is expected to work, because its the same set after all and it was
> already loaded succesfully once.
> 
> But with avx2, this fails: nft reports a clashing element.
> 
> The reported clash is of following form:
> 
>     We successfully re-inserted
>       a . b
>       c . d
> 
> Then we try to insert a . d
> 
> avx2 finds the already existing a . d, which (due to 'flush set') is marked
> as invalid in the new generation.  It skips the element and moves to next.
> 
> Due to incorrect masking, the skip-step finds the next matching
> element *only considering the first field*,
> 
> i.e. we return the already reinserted "a . b", even though the
> last field is different and the entry should not have been matched.
> 
> No such error is reported for the generic c implementation (no avx2) or when
> the last field has to use the 'nft_pipapo_avx2_lookup_slow' fallback.
> 
> Bisection points to
> 7711f4bb4b36 ("netfilter: nft_set_pipapo: fix range overlap detection")
> but that fix merely uncovers this bug.
> 
> Before this commit, the wrong element is returned, but erronously
> reported as a full, identical duplicate.
> 
> The root-cause is too early return in the avx2 match functions.
> When we process the last field, we should continue to process data
> until the entire input size has been consumed to make sure no stale
> bits remain in the map.

Oops, thanks for fixing this. It must have been a lot of "fun" to debug
it.

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

An explanation below.

> An alternative fix is to change the avx2 lookup functions to also
> return the last 'i_ul' (map store location) and then replace:
> 
> 	if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||
>                      !nft_set_elem_active(&e->ext, genmask))) {
> 		ret = pipapo_refill(res, f->bsize, f->rules,
> 				    fill, f->mt, last);
> 		 goto next_match;
>  	}
> 
> With:
>             if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||
>                          !nft_set_elem_active(&e->ext, genmask))) {
> 		if (slow)
>                       ret = pipapo_refill(res, f->bsize, f->rules,
>                                           fill, f->mt, last);
> 		else
> 		      ret = nft_pipapo_avx2_refill(i_ul, &res[i_ul], fill, f->mt, last);
>                                           fill, f->mt, last);
>                  goto next_match;

By the way, there are some mixed spaces and tabs and one duplicate
line in these snippets, which make them a bit hard to understand, they
should be:

	if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||
		     !nft_set_elem_active(&e->ext, genmask))) {
		ret = pipapo_refill(res, f->bsize, f->rules,
				    fill, f->mt, last);
		goto next_match;
	}

and:

	if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||
		     !nft_set_elem_active(&e->ext, genmask))) {
		if (slow) {
			ret = pipapo_refill(res, f->bsize, f->rules,
					    fill, f->mt, last);
		} else {
			ret = nft_pipapo_avx2_refill(i_ul, &res[i_ul],
						     fill, f->mt, last);
		}

		goto next_match;
	}

> ... so that irrelvant map parts aren't considered. However, the diffstat
> is significantly larger than this one.

Right, yes, I don't think it's worth it. The extra branch might
actually make things slower.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo_avx2.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> index 7ff90325c97f..6395982e4d95 100644
> --- a/net/netfilter/nft_set_pipapo_avx2.c
> +++ b/net/netfilter/nft_set_pipapo_avx2.c
> @@ -242,7 +242,7 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
>  
>  		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
>  		if (last)
> -			return b;

This came from this kind of optimisation:

  https://pipapo.lameexcu.se/pipapo/tree/avx2.h?id=a724e8dbd67ce3d9bf5a24bd836dea4ad3a5516f#n59

		if (!_mm256_testz_si256(r4, r4)) {
			if (last) {
				_mm256_store_si256((__m256i *)(map + i), r4);
				return i;
			}
			ret = 0;
		}

which, however, is only applied if the register with the current
matching results is all zeroes, *and* I think it's incorrect anyway as
it would only work for a 32-byte sized bucket (single iteration).

I think it's a left-over from the previous stage of implementation
where I only had 32-byte sized buckets for simplicity.

Now, we could probably reintroduce this kind of implementation on the
lines of what you suggested but a long branch like that doesn't look
promising in terms of clock cycles.

-- 
Stefano

