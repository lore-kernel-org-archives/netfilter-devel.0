From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables conntrack set ops for zone, helper assignment, etc.
Date: Thu, 12 Jan 2017 15:53:10 +0100
Message-ID: <20170112145310.GB24985@breakpoint.cc>
References: <20170111091721.GA26703@breakpoint.cc>
 <20170111200749.GA16953@salvia>
 <20170111230141.GA10141@breakpoint.cc>
 <20170112130035.GA1816@salvia>
 <20170112132930.GA24985@breakpoint.cc>
 <20170112142818.GA3211@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        christophe.leroy@c-s.fr
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37016 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750733AbdALOxU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2017 09:53:20 -0500
Content-Disposition: inline
In-Reply-To: <20170112142818.GA3211@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > No, I meant more intrusive version:
> > 
> > ct = nf_ct_get(...);
> > if (!ct || nf_ct_is_template(ct))))
> > 	nf_conntrack_in(net, info->pf, hook, skb);
> 
> OK, then we have to defrag first. Let me give another twist to this
> discussion, still brainstorming.

No, nf_conntrack forces a dependency on the defrag module, so unless
someone inserts such rule before the defrag hook we're fine (raw
table prio is fine for instance).

> Did you consider to move this logic into a explicit 'track' statement.

Yes, but that doesn't help a lot imo since that forces a user
to structure ruleset so that they do

ct zone set meta mark track with helper "ftp-standalone"

which looks fine but what does the 'track' keyword provide?
Would a user care?  Or is that just more about exposing whats going on
behind the scenes?

> Instead of this implicit lookup hidden in the helper/timeout
> assignment, syntax would be something like:
> 
>         tcp dport 21 track with helper "ftp-standalone" timeout "tcp-short-timeout"
> 
> Note, that:
> 
>         track with helper "ftp-standalone" timeout "tcp-short-timeout"
> 
> performs this lookup&change as you need, but in one go, only for
> unconfirmed conntrack. And this would be achieved with one single
> kernel expression, in nft --debug=netlink representation:
> 
>  [ track helper "ftp-standalone" timeout "tcp-short-timeout" ]

I see, so we add a new expression instead of using ct set syntax.

> For zone ID, we can use the same thing:
> 
>         track with zone 1       [ This can be combined with helper/timeouts too. ]

Hmm....  So we really have comeptely new user syntax for all of
this.

The reason I scrapped this idea early on is that this breaks horribly
with icmp error messages and reply traffic (at very least, its
highly counter-intuitive/inconvenient).  Consider this fine looking
but non-working line:

tcp dport 21 track with helper "ftp-standalone" zone 1

instead, users would have to do this:

track with zone 1 # so icmp, reply traffic, ftp data traffic is in zone 1 too
tcp dport 21 track with helper "ftp-standalone"

and that won't work either since we would have to support 're-tracking'
already tracked conntrack...

I planned to force explicit 'track' for the bridge conntrack support,
but that works only because the nf_conntrack_in PREROUTING equivalent
added in bridge_conntrack would not ever create new conntracks (only
RELATED).

We can do this because there is no bridge conntrack so far so we don't
have backwards compat problems.

But then I thought 'why add special "track" if I can just let
ct foo set bla do it for me'?

> In this case, we pass the zone ID via nf_conntrack_in() [ or a new
> function that is called from nf_conntrack_in() that takes the zone ID
> and that doesn't depend on templates anymore, we can strip off
> nf_conntrack_in() from the template logic ].

I found no way to avoid templates for the zone because of the RELATED
packets.

> > > Back to helpers, users are familiar with the current way to attach
> > > helpers, ie. from the raw chain.
> > > 
> > > Am I missing anything? I'm starting to think we can't escape the
> > > conntrack template.
> > 
> > For Helpers?  Why not?  As long as ct isn't in the main table it should
> > be fine afaics?  (Unless you mean "can't escape conntrack template to
> > read to helper info that we need to assign to ct from".
> >
> > For zones, yes, I don't see a way to avoid a template for them.
> > But thats the only ct key where I think that a template has to be used.
> 
> Yes, following the approach you propose zone would be the only one
> that requires the template. So this needs to happen before the
> conntrack hook.

Yes, thats right.
