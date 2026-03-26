Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C1D12D21B
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 00:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774485882; cv=none; b=W2rgfB69Q2UzSxHSNGyaJuVNSr46WH9sJHvKPCCcRj8OJHvi545mJynEWINgCFCcRGAa/R9BFqmTGCRbSz6jUedqRSg8e2/FwE034szCt6vGjpRUnnf+orIsz7g/OCRvmrELbz/4zpxlbcvLQ0OpSXl2FuLRZoNo0jDDa19zWcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774485882; c=relaxed/simple;
	bh=/EJGTM/YJUz83SHL50p4rQTYQXfQepIgC9Y3tEE2wUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ew7jDs72FygJpXWZIUgtH5vRLnfl3AewPq/XCbnyPAX4it+DwWYaMNEyykmWk1PTZkyPh/jUM22QFGLkjXnXdK7v7X+sl5IJpNSJk1N6AlHg3fnirOAlb7xlrWqxK+9sHjd1ynGpsKXZCs7+/zKK1OrNBa3VCkMOX3tOxl0w7Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=Ou/00mJx; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="Ou/00mJx"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2c0ea57fea7so696239eec.0
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2026 17:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1774485880; x=1775090680; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R4nj1vvPgX4K4Fm+fDNCxFXZPHCa7kpCm/wAg4vA9Ic=;
        b=Ou/00mJxDN6/26y/JHraepKDCuoozy+srLcZFRGG9dJyfr+ikt/GIErhtj6p2kiOiy
         O2MVA5+HnGP4RDadzvu8saaFaDYbvAIibZd7wQ1/g/XnTfeL9nPuSWCxmHatcIj/TcXm
         2mNFZbDprjfzUJUbLT9d+zfZf7CL1lh5lRSN1oOh9LG92W2RQkjF55m97D7NA4Y7ThsX
         rePrqU89fntuUk4Hk/B6VpaQnLqPyqqYinZfz3NguRTL3B8BpOoZ+J57xCtnuEWZ7KFW
         t6SyX9RvgpprGuPQr/5GmmP5ZIFiQqY7N83zgvcjVeO46iDlT1dbpwhRVRSL5qLTdUaI
         TtKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774485880; x=1775090680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R4nj1vvPgX4K4Fm+fDNCxFXZPHCa7kpCm/wAg4vA9Ic=;
        b=QKXilowc3MUc32xoDsCN+wwzSHcPVHukysWtXGyLpAbD6bkntb5x3l/OnHTlTKrEc7
         RiMEsDqyKvgD4uQk6KR0ub7CC8zY8nJx7ttasGeD2F6ukNfO28WKO/5LcCD2qGscWZag
         lXdiCwIItKdfEttIIbQhC8I4/ThUJsal4aI6sR/ZwkTDvycUIMKdPN3e/3YP3vQBhHjB
         nkxoFJ6o8Cu1HQL+p1MStoCwd/N2mNZe3DQXZi68P4scM/eqIL6h8iNHPbJybYbE7dX8
         KkgiET6eTu1Jlo2EovsQn0E7DewotdHtCbQbjsGRcdhUfXDc2/dK2cSrM9jmxNTdGGa4
         QZXA==
X-Gm-Message-State: AOJu0YzFUooINQH+LXvajMITOBSzz7z9lyt+pEKRpq4WXMDjsIyGrfhS
	K65Nvlfr0w7YpdA14c47poR9sX1GQHbshlkd1dlptGYnz3+rne4HqweYoTKj18Ix2Mc=
X-Gm-Gg: ATEYQzwNsR5CpDb2ej+BRN8qcNaqDy+nSUHQ/9xm/gyi34GV4LA0SLJSHbcZqUwIR/r
	0xVQd12eQhDQAOROvhMm3hdcgfwn/mOmLzXMqQ5PBc2QzlnA5Tt3YlN2HtiJDzBuPOVZUoxJSIS
	q88tLQdSt2Zwc5O0JRQiPGbXaqxcXaRGvldkl7VKhSCRfngveEjTCwFy1mz4wZvfXVp/4ntV90S
	R5UOX8q0SYe3HONHtKBVnQKJra2KGrs+kr2idbx9zIFfVTD18DcSVE+ssxYgGasKxMmKTTBYEZH
	n2DgClQCUN0pxj7vmQlHCoX6LPuQrV7Rdc17LfrQSfvi56fgDuiBMxsdSyLOfXDQxEioVS1zOYI
	D8dlGUOnMg+5RclczdtQiVwyYW7t1S0URUdf6z5TORrwcGuTkbZW/2dyI9th2JlHO+gSxODg2h8
	ep94m8bak=
