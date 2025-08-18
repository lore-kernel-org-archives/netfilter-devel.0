Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66908272807
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 18:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755543372; cv=none; b=Zemjb7a00CLHm/S/O4XjKlc44EcJ5Z88eWPzqOk9sRuvhn//sgNXtLK3Z6RGAzCCKbQhW5P2nb8aYRZsf1NaS547pba8pk/Yx8fbSEcf6GICv1/ggZTH7WUxh8p9usAlgMjgf8NKih8JvfR3jHG6Ia2yE08z4bv2CKfwOrpb1KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755543372; c=relaxed/simple;
	bh=WQPfWV9RsjW54pdiLa0gNn3y05kdz7zTcjxEiKHz73w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gmyWKkWshnzrnaYGjFxurbMmCQYbMix7fJkTLD9eIsi9/YNCHgLUJ/MIF6INiKrX8eKyB6POcAPozFwq6WroNNm79ONeMXOlxnQlOrAZHzLAnepAUg9YioZBgIuN5YtLT+Bx6ajUsLmGqu6llCqsq5LgHbfvsauNcfH2Yxo4FiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y/COwijI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y/COwijI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755543370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kekjQDWSmqTEBhPDzSV7nug6S3j8pgVGHUyR2svlDnI=;
	b=Y/COwijIWwvWhtWJq2/OiVRiE2RERvV0cnfqzFJtlX6ysRV3lBx/IkVjaG2c252xDh4oYI
	Wk7frzpUsv9x1rBlrQhmAd4PZTOUlBG6q4YE38sb9L8HQ0UlQIDBT902XerR/RFoeHvpBl
	PkoC7ymv3mezlWKyDniksiuTnIR1j1U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-2etiwKbRNCaIx0wEWm4KrA-1; Mon, 18 Aug 2025 14:56:08 -0400
X-MC-Unique: 2etiwKbRNCaIx0wEWm4KrA-1
X-Mimecast-MFC-AGG-ID: 2etiwKbRNCaIx0wEWm4KrA_1755543368
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0514a5so19802985e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 11:56:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755543367; x=1756148167;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kekjQDWSmqTEBhPDzSV7nug6S3j8pgVGHUyR2svlDnI=;
        b=WbIvGIHxiaN2c739aIkyrXhQgiclqjOr644RgJBIGj5vpUHGWg2nu6fl6S2TUVEIgc
         n9Z5ZHGwCvxQhxvoqLnwaO5+XV2hNI0Q+IO21nfMmiaVU2XyG62uxTj7T9a/3jX6LiNp
         uZtG1cZv5mJnOhpdwLrSQpzEpHuz/4o55MYskSsogEPNWJDke+hVJADTC7n+siIS2Yut
         GRkbEC7gEwlsaw0JLdh/byXhL0Qc5yMxcYBwcIYeYjgSFw0XDqrJa6JqjoeOHgL2Rhh9
         talh/o44g4HXdtbis6mXVhQmo0CRANvpeL7K1JtINtSfI8zqzfL0mDDImNFad7OWpAMz
         JaLQ==
X-Gm-Message-State: AOJu0YzEU0C6MniGNe0QT+oOLOih3rVH+tSv/mVtRk49gm8jMd+NvuHa
	4iYeG1zix2CMGdyUicyroayFS0ZmTdZ7gt9jMnwflEG6khesoosGYGmvDIz5sQLjuwRjUmdoL/h
	71FZngxtn7niHs0y/8EFYt+nDUzfZuNnOGIKifV74dbrHPxo2T5IbobZn0CsnrlX68F12Pw==
X-Gm-Gg: ASbGnctcxiuIQFEKhQPbDhZitKQp5v3oSAlerD2jLGfK3puSd4C5ySriSU0YhqtB+1e
	J1znuj46KWuVPPrU5UTaNbcGCWJAyI9TfEU/pAGAEIaLwMM3jWlhEEoUB6SSRg7PpA1zGfJ4hiQ
	ZSwv0kGSE1c7jZUt+N1Iy7kHCtNPcGFklOHquAvE1nxPujlSwlzdg85/4DT8LKIDpZ8cjbEe3+U
	uP+fZwBLRyf7XVuD6wxkJuv4UOtTfwfGc8cTfPNzY2pmyX0wDFPToMPCp3EBFewoxlE+ZNAn7Ih
	9W3E6yPFNpizAu3KGYSfRKHTk5gb4CSpYfbzi+5GKsYeGe0HtgI=
X-Received: by 2002:a05:600c:4447:b0:456:3b21:ad1e with SMTP id 5b1f17b1804b1-45b43660ea2mr1132155e9.17.1755543367538;
        Mon, 18 Aug 2025 11:56:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHShsY2OoQ3daRQdf8+95cj0aoxkpc3d8VIll8Kg+xf3QCoFea6yKiqmroexrb7GYuexuroLQ==
X-Received: by 2002:a05:600c:4447:b0:456:3b21:ad1e with SMTP id 5b1f17b1804b1-45b43660ea2mr1132005e9.17.1755543367156;
        Mon, 18 Aug 2025 11:56:07 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b793f37sm112570475e9.2.2025.08.18.11.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 11:56:06 -0700 (PDT)
Date: Mon, 18 Aug 2025 20:56:05 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/2] netfilter: nft_set_pipapo: use avx2
 algorithm for insertions too
Message-ID: <20250818205605.3cf49465@elisabeth>
In-Reply-To: <aKNv_lcbE6kMtqws@strlen.de>
References: <20250815143702.17272-1-fw@strlen.de>
	<20250815143702.17272-3-fw@strlen.de>
	<20250818183227.28dfa525@elisabeth>
	<aKNv_lcbE6kMtqws@strlen.de>
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

On Mon, 18 Aug 2025 20:25:02 +0200
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
> > > +static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
> > > +					  const u8 *data, u8 genmask,
> > > +					  u64 tstamp)
> > > +{
> > > +	struct nft_pipapo_elem *e;
> > > +
> > > +	local_bh_disable();
> > > +
> > > +#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
> > > +	if (boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX) &&  
> > 
> > I don't have any straightforward idea on how to avoid introducing AVX2
> > stuff (even if compiled out) in the generic function, which we had
> > managed to avoid so far. I don't think it's a big deal, though.  
> 
> It could be hidden away in a static inline helper if that makes it more
> acceptable.

I think that would just make it... hidden. I'd rather leave it like it
is.

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

