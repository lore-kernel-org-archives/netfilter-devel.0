Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2242E40B
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Nov 2024 13:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732283019; cv=none; b=en9RH+p3t+0xPl4lHLz+FvKhQHNmAkyByic7QZmSkat+fqTDwNiThlzDZPJTaMMAuBf2Ze7t99WGknRPgnQR5P1uxQYj/SXoTvjJG3VnG1rUepVwRzDs1pukZ+TlWKQ7xWSW4pJe4OBaE7q1M/52PwFpL39LRh3gEZJ6l7QVQ5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732283019; c=relaxed/simple;
	bh=bvHavJyLF6RIiabXLalp/69w7e2ltBPfG1ijRBqXjgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=haWe8v2f737UVzr5ptEm1JWOq8RukHOjXpbclTaoymctbpF9SpjUUOO6iqOrd0p7+ekencohCJCtjgtFd20kVj+2e8me99rzPKkAb2w8S7MTZ2PMnCEME4arDgtTwzfKV+sQbCxmz9J0KqUToY6abAavhzjmd2Ri7dPWswfrEqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tETwV-0005jz-UV; Fri, 22 Nov 2024 14:43:27 +0100
Date: Fri, 22 Nov 2024 14:43:27 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] debug: include kernel set information on cache
 fill
Message-ID: <20241122134327.GA17061@breakpoint.cc>
References: <20241120100221.11001-1-fw@strlen.de>
 <20241120100221.11001-2-fw@strlen.de>
 <Zz5w6NPQ2XsJrpHG@calendula>
 <20241120233854.GB31921@breakpoint.cc>
 <20241121092427.GA12619@breakpoint.cc>
 <Zz8EzBW2kzaq4jXr@calendula>
 <20241121120242.GB12619@breakpoint.cc>
 <Zz9N4CmuiLxQpaAH@calendula>
 <20241121171957.GA25690@breakpoint.cc>
 <Z0CInEpuxYA1bxFq@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0CInEpuxYA1bxFq@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Sure, wasn't that the reason why you iniitially wanted to restrict this to
> > --netlink=debug?  What made you change your mind?
> 
> With large garbage collection cycle, this counter provides a hint to
> the user to understand that slots are still being consumed by expired
> elements.

But how / where is that relevant?

rbtree does gc at insert time.  We could extend rbtree to force gc
even if interval is huge in case we have many expired elements.

We could do this by making __nft_rbtree_insert() count the number
of expired nodes that it saw during traversal, then force gc at commit
time even if time_after_eq() isn't met.

> > Maybe apply the simpler, existing v1 patches only, i.e. no exposure?
> 
> My concern is that this is exposing this implementation detail of the
> rbtree, forever. Can we agree to do heuristics to hide this detail:
> 
> Assuming initial 0.0.0.0 dummy element is in place (this can be
> subtracted), then, division by two gives us the number of ranges.

Ouch.  This either means more kernel complexity and lie to userspace,
or leak rbtree details into nft, basically strcmp on the new
SET_TYPE nlattr string and then display something else on frontend side.

I'd prefer to avoid this mess.
