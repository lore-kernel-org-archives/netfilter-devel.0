Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A57912D21B
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 00:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774485777; cv=none; b=ZVrdHGsYQzpHmN+34JtexdkO2V7kZFHEdrBsK6+EBQnGkhZa3KPc6lMnSiHNvwBfC7ad/s0dOx1CZEIlzoCfsMlGpuRRHmxZTSp+rNkCOXTfmI98dDboEWxWlGL0AgVbMYGfP9E/CeBFjTJIGsQndh4Sn165B4q2dao02X3V378=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774485777; c=relaxed/simple;
	bh=nurTYeK+77J4t+lk0EYRHTrnDi4rMtMPOXgZPX1122s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OfLIePgzg9TTal+lWdwEJ/qUcOTkOOiKSZvX77NsmWxSqQXNaif4mXNO4scnRw7ZqJdx59jJ3NUN9kVKo1KxYJVX+xAzjodTPOz2zQzG04CVSyLSnmDMMH/8XTiWBkoUeL0ZTGjeEH+rSU6mVKAj5CWVkhHvhmHe9pHuhvQp0zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=eOyLg1ID; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="eOyLg1ID"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4648447e29bso163109b6e.0
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2026 17:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1774485775; x=1775090575; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fRvhcDOzU0N5aAgfsR1DHF+wIdqPpgSRXdXqAgcNkJQ=;
        b=eOyLg1IDqWNS/wbpzqbNS7hpXLcdGIvtT0d1NQVRV3A47aXBjTifrKtky6gO6TFRxr
         cVgGAWO0llZ5X4oGD07+bRtKv0jwhWWABwh7WZdy1E+jBAVI7zn23a1Ne5G8IVzAyUj2
         ZXY3XmNjZ7SDmMTWUQUV2UsKKlu/syaqm/fBDB1gr34jrmtaVAYIIgbfufs2jyFQL9Qb
         mcZ+skWtAqwDWuY7KW4KYLnLU45UMFct0k5qhJkSxw77dwmwqpG3ipSZXk7tYLRRu0lF
         i7f6pZ73lV6OAPzhyEwC+a84NJgb0IhScq89nuNscg94UsoGMv+gPsg2m36kNvJghFCv
         /42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774485775; x=1775090575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fRvhcDOzU0N5aAgfsR1DHF+wIdqPpgSRXdXqAgcNkJQ=;
        b=RqTX6I5EBXgJr+f6t7SUPDW5AQvkjXaQmrPYlFYeosC7qNgNfdPjLLJ4E7ymSKanx1
         CkWJBOc9I69VIddgrjXUfwRxQhC4E6YQFNItLyc8knjJUpfHa3azZr/cOl1+2PMsSmpt
         KOSPSSdeECrqiSXnv7GTQoI7ZXQzOwbGk1H98iIC/ZZK+A4XipP9tSGafkZ5ColBxkqw
         7y0OPkAEq7FI6U0b+TxRSByeLgFhLiUNes6wNOIBGeKPIQinoA8EFIc4wwPfjsv5tgMO
         2JW3WDHBrCpn2kEBeZlWeFQqR3l4T5L04uNByPEsxato9Gi/hIuSRfj77SYsxeeNOP13
         99AA==
X-Gm-Message-State: AOJu0YydU+l57Ail0tAu+7BIUXq9xQFHCdYI7LFIKReOiAI9m93WP0Yg
	bMu85FTIVBxRqLslTCVPSOzaXAukj1sVZOqsFWB5Qbbn4pw3AO5eK2S4a+bsR0He0Kk=
