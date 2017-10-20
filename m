From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 3/7] libnftables: Introduce nft_ctx_flush_cache()
Date: Fri, 20 Oct 2017 23:00:03 +0200
Message-ID: <20171020210003.GJ32305@orbyte.nwl.cc>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-4-phil@nwl.cc>
 <20171020121326.GC4068@salvia>
 <20171020170513.GG32305@orbyte.nwl.cc>
 <20171020191031.GB1600@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53784 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751690AbdJTVAH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 17:00:07 -0400
Content-Disposition: inline
In-Reply-To: <20171020191031.GB1600@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 20, 2017 at 09:10:31PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 20, 2017 at 07:05:13PM +0200, Phil Sutter wrote:
> > Hi,
> > 
> > On Fri, Oct 20, 2017 at 02:13:26PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Oct 19, 2017 at 10:18:43AM +0200, Phil Sutter wrote:
> > [...]
> > > > +void nft_ctx_flush_cache(struct nft_ctx *ctx)
> > > > +{
> > > > +	iface_cache_release();
> > > > +	cache_release(&ctx->cache);
> > > > +}
> > > 
> > > This flush allows us to release the cache, but nft_ctx_alloc()
> > > populates it. I'm missing something here, can we force a context
> > > repopulation?
> > 
> > No, nft_ctx_alloc() does not populate the cache, but just initialize
> > cache list head (which is not undone by cache_release()). Cache
> > population happens during command execution depending on whether a cache
> > is needed or not.
> 
> I see.
> 
> I think cache population should happen from nft_ctx_alloc(), caches
> are context after all.
> 
> > > If there is no usecase for this yet, I would keep this behind by now.
> > 
> > The use-case for the above is cli_complete(), which
> > explicitly drops the cache after execution of every command (probably
> > because it's potentially long-lived and therefore things might change in
> > background).
> 
> I see. If we follow the approach I'm describe above, then we need
> something like nft_ctx_reset(), where we reset all context and we get
> a fresh cache.

I think it's worth keeping the current logic of when to populate the
cache. Remember when I added a call to cache_update() for echo output
support which caused an unnecessary slowdown you later complained about?
Populating the cache unconditionally upon context creation would cause
the same issue again if we follow my plan of making 'nft' binary the
first user of libnftables.

Right now, we only explicitly clear the cache in CLI, and my patch
allows applications to do that if they think it's necessary. Cache
population is completely pointless if an application just wants to e.g.
add a new table to the rule set, so I'd prefer to leave it this way. We
spoke about possible performance implications of cache updates at NFWS
already, keeping the existing (and well defined) logic will at least
limit the impact of this potential bottleneck.

Cheers, Phil
