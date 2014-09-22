From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 1/4] payload: generate dependency in the appropriate
 byteorder
Date: Mon, 22 Sep 2014 09:54:13 +0200
Message-ID: <20140922075413.GI4971@acer.localdomain>
References: <1411327957-19379-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35451 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaIVHyR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:54:17 -0400
Content-Disposition: inline
In-Reply-To: <1411327957-19379-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 21, 2014 at 09:32:34PM +0200, Alvaro Neira Ayuso wrote:
> If we add a dependency, the constant expression on the right
> hand side must be represented in the appropriate order.

What problem does this actually fix? Please include an example what is
broken if you want to fix something.

> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  src/payload.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/src/payload.c b/src/payload.c
> index 1eee4e0..a3bbe51 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -216,8 +216,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
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
