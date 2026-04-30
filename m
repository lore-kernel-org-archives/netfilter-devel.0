Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E5936D9EC
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 06:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777529473; cv=none; b=ga9jkM1gUICq88Ww2zpQDfuQICP7DfD4UcwBR5+nTH0LVsKaoCXStnVdzulrc8mf2BRiQxe/+vearw8VXfCS2bjY8gjmi6fl6N7xviNjpS3fRCDG81vUhbRJ9jPurUuwZ3Hun40PbEZ0FuBfL/5nlJ4G3rzuw3CdLJiBqjqzc+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777529473; c=relaxed/simple;
	bh=H8zTKiaaZ4XCK5J3XTKDFGbezJpcGpBAiAeizwDhd9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QxmEfpJSCKmmMgJ1mC13biFmHc7Ovq+AVw9ANPIvt1dFYeNVD2oB4fa660RiKHZYCMP8SJZSdhefcrdDyXtapvRf2c566CddUyT/jIbPWLXieu6ioxkw2q0fhg9690pP0t8HOOqPbxclXm4tAlysdhI7r/pAm/rYeUE+AmxqWr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fc7yE3Ck; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fc7yE3Ck"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id AA7BC60181;
	Thu, 30 Apr 2026 08:11:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777529470;
	bh=UniIGOwle02YOvkSqGbwyJ2ga11T2yfkhaM/rXBG1LE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fc7yE3Ck2yv+ZIDDJoQ856DsxQRZ3QZeDIfaji2QBRAk4z287+U+1LyDaC3a+L2Ct
	 TG0oSeC2u48nGvzvvKfSg0ns5MGEGxINBcBHbxnYdptmk1KW0LtvIKrhQ1ocB56ssO
	 ML46NArbfBKIVQxq3NdWLAkl2munMgnP/9+TprxEjHaW9xcB6hrF8mfO0MoOQ14lJi
	 Q2Qw6cLJFXz7I8y6jlJlpLMfZWgXcwSNdhMNBmWp79hJ0NK1IqjRnzQ+yzGJ5B09Fg
	 541ptKMa2PNbd6DPcr3SABX0M28zgL/JsqHzWOQWBbPLY5pF+4TD+FiypZAqtOHe8p
	 19rA4SCP8dPUw==
Date: Thu, 30 Apr 2026 08:11:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	jeremy@azazel.net, phil@nwl.cc, fw@strlen.de
Subject: Re: [PATCH nf v4] netfilter: nft_bitwise: fix dst corruption in same
 register shifts
Message-ID: <afLye0knzKl5IdrY@chamomile>
References: <20260427092117.4160-2-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260427092117.4160-2-fmancera@suse.de>

On Mon, Apr 27, 2026 at 11:21:18AM +0200, Fernando Fernandez Mancera wrote:
> For lshift and rshift, the shift operations are performed in a loop over
> 32-bit words. The loop calculates the shifted value and write it to dst,
> and then immediately reads from src to calculate the carry for the next
> iteration. Because src and dst could point to the same memory location,
> the carry is incorrectly calculated using the newly modified dst value
> instead of the original src value.
> 
> Adding a temporary local variable to cache the original value before
> writing to dst and using it for the carry calculation solves the
> problem. In addition, partial overlap is rejected from control plane for
> all kind of operations. This was tested with the following bytecode:
> 
> table test_table ip flags 0 use 1 handle 1
> ip test_table test_chain use 3 type filter hook input prio 0 policy accept packets 0 bytes 0 flags 1
> ip test_table test_chain 2
>   [ immediate reg 1 0x44332211 0x88776655 ]
>   [ bitwise reg 1 = ( reg 1 << 0x08000000 ) ]
>   [ cmp eq reg 1 0x66443322 0x00887766 ]
>   [ counter pkts 0 bytes 0 ]
> ip test_table test_chain 4 3
>   [ immediate reg 1 0x44332211 0x88776655 ]
>   [ bitwise reg 1 = ( reg 1 << 0x08000000 ) ]
>   [ cmp eq reg 1 0x55443322 0x00887766 ]
>   [ counter pkts 21794 bytes 1917798 ]
> 
> Fixes: 567d746b55bc ("netfilter: bitwise: add support for shifts.")
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
> v2: handled partially register overlap
> v3: reject partially overlap from control plane
> v4: applied the partial overlap check to all operations
> ---
>  net/netfilter/nft_bitwise.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
> index 13808e9cd999..76e7ae96429d 100644
> --- a/net/netfilter/nft_bitwise.c
> +++ b/net/netfilter/nft_bitwise.c
> @@ -43,8 +43,10 @@ static void nft_bitwise_eval_lshift(u32 *dst, const u32 *src,
>  	u32 carry = 0;
>  
>  	for (i = DIV_ROUND_UP(priv->len, sizeof(u32)); i > 0; i--) {
> -		dst[i - 1] = (src[i - 1] << shift) | carry;
> -		carry = src[i - 1] >> (BITS_PER_TYPE(u32) - shift);
> +		u32 tmp_src = src[i - 1];
> +
> +		dst[i - 1] = (tmp_src << shift) | carry;
> +		carry = tmp_src >> (BITS_PER_TYPE(u32) - shift);
>  	}
>  }
>  
> @@ -56,8 +58,10 @@ static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
>  	u32 carry = 0;
>  
>  	for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
> -		dst[i] = carry | (src[i] >> shift);
> -		carry = src[i] << (BITS_PER_TYPE(u32) - shift);
> +		u32 tmp_src = src[i];
> +
> +		dst[i] = carry | (tmp_src >> shift);
> +		carry = tmp_src << (BITS_PER_TYPE(u32) - shift);
>  	}
>  }
>  
> @@ -244,6 +248,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
>  			    const struct nlattr * const tb[])
>  {
>  	struct nft_bitwise *priv = nft_expr_priv(expr);
> +	unsigned int n;
>  	u32 len;
>  	int err;
>  
> @@ -264,6 +269,12 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
>  	if (err < 0)
>  		return err;
>  
> +	n = DIV_ROUND_UP(priv->len, sizeof(u32));
> +	if (priv->sreg != priv->dreg &&
> +	    priv->dreg < priv->sreg + n &&
> +	    priv->sreg < priv->dreg + n)
> +		return -EINVAL;

In some cases, there is also sreg2 that probably needs to be handled
too.
