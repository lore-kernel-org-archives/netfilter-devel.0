Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036AB1DE3A9
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Mar 2025 23:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742428238; cv=none; b=fMC3FzSSp3JXUBxlqL3CiIW6lE7qWLPWO2+tr4lVJ9eWzGUM37wXzbT+04654R/f+rd1hQNBPtB3g5zRaKlD1quEjsluzUHfr42/PFThREwU8+fljZFSmscVTYmuJSUs//253RSZJWjck2orU+ShRVJErqcd6Nz6mk4cGfzC7a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742428238; c=relaxed/simple;
	bh=GB6s7xsAh1rh1e8snAntYeh+RyqA4tmeQONc5KhahGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uW5sn+FUd0Kpm5xtpFddcSo8lqfDJfKb9EXJHob/Fq6IVbpLl3JWvRe7kr2uMWx60xGELeJMhYZIIqGj5IJ8p19evRgqR0qIGWLOQWF4C4dSeKspqahGR3En6Hv1QxwDk6uc51HEuoSAJJr0K35fPOPH8Com5+krO0RbuZVFCJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IPTkV53q; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FXvFEuxC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IPTkV53q";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FXvFEuxC"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 15E5D603C2; Thu, 20 Mar 2025 00:50:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742428232;
	bh=ZGqI94RBdlj7rytWdNeFwpGrzAvWosoxH1sQ2T4Cj+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IPTkV53qMXQ4Sw72Dq/EhtFdfRvs+P0IvB1TK4aD1tRM5KHog2+mZaaZLE7YjVyhx
	 z57FYmG9fTSPmwxfqzY+ARN/GkmQujVNsQoBHJC2MqO0SRtFvbmyx0S3uQh4xUIqlG
	 8Tbkyw4xfd3DjogDh3x/dH7zl6r6g2V9klvX/zmnWQ0jGrCiUY92WRpxIcShxk7o2o
	 EiOk3CwJNzmz1yqL7ZhZxAZ7moE6+/ra8tozn98Wrv+Op0WCIf9zL8P+2UthN7Nb9D
	 9xJNZ0sOMfRfe1AFMMXVFUmAJfAhP6ZJ6gB6NsxoM+5weGbtP9jdCk78NqWC7YQ9uJ
	 PJoG5ImAZ1ozQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 59B64603C2;
	Thu, 20 Mar 2025 00:50:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742428231;
	bh=ZGqI94RBdlj7rytWdNeFwpGrzAvWosoxH1sQ2T4Cj+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FXvFEuxC3udmYUev3yYt1Xrf6cxt/ifLTeXR5GZti4amDfsMlRi7L2K2UGSJ4MBj9
	 ySCBF/sOCYD3sElDkpm5bz5At6uj+J2vxSlLc13jJrpwOSEBcUfxmc+A4tdJIj1/ys
	 1e7ngQ1ILH+MBBDCsCRlcy5PSKcqL8SID9NXKMrwnW7qyGm6YFToOTlTx2VBZOufZu
	 xfDcF7q62Y65td2p5YrdsqTiFV9q3rcsn84wyvA+7dVnsvn6Ci+7un5V3B6PN8mhT3
	 miqsUY+jRXqsZuz/YTcqNo9Nz95F/5fBuGLDNm7SIa1+k6OZeLtUO8RWsnW7cbP8Fy
	 75dHOVKi65z4A==
Date: Thu, 20 Mar 2025 00:50:28 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] parser_bison: reject non-serializeable typeof
 expressions
Message-ID: <Z9tYRHnNO6SvjMQK@calendula>
References: <20250319162244.884-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250319162244.884-1-fw@strlen.de>

On Wed, Mar 19, 2025 at 05:22:40PM +0100, Florian Westphal wrote:
> Included bogon asserts with:
> BUG: unhandled key type 13
> nft: src/intervals.c:73: setelem_expr_to_range: Assertion `0' failed.
> 
> This should be rejected at parser stage, but the check for udata
> support was only done on the first item in a concatenation.
> 
> After fix, parser rejects this with:
> Error: primary expression type 'symbol' lacks typeof serialization

Maybe... otherwise, please correct me.

Fixes: 4ab1e5e60779 ("src: allow use of 'verdict' in typeof definitions")

> Signed-off-by: Florian Westphal <fw@strlen.de>

Thanks.

> ---
>  src/parser_bison.y                                 | 14 ++++++++++----
>  .../nft-f/typeof_map_with_plain_integer_assert     |  7 +++++++
>  2 files changed, 17 insertions(+), 4 deletions(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/typeof_map_with_plain_integer_assert
> 
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 4d4d39342bf7..cc3c908593a0 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -816,8 +816,8 @@ int nft_lex(void *, void *, void *);
>  
>  %type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
>  %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
> -%type <expr>			primary_expr shift_expr and_expr typeof_expr typeof_data_expr typeof_key_expr typeof_verdict_expr
> -%destructor { expr_free($$); }	primary_expr shift_expr and_expr typeof_expr typeof_data_expr typeof_key_expr typeof_verdict_expr
> +%type <expr>			primary_expr shift_expr and_expr primary_typeof_expr typeof_expr typeof_data_expr typeof_key_expr typeof_verdict_expr
> +%destructor { expr_free($$); }	primary_expr shift_expr and_expr primary_typeof_expr typeof_expr typeof_data_expr typeof_key_expr typeof_verdict_expr
>  %type <expr>			exclusive_or_expr inclusive_or_expr
>  %destructor { expr_free($$); }	exclusive_or_expr inclusive_or_expr
>  %type <expr>			basic_expr
> @@ -2142,7 +2142,7 @@ typeof_data_expr	:	INTERVAL	typeof_expr
>  			}
>  			;
>  
> -typeof_expr		:	primary_expr
> +primary_typeof_expr	:	primary_expr
>  			{
>  				if (expr_ops($1)->build_udata == NULL) {
>  					erec_queue(error(&@1, "primary expression type '%s' lacks typeof serialization", expr_ops($1)->name),
> @@ -2153,7 +2153,13 @@ typeof_expr		:	primary_expr
>  
>  				$$ = $1;
>  			}
> -			|	typeof_expr		DOT		primary_expr
> +			;
> +
> +typeof_expr		:	primary_typeof_expr
> +			{
> +				$$ = $1;
> +			}
> +			|	typeof_expr		DOT		primary_typeof_expr
>  			{
>  				struct location rhs[] = {
>  					[1]	= @2,
> diff --git a/tests/shell/testcases/bogons/nft-f/typeof_map_with_plain_integer_assert b/tests/shell/testcases/bogons/nft-f/typeof_map_with_plain_integer_assert
> new file mode 100644
> index 000000000000..f1dc12f699ec
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/typeof_map_with_plain_integer_assert
> @@ -0,0 +1,7 @@
> +table ip t {
> +        map m {
> +                typeof ip saddr . meta mark  . 0: verdict
> +                flags interval
> +                elements = { 127.0.0.1-127.0.0.4 . 0x00123434-0x00b00122 : accept }
> +        }
> +}
> -- 
> 2.48.1
> 
> 
