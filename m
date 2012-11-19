From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipset: Increase the number of maximal sets
 automatically as needed
Date: Mon, 19 Nov 2012 18:49:25 +0100
Message-ID: <20121119174925.GA30146@1984>
References: <alpine.DEB.2.00.1211191742240.22835@blackhole.kfki.hu>
 <20121119173206.GA27443@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42406 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836Ab2KSRtd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:49:33 -0500
Content-Disposition: inline
In-Reply-To: <20121119173206.GA27443@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 19, 2012 at 06:32:06PM +0100, Pablo Neira Ayuso wrote:
> Hi Jozsef,
> 
> On Mon, Nov 19, 2012 at 05:45:39PM +0100, Jozsef Kadlecsik wrote:
> > Hi Pablo,
> >
> > Please consider applying the next patch for the nf-next tree as it's a new
> > feature. You can also pull the patch from here:
> >
> >         git://blackhole.kfki.hu/nf-next master
> >
> > The max number of sets was hardcoded at kernel cofiguration time.
> > The patch adds the support to increase the max number of sets automatically.
> >
> > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > ---
> >  net/netfilter/ipset/ip_set_core.c |   59 ++++++++++++++++++++++++++++++++-----
> >  1 files changed, 51 insertions(+), 8 deletions(-)
> >
> > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> > index 778465f..05bc604 100644
> > --- a/net/netfilter/ipset/ip_set_core.c
> > +++ b/net/netfilter/ipset/ip_set_core.c
> > @@ -31,6 +31,7 @@ static DEFINE_RWLOCK(ip_set_ref_lock);		/* protects the set refs */
> >  static struct ip_set **ip_set_list;		/* all individual sets */
> >  static ip_set_id_t ip_set_max = CONFIG_IP_SET_MAX; /* max number of sets */
> >
> > +#define IP_SET_INC	64
> >  #define STREQ(a, b)	(strncmp(a, b, IPSET_MAXNAMELEN) == 0)
> >
> >  static unsigned int max_sets;
> > @@ -344,12 +345,26 @@ __ip_set_put(ip_set_id_t index)
> >   * so it can't be destroyed (or changed) under our foot.
> >   */
> >
> > +static inline struct ip_set *
> > +ip_set_rcu_get(ip_set_id_t index)
> > +{
> > +	struct ip_set *set, **list;
> > +
> > +	rcu_read_lock();
> > +	/* ip_set_list itself needs to be protected */
> > +	list = rcu_dereference(ip_set_list);
> > +	set = list[index];
> 
> You can simplify the two lines above with:
>         list = rcu_dereference(ip_set_list[index]);
> 
> > +	rcu_read_unlock();
> 
> Note that out of the rcu_read_unlock that `set' pointer is not granted
> to be valid.
> 
> So you have to call rcu_read_unlock once you are sure you don't need
> to access your `set' object anymore, eg.
> 
> int ip_set_test(...)
> {
>         struct ip_set *set;
>         int ret = 0;
> 
>         rcu_read_lock();
>         set = rcu_dereference(ip_set_list[index]);
> 
>         ...
> 
>         rcu_read_unlock();
> 
>         /* Convert error codes to nomatch */
>         return (ret < 0 ? 0 : ret);
> }
> EXPORT_SYMBOL_GPL(ip_set_test);

Oh, I see, set objects are not protected with rcu, only the set array
is protected with rcu. So any dereference out of the rcu_read_lock
section is valid. Forget the comment.
