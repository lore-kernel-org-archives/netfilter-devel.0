From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 00:22:11 +0100
Message-ID: <20150409232211.GC13473@acer.localdomain>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
 <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
 <20150409205135.GG20653@breakpoint.cc>
 <20150409223417.GA3205@salvia>
 <20150409223622.GI20653@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34615 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbbDIXWQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 19:22:16 -0400
Content-Disposition: inline
In-Reply-To: <20150409223622.GI20653@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.04, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Apr 09, 2015 at 10:51:35PM +0200, Florian Westphal wrote:
> > > Why would I want to re-write a working nft+compat ruleset to one
> > > that only uses native expressions?
> > 
> > The fact is that we cannot push users to use nf_tables, but we can
> > provide good reasons to adopt the native replacements and tools to
> > migrate easily.
> 
> I think dictionaries are a pretty good reason :-)
> 
> > > Whats the point of providing a 'native' replacement for an existing xtables
> > > target if we can just use the xtables version?
> > 
> > Have a look a hashlimit, multiport and all of our existing combo
> > match/targets.  They are a mess. We're now going towards a way more
> > flexible and generic (lego fashion) framework that will provide all
> > kind of combos without relying on this kind of Frankenstein
> > extensions.
> 
> Sure, but do you really want to add native expression equivalents for
> things like quota match, '-m time', '-j CLUSTERIP' ... ?
> 
> And wrt. the existing combos, are you positive that your xlate tool
> will always be able to translate everything to nft native expressions?
> 
> I'm specifically thinking about side-effects, e.g. -m recent which can
> also be manipulated externally to ruleset via /proc...
> 
> So i am afraid that 100% compat is not doable except by retaining all
> matches/targets (or at least some of them).

That's my biggest fear as well. I very much prefer to selectively add
what people are actually requesting or what obviously makes sense.

That way we at least know that something is needed and why.