X-Received: by 2002:a05:7300:cb0e:b0:2be:e4b:60c2 with SMTP id 5a478bee46e88-2c15d291b93mr2909251eec.5.1774485879602;
        Wed, 25 Mar 2026 17:44:39 -0700 (PDT)
Received: from 20HS2G4 ([2a09:bac6:bf21:15e1::22e:48])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c16ee3c3ecsm1109163eec.31.2026.03.25.17.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 17:44:39 -0700 (PDT)
Date: Wed, 25 Mar 2026 19:44:36 -0500
From: Chris Arges <carges@cloudflare.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf,v4] netfilter: nft_set_rbtree: revisit array resize
 logic
Message-ID: <acSBdDCsD5KAiU-2@20HS2G4>
References: <20260317170721.12396-1-pablo@netfilter.org>
 <abrI8CZV3c8fi9x3@20HS2G4>
 <abrZkrarLXbZzXEO@chamomile>
 <acF4eJn_ZSdHe635@20HS2G4>
 <acSBDEog6wFw7Khp@20HS2G4>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acSBDEog6wFw7Khp@20HS2G4>

On 2026-03-25 19:42:54, Chris Arges wrote:
> On 2026-03-23 12:29:30, Chris Arges wrote:
> > On 2026-03-18 17:57:54, Pablo Neira Ayuso wrote:
> > > On Wed, Mar 18, 2026 at 10:46:56AM -0500, Chris Arges wrote:
> > > > On 2026-03-17 18:07:21, Pablo Neira Ayuso wrote:
> > > > > Chris Arges reports high memory consumption with thousands of
> > > > > containers, this patch revisits the array allocation logic.
> > > > > 
> > > > > For anonymous sets, start by 16 slots (which takes 256 bytes on x86_64).
> > > > > Expand it by x2 until threshold of 512 slots is reached, over that
> > > > > threshold, expand it by x1.5.
> > > > > 
> > > > > For non-anonymous set, start by 1024 slots in the array (which takes 16
> > > > > Kbytes initially on x86_64). Expand it by x1.5.
> > > > > 
> > > > > Use set->ndeact to subtract deactivated elements when calculating the
> > > > > number of the slots in the array, otherwise the array size array gets
> > > > > increased artifically. Add special case shrink logic to deal with flush
> > > > > set too.
> > > > > 
> > > > > The shrink logic is skipped by anonymous sets.
> > > > > 
> > > > > Use check_add_overflow() to calculate the new array size.
> > > > > 
> > > > > Add a WARN_ON_ONCE check to make sure elements fit into the new array
> > > > > size.
> > > > > 
> > > > > Reported-by: Chris Arges <carges@cloudflare.com>
> > > > > Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
> > > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > > ---
> > > > > v4: use maybe_grow: goto tag instead of grow:
> > > > >     Add note in commit description: "The shrink logic is skipped by anonymous sets."
> > > > > 
> > > > 
> > > > I will be able to testing this more in depth early next week. Just to confirm,
> > > > this patch requires this to be applied first?
> > > > https://lore.kernel.org/netfilter-devel/20260307001124.2897063-1-pablo@netfilter.org/
> > > 
> > > Yes, it requires that fix to be applied first.
> > 
> > Thanks, these two patches applied on 6.18 stable show slab unreclaimable memory
> > leveling out at 1.5GB for my local reproducer. I'll be deploying this to a
> > wider set of machines for more real-world testing this week.
> > 
> > So far seems good.
> > --chris
> 
> We have deployed this successfully and memory usage looks good in production.
> 
> Tested-by: Chris Arges <carges@cloudflare.com>
> 
> --chris

Oh I see it's queued up here:
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260325222615.637793-8-pablo@netfilter.org/
Thanks for fixing this!
--chris

