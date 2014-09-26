From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 4/4 v4] nft: complete reject support
Date: Fri, 26 Sep 2014 20:06:12 +0200
Message-ID: <20140926180612.GB11463@salvia>
References: <1411750255-7663-1-git-send-email-alvaroneay@gmail.com>
 <1411750255-7663-4-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50514 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbaIZSFP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:05:15 -0400
Content-Disposition: inline
In-Reply-To: <1411750255-7663-4-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

First off, thanks for the effort. Several comments below.

On Fri, Sep 26, 2014 at 06:50:55PM +0200, Alvaro Neira Ayuso wrote:
> +/* The reason to reject this hasn't been specified */

You can remove this comment above. You selected a function to
encapsulate the code per reason that explains the thing by itself.

> +static int stmt_evaluate_reject_no_reason(struct eval_ctx *ctx,
> +					  struct stmt *stmt)
> +{
> +	switch (ctx->pctx.family) {
> +	case NFPROTO_IPV4:
> +	case NFPROTO_IPV6:
> +		stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
> +		stmt->reject.family = ctx->pctx.family;
> +		if (ctx->pctx.family == NFPROTO_IPV4)
> +			stmt->reject.icmp_code = ICMP_PORT_UNREACH;
> +		else
> +			stmt->reject.icmp_code = ICMP6_DST_UNREACH_NOPORT;
> +		break;
> +	case NFPROTO_INET:
> +	case NFPROTO_BRIDGE:
> +		stmt->reject.type = NFT_REJECT_ICMPX_UNREACH;
> +		stmt->reject.icmp_code = NFT_REJECT_ICMPX_PORT_UNREACH;
> +		break;
> +	}
> +	return 0;
> +}
> +
> +/* The reason to reject this has been specified with icmp reason */

Same thing here.

> +static int stmt_evaluate_reject_icmp_reason(struct eval_ctx *ctx,
> +					    struct stmt *stmt)

I'd suggest: stmt_evaluate_reject_with_icmp(...)

> +{
> +	struct error_record *erec;
> +	struct expr *code;
> +
> +	erec = symbol_parse(stmt->reject.expr, &code);
> +	if (erec != NULL) {
> +		erec_queue(erec, ctx->msgs);
> +		return -1;
> +	}
> +	stmt->reject.icmp_code = mpz_get_uint8(code->value);
> +	return 0;
> +}
> +
> +/* The reason to reject this has been specified with tcp reset */

And here.

> +static int stmt_evaluate_reject_tcp_reason(struct eval_ctx *ctx,
> +					   struct stmt *stmt)

I'd suggest: stmt_evaluate_reject_with_tcp(...)

