From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] netfilter: ipset: Fix set:list type crash when
 flush/dump set in parallel
Date: Mon, 29 Feb 2016 13:47:59 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1602291325430.21350@blackhole.kfki.hu>
References: <1456345166-23605-1-git-send-email-kadlec@blackhole.kfki.hu> <1456345166-23605-2-git-send-email-kadlec@blackhole.kfki.hu> <20160229122218.GA12101@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:56742 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbcB2MrU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 07:47:20 -0500
In-Reply-To: <20160229122218.GA12101@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 29 Feb 2016, Pablo Neira Ayuso wrote:

> On Wed, Feb 24, 2016 at 09:19:26PM +0100, Jozsef Kadlecsik wrote:
> > Flushing/listing entries was not RCU safe, so parallel flush/dump
> > could lead to kernel crash. Bug reported by Deniz Eren.
> > 
> > Fixes netfilter bugzilla id #1050.
> > 
> > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > ---
> >  net/netfilter/ipset/ip_set_core.c     |  3 ++
> >  net/netfilter/ipset/ip_set_list_set.c | 55 ++++++++++++++++-------------------
> >  2 files changed, 28 insertions(+), 30 deletions(-)
> > 
> > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> > index 95db43f..7e6568c 100644
> > --- a/net/netfilter/ipset/ip_set_core.c
> > +++ b/net/netfilter/ipset/ip_set_core.c
> > @@ -985,6 +985,9 @@ static int ip_set_destroy(struct net *net, struct sock *ctnl,
> >  	if (unlikely(protocol_failed(attr)))
> >  		return -IPSET_ERR_PROTOCOL;
> >  
> > +	/* Must wait for flush to be really finished in list:set */
> > +	rcu_barrier();
> 
> Jozsef, are you sure you need this rcu_barrier()?
> 
> This is waiting for rcu callback completion (ie. decrement the set
> reference counter and releasing the extension and object itself).

Yes, that's exactly what it's waiting for, in the case of sets which are 
elements in set:list type of sets.

> The rcu read side should be safe when accessing old copies from the
> dumping path when using call_rcu().

Three competing actions play role here: flush/delete, destroy, dumping. 
The rcu_barrier() above waits for the flush/delete actions. The rcu read 
side has access to the set id only and must lookup the set by id in order 
to get the name, which is protected by a reference counter. The function 
ip_set_name_byindex() intentionally checks that the reference counter 
cannot be equal to zero and I believe it's an important internal sanity 
checking and I don't want to remove it. The problem was that the reference 
counter of the set was first decremented at flush/delete and so we could 
get a BUG_ON() crash in ip_set_name_byindex() when an ongoing dumping was 
processed. So the reference counter must be released last for a successful 
parallel dumping. If rcu_barrier() was not added to the destroy path, a 
"destroy" immediately following a "flush" can lead to the error "set is in 
use, cannot delete". I tested it and couldn't find a simpler way.

It is the destroy path for sets, so it should not be performance critical.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
