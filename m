From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] src: perform sub-byte length matching from the
 evaluation step
Date: Sat, 28 Nov 2015 13:20:23 +0000
Message-ID: <20151128132023.GC17106@macbook.localdomain>
References: <1448715052-5705-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="1yeeQ81UyVL57Vl7"
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58428 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbbK1NU2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Nov 2015 08:20:28 -0500
Content-Disposition: inline
In-Reply-To: <1448715052-5705-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 28.11, Pablo Neira Ayuso wrote:
> This patch reworks c3f0501 ("src: netlink_linearize: handle sub-byte lengths")
> to perform the required sub-byte transformations from the evaluation step.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Patrick, @Florian: It seems we're falling into subbyte handling
> problems from different fronts, I just hit this while further testing of
> my dscp patch.
> 
> I'm sending this because I think it's sort of ready so we avoid overlap.
> 
> I'm working on a follow up patch (almost done here) to cover another
> corner case that we don't handle correctly, which is basically this:
> 
>     4 bits    6 bits
>    +-+-+-+-+-+-+-+-+-+-+
>    | vers  |   dscp    |
>    +-+-+-+-+-+-+-+-+-+-+
>                    ^
>                    |
>                    byte boundary
> 
> To match dscp in IPv6, we have to fetch 2 bytes from offset 0 via
> payload expression and the bitmask must be 00ffc000.
> 
> I got the code generation correctly, but I'm adjusting the
> payload_expr_trim() function now.
> 
> So I'm basically working on the netlink code generation part.

Some comments below.

> I'm not working on the protocol definition problem:
> http://marc.info/?l=netfilter-devel&m=144862242521205&w=2, but I also
> need this gets fixed. Let me know if you will be looking into this, just
> to avoid overlap.

It kinds of depends on the sub-byte handling, so we should get this done
first. 

> -static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **expr)
> +static void expr_evaluate_payload_subbyte(struct eval_ctx *ctx,
> +					  struct expr **exprp)
>  {
> -	if (__expr_evaluate_payload(ctx, *expr) < 0)
> +	struct expr *expr = *exprp, *and, *mask;
> +	unsigned int shift, masklen;
> +	mpz_t bitmask;
> +
> +	shift = expr->payload.offset % BITS_PER_BYTE;
> +	masklen = expr->len + shift;
> +
> +	if (masklen > 128)
> +		BUG("expr mask length is %u (len %u, shift %u)\n",
> +		    masklen, expr->len, shift);
> +
> +	mpz_init2(bitmask, masklen);
> +	mpz_bitmask(bitmask, expr->len);
> +	if (shift)
> +		mpz_lshift_ui(bitmask, shift);
> +
> +	mask = constant_expr_alloc(&expr->location, expr_basetype(expr),
> +				   BYTEORDER_HOST_ENDIAN, masklen, NULL);
> +	mpz_set(mask->value, bitmask);
> +
> +	and = binop_expr_alloc(&expr->location, OP_AND, expr, mask);
> +	and->dtype	= expr->dtype;
> +	and->byteorder	= expr->byteorder;
> +	and->len	= masklen;
> +
> +	*exprp = and;
> +
> +	ctx->ectx.shift = shift;
> +}
> +
> +static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
> +{
> +	struct expr *expr = *exprp;
> +
> +	if (__expr_evaluate_payload(ctx, expr) < 0)
>  		return -1;
>  
> -	return expr_evaluate_primary(ctx, expr);
> +	if (expr->len % BITS_PER_BYTE)
> +		expr_evaluate_payload_subbyte(ctx, exprp);
> +
> +	return expr_evaluate_primary(ctx, &expr);
>  }

>From my previous work on this I still have this patch, which allows you to
generate an rshift to get the payload to offset 0, then transfers it to the
LHS during binop simplification if its used in a relational expression.

The upside is that is generic and reuses what we already have.

The load masking should IMO not be done in eval but netlink_linearize. We
don't even know yet if the payload expression is actually used in a relational
expression or f.i. in a statement, where handling needs to be different.

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rshift.diff"

commit 6f2b9db5d2f2e48e80cdb31a9d792871b75a7f94
Author: Patrick McHardy <kaber@trash.net>
Date:   Sat Jun 13 14:51:20 2015 +0200

    evaluate: transfer right shifts to constant side
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/src/evaluate.c b/src/evaluate.c
index b64c231..22d5601 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -463,6 +463,7 @@ static int constant_binop_simplify(struct eval_ctx *ctx, struct expr **expr)
 		break;
 	case OP_LSHIFT:
 		assert(left->byteorder == BYTEORDER_HOST_ENDIAN);
+		mpz_set(val, left->value);
 		mpz_lshift_ui(val, mpz_get_uint32(right->value));
 		mpz_and(val, val, mask);
 		break;
@@ -833,6 +834,8 @@ static int binop_can_transfer(struct eval_ctx *ctx,
 			return expr_binary_error(ctx->msgs, right, left,
 						 "Comparison is always false");
 		return 1;
+	case OP_RSHIFT:
+		return 1;
 	case OP_XOR:
 		return 1;
 	default:
@@ -850,6 +853,10 @@ static int binop_transfer_one(struct eval_ctx *ctx,
 		(*right) = binop_expr_alloc(&(*right)->location, OP_RSHIFT,
 					    *right, expr_get(left->right));
 		break;
+	case OP_RSHIFT:
+		(*right) = binop_expr_alloc(&(*right)->location, OP_LSHIFT,
+					    *right, expr_get(left->right));
+		break;
 	case OP_XOR:
 		(*right) = binop_expr_alloc(&(*right)->location, OP_XOR,
 					    *right, expr_get(left->right));
@@ -864,6 +871,7 @@ static int binop_transfer_one(struct eval_ctx *ctx,
 static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *left = (*expr)->left, *i, *next;
+	unsigned int shift;
 	int err;
 
 	if (left->ops->type != EXPR_BINOP)
@@ -895,10 +903,24 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 		return 0;
 	}
 
-	left = expr_get((*expr)->left->left);
-	left->dtype = (*expr)->left->dtype;
-	expr_free((*expr)->left);
-	(*expr)->left = left;
+	switch (left->op) {
+	case OP_RSHIFT:
+		/* Mask out the bits the shift would have masked out */
+		shift = mpz_get_uint8(left->right->value);
+		mpz_bitmask(left->right->value, left->left->len);
+		mpz_lshift_ui(left->right->value, shift);
+		left->op = OP_AND;
+		break;
+	case OP_LSHIFT:
+	case OP_XOR:
+		left = expr_get((*expr)->left->left);
+		left->dtype = (*expr)->left->dtype;
+		expr_free((*expr)->left);
+		(*expr)->left = left;
+		break;
+	default:
+		BUG("invalid binop operation %u", left->op);
+	}
 	return 0;
 }
 

--1yeeQ81UyVL57Vl7--
