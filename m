From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 08/14] netfilter: ipset: Introduce RCU locking instead
 of rwlock per set in the core
Date: Wed, 3 Dec 2014 12:01:52 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1412031155070.21739@blackhole.kfki.hu>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu> <1417373825-3734-9-git-send-email-kadlec@blackhole.kfki.hu> <20141202182558.GB4504@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:34185 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaLCLAw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:00:52 -0500
In-Reply-To: <20141202182558.GB4504@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2 Dec 2014, Pablo Neira Ayuso wrote:

> On Sun, Nov 30, 2014 at 07:56:59PM +0100, Jozsef Kadlecsik wrote:
> > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > ---
> >  include/linux/netfilter/ipset/ip_set.h         |  6 ++++-
> >  include/linux/netfilter/ipset/ip_set_timeout.h | 27 ++++++++------------
> >  net/netfilter/ipset/ip_set_core.c              | 35 +++++++++++++-------------
> >  3 files changed, 34 insertions(+), 34 deletions(-)
> > 
> > diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
> > index f1606fa..d5d5bcd 100644
> > --- a/include/linux/netfilter/ipset/ip_set.h
> > +++ b/include/linux/netfilter/ipset/ip_set.h
> > @@ -223,7 +223,7 @@ struct ip_set {
> >  	/* The name of the set */
> >  	char name[IPSET_MAXNAMELEN];
> >  	/* Lock protecting the set data */
> > -	rwlock_t lock;
> > +	spinlock_t lock;
> >  	/* References to the set */
> >  	u32 ref;
> >  	/* The core set type */
> > @@ -322,6 +322,10 @@ ip_set_update_counter(struct ip_set_counter *counter,
> >  	}
> >  }
> >  
> > +#define ip_set_rcu_deref(t)		\
> > +	rcu_dereference_index_check(t,	\
> > +		rcu_read_lock_held() || rcu_read_lock_bh_held())
> > +
> 
> This is not used from this patch itself?

That is something leftover from an earlier phase, I remove it.
 
> >  static inline void
> >  ip_set_get_skbinfo(struct ip_set_skbinfo *skbinfo,
> >  		      const struct ip_set_ext *ext,
> > diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/linux/netfilter/ipset/ip_set_timeout.h
> > index 83c2f9e..1d6a935 100644
> > --- a/include/linux/netfilter/ipset/ip_set_timeout.h
> > +++ b/include/linux/netfilter/ipset/ip_set_timeout.h
> > @@ -40,38 +40,33 @@ ip_set_timeout_uget(struct nlattr *tb)
> >  }
> >  
> >  static inline bool
> > -ip_set_timeout_test(unsigned long timeout)
> > +ip_set_timeout_expired(unsigned long *t)
> >  {
> > -	return timeout == IPSET_ELEM_PERMANENT ||
> > -	       time_is_after_jiffies(timeout);
> > -}
> > -
> > -static inline bool
> > -ip_set_timeout_expired(unsigned long *timeout)
> > -{
> > -	return *timeout != IPSET_ELEM_PERMANENT &&
> > -	       time_is_before_jiffies(*timeout);
> > +	return *t != IPSET_ELEM_PERMANENT && time_is_before_jiffies(*t);
> >  }
> >  
> >  static inline void
> > -ip_set_timeout_set(unsigned long *timeout, u32 t)
> > +ip_set_timeout_set(unsigned long *timeout, u32 value)
> >  {
> > -	if (!t) {
> > +	unsigned long t;
> > +
> > +	if (!value) {
> >  		*timeout = IPSET_ELEM_PERMANENT;
> >  		return;
> >  	}
> >  
> > -	*timeout = msecs_to_jiffies(t * 1000) + jiffies;
> > -	if (*timeout == IPSET_ELEM_PERMANENT)
> > +	t = msecs_to_jiffies(value * MSEC_PER_SEC) + jiffies;
> > +	if (t == IPSET_ELEM_PERMANENT)
> >  		/* Bingo! :-) */
> > -		(*timeout)--;
> > +		t--;
> > +	*timeout = t;
> >  }
> >  
> >  static inline u32
> >  ip_set_timeout_get(unsigned long *timeout)
> >  {
> >  	return *timeout == IPSET_ELEM_PERMANENT ? 0 :
> > -		jiffies_to_msecs(*timeout - jiffies)/1000;
> > +		jiffies_to_msecs(*timeout - jiffies)/MSEC_PER_SEC;
> >  }
> >  
> >  #endif	/* __KERNEL__ */
> > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> > index 912e5a0..9fb2610 100644
> > --- a/net/netfilter/ipset/ip_set_core.c
> > +++ b/net/netfilter/ipset/ip_set_core.c
> > @@ -217,6 +217,7 @@ ip_set_type_register(struct ip_set_type *type)
> >  		 type->revision_min, type->revision_max);
> >  unlock:
> >  	ip_set_type_unlock();
> > +	synchronize_rcu();
> 
> Why this synchronize_rcu()?
> 
> ip_set_type_register() didn't publish any new object in the unlock
> path.

That's there just to have less line of code :-). I'll reorganize it so the 
unlock path won't call unnecessarily synchronize_rcu().

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
