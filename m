From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] src: store expression as set key instead of data
 type
Date: Wed, 27 Sep 2017 14:58:38 +0200
Message-ID: <20170927125838.GA26528@salvia>
References: <20170919124954.26852-1-fw@strlen.de>
 <20170919124954.26852-3-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:36017 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752823AbdI0M6p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 08:58:45 -0400
Content-Disposition: inline
In-Reply-To: <20170919124954.26852-3-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 19, 2017 at 02:49:54PM +0200, Florian Westphal wrote:
> @@ -1023,7 +1036,8 @@ static int list_member_evaluate(struct eval_ctx *ctx, struct expr **expr)
>  	return err;
>  }
>  
> -static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
> +static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr,
> +				bool evaluate)

Hm, why this boolean as parameter?

>  {
>  	const struct datatype *dtype = ctx->ectx.dtype, *tmp;
>  	uint32_t type = dtype ? dtype->type : 0, ntype = 0;
> @@ -1044,7 +1058,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
>  			tmp = concat_subtype_lookup(type, --off);
>  		expr_set_context(&ctx->ectx, tmp, tmp->size);
>  
> -		if (list_member_evaluate(ctx, &i) < 0)
> +		if (evaluate && list_member_evaluate(ctx, &i) < 0)
>  			return -1;
>  		flags &= i->flags;
>  
