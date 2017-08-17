From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATH 08/16] libnftables: add a nft_cache to nft_ctx
Date: Thu, 17 Aug 2017 11:43:53 +0200
Message-ID: <20170817094353.GW16375@orbyte.nwl.cc>
References: <20170816204310.3371-1-eric@regit.org>
 <20170816204310.3371-9-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49413 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751015AbdHQJny (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 05:43:54 -0400
Content-Disposition: inline
In-Reply-To: <20170816204310.3371-9-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 16, 2017 at 10:43:02PM +0200, Eric Leblond wrote:
[...]
> diff --git a/include/cli.h b/include/cli.h
> index e577400..899c8a6 100644
> --- a/include/cli.h
> +++ b/include/cli.h
> @@ -6,7 +6,7 @@
>  struct parser_state;
>  #ifdef HAVE_LIBREADLINE
>  extern int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
> -		    struct nft_cache *cache, struct parser_state *state);
> +		    struct parser_state *state);

One could get rid of nf_sock parameter as well since that resides in
nft_ctx, too.

[...]
> diff --git a/src/cli.c b/src/cli.c
> index 7501b29..fd5c7b7 100644
> --- a/src/cli.c
> +++ b/src/cli.c
> @@ -177,13 +177,17 @@ void __fmtstring(1, 0) cli_display(const char *fmt, va_list ap)
>  }
>  
>  int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
> -	     struct nft_cache *cache, struct parser_state *_state)
> +	     struct parser_state *_state)
>  {
>  	const char *home;
> +	struct nft_cache cache;
> +
> +	memset(&cache, 0, sizeof(cache));
> +	init_list_head(&cache.list);

Is this a leftover, or do you intentionally use a new cache instance
instead of nft->cache?

Cheers, Phil
