From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_tables: fix oops when using gotos
Date: Fri, 7 Feb 2014 16:30:41 +0000
Message-ID: <20140207163041.GA24391@macbook.localnet>
References: <1391789931-3917-1-git-send-email-pablo@netfilter.org>
 <20140207162330.GA4917@localhost>
 <20140207162658.GA5258@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45689 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaBGQar (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:30:47 -0500
Content-Disposition: inline
In-Reply-To: <20140207162658.GA5258@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 07, 2014 at 05:26:58PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Feb 07, 2014 at 05:23:30PM +0100, Pablo Neira Ayuso wrote:
> > On Fri, Feb 07, 2014 at 05:18:51PM +0100, Pablo Neira Ayuso wrote:
> > > Fix an oops if you use the "goto" operation, you will end up in
> > > non-base chain with no counters and no default policy. While at
> > > it, uninlined nft_chain_stats() since it doesn't make sense to
> > > optimize a debugging facility that is rarely used.
> > > 
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > > I noticed this when testing the compat layer.
> > > 
> > > @Patrick: When working on this I noticed I accidentally has skipped
> > > this patch: http://www.spinics.net/lists/netfilter-devel/msg29828.html
> > > I have included this change in this fix. Sorry for that.
> > 
> > Oops, unlined the wrong function...
> 
> I'm going to push this leftover fix to nf:
> 
> http://patchwork.ozlabs.org/patch/308930/
> 
> Will resend a v2 to fix the goto issue.

Thanks! I was also considering moving this to jump labels and enable
the label on nft meta set trace. Not sure if its worth it though,
will do some benchmarking at some point ...
