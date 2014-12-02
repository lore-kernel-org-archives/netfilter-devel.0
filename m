From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 10/14] netfilter: ipset: Introduce RCU locking in the
 list type
Date: Tue, 2 Dec 2014 19:52:17 +0100
Message-ID: <20141202185217.GA5089@salvia>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1417373825-3734-11-git-send-email-kadlec@blackhole.kfki.hu>
 <20141202183539.GC4504@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58527 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313AbaLBSuB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:50:01 -0500
Content-Disposition: inline
In-Reply-To: <20141202183539.GC4504@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 02, 2014 at 07:35:39PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Nov 30, 2014 at 07:57:01PM +0100, Jozsef Kadlecsik wrote:
> > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > ---
> >  net/netfilter/ipset/ip_set_list_set.c | 386 ++++++++++++++++------------------
> >  1 file changed, 182 insertions(+), 204 deletions(-)
> > 
> > diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
> > index f8f6828..323115a 100644
> > --- a/net/netfilter/ipset/ip_set_list_set.c
> > +++ b/net/netfilter/ipset/ip_set_list_set.c
> > @@ -9,6 +9,7 @@
> >  
> >  #include <linux/module.h>
> >  #include <linux/ip.h>
> > +#include <linux/rculist.h>
> >  #include <linux/skbuff.h>
> >  #include <linux/errno.h>
> >  
> > @@ -27,6 +28,8 @@ MODULE_ALIAS("ip_set_list:set");
> >  
> >  /* Member elements  */
> >  struct set_elem {
> > +	struct rcu_head rcu;
> > +	struct list_head list;
> 
> I think rcu_barrier() in the module removal path is missing to make
> sure call_rcu() is called before the module is gone.

I mean, we make sure rcu softirq runs to release these objects before
the module is gone.
