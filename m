From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4] evaluate: reject meta nfproto outside of inet family
Date: Sun, 18 Jun 2017 11:52:37 +0200
Message-ID: <20170618095237.GA3312@salvia>
References: <20170616203411.16408-1-fw@strlen.de>
 <20170616203411.16408-5-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48292 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbdFRJwq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Jun 2017 05:52:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5B6B5E1229
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 11:52:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40D71FF6DC
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 11:52:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C856D1D9A
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 11:52:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170616203411.16408-5-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 16, 2017 at 10:34:11PM +0200, Florian Westphal wrote:
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 311c86c5abe9..4cbbd5f9b52a 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1691,6 +1691,18 @@ static int expr_evaluate_fib(struct eval_ctx *ctx, struct expr **exprp)
>  	return expr_evaluate_primary(ctx, exprp);
>  }
>  
> +static int expr_evaluate_meta(struct eval_ctx *ctx, struct expr **exprp)
> +{
> +	struct expr *meta = *exprp;
> +
> +	if (ctx->pctx.family != NFPROTO_INET &&
> +	    meta->flags & EXPR_F_PROTOCOL &&
> +	    meta->meta.key == NFT_META_NFPROTO)
> +		return expr_error(ctx->msgs, meta,
> +					  "meta nfproto is only useful in the inet family");

Nitpick: Before you push this one, you probably want to mangle this
line to get it aligned with expr_error().

Thanks!
