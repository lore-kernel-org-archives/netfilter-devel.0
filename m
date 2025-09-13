Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F9B139E
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Sep 2025 00:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757722416; cv=none; b=XCleaVeCftnF4R+HpaTmJ8INRFfjxk2fGQzLVGUwC+JEW8VbrXsn13wwIWAuG6i/C00C7ByL0N0T9sKPPJrWYwsC1U9ZSbGSF/KW4epuoSqeg3+3tEZ1R22ELfocKIoh42Od49q3gzHQX0F4RBuqZUgfQUp3owDt0EHf/L3bU1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757722416; c=relaxed/simple;
	bh=xJz1ypkO+iHh9sSLvrzQLUeaM0QPYZ8HgipyUwFfb5E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aD6xiwoukGpqA2YQdkppoMirlqoRKlTr3B8KQBxblUsMTTHx2U3G06DtLd85azkA4LVqTxj3gUyEDI8Aa0Ie8W/0Swgdo/PaI/h/xwNVISQ538wLg+V3/vRLMXur1fMthPMQk6qnFrEo6qc0z7i53VGgjHaDLiOxbRQ/3sSd6dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G6eJ8IcY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G6eJ8IcY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757722413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z8To5vrkKZbmZ8g4l3TF/cbxMiVvXVHT+TK/SKk9VTA=;
	b=G6eJ8IcYhQ3zvz3MmkG0QHa1fkDZ7dCbnrOWsy1UqMShnjYA6pA2N5AD/KbkVRrIKA8nij
	Rc4Ac4x6ncKRMHoU2DqcTduSlhd4mcgj9K+Wvl78KPSc2MVAhzhCpO3BKeClDQDKudqTXn
	/YXhTyhf1R9QOMLgmxL+ctSGvfKqhpU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-tqFlIQVZORqRbx7rh8HAwQ-1; Fri, 12 Sep 2025 20:13:32 -0400
X-MC-Unique: tqFlIQVZORqRbx7rh8HAwQ-1
X-Mimecast-MFC-AGG-ID: tqFlIQVZORqRbx7rh8HAwQ_1757722411
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3e76376cc75so1129306f8f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Sep 2025 17:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757722410; x=1758327210;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z8To5vrkKZbmZ8g4l3TF/cbxMiVvXVHT+TK/SKk9VTA=;
        b=T1LxG7ewZHxEgTIV4WmSqkWm/3rZj9wVNhIEuL06+8QuyPTY3X53esc4Yw5r4yMpj7
         Dy/0wnNvfSonAQuDf7GvcypXTsMltOB+DVue8gEiy0BEuSAIPaSi4YSw3zHiMI4cARqK
         8+wUxGmYmmDncZpeDjbQPnEIlm/iQbKUzfeGlL+TU0+uMATTo1/TbeN6rqQrvs5qkgaK
         jwnWLbt23xVsWMhhXfjEqMV1h7jNu6lkUX7FPOcJiaCZu4Zvx19RomVpSyKBxyaBfdm8
         KShMmlQhH5UqpZdfVxLLZ6a6TaCMtMVz68r60KFQH5lNyBpT4xxkJsxwDTgr383+PX7V
         pP+A==
X-Gm-Message-State: AOJu0YzvIo6872WvslE+dx6JYqnh0ZY0R4qVmYG35EJ5uPX6sxLrPkWB
	PVet2yBpxAsCiwI1KxygVclqfZhMSy55Sa0/wqhPJBpTDkmvxnNc1ij2leKneTlAw5XNKjy0x2Y
	S/a1xln8ahGDusZkoCJd/z2wq6R/a66G0IxX4ww7tZJKBStlMSnQx1rJ1H/cbDFOAc/9Y5efShq
	MLAg==
X-Gm-Gg: ASbGnctd/80hp9HZuuNoy0bwuxR4bvn8wN5Cv7k/Um7i5+D7howniZo1bEzrZdIW6L1
	Q/rW9mqutDQfx4laa3dF7dXSsgXylIA2+BbkPkLHBxcFtHkYmDSrRBeGjX4Xr7rsB9s37r3sHpC
	NiazwI/MH7cB3vvTleNMj32FU2/7zMtkdXfAPulF+x5kWWKKyAEXHAo7PMzQmzzTPpsWx58jpnD
	vDWP7HPeaYFww1YzbIC7GS2ZwvniBMkSj7aQJN1rwG/ujha63wIHXUDHMTyHCMbN+qij+pwz3Ar
	LTyn3yqFEJRMHzXZpcUY+fgW6wpimJ/uIcRVeGTsjpcBvsM4KRdTc0zs7qZMPCD9+7Vw
X-Received: by 2002:a05:6000:2509:b0:3e3:6b81:b482 with SMTP id ffacd0b85a97d-3e7657995f7mr4552493f8f.28.1757722409915;
        Fri, 12 Sep 2025 17:13:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSxz3iSnaHyhsYqmr51YMB4zc/d8HEfwlnwkrNAaY5pkPiz5nF3LXatbN9iSM602PnUOGSJQ==
