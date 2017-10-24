From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 2/4] libnftables: Introduce nft_ctx_flush_cache()
Date: Tue, 24 Oct 2017 17:52:59 +0200
Message-ID: <20171024155258.GB11705@salvia>
References: <20171023153319.13415-1-phil@nwl.cc>
 <20171023153319.13415-3-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52284 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751514AbdJXPxD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 11:53:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B38A6E8EB6
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 17:53:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9FEB7DA7E9
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 17:53:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171023153319.13415-3-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 23, 2017 at 05:33:17PM +0200, Phil Sutter wrote:
> This allows an application to explicitly flush caches associated with a
> given nft context, as seen in cli_complete().
> 
> Note that this is a bit inconsistent in that it releases the global
> interface cache, but nft_ctx_free() does the same so at least it's not a
> regression.
> 
> Note that there is no need for explicit cache update routine since cache
> is populated during command execution depending on whether it is needed
> or not.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/nftables/nftables.h | 1 +
>  src/cli.c                   | 3 +--
>  src/libnftables.c           | 9 +++++++--
>  3 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
> index 44d3e95d399e6..1207f10cd2457 100644
> --- a/include/nftables/nftables.h
> +++ b/include/nftables/nftables.h
> @@ -51,6 +51,7 @@ enum nftables_exit_codes {
>  struct nft_ctx *nft_ctx_new(uint32_t flags);
>  void nft_ctx_free(struct nft_ctx *ctx);
>  FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
> +void nft_ctx_flush_cache(struct nft_ctx *ctx);

I would prefer we rename this to nft_ctx_flush_cache().

Now, let's make an exercise of abstraction: You're not Phil Sutter,
you're developer Vlamidir.

Vladimir wants to make a third party application based on libnftables
that is going to rock the world.

He knows nothing about internals, but he looks at the API and say:
"Hey, I can flush the cache, what is this cache concept?".

I'm telling this story because we're leaking an internal detail
implementation. So I would just rename this to nft_ctx_reset(). This
magic call just cleans up the context for you.

Vladimir will be just need to know that he needs to reset context if
he want to make incremental updates based on current.

I agree with you that we cannot allocate 'cache' from nft_ctx_alloc(),
it's good you reminded me this :-).

But I would say, we can just hide these details behind the curtain.

Let me know, thanks

P.S: I still has pushed out your patchset, it's just that I'm
providing feedback so we speed up libnftables release :-).
