From: Phil Sutter <phil@nwl.cc>
Subject: Re: RFC: Ideas about possible solutions for nfbz#949
Date: Tue, 30 May 2017 13:04:24 +0200
Message-ID: <20170530110424.xilg6ph3aqstopyl@base.sg13b.nwl.cc>
References: <20170510153429.GZ20805@orbyte.nwl.cc>
 <20170529175218.GA19201@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:40103 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751270AbdE3K7j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 May 2017 06:59:39 -0400
Content-Disposition: inline
In-Reply-To: <20170529175218.GA19201@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Mon, May 29, 2017 at 07:52:18PM +0200, Pablo Neira Ayuso wrote:
> I'm recovering this RFC that got lost in the pile.

Thanks for not dropping it! :)

> On Wed, May 10, 2017 at 05:34:29PM +0200, Phil Sutter wrote:
> > Hi,
> > 
> > Netfilter Bugzilla #949[1] complains about broken output when trying to
> > match icmpv6 message fields. This is a problem in how payload match is
> > implemented in nft: The given match (e.g. 'icmp6 id 2') is broken down
> > to a simple match of header data at a specific offset. Sadly this does
> > not work with ICMP(v6) since header structure depends on the packet's
> > ICMP type and on return path there is no information about which type of
> > message the user wanted to match against.
> 
> Right, this is a longstanding bug.
> 
> > My idea was to build something like the protocol dependencies we have
> > for e.g. TCP header fields but with ICMP, a given header field might be
> > present in multiple message types (e.g. icmp6_id is present in echo
> > request as well as reply).
> 
> You mean adding more instructions when generating bytecode? This has
> runtime overhead, just to provide context for just listing the
> ruleset. I would prefer we skip this.

Yes, that is questionable. But it is a matter of definition in my PoV. A
user saying 'icmp6 id 2' might not be aware that all possible icmp6
packets might match, not only those making use of the ID field. Right
now it feels like we want a low-level 'icmp6 offset X mask y' and a
high-level 'icmp6 echo direction any id 2' but that's probably out of
scope here.

> > I already considered inserting a match for icmp6 type against an
> > anonymous set (like 'icmp6 type { echo-request, echo-reply }'), but
> > having this as an implicit dependency and resolving with previous
> > matches, etc. becomes pretty complex.
> > 
> > Do you think I should try following a different approach (via userdata
> > e.g.)?
> 
> I think you should try adding some context structure to the
> expr_print(), this context can be used to interpret this offset based
> on the icmp type.
> 
> Someone (Elise?) send me a patch to add this context structure, just
> to prepare introduction, but she got stuck in the context update
> logic at some point. I can find such patch so you only have to figure
> out how to annotate the information we need in this context structure.

Yes, that would be great. Having something to get me started is always
very helpful. :)

Thanks, Phil
