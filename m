Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D08B2C1593
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 18:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773254721; cv=none; b=cpJ/xPEVE8YVDXBhJ2M6x1yYBTkNlx/DhrRArj2aFo+KPy2eqphViCL65TOmNYLyC5ZMLxh0w2BZAW6O5eDFvSsDpsTSFTWJIzrdIyjhtEhMOw7ZzeLAvNu/QY+J5e24L1M0zSlp/W5qPwtaJd1KwzMUKjiZ3daezZ8omV7yXqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773254721; c=relaxed/simple;
	bh=F/FUM/WxK+16s7Td4xG9TYokwm++yHN1mmOypIk4SJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SxtaeNXFd7y1lNBG0eTToYi5oaT1GKxkPUmXaj3BR1lJT6pJwykrQVERT0ZwXpmWKKeNmClbUzRvR/TVZ06aIbk0xCP3SDe1W4TfHyxnCYb0Bag1mtBXOsjKq77EwzVxnMP8QMWATNhnTVNBwLl8KTc0kM9enbLJZTyGujqmvzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=JKYNCHUW; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="JKYNCHUW"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d55b97f358so173487a34.3
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 11:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1773254719; x=1773859519; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HBEtBID0iBmXZ9g8hubX9HqMPMlXb5Ao1FxM4RO+wKY=;
        b=JKYNCHUW8HAV9NsKk9TU9WW110spE1M7t+ZyfLbConB++sv9Oe1dB01kwPxctjSMt4
         dAht4aud1SdZUGNmUpIXiqWh6T1vIyr+vyMwkZ8SsMgDPTgpoDSQvFwsbfurjG8qnhcm
         T6Quo2a/zLGLFSMNQc3jAxMbQ9tMcZdOt1AoIbduUW9oCQk5y4r310i1c63931dir3DQ
         E6NoSQCWBCBRfrraQtuBR3L1HIAXlkCOAlhhg9+KMxSHvOQq59mkCn8QjYfnkWSehVux
         k+1mv3A82fv6vHCBQ4Z3aW9JSsucW1XgjWi1s2dH5GuPEX6LkrWho8rsKis0rZD+wL1m
         hcsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773254719; x=1773859519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HBEtBID0iBmXZ9g8hubX9HqMPMlXb5Ao1FxM4RO+wKY=;
        b=Rj27vKTNl2tMMyzgkP+3CPGGpfpIUmx9YM02waoumIwCG7oP+4ZGQ1uf67pZcXfL84
         w3kcVO11p6GjbY+zS2FiOI64xgbvGye0lpEmyPVC/vQxwWgSBKMBOtxqr7v9CfY82sON
         wwij6knObGlZCxma80PiAcleuJunELkC5A5rFa5YcmCArz8GcdUpvR3UpbRfZeo4Ezhz
         YkD1Mk3YUZLVCNOuDP7eoxG73/cusKScS+y8BsDVdMzTBaPKEpxcEGa5oib9HqQzsu1l
         d5odgoWIPNrZhN/kLCFKw/D/xAY51emRvR8iyaA/jMsFIBCcqBNLmWkCYHEBtdOMC3Gt
         ax8Q==
X-Gm-Message-State: AOJu0YynJ2AcWaIX5dalul00hf9jKhBYhn/IEg0ovKTRTaqyv8MA5M5p
	XUJXA9t5WPICk5H1UDqITkx7mbzifGwQASuRN2ZGl0qXxr7cUf1oxTfP9W+iM+sUEvw=
X-Gm-Gg: ATEYQzx0Q417A8LxbBgLvpunVNQ9N7QEAmbfRBDaO0NrJiwbzJjlOB5hr3qlDExXxaO
	s0aTCQRnCQ5NdIExBfFFgICRbip/wcTRAWPoXqGlY7lS9YflU4H+H2jp/bgeGnozafGfi2v+wE+
	NwcxwC0tswFblqcDHMbNFEobWuJJppEOc1yx9MuyRSGSlCmaM7bILgCzOFkxguFuKOcD81vJ/eW
	vywZpWsTTsX9/EFKodgpTmaBDI8xQQcPsFTZZiBJp90VPRecp7WISCQr7zrZzskCuPlMQjXzkYW
	uWoRKcD0D5sR6+BhCQCepdCnBHyrhHWEJKqmY+t4mw+83Z2tGynXJNB2lRo2GggR1mf0bXxM1Sj
	+Q6Uqekrrmx8JPd2F1kgEdXn6U0dWhlQOGfAfjk0DIYlB2hoEUhIp6+ArjCB9gJC+XvrkEGceKE
	nYvARB3xzy2/4XGYsU
