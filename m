Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CA11EB39
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2024 20:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719865899; cv=none; b=Cb56R9lRHuOnDJ8Jt3Wau6XARFJomCswsXjZqe76l0JEGPHXie+wdcYxcje0C+oAUh2qOANq4jeaQ8HHZFAg4UQNqaN0tC2mIINOqBQWyDll50tr6aL3N0049TTbq8Vf/3/xugv9fmnCn9JlP0oH//3zjcwqy8IKPoiT0sbkv2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719865899; c=relaxed/simple;
	bh=+stoQamm44/kd4v6B5EofwWu2uEGAyB33C3Jpw1cjpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J04vpC2WvyntiTJ0Sy/39EPKTmBOL723sD3UnF8MYQiXBgkbvlfI2GObQLqfNZ2eIGUdEXPQw9Fqcs9YuzRbt69ULWAFcj2yXkPkHt6b2TE3FyYmBhArvUi7eQ/IZ5jYwrtTd1nDYrTE4hIEsLy/FRh71Wseoj+3pVwy0N1zvMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [31.221.216.127] (port=3006 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sONgQ-00HLUw-3S; Mon, 01 Jul 2024 22:31:32 +0200
Date: Mon, 1 Jul 2024 22:31:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf-next 2/4] netfilter: nf_tables: allow loads only when
 register is initialized
Message-ID: <ZoMSIF0jVEe1ro5T@calendula>
References: <20240627135330.17039-1-fw@strlen.de>
 <20240627135330.17039-3-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240627135330.17039-3-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Thu, Jun 27, 2024 at 03:53:22PM +0200, Florian Westphal wrote:
> @@ -11105,8 +11107,8 @@ static int nft_validate_register_load(enum nft_registers reg, unsigned int len)
>  int nft_parse_register_load(const struct nft_ctx *ctx,
>  			    const struct nlattr *attr, u8 *sreg, u32 len)
>  {
> -	u32 reg;
> -	int err;
> +	int err, invalid_reg;
> +	u32 reg, next_register;
>  
>  	err = nft_parse_register(attr, &reg);
>  	if (err < 0)
> @@ -11116,11 +11118,36 @@ int nft_parse_register_load(const struct nft_ctx *ctx,
>  	if (err < 0)
>  		return err;
>  
> +	next_register = DIV_ROUND_UP(len, NFT_REG32_SIZE) + reg;
> +
> +	/* Can't happen: nft_validate_register_load() should have failed */
> +	if (WARN_ON_ONCE(next_register > NFT_REG32_NUM))
> +		return -EINVAL;
> +
> +	/* find first register that did not see an earlier store. */
> +	invalid_reg = find_next_zero_bit(ctx->reg_inited, NFT_REG32_NUM, reg);

Is this assuming that register allocation from userspace is done secuencially?

> +	/* invalid register within the range that we're loading from? */
> +	if (invalid_reg < next_register)
> +		return -ENODATA;
> +
>  	*sreg = reg;
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(nft_parse_register_load);
