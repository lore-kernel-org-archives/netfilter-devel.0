From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] src: rename pr_debug() to pr_gmp_debug() and use
 printf() whenever possible
Date: Thu, 8 Jan 2015 12:43:45 +0000
Message-ID: <20150108124345.GM13765@acer.localdomain>
References: <1420720738-4953-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60994 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbbAHMnu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:43:50 -0500
Content-Disposition: inline
In-Reply-To: <1420720738-4953-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.01, Pablo Neira Ayuso wrote:
> Rename pr_debug() to pr_gmp_debug() so the new function name reminds
> us the explicit dependency with libgmp, as suggested by Patrick.
> 
> Moreover, use printf() instead of pr_debug() if no mpz_t types are
> used, so we get debugging information for proto-ctx as well.
> 
> pr_gmp_debug() is disabled with --with-mini-gmp since it relies on the
> gmp_printf(), which is not available in the mini-gmp implementation.


Not entirely, my suggestion was to keep the existing instances of
pr_debug() (mapped to printf) everywhere but in segtree.

> --- a/src/proto.c
> +++ b/src/proto.c
> @@ -137,15 +137,15 @@ static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base)
>  	if (!(debug_level & DEBUG_PROTO_CTX))
>  		return;
>  
> -	pr_debug("update %s protocol context:\n", proto_base_names[base]);
> +	printf("update %s protocol context:\n", proto_base_names[base]);
>  	for (i = PROTO_BASE_LL_HDR; i <= PROTO_BASE_MAX; i++) {
> -		pr_debug(" %-20s: %s%s\n",
> -			 proto_base_names[i],
> -			 ctx->protocol[i].desc ? ctx->protocol[i].desc->name :
> -						 "none",
> -			 i == base ? " <-" : "");
> +		printf(" %-20s: %s%s\n",
> +		       proto_base_names[i],
> +		       ctx->protocol[i].desc ? ctx->protocol[i].desc->name :
> +					       "none",
> +		       i == base ? " <-" : "");
>  	}
> -	pr_debug("\n");
> +	printf("\n");
>  #endif

So I wouldn't change this.
