From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] Inter-match communication cache
Date: Wed, 19 Sep 2012 19:25:44 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209191840210.7636@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1209182232460.5113@blackhole.kfki.hu> <Pine.LNX.4.64.1209191720490.12601@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:48789 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760Ab2ISRZr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:25:47 -0400
In-Reply-To: <Pine.LNX.4.64.1209191720490.12601@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 19 Sep 2012, Jesper Dangaard Brouer wrote:

> On Tue, 18 Sep 2012, Jozsef Kadlecsik wrote:
> 
> > I propose a small cache for inter-match communication purpose:
> > 
> > diff --git a/include/linux/netfilter/x_tables.h
> > b/include/linux/netfilter/x_tables.h
> > index 8d674a7..f07eab2 100644
> > --- a/include/linux/netfilter/x_tables.h
> > +++ b/include/linux/netfilter/x_tables.h
> > @@ -216,6 +216,9 @@ struct xt_action_param {
> > 		const void *matchinfo, *targinfo;
> > 	};
> > 	const struct net_device *in, *out;
> > +#ifdef CONFIG_NETFILTER_XTABLES_CACHE
> > +	u_int32_t cache;
> > +#endif
> 
> Perhaps we should add it, that the end of the struct, to avoid too big ABI
> breakage.  And I generally don't like, adding compile time optional elements
> in the middle of a struct, as it make its harder to cache profile and
> padding/aligning the struct.

I did not want to create a hole that's why I put the new structure element 
after *out.

The optional compiling in is just a suggestion :-)
 
> > 	int fragoff;
> > 	unsigned int thoff;
> > 	unsigned int hooknum;
> > @@ -223,6 +226,15 @@ struct xt_action_param {
> > 	bool hotdrop;
> > };
> 
> > 
> > +enum xt_cache_owner {
> > +	XT_CACHE_OWNER_NONE	= 0,
> > +	XT_CACHE_OWNER_IPSET	= 1,
> > +};
> > +
> > +#define XT_CACHE_GET_OWNER(cache)	 (((cache) & 0xFF000000) >> 24)
> > +#define XT_CACHE_SET_OWNER(cache, owner) ((cache) |= (owner) << 24)
> > +#define XT_CACHE_GET_VALUE(cache)	 ((cache) & 0x00FFFFFF)
> > +
> 
> So, you are reserving 24 bit for data/"values". And we have 8 bits for 
> setting an owner of this data.  Thats the basic idea right?

Yes, but we could reserve less bits, say 6, 5 or even 4 for the owner and 
so giving more space to the value. 

Of course the cache is too small to hold a pointer, a match can store 
internal state flags there. For the "set" match that means the set 
identifier (16 bits) and the match flags together with the match result (8 
bits).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
