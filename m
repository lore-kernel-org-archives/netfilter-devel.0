From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix oops when using gotos
Date: Fri, 7 Feb 2014 17:26:58 +0100
Message-ID: <20140207162658.GA5258@localhost>
References: <1391789931-3917-1-git-send-email-pablo@netfilter.org>
 <20140207162330.GA4917@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58757 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaBGQ1L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:27:11 -0500
Content-Disposition: inline
In-Reply-To: <20140207162330.GA4917@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 07, 2014 at 05:23:30PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Feb 07, 2014 at 05:18:51PM +0100, Pablo Neira Ayuso wrote:
> > Fix an oops if you use the "goto" operation, you will end up in
> > non-base chain with no counters and no default policy. While at
> > it, uninlined nft_chain_stats() since it doesn't make sense to
> > optimize a debugging facility that is rarely used.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > I noticed this when testing the compat layer.
> > 
> > @Patrick: When working on this I noticed I accidentally has skipped
> > this patch: http://www.spinics.net/lists/netfilter-devel/msg29828.html
> > I have included this change in this fix. Sorry for that.
> 
> Oops, unlined the wrong function...

I'm going to push this leftover fix to nf:

http://patchwork.ozlabs.org/patch/308930/

Will resend a v2 to fix the goto issue.
