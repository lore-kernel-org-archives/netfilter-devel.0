Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500ACC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 May 2022 17:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiEWRDv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 May 2022 13:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbiEWRDu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 May 2022 13:03:50 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26E0A11C02
        for <netfilter-devel@vger.kernel.org>; Mon, 23 May 2022 10:03:45 -0700 (PDT)
Date:   Mon, 23 May 2022 19:03:42 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [nft PATCH v4 08/32] netlink: send bit-length of bitwise binops
 to kernel
Message-ID: <You+bsAw2mbUuE6S@salvia>
References: <20220404121410.188509-1-jeremy@azazel.net>
 <20220404121410.188509-9-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220404121410.188509-9-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm sorry for taking time to get back to this, I have questions.

On Mon, Apr 04, 2022 at 01:13:46PM +0100, Jeremy Sowden wrote:
> Some bitwise operations are generated when munging paylod expressions.
> During delinearization, we attempt to eliminate these operations.
> However, this is done before deducing the byte-order or the correct
> length in bits of the operands, which means that we don't always handle
> multi-byte host-endian operations correctly.  Therefore, pass the
> bit-length of these expressions to the kernel in order to have it
> available during delinearization.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  src/netlink_delinearize.c | 14 ++++++++++++--
>  src/netlink_linearize.c   |  2 ++
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index a1b00dee209a..733977bc526d 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -451,20 +451,28 @@ static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
>  					       const struct nftnl_expr *nle,
>  					       enum nft_registers sreg,
>  					       struct expr *left)
> -
>  {
>  	struct nft_data_delinearize nld;
>  	struct expr *expr, *mask, *xor, *or;
> +	unsigned int nbits;
>  	mpz_t m, x, o;
>  
>  	expr = left;
>  
> +	nbits = nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_NBITS);
> +	if (nbits > 0)
> +		expr->len = nbits;

So NFTNL_EXPR_BITWISE_NBITS is signalling that this is an implicit
bitwise that has been generated to operate with a payload header bitfield?

Could you provide an example expression tree to show how this
simplifies delinearization?

> +
>  	nld.value = nftnl_expr_get(nle, NFTNL_EXPR_BITWISE_MASK, &nld.len);
>  	mask = netlink_alloc_value(loc, &nld);
> +	if (nbits > 0)
> +		mpz_switch_byteorder(mask->value, div_round_up(nbits, BITS_PER_BYTE));

What is the byteorder expected for the mask before this switch
operation?

>  	mpz_init_set(m, mask->value);
>  
>  	nld.value = nftnl_expr_get(nle, NFTNL_EXPR_BITWISE_XOR, &nld.len);
> -	xor  = netlink_alloc_value(loc, &nld);
> +	xor = netlink_alloc_value(loc, &nld);
> +	if (nbits > 0)
> +		mpz_switch_byteorder(xor->value, div_round_up(nbits, BITS_PER_BYTE));
>  	mpz_init_set(x, xor->value);
>  
>  	mpz_init_set_ui(o, 0);
> @@ -500,6 +508,8 @@ static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
>  
>  		or = netlink_alloc_value(loc, &nld);
>  		mpz_set(or->value, o);
> +		if (nbits > 0)
> +			mpz_switch_byteorder(or->value, div_round_up(nbits, BITS_PER_BYTE));
>  		expr = binop_expr_alloc(loc, OP_OR, expr, or);
>  		expr->len = left->len;
>  	}
> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> index c8bbcb7452b0..4793f3853bee 100644
> --- a/src/netlink_linearize.c
> +++ b/src/netlink_linearize.c
> @@ -677,6 +677,8 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
>  	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, dreg);
>  	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_BOOL);
>  	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
> +	if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
> +		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_NBITS, expr->len);

Why is this only required for host endian expressions?

>  	netlink_gen_raw_data(mask, expr->byteorder, len, &nld);
>  	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, nld.value, nld.len);
> -- 
> 2.35.1
> 
