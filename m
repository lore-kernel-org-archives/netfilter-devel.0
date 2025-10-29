Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F218F3563E9
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 18:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761763000; cv=none; b=Czmd33D2tr3NvZlHGzkcaeayieyByeMX8ttYsNoNyEGv6BuPBuSi0eOQNLre/VH4lqv4fSAbNnPQByoizSD3oM0hl5+VqJXLTuuakOHTRF/tJAqWS+WEtXEat20KLdVVfAhIL3ZOHtwfVSUY48N1ONi9xWwOSUZ4fvUkQLXrGLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761763000; c=relaxed/simple;
	bh=Z57akTc+GyshA/4ul0bQZ/M6XviRNrZPld5Bs/xDAG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3UcLZUmKbOcYIpaXmeJhiUd92MGhZxedTwkZa83z3au3QvCK2yEMJNhGbbofNcfGup8mI+IIv9YaPuD9RwBDw3FHEziMoRqjN+bPQZ6nB85/nrp1Olxa39nK32pNLV1YP8WbN2gA44JIgIJzRWm13hBhl0t27xpuhjNvL+LxZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DdJ5dbxn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DdJ5dbxn"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 059F760281;
	Wed, 29 Oct 2025 19:36:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761762997;
	bh=hgTdDAnFuPC5BFnY4wkyCTZ0nveXF24LlVi42Zgt+Ps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DdJ5dbxn1S+s2KT6bD49O+6aIYVaH4VKMgJBRfcSwiVY05NJkloPKNYuA2z4P1Dcb
	 +4p09f1KbjwFT5oD8BFLFcvw8vsb8GxUhHei2Fd8WwA8uTTFRaDass4l6dh+1BJsXU
	 pF+CT9JkUMdpSD4CfOyskHrGvzqbn19yyaTlH420eRTTdkjBQ3iQq7XijvbC57dQ7M
	 JH198R6M1hWCVr8RYaRxIiQRvHyXJG6RQ/QA1TR5gU2tA9ZhchrxbSSfzWPrprlhLh
	 xUFTd1DLwevWxtcdxLxtsawMmOz5SMW/SiUdd7koduIUM1FXrDDyJGUkSh9tAsgCXR
	 kV2LHyh0uzXZA==
Date: Wed, 29 Oct 2025 19:36:34 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 10/28] datatype: Increase symbolic constant printer
 robustness
Message-ID: <aQJesgR0qPoO4SfP@calendula>
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-11-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251023161417.13228-11-phil@nwl.cc>

On Thu, Oct 23, 2025 at 06:13:59PM +0200, Phil Sutter wrote:
> Do not segfault if passed symbol table is NULL.

Is this a fix, or a cleanup?

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/datatype.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/src/datatype.c b/src/datatype.c
> index 7104ae8119ec6..55cd0267055bd 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -254,15 +254,19 @@ void symbolic_constant_print(const struct symbol_table *tbl,
>  	mpz_export_data(constant_data_ptr(val, expr->len), expr->value,
>  			expr->byteorder, len);
>  
> +	if (nft_output_numeric_symbol(octx) || !tbl)
> +		goto basetype_print;
> +
>  	for (s = tbl->symbols; s->identifier != NULL; s++) {
>  		if (val == s->value)
>  			break;
>  	}
> -
> -	if (s->identifier == NULL || nft_output_numeric_symbol(octx))
> -		return expr_basetype(expr)->print(expr, octx);
> -
> -	nft_print(octx, quotes ? "\"%s\"" : "%s", s->identifier);
> +	if (s->identifier) {
> +		nft_print(octx, quotes ? "\"%s\"" : "%s", s->identifier);
> +		return;
> +	}
> +basetype_print:
> +	expr_basetype(expr)->print(expr, octx);
>  }
>  
>  static void switch_byteorder(void *data, unsigned int len)
> -- 
> 2.51.0
> 
> 
