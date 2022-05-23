Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708EAC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 May 2022 17:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbiEWR6v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 May 2022 13:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243025AbiEWR4C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 May 2022 13:56:02 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF67DBCEA1
        for <netfilter-devel@vger.kernel.org>; Mon, 23 May 2022 10:43:01 -0700 (PDT)
Date:   Mon, 23 May 2022 19:42:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [nft PATCH v4 13/32] evaluate: support shifts larger than the
 width of the left operand
Message-ID: <YovHkOThO0KYRGda@salvia>
References: <20220404121410.188509-1-jeremy@azazel.net>
 <20220404121410.188509-14-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220404121410.188509-14-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I just tested patches 9 and 14 alone, and meta mark set ip dscp ...
now works fine.

So most of the work from 7 to 14 is to allow to use shifts.

So 8, 10, 11, 12 and 13 enable the use of shifts is meta and ct
statements?

The new _NBIT field is there to store the original length for the
payload field (6 bits, for the ip dscp case)?

On Mon, Apr 04, 2022 at 01:13:51PM +0100, Jeremy Sowden wrote:
> If we want to left-shift a value of narrower type and assign the result
> to a variable of a wider type, we are constrained to only shifting up to
> the width of the narrower type.  Thus:
> 
>   add rule t c meta mark set ip dscp << 2
> 
> works, but:
> 
>   add rule t c meta mark set ip dscp << 8
> 
> does not, even though the lvalue is large enough to accommodate the
> result.
> 
> Evaluation of the left-hand operand of a shift overwrites the `len`
> field of the evaluation context when `expr_evaluate_primary` is called.
> Instead, preserve the `len` value of the evaluation context for shifts,
> and support shifts up to that size, even if they are larger than the
> length of the left operand.
> 
> Update netlink_delinearize.c to handle the case where the length of a
> shift expression does not match that of its left-hand operand.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  src/evaluate.c            | 23 ++++++++++++++---------
>  src/netlink_delinearize.c |  4 ++--
>  2 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index be493f85010c..ee4da5a2b889 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1116,14 +1116,18 @@ static int constant_binop_simplify(struct eval_ctx *ctx, struct expr **expr)
>  static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
>  {
>  	struct expr *op = *expr, *left = op->left, *right = op->right;
> +	unsigned int shift = mpz_get_uint32(right->value);
> +	unsigned int op_len = left->len;
>  
> -	if (mpz_get_uint32(right->value) >= left->len)
> -		return expr_binary_error(ctx->msgs, right, left,
> -					 "%s shift of %u bits is undefined "
> -					 "for type of %u bits width",
> -					 op->op == OP_LSHIFT ? "Left" : "Right",
> -					 mpz_get_uint32(right->value),
> -					 left->len);
> +	if (shift >= op_len) {
> +		if (shift >= ctx->ectx.len)
> +			return expr_binary_error(ctx->msgs, right, left,
> +						 "%s shift of %u bits is undefined for type of %u bits width",
> +						 op->op == OP_LSHIFT ? "Left" : "Right",
> +						 shift,
> +						 op_len);
> +		op_len = ctx->ectx.len;
> +	}
>  
>  	/* Both sides need to be in host byte order */
>  	if (byteorder_conversion(ctx, &op->left, BYTEORDER_HOST_ENDIAN) < 0)
> @@ -1134,7 +1138,7 @@ static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
>  
>  	op->dtype     = &integer_type;
>  	op->byteorder = BYTEORDER_HOST_ENDIAN;
> -	op->len       = left->len;
> +	op->len	      = op_len;
>  
>  	if (expr_is_constant(left))
>  		return constant_binop_simplify(ctx, expr);
> @@ -1167,6 +1171,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
>  {
>  	struct expr *op = *expr, *left, *right;
>  	const char *sym = expr_op_symbols[op->op];
> +	unsigned int ectx_len = ctx->ectx.len;
>  
>  	if (expr_evaluate(ctx, &op->left) < 0)
>  		return -1;
> @@ -1174,7 +1179,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
>  
>  	if (op->op == OP_LSHIFT || op->op == OP_RSHIFT)
>  		__expr_set_context(&ctx->ectx, &integer_type,
> -				   left->byteorder, ctx->ectx.len, 0);
> +				   left->byteorder, ectx_len, 0);
>  	if (expr_evaluate(ctx, &op->right) < 0)
>  		return -1;
>  	right = op->right;
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index cf5359bf269e..9f6fdee3e92d 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -486,7 +486,7 @@ static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
>  		mpz_ior(m, m, o);
>  	}
>  
> -	if (left->len > 0 && mpz_scan0(m, 0) == left->len) {
> +	if (left->len > 0 && mpz_scan0(m, 0) >= left->len) {
>  		/* mask encompasses the entire value */
>  		expr_free(mask);
>  	} else {
> @@ -536,7 +536,7 @@ static struct expr *netlink_parse_bitwise_shift(struct netlink_parse_ctx *ctx,
>  	right->byteorder = BYTEORDER_HOST_ENDIAN;
>  
>  	expr = binop_expr_alloc(loc, op, left, right);
> -	expr->len = left->len;
> +	expr->len = nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_LEN) * BITS_PER_BYTE;
>  
>  	return expr;
>  }
> -- 
> 2.35.1
> 
