From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/4,v2] netfilter: conntrack: introduce clash
 resolution on insertion race
Date: Tue, 3 May 2016 16:29:40 +0200
Message-ID: <20160503142940.GD2395@breakpoint.cc>
References: <1462276122-3532-1-git-send-email-pablo@netfilter.org>
 <20160503121426.GC2395@breakpoint.cc>
 <20160503123200.GA11077@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49693 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316AbcECO3o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 May 2016 10:29:44 -0400
Content-Disposition: inline
In-Reply-To: <20160503123200.GA11077@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > +		/* Don't modify skb->nfctinfo, we're at POSTROUTING so this
> > > +		 * packet is already leaving our framework, it is too late.
> > > +		 */
> > 
> > Note that this might be loopback in which case this skb will
> > reappear on PREROUTING.
> 
> The comment intention is that we probably already applied a filtering
> decision, so changing the ctinfo here seems awkward to me.

Hmm, but we did not drop the packet, else we would not have ended up in
_confirm().

> In NFQUEUE, this packet may have spent quite a bit of time so it may
> even get a different ctinfo if we reevaluate, but as I said, having
> packets changing its original ctinfo is...

OK, fair enough -- I just wanted to point out that for loopback clashes
we can end up with ->nfct neing set to the "old" one (already in hash
table) while ctinfo is the "new" one (from the ->nfct we tossed since
would could not add it to the table).

But I see that there is no good argument to chose one over the other.

So I'm fine with current version, sorry for the confusion.

> > > +		skb->nfct = &ct->ct_general;
> > > +		nf_ct_acct_merge(ct, ctinfo, old_ct);
> > > +		nf_ct_put(old_ct);
> > 
> > Perhaps it would be better to not have old_ct and instead
> > nf_conntrack_put(skb->nfct);
> > skb->nfct = &ct->ct_general;
> > 
> > ?
> 
> I can use this if you find it more readable, no problem.

Thanks!

> > > +	int ret;
> > >  
> > >  	ct = nf_ct_get(skb, &ctinfo);
> > >  	net = nf_ct_net(ct);
> > > @@ -727,10 +770,11 @@ __nf_conntrack_confirm(struct sk_buff *skb)
> > >  
> > >  out:
> > >  	nf_ct_add_to_dying_list(ct);
> > > +	ret = nf_ct_resolve_clash(net, skb, ct, ctinfo, h);
> > 
> > Is this safe?
> > Seems we jump to out label in other cases as well, not
> > just for clashes.
> 
> We're jumping out for dying conntracks too, and clash is handling this
> already so I considered not adding more code. I could just run
> nf_ct_resolve_clash() iff !nf_ct_dying() but I don't see much of a
> benefit on this.

I missed the nf_ct_dying test, that should indeed avoid operating on
*h garbage.
