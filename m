From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 08/10] netfilter: ipset: Introduce RCU in all set types
 instead of rwlock per set
Date: Wed, 26 Nov 2014 15:58:01 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1411261538080.9422@blackhole.kfki.hu>
References: <1416862012-31139-1-git-send-email-kadlec@blackhole.kfki.hu> <1416862012-31139-9-git-send-email-kadlec@blackhole.kfki.hu> <20141126131434.GA1671@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:33150 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbaKZO5I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:57:08 -0500
In-Reply-To: <20141126131434.GA1671@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 26 Nov 2014, Pablo Neira Ayuso wrote:

> > diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
> > index f1606fa..418d360 100644
> > --- a/include/linux/netfilter/ipset/ip_set.h
> > +++ b/include/linux/netfilter/ipset/ip_set.h
> > @@ -113,10 +113,10 @@ struct ip_set_comment {
> >  };
> >  
> >  struct ip_set_skbinfo {
> > -	u32 skbmark;
> > -	u32 skbmarkmask;
> > -	u32 skbprio;
> > -	u16 skbqueue;
> > +	u32 __rcu skbmark;
> > +	u32 __rcu skbmarkmask;
> > +	u32 __rcu skbprio;
> > +	u16 __rcu skbqueue;
> >  };
> >  
> >  struct ip_set;
> > @@ -223,7 +223,7 @@ struct ip_set {
> >  	/* The name of the set */
> >  	char name[IPSET_MAXNAMELEN];
> >  	/* Lock protecting the set data */
> > -	rwlock_t lock;
> > +	spinlock_t lock;
> >  	/* References to the set */
> >  	u32 ref;
> >  	/* The core set type */
> > @@ -322,30 +322,72 @@ ip_set_update_counter(struct ip_set_counter *counter,
> >  	}
> >  }
> >  
> > +/* RCU-safe assign value */
> > +#define IP_SET_RCU_ASSIGN(ptr, value)	\
> > +do {					\
> > +	smp_wmb();			\
> > +	*(ptr) = value;			\
> > +} while (0)
> > +
> > +static inline void
> > +ip_set_rcu_assign_ulong(unsigned long *v, unsigned long value)
> > +{
> > +	IP_SET_RCU_ASSIGN(v, value);
> > +}
> > +
> > +static inline void
> > +ip_set_rcu_assign_u32(u32 *v, u32 value)
> > +{
> > +	IP_SET_RCU_ASSIGN(v, value);
> > +}
> > +
> > +static inline void
> > +ip_set_rcu_assign_u16(u16 *v, u16 value)
> > +{
> > +	IP_SET_RCU_ASSIGN(v, value);
> > +}
> > +
> > +static inline void
> > +ip_set_rcu_assign_u8(u8 *v, u8 value)
> > +{
> > +	IP_SET_RCU_ASSIGN(v, value);
> > +}
> 
> No questions regarding numbers, but I would like to see some
> explanation on the RCU approach that you're implementing in this
> patch. Thanks.

There are four types in the patch :-)

- bitmap set types: bit setting is atomic, so nothing required 
- list set type: normal list rcu
- hash set types: the pointer manipulations of the hash buckets
  are RCU protected; the cidr maintenance is changed and ordered
  so that adding/deleting does not break the list of cidrs.
- elem extensions: the manipulations of the extensions are 
  either atomic operations or integer settings. The inline functions
  above provide those RCU safe integer settings: they are the same
  as rcu_assign_pointer(), but that one can be used for pointers only.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
