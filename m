From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 04/18] libnftables: add context new and free
Date: Mon, 21 Aug 2017 10:17:45 +0200
Message-ID: <20170821081745.GC2982@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-5-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:53096 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbdHUISS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 04:18:18 -0400
Content-Disposition: inline
In-Reply-To: <20170819152420.22563-5-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 19, 2017 at 05:24:06PM +0200, Eric Leblond wrote:
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  include/nftables.h          |  1 +
>  include/nftables/nftables.h |  3 +++
>  src/libnftables.c           | 20 ++++++++++++++++++++
>  src/main.c                  | 29 ++++++++++++++---------------
>  4 files changed, 38 insertions(+), 15 deletions(-)
> 
> diff --git a/include/nftables.h b/include/nftables.h
> index a457aba..717af37 100644
> --- a/include/nftables.h
> +++ b/include/nftables.h
> @@ -35,6 +35,7 @@ struct output_ctx {
>  struct nft_ctx {
>  	struct output_ctx	output;
>  	bool			check;
> +	struct mnl_socket	*nf_sock;
>  };
>  
>  struct nft_cache {
> diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
> index 4ba16f0..cfa60fe 100644
> --- a/include/nftables/nftables.h
> +++ b/include/nftables/nftables.h
> @@ -17,4 +17,7 @@
>  void nft_global_init(void);
>  void nft_global_deinit(void);
>  
> +struct nft_ctx *nft_context_new(void);
> +void nft_context_free(struct nft_ctx *nft);
> +
>  #endif
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 215179a..6756c0f 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -51,3 +51,23 @@ void nft_global_deinit(void)
>  	realm_table_meta_exit();
>  	mark_table_exit();
>  }
> +
> +struct nft_ctx *nft_context_new(void)
> +{
> +	struct nft_ctx *ctx = NULL;
> +	ctx = calloc(1, sizeof(struct nft_ctx));
> +	if (ctx == NULL)
> +		return NULL;
> +	ctx->nf_sock = netlink_open_sock();

I would prefer we keep the 'struct mnl_socket' away from the context
structure.

If we want to support monitor mode, that is something I would like to
support too, then we have to expose this netlink descriptor since
event handling is usually trickier.

Please, don't tell me that we can expose the socket file descriptor
though some nft_ctx_get_fd()... Then, we may have to expose toggle for
O_CLOEXEC in socket() and whatever new details that gets added to
netlink.

In the past, looking at libnfnetlink and other libnetfilter_*, hidding
the netlink file descriptor - and netlink details in general - was a
design decision.
