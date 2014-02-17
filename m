From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] netlink: meta: fix wrong type in attributes
Date: Mon, 17 Feb 2014 17:25:59 +0000
Message-ID: <20140217172559.GA9866@macbook.localnet>
References: <1392652085-8225-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51610 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbaBQR0D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:26:03 -0500
Content-Disposition: inline
In-Reply-To: <1392652085-8225-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 17, 2014 at 04:48:05PM +0100, Florian Westphal wrote:
> We segfault on 'list filter' when meta expr is used as _u8
> returns invalid register 0.

This seems to only affect the master branch. Not sure how many people
are using that and if its worth doing a new release. I'd rather merge
the next-3.14 branch and have people use that.

On a side note: there's no reason to have our releases timed after
kernel releases. At this point I'd rather go for more frequent releases
of the current code instead of backporting fixes.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/netlink_delinearize.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index 6668308..b976d86 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -346,9 +346,9 @@ static void netlink_parse_meta_sreg(struct netlink_parse_ctx *ctx,
>  	struct expr *expr;
>  
>  	expr = netlink_get_register(ctx, loc,
> -			nft_rule_expr_get_u8(nle, NFT_EXPR_META_SREG));
> +			nft_rule_expr_get_u32(nle, NFT_EXPR_META_SREG));
>  	stmt = meta_stmt_alloc(loc,
> -			       nft_rule_expr_get_u8(nle, NFT_EXPR_META_KEY),
> +			       nft_rule_expr_get_u32(nle, NFT_EXPR_META_KEY),
>  			       expr);
>  	expr_set_type(expr, stmt->meta.tmpl->dtype, stmt->meta.tmpl->byteorder);
>  
> -- 
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
