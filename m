From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] evaluate: allow to use string with binary operations
Date: Tue, 14 Jan 2014 12:22:52 +0000
Message-ID: <20140114122251.GB27277@macbook.localnet>
References: <1389699030-6301-1-git-send-email-pablo@netfilter.org>
 <1389699030-6301-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33906 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaANMWz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:22:55 -0500
Content-Disposition: inline
In-Reply-To: <1389699030-6301-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 14, 2014 at 12:30:29PM +0100, Pablo Neira Ayuso wrote:
> This allows us to match ifname masks, eg.
> 
> nft add rule filter output meta oifname and eth == eth counter
> 
> I've been investigating other possibility, such as adding
> ofiname-mask, which requires several patches and transformations
> to make it look binop tree, but I still think this looks like
> a natural way (and simple, look at the patch, it's rather small)
> to represent this in the nftables.

I was just going to suggest adding a shortcut for this since its exposing
a lot of low-level detail. The transformation should be quite easy during
evaluation, could you elaborate on the problems?

> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/evaluate.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 94fee64..49f0f74 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -534,7 +534,8 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
>  		return -1;
>  	right = op->right;
>  
> -	if (expr_basetype(left)->type != TYPE_INTEGER)
> +	if (expr_basetype(left)->type != TYPE_INTEGER &&
> +	    expr_basetype(left)->type != TYPE_STRING)
>  		return expr_binary_error(ctx, left, op,
>  					 "Binary operation (%s) is undefined "
>  					 "for %s types",
> -- 
> 1.7.10.4
