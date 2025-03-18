Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77891F7076
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 23:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742340855; cv=none; b=DZo7zwWvt/zfMDbQdGffN1/NM3T9R9S9x/qGp938PKqBj7eslLLdzaKjd3F0kiISEjxDTEylxD2YCmtkhzUsIeTga8c8SzNSUdV7GM8A561FIceNTQ+WCmn1cHNtHIlZJhx2T2jQJ1CtZ9wRxt1K+pAodJ4ebe7Q99uMqw1yraw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742340855; c=relaxed/simple;
	bh=sMqnDAb5Ww133nrMyBv1Hupp5ENyItxQSE48eHD2G7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C3uT9uR1KfnxHBiSfQxsl0wrqd7M1y2adDQcUXX476pGDxFlaEdmWuJ+SJmr6yGBh0QfL6GnmMalqb5kwiAFAFNirflFuTg3Arf17i3Vwcn8MN15S8K3l8UO2XBQUDUSHeEgm5MD2n/F0aokkFNfqPEhxFggFydqzT6pwN4aq/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ao3C46yr; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=l+gAU1FE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ao3C46yr";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="l+gAU1FE"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 659056057D; Wed, 19 Mar 2025 00:34:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742340852;
	bh=4i2/JPZZ55R8JKKkAoF8OH6WKeB0YIk34qvSIpw+cEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ao3C46yrZzG3gh5X72WhODGacMLMb6u7a5EW9DBQ6K+6u3zn4Kd+EC1CCxr6WOghw
	 pOGydDdohdzEk/REWtM/Moif/JL4xPyQL5Kn9LUfQ14mqvAckOHUKbmhjkJ0VYPdut
	 4ZybDJwh/f2g3z+cTTZAxGVNTeCCGndFDE0Fj+4+19f6LXnu8ohQSKvcNXbe/9LYiP
	 rVv0NBDi3h0NaQGMa9gaKilMzZXEpXZXMy2ruT/Acpx2oXChJ0om9te3GVXiwhVNzj
	 X5jm/BkjfqatiXmlXMlsuulTuHp5XQpn4TwXy/i0IwaW9Jxqc78AMloy5EPqXmtGmL
	 qeUArh3Lc82yQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BDE5C6057D;
	Wed, 19 Mar 2025 00:34:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742340851;
	bh=4i2/JPZZ55R8JKKkAoF8OH6WKeB0YIk34qvSIpw+cEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l+gAU1FEwfy9VJhch5NNLzWeVz/qLVQNs5T6EGpL+Oda1PTQA38CIQdS/OLiaNZ+S
	 ly1xUgXccuaxu0O1++Tq3Ta9hjsg5ZAUJIGzgOtbuKM6JdQgp6R9BZ3yCK+k0cmkH9
	 2gHVhkRNioZOgu7zMPxWPOVVM2QH/4bvj4gDa7kA2lnAYCMWVFLPUK17mWRZLOzdTH
	 R8C0Ale2YpuMj8JbnDqDcnIeOwIAEf/eNrv/Y/MeVWdNVQLd1LDmpZXydJdX3SM/4m
	 TrvDCZaH6M5rU98Cfh4naRLxoi2iB2ptYhHFQAud/ssUG4cOqqmn3fsEI0q2ftzTu7
	 9xZ8Irbpz+K7w==
Date: Wed, 19 Mar 2025 00:34:09 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl] expr: fix new header name printing of payload
 expr
Message-ID: <Z9oC8SPzgjzmcIn1@calendula>
References: <20250318160204.49576-1-dzq.aishenghu0@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250318160204.49576-1-dzq.aishenghu0@gmail.com>

On Tue, Mar 18, 2025 at 04:02:04PM +0000, Zhongqiu Duan wrote:
> The debug printing of the payload expr shows the tunnel header name as
> unknown. Since after the first version we added two new payload bases
> inner and tunnel, I prefer to make this change to meet possible future
> extensions rather than setting NFT_PAYLOAD_TUN_HEADER as the new bound.

Thanks for catching this.

> Reproduce:
> 
> nft --debug netlink add rule inet t c meta l4proto udp vxlan vni 0x123456
> 
> Before patch:
>   ...
>   [ inner type 1 hdrsize 8 flags f [ payload load 3b @ unknown header + 4 => reg 1 ] ]

I can see a tests/py is already displaying unknown.

>   ...
> 
> After patch:
>   ...
>   [ inner type 1 hdrsize 8 flags f [ payload load 3b @ tunnel header + 4 => reg 1 ] ]
>   ...
> 
> Fixes: da49c1241474 ("src: expr: use the function base2str in payload")
> Fixes: 3f3909afd76d ("expr: add inner support")
> Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
> ---
>  src/expr/payload.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/expr/payload.c b/src/expr/payload.c
> index c3ac0c345aec..992c353423ef 100644
> --- a/src/expr/payload.c
> +++ b/src/expr/payload.c
> @@ -207,7 +207,7 @@ static const char *base2str_array[NFT_PAYLOAD_TUN_HEADER + 1] = {
>  
>  static const char *base2str(enum nft_payload_bases base)
>  {
> -	if (base > NFT_PAYLOAD_INNER_HEADER)
> +	if (base >= array_size(base2str_array) || !base2str_array[base])

Too defensive. Should be sufficient with:

	if (base >= array_size(base2str_array))

I don't expect array to be have an empty (unset) slot.

I can mangle and apply here, no need to resend.

Thanks.

>  		return "unknown";
>  
>  	return base2str_array[base];
> -- 
> 2.43.0
> 
> 
