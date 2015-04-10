From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 01:05:33 +0100
Message-ID: <20150410000533.GG13473@acer.localdomain>
References: <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
 <20150409205135.GG20653@breakpoint.cc>
 <20150409223417.GA3205@salvia>
 <20150409223622.GI20653@breakpoint.cc>
 <20150409225626.GA4215@salvia>
 <20150409232341.GD13473@acer.localdomain>
 <20150409234012.GA6169@salvia>
 <20150409234504.GE13473@acer.localdomain>
 <20150409235916.GA6449@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34869 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbbDJAFi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 20:05:38 -0400
Content-Disposition: inline
In-Reply-To: <20150409235916.GA6449@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.04, Pablo Neira Ayuso wrote:
> On Fri, Apr 10, 2015 at 12:45:05AM +0100, Patrick McHardy wrote:
> [...]:
> > I want this decision to be made based on what users actually need and
> > on what they need it for. Not basically pull in everything from iptables
> > in one go without even thinking about it.
> > 
> > As a middle ground, I think I could agree to adding the xt compat
> > framework, but only allow selective extensions to be used where we
> > are sure we need them.
> 
> The framework fully supports this, imposing an artificial limitation
> makes no sense to me at all.

I'm aware that its technically possible, the question is a different one.
 
> And more importantly, without this patch nft breaks when users
> load their ruleset throught iptables-compat-restore.

How will it break if we don't support it so far?

> With that artificial limitation, some rulesets will break, some other
> not.
> 
> Admit it, there is no way we can control what users will do in the
> future. The only way out is to move forward in an evolutionary
> fashion.

Right. But this is not evolutionary. It pulls everything we have in
iptables in nftables in one big dump. Its the opposite of evolution.
An evolutionary process would be to grow things as they are needed,
which is what I'm suggesting.

Don't you see the difference? If people are using the translation
layer, they will by definition translate their old ruleset again on
every load. Once they have the xt stuff in their nftables ruleset,
we don't have any control over it anymore. Unless you want to pull
the nft translation layer into nft, which would be ridiculous.

We can't decide anymore how we want to map an old extension to
the new framework. We loose all control and are stuck with the
worst case, which is that people might be using all the old crap
in compat mode.
