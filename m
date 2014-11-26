From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 08/10] netfilter: ipset: Introduce RCU in all set types
 instead of rwlock per set
Date: Wed, 26 Nov 2014 16:41:13 +0100
Message-ID: <20141126154113.GD24801@breakpoint.cc>
References: <1416862012-31139-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1416862012-31139-9-git-send-email-kadlec@blackhole.kfki.hu>
 <20141126131434.GA1671@salvia>
 <alpine.DEB.2.10.1411261538080.9422@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41489 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753763AbaKZPlQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:41:16 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1411261538080.9422@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> On Wed, 26 Nov 2014, Pablo Neira Ayuso wrote:
> 
> > > diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
> > > index f1606fa..418d360 100644
> > > --- a/include/linux/netfilter/ipset/ip_set.h
> > > +++ b/include/linux/netfilter/ipset/ip_set.h
> > > @@ -113,10 +113,10 @@ struct ip_set_comment {
> > >  };
> > >  
> > >  struct ip_set_skbinfo {
> > > -	u32 skbmark;
> > > -	u32 skbmarkmask;
> > > -	u32 skbprio;
> > > -	u16 skbqueue;
> > > +	u32 __rcu skbmark;
> > > +	u32 __rcu skbmarkmask;
> > > +	u32 __rcu skbprio;
> > > +	u16 __rcu skbqueue;
> > >  };

This looks weird...
What is rcu protecting here?

> > > +#define IP_SET_RCU_ASSIGN(ptr, value)	\
> > > +do {					\
> > > +	smp_wmb();			\

Whats this barrier for?

> > > +	*(ptr) = value;			\
> > > +} while (0)

> > > +static inline void
> > > +ip_set_rcu_assign_ulong(unsigned long *v, unsigned long value)
> > > +{
> > > +	IP_SET_RCU_ASSIGN(v, value);
> > > +}
> > > +
> > > +static inline void
> > > +ip_set_rcu_assign_u32(u32 *v, u32 value)
> > > +{
> > > +	IP_SET_RCU_ASSIGN(v, value);
> > > +}
> > > +
> > > +static inline void
> > > +ip_set_rcu_assign_u16(u16 *v, u16 value)
> > > +{
> > > +	IP_SET_RCU_ASSIGN(v, value);
> > > +}
> > > +
> > > +static inline void
> > > +ip_set_rcu_assign_u8(u8 *v, u8 value)
> > > +{
> > > +	IP_SET_RCU_ASSIGN(v, value);
> > > +}

These macros look dodgy...  Why are they needed?

> - elem extensions: the manipulations of the extensions are 
>   either atomic operations or integer settings. The inline functions
>   above provide those RCU safe integer settings: they are the same
>   as rcu_assign_pointer(), but that one can be used for pointers only.

Yes, because it doesn't make sense to me to have something NOT for
pointers.

rcu_assign_pointer() is there to make sure that when you "publish" the
memory whose address is given, all the content is visible to all the
cpus, this is also why it has the barrier.

I don't see why you'd need a special function otherwise, unless you
want some explicit documentation as to where you're changing/updating
content of structures protected by rcu.  But, in those sections you
already need to hold some type of lock, so I don't think its needed.

Cheers,
Florian
