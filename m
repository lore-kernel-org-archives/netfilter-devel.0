Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F173C7DEC
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Mar 2026 17:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774286973; cv=none; b=PkOYTddEuIbuxwtyRs+JpK+dyDmrt7+4tpnWHgUzH3Z/nr6mZMxG5cHamkHxX1XcdBRNHafuu1l5H2ePh93u4mIRStugtiMOGg6id93of/gf7MDLTAzXBaGBeEw5fMRB5WLv98fmxXZLjQ0MoWSZJKRlhxtoTrgBoM7P6QJKXKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774286973; c=relaxed/simple;
	bh=k8DLoNLXKMFj6ox3WZDl9xOPfFc7cwuadTPfGImlssY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jiH6oBAxXCUE2hwP36dk0LunJKFmV/HG4vH3bMcXOHvwm12Bv50daSrQOZW1sIBIrHWH1MYS63Wm+QbsRxHHIXX2iJAv1q5y7j3pRXiJUAZ4G5xx+Vzpki/vh03kBjHnB/fOum/63aH4ORN750dqZOLq3SVzzWB0G5JiUK8bmDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=IVqt/6Vn; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="IVqt/6Vn"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-4680a2493a2so626722b6e.0
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Mar 2026 10:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1774286971; x=1774891771; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nNdkJjIyCiq4nbSq1NxkdPtu5zyrilWg59iII9wnflo=;
        b=IVqt/6VnNQ7bCRAAq8J3irjGVaZj7D0kdif0OSyC/hhezeULd/YyyLOjsYPQmCh9yP
         S7+g6sXW0T+esrqpd396lfuSnBrc6pL8Tajq9H+XgwmUwqELrewZswdHsqDoeF64uxDZ
         jydBAv7eZjuUAaQIzx32IyTAPFuM/rnU6x+EBMhdmCT9TLD8+ESi+V0c8ZluVag6eytV
         Q+XdIK1E3rrfkgJKGsEHcEQ8NLnLQxsYWFrdTqzP/oF40uYJbeeldWCiXcQyYGaFpgCM
         kH5SnVjQCLbp/R/+aOgUBBNGn3iHiy+BQAe35C/UMSqEYB4XAWpZ+0OsYGTy7G69Cjgu
         xbMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774286971; x=1774891771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nNdkJjIyCiq4nbSq1NxkdPtu5zyrilWg59iII9wnflo=;
        b=Equ/sURp5y2JheOhX/EJfBXr4VGEg4fzqyicpqOsU6PDMNs0r3PlR6uZb+hdYo53mv
         uSwcIgrBHEuCZYLvbAzJjJMhVvbK3rDP4Va8o9mGmdhMaYsZq/T26MzUcAat54r9jYFM
         RxpchPij0gUoYK+moLI/SxhmSxQiVweypD4YyPlaKTthLFNQdR4T5aFE8E6/PmXw5jy9
         eDEYP8kao8qWcH3R/Mz/kT+5qZMb6nYqzL+ZEnXwEeF/K7tMxUYuN/g4OBHHrVC/BAu/
         kcjZ37Au9rZQvWxZ5cC6zF3/lDTng2hG3f9U39F/5rOj4JZxJHejhsDQGxbd2nYnjPCp
         O6eA==
X-Gm-Message-State: AOJu0Yw3d4jpYTfk4xvcUM3om/9atzIr7o78kKWhBbO9s9eHOJU7zAgu
	lGteesGnuwU5CTs2H56MJ/pPJSaS2pEtnSy8Dw/kxbsL8lwIvVu9LB32TzH8dA7Msvcg11C+uEW
	HyJ9sfxc=
X-Gm-Gg: ATEYQzxVB1+fym47TDMppJzI0xmb/0NNLsNPc6ULuo9JI0N2NHdb0IVfGkppGfCzAUn
	Ycn+XPOZE245siSbkjM88fZvIh/yyIL0TjbR5Ngly9cR39zpl2DNb+9tw6p+fOSvk1O3iQTYdpt
	4DTwNRqx1Zh64PHd9fISbpsfzNq3eDkZniGE6bXKX6QNddw3ivw8l8ArxhZC15W6wvYrd6vXNHN
	TiuSSwKN2QoMzU6pY5Yx/LaGUrCVGhzyMk9QSV0elfE+aQ7it7BXzVCxIun5MHJJ2Y/3c77TJ11
	ND5ZUdqHybQOokh3b3i2mjlxR5fWz1W3Ufi7WbQ3o7zSKSUqqj+J3v4pN53v/rb4NZNjL9K8a9H
	aWSg+pRhLgeuPkTTmMGuyQPO/7ZSaeUmZSLidYmeMLZJqe78ezgEnF9WDUog3KKuEkontXia6yB
	WJ4QGXZQ==
X-Received: by 2002:a05:6808:1c9:b0:467:2652:b29d with SMTP id 5614622812f47-467e5d4191amr6048045b6e.8.1774286970482;
        Mon, 23 Mar 2026 10:29:30 -0700 (PDT)
Received: from 20HS2G4 ([2a09:bac6:bf21:2632::3ce:1])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c148a5f99sm11223063fac.2.2026.03.23.10.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 10:29:29 -0700 (PDT)
Date: Mon, 23 Mar 2026 12:29:28 -0500
From: Chris Arges <carges@cloudflare.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf,v4] netfilter: nft_set_rbtree: revisit array resize
 logic
Message-ID: <acF4eJn_ZSdHe635@20HS2G4>
References: <20260317170721.12396-1-pablo@netfilter.org>
 <abrI8CZV3c8fi9x3@20HS2G4>
 <abrZkrarLXbZzXEO@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abrZkrarLXbZzXEO@chamomile>

On 2026-03-18 17:57:54, Pablo Neira Ayuso wrote:
> On Wed, Mar 18, 2026 at 10:46:56AM -0500, Chris Arges wrote:
> > On 2026-03-17 18:07:21, Pablo Neira Ayuso wrote:
> > > Chris Arges reports high memory consumption with thousands of
> > > containers, this patch revisits the array allocation logic.
> > > 
> > > For anonymous sets, start by 16 slots (which takes 256 bytes on x86_64).
> > > Expand it by x2 until threshold of 512 slots is reached, over that
> > > threshold, expand it by x1.5.
> > > 
> > > For non-anonymous set, start by 1024 slots in the array (which takes 16
> > > Kbytes initially on x86_64). Expand it by x1.5.
> > > 
> > > Use set->ndeact to subtract deactivated elements when calculating the
> > > number of the slots in the array, otherwise the array size array gets
> > > increased artifically. Add special case shrink logic to deal with flush
> > > set too.
> > > 
> > > The shrink logic is skipped by anonymous sets.
> > > 
> > > Use check_add_overflow() to calculate the new array size.
> > > 
> > > Add a WARN_ON_ONCE check to make sure elements fit into the new array
> > > size.
> > > 
> > > Reported-by: Chris Arges <carges@cloudflare.com>
> > > Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > > v4: use maybe_grow: goto tag instead of grow:
> > >     Add note in commit description: "The shrink logic is skipped by anonymous sets."
> > > 
> > 
> > I will be able to testing this more in depth early next week. Just to confirm,
> > this patch requires this to be applied first?
> > https://lore.kernel.org/netfilter-devel/20260307001124.2897063-1-pablo@netfilter.org/
> 
> Yes, it requires that fix to be applied first.

Thanks, these two patches applied on 6.18 stable show slab unreclaimable memory
leveling out at 1.5GB for my local reproducer. I'll be deploying this to a
wider set of machines for more real-world testing this week.

So far seems good.
--chris
