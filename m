From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 4/7] netlink: decode payload statment
Date: Mon, 1 Aug 2016 12:34:59 +0200
Message-ID: <20160801103459.GB3206@salvia>
References: <1469580196-2100-1-git-send-email-fw@strlen.de>
 <1469580196-2100-5-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58373 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbcHAKfF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Aug 2016 06:35:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B5D781B7FA1
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 12:35:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A53B6FF6FF
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 12:35:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 91727ADF3
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 12:35:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469580196-2100-5-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 27, 2016 at 02:43:13AM +0200, Florian Westphal wrote:
> This allows nft to display payload set operations if the
> header isn't byte aligned or has non-byte divisible sizes.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/netlink_delinearize.c | 165 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 160 insertions(+), 5 deletions(-)
> 
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index ae87280..5e28111 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -1747,6 +1747,165 @@ static void stmt_expr_postprocess(struct rule_pp_ctx *ctx)
>  		expr_postprocess_range(ctx, op);
>  }
>  
> +static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
> +{
> +	struct expr *payload = binop->left;
> +	struct expr *mask = binop->right;
> +	unsigned int shift;
> +
> +	assert(payload->ops->type == EXPR_PAYLOAD);
> +	if (payload_expr_trim(payload, mask, &ctx->pctx, &shift)) {
> +		__binop_adjust(binop, mask, shift);
> +		payload_expr_complete(payload, &ctx->pctx);
> +		expr_set_type(mask, payload->dtype,
> +			      payload->byteorder);
> +	}
> +}
> +
> +static void stmt_payload_postprocess(struct rule_pp_ctx *ctx)
> +{
> +	struct stmt *stmt = ctx->stmt;
> +	struct expr *expr, *binop, *payload, *value, *mask;
> +	mpz_t bitmask;
> +
> +	expr_postprocess(ctx, &stmt->payload.expr);
> +
> +	expr_set_type(stmt->payload.val,
> +		      stmt->payload.expr->dtype,
> +		      stmt->payload.expr->byteorder);
> +
> +	if (payload_is_known(stmt->payload.expr))
> +		goto out;

Could you wrap the whole code below into a function, something like:

        stmt_payload_binop_postprocess(...)

(feel free to select a better name that looks consistent to what we
have around), so this looks like:

static void stmt_payload_postprocess(struct rule_pp_ctx *ctx)
{
        [...]

	expr_postprocess(ctx, &stmt->payload.expr);

	expr_set_type(stmt->payload.val,
		      stmt->payload.expr->dtype,
		      stmt->payload.expr->byteorder);

	if (!payload_is_known(stmt->payload.expr))
                stmt_payload_binop_postprocess(...);

        expr_postprocess(...);
}

So we reduce the use of gotos a bit.

> +	/*
> +	 * expr_postprocess() failed to decode the payload information.

Thus, this comment becomes a description for this new
stmt_payload_binop_postprocess() function.
