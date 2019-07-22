Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D67C76195
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 08:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1583622296
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 08:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbfGVIyP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 04:54:15 -0400
Received: from mail.us.es ([193.147.175.20]:60150 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfGVIyP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 04:54:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 65AE5C1DE1
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 10:54:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4C7A11150B9
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 10:54:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4227CDA708; Mon, 22 Jul 2019 10:54:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C712BA59B;
        Mon, 22 Jul 2019 10:54:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Jul 2019 10:54:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.214.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 89CEA4265A31;
        Mon, 22 Jul 2019 10:54:10 +0200 (CEST)
Date:   Mon, 22 Jul 2019 10:54:08 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: evaluate: support prefix expression in
 statements
Message-ID: <20190722085408.m4al3d7jk63pakyd@salvia>
References: <20190721162948.20221-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190721162948.20221-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jul 21, 2019 at 06:29:48PM +0200, Florian Westphal wrote:
> nft dumps core when a statement contains a prefix expression:
> iifname ens3 snat to 10.0.0.0/28
> 
> yields:
> BUG: unknown expression type prefix
> nft: netlink_linearize.c:688: netlink_gen_expr: Assertion `0' failed.
> 
> This assertion is correct -- we can't linearize a prefix because kernel
> doesn't know what that is.
> 
> For LHS, they get converted to a binary 'and' such as
> '10.0.0.0 & 255.255.255.240'.  For RHS, we can convert them into a range:
> 
> iifname "ens3" snat to 10.0.0.0-10.0.0.15
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1187
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/evaluate.c                  | 61 +++++++++++++++++++++++++++++++++
>  tests/py/ip6/dnat.t             |  2 ++
>  tests/py/ip6/dnat.t.json        | 27 +++++++++++++++
>  tests/py/ip6/dnat.t.payload.ip6 | 12 +++++++
>  4 files changed, 102 insertions(+)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 8c1c82abed4e..d55fe8ebb78e 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1933,6 +1933,65 @@ static int stmt_evaluate_expr(struct eval_ctx *ctx, struct stmt *stmt)
>  	return expr_evaluate(ctx, &stmt->expr);
>  }
>  
> +static int stmt_prefix_conversion(struct eval_ctx *ctx, struct expr **expr,
> +				  enum byteorder byteorder)
> +{
> +	struct expr *mask, *and, *or, *prefix, *base, *range;
> +
> +	prefix = *expr;
> +	base = prefix->prefix;
> +
> +	if (base->etype != EXPR_VALUE)
> +		return expr_error(ctx->msgs, prefix,
> +				  "you cannot specify a prefix here, "
> +				  "unknown type %s", base->dtype->name);
> +
> +	if (!expr_is_constant(base))
> +		return expr_error(ctx->msgs, prefix,
> +				  "Prefix expression is undefined for "
> +				  "non-constant expressions");
> +
> +	if (expr_basetype(base)->type != TYPE_INTEGER)
> +		return expr_error(ctx->msgs, prefix,
> +				  "Prefix expression expected integer value");
> +
> +	mask = constant_expr_alloc(&prefix->location, expr_basetype(base),
> +				   BYTEORDER_HOST_ENDIAN, base->len, NULL);
> +
> +	mpz_prefixmask(mask->value, base->len, prefix->prefix_len);
> +	and = binop_expr_alloc(&prefix->location, OP_AND, expr_get(base), mask);
> +
> +	if (expr_evaluate(ctx, &and) < 0) {

I think we don't need this expr_evaluate() call. The one at the bottom
of this function (for the range expression) should take care of this
already since expr_evaluate() makes recursive calls to left and right
hand side.

> +		expr_free(and);
> +		goto err_evaluation;
> +	}
> +
> +	mask = constant_expr_alloc(&prefix->location, expr_basetype(base),
> +				   BYTEORDER_HOST_ENDIAN, base->len, NULL);
> +	mpz_bitmask(mask->value, prefix->len - prefix->prefix_len);
> +	or = binop_expr_alloc(&prefix->location, OP_OR, expr_get(base), mask);
> +
> +	if (expr_evaluate(ctx, &or) < 0) {

Same here.

> +		expr_free(and);
> +		expr_free(or);
> +		goto err_evaluation;
> +	}
> +
> +	range = range_expr_alloc(&prefix->location, and, or);
> +	if (expr_evaluate(ctx, &range) < 0) {
> +		expr_free(range);
> +		goto err_evaluation;
> +	}
> +
> +	expr_free(*expr);
> +	*expr = range;
> +	return 0;
> +
> +err_evaluation:
> +	return expr_error(ctx->msgs, prefix,
> +			  "Could not expand prefix expression");

If this happens, then expr_error() will reported via recursive call
inside expr_evaluate(). I mean, expr_evaluate() itself should give us
an error already. So I would remove this, which is already actually
telling about an internal problem. The user cannot do much about this.
So either remove it or BUG() here I'd suggest.

Thanks!
