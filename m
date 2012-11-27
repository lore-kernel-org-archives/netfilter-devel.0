From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: ipset: Increase the number of maximal sets
 automatically as needed
Date: Tue, 27 Nov 2012 12:55:00 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211271246020.14623@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1211202017260.27297@blackhole.kfki.hu> <20121127104856.GA27734@1984> <alpine.DEB.2.00.1211271207300.14623@blackhole.kfki.hu> <20121127113353.GA30478@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:46994 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab2K0LzD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:55:03 -0500
In-Reply-To: <20121127113353.GA30478@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 27 Nov 2012, Pablo Neira Ayuso wrote:

> On Tue, Nov 27, 2012 at 12:18:30PM +0100, Jozsef Kadlecsik wrote:
> > 
> > On Tue, 27 Nov 2012, Pablo Neira Ayuso wrote:
> > 
> > > I've got one question regarding this patch:
> > [...] 
> > > > @@ -730,10 +775,9 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
> > > >  	 * and check clashing.
> > > >  	 */
> > > >  	ret = find_free_id(set->name, &index, &clash);
> > > > -	if (ret != 0) {
> > > > +	if (ret == -EEXIST) {
> > > >  		/* If this is the same set and requested, ignore error */
> > > > -		if (ret == -EEXIST &&
> > > > -		    (flags & IPSET_FLAG_EXIST) &&
> > > > +		if ((flags & IPSET_FLAG_EXIST) &&
> > > >  		    STREQ(set->type->name, clash->type->name) &&
> > > >  		    set->type->family == clash->type->family &&
> > > >  		    set->type->revision_min == clash->type->revision_min &&
> > > > @@ -741,13 +785,36 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
> > > >  		    set->variant->same_set(set, clash))
> > > >  			ret = 0;
> > > >  		goto cleanup;
> > > > -	}
> > > > +	} else if (ret == -IPSET_ERR_MAX_SETS) {
> > > > +		struct ip_set **list, **tmp;
> > > > +		ip_set_id_t i = ip_set_max + IP_SET_INC;
> > > > +
> > > > +		if (i < ip_set_max)
> > > > +			/* Wraparound */
> > > > +			goto cleanup;
> > > > +
> > > > +		list = kzalloc(sizeof(struct ip_set *) * i, GFP_KERNEL);
> > > > +		if (!list)
> > > > +			goto cleanup;
> > > > +		/* nfnl mutex is held, both lists are valid */
> > > > +		tmp = nfnl_dereference(ip_set_list);
> > > > +		memcpy(list, tmp, sizeof(struct ip_set *) * ip_set_max);
> > > > +		rcu_assign_pointer(ip_set_list, list);
> > > > +		/* Make sure all current packets have passed through */
> > > > +		synchronize_net();
> > > > +		/* Use new list */
> > > > +		index = ip_set_max;
> > > > +		ip_set_max = i;
> > > > +		kfree(tmp);
> > > > +		ret = 0;
> > > 
> > > I can see that this increases in 64 new slots the array of sets every
> > > time the this hits -IPSET_ERR_MAX_SETS. And that can be happen on and
> > > on, without limitation AFAICS.
> > 
> > No, the ip_set_id_t is actually u16. A few lines above the wraparound is 
> > checked and at that point the increasing of the array is stopped.
> 
> Ah, I see. So we've got an implicit limit of 65536.
> 
> > > Why not just some specific operation to set a new ip_set_max value and
> > > readjust the array of sets in that case? Thus, the user is in full
> > > control of the maximum number of sets and we don't have to assume
> > > anything.
> > 
> > That'd need another knob - this way the array is increased as needed.
> > The user doesn't have to count the required sets in advance, just create.
> 
> Yes, that would require some new netlink command. I tend to prefer
> explicit configuration options. My concern is that day someone will
> come and say that 2^16 are not enough for them. Then, we'll have to
> add some explicit upper limit and allow to modify it.

That'd be non trivial, because the whole array should then be replaced 
with something else for faster access from user space when the set is 
searched by name. The kernel always refers to the index.
 
> But I'm all fine if you like it this way. We can just document that
> the new maximum amount of sets 65536.

It's "documented" in the input range of the "Maximum number of IP 
sets" configuration parameter in Kconfig. Should I add it explicitely to 
the help text? Or directly to the title line?

> > But please discard this patch, I'm going to send you a completed one, 
> > which survived not only the compiling but the testsuite too.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
