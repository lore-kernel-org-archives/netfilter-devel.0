Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13773E1CFA
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 16:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773246605; cv=none; b=h0eJufsf9v95aMHNFXc7RND5EEna67aOHY9Nmq3cjeeC6S5XZ/KaGyz6PYWwetizGZPEoFZrXEiJjt4+HaVi00Oc8BCg0/1eUbQrtwM9A9pi9wqcUeBlrPX6RDSwi5sIB3xTh6H3snRicJvglpulqKaXIpf0V4owrJ+jqsNU4P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773246605; c=relaxed/simple;
	bh=R9YWHVdsX2EIF0wT4/Ozdb04mwWxNPBDb2L5EORf85o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=osYqEWHq8K7UA0H6JmhYM2dyvCRjVvJNbBA3LQMz5k+2d4YiTbwrflYFk7gnk3eryiYhTQIhNneCjC7WZT9PJwjrm6ZsMle56MKm3nvWKCUyGD46h28EdTQJCDgCk9HOZV9XF1Ds/Gkqu3zhJa3LS1PMemXA0wEzFM0F53OcFcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=TmlCrpzp; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="TmlCrpzp"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d75e74f5adso116911a34.3
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 09:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1773246602; x=1773851402; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wn36tzR+7WlBV7T0Y3x52AuKzoVFmqDTv4sFV2w3f/Q=;
        b=TmlCrpzp/ajJzHkZPFnd5x7zCoW2oFAa/yVgvLAW3MU2A0p7I2cJecP7FPz6eAzNdi
         1hLyfpjoBGpLBPIV/3az/+l7FkZEkOvdb3uIQ5TkXKtW2qpHPOmp3pFA/PfC9Lv+62a1
         98/3UWsaGelhPUqqeRZCHIvtD1pLZ+1No+wWjboZ5OAzENTaO8ZkAyOANcASFm/piJC7
         wXyB+cGNSTa+8abRVNlfL13cY0jbxMkTA+y+EkSSjltyxuEhm280uCWPmXNCqE7jwdfu
         vhjClZJ0wEp0COuCaOtVGvHImvNOUaNGM+Ho5tzcLpunoS3S+B1sR2QAvJCXQxyko+E/
         PmzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773246602; x=1773851402;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wn36tzR+7WlBV7T0Y3x52AuKzoVFmqDTv4sFV2w3f/Q=;
        b=KuQsFDXt9WhpurKkCJiJRDJFJ+VWGdHiwoOPb4x7HtCNU//K1M8B9nf8ly8eN0bmEp
         eOLTvw+F0faIGL7VoaJFy4SMoymgr1TCzXW8508fIuY0iY7yat83UfazvV3cWP7wKCEV
         mDFxvG1eDmj1IYVTmUXWqey87ia5fuZeElF95AFfIsyMQof8i2N838feypHQ08olri2D
         9RCH5V01Zl5nSxoiGK8lgGVqexhhz7VYdPWrtvtkV/cdRfeJPrWPNpC/7Bu/xmoB5+QA
         s+ubkMeUWUjlig1cZIPh916W9iP2zAVuf7+odfcZdZCbJoMDjS3AUIjL35le7WPCLdk1
         SQBQ==
X-Gm-Message-State: AOJu0Yw0pKtuw46pqR4jySjGRJdpg9dGw5r3+anUq5nz4ne9NZfDMnF3
	Tadc0BL5gUnV2EXOyradJBLRudv6iSkanQdsXkAS6gJXJERTHvqTyTsqQLCozOY72FyMFmfGynQ
	VNexmnwo=
X-Gm-Gg: ATEYQzxa6+rObMXnFmOMwNJb/e81z4jIwsA5lvRIcpwm7uZRUN/nNatphhxu2hSmifS
	6N1PvtMgyhrIohMzraAswMg+IYbCft6BA0qL02lUM3K4HhSfTM1PRXlWDtDokmrYhZT1//hiMsQ
	+skg9Dt8edz24zpInBPCw4bNeWWLKfFMJvyH5uLoTmYLpnsWwBmrZVUtGa4UCbeHZsDneKsDDej
	1Yx306g4ioCGXhOD2KwFutBNZ/C8RYu09Mq4e9LEuoVumG+PZ4POJZVyetIJHhLd36QruiUI3xl
	jGkaYhHVmZsoQ+0UbTtJiC4+Plut/C6NNcdfxK4N5V/emcfTCvxp5STnnLmIQPzMxux2rGGuRFD
	bu1xW0OrD1lncfnMBT6GIVtnRr+ER+tH5k/FXzRTIvChJ6f0jFkjp55/5xvI4+eaHAnU83Bsngy
	SsQ8ryKw==
X-Received: by 2002:a05:6830:67e5:b0:7d4:e11e:fa2d with SMTP id 46e09a7af769-7d76a844441mr2174274a34.36.1773246602157;
        Wed, 11 Mar 2026 09:30:02 -0700 (PDT)
Received: from 20HS2G4 ([2a09:bac1:76c0:540::3ce:20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ac3230fsm2175795a34.4.2026.03.11.09.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 09:30:01 -0700 (PDT)
Date: Wed, 11 Mar 2026 11:29:59 -0500
From: Chris Arges <carges@cloudflare.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf,v2] netfilter: nft_set_rbtree: allocate same array
 size on updates
Message-ID: <abGYhwlvCWKoKNmm@20HS2G4>
References: <20260307001124.2897063-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307001124.2897063-1-pablo@netfilter.org>

On 2026-03-07 01:11:24, Pablo Neira Ayuso wrote:
> The array resize function increments the size of the array in
> NFT_ARRAY_EXTRA_SIZE slots for each update, this is unnecesarily
> increasing the array size.
> 
> To determine the number of array slots:
> 
> - Use NFT_ARRAY_EXTRA_SIZE for new sets.
> - Use the current maximum number of intervals in the live array.
> 
> Reported-by: Chris Arges <carges@cloudflare.com>
> Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: fix crash with new sets, reported by Florian.
> 
>  net/netfilter/nft_set_rbtree.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 

Pablo,

I was able to test with this patch applied on top of v6.18.16; however the
memory consumption remained high and similar to v6.18.16 without this patch.

My VM reproducer runs the services and checks for slab memory increases. In a
passing test case, the unreclaimable slab memory reaches about 1.4G and
stabilizes. In a failure test case unreclaimable slab memory goes beyond 4.4G
then the process gets OOM killed due to cgroup memory limits.

Also, using this reproducer I re-verified that this patch is what changes
slab memory.stat characteristics from within the cgroup:
- 7e43e0a1141d netfilter: nft_set_rbtree: translate rbtree to array for binary search

Finally, I reverted the following patches from v6.18.16 and re-tested using my
reproducer:
- 648946966a08 netfilter: nft_set_rbtree: validate open interval overlap
- 782f2688128e netfilter: nft_set_rbtree: validate element belonging to interval
- 35f83a75529a netfilter: nft_set_rbtree: don't gc elements on insert
- 5599fa810b50 netfilter: nft_set_rbtree: remove seqcount_rwlock_t
- 2aa34191f06f netfilter: nft_set_rbtree: use binary search array in get command
- 7e43e0a1141d netfilter: nft_set_rbtree: translate rbtree to array for binary search
In this instance memory allocations were again around 1.4G.

Any suggestions for other tests, I can rebuild with memory debugging config as
well.

Also, could there be an option here to opt-out of this performance optimization
in favor of retaining existing memory characteristics?

Thanks,
--chris

