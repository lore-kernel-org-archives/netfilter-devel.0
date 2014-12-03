From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 10/14] netfilter: ipset: Introduce RCU locking in the
 list type
Date: Wed, 3 Dec 2014 12:36:42 +0100
Message-ID: <20141203113642.GA4122@salvia>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1417373825-3734-11-git-send-email-kadlec@blackhole.kfki.hu>
 <20141202183539.GC4504@salvia>
 <alpine.DEB.2.10.1412031206530.21739@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50595 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbaLCLe0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:34:26 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1412031206530.21739@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 03, 2014 at 12:17:36PM +0100, Jozsef Kadlecsik wrote:
> On Tue, 2 Dec 2014, Pablo Neira Ayuso wrote:
> 
> > On Sun, Nov 30, 2014 at 07:57:01PM +0100, Jozsef Kadlecsik wrote:
> > > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > > ---
> > >  net/netfilter/ipset/ip_set_list_set.c | 386 ++++++++++++++++------------------
> > >  1 file changed, 182 insertions(+), 204 deletions(-)
> > > 
> > > diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
> > > index f8f6828..323115a 100644
> > > --- a/net/netfilter/ipset/ip_set_list_set.c
> > > +++ b/net/netfilter/ipset/ip_set_list_set.c
> > > @@ -9,6 +9,7 @@
> > >  
> > >  #include <linux/module.h>
> > >  #include <linux/ip.h>
> > > +#include <linux/rculist.h>
> > >  #include <linux/skbuff.h>
> > >  #include <linux/errno.h>
> > >  
> > > @@ -27,6 +28,8 @@ MODULE_ALIAS("ip_set_list:set");
> > >  
> > >  /* Member elements  */
> > >  struct set_elem {
> > > +	struct rcu_head rcu;
> > > +	struct list_head list;
> > 
> > I think rcu_barrier() in the module removal path is missing to make
> > sure call_rcu() is called before the module is gone.
> 
> The module can be removed only when there isn't a single set of the given 
> type. That means there are no elements to be removed by kfree_rcu(). 
> Therefore I think rcu_barrier() is not required in the module removal 
> path.

I think this can race with the rcu callback execution. See this:

https://www.kernel.org/doc/Documentation/RCU/rcubarrier.txt

specifically: Unloading Modules That Use call_rcu()

[...]
> > > +	/* Can we replace a timed out entry? */
> > > +	if (n != NULL &&
> > > +	    !(SET_WITH_TIMEOUT(set) &&
> > > +	      ip_set_timeout_expired(ext_timeout(n, set))))
> > > +		n =  NULL;
> > > +
> > > +	e = kzalloc(set->dsize, GFP_KERNEL);
> > > +	if (!e)
> > > +		return -ENOMEM;
> > > +	e->id = d->id;
> > > +	INIT_LIST_HEAD(&e->list);
> > > +	list_set_init_extensions(set, ext, e);
> > > +	if (n)
> > > +		list_set_replace(set, e, n);
> > > +	else if (next)
> > > +		list_add_tail_rcu(&e->list, &next->list);
> > > +	else if (prev)
> > > +		list_add_rcu(&e->list, &prev->list);
> > > +	else
> > > +		list_add_tail_rcu(&e->list, &map->members);
> > > +	spin_unlock_bh(&set->lock);
> > > +
> > > +	synchronize_rcu_bh();
> > 
> > I suspect you don't need this. What is your intention here?
> 
> Here the userspace adds/deletes/replaces an element in the list type of 
> set and in the meantime the kernel module can traverse the same linked 
> list. In the replace case we remove and delete the old entry, therefore 
> the call to synchronize_rcu_bh(). That could be called from a condition 
> then, to express the case.

But you're releasing objects via kfree_rcu(), right? Then you don't
need to wait for the rcu grace state.
