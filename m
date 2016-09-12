From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH nft] src: fix compile error due to _UNTIL renamed to
 _MODULUS in libnftnl
Date: Mon, 12 Sep 2016 11:49:20 +0200
Message-ID: <20160912094919.GA5013@sonyv>
References: <1473582957-52218-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36094 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756905AbcILJtY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 05:49:24 -0400
Received: by mail-wm0-f68.google.com with SMTP id z194so440493wmd.3
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 02:49:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1473582957-52218-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 11, 2016 at 04:35:57PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> In the latest libnftnl, NFTNL_EXPR_NG_UNTIL was renamed to
> NFTNL_EXPR_NG_MODULUS, so compile error happened:
>   netlink_linearize.c: In function ‘netlink_gen_numgen’:
>   netlink_linearize.c:184:26: error: ‘NFTNL_EXPR_NG_UNTIL’ undeclared
>   (first use in this function)
> 

In order to complete the renaming, NFTA_NG_UNTIL should be changed to
NFTA_NG_MODULUS as well.

> Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
> ---
>  src/netlink_delinearize.c | 2 +-
>  src/netlink_linearize.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index 05edb01..6bb27b6 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -554,7 +554,7 @@ static void netlink_parse_numgen(struct netlink_parse_ctx *ctx,
>  	struct expr *expr;
>  
>  	type  = nftnl_expr_get_u32(nle, NFTNL_EXPR_NG_TYPE);
> -	until = nftnl_expr_get_u32(nle, NFTNL_EXPR_NG_UNTIL);
> +	until = nftnl_expr_get_u32(nle, NFTNL_EXPR_NG_MODULUS);
>  
>  	expr = numgen_expr_alloc(loc, type, until);
>  	dreg = netlink_parse_register(nle, NFTNL_EXPR_NG_DREG);
> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> index 5204154..558deb2 100644
> --- a/src/netlink_linearize.c
> +++ b/src/netlink_linearize.c
> @@ -181,7 +181,7 @@ static void netlink_gen_numgen(struct netlink_linearize_ctx *ctx,
>  	nle = alloc_nft_expr("numgen");
>  	netlink_put_register(nle, NFTNL_EXPR_NG_DREG, dreg);
>  	netlink_put_register(nle, NFTNL_EXPR_NG_TYPE, expr->numgen.type);
> -	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_UNTIL, expr->numgen.mod);
> +	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_MODULUS, expr->numgen.mod);
>  	nftnl_rule_add_expr(ctx->nlr, nle);
>  }
>  
> -- 
> 2.5.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
