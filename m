Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D633563DA
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 18:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761762690; cv=none; b=ZdsGbvTbdffD/Exkfoaj8au1zF1d/+6LHJCZ0+vrHbsFqN1yD5Wsw91QlD5108KKsx74D42VkGJa4pTgk3QUhL8NRFNm/pN2pRnZvEBPSsdaYdMIjtr2yvkLyhIqgzNKJtSDzlsYAPVfojmkzevAdOKne00dTWlbemSUzpahkOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761762690; c=relaxed/simple;
	bh=LLFxuUs/dG85T2fGQxEtalez5axYMRKoeA1T1NqXC/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sz/QzcRagjywJyGbNvX3hdhiN783y2NoXLbzcWRvL25HZSWjr/STTSTEIGZUcHbW3WdvbFsfl8PLphkfuwV3/sgWAWGVRGbqMdzbBiysgZhRQQ0y5ZbHpShGtN0cyUbUWZ0EdjEWK23ZIIrgiX3Q7oMNouLfgt1jw1yHGHzaORQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CD6rV48s; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CD6rV48s"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D93B76026F;
	Wed, 29 Oct 2025 19:31:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761762685;
	bh=1ovZrBbAdjpErEqunB7iOvAe0fLdf20RVzYL4cDcOIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CD6rV48su5Jt2cJugcUYW9zr/aqbfcezEBN+aUZxRzAP7iemWBwPW+GRiEV2zdxAq
	 NRH36DWQGkgA3Zr/7fZKrNqcy0rLxXh/Y8uLtHsgThQQdb3iziboaBOEDtECQZ42Pl
	 Mssr0w0vluNJpMJy3Q3hScHk+cxIeBzDbzw/Ds2utQ69UgsP2F4JsRTo+3VWVWM8FR
	 oOqSDgGGH/5vhqPcv7CZmmFnfO8QOHTj9STbEyyZ4xNF3qeS1M5II/qn2K6F7HYt2D
	 o/nPe6aIjQ4+d6jyLwxeOzEKxcv8EiS3wF3G/UiWGlRL5gQzhfVH3PzpVGIl1b07FG
	 qGoei4ddNkUwg==
Date: Wed, 29 Oct 2025 19:31:22 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 26/28] utils: Introduce expr_print_debug()
Message-ID: <aQJdejPMgrhyjeAT@calendula>
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-27-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251023161417.13228-27-phil@nwl.cc>

On Thu, Oct 23, 2025 at 06:14:15PM +0200, Phil Sutter wrote:
> A simple function to call in random places when debugging
> expression-related code.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/utils.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/utils.h b/include/utils.h
> index e18fabec56ba3..0db0cf20e493c 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -26,6 +26,15 @@
>  #define pr_gmp_debug(fmt, arg...) ({ if (false) {}; 0; })
>  #endif
>  
> +#define expr_print_debug(expr)					\
> +{								\
> +	struct output_ctx octx = { .output_fp = stdout };	\
> +	printf("%s:%d: ", __FILE__, __LINE__);			\
> +	printf("'" #expr "' type %s: ", expr_name(expr));	\
> +	expr_print((expr), &octx);				\
> +	printf("\n");						\
> +}

Where is the first user of this? Better add and add users to improve
tracking when looking at git annotate?

> +
>  #define __fmtstring(x, y)	__attribute__((format(printf, x, y)))
>  #if 0
>  #define __gmp_fmtstring(x, y)	__fmtstring(x, y)
> -- 
> 2.51.0
> 
