Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8625D3A962D
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2026 11:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777029521; cv=none; b=YuGUq/o6ItzU+Y7M43Ik/6WrIAiLxxajhZkjXPrrCQ0aZl985mwsQscEG+Lk8w3cGK+jp+YZoh967yrwO8+76r0POOWDZU42XZjFjnciuQir1NTjUij3WV39ItnVkeJFYxk4KTF6OmQyQ9xzmVo6VqJr+Px1gNg5y6tDEQMGVUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777029521; c=relaxed/simple;
	bh=JHCdOl1O5TCcRorW5swJrMuzFPwFczv8rd44PrZkF4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tc1FrGg75IR0X4Obrk+04QzvJNXhA6bin63yHYfG5E7AxR1BFjzrru904hN/cFW3JO5wImpFk6aZOax7z5mMguekS0AwezVG7fLuVnXx65O0wu/Z6ByzXG0acQRrVAvv4tmIvpXOTnijzZlHMBVcCvK2gHG21B8OghPGyP2zO18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XvB2C3Ns; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XvB2C3Ns"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9F791600B5;
	Fri, 24 Apr 2026 13:18:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777029514;
	bh=hyKBmCiwm7cVJYTWuUsDM/MNW76xozDu9Pjo0IU6aD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XvB2C3Nsih2/S8e2l8T1ilxNjlr6WWi98GQckm1wd93AGuICsrrK4G7VqJhmXf+to
	 nTem8NXVXs4zSxNSjOFOjiGLaPr07F+j/F10jqpar/3Rswm9B+SqxY3HdXV1K73JoL
	 WLc9twsLpa1NDHI8UR/q5mBkix3CBNoXD7wT6ibQTjLtj2rq1IsH3IUOEZv4r47Wo0
	 GNqMgVufz4bw5TBDpTICSiFTenrUdvEjvfoilP7YUuxriHquWtK9SPCiEfFYKsHYud
	 /6iCUX4U0WXtlkqqu9UoO+LFTvbTD6VUJccz1fwiUoRTA/d0OGMuKc5cBlDtV1V5yO
	 /riwvzXSDZM4A==
Date: Fri, 24 Apr 2026 13:18:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	jeremy@azazel.net, phil@nwl.cc, fw@strlen.de
Subject: Re: [PATCH nf v3] netfilter: nft_bitwise: fix dst corruption in same
 register shifts
Message-ID: <aetRiG3x9S3PQHaw@chamomile>
References: <20260423155453.7499-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260423155453.7499-1-fmancera@suse.de>

Hi Fernando,

On Thu, Apr 23, 2026 at 05:54:53PM +0200, Fernando Fernandez Mancera wrote:
[...]
> @@ -201,6 +206,11 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
>  		return -EINVAL;
>  	}
>  
> +	if (priv->sreg != priv->dreg &&
> +	    priv->dreg < priv->sreg + n &&
> +	    priv->sreg < priv->dreg + n)

Is this enough? Just to make sure we are on the same page.

NFT_REG_1
NFT_REG_2
NFT_REG_3
NFT_REG_4

have a size of 128 bytes.

Then, NFT_REG32_00, NFT_REG32_01, NFT_REG32_02 and NFT_REG32_03
basically overlap with NFT_REG_1. They split the 128 bytes of
NFT_REG_1 in 4 registers of 32 bytes.

Is this check above enough to deal with the partial overlaps?

Thanks!

> +		return -EINVAL;
> +
>  	return 0;
>  }
>  
> -- 
> 2.53.0
> 
> 
