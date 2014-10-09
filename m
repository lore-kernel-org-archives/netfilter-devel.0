From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 4/4 v5] nft: complete reject support
Date: Thu, 9 Oct 2014 14:01:44 +0200
Message-ID: <20141009120144.GA16528@salvia>
References: <1412090500-4564-1-git-send-email-alvaroneay@gmail.com>
 <1412090500-4564-4-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58172 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbaJIMA1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:00:27 -0400
Content-Disposition: inline
In-Reply-To: <1412090500-4564-4-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 30, 2014 at 05:21:40PM +0200, Alvaro Neira Ayuso wrote:
> This patch allows to use the reject action in rules. For example:
> 
>   nft add rule filter input udp dport 22 reject

Series applies with some minor glitches, Thanks Alvaro.

See comments below.

> diff --git a/include/proto.h b/include/proto.h
> index cc1f51f..0e531b2 100644
> --- a/include/proto.h
> +++ b/include/proto.h
> @@ -252,6 +252,7 @@ enum udp_hdr_fields {
>  
>  enum tcp_hdr_fields {
>  	TCPHDR_INVALID,
> +	TCPHDR_UNSPEC = TCPHDR_INVALID,

I think we can rename all _INVALID to _UNSPEC in a follow up patch,
given that we use this to generate the dependencies.

> +static const struct symbol_table icmp_code_tbl = {
> +	.symbols	= {
> +		SYMBOL("port-unreach",		ICMP_PORT_UNREACH),

This one is shortened.

> +		SYMBOL("net-prohibited",	ICMP_NET_ANO),

This one is full long name.

I have mangled the patch to use long names all the time for
consistency. Once we get autocompletion I guess this shouldn't be a
problem.

> +static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
> +				      struct expr *expr)
> +{
> +	struct expr *payload = NULL;
> +	struct stmt *nstmt;
> +
> +	switch (stmt->reject.type) {
> +	case NFT_REJECT_TCP_RST:
> +		if (reject_payload_gen_dependency_tcp(ctx, stmt, &payload) < 0)
> +			return -1;
> +		break;
> +	default:
> +		if (reject_payload_gen_dependency_family(ctx, stmt,
> +							 &payload) < 0)
> +			return -1;
> +		break;
> +	}

Beware with using 'default' in switch().

This is actually catching the NFT_REJECT_ICMP_UNREACH. And
NFT_REJECT_ICMPX_UNREACH seems not possible.

I mangled this to catch NFT_REJECT_ICMP_UNREACH and the default case
(which should not happen displays a bug).

> @@ -899,6 +909,59 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
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
> +		stmt->reject.family = rctx.pctx.family;
> +		stmt->reject.expr->dtype = &icmp_code_type;
> +		break;
> +	case NFPROTO_IPV6:
> +		stmt->reject.family = rctx.pctx.family;
> +		stmt->reject.expr->dtype = &icmpv6_code_type;
> +		break;
> +	case NFPROTO_INET:
> +		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
> +			break;
> +		base = rctx.pctx.protocol[PROTO_BASE_LL_HDR].desc;
> +		desc = rctx.pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
> +		protocol = proto_find_num(base, desc);
> +		switch (protocol) {
> +		case NFPROTO_IPV4:
> +			stmt->reject.expr->dtype = &icmp_code_type;
> +			break;
> +		case NFPROTO_IPV6:
> +			stmt->reject.expr->dtype = &icmpv6_code_type;
> +			break;
> +		}
> +		stmt->reject.family = protocol;
> +		break;
> +	case NFPROTO_BRIDGE:
> +		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
> +			break;
> +		base = rctx.pctx.protocol[PROTO_BASE_LL_HDR].desc;
> +		desc = rctx.pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
> +		protocol = proto_find_num(base, desc);
> +		switch (protocol) {
> +		case __constant_htons(ETH_P_IP):
> +			stmt->reject.family = NFPROTO_IPV4;
> +			stmt->reject.expr->dtype = &icmp_code_type;
> +			break;
> +		case __constant_htons(ETH_P_IPV6):
> +			stmt->reject.family = NFPROTO_IPV6;
> +			stmt->reject.expr->dtype = &icmpv6_code_type;
> +			break;
> +		default:
> +			break;

Please, have a closer look to this 'default' case. We may have
different ethertype in bridge (not just ipv4 and ipv6). Check if this
works fine in that case.
