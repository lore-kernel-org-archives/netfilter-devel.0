From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: REJECT: separate reusable code
Date: Wed, 5 Feb 2014 12:01:46 +0000
Message-ID: <20140205120145.GB27444@macbook.localnet>
References: <20140205102547.GA20930@macbook.localnet>
 <20140205104247.GA4458@localhost>
 <20140205105348.GB21355@macbook.localnet>
 <20140205111713.GB4660@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56234 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaBEMBu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 07:01:50 -0500
Content-Disposition: inline
In-Reply-To: <20140205111713.GB4660@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 05, 2014 at 12:17:13PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Feb 05, 2014 at 10:53:48AM +0000, Patrick McHardy wrote:
> > On Wed, Feb 05, 2014 at 11:42:47AM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Feb 05, 2014 at 10:25:48AM +0000, Patrick McHardy wrote:
> > > > Just noticed commit cc70d069 (netfilter: REJECT: separate reusable code).
> > > > That doesn't look like a good idea to me at all.
> > > > 
> > > > First of all, it introduces static non-inline functions into a header file,
> > > > which is obviously wrong. But more importantly, it adds a symbol dependency
> > > > of the reject module on IPv6. We've tried hard to get rid of all these in
> > > > x_tables, lets please not re-add them in nftables.
> > > 
> > > Well, I think this is working at this moment, we can improve it of
> > > course.
> > 
> > Sure. I'd just prefer to have it done right from the beginning instead
> > of having to fix it up afterwards if we already know of these problems.
> > It just takes more time this way.
> > 
> > I wonder if we could add something that would break compilation for
> > anything in net/netfilter depending on the ipv6 module. It keeps
> > happening again and again.
> 
> We are using this trick thing in Kconfig:
> 
> depends on (IPV6 || IPV6=n)
> 
> and similar thing in NFT_REJECT
> 
> depends on NF_TABLES_IPV6 || !NF_TABLES_IPV6
> 
> it's not nice, but it seems to work to avoid buildbot reports.

That's not what I meant. I *want* to break compilation if anything in
net/netfilter depends on a symbol of the IPV6 module. Its wrong, with
the only exception being stuff for NFPROTO_INET.

> > > > I think we should instead use AF-specific modules for things like that.
> > > > We share basically no code except the boiler plate. I'd suggest to add
> > > > an AF-specific expression type lookup mechanism that takes precedence
> > > > over generic types.
> > > 
> > > Yes, this looks like the way to go to me.
> > > 
> > > How do you plan to handle this with the inet table? We don't have
> > > family context there.
> > 
> > Hmm good question indeed. We do have it at runtime, but this would
> > obviously also mean we'd also have to dispatch at runtime.
> > 
> > I guess an NFPROTO_INET specific reject module that dispatches to
> > the IPv4 and IPv6 versions is the only possibility unless we want
> > to add restrictions (which I don't).
> 
> I think that, once the infrastructure to provide expressions per
> family in place, a specific reject for inet is a good idea. It can
> reply depending on the packet family that it sees at _eval(...). I
> don't have any better idea on how to handle this case.

Yes, that seems fine, its in fact pretty much what we're doing right
now.
