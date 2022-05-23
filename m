Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EB8C43217
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 May 2022 17:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241754AbiEWRo3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 May 2022 13:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244322AbiEWRne (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 May 2022 13:43:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EC4E9D4F5
        for <netfilter-devel@vger.kernel.org>; Mon, 23 May 2022 10:35:18 -0700 (PDT)
Date:   Mon, 23 May 2022 19:19:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [nft PATCH v4 10/32] netlink_delinearize: correct type and
 byte-order of shifts
Message-ID: <YovCEsqTL9wcuv55@salvia>
References: <20220404121410.188509-1-jeremy@azazel.net>
 <20220404121410.188509-11-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220404121410.188509-11-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 04, 2022 at 01:13:48PM +0100, Jeremy Sowden wrote:
> Shifts are of integer type and in HBO.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  src/netlink_delinearize.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index 12624db4c3a5..8b010fe4d168 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -2618,8 +2618,17 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
>  		}
>  		expr_postprocess(ctx, &expr->right);
>  
> -		expr_set_type(expr, expr->left->dtype,
> -			      expr->left->byteorder);
> +		switch (expr->op) {
> +		case OP_LSHIFT:
> +		case OP_RSHIFT:
> +			expr_set_type(expr, &integer_type,
> +				      BYTEORDER_HOST_ENDIAN);
> +			break;
> +		default:
> +			expr_set_type(expr, expr->left->dtype,
> +				      expr->left->byteorder);

This is a fix?

If so, would it be possible to provide a standalone example that shows
what this is fixing up?

> +		}
> +
>  		break;
>  	case EXPR_RELATIONAL:
>  		switch (expr->left->etype) {
> -- 
> 2.35.1
> 
