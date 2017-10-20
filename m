From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 7/7] libnftables: Add remaining getters and setters
Date: Fri, 20 Oct 2017 14:18:53 +0200
Message-ID: <20171020121853.GF4068@salvia>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-8-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46682 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751422AbdJTMS6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 08:18:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DFE9A6926C
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:18:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD2CBDA874
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:18:56 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171019081847.16171-8-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 19, 2017 at 10:18:47AM +0200, Phil Sutter wrote:
> Provide API functions for remaining context settings changed by main.c,
> then hide struct nft_ctx definition from applications. This allows us to
> later change data structures internally without risk of breaking
> applications.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/nftables.h          | 27 +++++++++++++++++++++
>  include/nftables/nftables.h | 41 ++++++++++---------------------
>  src/libnftables.c           | 59 +++++++++++++++++++++++++++++++++++++++++++++
>  src/main.c                  | 18 +++++++++-----
>  4 files changed, 111 insertions(+), 34 deletions(-)
> 
> diff --git a/include/nftables.h b/include/nftables.h
> index a633e1a2cc2e2..ad72383303bdb 100644
> --- a/include/nftables.h
> +++ b/include/nftables.h
> @@ -6,6 +6,33 @@
>  #include <utils.h>
>  #include <nftables/nftables.h>
>  
> +struct nft_cache {
> +	bool			initialized;
> +	struct list_head	list;
> +	uint32_t		seqnum;
> +};
> +
> +struct output_ctx {
> +	unsigned int numeric;
> +	unsigned int stateless;
> +	unsigned int ip2name;
> +	unsigned int handle;
> +	unsigned int echo;
> +	FILE *output_fp;
> +};
> +
> +struct nft_ctx {
> +	struct mnl_socket	*nf_sock;
> +	char			**include_paths;
> +	unsigned int		num_include_paths;
> +	unsigned int		parser_max_errors;
> +	unsigned int		debug_mask;
> +	struct output_ctx	output;
> +	bool			check;
> +	struct nft_cache	cache;
> +	uint32_t		flags;
> +};

Oh, I see. Now these structure definitions are coming back to
include/nftables.h. I'm telling this because of what I mentioned in
2/7.

I would prefer we avoid these goes back and forth with this code.

> +
>  struct input_descriptor;
>  struct location {
>  	const struct input_descriptor		*indesc;
> diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
> index a752f20d74132..2bc3061457257 100644
> --- a/include/nftables/nftables.h
> +++ b/include/nftables/nftables.h
> @@ -9,34 +9,7 @@
>  #ifndef LIB_NFTABLES_H
>  #define LIB_NFTABLES_H
>  
> -struct mnl_socket;
> -
> -struct nft_cache {
> -	bool			initialized;
> -	struct list_head	list;
> -	uint32_t		seqnum;
> -};
> -
> -struct output_ctx {
> -	unsigned int numeric;
> -	unsigned int stateless;
> -	unsigned int ip2name;
> -	unsigned int handle;
> -	unsigned int echo;
> -	FILE *output_fp;
> -};
> -
> -struct nft_ctx {
> -	struct mnl_socket	*nf_sock;
> -	char			**include_paths;
> -	unsigned int		num_include_paths;
> -	unsigned int		parser_max_errors;
> -	unsigned int		debug_mask;
> -	struct output_ctx	output;
> -	bool			check;
> -	struct nft_cache	cache;
> -	uint32_t		flags;
> -};
> +struct nft_ctx;
>  
>  enum debug_level {
>  	DEBUG_SCANNER		= 0x1,
> @@ -78,6 +51,18 @@ FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
>  void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry);
>  int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path);
>  void nft_ctx_clear_include_paths(struct nft_ctx *ctx);
> +enum numeric_level nft_ctx_output_get_numeric(struct nft_ctx *ctx);
> +void nft_ctx_output_set_numeric(struct nft_ctx *ctx, enum numeric_level level);
> +bool nft_ctx_output_get_stateless(struct nft_ctx *ctx);
> +void nft_ctx_output_set_stateless(struct nft_ctx *ctx, bool val);
> +bool nft_ctx_output_get_ip2name(struct nft_ctx *ctx);
> +void nft_ctx_output_set_ip2name(struct nft_ctx *ctx, bool val);
> +unsigned int nft_ctx_output_get_debug(struct nft_ctx *ctx);
> +void nft_ctx_output_set_debug(struct nft_ctx *ctx, unsigned int mask);
> +bool nft_ctx_output_get_handle(struct nft_ctx *ctx);
> +void nft_ctx_output_set_handle(struct nft_ctx *ctx, bool val);
> +bool nft_ctx_output_get_echo(struct nft_ctx *ctx);
> +void nft_ctx_output_set_echo(struct nft_ctx *ctx, bool val);
>  
>  void nft_ctx_flush_cache(struct nft_ctx *ctx);
>  
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 2f4275c9a0a94..925c96d1272a3 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -206,6 +206,65 @@ void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry)
>  	ctx->check = dry;
>  }
>  
> +enum numeric_level nft_ctx_output_get_numeric(struct nft_ctx *ctx)
> +{
> +	return ctx->output.numeric;
> +}
> +
> +void nft_ctx_output_set_numeric(struct nft_ctx *ctx, enum numeric_level level)
> +{
> +	ctx->output.numeric = level;
> +}
> +
> +bool nft_ctx_output_get_stateless(struct nft_ctx *ctx)
> +{
> +	return ctx->output.stateless;
> +}
> +
> +void nft_ctx_output_set_stateless(struct nft_ctx *ctx, bool val)
> +{
> +	ctx->output.stateless = val;
> +}
> +
> +bool nft_ctx_output_get_ip2name(struct nft_ctx *ctx)
> +{
> +	return ctx->output.ip2name;
> +}
> +
> +void nft_ctx_output_set_ip2name(struct nft_ctx *ctx, bool val)
> +{
> +	ctx->output.ip2name = val;
> +}
> +
> +unsigned int nft_ctx_output_get_debug(struct nft_ctx *ctx)
> +{
> +	return ctx->debug_mask;
> +}
> +void nft_ctx_output_set_debug(struct nft_ctx *ctx, unsigned int mask)
> +{
> +	ctx->debug_mask = mask;
> +}
> +
> +bool nft_ctx_output_get_handle(struct nft_ctx *ctx)
> +{
> +	return ctx->output.handle;
> +}
> +
> +void nft_ctx_output_set_handle(struct nft_ctx *ctx, bool val)
> +{
> +	ctx->output.handle = val;
> +}
> +
> +bool nft_ctx_output_get_echo(struct nft_ctx *ctx)
> +{
> +	return ctx->output.echo;
> +}
> +
> +void nft_ctx_output_set_echo(struct nft_ctx *ctx, bool val)
> +{
> +	ctx->output.echo = val;
> +}

BTW, why not just add dry_run setter here too?

I see no need for the standalone patch that comes in this series.

Thanks!
