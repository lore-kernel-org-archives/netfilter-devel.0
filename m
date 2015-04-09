From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 00:21:06 +0100
Message-ID: <20150409232106.GB13473@acer.localdomain>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
 <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
 <20150409205135.GG20653@breakpoint.cc>
 <20150409223417.GA3205@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34605 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbbDIXVL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 19:21:11 -0400
Content-Disposition: inline
In-Reply-To: <20150409223417.GA3205@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.04, Pablo Neira Ayuso wrote:
> On Thu, Apr 09, 2015 at 10:51:35PM +0200, Florian Westphal wrote:
> > Why would I want to re-write a working nft+compat ruleset to one
> > that only uses native expressions?
> 
> The fact is that we cannot push users to use nf_tables, but we can
> provide good reasons to adopt the native replacements and tools to
> migrate easily.

We actually can by translating their iptables ruleset transparently.

> > Whats the point of providing a 'native' replacement for an existing xtables
> > target if we can just use the xtables version?
> 
> Have a look a hashlimit, multiport and all of our existing combo
> match/targets.  They are a mess. We're now going towards a way more
> flexible and generic (lego fashion) framework that will provide all
> kind of combos without relying on this kind of Frankenstein
> extensions.

The thing is, my adding missing features we can make a case by case
decision of whether it makes sense and how to implement it properly.

The "whether it makes sense" decision is taken away from us by providing
the xt compat thing. It might very well not make sense to have a 1:1
mapping in nft but to express things differently.