X-Received: by 2002:a05:6000:2509:b0:3e3:6b81:b482 with SMTP id ffacd0b85a97d-3e7657995f7mr4552479f8f.28.1757722409519;
        Fri, 12 Sep 2025 17:13:29 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607ccf93sm8308810f8f.38.2025.09.12.17.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 17:13:28 -0700 (PDT)
Date: Sat, 13 Sep 2025 02:13:26 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH RFC nf-next 1/2] netfilter: nft_set_pipapo_avx2: fix
 skip of expired entries
Message-ID: <20250913021326.52fc3ca6@elisabeth>
In-Reply-To: <20250912132004.7925-1-fw@strlen.de>
References: <20250912132004.7925-1-fw@strlen.de>
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

On Fri, 12 Sep 2025 15:19:59 +0200
Florian Westphal <fw@strlen.de> wrote:

> KASAN reports following splat:
> BUG: KASAN: slab-out-of-bounds in pipapo_get_avx2+0x941/0x25d0
> Read of size 1 at addr ffff88814c561be0 by task nft/3944
> 
> CPU: 7 UID: 0 PID: 3944 Comm: nft Not tainted 6.17.0-rc4+ #637 PREEMPT(full)
> Call Trace:
>  pipapo_get_avx2+0x941/0x25d0
>  ? __local_bh_enable_ip+0x116/0x1a0
>  ? pipapo_get_avx2+0xee/0x25d0
>  ? nft_pipapo_insert+0x22b/0x11b0
>  nft_pipapo_insert+0x440/0x11b0
>  nf_tables_newsetelem+0x220a/0x3a00
>  ..
> 
> This bisects down to
> 84c1da7b38d9 ("netfilter: nft_set_pipapo: use AVX2 algorithm for insertions too"),
> however, it merely uncovers this bug.
> 
> When we find a match but that match has expired or timed out, the AVX2
> implementation restarts the full match loop.
> 
> At that point, data (key element or start of register space with the key)
> has already been incremented to point to the last key field:
> out-of-bounds access occurs.

Oops.

By the way, you're referring to 'rp' here, and nothing else, right?
Could you mention that explicitly if that's the case? I have to say
that "data (...) has already been incremented" took me a while to
understand.

> The restart logic in AVX2 is different compared to the plain C
> implementation, but both should follow the same logic.

That's because I wanted to avoid calling pipapo_refill() from the AVX2
lookup path, as it was significantly slower than re-doing the full
lookup, at least for "net, port" sets which I assumed would be the most
common.

On the other hand, it should always be a corner case (right?), so I
guess simplicity / consistency should prevail.

> The C implementation just calls pipapo_refill() again to check the next
> entry.  Do the same in the AVX2 implementation.

An alternative would be to reset rp = key, but maybe what you're doing
is actually saner, see above.

> Note that with this change, due to implementation differences of
> pipapo_refill vs. nft_pipapo_avx2_refill, the refill call will return
> the same element again, then, on the next call it will move to the next
> entry as expected.  This is because avx2_refill doesn't clear the bitmap
> in the 'last' conditional.  This is harmless.
> 
> A selftest test case comes in a followup patch.
> 
> Sent as RFC tag because it needs to be revamped after net -> net-next
> merge, there are conflicting changes in these two trees at the moment.
> 
> Another alternative is to retarget this patch to nf, but given its
> a day-0 bug that only got exposed due to the use of AVX2 in insertion
> path added recently I think -next is fine.
> 
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo_avx2.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> index 7559306d0aed..d97b67a4de16 100644
> --- a/net/netfilter/nft_set_pipapo_avx2.c
> +++ b/net/netfilter/nft_set_pipapo_avx2.c
> @@ -1179,7 +1179,6 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
>  
>  	nft_pipapo_avx2_prepare();
>  
> -next_match:
>  	nft_pipapo_for_each_field(f, i, m) {
>  		bool last = i == m->field_count - 1, first = !i;
>  		int ret = 0;
> @@ -1226,6 +1225,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
>  
>  #undef NFT_SET_PIPAPO_AVX2_LOOKUP
>  
> +next_match:
>  		if (ret < 0) {
>  			scratch->map_index = map_index;
>  			kernel_fpu_end();
> @@ -1238,8 +1238,10 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
>  
>  			e = f->mt[ret].e;
>  			if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||
> -				     !nft_set_elem_active(&e->ext, genmask)))
> -				goto next_match;
> +				     !nft_set_elem_active(&e->ext, genmask))) {
> +				ret = pipapo_refill(res, f->bsize, f->rules, fill, f->mt, last);

It could be wrapped like this:

				ret = pipapo_refill(res, f->bsize, f->rules,
						    fill, f->mt, last);

> +				goto next_match:
> +			}
>  
>  			scratch->map_index = map_index;
>  			kernel_fpu_end();

In any case:

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

