From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 00:36:22 +0200
Message-ID: <20150409223622.GI20653@breakpoint.cc>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
 <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
 <20150409205135.GG20653@breakpoint.cc>
 <20150409223417.GA3205@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56760 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753533AbbDIWgY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 18:36:24 -0400
Content-Disposition: inline
In-Reply-To: <20150409223417.GA3205@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Apr 09, 2015 at 10:51:35PM +0200, Florian Westphal wrote:
> > Why would I want to re-write a working nft+compat ruleset to one
> > that only uses native expressions?
> 
> The fact is that we cannot push users to use nf_tables, but we can
> provide good reasons to adopt the native replacements and tools to
> migrate easily.

I think dictionaries are a pretty good reason :-)

> > Whats the point of providing a 'native' replacement for an existing xtables
> > target if we can just use the xtables version?
> 
> Have a look a hashlimit, multiport and all of our existing combo
> match/targets.  They are a mess. We're now going towards a way more
> flexible and generic (lego fashion) framework that will provide all
> kind of combos without relying on this kind of Frankenstein
> extensions.

Sure, but do you really want to add native expression equivalents for
things like quota match, '-m time', '-j CLUSTERIP' ... ?

And wrt. the existing combos, are you positive that your xlate tool
will always be able to translate everything to nft native expressions?

I'm specifically thinking about side-effects, e.g. -m recent which can
also be manipulated externally to ruleset via /proc...

So i am afraid that 100% compat is not doable except by retaining all
matches/targets (or at least some of them).
