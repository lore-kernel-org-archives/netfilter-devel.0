From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables conntrack set ops for zone, helper assignment, etc.
Date: Thu, 12 Jan 2017 14:29:30 +0100
Message-ID: <20170112132930.GA24985@breakpoint.cc>
References: <20170111091721.GA26703@breakpoint.cc>
 <20170111200749.GA16953@salvia>
 <20170111230141.GA10141@breakpoint.cc>
 <20170112130035.GA1816@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        christophe.leroy@c-s.fr
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36702 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751010AbdALN3i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2017 08:29:38 -0500
Content-Disposition: inline
In-Reply-To: <20170112130035.GA1816@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jan 12, 2017 at 12:01:41AM +0100, Florian Westphal wrote:
> > ct zone set meta mark   # as per my proposal -- set template
> > ct eventmask set new	# as per my proposal -- lookup&change real conntrack
> > ct helper set "foo"	# as per my proposal, lookup and change real
> > conntrack if its unconfirmed, EXCEPT helper is not looked up based on skb
> > payload and name "foo" but instead taken from objref infrastructure.
> > Same for timeout.
> 
> Yes, something like the one above. By look&change, you refer to this?
> 
> ct = nf_ct_get(...);
> if (!ct || !nf_ct_unconfirmed(ct))
>         return;
> 
> /*
>  * ... update ct with helper here.
>  */

No, I meant more intrusive version:

ct = nf_ct_get(...);
if (!ct || nf_ct_is_template(ct))))
	nf_conntrack_in(net, info->pf, hook, skb);

ct = nf_ct_get(...);
if (!ct)
	return;

switch (priv->key) {
case NFT_CT_MARK:
	ct->mark = sreg32;
	break;
case NFT_CT_HELPER:
	if (nf_ct_is_confirmed(ct))
		return; /* too late */

	/* update helper here. sreg contains name of objectref,
	 * so we'd use that to obtain a helper template, then set/add
	 * helper extension to ct based on that.
	 * But we don't set skb->nfct to the template, we only use
	 * it as source to get the needed helper information.
	 */
	break;
case NFT_CT_EVENTMASK:
	struct nf_conntrack_ecache *e = nf_ct_ecache_find(ct);

	if (!e) {
		if (!nf_ct_is_confirmed(ct))
			nf_ct_ecache_ext_add(ct, sreg16, ~0, GFP_ATOMIC);
		return;
	}

	e->ctmask = sreg16;
	break;
case ...
}

NFT_CT_ZONE would have its own eval() version that doesn't
call nf_conntrack_in but instead sets up skb->nfct to a percpu template
that will then be used to transport the zoneinfo until nf_conntrack_in
is called (either by later hook or by later call via 'ct foo set bar').

[ unless skb->nfct is != NULL, then its a no-op ]

> For timeouts, after a second look I think this is more complicated: we
> set them from nf_conntrack_in() via l4proto->packet(). Thus, if we add
> the conntrack extension to store timeouts later on, the first
> conntrack state will not get refreshed with the right timeout.
>
> Assuming this is the first packet of a flow, that should be easy to
> amend later. But if we pickup a flow from the middle, timeout
> amendment gets a bit more tricky.  Calling l4proto->packet() is not
> possible either since this sets packets as invalid, so we can drop it
> from the ruleset.

Ok.  However I don't see why this isn't solveable in some way.

We could e.g. add a new l4proto callback, something like
l4proto->update_timeouts(ct, timeouts);

> Back to helpers, users are familiar with the current way to attach
> helpers, ie. from the raw chain.
> 
> Am I missing anything? I'm starting to think we can't escape the
> conntrack template.

For Helpers?  Why not?  As long as ct isn't in the main table it should
be fine afaics?  (Unless you mean "can't escape conntrack template to
read to helper info that we need to assign to ct from".

For zones, yes, I don't see a way to avoid a template for them.
But thats the only ct key where I think that a template has to be used.
