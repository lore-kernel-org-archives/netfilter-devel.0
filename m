From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 00:23:41 +0100
Message-ID: <20150409232341.GD13473@acer.localdomain>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
 <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
 <20150409205135.GG20653@breakpoint.cc>
 <20150409223417.GA3205@salvia>
 <20150409223622.GI20653@breakpoint.cc>
 <20150409225626.GA4215@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34628 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbbDIXXq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 19:23:46 -0400
Content-Disposition: inline
In-Reply-To: <20150409225626.GA4215@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.04, Pablo Neira Ayuso wrote:
> On Fri, Apr 10, 2015 at 12:36:22AM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > > > Whats the point of providing a 'native' replacement for an existing xtables
> > > > target if we can just use the xtables version?
> > > 
> > > Have a look a hashlimit, multiport and all of our existing combo
> > > match/targets.  They are a mess. We're now going towards a way more
> > > flexible and generic (lego fashion) framework that will provide all
> > > kind of combos without relying on this kind of Frankenstein
> > > extensions.
> > 
> > Sure, but do you really want to add native expression equivalents for
> > things like quota match, '-m time', '-j CLUSTERIP' ... ?
> 
> We don't want to rush to add a native expression that is going to map 1:1
> to these matches/targets. We need time to think and to discuss how to
> implement these in a nice (generic) fashion.
> 
> But if users need these features, they can migrate to nftables while
> keeping those in their ruleset through compat.

But if they don't tell us what they need, how are we supposed to know?
This removes it from decision making and our sight entirely.

> > And wrt. the existing combos, are you positive that your xlate tool
> > will always be able to translate everything to nft native expressions?
> >
> > I'm specifically thinking about side-effects, e.g. -m recent which can
> > also be manipulated externally to ruleset via /proc...
> > 
> > So i am afraid that 100% compat is not doable except by retaining all
> > matches/targets (or at least some of them).
> 
> We'll provide a translation which means that the returns the closest
> approximation to what they need.
> 
> That will not save them from reading the new documentation and
> familiarizing with the new framework and tools. But we'll relieve the
> pain of migration in some way.
> 
> As I said, the only way to get people moving forward is to provide
> good reasons to learn the new tool and start using it.

I think we already have pretty good reasons, and they soon will get a lot
stronger with concatenations and generic state keeping.
