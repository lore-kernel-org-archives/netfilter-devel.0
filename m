Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D6A136E37
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Nov 2024 14:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732286299; cv=none; b=sC3k5DXASEHthAj8BedTKAT3T2ejDHR6fJNDtpb4ZdzwyoKWf/WFxg19pGJ9b8vyZdYoQgMBo1PeQOQ2AF8/X2cf0DcvXQLqQBer1xpvGcYMJi6fmwwG95Ru8Vk+Rz7XiQ4bhbHu3Xz8Jg77HxC+yAHdjGo7kk3EPZ9RLjEn4EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732286299; c=relaxed/simple;
	bh=XFKn24EJBJKwcVEYHkqqNFk+EEoSk0F0Tksin10SRRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UrOc35wsygYNkpinZJdGObQfqlWC2+tSA62Awb4SUOlIflfWGp/3QL5GM+P9YnWDjLmFSo3Se6DmPCcxYOS3fDHX0S8AzYyFb1EtIVlSA1IKTOH03/Ho2nJR/lfgL2r3XEa3+hjyUvlmg+54T/xZGpZiy2jAaiHeiKa8d9VVQVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tEUnX-00060E-2v; Fri, 22 Nov 2024 15:38:15 +0100
Date: Fri, 22 Nov 2024 15:38:15 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] debug: include kernel set information on cache
 fill
Message-ID: <20241122143815.GA22830@breakpoint.cc>
References: <Zz5w6NPQ2XsJrpHG@calendula>
 <20241120233854.GB31921@breakpoint.cc>
 <20241121092427.GA12619@breakpoint.cc>
 <Zz8EzBW2kzaq4jXr@calendula>
 <20241121120242.GB12619@breakpoint.cc>
 <Zz9N4CmuiLxQpaAH@calendula>
 <20241121171957.GA25690@breakpoint.cc>
 <Z0CInEpuxYA1bxFq@calendula>
 <20241122134327.GA17061@breakpoint.cc>
 <Z0COyPgXhs141N8W@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0COyPgXhs141N8W@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Nov 22, 2024 at 02:43:27PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Sure, wasn't that the reason why you iniitially wanted to restrict this to
> > > > --netlink=debug?  What made you change your mind?
> > > 
> > > With large garbage collection cycle, this counter provides a hint to
> > > the user to understand that slots are still being consumed by expired
> > > elements.
> > 
> > But how / where is that relevant?
> > 
> > rbtree does gc at insert time.  We could extend rbtree to force gc
> > even if interval is huge in case we have many expired elements.
> > 
> > We could do this by making __nft_rbtree_insert() count the number
> > of expired nodes that it saw during traversal, then force gc at commit
> > time even if time_after_eq() isn't met.
> 
> IIRC, rbtree insert path already performs gc on-demand.

It doesn't do a full scan though.

Maybe lets take two steps back.  What is the actual issue that
needs to be resolved?

Even if nelems/count is dumped while concealing the
rbtree details, then its still confusing, you get
nelems 42 but no (or fewer) elements = { ... dumped
due to the timeout thing.

So in case we have to document that nelems/count isn't
the number of active elements but stored elements, including
the inactive ones, then we might as well not export this
and instead document consequence of large gc interval.

We could also do something even simpler: when we hit
size limit on dataplane insertion for TIMEOUT element,
expedite next gc scan if gc interval is > 10s (or some
other value -- don't want constant scans when set is full
with no timed out elements).

> I would really like to provide an alternative interface for the rbtree
> to allow for the same netlink representation as pipapo. I expected
> pipapo can replace rbtree by pipapo, but you mentioned in the past
> this could be an issue.

pipapo has other issues, just compare insert and delete times
of pipapo or hash or rbtree.

Even if thats not a concern, ATM userspace cannot force pipapo even if
it wanted to, so this is moot anyway.

> > I'd prefer to avoid this mess.
> 
> OK, then we assume this will be forever used for debugging only,
> unless rbtree is fully replaced.

Only if this fixup stuff is done in the kernel, which sabotages
debug output (conceals actual elements by some strategy rather
than just expose set->nelems).

> Please, let me have a look, if I fail or it is too ugly you can still
> ditch it and we can follow up with your approach.

OK.
