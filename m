Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349A31D79BE
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 15:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681587; cv=none; b=dF8SDW/rXL58AvCdICOvcpi9U3v10FxkdIxOvEZcwHbx/SF8emcjFE1sIH8pgh/EYo3OmW4Chx61JE9bBYh6TThwjum0w3prb5NkfNvTs1LaebPsJoBMFGdrsn+/jKJSVUCQDb97McrHmPS0psJ8D4AkX2/Uwm7FTlCaHmo5BE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681587; c=relaxed/simple;
	bh=8TVe+A2856SgFZjEz31psBHVc1WXs6T81W/Z/oxq9KU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NBIL+OXgM9vIkrP+nTWcbHatPvxe2DvR7NjfLspn/X3Lupq/DrKLXwiCDFQnBsB8hUODRYNcEns8bGWw9FXdcvl5Iz6+8ld4Rky9CB0FtuZmCzpS4g54RFeTpAKXUAEvtynFR6AyRdTa4ww0TzyUNaMJva6v9by8IofV0brQVb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 01E0C604EE; Wed, 16 Jul 2025 17:59:41 +0200 (CEST)
Date: Wed, 16 Jul 2025 17:59:41 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 4/4] netfilter: nf_conntrack: fix crash due to removal
 of uninitialised entry
Message-ID: <aHfMbT1txNXpdK_7@strlen.de>
References: <20250627142758.25664-1-fw@strlen.de>
 <20250627142758.25664-5-fw@strlen.de>
 <aGaLwPfOwyEFmh7w@calendula>
 <aGaR_xFIrY6pwY2b@strlen.de>
 <aHULbUHBCM4bUw8e@calendula>
 <aHUV8-hd1RbiupaC@strlen.de>
 <aHbRhj-NW3frJt0v@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHbRhj-NW3frJt0v@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jul 14, 2025 at 04:36:35PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Thu, Jul 03, 2025 at 04:21:51PM +0200, Florian Westphal wrote:
> > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > Thanks for the description, this scenario is esoteric.
> > > > > 
> > > > > Is this bug fully reproducible?
> > > > 
> > > > No.  Unicorn.  Only happened once.
> > > > Everything is based off reading the backtrace and vmcore.
> > > 
> > > I guess this needs a chaos money to trigger this bug. Else, can we try to catch this unicorn again?
> > 
> > I would not hold my breath.  But I don't see anything that prevents the
> > race described in 4/4, and all the things match in the vmcore, including
> > increment of clash resolution counter.  If you think its too perfect
> > then ok, we can keep 4/4 back until someone else reports this problem
> > again.
> 
> Hm, I think your sequence is possible, it is the SLAB_TYPESAFE_BY_RCU rule
> that allows for this to occur.
> 
> Could this rare sequence still happen?
> 
> cpu x                   cpu y                   cpu z
>  found entry E          found entry E
>  E is expired           <preemption>
>  nf_ct_delete()
>  return E to rcu slab
>                                         init_conntrack
>                                         <preemption>     NOTE: ct->status not yet set to zero
> 
> cpu y resumes, it observes E as expired but CONFIRMED:
>                         <resumes>
>                         nf_ct_expired()
>                          -> yes (ct->timeout is 30s)
>                         confirmed bit set.

Yes, that can happen, but then the refcount can't be incremented
as its 0 (-> entry is skipped). If its nonzero but the object was returned
by the kmem cache we have a different kind of bug (free with refcount > 0),
or use-after-free.
