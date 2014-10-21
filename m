From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/4] evaluate: no check the network context in reject
 with tcp reset reason
Date: Tue, 21 Oct 2014 09:55:45 +0200
Message-ID: <20141021075544.GA3220@salvia>
References: <1413847780-10149-1-git-send-email-alvaroneay@gmail.com>
 <1413847780-10149-3-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46907 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbaJUHyQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 03:54:16 -0400
Content-Disposition: inline
In-Reply-To: <1413847780-10149-3-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 21, 2014 at 01:29:39AM +0200, Alvaro Neira Ayuso wrote:
> nft add rule -nnn bridge test-bridge input \
> 			ip protocol tcp reject with tcp reset
> 
> If we use in reject the type tcp reset. We don't need to check if the network
> context is compatible with the reason. This patch fix that.
> 
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  src/evaluate.c |   80 +++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 47 insertions(+), 33 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 20235a8..8b19baf 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1208,24 +1208,31 @@ static int stmt_evaluate_reject_inet(struct eval_ctx *ctx, struct stmt *stmt,
>  	const struct proto_desc *desc, *base;
>  	int protocol;
>  
> -	base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
> -	desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
> -	if (desc != NULL) {
> -		protocol = proto_find_num(base, desc);
> -		switch (protocol) {
> -		case NFPROTO_IPV4:
> -			if (stmt->reject.family == NFPROTO_IPV4)
> -				return 0;
> -			return stmt_error(ctx, stmt,
> -			  "conflicting protocols specified: ip vs ip6");
> -		case NFPROTO_IPV6:
> -			if (stmt->reject.family == NFPROTO_IPV6)
> -				return 0;
> -			return stmt_error(ctx, stmt,
> -			  "conflicting protocols specified: ip vs ip6");
> -		default:
> -			BUG("unsupported family");
> +	switch (stmt->reject.type) {
> +	case NFT_REJECT_TCP_RST:
> +		break;
> +	case NFT_REJECT_ICMPX_UNREACH:

Do you really need to check layer 3 conflicts with icmpx?

> +	case NFT_REJECT_ICMP_UNREACH:
> +		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
> +		desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
> +		if (desc != NULL) {
> +			protocol = proto_find_num(base, desc);
> +			switch (protocol) {
> +			case NFPROTO_IPV4:
> +				if (stmt->reject.family == NFPROTO_IPV4)
> +					return 0;
> +				return stmt_error(ctx, stmt,
> +				  "conflicting protocols specified: ip vs ip6");
> +			case NFPROTO_IPV6:
> +				if (stmt->reject.family == NFPROTO_IPV6)
> +					return 0;
> +				return stmt_error(ctx, stmt,
> +				  "conflicting protocols specified: ip vs ip6");
> +			default:
> +				BUG("unsupported family");
> +			}
>  		}
> +		break;
>  	}
>  	if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
>  		return 0;
