From: Phil Sutter <phil@nwl.cc>
Subject: Re: RFC: Ideas about possible solutions for nfbz#949
Date: Fri, 23 Jun 2017 16:03:24 +0200
Message-ID: <20170623140324.GD5669@orbyte.nwl.cc>
References: <20170510153429.GZ20805@orbyte.nwl.cc>
 <20170529175218.GA19201@salvia>
 <20170530110424.xilg6ph3aqstopyl@base.sg13b.nwl.cc>
 <20170530120836.GA3010@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:37681 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752878AbdFWODb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Jun 2017 10:03:31 -0400
Content-Disposition: inline
In-Reply-To: <20170530120836.GA3010@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 30, 2017 at 02:08:36PM +0200, Pablo Neira Ayuso wrote:
> On Tue, May 30, 2017 at 01:04:24PM +0200, Phil Sutter wrote:
> [...]
> > On Mon, May 29, 2017 at 07:52:18PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > > > My idea was to build something like the protocol dependencies we have
> > > > for e.g. TCP header fields but with ICMP, a given header field might be
> > > > present in multiple message types (e.g. icmp6_id is present in echo
> > > > request as well as reply).
> > > 
> > > You mean adding more instructions when generating bytecode? This has
> > > runtime overhead, just to provide context for just listing the
> > > ruleset. I would prefer we skip this.
> > 
> > Yes, that is questionable. But it is a matter of definition in my PoV. A
> > user saying 'icmp6 id 2' might not be aware that all possible icmp6
> > packets might match, not only those making use of the ID field. Right
> > now it feels like we want a low-level 'icmp6 offset X mask y' and a
> > high-level 'icmp6 echo direction any id 2' but that's probably out of
> > scope here.
> 
> If the user just specifies 'icmp6 id 2', we should reject this and ask
> for a specific icmp type.

If nft is supposed to check the semantics, that's not as easy since in
worst case, user specified 'icmp6 type { echo-request, echo-reply }'
(for a valid example) or 'icmp6 type { echo-request, nd-redirect }' (for
an invalid one). Just making sure icmp6 type has been specified should
be possible though (but may not be helpful later in output path).

> > > > I already considered inserting a match for icmp6 type against an
> > > > anonymous set (like 'icmp6 type { echo-request, echo-reply }'), but
> > > > having this as an implicit dependency and resolving with previous
> > > > matches, etc. becomes pretty complex.
> > > > 
> > > > Do you think I should try following a different approach (via userdata
> > > > e.g.)?
> > > 
> > > I think you should try adding some context structure to the
> > > expr_print(), this context can be used to interpret this offset based
> > > on the icmp type.
> > > 
> > > Someone (Elise?) send me a patch to add this context structure, just
> > > to prepare introduction, but she got stuck in the context update
> > > logic at some point. I can find such patch so you only have to figure
> > > out how to annotate the information we need in this context structure.
> > 
> > Yes, that would be great. Having something to get me started is always
> > very helpful. :)
> 
> I'm attaching what Elise sent me for review.
> 
> This is just an initial patch to add some context structure for
> expr_print(), so it's pretty much the simple initial step.
> 
> Not telling here you have to use 'struct proto_ctx' specifically, I
> guess we need some print_ctx structure for this to annotate that we
> have seen "icmp type" already, so offset interpretation is based on
> 
> I would need to spend more time here to provide a more specific design
> for this, so if you can come back with initial ideas, that would be
> good.

Yes, looking at previous matches might help but I'm getting stuck when
it comes to corner cases like in my examples above: 'icmp6 id' is valid
for more than a single icmp6 type, and there is nothing preventing a
user from giving a set of icmp6 types to match against. So this won't
lead to a "what type is this field match for" kind of test but rather
a "are all given types valid for that human readable representation of
the field match".

Thanks, Phil
