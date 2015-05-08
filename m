From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 02/34] netfilter: ipset: Prepare the ipset core to use
 RCU at set level
Date: Fri, 8 May 2015 21:58:15 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1505082157260.16001@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu> <1430587703-3387-3-git-send-email-kadlec@blackhole.kfki.hu> <20150507233942.GA3971@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:60264 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbbEHT5r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2015 15:57:47 -0400
In-Reply-To: <20150507233942.GA3971@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 8 May 2015, Pablo Neira Ayuso wrote:

> On Sat, May 02, 2015 at 07:27:51PM +0200, Jozsef Kadlecsik wrote:
> > Replace rwlock_t with spinlock_t in "struct ip_set" and change the locking
> > accordingly. Also, simplify the timeout routines.
> > 
> > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > ---
> [...]
> > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> > index d259da3..a8e55c8 100644
> > --- a/net/netfilter/ipset/ip_set_core.c
> > +++ b/net/netfilter/ipset/ip_set_core.c
> > @@ -208,15 +208,15 @@ ip_set_type_register(struct ip_set_type *type)
> >  		pr_warn("ip_set type %s, family %s with revision min %u already registered!\n",
> >  			type->name, family_name(type->family),
> >  			type->revision_min);
> > -		ret = -EINVAL;
> > -		goto unlock;
> > +		ip_set_type_unlock();
> > +		return -EINVAL;
> >  	}
> >  	list_add_rcu(&type->list, &ip_set_type_list);
> >  	pr_debug("type %s, family %s, revision %u:%u registered.\n",
> >  		 type->name, family_name(type->family),
> >  		 type->revision_min, type->revision_max);
> > -unlock:
> >  	ip_set_type_unlock();
> > +	synchronize_rcu();
> 
> You don't need to call synchronize() after list_add_rcu().

Ohh, thanks! I'll correct that in the next version of the patches.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
