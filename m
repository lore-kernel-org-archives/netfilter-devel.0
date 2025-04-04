Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED65717A305
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Apr 2025 08:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743755696; cv=none; b=cgSpm2vHrZ6DYs3UncYGoxm3gR0BHNPOBcbQG3FLGE629cFnzkdwnUeDrBYRQMrgii0WyqhlYDFtqHsr6s/q1JIL0jiU0Rhaex48pQz+pABhNB3KZB9j9hDsAq59C/5xH4Rnc8FWqOdUZUUYvBtIDFRdyER2k11wcvkg9D9qHs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743755696; c=relaxed/simple;
	bh=gFDjoSNrjw+xb2FYMeU1DaqhTWKZmDy4CYJ4ninyMR0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C94/0nHMU3Kl/ztm0nTriYG5yu79rH0Rgnv7qe3SE15aizyKkDd36ziw/xreypVOSeD4+awKzILyoXXGkjJDNenMslmWm36AOJ3vJplgNvdPDHYrvM5p7lPiiktVCvIR6RUTbvlzPSBuI0lx5WUeRiqy2jwb6M3tUvoOkLOwUGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gsg8Hlj7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gsg8Hlj7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743755693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F5GHs9npPSO99/d0UD+w8GPMRD5PNjloh1qA7OzMVSA=;
	b=Gsg8Hlj74M48DXXVFj+zQ2lG5ItznN/p6eZBtQRsWjShywAkGcUP/xdqvYvzw1YYtWISES
	hgq73MBfvHL+T9fz/G46Oi+vc+w0+plr7ZvnqGyn+F3VTBNEbt+RHZds3qpOf0w/8gQbru
	qWJT+2JQwwQ/l4zRG4/8+nCJrTW+wS0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-FiN617lsMoGHjNnQy_g__Q-1; Fri, 04 Apr 2025 04:34:52 -0400
X-MC-Unique: FiN617lsMoGHjNnQy_g__Q-1
X-Mimecast-MFC-AGG-ID: FiN617lsMoGHjNnQy_g__Q_1743755691
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39c184b20a2so1013468f8f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Apr 2025 01:34:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743755690; x=1744360490;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F5GHs9npPSO99/d0UD+w8GPMRD5PNjloh1qA7OzMVSA=;
        b=kyEtSGBp4lNadgz6k7KWiszvsYTBq2bQr5LxV7wMsd3TmiBAhdY6jZSj/fClGeVBB1
         PF/hn1gw6zutIOwL5uBEoPD3E6Wq5iwSJtqDUo/S5SNiHatIAYIPMXj7wkjt2ahR12IA
         bDtZZZteEYRuoOc+H3XJ4C3b1lbv440L9EfGP0L4f7QeIRkoUGGWsjOHkeRZHVdefPBw
         QvtwbCp+GosoIzDHX5+Sy/45ytLLBuu5VqdL2XrMCrAK0+KQzwctT9xNBq/G7KVDA6BK
         qWCN6cDqaf0TZAmIPykotYSidu6kAzMnqM21Fm2sypSamDxyinXr2Fu/hGkAGUpei4ga
         SyiQ==
X-Gm-Message-State: AOJu0Yyra+0UCo32n5FdidjFdWKAkkcxfd0cRGUvPnCiaA2XCqFNScDC
	bM6zsTVlmNs+T9TJplQD4J4oCHYSybDQeCmN2TKnCJ8CJYJEqfxMoLcaTdeo0lKLBU0Zpn5ldmb
	5XI5LbZUe9bEaPciVpl13uwummRsu0pzVx79zhtv/kEu9Sx16yr/zgzc30uFx8M/nAeSVVpc5CQ
	==
X-Gm-Gg: ASbGnctz0Fh1UIPr880/Vaw5siQPxVCWa8Feg5C1HSeGloPpmWq56/FSvQblwjX2ezG
	6GM6HOk/SMqcaC8iyC4fUgXmrc0apVKSFv+Kflcwn9K7pf2ys7cJFvRkdrqW8yK6/ucirjKrvDK
	5CL80GNLQCFZ04iMp0Yyjz+4pQnQLjmw9tUX4szY/daB+mm4ogT5JIgdanksvz2hv12GrsolpYi
	cDKXdOVC4F1Aj1zwS+ymMjRBNGL6c+pba67UvWdKZRxVR5/ywMOEetDZuTg5yEVKVtHOBGro1fC
	DS2BcijgkEvfDycCw144RoATnQ6OmHWo5A7gRfTk512C
X-Received: by 2002:a5d:64c3:0:b0:390:f9d0:5e4 with SMTP id ffacd0b85a97d-39cb3595eb1mr1727203f8f.21.1743755689966;
        Fri, 04 Apr 2025 01:34:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWQ/HtRtmnPxmtoqwX/dpE5yyDxuOISuFdE2MCDE1rl3mVLpLo3GG0SVwKjECgkI1gQ/40dA==
X-Received: by 2002:a5d:64c3:0:b0:390:f9d0:5e4 with SMTP id ffacd0b85a97d-39cb3595eb1mr1727186f8f.21.1743755689584;
        Fri, 04 Apr 2025 01:34:49 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec34be2ffsm39326805e9.22.2025.04.04.01.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 01:34:48 -0700 (PDT)
Date: Fri, 4 Apr 2025 10:34:47 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>, sontu21@gmail.com
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf 2/3] nft_set_pipapo: fix incorrect avx2 match of 5th
 field octet
Message-ID: <20250404103447.6f767eed@elisabeth>
In-Reply-To: <20250404062105.4285-3-fw@strlen.de>
References: <20250404062105.4285-1-fw@strlen.de>
	<20250404062105.4285-3-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  4 Apr 2025 08:20:53 +0200
Florian Westphal <fw@strlen.de> wrote:

> Given a set element like:
> 
> 	icmpv6 . dead:beef:00ff::1
> 
> The value of 'ff' is irrelevant, any address will be matched
> as long as the other octets are the same.
> 
> This is because of too-early register clobbering:
> ymm7 is reloaded with new packet data (pkt[9])  but it still holds data
> of an earlier load that wasn't processed yet.
> 
> The existing tests in nft_concat_range.sh selftests do exercise this code
> path, but do not trigger incorrect matching due to the network prefix
> limitation.
> 
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Reported-by: sontu mazumdar <sontu21@gmail.com>
> Closes: https://marc.info/?l=netfilter&m=174369594208899&w=2
> Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo_avx2.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> index 8ce7154b678a..87cb0183cd79 100644
> --- a/net/netfilter/nft_set_pipapo_avx2.c
> +++ b/net/netfilter/nft_set_pipapo_avx2.c
> @@ -1120,8 +1120,9 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
>  		NFT_PIPAPO_AVX2_BUCKET_LOAD8(5, lt,  8,  pkt[8], bsize);
>  
>  		NFT_PIPAPO_AVX2_AND(6, 2, 3);
> +		NFT_PIPAPO_AVX2_AND(3, 4, 7);
>  		NFT_PIPAPO_AVX2_BUCKET_LOAD8(7, lt,  9,  pkt[9], bsize);
> -		NFT_PIPAPO_AVX2_AND(0, 4, 5);
> +		NFT_PIPAPO_AVX2_AND(0, 3, 5);

Ouch, this is embarrassing, so it's great to see 1/3 and the fact that
it doesn't trigger other splats is a big relief.

Thanks Florian for fixing this and thanks Sontu for the detailed
report. I'm still reviewing patches 1/3 and 3/3.

If it matters, for now, for this one,

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

