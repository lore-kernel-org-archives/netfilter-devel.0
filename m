Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D981D5ADE
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2025 22:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744325433; cv=none; b=SCkwg3I4daqi2AnmZwH1IcdZoqT0wWER/DLDQ1F1w1IYcLfBLDZ/ox5RnzwCL+u2VdywI4o4Jf9n5WAHJewXEgbG3nYbGcUAu7Lwv4YWdF/zv/bZBlZeE3vgy78/SfzojB2dlTchKuPS02QwHv00swt6gh64cG2TzWcrThHiaXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744325433; c=relaxed/simple;
	bh=ELWiOCvcUAEHxoMp56bMK5sIvYO/XcspqxYCaeKapas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JP2r4YGaRr8Uon8zxnvKK+785CA3P594N7q508/7J8LDXh1WJh7Gm5HWLW2SNUHax/z6DKgF/sSX/A3YJJz8KodAMIL87K5l/gTDNZkZebRzccPwqQIUzwpO84T7lvaMxr7W313xw9b0DWySsOkMAMSF0MIkrmglJUtPNji8u3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KSGQQRqA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=H+bP2UPl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KSGQQRqA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="H+bP2UPl"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B359E60653; Fri, 11 Apr 2025 00:50:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744325426;
	bh=DDGScoBYbNvjtC8KXC4oet1YOoPqIhnFMwYBO8/pbOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KSGQQRqADN5w4mmARl5jBVNPADnDt1Zqc5tEFLXhjtkRM8DqBW4ycmlQ1PmWbHCXO
	 cXsujMPCJyE9/k4XpogTQ1z/1AQIptBdiPWKeoSvINCfVvvcr7G9Env7Kh8fFeQtID
	 t8xm6i3rJ179B39czIwvcZu5cx9a4Cv1w5i6zk/Y9Mo5q5pKwvJk3jVJyuAvF5ttLG
	 64K4KXHTWni0Q78bGQFJom9FLuw5mNA7QdQPYG/6sBc+1tXbfuNBwmW9reyhx/3+Qv
	 vXb3tF/xnMHpO5FChmY7282hW0X/7DVYOC67rpKGtnWAssznPDqbzRxE+AJ50oQ0KT
	 FSlQ/ncuPfvqQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BDC0160643;
	Fri, 11 Apr 2025 00:50:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744325425;
	bh=DDGScoBYbNvjtC8KXC4oet1YOoPqIhnFMwYBO8/pbOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H+bP2UPluCaO0md4LTEP8kumqYNbfLj6XunbYKDQdCELIq2sm6zMiQYzWTA0Uqh82
	 ctIUBlBypORPNkX2H3ivW4F10tEJbtnAlqdXyFrDlui+pxRdc3DJ7AWfFB2RYvP4MD
	 430jzj1cKPq+oWrH61VmJcZZ1S6lES9dUhmwIFtabrVCz7CmOxommAk4GbKNJ+DkJy
	 w5zXpPczdSUVyfbM+P6rcyjdbH2p/04viJTP6JB+G7sEM05lIUw8Q8GmaVf9MI2M8d
	 U29+jYxb7aLHkr94MjLejZ0hpP2l5vrB5d/fo5gaUYUs8VqO7KdXyZhtqZxjUaDGET
	 Ysj0oFIdKN77w==
Date: Fri, 11 Apr 2025 00:50:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] evaluate: restrict allowed subtypes of
 concatenations
Message-ID: <Z_hLLgRswOjXUKMa@calendula>
References: <20250402145045.4637-1-fw@strlen.de>
 <20250402145045.4637-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250402145045.4637-2-fw@strlen.de>

Hi Florian,

