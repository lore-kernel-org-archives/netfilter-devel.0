From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nftables 6/6] src: add trace support to nft monitor mode
Date: Tue, 24 Nov 2015 11:04:29 +0000
Message-ID: <20151124110429.GM2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-7-git-send-email-fw@strlen.de>
 <20151124102553.GE2310@macbook.localdomain>
 <20151124105333.GA3212@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:44857 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754187AbbKXLEd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 06:04:33 -0500
Content-Disposition: inline
In-Reply-To: <20151124105333.GA3212@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Pablo Neira Ayuso wrote:
> On Tue, Nov 24, 2015 at 10:25:54AM +0000, Patrick McHardy wrote:
> > Tracing might be a long running operation. The cache can go out of sync, might
> > be better to do a lookup on demand.
> 
> We'll need to handle generations in that approach. The kernel lookup
> per trace will be expensive.
> 
> Why not just keep the cache in userspace and update it only when
> needed? We can easily detect when we get out of sync via ENOBUFS.
> 
> > Right now the caching infrastrucure has quite a lot of problems and I'd prefer
> > to get them fixed before we base new things on it.
> 
> The caching infrastructure only needs to have a mode to be populated
> via set information, then infer existing tables from handles as you
> indicated.
> 
> What other problems you see with it?

Well I keep running into problems with it. We already discussed a few, we're
dumping way to much information that we don't need and we're making nft
require root even for unpriviledged operations and just testing ruleset
syntax.

We're basing errors on a cache that might not be up to date.

When I list the bridge table, for some reason it lists *all* tables of all
families. We're basically doing full dumps of everything in many cases.
This will be absolutely killing performance with a big ruleset.

AFAIK (did not test) we're only listing sets for the family of the first
command, then set cache_initializer to true and skip further updates. When
the ruleset refers to multiple families, the contents will not be present
but expected.

It basically seems like the big hammer approach + some bugs instead of
selectively getting what we need when we need it and making sure its
up to date, at least before generating errors based on it.
