Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE5C33768F
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 14:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525655; cv=none; b=IxnjOT8tq3oimpWjyMbIn7xIed7RpdXo6gElLjh92aFt2OfZcrbFIEdRHA1VKjU38VMhNj6zH0pl6NzEs8XW1+NFBrqvCa1wzcQZD7MPo+MAabHGeBO2dTJd257GY78R4g5E9CZIfkaeVP3XrHSWFh2lJM+n4WpRkt3KFbNYRg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525655; c=relaxed/simple;
	bh=NIF2Jjxm9WI5UkN5wDlUZciwGuGVa6JkpBIPkBHVuAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kH/vE6K64LyAJ25ljMGAxhkoRvUuVm+xDX8XShXHLWxtmUvS3k4lQYY5NYB37w52mmTWJjYak2xsXSnKuqnelAgVUjRRMLK8W0fDpgW20o/S05STH8uq3lY2dLeObuwHRhvIEkCCycKEROVmiXm/dLv5157MxRBYFYERAEP7ty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JCxyblM/; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JCxyblM/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JCxyblM/";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JCxyblM/"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id CEFC760265; Mon, 18 Aug 2025 16:00:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755525649;
	bh=xRA3wiA2CuWTJfJ6r7Ch2CYCGr/M4zspOOmUXTnLRtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JCxyblM/KO1HMdkrZeQcDVtEPjgUwmd5ZWDIv0Q3SJWC7nl1ym8HGS6UNRgDnRyOK
	 mwjex5n+bGKhYbS32LvXQZACwIup/KMtiEpoCWdmgf5WIcxmakX8zMbT56vq+NreZb
	 PGyaz07m6TeBilok3ULvdl+nNww4/lmJIS0+KsbCAm0Hx7vx2KK4e7vUOMEubPEt+F
	 6vgBKoVcH0q4tV2Uw931hDQohuD7qSVkhRPy1EP1mAMOlz7EsRok5n2O8kNtNsvdtS
	 DWLnh5AJpm3kTIF6LgLbRzR5corLB0OCA/icGgaUd54+jR+MlObb4R3B1zaxD8HLeE
	 fCTT9qlS8FHiw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1F95B60265;
	Mon, 18 Aug 2025 16:00:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755525649;
	bh=xRA3wiA2CuWTJfJ6r7Ch2CYCGr/M4zspOOmUXTnLRtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JCxyblM/KO1HMdkrZeQcDVtEPjgUwmd5ZWDIv0Q3SJWC7nl1ym8HGS6UNRgDnRyOK
	 mwjex5n+bGKhYbS32LvXQZACwIup/KMtiEpoCWdmgf5WIcxmakX8zMbT56vq+NreZb
	 PGyaz07m6TeBilok3ULvdl+nNww4/lmJIS0+KsbCAm0Hx7vx2KK4e7vUOMEubPEt+F
	 6vgBKoVcH0q4tV2Uw931hDQohuD7qSVkhRPy1EP1mAMOlz7EsRok5n2O8kNtNsvdtS
	 DWLnh5AJpm3kTIF6LgLbRzR5corLB0OCA/icGgaUd54+jR+MlObb4R3B1zaxD8HLeE
	 fCTT9qlS8FHiw==
Date: Mon, 18 Aug 2025 16:00:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] evaluate: check XOR RHS operand is a constant
 value
Message-ID: <aKMyDsWdj6Bapv7j@calendula>
References: <20250805194032.18288-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250805194032.18288-1-fw@strlen.de>

On Tue, Aug 05, 2025 at 09:40:14PM +0200, Florian Westphal wrote:
> Now that we support non-constant RHS side in binary operations,
> reject XOR with non-constant key: we cannot transfer the expression.
> 
> Fixes: 54bfc38c522b ("src: allow binop expressions with variable right-hand operands")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Maybe a tests/py for this to improve coverage is worth?

> ---
>  I suggest to defer this until after 1.1.4 is out.
> 
>  src/evaluate.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 81e88d11aecb..1d102f842df0 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -2578,16 +2578,20 @@ static int binop_can_transfer(struct eval_ctx *ctx,
>  
>  	switch (left->op) {
>  	case OP_LSHIFT:
> +		assert(left->right->etype == EXPR_VALUE);
> +		assert(right->etype == EXPR_VALUE);
> +
>  		if (mpz_scan1(right->value, 0) < mpz_get_uint32(left->right->value))
>  			return expr_binary_error(ctx->msgs, right, left,
>  						 "Comparison is always false");
>  		return 1;
>  	case OP_RSHIFT:
> +		assert(left->right->etype == EXPR_VALUE);
>  		if (ctx->ectx.len < right->len + mpz_get_uint32(left->right->value))
>  			ctx->ectx.len += mpz_get_uint32(left->right->value);
>  		return 1;
>  	case OP_XOR:
> -		return 1;
> +		return expr_is_constant(left->right);
>  	default:
>  		return 0;
>  	}
> -- 
> 2.49.1
> 
> 
