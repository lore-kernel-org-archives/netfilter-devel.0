From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/2] src: get rid of printf
Date: Mon, 4 Sep 2017 00:34:41 +0200
Message-ID: <20170903223441.GB12383@salvia>
References: <20170903220356.20178-1-eric@regit.org>
 <20170903220356.20178-3-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:40750 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752964AbdICWfO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Sep 2017 18:35:14 -0400
Content-Disposition: inline
In-Reply-To: <20170903220356.20178-3-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 04, 2017 at 12:03:56AM +0200, Eric Leblond wrote:
> This patch introduces the nft_print_to_output_ctx function that has
> to be used instead of printf to output information that where
> previously send to stdout. This function accumulate the output in
> a buffer that can be fetched by the user with the nft_ctx_get_output()
> function.
> 
> This modification will allow the libnftables library to provide an
> easy way to the users to get the output data and display them like
> they want.
> 
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  include/datatype.h   |   5 +-
>  include/expression.h |   2 +-
>  include/nftables.h   |   5 ++
>  src/cli.c            |   1 +
>  src/ct.c             |  21 ++---
>  src/datatype.c       |  66 ++++++++-------
>  src/expression.c     |  79 ++++++++++--------
>  src/exthdr.c         |  16 ++--
>  src/fib.c            |  23 +++---
>  src/hash.c           |  10 +--
>  src/main.c           |  45 ++++++++++
>  src/meta.c           |  32 +++++---
>  src/numgen.c         |   8 +-
>  src/payload.c        |   9 +-
>  src/rule.c           | 228 +++++++++++++++++++++++++++++----------------------
>  src/statement.c      | 145 +++++++++++++++++---------------
>  16 files changed, 408 insertions(+), 287 deletions(-)
> 
> diff --git a/include/datatype.h b/include/datatype.h
> index 2e34591..e9f6079 100644
> --- a/include/datatype.h
> +++ b/include/datatype.h
> @@ -209,7 +209,8 @@ extern void symbolic_constant_print(const struct symbol_table *tbl,
>  				    struct output_ctx *octx);
>  extern void symbol_table_print(const struct symbol_table *tbl,
>  			       const struct datatype *dtype,
> -			       enum byteorder byteorder);
> +			       enum byteorder byteorder,
> +			       struct output_ctx *octx);
>  
>  extern struct symbol_table *rt_symbol_table_init(const char *filename);
>  extern void rt_symbol_table_free(struct symbol_table *tbl);
> @@ -261,7 +262,7 @@ extern const struct datatype *
>  set_datatype_alloc(const struct datatype *orig_dtype, unsigned int byteorder);
>  extern void set_datatype_destroy(const struct datatype *dtype);
>  
> -extern void time_print(uint64_t seconds);
> +extern void time_print(uint64_t seconds, struct output_ctx *octx);
>  extern struct error_record *time_parse(const struct location *loc,
>  				       const char *c, uint64_t *res);
>  
> diff --git a/include/expression.h b/include/expression.h
> index 32d4423..ce6b702 100644
> --- a/include/expression.h
> +++ b/include/expression.h
> @@ -334,7 +334,7 @@ extern struct expr *expr_get(struct expr *expr);
>  extern void expr_free(struct expr *expr);
>  extern void expr_print(const struct expr *expr, struct output_ctx *octx);
>  extern bool expr_cmp(const struct expr *e1, const struct expr *e2);
> -extern void expr_describe(const struct expr *expr);
> +extern void expr_describe(const struct expr *expr, struct output_ctx *octx);
>  
>  extern const struct datatype *expr_basetype(const struct expr *expr);
>  extern void expr_set_type(struct expr *expr, const struct datatype *dtype,
> diff --git a/include/nftables.h b/include/nftables.h
> index 7c4e93f..f4d5ce1 100644
> --- a/include/nftables.h
> +++ b/include/nftables.h
> @@ -30,6 +30,8 @@ struct output_ctx {
>  	unsigned int ip2name;
>  	unsigned int handle;
>  	unsigned int echo;
> +	char *output_buf;
> +	size_t output_buf_len;
>  };
>  
>  struct nft_cache {
> @@ -149,4 +151,7 @@ void realm_table_meta_exit(void);
>  void devgroup_table_exit(void);
>  void realm_table_rt_exit(void);
>  
> +int nft_print_to_output_ctx(struct output_ctx *octx, const char *fmt, ...);
> +char *nft_ctx_get_output(struct nft_ctx *ctx);
> +
>  #endif /* NFTABLES_NFTABLES_H */
> diff --git a/src/cli.c b/src/cli.c
> index d923ff7..ca4418c 100644
> --- a/src/cli.c
> +++ b/src/cli.c
> @@ -138,6 +138,7 @@ static void cli_complete(char *line)
>  		    cli_nft->debug_mask);
>  	scanner_push_buffer(scanner, &indesc_cli, line);
>  	nft_run(cli_nft, cli_nf_sock, scanner, state, &msgs);
> +	printf("%s", nft_ctx_get_output(cli_nft));
>  	erec_print_list(stdout, &msgs, cli_nft->debug_mask);
>  	xfree(line);
>  	cache_release(&cli_nft->cache);
> diff --git a/src/ct.c b/src/ct.c
> index d64f467..f19608a 100644
> --- a/src/ct.c
> +++ b/src/ct.c
> @@ -141,11 +141,12 @@ static void ct_label_type_print(const struct expr *expr,
>  	for (s = ct_label_tbl->symbols; s->identifier != NULL; s++) {
>  		if (bit != s->value)
>  			continue;
> -		printf("\"%s\"", s->identifier);
> +		nft_print_to_output_ctx(octx, "\"%s\"", s->identifier);
>  		return;
>  	}
>  	/* can happen when connlabel.conf is altered after rules were added */
> -	printf("%ld\n", (long)mpz_scan1(expr->value, 0));
> +	nft_print_to_output_ctx(octx, "%ld\n",

Let's call this nft_print(), ok?

I can make the rename here before applying.

I have a bad record of making functions unnecessarily long, so I'm
trying to fix it this time. Anyway, this will be internal, so no
problem.
