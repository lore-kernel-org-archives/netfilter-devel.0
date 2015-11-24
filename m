From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nftables 6/6] src: add trace support to nft monitor mode
Date: Tue, 24 Nov 2015 11:36:29 +0000
Message-ID: <20151124113629.GP2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-7-git-send-email-fw@strlen.de>
 <20151124102553.GE2310@macbook.localdomain>
 <20151124105333.GA3212@salvia>
 <20151124110429.GM2310@macbook.localdomain>
 <20151124111221.GA3528@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:45103 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752006AbbKXLgd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 06:36:33 -0500
Content-Disposition: inline
In-Reply-To: <20151124111221.GA3528@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Pablo Neira Ayuso wrote:
> On Tue, Nov 24, 2015 at 11:04:29AM +0000, Patrick McHardy wrote:
> > On 24.11, Pablo Neira Ayuso wrote:
> > Well I keep running into problems with it. We already discussed a few, we're
> > dumping way to much information that we don't need and we're making nft
> > require root even for unpriviledged operations and just testing ruleset
> > syntax.
> > 
> > We're basing errors on a cache that might not be up to date.
> > 
> > When I list the bridge table, for some reason it lists *all* tables of all
> > families. We're basically doing full dumps of everything in many cases.
> > This will be absolutely killing performance with a big ruleset.
> 
> OK, I'll be refining this to allow selective dumps.
> 
> > AFAIK (did not test) we're only listing sets for the family of the first
> > command, then set cache_initializer to true and skip further updates. When
> > the ruleset refers to multiple families, the contents will not be present
> > but expected.
> 
> This may be related to the kernel patches I have to send to use
> generations from the dump path.

As mentioned, I did not actually test this so far, but its the caching
code, it initializes for the first rule and only for that rule and bases
its queries on that handle. OTOH the dumping of all tables indicates that
it *does* dump more than that. Not sure, would have to test to be sure,
but the code looks like it.

> > It basically seems like the big hammer approach + some bugs instead of
> > selectively getting what we need when we need it and making sure its
> > up to date, at least before generating errors based on it.
> 
> Selective dumping is good to have indeed, I'm willing to refine this.
> 
> But regarding event tracing, I think it's good to keep a cache in
> userspace that we update based on the events that we receive, then
> resync if we hit ENOBUFS, instead of inquiring the kernel for every
> trace.

Generally I agree.

> So I think Florian can get this in. I'll be resolving the existing
> caching issues after him as this is not related to his work.
> 
> Fine with this approach?

Sure, it we fix this, no question :)
