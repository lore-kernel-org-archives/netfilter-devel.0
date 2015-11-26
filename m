From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new
 conntrack entries
Date: Thu, 26 Nov 2015 16:25:28 +0000
Message-ID: <20151126162528.GS16828@macbook.localdomain>
References: <20151126095133.GA1612@salvia>
 <20151126141552.GH16828@macbook.localdomain>
 <20151126143328.GC32716@breakpoint.cc>
 <20151126144916.GJ16828@macbook.localdomain>
 <20151126150726.GD32716@breakpoint.cc>
 <20151126151229.GA3412@salvia>
 <20151126152410.GN16828@macbook.localdomain>
 <20151126155426.GA4108@salvia>
 <20151126160227.GQ16828@macbook.localdomain>
 <20151126161529.GA4350@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Michal Kubecek <mkubecek@suse.cz>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:37042 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751165AbbKZQZe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 11:25:34 -0500
Content-Disposition: inline
In-Reply-To: <20151126161529.GA4350@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Pablo Neira Ayuso wrote:
> On Thu, Nov 26, 2015 at 04:02:27PM +0000, Patrick McHardy wrote:
> > On 26.11, Pablo Neira Ayuso wrote:
> > > On Thu, Nov 26, 2015 at 03:24:11PM +0000, Patrick McHardy wrote:
> > > > Consider:
> > > > 
> > > > -i eth0 -j CT --track
> > > > -i eth0 -p sctp --dport 1234 -j ACCEPT
> > > > -i eth0 -m state --state ESTABLISHED -j ACCEPT
> [...]
> > > IMO we should skip enabling things by default. When we enable things
> > > by default someone else follow up later on with some scenario we
> > > didn't consider and then we've got problems. I think we should go in
> > > the direction of explicit configurations, we already do this for
> > > conntrack helpers.
> > 
> > Well as I already said, it doesn't solve anything regarding this problem,
> > so how is it relevant?
> 
> This doesn't sound so complicated to me:
> 
>         add rule filter prerouting \
>                 ip protocol { tcp, udp, sctp } track
> 
> You just specify what you need for stateful tracking.

Sure, or "filter prerouting track" for everything. Let's stay at that
example because it will be a common case and we don't know anything about
protocols.

> The case above you indicate is enabling conntrack for all packets, the
> -j CT --track is what should govern this IMO.

How does it prevent exactly that case we're talking about - someone is
saying "CT --track" without further qualification and means "track
everything". And the SCTP connection tracking module is not available or
not loaded. The user uses exactly the rules which lead up to this fix.
How does this change *anything*? AFAICS its exactly the situation we have
now.
