Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18032C83F11
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 15:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjH1PA7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 11:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbjH1PAk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 11:00:40 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0129B122
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 08:00:34 -0700 (PDT)
Received: from [78.30.34.192] (port=39328 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qadjA-00AHYZ-TQ; Mon, 28 Aug 2023 17:00:31 +0200
Date:   Mon, 28 Aug 2023 17:00:28 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/4] src: add ops_cache struct for caching
 information during parsing
Message-ID: <ZOy2jBH37a16AsJ4@calendula>
References: <20230825132942.2733840-1-thaller@redhat.com>
 <20230825132942.2733840-3-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230825132942.2733840-3-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 25, 2023 at 03:24:18PM +0200, Thomas Haller wrote:
> The "ops_cache" will be used for caching the current timestamp
> (time(NULL)) for the duration of one operation. It will ensure that all
> decisions regarding the time, are based on the same timestamp.
>
> Add the struct for that. The content will be added next.
> 
> There is already "struct nft_cache", but that seems to have a
> different purpose. Hence, instead of extending "struct nft_cache",
> add a new "struct ops_cache".

There is a "struct nft_cache" which stores objects from the kernel.

This new area is only used to store time related information.  I
prefer you simple call this time_cache or such, so it only wraps time
related information.

If there is a need to cache something else, new structures can be
added, no need to place all in ops_cache.

> The difficulty is invalidating the cache and find the right places
> to call nft_ctx_reset_ops_cache().

Could you explain the rationale to invalidate this time cache?

> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  include/datatype.h |  8 ++++++++
>  include/nftables.h |  3 +++
>  src/evaluate.c     |  5 +++--
>  src/libnftables.c  | 17 +++++++++++++++++
>  4 files changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/include/datatype.h b/include/datatype.h
> index 9ce7359cd340..79d996edd348 100644
> --- a/include/datatype.h
> +++ b/include/datatype.h
> @@ -120,6 +120,13 @@ enum byteorder {
>  
>  struct expr;
>  
> +struct ops_cache {
> +};
> +
> +#define CTX_CACHE_INIT() \
> +	{ \
> +	}
> +
>  /**
>   * enum datatype_flags
>   *
> @@ -182,6 +189,7 @@ struct datatype *dtype_clone(const struct datatype *orig_dtype);
>  struct parse_ctx {
>  	struct symbol_tables	*tbl;
>  	const struct input_ctx	*input;
> +	struct ops_cache	*ops_cache;
>  };
>  
>  extern struct error_record *symbol_parse(struct parse_ctx *ctx,
> diff --git a/include/nftables.h b/include/nftables.h
> index 219a10100206..b0a7f2f874ca 100644
> --- a/include/nftables.h
> +++ b/include/nftables.h
> @@ -6,6 +6,7 @@
>  #include <utils.h>
>  #include <cache.h>
>  #include <nftables/libnftables.h>
> +#include <datatype.h>
>  
>  struct cookie {
>  	FILE *fp;
> @@ -47,6 +48,7 @@ struct output_ctx {
>  		struct cookie error_cookie;
>  	};
>  	struct symbol_tables tbl;
> +	struct ops_cache *ops_cache;
>  };
>  
>  static inline bool nft_output_reversedns(const struct output_ctx *octx)
> @@ -136,6 +138,7 @@ struct nft_ctx {
>  	struct output_ctx	output;
>  	bool			check;
>  	struct nft_cache	cache;
> +	struct ops_cache	ops_cache;
>  	uint32_t		flags;
>  	uint32_t		optimize_flags;
>  	struct parser_state	*state;
> diff --git a/src/evaluate.c b/src/evaluate.c
> index fdd2433b4780..ea910786f3e4 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -43,8 +43,9 @@
>  static struct parse_ctx *parse_ctx_init(struct parse_ctx *parse_ctx, const struct eval_ctx *ctx)
>  {
>  	struct parse_ctx tmp = {
> -		.tbl	= &ctx->nft->output.tbl,
> -		.input	= &ctx->nft->input,
> +		.tbl		= &ctx->nft->output.tbl,
> +		.input		= &ctx->nft->input,
> +		.ops_cache	= &ctx->nft->ops_cache,
>  	};
>  
>  	/* "tmp" only exists, so we can search for "/struct parse_ctx .*=/" and find the location
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 9c802ec95f27..e520bac76dfa 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -19,6 +19,15 @@
>  #include <stdlib.h>
>  #include <string.h>
>  
> +static void nft_ctx_reset_ops_cache(struct nft_ctx *ctx)
> +{
> +	ctx->ops_cache = (struct ops_cache) CTX_CACHE_INIT();
> +
> +	/* The cache is also referenced by the output context. Set
> +	 * up the pointer. */
> +	ctx->output.ops_cache = &ctx->ops_cache;
> +}
> +
>  static int nft_netlink(struct nft_ctx *nft,
>  		       struct list_head *cmds, struct list_head *msgs)
>  {
> @@ -37,6 +46,8 @@ static int nft_netlink(struct nft_ctx *nft,
>  	if (list_empty(cmds))
>  		goto out;
>  
> +	nft_ctx_reset_ops_cache(nft);
> +
>  	batch_seqnum = mnl_batch_begin(ctx.batch, mnl_seqnum_alloc(&seqnum));
>  	list_for_each_entry(cmd, cmds, list) {
>  		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
> @@ -522,6 +533,8 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
>  	unsigned int flags;
>  	int err = 0;
>  
> +	nft_ctx_reset_ops_cache(nft);
> +
>  	filter = nft_cache_filter_init();
>  	if (nft_cache_evaluate(nft, cmds, msgs, filter, &flags) < 0) {
>  		nft_cache_filter_fini(filter);
> @@ -630,6 +643,8 @@ err:
>  	if (rc || nft->check)
>  		nft_cache_release(&nft->cache);
>  
> +	nft_ctx_reset_ops_cache(nft);
> +
>  	return rc;
>  }
>  
> @@ -740,6 +755,8 @@ err:
>  
>  	scope_release(nft->state->scopes[0]);
>  
> +	nft_ctx_reset_ops_cache(nft);
> +
>  	return rc;
>  }
>  
> -- 
> 2.41.0
> 
