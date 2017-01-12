From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables conntrack set ops for zone, helper assignment, etc.
Date: Thu, 12 Jan 2017 15:28:18 +0100
Message-ID: <20170112142818.GA3211@salvia>
References: <20170111091721.GA26703@breakpoint.cc>
 <20170111200749.GA16953@salvia>
 <20170111230141.GA10141@breakpoint.cc>
 <20170112130035.GA1816@salvia>
 <20170112132930.GA24985@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, christophe.leroy@c-s.fr
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44166 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750730AbdALO2a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2017 09:28:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 14C8CED06B
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2017 15:28:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03227DA790
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2017 15:28:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9EF8CA7DB0
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2017 15:28:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170112132930.GA24985@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 12, 2017 at 02:29:30PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Jan 12, 2017 at 12:01:41AM +0100, Florian Westphal wrote:
> > > ct zone set meta mark   # as per my proposal -- set template
> > > ct eventmask set new	# as per my proposal -- lookup&change real conntrack
> > > ct helper set "foo"	# as per my proposal, lookup and change real
> > > conntrack if its unconfirmed, EXCEPT helper is not looked up based on skb
> > > payload and name "foo" but instead taken from objref infrastructure.
> > > Same for timeout.
> > 
> > Yes, something like the one above. By look&change, you refer to this?
> > 
> > ct = nf_ct_get(...);
> > if (!ct || !nf_ct_unconfirmed(ct))
> >         return;
> > 
> > /*
> >  * ... update ct with helper here.
> >  */
> 
> No, I meant more intrusive version:
> 
> ct = nf_ct_get(...);
> if (!ct || nf_ct_is_template(ct))))
> 	nf_conntrack_in(net, info->pf, hook, skb);

OK, then we have to defrag first. Let me give another twist to this
discussion, still brainstorming.

Did you consider to move this logic into a explicit 'track' statement.
Instead of this implicit lookup hidden in the helper/timeout
assignment, syntax would be something like:

        tcp dport 21 track with helper "ftp-standalone" timeout "tcp-short-timeout"

Note, that:

        track with helper "ftp-standalone" timeout "tcp-short-timeout"

performs this lookup&change as you need, but in one go, only for
unconfirmed conntrack. And this would be achieved with one single
kernel expression, in nft --debug=netlink representation:

 [ track helper "ftp-standalone" timeout "tcp-short-timeout" ]

For zone ID, we can use the same thing:

        track with zone 1       [ This can be combined with helper/timeouts too. ]

In this case, we pass the zone ID via nf_conntrack_in() [ or a new
function that is called from nf_conntrack_in() that takes the zone ID
and that doesn't depend on templates anymore, we can strip off
nf_conntrack_in() from the template logic ].

The new track kernel expression would need to perform similar tricks
as 'objref', as we also want map support there. So we can add
_SREG_ZONE, _SREG_TIMEOUT and _SREG_HELPER attribute to indicate the
set key that we use to perform the lookups to fetch the data/objects.

Syntax would be:

        track with helper map tcp dport { 21 : "ftp-standalone",
                                          2121 : "ftp-standaline" } \
                   timeout "tcp-short-timeout"

In nft --debug=netlink representation, this looks like:

  [ track helper sreg X timeout "tcp-short-timeout" ]

_SREG_TIMEOUT and _SREG_HELPER would require a NFT_SET_OBJECT set
type. _SREG_ZONE will be just fine with a NFT_SET_MAP that contains
simple data maps, not pointers.

With this proposal, I'm moving to the opposite side than in my
previous email 8): I think we could completely get rid of templates.

Look, and we could also allow a simple:

        track

alone itself with no options, that means, track this. This results in
creation of conntrack if it doesn't exists, otherwise lookup and
attach to skb->nfct. I know this is different front as this would be
only useful for bridge and ingress at this stage. For existing ip/ip6
families, this would nf_conntrack_in() into a no-op if skb->nfct is
set.

> ct = nf_ct_get(...);
> if (!ct)
> 	return;
> 
> switch (priv->key) {
> case NFT_CT_MARK:
> 	ct->mark = sreg32;
> 	break;
> case NFT_CT_HELPER:
> 	if (nf_ct_is_confirmed(ct))
> 		return; /* too late */
> 
> 	/* update helper here. sreg contains name of objectref,
> 	 * so we'd use that to obtain a helper template, then set/add
> 	 * helper extension to ct based on that.
> 	 * But we don't set skb->nfct to the template, we only use
> 	 * it as source to get the needed helper information.
> 	 */
> 	break;
> case NFT_CT_EVENTMASK:
> 	struct nf_conntrack_ecache *e = nf_ct_ecache_find(ct);
> 
> 	if (!e) {
> 		if (!nf_ct_is_confirmed(ct))
> 			nf_ct_ecache_ext_add(ct, sreg16, ~0, GFP_ATOMIC);
> 		return;
> 	}
> 
> 	e->ctmask = sreg16;
> 	break;
> case ...
> }
> 
> NFT_CT_ZONE would have its own eval() version that doesn't
> call nf_conntrack_in but instead sets up skb->nfct to a percpu template
> that will then be used to transport the zoneinfo until nf_conntrack_in
> is called (either by later hook or by later call via 'ct foo set bar').
> 
> [ unless skb->nfct is != NULL, then its a no-op ]

I see.

> > For timeouts, after a second look I think this is more complicated: we
> > set them from nf_conntrack_in() via l4proto->packet(). Thus, if we add
> > the conntrack extension to store timeouts later on, the first
> > conntrack state will not get refreshed with the right timeout.
> >
> > Assuming this is the first packet of a flow, that should be easy to
> > amend later. But if we pickup a flow from the middle, timeout
> > amendment gets a bit more tricky.  Calling l4proto->packet() is not
> > possible either since this sets packets as invalid, so we can drop it
> > from the ruleset.
> 
> Ok.  However I don't see why this isn't solveable in some way.
> 
> We could e.g. add a new l4proto callback, something like
> l4proto->update_timeouts(ct, timeouts);

Yes, timeout logic happens at the end of TCP tracker timeout which
seems to perform a few tricks there. And matching 'ct expiration' will
change semantics for unconfirmed ct, but that should be OK, I don't
know of anyone using it.

> > Back to helpers, users are familiar with the current way to attach
> > helpers, ie. from the raw chain.
> > 
> > Am I missing anything? I'm starting to think we can't escape the
> > conntrack template.
> 
> For Helpers?  Why not?  As long as ct isn't in the main table it should
> be fine afaics?  (Unless you mean "can't escape conntrack template to
> read to helper info that we need to assign to ct from".
>
> For zones, yes, I don't see a way to avoid a template for them.
> But thats the only ct key where I think that a template has to be used.

Yes, following the approach you propose zone would be the only one
that requires the template. So this needs to happen before the
conntrack hook.
