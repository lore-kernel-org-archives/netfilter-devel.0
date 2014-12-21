From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/8] netfilter: ipset: Prepare ipset core for RCU locking
 instead of rwlock per set
Date: Sun, 21 Dec 2014 13:23:34 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1412211320060.6226@blackhole.kfki.hu>
References: <1418421489-17411-1-git-send-email-kadlec@blackhole.kfki.hu> <1418421489-17411-3-git-send-email-kadlec@blackhole.kfki.hu> <20141218183833.GA3552@salvia> <alpine.DEB.2.10.1412211227300.5985@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:34812 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbaLUMW2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Dec 2014 07:22:28 -0500
In-Reply-To: <alpine.DEB.2.10.1412211227300.5985@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 21 Dec 2014, Jozsef Kadlecsik wrote:

> > More concerns: Let's revisit __list_set_del():
> > 
> > >static void
> > >__list_set_del(struct ip_set *set, struct set_elem *e)
> > > {
> > >        struct list_set *map = set->data;
> > > 
> > >        ip_set_put_byindex(map->net, e->id);
> > >        /* We may call it, because we don't have a to be destroyed
> > >         * extension which is used by the kernel.
> > >         */
> > >        ip_set_ext_destroy(set, e);
> >          ^.......................^
> > 
> > You may have a reader still walking on the extension area of the
> > element by when you call this.
> 
> Hm, I think this is valid, too: there can be an ongoing listing.
> 
> > >        kfree_rcu(e, rcu);
> > >}
> > 
> > The alternative to make sure that everything is released by when no
> > readers are accessing the object anymore is to use call_rcu():
> > 
> >         call_rcu(e, ipset_list_free_rcu);
> > 
> > Then:
> > 
> > static void ipset_list_free_rcu(struct rcu_head *rcu)
> > {
> >         ip_set_put_byindex(...);
> >         ip_set_ext_destroy(...);
> >         kfree(set);
> > }
> > 
> > This safely release memory with 100% guarantee no readers are accesing
> > the object you're destroying.
> > 
> > *But* you have to make sure none of those function in the callback may
> > sleep. Since this callback is called from the rcu softirq (interrupt
> > context).
> 
> That is fine, no function which'd sleep is called.
> 
> > I suspect (actually I would need to make a closer look) you cannot use
> > this pattern easily unless elements keep a pointer to the set they
> > belong to, to access the data you need from the callback.
> 
> Yes, that is the case exactly...

I can split it up into two call_rcu invocations: one for the extensions 
and one for the member elements. Because the destroy functions are called 
after the grace period, no reader will access the memory areas and the 
call order of the destroy functions does not matter.

I'm going to work on this approach - which must be applied to the hash 
types as well.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
