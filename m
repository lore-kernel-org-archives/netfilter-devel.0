From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nftables 6/6] src: add trace support to nft monitor mode
Date: Tue, 24 Nov 2015 11:07:41 +0000
Message-ID: <20151124110741.GN2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-7-git-send-email-fw@strlen.de>
 <20151124102553.GE2310@macbook.localdomain>
 <20151124104834.GF1740@breakpoint.cc>
 <20151124105816.GL2310@macbook.localdomain>
 <20151124110145.GA3421@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:44880 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753786AbbKXLHp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 06:07:45 -0500
Content-Disposition: inline
In-Reply-To: <20151124110145.GA3421@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Pablo Neira Ayuso wrote:
> On Tue, Nov 24, 2015 at 10:58:16AM +0000, Patrick McHardy wrote:
> > On 24.11, Florian Westphal wrote:
> > > > An alternative would be to use our internal datatypes, IOW parse the
> > > > attributes, associate the values with an internal type and use the regular
> > > > printing functions. The benefit would be fully consistent output, also
> > > > with respect to output options like numerical output.
> > > 
> > > Yes, right now virtually all of the printing is in libnftnl
> > > (called from nftables via nftnl_trace_fprintf() ).
> > 
> > The downside is that we're stuck to fprintf. I'm working on moving nft to
> > printing to buffers for pretty printing, intending set contents, sorting
> > flow tables in different dimensions etc. If we have external printing we'll
> > be missing some flexibilty in handling it, also regarding logging to other
> > outputs than stdout.
> 
> What we did do far is to have the fprintf variant for quick printing,
> but this should be based on the printing to buffers. Both approaches
> would be exported.
> 
> Does this sound good to you?

I'm completely fine with the fprintf printing *for libnfntnl*, but I'm
questing whether nft should make use of it for its own output asides from
debugging netlink operations. I also wouldn't consider the libnftnl output
stable in any form, the fprintf variant it basically something for debugging,
at least I've always seen it that way.

So yeah, I'm not opposed to having it, just to using it for this particular
purpose.
