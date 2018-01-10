From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] Don't merge adjacent/overlapping ranges by default
Date: Wed, 10 Jan 2018 12:51:00 +0100
Message-ID: <20180110115100.z3hbazlk4w7lekga@salvia>
References: <20180110104221.3565-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34394 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933970AbeAJLvG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 06:51:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8C791B8418
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 12:51:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9845DA84C
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 12:51:04 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180110104221.3565-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

Thanks for working on this!

On Wed, Jan 10, 2018 at 11:42:21AM +0100, Phil Sutter wrote:
> This patch introduces a new commandline parameter -m/--merge which
> restores the old behaviour.
> 
> Previously, when adding multiple ranges to a set they were merged if
> overlapping or adjacent. This might cause inconvenience though since it
> is afterwards not easily possible anymore to remove one of the merged
> ranges again while keeping the others in place.
> 
> Since it is not possible to have overlapping ranges, this patch adds a
> check for newly added ranges to make sure they don't overlap if merging
> is turned off.
> 
> Two tests had to be adjusted: One in tests/py to avoid adding
> overlapping ranges and the other in tests/shell to call nft with --merge
> option.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/expression.h                               |  2 +-
>  include/netlink.h                                  |  2 ++
>  include/nftables.h                                 |  1 +
>  include/nftables/nftables.h                        |  3 ++
>  src/libnftables.c                                  | 11 +++++++
>  src/main.c                                         | 11 ++++++-
>  src/rule.c                                         |  8 +++--
>  src/segtree.c                                      | 38 ++++++++++++++++++----
>  tests/py/any/meta.t                                |  2 +-
>  tests/py/any/meta.t.payload                        |  4 +--
>  .../sets/0002named_interval_automerging_0          |  2 +-
>  11 files changed, 69 insertions(+), 15 deletions(-)
> 
> diff --git a/include/expression.h b/include/expression.h
> index 915ce0bad04df..0a0e178fe4680 100644
> --- a/include/expression.h
> +++ b/include/expression.h
> @@ -419,7 +419,7 @@ extern struct expr *set_expr_alloc(const struct location *loc,
>  				   const struct set *set);
>  extern int set_to_intervals(struct list_head *msgs, struct set *set,
>  			    struct expr *init, bool add,
> -			    unsigned int debug_mask);
> +			    unsigned int debug_mask, bool merge);
>  extern void interval_map_decompose(struct expr *set);
>  
>  extern struct expr *mapping_expr_alloc(const struct location *loc,
> diff --git a/include/netlink.h b/include/netlink.h
> index 51cd5c9d1b94d..4ec215da1dcde 100644
> --- a/include/netlink.h
> +++ b/include/netlink.h
> @@ -42,6 +42,7 @@ extern const struct location netlink_location;
>   * @octx:	output context
>   * @debug_mask:	display debugging information
>   * @cache:	cache context
> + * @range_merge: merge adjacent/overlapping ranges in new set elements
>   */
>  struct netlink_ctx {
>  	struct mnl_socket	*nf_sock;
> @@ -55,6 +56,7 @@ struct netlink_ctx {
>  	unsigned int		debug_mask;
>  	struct output_ctx	*octx;
>  	struct nft_cache	*cache;
> +	bool			range_merge;
>  };
>  
>  extern struct nftnl_table *alloc_nftnl_table(const struct handle *h);
> diff --git a/include/nftables.h b/include/nftables.h
> index 3bfa33e5cb336..f22df0d1ddc15 100644
> --- a/include/nftables.h
> +++ b/include/nftables.h
> @@ -31,6 +31,7 @@ struct nft_ctx {
>  	unsigned int		debug_mask;
>  	struct output_ctx	output;
>  	bool			check;
> +	bool			range_merge;
>  	struct nft_cache	cache;
>  	uint32_t		flags;
>  };
> diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
> index 8e59f2b2a59ab..ae0d25832b70c 100644
> --- a/include/nftables/nftables.h
> +++ b/include/nftables/nftables.h
> @@ -43,6 +43,9 @@ void nft_ctx_free(struct nft_ctx *ctx);
>  
>  bool nft_ctx_get_dry_run(struct nft_ctx *ctx);
>  void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry);
> +bool nft_ctx_get_range_merge(struct nft_ctx *ctx);
> +void nft_ctx_set_range_merge(struct nft_ctx *ctx, bool merge);
> +
>  enum nft_numeric_level nft_ctx_output_get_numeric(struct nft_ctx *ctx);
>  void nft_ctx_output_set_numeric(struct nft_ctx *ctx, enum nft_numeric_level level);
>  bool nft_ctx_output_get_stateless(struct nft_ctx *ctx);
> diff --git a/src/libnftables.c b/src/libnftables.c
> index c86d89477e778..447baa7a7e4f9 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -43,6 +43,7 @@ static int nft_netlink(struct nft_ctx *nft,
>  		ctx.nf_sock = nf_sock;
>  		ctx.cache = &nft->cache;
>  		ctx.debug_mask = nft->debug_mask;
> +		ctx.range_merge = nft->range_merge;
>  		init_list_head(&ctx.list);
>  		ret = do_command(&ctx, cmd);
>  		if (ret < 0)
> @@ -209,6 +210,16 @@ void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry)
>  	ctx->check = dry;
>  }
>  
> +bool nft_ctx_get_range_merge(struct nft_ctx *ctx)
> +{
> +	return ctx->range_merge;
> +}
> +
> +void nft_ctx_set_range_merge(struct nft_ctx *ctx, bool merge)
> +{
> +	ctx->range_merge = merge;
> +}
> +
>  enum nft_numeric_level nft_ctx_output_get_numeric(struct nft_ctx *ctx)
>  {
>  	return ctx->output.numeric;
> diff --git a/src/main.c b/src/main.c
> index 353b87bc66631..69b3a1b898f33 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -37,10 +37,11 @@ enum opt_vals {
>  	OPT_DEBUG		= 'd',
>  	OPT_HANDLE_OUTPUT	= 'a',
>  	OPT_ECHO		= 'e',
> +	OPT_MERGE		= 'm',
>  	OPT_INVALID		= '?',
>  };
>  
> -#define OPTSTRING	"hvcf:iI:vnsNae"
> +#define OPTSTRING	"hvcf:iI:vnsNaem"
>  
>  static const struct option options[] = {
>  	{
> @@ -95,6 +96,10 @@ static const struct option options[] = {
>  		.val		= OPT_ECHO,
>  	},
>  	{
> +		.name		= "merge",
> +		.val		= OPT_MERGE,
> +	},
> +	{
>  		.name		= NULL
>  	}
>  };
> @@ -119,6 +124,7 @@ static void show_help(const char *name)
>  "  -N				Translate IP addresses to names.\n"
>  "  -a, --handle			Output rule handle.\n"
>  "  -e, --echo			Echo what has been added, inserted or replaced.\n"
> +"  -m, --merge			Merge adjacent/overlapping ranges in sets upon insertion.\n"

I would disable this by default by now, no option.

Then, revisit this later on to see if it's worth adding this, thanks!