X-Gm-Gg: ATEYQzzWELDiPBF99PyLHIS11UNolYA41+eAJ8OKiPJLM6+nmQkk3VvlVqa+XebdoM5
	t4A6mTx8ND3EGa4QrB9X2Uy1WR6xQsGlVXUcF9TiIf30ph0fKEd0nrM2D/uB1vmZ7j2vScaJpIw
	mhw5NxzT1C3F2syCEfA++EyaN1kZcNptrb5u2ABlI36qtnLClxnKeUvMlLPPr/ZUlmtskM0dUJ5
	U0eZB5ujSiHdbnBkaoZwi49kJr5PZFGWt5AAu/RCYhh5P2cnZIR1N313zTDwfeNV40ckaMNDHit
	ny0tAEKh7ZtUbvji8sUjt4+gYpfwtsJpr3eKcPpxx9WmEOPnOQb4qD5Xzf+zlOwfbItFK6dF6Yp
	qr7WmQrBr/U4jzIrXtVigbQcGRFjHcBQnTIcIOhHNYJZPLIIjiMuLc8KD8Jiya53QP0hM98p8sf
	14uppIV1s=
X-Received: by 2002:a05:6808:1907:b0:467:a44:dde2 with SMTP id 5614622812f47-46a5c7fd037mr2627930b6e.56.1774485774988;
        Wed, 25 Mar 2026 17:42:54 -0700 (PDT)
Received: from 20HS2G4 ([2a09:bac6:bf21:15e1::22e:48])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d9e6fddb47sm983541a34.8.2026.03.25.17.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 17:42:54 -0700 (PDT)
Date: Wed, 25 Mar 2026 19:42:52 -0500
From: Chris Arges <carges@cloudflare.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf,v4] netfilter: nft_set_rbtree: revisit array resize
 logic
Message-ID: <acSBDEog6wFw7Khp@20HS2G4>
References: <20260317170721.12396-1-pablo@netfilter.org>
 <abrI8CZV3c8fi9x3@20HS2G4>
 <abrZkrarLXbZzXEO@chamomile>
 <acF4eJn_ZSdHe635@20HS2G4>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acF4eJn_ZSdHe635@20HS2G4>

On 2026-03-23 12:29:30, Chris Arges wrote:
> On 2026-03-18 17:57:54, Pablo Neira Ayuso wrote:
> > On Wed, Mar 18, 2026 at 10:46:56AM -0500, Chris Arges wrote:
> > > On 2026-03-17 18:07:21, Pablo Neira Ayuso wrote:
> > > > Chris Arges reports high memory consumption with thousands of
> > > > containers, this patch revisits the array allocation logic.
> > > > 
> > > > For anonymous sets, start by 16 slots (which takes 256 bytes on x86_64).
> > > > Expand it by x2 until threshold of 512 slots is reached, over that
> > > > threshold, expand it by x1.5.
> > > > 
> > > > For non-anonymous set, start by 1024 slots in the array (which takes 16
> > > > Kbytes initially on x86_64). Expand it by x1.5.
> > > > 
> > > > Use set->ndeact to subtract deactivated elements when calculating the
> > > > number of the slots in the array, otherwise the array size array gets
> > > > increased artifically. Add special case shrink logic to deal with flush
> > > > set too.
> > > > 
> > > > The shrink logic is skipped by anonymous sets.
> > > > 
> > > > Use check_add_overflow() to calculate the new array size.
> > > > 
> > > > Add a WARN_ON_ONCE check to make sure elements fit into the new array
> > > > size.
> > > > 
> > > > Reported-by: Chris Arges <carges@cloudflare.com>
> > > > Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
> > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > ---
> > > > v4: use maybe_grow: goto tag instead of grow:
> > > >     Add note in commit description: "The shrink logic is skipped by anonymous sets."
> > > > 
> > > 
> > > I will be able to testing this more in depth early next week. Just to confirm,
> > > this patch requires this to be applied first?
> > > https://lore.kernel.org/netfilter-devel/20260307001124.2897063-1-pablo@netfilter.org/
> > 
> > Yes, it requires that fix to be applied first.
> 
> Thanks, these two patches applied on 6.18 stable show slab unreclaimable memory
> leveling out at 1.5GB for my local reproducer. I'll be deploying this to a
> wider set of machines for more real-world testing this week.
> 
> So far seems good.
> --chris

We have deployed this successfully and memory usage looks good in production.

Tested-by: Chris Arges <carges@cloudflare.com>

--chris
