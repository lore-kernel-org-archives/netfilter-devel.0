From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 11/14] netfilter: ipset: Introduce RCU locking in the
 hash types
Date: Wed, 3 Dec 2014 12:23:26 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1412031217480.21739@blackhole.kfki.hu>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu> <1417373825-3734-12-git-send-email-kadlec@blackhole.kfki.hu> <20141202184012.GD4504@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:34570 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbaLCLW0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:22:26 -0500
In-Reply-To: <20141202184012.GD4504@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2 Dec 2014, Pablo Neira Ayuso wrote:

> > diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> > index 974ff38..8f51ba4 100644
> > --- a/net/netfilter/ipset/ip_set_hash_gen.h
> > +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> > @@ -10,19 +10,19 @@
> >  
> >  #include <linux/rcupdate.h>
> >  #include <linux/jhash.h>
> > +#include <linux/types.h>
> >  #include <linux/netfilter/ipset/ip_set_timeout.h>
> > -#ifndef rcu_dereference_bh
> > -#define rcu_dereference_bh(p)	rcu_dereference(p)
> > -#endif
> > +
> > +#define __ipset_dereference_protected(p, c)	rcu_dereference_protected(p, c)
> > +#define ipset_dereference_protected(p, set) \
> > +	__ipset_dereference_protected(p, spin_is_locked(&(set)->lock))
> >  
> >  #define rcu_dereference_bh_nfnl(p)	rcu_dereference_bh_check(p, 1)
> >  
> [...]
> >  /* Flush a hash type of set: destroy all elements */
> > @@ -376,16 +359,16 @@ mtype_flush(struct ip_set *set)
> >  	struct hbucket *n;
> >  	u32 i;
> >  
> > -	t = rcu_dereference_bh_nfnl(h->table);
> > +	t = ipset_dereference_protected(h->table, set);
> >  	for (i = 0; i < jhash_size(t->htable_bits); i++) {
> > -		n = hbucket(t, i);
> > -		if (n->size) {
> > -			if (set->extensions & IPSET_EXT_DESTROY)
> > -				mtype_ext_cleanup(set, n);
> > -			n->size = n->pos = 0;
> > -			/* FIXME: use slab cache */
> > -			kfree(n->value);
> > -		}
> > +		n = __ipset_dereference_protected(hbucket(t, i), 1);
> 
> What is your intention with these macros?

The macros serve to solve sparse checking warnings. Without the macros one 
can get:

/usr/src/git/ipset/ipset/kernel/net/netfilter/ipset/ip_set_hash_gen.h:369:19: 
warning: incorrect type in assignment (different address spaces)
/usr/src/git/ipset/ipset/kernel/net/netfilter/ipset/ip_set_hash_gen.h:369:19:    
expected struct hbucket *n
/usr/src/git/ipset/ipset/kernel/net/netfilter/ipset/ip_set_hash_gen.h:369:19:    
got struct hbucket [noderef] <asn:4>*<noident>

The real condition (spin is locked) is always checked before the loop, in 
ipset_dereference_protected. Inside the loop it's not checked again and 
again.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
