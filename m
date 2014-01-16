From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 1/3] parser: fix parsing of ethernet protocol types
Date: Thu, 16 Jan 2014 16:51:59 +0000
Message-ID: <20140116165159.GA4669@macbook.localnet>
References: <1389817823-7251-1-git-send-email-pablo@netfilter.org>
 <20140116162816.GA4111@macbook.localnet>
 <20140116164937.GA5179@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57555 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaAPQwE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:52:04 -0500
Content-Disposition: inline
In-Reply-To: <20140116164937.GA5179@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 16, 2014 at 05:49:37PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 16, 2014 at 04:28:16PM +0000, Patrick McHardy wrote:
> > On Wed, Jan 15, 2014 at 09:30:21PM +0100, Pablo Neira Ayuso wrote:
> > > This allows us to use the protocol type keyword, eg.
> > > 
> > > nft add rule ip filter output meta protocol ip6 counte
> > >                                             ^^^
> > 
> > I see two problems with this patch:
> > 
> > - the mapping to ETH_P_* is fixed. In case of f.i. meta nfproto relational
> >   expression it would have to map to NFPROTO_* values. So I think we should
> >   use symbolic expressions instead of constants and leave parsing to the
> >   evaluation phase-
> 
> Yes, that change needs to be done in next-3.14 to get it working with
> your new inet table. I was focusing to fix this in master for the
> upcoming release.
> 
> > - we're still using a mix of ip6 and ipv6. Lets also fix that, ideally
> >   as a patch before this one.
> > 
> > I can take care of this if you like.
> 
> Please, go ahead, I'm looking at more pending stuff I want to provide
> feedback on.

Already done :) I'm simply going to take your entire patchset and integrate
it with my change since they kind of depend on each other.
