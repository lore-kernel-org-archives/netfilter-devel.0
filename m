From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] expr: do not suppress OP_EQ when RHS is bitmask type
Date: Fri, 4 Apr 2014 10:17:23 +0200
Message-ID: <20140404081723.GA3574@localhost>
References: <1395094118-32580-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59568 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbaDDIRd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 04:17:33 -0400
Content-Disposition: inline
In-Reply-To: <1395094118-32580-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 17, 2014 at 11:08:38PM +0100, Florian Westphal wrote:
> bitmask types default to flagcmp now, thus do not suppress OP_EQ.  Else,
> 
> rule filter output tcp flags syn
> rule filter output tcp flags == syn
> 
> are both displayed as 'flags syn'.

I believe that in other selectors:

        selector == value
        selector value

are equivalent.

I think it's not just that we have to fix the printing, but make it
consistent.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/expression.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/src/expression.c b/src/expression.c
> index 1313925..fa14d99 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -514,13 +514,21 @@ static void binop_arg_print(const struct expr *op, const struct expr *arg)
>  		printf(")");
>  }
>  
> +static bool must_print_eq_op(const struct expr *expr)
> +{
> +	if (expr->right->dtype->basetype != NULL &&
> +	    expr->right->dtype->basetype->type == TYPE_BITMASK)
> +		return true;
> +
> +	return expr->left->ops->type == EXPR_BINOP;
> +}
> +
>  static void binop_expr_print(const struct expr *expr)
>  {
>  	binop_arg_print(expr, expr->left);
>  
>  	if (expr_op_symbols[expr->op] &&
> -	    (expr->op != OP_EQ ||
> -	     expr->left->ops->type == EXPR_BINOP))
> +	    (expr->op != OP_EQ || must_print_eq_op(expr)))
>  		printf(" %s ", expr_op_symbols[expr->op]);
>  	else
>  		printf(" ");
> -- 
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
