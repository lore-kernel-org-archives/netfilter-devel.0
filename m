Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7487EC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 May 2022 17:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbiEWR3k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 May 2022 13:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242016AbiEWR1X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 May 2022 13:27:23 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32BD67A80A
        for <netfilter-devel@vger.kernel.org>; Mon, 23 May 2022 10:22:33 -0700 (PDT)
Date:   Mon, 23 May 2022 19:22:02 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [nft PATCH v4 11/32] netlink_delinearize: correct length of
 right bitwise operand
Message-ID: <YovCuuA/egTL+TvL@salvia>
References: <20220404121410.188509-1-jeremy@azazel.net>
 <20220404121410.188509-12-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220404121410.188509-12-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 04, 2022 at 01:13:49PM +0100, Jeremy Sowden wrote:
> Set it to match the length of the left operand.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  src/netlink_delinearize.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index 8b010fe4d168..cf5359bf269e 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -2613,6 +2613,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
>  				      BYTEORDER_HOST_ENDIAN);
>  			break;
>  		default:
> +			expr->right->len = expr->left->len;

This seems to be required for EXPR_BINOP (exclusing left/right shift)

I am assuming here expr->right is the value of the bitmask.

Was expr->right->len unset?

>  			expr_set_type(expr->right, expr->left->dtype,
>  				      expr->left->byteorder);
>  		}
> -- 
> 2.35.1
> 
