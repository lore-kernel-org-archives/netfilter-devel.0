Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBF12512F1
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Sep 2025 21:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757453648; cv=none; b=N9PN79UWLSMZSkXq8A2ugaxo+E8m+nZ9prA+TAW1lOZNoSF0pWIU2s4mAcXRcHzFbKXJxPPBNDMHK5HtoMuOXmmRCJQEEFnF0iAUZkxsbCdXN8V5AFPqCVcd+Z4voxSDt5fdd+cuz56zEosp2mjEAfAuv6qESHV0T6cYcJDNDPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757453648; c=relaxed/simple;
	bh=mwcAzSCG2wSe4si1W/XSgvNe28yjYVaupE1JMNBA5ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4Am8jQtSYKmFbjnErhWyGsgXHoloaAfC5RDypWrODMaF/OzfIT+8840aMuqe3TZf0jeFfMSMankvNEGu2fLOwMW5JfZUZMP+L2MlbPMxppBcQNl00Et7OVAa1Y7aLBz9NbPVA2gPolNzXmMd2p5KyovtafxXsejfL/Y/yHpu9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tp4gFKQp; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RMTrC+4X; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tp4gFKQp";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RMTrC+4X"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A74B660653; Tue,  9 Sep 2025 23:34:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757453643;
	bh=yEzIH3J5Hyl2D83PVCYv9hjOy9qcEjt9UF4xHoVPrF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tp4gFKQp5UNVTzP2x0WuYNBPzSwySp75ZEBBh3ligXxZpg5tBsBuqMp94b5eyaLbH
	 bsU8vUDfdgUJAemYlEf5Oek5LMG/KXAuOYxmK2xda4JZPCCpj8oWhvh24jLTMjwpbU
	 RwfDxi7J33wT/xj6tSOC04q1FUskX10qi4XMPDmUO65rX2Z8z9Ta2C2igtv7e5SLmp
	 WRzIu6rQjc885HUbY5g+bpjYe3MbRs2wQHhdXbT8hTtdE2SGJqGrQ98wT4s+L3Ty9g
	 /Y6nEt+mvpFJ5RDlHusxMqlOyfoWloa3DVTtPzqCLceNmoJho88WKaupA/NmvXonUN
	 AujuwsQpOGZpg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B65C4602C8;
	Tue,  9 Sep 2025 23:34:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757453642;
	bh=yEzIH3J5Hyl2D83PVCYv9hjOy9qcEjt9UF4xHoVPrF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RMTrC+4XnFN39k5zb0ZLZCPem47/zjpS0cS7W7/xCVu00MHd19o2AKUrb11btCBnk
	 yqs6yyqrCXEbXZqHSUQGRQUZ/CNDp1VSrufcG/GRFrsuMfmNwJGwsdwj/Ih2LbuMWk
	 Ws1BuJg29hhqQyRCUsKYoEB1Gd/fuLxFS+pR/DB5fuM/6MfAMnOwMaKOWMTZhb5pBH
	 +MwUCvZvrwlKUaCm9V+1ixnXsYAXIe3/mGryUx0AK1w0adJESdud0tuPNYMnCxeUtY
	 Oa7jXXM6lCNdkMyG8LwuG1Z3AiBgfWF24uuWePR9MIeEDqNCkEirJUuxegMQlgPNAj
	 fJs1AqLmc1Q4A==
Date: Tue, 9 Sep 2025 23:34:00 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
Subject: Re: [nft PATCH] fib: Fix for existence check on Big Endian
Message-ID: <aMCdSDWhxCJM_kjY@calendula>
References: <20250909204948.17757-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250909204948.17757-1-phil@nwl.cc>

Hi Phil,

On Tue, Sep 09, 2025 at 10:49:48PM +0200, Phil Sutter wrote:
> Adjust the expression size to 1B so cmp expression value is correct.
> Without this, the rule 'fib saddr . iif check exists' generates
> following byte code on BE:
> 
> |  [ fib saddr . iif oif present => reg 1 ]
> |  [ cmp eq reg 1 0x00000001 ]
> 
> Though with NFTA_FIB_F_PRESENT flag set, nft_fib.ko writes to the first
> byte of reg 1 only (using nft_reg_store8()). With this patch in place,
> byte code is correct:
> 
> |  [ fib saddr . iif oif present => reg 1 ]
> |  [ cmp eq reg 1 0x01000000 ]

Is this a generic issue of boolean that is using 1 bit?

const struct datatype boolean_type = {
        .type           = TYPE_BOOLEAN,
        .name           = "boolean",
        .desc           = "boolean type",
        .size           = 1,

> Fixes: f686a17eafa0b ("fib: Support existence check")
> Cc: Yi Chen <yiche@redhat.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/evaluate.c | 1 +
>  src/fib.c      | 4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 8cecbe09de01c..6a1aa4963bceb 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -3002,6 +3002,7 @@ static int expr_evaluate_fib(struct eval_ctx *ctx, struct expr **exprp)
>  	if (expr->flags & EXPR_F_BOOLEAN) {
>  		expr->fib.flags |= NFTA_FIB_F_PRESENT;
>  		datatype_set(expr, &boolean_type);
> +		expr->len = BITS_PER_BYTE;
>  	}
>  	return expr_evaluate_primary(ctx, exprp);
>  }
> diff --git a/src/fib.c b/src/fib.c
> index 5383613292a5e..4db7cd2bbc9c3 100644
> --- a/src/fib.c
> +++ b/src/fib.c
> @@ -198,8 +198,10 @@ struct expr *fib_expr_alloc(const struct location *loc,
>  		BUG("Unknown result %d\n", result);
>  	}
>  
> -	if (flags & NFTA_FIB_F_PRESENT)
> +	if (flags & NFTA_FIB_F_PRESENT) {
>  		type = &boolean_type;
> +		len = BITS_PER_BYTE;
> +	}
>  
>  	expr = expr_alloc(loc, EXPR_FIB, type,
>  			  BYTEORDER_HOST_ENDIAN, len);
> -- 
> 2.51.0
> 