> +{
> +	int protonum;
> +	const struct proto_desc *desc, *base;
> +	struct proto_ctx *pctx = &ctx->pctx;
> +
> +	base = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
> +	desc = pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
> +	if (desc == NULL)
> +		return 0;
> +
> +	protonum = proto_find_num(base, desc);
> +	switch (protonum) {
> +	case IPPROTO_TCP:
> +		break;
> +	default:
> +		if (stmt->reject.type == NFT_REJECT_TCP_RST) {
> +			return stmt_error(ctx, stmt,
> +				 "you cannot use tcp reset with this protocol");
> +		}
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
> +{
> +	struct expr *expr = ctx->cmd->expr;
> +
> +	if (stmt->reject.icmp_code < 0) {
> +		stmt_evaluate_reject_no_reason(ctx, stmt);
> +	} else if (stmt->reject.expr != NULL) {
> +		if (stmt_evaluate_reject_icmp_reason(ctx, stmt) < 0)
> +			return -1;
> +	} else {
> +		if (stmt_evaluate_reject_tcp_reason(ctx, stmt) < 0)
> +			return -1;
> +	}
> +
> +	return stmt_evaluate_reject_family(ctx, stmt, expr);
> +}
> +
>  static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
>  {
>  	struct proto_ctx *pctx = &ctx->pctx;
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index 796b632..12cb9e0 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -14,6 +14,9 @@
>  #include <string.h>
>  #include <limits.h>
>  #include <linux/netfilter/nf_tables.h>
> +#include <arpa/inet.h>
> +#include <linux/netfilter.h>
> +#include <net/ethernet.h>
>  #include <netlink.h>
>  #include <rule.h>
>  #include <statement.h>
> @@ -474,6 +477,9 @@ static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
>  	struct stmt *stmt;
>  
>  	stmt = reject_stmt_alloc(loc);
> +	stmt->reject.type = nft_rule_expr_get_u32(expr, NFT_EXPR_REJECT_TYPE);
> +	stmt->reject.icmp_code = nft_rule_expr_get_u8(expr,
> +						      NFT_EXPR_REJECT_CODE);
>  	list_add_tail(&stmt->list, &ctx->rule->stmts);
>  }
>  
> @@ -899,6 +905,38 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
>  	}
>  }
>  
> +static void stmt_reject_postprocess(struct rule_pp_ctx rctx, struct stmt *stmt)
> +{
> +	const struct proto_desc *desc, *base;
> +	int protocol;
> +
> +	switch (rctx.pctx.family) {
> +	case NFPROTO_IPV4:
> +	case NFPROTO_IPV6:
> +		stmt->reject.family = rctx.pctx.family;
> +		break;
> +	case NFPROTO_INET:
> +	case NFPROTO_BRIDGE:
> +		if (rctx.pbase == PROTO_BASE_INVALID)
> +			return;
> +
> +		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
> +			break;
> +
> +		base = rctx.pctx.protocol[PROTO_BASE_LL_HDR].desc;
> +		desc = rctx.pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
> +		protocol = proto_find_num(base, desc);
> +		if (protocol == __constant_htons(ETH_P_IP))
> +			stmt->reject.family = NFPROTO_IPV4;
> +		else if (protocol == __constant_htons(ETH_P_IPV6))
> +			stmt->reject.family = NFPROTO_IPV6;
> +		else
> +			stmt->reject.family = protocol;

I think you can generate an expression here to set up
stmt->reject.expr. That should help to simplify reject_stmt_print()
since you can use the new datatypes that you have defined.

I mean, with stmt->reject.expr, you can skip this:

+const char *reject_stmt_code_ip[] = {
+       [ICMP_NET_UNREACH]      = "net-unreach",
...

and get reject_stmt_print() in a diet.

I'm refering to the code in src/statement.c

[...]
> +reject_opts		:       /* empty */
> +			{
> +				$<stmt>0->reject.type = -1;
> +				$<stmt>0->reject.icmp_code = -1;
> +			}
> +			|	WITH	ICMP	TYPE	STRING
> +	       		{
> +				$<stmt>0->reject.family = NFPROTO_IPV4;
> +				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
> +				$<stmt>0->reject.expr = symbol_expr_alloc(&@$,
> +								   SYMBOL_VALUE,
> +							   current_scope(state),
> +									 $4);

To fulfill the 80-chars per line rule, I'd suggest:

				$<stmt>0->reject.expr =
                                        symbol_expr_alloc(&@$, SYMBOL_VALUE,
                                                          current_scope(state),
                                                          $4);

> +				$<stmt>0->reject.expr->dtype = &icmp_code_type;
> +			}
> +			|	WITH	ICMP6	TYPE	STRING
> +			{
> +				$<stmt>0->reject.family = NFPROTO_IPV6;
> +				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
> +				$<stmt>0->reject.expr = symbol_expr_alloc(&@$,
> +								   SYMBOL_VALUE,
> +							   current_scope(state),
> +									 $4);

Same here.

> +				$<stmt>0->reject.expr->dtype = &icmpv6_code_type;
> +			}
> +			|	WITH	ICMPX	TYPE	STRING
> +			{
> +				$<stmt>0->reject.type = NFT_REJECT_ICMPX_UNREACH;
> +				$<stmt>0->reject.expr = symbol_expr_alloc(&@$,
> +								   SYMBOL_VALUE,
> +							   current_scope(state),
> +									 $4);

And here.
