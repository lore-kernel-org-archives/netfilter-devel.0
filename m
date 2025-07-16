Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A737D186294
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 17:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752685213; cv=none; b=PdKCXOfoaHGzE9b63CWHmuuDhcOxTHZ1uSHU17vO5V8kG3oFG6SnmtkB7cO8ZyUpFevDTEi0924pCNMZG+/XPIgqrmcFXnr7fI9sbZNcgnfEaMdpweHEfXMxemvlqYd8VIwiTy8t12I2p7DRfLEryS8pFzIgZsFjPPOyPqx1frE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752685213; c=relaxed/simple;
	bh=omlqQ8Y+11a0mmpLUAUG9rz+qsJqlyCBWsw48b3Wf1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iFAKzHYCbe29u5khV8tU8w4asF3o/X8U9HGZuYR1Uw9E7uVMAbahhVnv2qF5m6EwetdL2Xxjgo5xJq6hT2fOPkkOryztJh6KBGaKA3vx9uKRbFIPoXorINfC5enoVcu4wXO6i/IUVll3nTx1Qv2QRUWudZt5IziYPG25PFLA/SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pA2rPxCH; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pA2rPxCH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pA2rPxCH";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pA2rPxCH"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id CD02B6027B; Wed, 16 Jul 2025 19:00:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752685208;
	bh=4v78sEaVSYr5bxxHKpupP8CuUo/Q4JxdtjaT+hytUYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pA2rPxCHpL6vBDrVK+0k+rPQc9p+T+UuFfenC9TZ7KMYU7nxF/loXa1jQK5R8204S
	 ivYv3HIqpww8B/Ov/NxC8PU6uZBR0zcjHIZLD3zfgNSfYd6vFeKREuWw6fQTZ1bPkh
	 9RI23j9SCKXdDqkb2EOTn4DgD11/sGPQLZQgdPOogdreOg8vGsIunMfNhtaWS7DmbU
	 070LSfCl22JzIYE/R6ZXzI2Tu1lsJ5Zwo57OF+VEeImZK/pyvMlRTphZCoXwAnEG5D
	 nxYKL/iGs0mSu2Z/hfYcCpQLJXkUYO58/iQtbFSgcho12rqloguySyXSeCVDQhqyP7
	 fkJrkfQNCnajA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 05DF46027B;
	Wed, 16 Jul 2025 19:00:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752685208;
	bh=4v78sEaVSYr5bxxHKpupP8CuUo/Q4JxdtjaT+hytUYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pA2rPxCHpL6vBDrVK+0k+rPQc9p+T+UuFfenC9TZ7KMYU7nxF/loXa1jQK5R8204S
	 ivYv3HIqpww8B/Ov/NxC8PU6uZBR0zcjHIZLD3zfgNSfYd6vFeKREuWw6fQTZ1bPkh
	 9RI23j9SCKXdDqkb2EOTn4DgD11/sGPQLZQgdPOogdreOg8vGsIunMfNhtaWS7DmbU
	 070LSfCl22JzIYE/R6ZXzI2Tu1lsJ5Zwo57OF+VEeImZK/pyvMlRTphZCoXwAnEG5D
	 nxYKL/iGs0mSu2Z/hfYcCpQLJXkUYO58/iQtbFSgcho12rqloguySyXSeCVDQhqyP7
	 fkJrkfQNCnajA==
Date: Wed, 16 Jul 2025 19:00:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 4/4] netfilter: nf_conntrack: fix crash due to removal
 of uninitialised entry
Message-ID: <aHfVrat6tEvZmZ5h@calendula>
References: <20250627142758.25664-1-fw@strlen.de>
 <20250627142758.25664-5-fw@strlen.de>
 <aGaLwPfOwyEFmh7w@calendula>
 <aGaR_xFIrY6pwY2b@strlen.de>
 <aHULbUHBCM4bUw8e@calendula>
 <aHUV8-hd1RbiupaC@strlen.de>
 <aHbRhj-NW3frJt0v@calendula>
 <aHfMbT1txNXpdK_7@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aHfMbT1txNXpdK_7@strlen.de>

On Wed, Jul 16, 2025 at 05:59:41PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Jul 14, 2025 at 04:36:35PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > On Thu, Jul 03, 2025 at 04:21:51PM +0200, Florian Westphal wrote:
> > > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > > Thanks for the description, this scenario is esoteric.
> > > > > > 
> > > > > > Is this bug fully reproducible?
> > > > > 
> > > > > No.  Unicorn.  Only happened once.
> > > > > Everything is based off reading the backtrace and vmcore.
> > > > 
> > > > I guess this needs a chaos money to trigger this bug. Else, can we try to catch this unicorn again?
> > > 
> > > I would not hold my breath.  But I don't see anything that prevents the
> > > race described in 4/4, and all the things match in the vmcore, including
> > > increment of clash resolution counter.  If you think its too perfect
> > > then ok, we can keep 4/4 back until someone else reports this problem
> > > again.
> > 
> > Hm, I think your sequence is possible, it is the SLAB_TYPESAFE_BY_RCU rule
> > that allows for this to occur.
> > 
> > Could this rare sequence still happen?
> > 
> > cpu x                   cpu y                   cpu z
> >  found entry E          found entry E
> >  E is expired           <preemption>
> >  nf_ct_delete()
> >  return E to rcu slab
> >                                         init_conntrack
> >                                         <preemption>     NOTE: ct->status not yet set to zero
> > 
> > cpu y resumes, it observes E as expired but CONFIRMED:
> >                         <resumes>
> >                         nf_ct_expired()
> >                          -> yes (ct->timeout is 30s)
> >                         confirmed bit set.
> 
> Yes, that can happen, but then the refcount can't be incremented
> as its 0 (-> entry is skipped).

Right, refcount zero prevents it.

static void nf_ct_gc_expired(struct nf_conn *ct)
{
        if (!refcount_inc_not_zero(&ct->ct_general.use))
                return;


> If its nonzero but the object was returned
> by the kmem cache we have a different kind of bug (free with refcount > 0),
> or use-after-free.

OK, thanks for explaining, use set_bit() and post v2.
