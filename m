Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10103C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 May 2022 18:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237736AbiEWSJC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 May 2022 14:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244791AbiEWSHS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 May 2022 14:07:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDE2DA7761
        for <netfilter-devel@vger.kernel.org>; Mon, 23 May 2022 10:48:03 -0700 (PDT)
Date:   Mon, 23 May 2022 19:33:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [nft PATCH v4 14/32] evaluate: relax type-checking for integer
 arguments in mark statements
Message-ID: <YovFWu9AsdO99Oy+@salvia>
References: <20220404121410.188509-1-jeremy@azazel.net>
 <20220404121410.188509-15-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220404121410.188509-15-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 04, 2022 at 01:13:52PM +0100, Jeremy Sowden wrote:
> In order to be able to set ct and meta marks to values derived from
> payload expressions, we need to relax the requirement that the type of
> the statement argument must match that of the statement key.  Instead,
> we require that the base-type of the argument is integer and that the
> argument is small enough to fit.

LGTM.

> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  src/evaluate.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index ee4da5a2b889..f975dd197de3 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -2393,8 +2393,12 @@ static int __stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
>  					 "expression has type %s with length %d",
>  					 dtype->desc, (*expr)->dtype->desc,
>  					 (*expr)->len);
> -	else if ((*expr)->dtype->type != TYPE_INTEGER &&
> -		 !datatype_equal((*expr)->dtype, dtype))
> +
> +	if ((dtype->type == TYPE_MARK &&
> +	     !datatype_equal(datatype_basetype(dtype), datatype_basetype((*expr)->dtype))) ||
> +	    (dtype->type != TYPE_MARK &&
> +	     (*expr)->dtype->type != TYPE_INTEGER &&
> +	     !datatype_equal((*expr)->dtype, dtype)))
>  		return stmt_binary_error(ctx, *expr, stmt,		/* verdict vs invalid? */
>  					 "datatype mismatch: expected %s, "
>  					 "expression has type %s",
> -- 
> 2.35.1
> 
