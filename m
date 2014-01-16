From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] expression: fix output of verdict maps
Date: Thu, 16 Jan 2014 17:53:37 +0100
Message-ID: <20140116165337.GA5205@localhost>
References: <1389616756-8326-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44383 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbaAPQxn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:53:43 -0500
Content-Disposition: inline
In-Reply-To: <1389616756-8326-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 13, 2014 at 01:39:16PM +0100, Pablo Neira Ayuso wrote:
> % nft list table filter
> table ip filter {
> 	...
> 	chain output {
> 		...
> 		ip saddr map { 1.1.1.1 => accept}
> 	}
> }
> 
> It displays 'map' instead of 'vmap'. Fix it by checking the mapping
> type in map_expr_print().

Spinning over the list of pending stuff in my notepad before the
release.

I think it's not so bad if we keep the 'vmap' for verdict maps. This
can just become a synonym of 'map' if we ever find the way to make it
work without ambiguity complains from the parser.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/expression.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/src/expression.c b/src/expression.c
> index 71154cc..97481d0 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -689,7 +689,11 @@ struct expr *mapping_expr_alloc(const struct location *loc,
>  static void map_expr_print(const struct expr *expr)
>  {
>  	expr_print(expr->map);
> -	printf(" map ");
> +	if (expr->mappings->ops->type == EXPR_SET_REF &&
> +	    expr->mappings->set->datatype->type == TYPE_VERDICT)
> +		printf(" vmap ");
> +	else
> +		printf(" map ");
>  	expr_print(expr->mappings);
>  }
>  
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
