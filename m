From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/2] src: fix byteorder conversions
Date: Fri, 18 Jul 2014 13:34:45 +0200
Message-ID: <20140718113445.GA5279@salvia>
References: <1405617860-13494-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55201 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbaGRLej (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:34:39 -0400
Content-Disposition: inline
In-Reply-To: <1405617860-13494-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Alvaro,

Several comments.

On Thu, Jul 17, 2014 at 07:24:20PM +0200, Alvaro Neira Ayuso wrote:
> Currently the byteorder conversion happens in the parser,
> the evaluation and the code generation steps. This is a problem
> because the expression which are already in big endian byteorder
> are converted again.
> 
> With this patch, we don't change byteorder in the code generation
> step anymore because we assume that all expressions are in the
> appropriate byteorder. This patch solves rules like:
> 
> nft add rule bridge filter input ether type ip
> 
> With this rule we create a expression like:
> 
> [ payload load 2b @ link header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x00000800 ]
> 
> With this patch, we have a expresion with the correct conversion:
> 
> [ payload load 2b @ link header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
> 
> This is also a problem in the delinearize step because the expression
> are already converted to the correctly byteorder and we change it again.
> 
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  include/netlink.h         |    3 +--
>  src/datatype.c            |    2 +-
>  src/gmputil.c             |    2 +-
>  src/netlink.c             |   11 +++++++----
>  src/netlink_delinearize.c |    2 +-
>  src/netlink_linearize.c   |   10 +++++-----
>  src/payload.c             |    3 +--
>  7 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/include/netlink.h b/include/netlink.h
> index 4ef7365..1e82fce 100644
> --- a/include/netlink.h
> +++ b/include/netlink.h
> @@ -55,8 +55,7 @@ struct nft_data_delinearize {
>  
>  extern void netlink_gen_data(const struct expr *expr,
>  			     struct nft_data_linearize *data);
> -extern void netlink_gen_raw_data(const mpz_t value, enum byteorder byteorder,
> -				 unsigned int len,
> +extern void netlink_gen_raw_data(const mpz_t value, unsigned int len,
>  				 struct nft_data_linearize *data);
>  
>  extern struct expr *netlink_alloc_value(const struct location *loc,
> diff --git a/src/datatype.c b/src/datatype.c
> index 55af227..0a3aa41 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -545,7 +545,7 @@ static struct error_record *inet_service_type_parse(const struct expr *sym,
>  		if (errno == ERANGE || i > UINT16_MAX)
>  			return error(&sym->location, "Service out of range");
>  
> -		port = htons(i);
> +		port = i;

I see. This is converted to big endian when allocating the constant
expression just several lines after this (not showing up in the
patch), this seems correct to me.

>  	} else {
>  		err = getaddrinfo(NULL, sym->identifier, NULL, &ai);
>  		if (err != 0)
> diff --git a/src/gmputil.c b/src/gmputil.c
> index cb46445..2e4438a 100644
> --- a/src/gmputil.c
> +++ b/src/gmputil.c
> @@ -127,11 +127,11 @@ void mpz_import_data(mpz_t rop, const void *data,
>  
>  	switch (byteorder) {
>  	case BYTEORDER_BIG_ENDIAN:
> -	default:
>  		order  = MPZ_MSWF;
>  		endian = MPZ_BIG_ENDIAN;
>  		break;

Please, add a comment here, something like:

        /* We can import data from the parser, the datatype is invalid there.
         * Handle invalid byteorder as host endian, we'll get the real datatype
         * in the evaluation step, then it will be converted to big endian if
         * needed.
         */

>  	case BYTEORDER_HOST_ENDIAN:
> +	default:
>  		order  = MPZ_HWO;
>  		endian = MPZ_HOST_ENDIAN;
>  		break;
> diff --git a/src/netlink.c b/src/netlink.c
> index 987dd63..0547fa5 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -234,11 +234,14 @@ static struct nft_set_elem *alloc_nft_setelem(const struct expr *expr)
>  	return nlse;
>  }
>  
> -void netlink_gen_raw_data(const mpz_t value, enum byteorder byteorder,
> -			  unsigned int len, struct nft_data_linearize *data)
> +void netlink_gen_raw_data(const mpz_t value, unsigned int len,
> +			  struct nft_data_linearize *data)
>  {
>  	assert(len > 0);
> -	mpz_export_data(data->value, value, byteorder, len);
> +	/* Here, we can suppose that all the values has been converted with the
> +	 * byteorder and all are in HOST_ENDIAN
> +	 */

I'd suggest a comment like:

        /* After the evaluation step we assume that the values are always in
         * the appropriate byteorder. Use BYTEORDER_HOST_ENDIAN here not to
         * alter endianness.
         */

> +	mpz_export_data(data->value, value, BYTEORDER_HOST_ENDIAN, len);
>  	data->len = len;
>  }
>  
> @@ -272,7 +275,7 @@ static void netlink_gen_constant_data(const struct expr *expr,
>  				      struct nft_data_linearize *data)
>  {
>  	assert(expr->ops->type == EXPR_VALUE);
> -	netlink_gen_raw_data(expr->value, expr->byteorder,
> +	netlink_gen_raw_data(expr->value,
>  			     div_round_up(expr->len, BITS_PER_BYTE), data);
>  }
>  
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index 5c6ca80..ad74cdb 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -642,7 +642,7 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
>  		list_for_each_entry(left, &list, list) {
>  			tmp = constant_expr_splice(right, left->len);
>  			expr_set_type(tmp, left->dtype, left->byteorder);

This needs to be clarified with a comment as well. I guess that it
can be somthing like:

                        /* We have to convert the values that we obtained from
                         * the kernel to host byteorder. Therefore, we assume
                         * that the values are in host endian after the
                         * delinearization.
                         */

> -			if (tmp->byteorder == BYTEORDER_HOST_ENDIAN)
> +			if (tmp->byteorder == BYTEORDER_BIG_ENDIAN)
>  				mpz_switch_byteorder(tmp->value, tmp->len / BITS_PER_BYTE);
>  
>  			nexpr = relational_expr_alloc(&expr->location, expr->op,
> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> index 5c1b46d..8788813 100644
> --- a/src/netlink_linearize.c
> +++ b/src/netlink_linearize.c
> @@ -206,8 +206,8 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
>  
>  		mpz_init(mask);
>  		mpz_prefixmask(mask, expr->right->len, expr->right->prefix_len);
> -		netlink_gen_raw_data(mask, expr->right->byteorder,
> -				     expr->right->len / BITS_PER_BYTE, &nld);
> +		netlink_gen_raw_data(mask, expr->right->len / BITS_PER_BYTE,
> +				     &nld);
>  		mpz_clear(mask);
>  
>  		zero.len = nld.len;
> @@ -315,7 +315,7 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
>  
>  	mpz_init_set_ui(zero, 0);
>  
> -	netlink_gen_raw_data(zero, expr->right->byteorder, len, &nld);
> +	netlink_gen_raw_data(zero, len, &nld);
>  	netlink_gen_data(expr->right, &nld2);
>  
>  	nle = alloc_nft_expr("bitwise");
> @@ -423,9 +423,9 @@ static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
>  	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_DREG, dreg);
>  	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_LEN, len);
>  
> -	netlink_gen_raw_data(mask, expr->byteorder, len, &nld);
> +	netlink_gen_raw_data(mask, len, &nld);
>  	nft_rule_expr_set(nle, NFT_EXPR_BITWISE_MASK, nld.value, nld.len);
> -	netlink_gen_raw_data(xor, expr->byteorder, len, &nld);
> +	netlink_gen_raw_data(xor, len, &nld);
>  	nft_rule_expr_set(nle, NFT_EXPR_BITWISE_XOR, nld.value, nld.len);
>  
>  	mpz_clear(tmp);
> diff --git a/src/payload.c b/src/payload.c
> index a1785a5..432ce44 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -208,8 +208,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
>  		left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
>
>  	right = constant_expr_alloc(&expr->location, tmpl->dtype,
> -				    BYTEORDER_HOST_ENDIAN,
> -				    tmpl->len,
> +				    tmpl->dtype->byteorder, tmpl->len,
>  				    constant_data_ptr(protocol, tmpl->len));
>  
>  	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
