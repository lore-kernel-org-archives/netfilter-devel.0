Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C411EB64DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jul 2023 10:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbjGNKHg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jul 2023 06:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbjGNKHf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jul 2023 06:07:35 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0C0198A
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jul 2023 03:07:34 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qKFi0-0008G6-Mf; Fri, 14 Jul 2023 12:07:32 +0200
Date:   Fri, 14 Jul 2023 12:07:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft v2 PATCH 2/3] nftables: add input flag NFT_CTX_INPUT_NO_DNS
 to avoid blocking getaddrinfo()
Message-ID: <ZLEeZF3voEjlT12h@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <ZKxG23yJzlRRPpsO@calendula>
 <20230714084943.1080757-1-thaller@redhat.com>
 <20230714084943.1080757-2-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230714084943.1080757-2-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 14, 2023 at 10:48:52AM +0200, Thomas Haller wrote:
> getaddrinfo() blocks while trying to resolve the name. Blocking the
> caller of the library is in many cases undesirable. Also, while
> reconfiguring the firewall, it's not clear that resolving names via
> the network works or makes sense.
> 
> Add a new input flag NFT_CTX_INPUT_NO_DNS to opt-out from getaddrinfo()
> and only accept plain IP addresses.
> 
> We could also use AI_NUMERICHOST with getaddrinfo() instead of
> inet_pton(). But it seems we can do a better job of generating an error
> message, when we try to parse via inet_pton(). Then our error message
> can clearly indicate that the string is not a valid IP address.
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  doc/libnftables.adoc           | 10 ++++-
>  include/datatype.h             |  1 +
>  include/nftables/libnftables.h |  4 ++
>  src/datatype.c                 | 68 ++++++++++++++++++++--------------
>  src/evaluate.c                 | 16 +++++++-
>  5 files changed, 68 insertions(+), 31 deletions(-)
> 
> diff --git a/doc/libnftables.adoc b/doc/libnftables.adoc
> index 96a580469ee0..77f3a0fd5659 100644
> --- a/doc/libnftables.adoc
> +++ b/doc/libnftables.adoc
> @@ -84,7 +84,15 @@ The *nft_ctx_set_dry_run*() function sets the dry-run setting in 'ctx' to the va
>  === nft_ctx_input_get_flags() and nft_ctx_input_set_flags()
>  The flags setting controls the input format.
>  
> -Currently not flags are implemented.
> +----
> +enum {
> +        NFT_CTX_INPUT_NO_DNS = (1 << 0),
> +};
> +----
> +
> +NFT_CTX_INPUT_NO_DNS::
> +	Avoid resolving IP addresses with blocking getaddrinfo(). In that case,
> +	only plain IP addresses are accepted.
>  
>  The *nft_ctx_input_get_flags*() function returns the input flags setting's value in 'ctx'.
>  
> diff --git a/include/datatype.h b/include/datatype.h
> index 4b59790b67f9..be5c6d1b4011 100644
> --- a/include/datatype.h
> +++ b/include/datatype.h
> @@ -182,6 +182,7 @@ struct datatype *dtype_clone(const struct datatype *orig_dtype);
>  
>  struct parse_ctx {
>  	struct symbol_tables	*tbl;
> +	const struct input_ctx	*input;
>  };
>  
>  extern struct error_record *symbol_parse(struct parse_ctx *ctx,
> diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
> index 7fb621be1f12..2f5f079efff0 100644
> --- a/include/nftables/libnftables.h
> +++ b/include/nftables/libnftables.h
> @@ -48,6 +48,10 @@ enum nft_optimize_flags {
>  uint32_t nft_ctx_get_optimize(struct nft_ctx *ctx);
>  void nft_ctx_set_optimize(struct nft_ctx *ctx, uint32_t flags);
>  
> +enum {
> +	NFT_CTX_INPUT_NO_DNS		= (1 << 0),
> +};
> +
>  unsigned int nft_ctx_input_get_flags(struct nft_ctx *ctx);
>  void nft_ctx_input_set_flags(struct nft_ctx *ctx, unsigned int flags);
>  
> diff --git a/src/datatype.c b/src/datatype.c
> index da802a18bccd..8629a38da56a 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -599,27 +599,33 @@ static struct error_record *ipaddr_type_parse(struct parse_ctx *ctx,
>  					      const struct expr *sym,
>  					      struct expr **res)
>  {
> -	struct addrinfo *ai, hints = { .ai_family = AF_INET,
> -				       .ai_socktype = SOCK_DGRAM};
> -	struct in_addr *addr;
> -	int err;
> +	struct in_addr addr;
>  
> -	err = getaddrinfo(sym->identifier, NULL, &hints, &ai);
> -	if (err != 0)
> -		return error(&sym->location, "Could not resolve hostname: %s",
> -			     gai_strerror(err));
> +	if (ctx->input->flags & NFT_CTX_INPUT_NO_DNS) {
> +		if (inet_pton(AF_INET, sym->identifier, &addr) != 1)
> +			return error(&sym->location, "Invalid IPv4 address");
> +	} else {
> +		struct addrinfo *ai, hints = { .ai_family = AF_INET,
> +					       .ai_socktype = SOCK_DGRAM};
> +		int err;
>  
> -	if (ai->ai_next != NULL) {
> +		err = getaddrinfo(sym->identifier, NULL, &hints, &ai);
> +		if (err != 0)
> +			return error(&sym->location, "Could not resolve hostname: %s",
> +				     gai_strerror(err));
> +
> +		if (ai->ai_next != NULL) {
> +			freeaddrinfo(ai);
> +			return error(&sym->location,
> +				     "Hostname resolves to multiple addresses");
> +		}
> +		addr = ((struct sockaddr_in *)ai->ai_addr)->sin_addr;
>  		freeaddrinfo(ai);
> -		return error(&sym->location,
> -			     "Hostname resolves to multiple addresses");
>  	}
>  
> -	addr = &((struct sockaddr_in *)ai->ai_addr)->sin_addr;
>  	*res = constant_expr_alloc(&sym->location, &ipaddr_type,
>  				   BYTEORDER_BIG_ENDIAN,
> -				   sizeof(*addr) * BITS_PER_BYTE, addr);
> -	freeaddrinfo(ai);
> +				   sizeof(addr) * BITS_PER_BYTE, &addr);
>  	return NULL;
>  }

Maybe introduce a common

| struct error_record *do_getaddrinfo(const char *buf, int family, struct in_addr *out);

for both *_type_parse() to call?

[...]
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 33e4ac93e89a..a904714acd48 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -46,6 +46,14 @@ struct proto_ctx *eval_proto_ctx(struct eval_ctx *ctx)
>  	return &ctx->_pctx[idx];
>  }
>  
> +static void parse_ctx_init(struct parse_ctx *parse_ctx, const struct eval_ctx *ctx)
> +{
> +	*parse_ctx = (struct parse_ctx) {
> +		.tbl	= &ctx->nft->output.tbl,
> +		.input	= &ctx->nft->input,
> +	};
> +}

This is interesting coding style, but looks more complicated than

| parse_ctx->tbl	= &ctx->nft->output.tbl;
| parse_ctx->input	= &ctx->nft->input;

though I would just keep the extra assignment inline like so:

> -	struct parse_ctx parse_ctx = { .tbl = &ctx->nft->output.tbl, };
> +	struct parse_ctx parse_ctx = {
> +		.tbl	= &ctx->nft->output.tbl,
> +		.input	= &ctx->nft->input,
> +	};

Cheers, Phil
