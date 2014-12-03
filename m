From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 10/14] netfilter: ipset: Introduce RCU locking in the
 list type
Date: Wed, 3 Dec 2014 12:17:36 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1412031206530.21739@blackhole.kfki.hu>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu> <1417373825-3734-11-git-send-email-kadlec@blackhole.kfki.hu> <20141202183539.GC4504@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:33293 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaLCLQh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:16:37 -0500
In-Reply-To: <20141202183539.GC4504@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2 Dec 2014, Pablo Neira Ayuso wrote:

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

The module can be removed only when there isn't a single set of the given 
type. That means there are no elements to be removed by kfree_rcu(). 
Therefore I think rcu_barrier() is not required in the module removal 
path.

> > @@ -91,13 +88,9 @@ list_set_kadd(struct ip_set *set, const struct sk_buff *skb,
> >  {
> >  	struct list_set *map = set->data;
> >  	struct set_elem *e;
> > -	u32 i;
> >  	int ret;
> >  
> > -	for (i = 0; i < map->size; i++) {
> > -		e = list_set_elem(set, map, i);
> > -		if (e->id == IPSET_INVALID_ID)
> > -			return 0;
> > +	list_for_each_entry_rcu(e, &map->members, list) {
> 
> >From net/netfilter/ipset/ip_set_core.c I can see this kadd() will be
> called under spin_lock_bh(), so you can just use
> list_for_each_entry(). The _rcu() variant protects the reader side,
> but this code is only invoked from the writer side (no changes are
> guaranteed to happen there).

Yes, you are right! I'll correct it.

> >  static int
> >  list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> > @@ -282,60 +240,82 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> >  {
> >  	struct list_set *map = set->data;
> >  	struct set_adt_elem *d = value;
> > -	struct set_elem *e;
> > +	struct set_elem *e, *n, *prev, *next;
> >  	bool flag_exist = flags & IPSET_FLAG_EXIST;
> > -	u32 i, ret = 0;
> >  
> >  	if (SET_WITH_TIMEOUT(set))
> >  		set_cleanup_entries(set);
> >  
> > -	/* Check already added element */
> > -	for (i = 0; i < map->size; i++) {
> > -		e = list_set_elem(set, map, i);
> > -		if (e->id == IPSET_INVALID_ID)
> > -			goto insert;
> > -		else if (e->id != d->id)
> > +	/* Find where to add the new entry */
> > +	n = prev = next = NULL;
> > +	list_for_each_entry(e, &map->members, list) {
> > +		if (SET_WITH_TIMEOUT(set) &&
> > +		    ip_set_timeout_expired(ext_timeout(e, set)))
> >  			continue;
> > -
> > -		if ((d->before > 1 && !id_eq(set, i + 1, d->refid)) ||
> > -		    (d->before < 0 &&
> > -		     (i == 0 || !id_eq(set, i - 1, d->refid))))
> > -			/* Before/after doesn't match */
> > +		else if (d->id == e->id)
> > +			n = e;
> > +		else if (d->before == 0 || e->id != d->refid)
> > +			continue;
> > +		else if (d->before > 0)
> > +			next = e;
> > +		else
> > +			prev = e;
> > +	}
> > +	/* Re-add already existing element */
> > +	if (n) {
> > +		if ((d->before > 0 && !next) ||
> > +		    (d->before < 0 && !prev))
> >  			return -IPSET_ERR_REF_EXIST;
> >  		if (!flag_exist)
> > -			/* Can't re-add */
> >  			return -IPSET_ERR_EXIST;
> >  		/* Update extensions */
> > -		ip_set_ext_destroy(set, e);
> > +		ip_set_ext_destroy(set, n);
> > +		list_set_init_extensions(set, ext, n);
> >  
> > -		if (SET_WITH_TIMEOUT(set))
> > -			ip_set_timeout_set(ext_timeout(e, set), ext->timeout);
> > -		if (SET_WITH_COUNTER(set))
> > -			ip_set_init_counter(ext_counter(e, set), ext);
> > -		if (SET_WITH_COMMENT(set))
> > -			ip_set_init_comment(ext_comment(e, set), ext);
> > -		if (SET_WITH_SKBINFO(set))
> > -			ip_set_init_skbinfo(ext_skbinfo(e, set), ext);
> >  		/* Set is already added to the list */
> >  		ip_set_put_byindex(map->net, d->id);
> >  		return 0;
> >  	}
> > -insert:
> > -	ret = -IPSET_ERR_LIST_FULL;
> > -	for (i = 0; i < map->size && ret == -IPSET_ERR_LIST_FULL; i++) {
> > -		e = list_set_elem(set, map, i);
> > -		if (e->id == IPSET_INVALID_ID)
> > -			ret = d->before != 0 ? -IPSET_ERR_REF_EXIST
> > -				: list_set_add(set, i, d, ext);
> > -		else if (e->id != d->refid)
> > -			continue;
> > -		else if (d->before > 0)
> > -			ret = list_set_add(set, i, d, ext);
> > -		else if (i + 1 < map->size)
> > -			ret = list_set_add(set, i + 1, d, ext);
> > +	/* Add new entry */
> > +	if (d->before == 0) {
> > +		/* Append  */
> > +		n = list_empty(&map->members) ? NULL :
> > +		    list_last_entry(&map->members, struct set_elem, list);
> > +	} else if (d->before > 0) {
> > +		/* Insert after next element */
> > +		if (!list_is_last(&next->list, &map->members))
> > +			n = list_next_entry(next, list);
> > +	} else {
> > +		/* Insert before prev element */
> > +		if (prev->list.prev != &map->members)
> > +			n = list_prev_entry(prev, list);
> >  	}
> > -
> > -	return ret;
> > +	/* Can we replace a timed out entry? */
> > +	if (n != NULL &&
> > +	    !(SET_WITH_TIMEOUT(set) &&
> > +	      ip_set_timeout_expired(ext_timeout(n, set))))
> > +		n =  NULL;
> > +
> > +	e = kzalloc(set->dsize, GFP_KERNEL);
> > +	if (!e)
> > +		return -ENOMEM;
> > +	e->id = d->id;
> > +	INIT_LIST_HEAD(&e->list);
> > +	list_set_init_extensions(set, ext, e);
> > +	if (n)
> > +		list_set_replace(set, e, n);
> > +	else if (next)
> > +		list_add_tail_rcu(&e->list, &next->list);
> > +	else if (prev)
> > +		list_add_rcu(&e->list, &prev->list);
> > +	else
> > +		list_add_tail_rcu(&e->list, &map->members);
> > +	spin_unlock_bh(&set->lock);
> > +
> > +	synchronize_rcu_bh();
> 
> I suspect you don't need this. What is your intention here?

Here the userspace adds/deletes/replaces an element in the list type of 
set and in the meantime the kernel module can traverse the same linked 
list. In the replace case we remove and delete the old entry, therefore 
the call to synchronize_rcu_bh(). That could be called from a condition 
then, to express the case.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