X-Received: by 2002:a05:6830:6601:b0:7d5:96e7:1509 with SMTP id 46e09a7af769-7d76a844436mr2111075a34.21.1773254719077;
        Wed, 11 Mar 2026 11:45:19 -0700 (PDT)
Received: from 20HS2G4 ([2a09:bac1:76c0:540::3ce:20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ac32913sm2513574a34.5.2026.03.11.11.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 11:45:18 -0700 (PDT)
Date: Wed, 11 Mar 2026 13:45:16 -0500
From: Chris Arges <carges@cloudflare.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf,v2] netfilter: nft_set_rbtree: allocate same array
 size on updates
Message-ID: <abG4PAE3M1b9M35_@20HS2G4>
References: <20260307001124.2897063-1-pablo@netfilter.org>
 <abGYhwlvCWKoKNmm@20HS2G4>
 <abGbr0xbcAvRDMUZ@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abGbr0xbcAvRDMUZ@chamomile>

On 2026-03-11 17:43:27, Pablo Neira Ayuso wrote:
> On Wed, Mar 11, 2026 at 11:29:59AM -0500, Chris Arges wrote:
> > On 2026-03-07 01:11:24, Pablo Neira Ayuso wrote:
> > > The array resize function increments the size of the array in
> > > NFT_ARRAY_EXTRA_SIZE slots for each update, this is unnecesarily
> > > increasing the array size.
> > > 
> > > To determine the number of array slots:
> > > 
> > > - Use NFT_ARRAY_EXTRA_SIZE for new sets.
> > > - Use the current maximum number of intervals in the live array.
> > > 
> > > Reported-by: Chris Arges <carges@cloudflare.com>
> > > Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > > v2: fix crash with new sets, reported by Florian.
> > > 
> > >  net/netfilter/nft_set_rbtree.c | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > 
> > 
> > Pablo,
> 
> Chris,
> 
> > I was able to test with this patch applied on top of v6.18.16; however the
> > memory consumption remained high and similar to v6.18.16 without this patch.
> 
> Makes no sense to me.
> 

I did something like this:
```
git checkout v6.18.16
patch -p1 < this.patch
vng -b
```
Then ran my reproducer; unreclaimable slab memory went up past 4G showing
the high memory consumption.

> > My VM reproducer runs the services and checks for slab memory increases. In a
> > passing test case, the unreclaimable slab memory reaches about 1.4G and
> > stabilizes. In a failure test case unreclaimable slab memory goes beyond 4.4G
> > then the process gets OOM killed due to cgroup memory limits.
> 
> I have to review again what I posted. You mean, memory keeps for each
> dynamic update, increasing until it reaches OOM?
> 

Correct.

> > Also, using this reproducer I re-verified that this patch is what changes
> > slab memory.stat characteristics from within the cgroup:
> > - 7e43e0a1141d netfilter: nft_set_rbtree: translate rbtree to array for binary search
> > 
> > Finally, I reverted the following patches from v6.18.16 and re-tested using my
> > reproducer:
> > - 648946966a08 netfilter: nft_set_rbtree: validate open interval overlap
> > - 782f2688128e netfilter: nft_set_rbtree: validate element belonging to interval
> > - 35f83a75529a netfilter: nft_set_rbtree: don't gc elements on insert
> 
> Are you using timeout in your set?
>
No.
 
> > - 5599fa810b50 netfilter: nft_set_rbtree: remove seqcount_rwlock_t
> > - 2aa34191f06f netfilter: nft_set_rbtree: use binary search array in get command
> > - 7e43e0a1141d netfilter: nft_set_rbtree: translate rbtree to array for binary search
> > In this instance memory allocations were again around 1.4G.
> > 
> > Any suggestions for other tests, I can rebuild with memory debugging config as
> > well.
> > 
> > Also, could there be an option here to opt-out of this performance optimization
> > in favor of retaining existing memory characteristics?
> 
> This series is fixing a real bug, now you may experience possible
> false negatives in lookups with what you have reverted.
> 

Understood, we want to use these patches in the long run; once memory usage
issues are fixed.

> I am going to collect memory numbers and post them here, I will try to
> mimic a script from your description.

Sure, I can provide more details if needed, but should be similar as
explained in https://lore.kernel.org/all/aahw_h5DdmYZeeqw@20HS2G4/.

Thanks,
--chris
