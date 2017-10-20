From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/7] libnftables: Introduce nft_ctx_flush_cache()
Date: Fri, 20 Oct 2017 21:10:31 +0200
Message-ID: <20171020191031.GB1600@salvia>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-4-phil@nwl.cc>
 <20171020121326.GC4068@salvia>
 <20171020170513.GG32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, Eric Leblond <eric@regit.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46140 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752356AbdJTTKg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 15:10:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D5F00C5142
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 21:10:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C32DFDA863
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 21:10:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171020170513.GG32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 20, 2017 at 07:05:13PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Fri, Oct 20, 2017 at 02:13:26PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Oct 19, 2017 at 10:18:43AM +0200, Phil Sutter wrote:
> [...]
> > > +void nft_ctx_flush_cache(struct nft_ctx *ctx)
> > > +{
> > > +	iface_cache_release();
> > > +	cache_release(&ctx->cache);
> > > +}
> > 
> > This flush allows us to release the cache, but nft_ctx_alloc()
> > populates it. I'm missing something here, can we force a context
> > repopulation?
> 
> No, nft_ctx_alloc() does not populate the cache, but just initialize
> cache list head (which is not undone by cache_release()). Cache
> population happens during command execution depending on whether a cache
> is needed or not.

I see.

I think cache population should happen from nft_ctx_alloc(), caches
are context after all.

> > If there is no usecase for this yet, I would keep this behind by now.
> 
> The use-case for the above is cli_complete(), which
> explicitly drops the cache after execution of every command (probably
> because it's potentially long-lived and therefore things might change in
> background).

I see. If we follow the approach I'm describe above, then we need
something like nft_ctx_reset(), where we reset all context and we get
a fresh cache.

Makes sense to you?
