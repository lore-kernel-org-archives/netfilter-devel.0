From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 05/18] libnftables: add nft_run_command_from_buffer
Date: Mon, 21 Aug 2017 10:23:44 +0200
Message-ID: <20170821082344.GE2982@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-6-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:53150 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdHUIYM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 04:24:12 -0400
Content-Disposition: inline
In-Reply-To: <20170819152420.22563-6-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 19, 2017 at 05:24:07PM +0200, Eric Leblond wrote:
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  include/nftables/nftables.h |  3 +++
>  src/libnftables.c           | 26 +++++++++++++++++++++++++-
>  src/main.c                  | 19 ++++++++-----------
>  3 files changed, 36 insertions(+), 12 deletions(-)
> 
> diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
> index cfa60fe..63150ba 100644
> --- a/include/nftables/nftables.h
> +++ b/include/nftables/nftables.h
> @@ -20,4 +20,7 @@ void nft_global_deinit(void);
>  struct nft_ctx *nft_context_new(void);
>  void nft_context_free(struct nft_ctx *nft);
>  
> +int nft_run_command_from_buffer(struct nft_ctx *nft, struct nft_cache *cache,
> +				char *buf, size_t buflen);

Can we probably have something like:

nft_import_from_buffer(ctx, ...)
nft_import_from_file(ctx, ...)

That initializes the context structure. Then, a generic:

nft_run(ctx)

I suggest you make a patch to add these to nftables in first place.
I mean, just send a patch that adds these functions as static to
src/main.c to start with it. Just as a cleanup to prepare thing, we
can integrate this asap meanwhile we keep discussing library details,
so we reduce the size/burden of your patchset as we iterate over it.
To integrate things more quickly.

Thanks.
