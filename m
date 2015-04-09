From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 00:45:05 +0100
Message-ID: <20150409234504.GE13473@acer.localdomain>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
 <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
 <20150409205135.GG20653@breakpoint.cc>
 <20150409223417.GA3205@salvia>
 <20150409223622.GI20653@breakpoint.cc>
 <20150409225626.GA4215@salvia>
 <20150409232341.GD13473@acer.localdomain>
 <20150409234012.GA6169@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34747 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbbDIXpK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 19:45:10 -0400
Content-Disposition: inline
In-Reply-To: <20150409234012.GA6169@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.04, Pablo Neira Ayuso wrote:
> On Fri, Apr 10, 2015 at 12:23:41AM +0100, Patrick McHardy wrote:
> > On 10.04, Pablo Neira Ayuso wrote:
> > > On Fri, Apr 10, 2015 at 12:36:22AM +0200, Florian Westphal wrote:
> > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >
> > > > > > Whats the point of providing a 'native' replacement for an existing xtables
> > > > > > target if we can just use the xtables version?
> > > > > 
> > > > > Have a look a hashlimit, multiport and all of our existing combo
> > > > > match/targets.  They are a mess. We're now going towards a way more
> > > > > flexible and generic (lego fashion) framework that will provide all
> > > > > kind of combos without relying on this kind of Frankenstein
> > > > > extensions.
> > > > 
> > > > Sure, but do you really want to add native expression equivalents for
> > > > things like quota match, '-m time', '-j CLUSTERIP' ... ?
> > > 
> > > We don't want to rush to add a native expression that is going to map 1:1
> > > to these matches/targets. We need time to think and to discuss how to
> > > implement these in a nice (generic) fashion.
> > > 
> > > But if users need these features, they can migrate to nftables while
> > > keeping those in their ruleset through compat.
> > 
> > But if they don't tell us what they need, how are we supposed to know?
> > This removes it from decision making and our sight entirely.
> 
> We know we have to provide native replacements for what we have
> already.

Not necessarily. iptables has accumulated tons of cruft that probably
nobody in the world uses, CLUSTERIP being the prime example. The fact
is that we don't know and we will never know if we simply add support
for everything we had.

I want this decision to be made based on what users actually need and
on what they need it for. Not basically pull in everything from iptables
in one go without even thinking about it.

As a middle ground, I think I could agree to adding the xt compat
framework, but only allow selective extensions to be used where we
are sure we need them.
