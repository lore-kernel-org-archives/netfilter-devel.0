From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 3/7] libnftables: Introduce nft_ctx_flush_cache()
Date: Fri, 20 Oct 2017 19:05:13 +0200
Message-ID: <20171020170513.GG32305@orbyte.nwl.cc>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-4-phil@nwl.cc>
 <20171020121326.GC4068@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53306 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751698AbdJTRFO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 13:05:14 -0400
Content-Disposition: inline
In-Reply-To: <20171020121326.GC4068@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, Oct 20, 2017 at 02:13:26PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 19, 2017 at 10:18:43AM +0200, Phil Sutter wrote:
[...]
> > +void nft_ctx_flush_cache(struct nft_ctx *ctx)
> > +{
> > +	iface_cache_release();
> > +	cache_release(&ctx->cache);
> > +}
> 
> This flush allows us to release the cache, but nft_ctx_alloc()
> populates it. I'm missing something here, can we force a context
> repopulation?

No, nft_ctx_alloc() does not populate the cache, but just initialize
cache list head (which is not undone by cache_release()). Cache
population happens during command execution depending on whether a cache
is needed or not.

> If there is no usecase for this yet, I would keep this behind by now.

The use-case for the above is cli_complete(), which
explicitly drops the cache after execution of every command (probably
because it's potentially long-lived and therefore things might change in
background).

Cheers, Phil
