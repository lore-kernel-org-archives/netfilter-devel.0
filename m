Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF108C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Apr 2022 10:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbiDZKuD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Apr 2022 06:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345994AbiDZKta (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Apr 2022 06:49:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4700E3
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2022 03:45:22 -0700 (PDT)
Date:   Tue, 26 Apr 2022 12:45:19 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: fix always-true assertions
Message-ID: <YmfNP3VBYN5F2vJ3@salvia>
References: <20220426102935.14950-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220426102935.14950-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 26, 2022 at 12:29:35PM +0200, Florian Westphal wrote:
> assert(1) is a no-op, this should be assert(0). Use BUG() instead.
> Add missing CATCHALL to avoid BUG().

LGTM.

So this is fixing a bug with catch-all element, correct?

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/evaluate.c  | 2 +-
>  src/intervals.c | 5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index b5f74d2f5051..1447a4c28aee 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1499,7 +1499,7 @@ static int interval_set_eval(struct eval_ctx *ctx, struct set *set,
>  	case CMD_GET:
>  		break;
>  	default:
> -		assert(1);
> +		BUG("unhandled op %d\n", ctx->cmd->op);
>  		break;
>  	}
>  
> diff --git a/src/intervals.c b/src/intervals.c
> index a74238525d8d..85ec59eda36a 100644
> --- a/src/intervals.c
> +++ b/src/intervals.c
> @@ -20,6 +20,7 @@ static void setelem_expr_to_range(struct expr *expr)
>  	assert(expr->etype == EXPR_SET_ELEM);
>  
>  	switch (expr->key->etype) {
> +	case EXPR_SET_ELEM_CATCHALL:
>  	case EXPR_RANGE:
>  		break;
>  	case EXPR_PREFIX:
> @@ -53,7 +54,7 @@ static void setelem_expr_to_range(struct expr *expr)
>  		expr->key = key;
>  		break;
>  	default:
> -		assert(1);
> +		BUG("unhandled key type %d\n", expr->key->etype);
>  	}
>  }
>  
> @@ -185,7 +186,7 @@ static struct expr *interval_expr_key(struct expr *i)
>  		elem = i;
>  		break;
>  	default:
> -		assert(1);
> +		BUG("unhandled expression type %d\n", i->etype);
>  		return NULL;
>  	}
>  
> -- 
> 2.35.1
> 
