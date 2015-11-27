From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] netlink_delinearize: fix use-after-free
Date: Fri, 27 Nov 2015 11:18:31 +0000
Message-ID: <20151127111831.GL4263@macbook.localdomain>
References: <1448622765-2519-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45631 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbbK0LSf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 06:18:35 -0500
Content-Disposition: inline
In-Reply-To: <1448622765-2519-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27.11, Pablo Neira Ayuso wrote:
> We have to clone the payload expression before attaching it to the lhs
> of the relational expression, this payload expression is located at the
> lhs of the binary operation that is released thereafter.

If we the other reference is released expr_get() is sufficient.

> 
> Fixes: 39f15c2 ("nft: support listing expressions that use non-byte header fields")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/netlink_delinearize.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index b119027..1ab8f43 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -1217,8 +1217,8 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
>  	} else if (binop->op == OP_AND &&
>  		   binop->left->ops->type == EXPR_PAYLOAD &&
>  		   binop->right->ops->type == EXPR_VALUE) {
> -		struct expr *payload = expr->left->left;
> -		struct expr *mask = expr->left->right;
> +		struct expr *payload = binop->left;
> +		struct expr *mask = binop->right;
>  
>  		/*
>  		 * This *might* be a payload match testing header fields that
> @@ -1266,7 +1266,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
>  			assert(expr->left->ops->type == EXPR_BINOP);
>  
>  			assert(binop->left == payload);
> -			expr->left = payload;
> +			expr->left = expr_clone(payload);
>  			expr_free(binop);
>  		}
>  	}
> -- 
> 2.1.4
> 
