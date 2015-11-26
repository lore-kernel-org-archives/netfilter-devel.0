From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new
 conntrack entries
Date: Thu, 26 Nov 2015 16:53:46 +0000
Message-ID: <20151126165346.GW16828@macbook.localdomain>
References: <20151126143328.GC32716@breakpoint.cc>
 <20151126144916.GJ16828@macbook.localdomain>
 <20151126150726.GD32716@breakpoint.cc>
 <20151126151229.GA3412@salvia>
 <20151126152410.GN16828@macbook.localdomain>
 <20151126155426.GA4108@salvia>
 <20151126160227.GQ16828@macbook.localdomain>
 <20151126161529.GA4350@salvia>
 <20151126162528.GS16828@macbook.localdomain>
 <20151126164316.GA4495@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Michal Kubecek <mkubecek@suse.cz>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:37251 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751474AbbKZQxw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 11:53:52 -0500
Content-Disposition: inline
In-Reply-To: <20151126164316.GA4495@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Pablo Neira Ayuso wrote:
> On Thu, Nov 26, 2015 at 04:25:28PM +0000, Patrick McHardy wrote:
> > > This doesn't sound so complicated to me:
> > > 
> > >         add rule filter prerouting \
> > >                 ip protocol { tcp, udp, sctp } track
> > > 
> > > You just specify what you need for stateful tracking.
> > 
> > Sure, or "filter prerouting track" for everything. Let's stay at that
> > example because it will be a common case and we don't know anything about
> > protocols.
> >
> > > The case above you indicate is enabling conntrack for all packets, the
> > > -j CT --track is what should govern this IMO.
> > 
> > How does it prevent exactly that case we're talking about - someone is
> > saying "CT --track" without further qualification and means "track
> > everything".
> 
> That indeed means to me track everything based on what conntrack knows
> how to track.

Right. And the problem is that we do this right now but it might not be
what the user expects since he's explicitly filtering on connection
identities and expects stateful filtering to be based on those as well.
This is exactly what was regarded as the rational for the security fix, so
it doesn't make sense to now state this is all Ok.

> > And the SCTP connection tracking module is not available or not
> > loaded.
> 
> If the module is not available, then this is a custom kernel
> compilation. IMO we should focus on providing good defaults to typical
> kernel that are included by most distributors.

Sure, but that's exactly what we're talking about. I think the number of
distributors enabling SCTP/whatever tracking statically is basically
non existant.

Every kernel is a custom kernel. We shouldn't expect users to dive into
.config to figure out how to build their ruleset.

> If the SCTP tracker becomes part of nf_conntrack by default, then we
> don't have to worry about the "SCTP module not loaded" case.

I agree, but you stated "IMO we should skip enabling things by default"
and referred to the downside of then having it available in network namespaces.
Maybe I misunderstood you, but I took that as you don't want to put it
into nf_conntrack and you don't want it to be autoloaded.

I'm really not sure what you are arguing or proposing. Explicit tracking
and the CT target suggest you *don't* want it in nf_conntrack, now you state
the opposite.

Either way fixes the problem, although I do somewhat agree with Florian that
its better to not enable it if it definitely is not needed, but I guess its
acceptable.
