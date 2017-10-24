From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v2 2/4] libnftables: Introduce nft_ctx_flush_cache()
Date: Tue, 24 Oct 2017 19:40:21 +0200
Message-ID: <20171024174021.GR32305@orbyte.nwl.cc>
References: <20171023153319.13415-1-phil@nwl.cc>
 <20171023153319.13415-3-phil@nwl.cc>
 <20171024155258.GB11705@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35734 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751399AbdJXRkY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 13:40:24 -0400
Content-Disposition: inline
In-Reply-To: <20171024155258.GB11705@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, Oct 24, 2017 at 05:52:59PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Oct 23, 2017 at 05:33:17PM +0200, Phil Sutter wrote:
[...]
> > diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
> > index 44d3e95d399e6..1207f10cd2457 100644
> > --- a/include/nftables/nftables.h
> > +++ b/include/nftables/nftables.h
> > @@ -51,6 +51,7 @@ enum nftables_exit_codes {
> >  struct nft_ctx *nft_ctx_new(uint32_t flags);
> >  void nft_ctx_free(struct nft_ctx *ctx);
> >  FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
> > +void nft_ctx_flush_cache(struct nft_ctx *ctx);
> 
> I would prefer we rename this to nft_ctx_flush_cache().
> 
> Now, let's make an exercise of abstraction: You're not Phil Sutter,
> you're developer Vlamidir.
> 
> Vladimir wants to make a third party application based on libnftables
> that is going to rock the world.
> 
> He knows nothing about internals, but he looks at the API and say:
> "Hey, I can flush the cache, what is this cache concept?".
> 
> I'm telling this story because we're leaking an internal detail
> implementation. So I would just rename this to nft_ctx_reset(). This
> magic call just cleans up the context for you.

Hmm. Without further information, I would guess for nft_ctx_reset() to
reset all the context data which was previously modified using those
setters I defined. A possible cache to reset didn't come to mind since I
wasn't aware that there is a cache at all!

> Vladimir will be just need to know that he needs to reset context if
> he want to make incremental updates based on current.

I wonder whether we need to reset the cache at all: We could make
cache_update() ignore cache->initialized and instead check whether
nft_genid did change after calling netlink_genid_get() - if not, cache
is up to date, otherwise call cache_init(). When we discussed possible
performance implications of cache updates, I suggested just that as a
first counter-measure.

Could this work? Or am I missing something?

Cheers, Phil
