From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Tue, 24 Nov 2015 10:47:30 +0000
Message-ID: <20151124104729.GJ2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151124102245.GD2683@salvia>
 <20151124102841.GD1740@breakpoint.cc>
 <20151124103348.GG2310@macbook.localdomain>
 <20151124104404.GA3149@salvia>
 <20151124104523.GA3188@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:44738 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752563AbbKXKrd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:47:33 -0500
Content-Disposition: inline
In-Reply-To: <20151124104523.GA3188@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Pablo Neira Ayuso wrote:
> On Tue, Nov 24, 2015 at 11:44:04AM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Nov 24, 2015 at 10:33:49AM +0000, Patrick McHardy wrote:
> > > BTW and completely unrelated to the netlink group: I think it would be
> > > nicer to have a "trace" keyword instead of "nftrace set 1" in the nft
> > > frontend.
> > 
> > I like the idea of having this "trace" statement.
> 
> Or you mean only "trace" keyword from the parser, not a statement,
> right?

Probably, we can internally translate it to "meta set trace = 1" in the
parser and translate it back during output.
