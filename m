Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B9A29B78B
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2025 16:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750695725; cv=none; b=rS8kdb7pE2ju2dRzLW4pguXzOagTjEVFxrEDCcKw8i6ofvgWeQ63weKRGBVb2b2tpMFp5DRFvg5ZHNrEMf/eYnkJ0yA3InzBsnfTvdAy+TD2AmEy2Povf8DM4l+6TaFdh7lzZkzoCHjHhIePW5iziNgx5VXzgCH+MHhojjC3I3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750695725; c=relaxed/simple;
	bh=mjrx+OzhBULMtNg2tc3H7rVv0AUXmhm3T9iJM9vCTJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ScaIFvfb3a30MwlCYhA6/keamNvK9bmKXKg/uo8Phw49D6LEN1+iCcgy5jmseIGVwyvScAOgUqdHXnwi7n5vi9x7OPzHZfA4WcV/UT5Jxi+f3VPPFqSgi9zqTzQd4nLiM5+c5dHILrqdAPIHg9ajpudRFPf9eHh14evyE4RIUC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=B5sdHEEL; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LGJ4KaK4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="B5sdHEEL";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LGJ4KaK4"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 63F1A60278; Mon, 23 Jun 2025 18:21:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750695714;
	bh=UlNofn/YVd5qLkzzrfRNyJtNm8keT+QUdf9Z4uzpRq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B5sdHEELRRN9/qbj3ZltTW7YNBmpQZkkbn+h7XhYfXpTbyEHfFPMND926O/p3eERW
	 DhTWsGCcMHoMAy8R2B1mSBl8Va0PZvfavH0o6kvGnJz79QCxQen6EBguKH1DPkdK4E
	 mKP9T2SzXp5vuNUvShFzMDG5oAclGlsSAbKLddTbLO2d0fe0FtsGwnuWFw9ySJZElB
	 l2LfsgVzKhkLMiUMwOZHnLU08hT5SfL+slM8Cc1nN11MVvTxq8NL7Nh39qBHez8YFi
	 EuPFiGbjHzdva5zCa/r+0Ud3F8OyttssoIr+50Lf2hnvQuQLge4jvf1qNmwBYgVN2r
	 vk3hACDN+5mYQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 814DB60273;
	Mon, 23 Jun 2025 18:21:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750695713;
	bh=UlNofn/YVd5qLkzzrfRNyJtNm8keT+QUdf9Z4uzpRq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LGJ4KaK4V8EkSvm2h0Lfo8K3IL4CWnY3FteXxr21xRUmucnL2sTOTMwlm9AseWuqy
	 zS65RvFE6l9FeikuWvFx8B+1JNhcqTaX1nSwuqG2VvuZ0xV4cU3DJKIxKbh1TN0N/C
	 smfp49bUg/giX6tI+KepotLe7QGLeFGzOrVh61A28yi9Lf50bBy/50r1voq5Q2m3MO
	 RdL4tIyJyAtJkVyQEujQ877z3ZRrlUkAXhutqsGlvBpQUaMOGasABqVJb+3D36k1UX
	 4+ZUO7I6s/CZ/wXuWoXUj5PvGkGtOh1RNx6Iy+SvT5Bq1zomUwKeUvlDHy+mrRP6IU
	 KU3bcyuAmmPRg==
Date: Mon, 23 Jun 2025 18:21:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: refuse to merge set and map
Message-ID: <aFl_HmQG7vJZ1u9O@calendula>
References: <20250623132225.21115-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250623132225.21115-1-fw@strlen.de>

Hi Florian,

On Mon, Jun 23, 2025 at 03:22:13PM +0200, Florian Westphal wrote:
> Reject maps and sets of the same name:
>  BUG: invalid range expression type catch-all set element
>  nft: src/expression.c:1704: range_expr_value_low: Assertion `0' failed.
> 
> After:
> 8:6-6: Error: Cannot merge set with existing map of same name
>   set z {
>       ^
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/evaluate.c                                 | 11 +++++++++--
>  ...xpression_type_catch-all_set_element_assert | 18 ++++++++++++++++++
>  2 files changed, 27 insertions(+), 2 deletions(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_range_expression_type_catch-all_set_element_assert
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index c666705b23be..709580c2fffe 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -5273,8 +5273,15 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
>  		return 0;
>  	}
>  
> -	if (existing_set && set_is_interval(set->flags) && !set_is_interval(existing_set->flags))
> -		return set_error(ctx, set, "existing %s lacks interval flag", type);
> +
> +	if (existing_set) {
> +		if (set_is_interval(set->flags) && !set_is_interval(existing_set->flags))
> +			return set_error(ctx, set,
> +					 "existing %s lacks interval flag", type);
> +		if (set_is_map(existing_set->flags) != set_is_map(set->flags))

this helper is a bit confusing, it is hiding two type of maps:

static inline bool set_is_map(uint32_t set_flags)
{
        return set_is_datamap(set_flags) || set_is_objmap(set_flags);
}

then, I'd suggest

		if (set_is_datamap(existing_set->flags) != set_is_datamap(set->flags))
                        ...
		if (set_is_objmap(existing_set->flags) != set_is_objmap(set->flags))
                        ...

Thanks.

> +			return set_error(ctx, set, "Cannot merge %s with existing %s of same name",
> +					type, set_is_map(existing_set->flags) ? "map" : "set");
> +	}
>  
>  	set->existing_set = existing_set;
>  
> diff --git a/tests/shell/testcases/bogons/nft-f/invalid_range_expression_type_catch-all_set_element_assert b/tests/shell/testcases/bogons/nft-f/invalid_range_expression_type_catch-all_set_element_assert
> new file mode 100644
> index 000000000000..3660ac3fda9c
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/invalid_range_expression_type_catch-all_set_element_assert
> @@ -0,0 +1,18 @@
> +table ip x {
> +	map z {
> +		type ipv4_addr : ipv4_addr
> +		flags interval
> +		elements = { 10.0.0.2, * : 192.168.0.4 }
> +	}
> +
> +	set z {
> +		type ipv4_addr
> +		flags interval
> +		counter
> +		elements = { 1.1.1.0/24 counter packets 0 bytes 0,
> +			 * counter packets 0 bytes 0packets 0 bytes ipv4_addr }
> +		flags interval
> +		auto-merge
> +		elements = { 1.1.1.1 }
> +	}
> +}
> -- 
> 2.49.0
> 
> 
