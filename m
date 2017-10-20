From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/7] libnftables: Introduce nft_ctx_flush_cache()
Date: Fri, 20 Oct 2017 14:13:26 +0200
Message-ID: <20171020121326.GC4068@salvia>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-4-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43890 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752745AbdJTMNa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 08:13:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4D41A69272
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:13:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3CAD0DA86C
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:13:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171019081847.16171-4-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 19, 2017 at 10:18:43AM +0200, Phil Sutter wrote:
> This allows an application to explicitly flush caches associated with a
> given nft context.
> 
> Note that this is a bit inconsistent in that it releases the global
> interface cache, but nft_ctx_free() does the same so at least it's not a
> regression.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/nftables/nftables.h | 1 +
>  src/libnftables.c           | 9 +++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
> index 052a77bfb5371..fbc6fd4252a97 100644
> --- a/include/nftables/nftables.h
> +++ b/include/nftables/nftables.h
> @@ -77,6 +77,7 @@ enum nftables_exit_codes {
>  struct nft_ctx *nft_ctx_new(uint32_t flags);
>  void nft_ctx_free(struct nft_ctx *ctx);
>  FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
> +void nft_ctx_flush_cache(struct nft_ctx *ctx);
>  
>  int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
>  	    void *scanner, struct parser_state *state,
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 187747c66af21..0de50c854d572 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -146,13 +146,18 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
>  	return ctx;
>  }
>  
> +void nft_ctx_flush_cache(struct nft_ctx *ctx)
> +{
> +	iface_cache_release();
> +	cache_release(&ctx->cache);
> +}

This flush allows us to release the cache, but nft_ctx_alloc()
populates it. I'm missing something here, can we force a context
repopulation?

If there is no usecase for this yet, I would keep this behind by now.
