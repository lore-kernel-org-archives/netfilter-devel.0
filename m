From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/4] evaluate: refactor function to check the reject
 family in inet and bridge
Date: Tue, 21 Oct 2014 10:45:08 +0200
Message-ID: <20141021084508.GA4728@salvia>
References: <1413847780-10149-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38467 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaJUIni (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:43:38 -0400
Content-Disposition: inline
In-Reply-To: <1413847780-10149-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 21, 2014 at 01:29:37AM +0200, Alvaro Neira Ayuso wrote:
> This patch make a refactorization of the code to check the reject family in inet
> and bridge. These changes will be used in follow up patches.
> 
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  src/evaluate.c |  110 ++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 63 insertions(+), 47 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 1fec120..977df86 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1202,12 +1202,72 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
>  	return 0;
>  }
>  
> -static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
> +static int stmt_evaluate_reject_inet(struct eval_ctx *ctx, struct stmt *stmt,
> +				       struct expr *expr)
> +{
> +	const struct proto_desc *desc, *base;
> +	int protocol;
> +
> +	base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;

This base pointer is fetched, but you only need this if desc != NULL.
Please, while you're refactoring this, it's good if you avoid this.

> +	desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
> +	if (desc != NULL) {

>From here:

> +		protocol = proto_find_num(base, desc);
> +		switch (protocol) {
> +		case NFPROTO_IPV4:
> +			if (stmt->reject.family == NFPROTO_IPV4)
> +				return 0;
> +			return stmt_error(ctx, stmt,
> +			  "conflicting protocols specified: ip vs ip6");
> +		case NFPROTO_IPV6:
> +			if (stmt->reject.family == NFPROTO_IPV6)
> +				return 0;
> +			return stmt_error(ctx, stmt,
> +			  "conflicting protocols specified: ip vs ip6");
> +		default:
> +			BUG("unsupported family");
> +		}
> +	}

to there. You can put this code in another function, given that you'll
need it again for your patch 3/4.

static int stmt_evaluate_reject_inet_family(...)
{
	int protocol;

	protocol = proto_find_num(base, desc);
	switch (protocol) {
	case NFPROTO_IPV4:
		if (stmt->reject.family != NFPROTO_IPV4)
			return -1;

                break;
	case NFPROTO_IPV6:
		if (stmt->reject.family == NFPROTO_IPV6)
			return -1;

                break;
	default:
		BUG("unsupported family");
	}

        return 0;
}

Then, from stmt_evaluate_reject_inet():

        if (desc != NULL &&
            stmt_evaluate_reject_inet_family(...) < 0)
                return stmt_error(..., "conflicting protocols...");

> +	if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
> +		return 0;
> +	if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
> +		return -1;
> +	return 0;
> +}
> +
> +static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
>  				       struct expr *expr)

Same thing for the bridge code.
