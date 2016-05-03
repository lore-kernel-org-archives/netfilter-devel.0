From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/4,v2] netfilter: conntrack: introduce clash
 resolution on insertion race
Date: Tue, 3 May 2016 14:32:00 +0200
Message-ID: <20160503123200.GA11077@salvia>
References: <1462276122-3532-1-git-send-email-pablo@netfilter.org>
 <20160503121426.GC2395@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56711 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbcECMcG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 May 2016 08:32:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5200F114801
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 14:32:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3F3C13591
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 14:32:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9A791A862
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 14:32:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160503121426.GC2395@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 03, 2016 at 02:14:26PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This patch introduces nf_ct_resolve_clash() to resolve race condition on
> > conntrack insertions.
> > 
> > This is particularly a problem for connection-less protocols such as
> > UDP, with no initial handshake. Two or more packets may race to insert
> > the entry resulting in packet drops.
> > 
> > Another problematic scenario are packets enqueued to userspace via
> > NFQUEUE after the raw table, that make it easier to trigger this
> > race.
> > 
> > To resolve this, the idea is to reset the conntrack entry to the one
> > that won race. Packet and bytes counters are also merged.
> > 
> > The 'insert_failed' stats still accounts for this situation, after
> > this patch, the drop counter is bumped whenever we drop packets, so we
> > can watch for unresolved clashes.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: drop refcount of the old conntrack entry, otherwise we leak this.
> >     Call nf_ct_add_to_dying_list() before clash resolution.
> > +/* Resolve race on insertion if this protocol allows this. */
> > +static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
> > +			       struct nf_conn *old_ct,
> > +			       enum ip_conntrack_info ctinfo,
> > +			       struct nf_conntrack_tuple_hash *h)
> > +{
> > +	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
> > +	struct nf_conntrack_l4proto *l4proto;
> > +
> > +	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
> > +	if (l4proto->allow_clash &&
> > +	    !nf_ct_is_dying(ct) &&
> > +	    atomic_inc_not_zero(&ct->ct_general.use)) {
> 
> I found this confusing, perhaps add small one-liner comment that
> *ct is in fact ct already in the table, not the one that was attached
> to skb->nfct (perhaps I just need more coffee, sorry).

OK, will add this.

> > +		/* Don't modify skb->nfctinfo, we're at POSTROUTING so this
> > +		 * packet is already leaving our framework, it is too late.
> > +		 */
> 
> Note that this might be loopback in which case this skb will
> reappear on PREROUTING.

The comment intention is that we probably already applied a filtering
decision, so changing the ctinfo here seems awkward to me.

In NFQUEUE, this packet may have spent quite a bit of time so it may
even get a different ctinfo if we reevaluate, but as I said, having
packets changing its original ctinfo is...

> > +		skb->nfct = &ct->ct_general;
> > +		nf_ct_acct_merge(ct, ctinfo, old_ct);
> > +		nf_ct_put(old_ct);
> 
> Perhaps it would be better to not have old_ct and instead
> nf_conntrack_put(skb->nfct);
> skb->nfct = &ct->ct_general;
> 
> ?

I can use this if you find it more readable, no problem.

> > +	int ret;
> >  
> >  	ct = nf_ct_get(skb, &ctinfo);
> >  	net = nf_ct_net(ct);
> > @@ -727,10 +770,11 @@ __nf_conntrack_confirm(struct sk_buff *skb)
> >  
> >  out:
> >  	nf_ct_add_to_dying_list(ct);
> > +	ret = nf_ct_resolve_clash(net, skb, ct, ctinfo, h);
> 
> Is this safe?
> Seems we jump to out label in other cases as well, not
> just for clashes.

We're jumping out for dying conntracks too, and clash is handling this
already so I considered not adding more code. I could just run
nf_ct_resolve_clash() iff !nf_ct_dying() but I don't see much of a
benefit on this.
