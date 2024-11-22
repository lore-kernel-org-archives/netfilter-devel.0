Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0762AEFE
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Nov 2024 14:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732284111; cv=none; b=AjRCw2V4kez/48q6VXwUXfiUbD0copoXO9Rtdwy9tH/KvS61HJChQzDVpsg8zwANIqHXbzCMHO3DNP7Z95sa7VBLCzvYV5mmWVMLgvPdOuhCQRv9oS5gsHeuUq71QJYlVqq5+h7byIRrZ7v8hiQirLzZ5X7OFBuPTljMc21G8FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732284111; c=relaxed/simple;
	bh=Zkxgs4iTrvdGQo/E7YPLHHD32H2rg+nkKZvm7T/MDU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FEyWhdO6w0szSZzgnBcUPbMqCbp4+69f8kQq9vn6HzcFdPsHdexdpq5fwlfbyCpGnR5YkM1Ga7SW0uXAODR9+NUHcX6xE/ww7dnpNs8l1ukQNhX27rN7vOS+M//l3W7GedwQRjaKh4l7svFW9tgjhQo+m6VuOdsFFDsp1OzjfzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=32826 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tEUED-000u6w-Se; Fri, 22 Nov 2024 15:01:48 +0100
Date: Fri, 22 Nov 2024 15:01:44 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] debug: include kernel set information on cache
 fill
Message-ID: <Z0COyPgXhs141N8W@calendula>
References: <20241120100221.11001-2-fw@strlen.de>
 <Zz5w6NPQ2XsJrpHG@calendula>
 <20241120233854.GB31921@breakpoint.cc>
 <20241121092427.GA12619@breakpoint.cc>
 <Zz8EzBW2kzaq4jXr@calendula>
 <20241121120242.GB12619@breakpoint.cc>
 <Zz9N4CmuiLxQpaAH@calendula>
 <20241121171957.GA25690@breakpoint.cc>
 <Z0CInEpuxYA1bxFq@calendula>
 <20241122134327.GA17061@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241122134327.GA17061@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Fri, Nov 22, 2024 at 02:43:27PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Sure, wasn't that the reason why you iniitially wanted to restrict this to
> > > --netlink=debug?  What made you change your mind?
> > 
> > With large garbage collection cycle, this counter provides a hint to
> > the user to understand that slots are still being consumed by expired
> > elements.
> 
> But how / where is that relevant?
> 
> rbtree does gc at insert time.  We could extend rbtree to force gc
> even if interval is huge in case we have many expired elements.
> 
> We could do this by making __nft_rbtree_insert() count the number
> of expired nodes that it saw during traversal, then force gc at commit
> time even if time_after_eq() isn't met.

IIRC, rbtree insert path already performs gc on-demand.

> > > Maybe apply the simpler, existing v1 patches only, i.e. no exposure?
> > 
> > My concern is that this is exposing this implementation detail of the
> > rbtree, forever. Can we agree to do heuristics to hide this detail:
> > 
> > Assuming initial 0.0.0.0 dummy element is in place (this can be
> > subtracted), then, division by two gives us the number of ranges.
> 
> Ouch.  This either means more kernel complexity and lie to userspace,
> or leak rbtree details into nft, basically strcmp on the new
> SET_TYPE nlattr string and then display something else on frontend side.

Yes, this is lying to userspace to hide the implementation details.

I would really like to provide an alternative interface for the rbtree
to allow for the same netlink representation as pipapo. I expected
pipapo can replace rbtree by pipapo, but you mentioned in the past
this could be an issue.

> I'd prefer to avoid this mess.

OK, then we assume this will be forever used for debugging only,
unless rbtree is fully replaced.

Please, let me have a look, if I fail or it is too ugly you can still
ditch it and we can follow up with your approach.

Thanks.
