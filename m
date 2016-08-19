From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 2/6] netfilter: conntrack: get rid of conntrack
 timer
Date: Fri, 19 Aug 2016 17:16:42 +0200
Message-ID: <20160819151642.GA11049@breakpoint.cc>
References: <1471606575-2197-1-git-send-email-fw@strlen.de>
 <1471606575-2197-3-git-send-email-fw@strlen.de>
 <1471617465.29842.102.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56966 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754146AbcHSPQo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Aug 2016 11:16:44 -0400
Content-Disposition: inline
In-Reply-To: <1471617465.29842.102.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > +/* caller must hold rcu readlock and none of the nf_conntrack_locks */
> > +static void nf_ct_gc_expired(struct nf_conn *ct)
> > +{
> > +	if (!atomic_inc_not_zero(&ct->ct_general.use))
> > +		return;
> > +
> > +	if (nf_ct_should_gc(ct))
> > +		nf_ct_kill(ct);
> > +
> > +	nf_ct_put(ct);
> > +}
> > +
> >  /*
> >   * Warning :
> >   * - Caller must take a reference on returned object
> > @@ -499,6 +505,17 @@ begin:
> >  	bucket = reciprocal_scale(hash, hsize);
> >  
> >  	hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[bucket], hnnode) {
> > +		struct nf_conn *ct;
> > +
> > +		ct = nf_ct_tuplehash_to_ctrack(h);
> > +		if (nf_ct_is_expired(ct)) {
> > +			nf_ct_gc_expired(ct);
> > +			continue;
> > +		}
> > +
> > +		if (nf_ct_is_dying(ct))
> > +			continue;
> > +
> >  		if (nf_ct_key_equal(h, tuple, zone, net)) {
> >  			NF_CT_STAT_INC_ATOMIC(net, found);
> >  			return h;
> 
> Florian, I do not see how this part is safe against concurrent lookups
> and deletes ?
> 
> At least the hlist_nulls_for_each_entry_rcu() looks buggy, since
> fetching the next pointer would trigger a use after free ?

Hmm, ____nf_conntrack_find caller needs to hold rcu_read_lock,
in case object is free'd SLAB_DESTROY_BY_RCU should delay actual release
of the page.

Should be same as (old) 'death_by_timeout' timer firing during
hlist_nulls_for_each_entry_rcu walk.

Thanks for looking at this Eric!
