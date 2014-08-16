From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 2/5] payload: generate dependency in the correct
 byteorder
Date: Sat, 16 Aug 2014 15:19:36 +0100
Message-ID: <20140816141936.GC9697@acer.localdomain>
References: <1407168011-6424-1-git-send-email-alvaroneay@gmail.com>
 <1407168011-6424-3-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64226 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaHPOTk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2014 10:19:40 -0400
Content-Disposition: inline
In-Reply-To: <1407168011-6424-3-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:00:08PM +0200, Alvaro Neira Ayuso wrote:
> Currently, we suppose that all the dependency are in host endian. The problem
> is if we try to add a dependency with big endian byteorder, we create
> this dependency wrong. For example, if we add a ether type dependency in bridge,
> we must use big endian byteorder and we use host endian and we create wrong the
> payload.
> 
> Now, we are going to create the dependency taking account the byteorder.

This seems correct to me.

> 
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  src/payload.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/src/payload.c b/src/payload.c
> index be3d610..8b10a79 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -213,8 +213,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
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
