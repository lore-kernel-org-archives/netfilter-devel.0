From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] meta: permit meta nfproto ip in ip family
Date: Tue, 6 Jun 2017 20:57:39 +0200
Message-ID: <20170606185739.GC13566@breakpoint.cc>
References: <20170529172538.27878-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41650 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751589AbdFFS6M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 14:58:12 -0400
Content-Disposition: inline
In-Reply-To: <20170529172538.27878-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> works:
> add rule ip filter input ct original saddr 1.2.3.4
> (family ctx init initialises network base to proto_ip).
> 
> fails to parse 1.2.3.4 address:
> add rule ip filter input meta nfproto ipv4 ct original saddr 1.2.3.4
> 
> ... because meta_expr_pctx_update() won't find a dependency
> from "ip" to "ip" and then overwrites the correct base with proto_unknown.
> 
> "meta nfproto ip" is useless in the ip family, as it will always match,
> i.e.  a better (but more compliated) fix would be to remove the statement
> during evaluation.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/meta.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/src/meta.c b/src/meta.c
> index cb7c1368e087..dd09d49560cd 100644
> --- a/src/meta.c
> +++ b/src/meta.c
> @@ -497,6 +497,7 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
>  	const struct hook_proto_desc *h = &hook_proto_desc[ctx->family];
>  	const struct expr *left = expr->left, *right = expr->right;
>  	const struct proto_desc *desc;
> +	uint8_t protonum;
>  
>  	assert(expr->op == OP_EQ);
>  
> @@ -514,10 +515,16 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
>  		proto_ctx_update(ctx, PROTO_BASE_LL_HDR, &expr->location, desc);
>  		break;
>  	case NFT_META_NFPROTO:
> -		desc = proto_find_upper(h->desc, mpz_get_uint8(right->value));
> -		if (desc == NULL)
> +		protonum = mpz_get_uint8(right->value);
> +		desc = proto_find_upper(h->desc, protonum);
> +		if (desc == NULL) {
>  			desc = &proto_unknown;
>  
> +			if (protonum == ctx->family &&
> +			    h->base == PROTO_BASE_NETWORK_HDR)
> +				desc = h->desc;
> +		}
> +

I've pushed this.

One thing to keep in mind for future:

NFT_META_NFPROTO is basically useless except for inet pseudo-family.

For bridge it will be NFPROTO_BRIDGE, so if we ever get bridge
conntrack support we will need some other dependency instead to
set the needed context info (perhaps based off ct entry itself...)

Perhaps we should extend eval step to kill this dependency, or reject
statements when they occur in wrong context.

Examples:

add rule ip filter input meta nfproto ipv4  // always true
add rule ip filter input meta nfproto != ipv4  // always false
add rule ip filter input meta nfproto ipv6  // always false
add rule bridge filter input meta nfproto ipv6  // always false


