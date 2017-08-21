From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 10/18] libnftables: add a nft_cache to nft_ctx
Date: Mon, 21 Aug 2017 10:32:27 +0200
Message-ID: <20170821083227.GG2982@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-11-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:53221 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751831AbdHUIcz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 04:32:55 -0400
Content-Disposition: inline
In-Reply-To: <20170819152420.22563-11-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 19, 2017 at 05:24:12PM +0200, Eric Leblond wrote:
> Hide this structure from the user, this allows simplify the simple
> functions by just providing easy and meaningfull arguments.

I'm fine with placing the cache into nft_ctx. You can send an upfront
initial patch to do this that I would ack asap.

More comments below.

> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  include/cli.h               |  2 +-
>  include/nftables.h          | 13 +++++++------
>  include/nftables/nftables.h |  5 ++---
>  src/cli.c                   | 10 ++++++++--
>  src/libnftables.c           | 19 +++++++++++--------
>  src/main.c                  | 11 +++--------
>  6 files changed, 32 insertions(+), 28 deletions(-)
> 
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
>  #else
>  static inline int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
>  			   struct nft_cache *cache, struct parser_state *state)

cli_init footprint is not updated, this will break compilation with no
HAVE_LIBREADLINE.

> diff --git a/include/nftables.h b/include/nftables.h
> index aad204e..348fbb0 100644
> --- a/include/nftables.h
> +++ b/include/nftables.h
> @@ -32,18 +32,19 @@ struct output_ctx {
>  	unsigned int echo;
>  };
>  
> -struct nft_ctx {
> -	struct output_ctx	output;
> -	bool			check;
> -	struct mnl_socket	*nf_sock;
> -};
> -
>  struct nft_cache {
>  	bool			initialized;
>  	struct list_head	list;
>  	uint32_t		seqnum;
>  };
>  
> +struct nft_ctx {
> +	struct output_ctx	output;
> +	bool			check;
> +	struct mnl_socket	*nf_sock;
> +	struct nft_cache	cache;
> +};
> +
>  extern unsigned int max_errors;
>  extern unsigned int debug_level;
>  extern const char *include_paths[INCLUDE_PATHS_MAX];
> diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
> index 20a062c..b902cbd 100644
> --- a/include/nftables/nftables.h
> +++ b/include/nftables/nftables.h
> @@ -27,9 +27,8 @@ void nft_global_deinit(void);
>  struct nft_ctx *nft_context_new(void);
>  void nft_context_free(struct nft_ctx *nft);
>  
> -int nft_run_command_from_buffer(struct nft_ctx *nft, struct nft_cache *cache,
> +int nft_run_command_from_buffer(struct nft_ctx *nft,
>  				char *buf, size_t buflen);
> -int nft_run_command_from_filename(struct nft_ctx *nft, struct nft_cache *cache,
> -				  const char *filename);
> +int nft_run_command_from_filename(struct nft_ctx *nft, const char *filename);
>  
>  #endif
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
>  
>  	cli_nf_sock = nf_sock;
>  	cli_nft = *nft;
> -	cli_cache = cache;
> +	cli_cache = &cache;
>  	rl_readline_name = "nft";
>  	rl_instream  = stdin;
>  	rl_outstream = stdout;
> @@ -204,6 +208,8 @@ int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
>  
>  	while (!eof)
>  		rl_callback_read_char();
> +
> +	cache_release(&cache);
>  	return 0;
>  }
>  
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 28f9272..19d539c 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -63,7 +63,10 @@ struct nft_ctx *nft_context_new(void)
>  	ctx = calloc(1, sizeof(struct nft_ctx));
>  	if (ctx == NULL)
>  		return NULL;
> +
> +	memset(ctx, 0, sizeof(*ctx));

memset() a calloc() memory area? Not needed.

>  	ctx->nf_sock = netlink_open_sock();
> +	init_list_head(&ctx->cache.list);

Cleanup: It would be good to add a cache_init() function probably.

>  	return ctx;
>  }
> @@ -74,6 +77,7 @@ void nft_context_free(struct nft_ctx *nft)
>  	if (nft == NULL)
>  		return;
>  	netlink_close_sock(nft->nf_sock);
> +	cache_release(&nft->cache);
>  	xfree(nft);
>  }
>  
> @@ -82,7 +86,7 @@ static const struct input_descriptor indesc_cmdline = {
>  	.name	= "<cmdline>",
>  };
>  
> -int nft_run_command_from_buffer(struct nft_ctx *nft, struct nft_cache *cache,
> +int nft_run_command_from_buffer(struct nft_ctx *nft,
>  				char *buf, size_t buflen)
>  {
>  	int rc = NFT_EXIT_SUCCESS;
> @@ -90,11 +94,11 @@ int nft_run_command_from_buffer(struct nft_ctx *nft, struct nft_cache *cache,
>  	LIST_HEAD(msgs);
>  	void *scanner;
>  
> -	parser_init(nft->nf_sock, cache, &state, &msgs);
> +	parser_init(nft->nf_sock, &nft->cache, &state, &msgs);
>  	scanner = scanner_init(&state);
>  	scanner_push_buffer(scanner, &indesc_cmdline, buf);
>  		
        ^^^^^^^^

Comestic: There is an empty line here above with an indent.
