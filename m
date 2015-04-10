From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 01:33:26 +0100
Message-ID: <20150410003325.GI13473@acer.localdomain>
References: <20150409205135.GG20653@breakpoint.cc>
 <20150409223417.GA3205@salvia>
 <20150409223622.GI20653@breakpoint.cc>
 <20150409225626.GA4215@salvia>
 <20150409232341.GD13473@acer.localdomain>
 <20150409234012.GA6169@salvia>
 <20150409234504.GE13473@acer.localdomain>
 <20150409235916.GA6449@salvia>
 <20150410000533.GG13473@acer.localdomain>
 <20150410002649.GA6929@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35047 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbbDJAdb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 20:33:31 -0400
Content-Disposition: inline
In-Reply-To: <20150410002649.GA6929@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.04, Pablo Neira Ayuso wrote:
> On Fri, Apr 10, 2015 at 01:05:33AM +0100, Patrick McHardy wrote:
> > On 10.04, Pablo Neira Ayuso wrote:
> > > On Fri, Apr 10, 2015 at 12:45:05AM +0100, Patrick McHardy wrote:
> > > [...]:
> > > > I want this decision to be made based on what users actually need and
> > > > on what they need it for. Not basically pull in everything from iptables
> > > > in one go without even thinking about it.
> > > > 
> > > > As a middle ground, I think I could agree to adding the xt compat
> > > > framework, but only allow selective extensions to be used where we
> > > > are sure we need them.
> > > 
> > > The framework fully supports this, imposing an artificial limitation
> > > makes no sense to me at all.
> > 
> > I'm aware that its technically possible, the question is a different one.
> 
> Then, if it's technically possible with the existing kernel framework
> (and exposed to userspace), there is basically no way that we can
> limit what userspace can do with this.

I'm repeating myself. We'll have iptables in the nft ruleset. We can't
get rid of it because we don't understand it and we don't want to understand
it.

This is the major difference to translating on every load. Once its
in the nft ruleset, it stays there. We loose control. We can't transform
it anymore. Its an opaque blob.

> > > Admit it, there is no way we can control what users will do in the
> > > future. The only way out is to move forward in an evolutionary
> > > fashion.
> > 
> > Right. But this is not evolutionary. It pulls everything we have in
> > iptables in nftables in one big dump. Its the opposite of evolution.
> > An evolutionary process would be to grow things as they are needed,
> > which is what I'm suggesting.
> 
> No. Evolution is to extend things from what you already have, and let
> just things extinct by providing better alternatives.

So we're evolving nft into supporting iptables in order to extinct it?
That makes absolutely no sense.

I agree that we need to provide a way to move people over smoothly.
But I'm absolutely against doing this without even considering the
consequences and arguing about it on this level.

It starts with a problem statement *why* we would want to do this.
And this is to provide access to features we do not support so far.
This implies its about features we actually do want to support at all,
and excludes features we do already support. This means selectively
enabling the remaining ones is what makes sense, and even that is
a hard call for the reasons stated above.