On Wed, Apr 02, 2025 at 04:50:40PM +0200, Florian Westphal wrote:
> We need to restrict this, included bogon asserts with:
> BUG: unknown expression type prefix
> nft: src/netlink_linearize.c:940: netlink_gen_expr: Assertion `0' failed.
> 
> Prefix expressions are only allowed if the concatenation is used within
> a set element, not when specifying the lookup key.
> 
> For the former, anything that represents a value is allowed.
> For the latter, only what will generate data (fill a register) is
> permitted.
> 
> Add a new list recursion counter for this. If its 0 then we're building
> the lookup key, if its the latter the concatenation is the RHS part
> of a relational expression and prefix, ranges and so on are allowed.
[...]
> diff --git a/src/evaluate.c b/src/evaluate.c
> index d099be137cb3..0c8af09492d1 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
[...]
> @@ -1704,10 +1706,48 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
>  		if (list_member_evaluate(ctx, &i) < 0)
>  			return -1;
>  
> -		if (i->etype == EXPR_SET)
> +		switch (i->etype) {
> +		case EXPR_VALUE:
> +		case EXPR_UNARY:
> +		case EXPR_BINOP:
> +		case EXPR_RELATIONAL:
> +		case EXPR_CONCAT:
> +		case EXPR_MAP:
> +		case EXPR_PAYLOAD:
> +		case EXPR_EXTHDR:
> +		case EXPR_META:
> +		case EXPR_RT:
> +		case EXPR_CT:
> +		case EXPR_SET_ELEM:
> +		case EXPR_NUMGEN:
> +		case EXPR_HASH:
> +		case EXPR_FIB:
> +		case EXPR_SOCKET:
> +		case EXPR_OSF:
> +		case EXPR_XFRM:

I am expecting more new selector expressions here that would need to
be added and I think it is less likely to see new constant expressions
in the future, so maybe reverse this logic ...

		if (i->etype == EXPR_RANGE ||
                    i->etype == EXPR_PREFIX) {
			/* allowed on RHS (e.g. th dport . mark { 1-65535 . 42 }
			 *                                       ~~~~~~~~ allowed
			 * but not on LHS (e.g  1-4 . mark { ...}
			 *                      ~~~ illegal
                        ...

... and let anything else be accepted?

> +			break;
> +		case EXPR_RANGE:
> +		case EXPR_PREFIX:
> +			/* allowed on RHS (e.g. th dport . mark { 1-65535 . 42 }
> +			 *                                       ~~~~~~~~ allowed
> +			 * but not on LHS (e.g  1-4 . mark { ...}
> +			 *                      ~~~ illegal
> +			 *
> +			 * recursion.list > 0 means that the concatenation is
> +			 * part of another expression, such as EXPR_MAPPING or
> +			 * EXPR_SET_ELEM (is used as RHS).
> +			 */
> +			if (ctx->recursion.list > 0)
> +				break;

So recursion.list is used to provide context to identify this is rhs,
correct? Is your intention is to use this recursion.list to control to
deeper recursions in a follow up patch?

Not related, but if goal is to provide context then I also need more
explicit context hints for bitfield payload and bitwise expressions
where the evaluation needs to be different depending on where the
expression is located (not the same if the expression is either used
as selector or as lhs/rhs of assignment).

I don't know yet how such new context enum to modify evaluation
behaviour will look, so we can just use recursion.list by now, I don't
want to block this fix.

> +
> +			return expr_error(ctx->msgs, i,
> +					  "cannot use %s in concatenation",
> +					  expr_name(i));
> +		default:
>  			return expr_error(ctx->msgs, i,
>  					  "cannot use %s in concatenation",
>  					  expr_name(i));
> +		}
>  
>  		if (!i->dtype)
>  			return expr_error(ctx->msgs, i,
> diff --git a/tests/shell/testcases/bogons/nft-f/unknown_expression_type_prefix_assert b/tests/shell/testcases/bogons/nft-f/unknown_expression_type_prefix_assert
> new file mode 100644
> index 000000000000..d7f8526092a5
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/unknown_expression_type_prefix_assert
> @@ -0,0 +1,9 @@
> +table t {
> +	set sc {
> +		type inet_service . ifname
> +	}
> +
> +	chain c {
> +		tcp dport . bla* @sc accept
> +	}
> +}
> -- 
> 2.49.0
> 
> 
