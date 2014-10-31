From: Mathias Krause <minipli@googlemail.com>
Subject: Re: bug report: use after free bug leading to kernel panic
Date: Fri, 31 Oct 2014 18:46:42 +0100
Message-ID: <20141031174642.GA22605@jig.fritz.box>
References: <CAHZ_AjsbkkXNMG8oZfOhr6WbUmV=4eK0j23ijbP=cNkfVdoAjQ@mail.gmail.com>
 <20141031165042.GN10069@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: eric gisse <jowr.pi@gmail.com>, netfilter-devel@vger.kernel.org,
	PaX Team <pageexec@freemail.hu>,
	Brad Spengler <spender@grsecurity.net>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37111 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaJaRqv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:46:51 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so1870979wiv.2
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Oct 2014 10:46:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20141031165042.GN10069@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 31, 2014 at 05:50:42PM +0100, Florian Westphal wrote:
> eric gisse <jowr.pi@gmail.com> wrote:
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 3e8afcc07a76..08a7cbcf2274 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2643,6 +2643,12 @@ static __always_inline void slab_free(struct kmem_cache *s,
> >  
> >  	slab_free_hook(s, x);
> >  
> > +	if (pax_sanitize_slab && !(s->flags & SLAB_NO_SANITIZE)) {
> > +		memset(x, PAX_MEMORY_SANITIZE_VALUE, s->object_size);
> > +		if (s->ctor)
> > +			s->ctor(x);
> > +	}
> > +
> 
> I am no SLUB expert, but this looks wrong.
> slab_free() is called directly via kmem_cache_free().
> 
> conntrack objects are alloc'd/free'd from a SLAB_DESTROY_BY_RCU cache.
> 
> It is therefore legal to access a conntrack object from another
> CPU even after kmem_cache_free() was invoked on another cpu, provided all
> readers that do so hold rcu_read_lock, and verify that object has not been
> freed yet by issuing appropriate atomic_inc_not_zero calls.
> 
> Therefore, object poisoning will only be safe from rcu callback, after
> accesses are known to be illegal/invalid.

Snap, you're right! I was misreading the following comment in
include/linux/slab.h to allow "free reuse" by the slab allocator as
well, e.g. for sanitizing/poisoning the object:

 * SLAB_DESTROY_BY_RCU - **WARNING** READ THIS!
 *  
 * This delays freeing the SLAB page by a grace period, it does _NOT_
 * delay object freeing. This means that if you do kmem_cache_free()
 * that memory location is free to be reused at any time. Thus it may
 * be possible to see another object there in the same RCU grace period.

But, in fact, that assumption is not true. I now see how the conntrack
code exploits this feature by testing &ct->ct_general.use. So if we
scratch that by writing '\xfe' everywhere over the object, that test
will no longer work.

I guess we need to change the slab sanitization feature in PaX to handle
SLAB_DESTROY_BY_RCU marked slabs the way they need to.

> 
> (not saying that conntrack is bug free..., we had races there in the
>  past).
> 
> From a short glance at SLUB it seems poisoning objects for SLAB_DESTROY_BY_RCU
> caches is safe in __free_slab(), but not earlier.
> 
> If you use different allocator, please tell us which one (check kernel
> config, slub is default).
> 
> If its reproduceable with poisoning done after the RCU grace periods
> have elapsed (i.e., where its not legal anymore to access the memory),
> please let us know and we can have another look at it.
> 

Thanks,
Mathias
