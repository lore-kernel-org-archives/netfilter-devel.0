From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 3/3] ct: add conntrack label set support
Date: Tue, 15 Mar 2016 18:11:57 +0100
Message-ID: <20160315171157.GB25284@salvia>
References: <1458058211-11147-1-git-send-email-fw@strlen.de>
 <1458058211-11147-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41437 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934827AbcCORMB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 13:12:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4012F114F52
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 18:12:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2B4D7DA38A
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 18:12:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 434B1DA8F9
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 18:11:58 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1458058211-11147-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 15, 2016 at 05:10:11PM +0100, Florian Westphal wrote:
> Pablo suggested to support this by adding the label bit number
> that we want to set as a netlink attribute and pass that to the kernel.
> 
> IOW, ct label set doesn't use an sreg -- instead, the bit that we
> should set in the conntrack label area is taken directly from the user.
> 
> This works pretty much the same way as '-m connlabel --set foo'.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  I find the placement of the expr <-> attribute conversion
>  in netlink_(de)linearize to be pretty bad, but doing it
>  during stmt_evaluate_ct() requires extra member in
>  stmt->ct to store the 'extracted' bit value.
> 
>  Thoughts?
> 
>  src/evaluate.c            | 19 +++++++++++++++----
>  src/netlink_delinearize.c | 24 +++++++++++++++++++++---
>  src/netlink_linearize.c   | 20 ++++++++++++++------
>  3 files changed, 50 insertions(+), 13 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 473f014..7a3be46 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1462,10 +1462,21 @@ static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
>  
>  static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
>  {
> -	return stmt_evaluate_arg(ctx, stmt,
> -				 stmt->ct.tmpl->dtype,
> -				 stmt->ct.tmpl->len,
> -				 &stmt->ct.expr);
> +	int ret = stmt_evaluate_arg(ctx, stmt, stmt->ct.tmpl->dtype,
> +				    stmt->ct.tmpl->len, &stmt->ct.expr);
> +	if (ret < 0)
> +		return ret;
> +
> +	switch (stmt->ct.key) {
> +	case NFT_CT_LABELS:
> +		if (stmt->ct.expr->ops->type != EXPR_VALUE)
> +			return stmt_error(ctx, stmt, "label expected");
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return 0;
>  }
>  
>  static int reject_payload_gen_dependency_tcp(struct eval_ctx *ctx,
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index d431588..86ff376 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -524,10 +524,28 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
>  	struct stmt *stmt;
>  	struct expr *expr;
>  
> -	sreg = netlink_parse_register(nle, NFTNL_EXPR_CT_SREG);
> -	expr = netlink_get_register(ctx, loc, sreg);
> -
>  	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_CT_KEY);
> +	switch (key) {
> +	case NFT_CT_LABELS: {
> +		unsigned char data[128];
> +		mpz_t value;
> +
> +		mpz_init(value);
> +		mpz_setbit(value, nftnl_expr_get_u16(nle, NFTNL_EXPR_CT_LABEL));
> +
> +		mpz_export_data(data, value, BYTEORDER_HOST_ENDIAN, sizeof(data));
> +		expr = constant_expr_alloc(loc, &integer_type,
> +					   BYTEORDER_BIG_ENDIAN,
> +					   BITS_PER_BYTE * sizeof(data), data);
> +		break;
> +	}

If we have some generic way to parse immediates, this would look like:

        if (nfntl_attr_is_set(nle, NFTNL_EXPR_CT_SREG)) {
                ...
        } else if (nftnl_attr_is_set(nle, NFTNL_EXPR_CT_IMM)) {
                ...
        }

Would this look nicer this way to you?

> +	default:
> +		sreg = netlink_parse_register(nle, NFTNL_EXPR_CT_SREG);
> +		expr = netlink_get_register(ctx, loc, sreg);
> +		break;
> +	}
> +
> +
>  	stmt = ct_stmt_alloc(loc, key, expr);
>  	expr_set_type(expr, stmt->ct.tmpl->dtype, stmt->ct.tmpl->byteorder);
>  
