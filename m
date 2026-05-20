Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7043D6688
	for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2026 12:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779279193; cv=none; b=PeXeDGnYTuerwyd6UUvkWBuxfn6PmTd9h70VF13uBhiwWJweM4DrkKEFoxQeC2F3niijc/otIW7TGdOq8neGn+Z/wAC4JzggLu5Z9fxHVY4aWm8/Ld0c+CrS88rQXssuF90XBhKeBThpggAlpnU7SU7IQiD3J6z4lK6rDVhrYZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779279193; c=relaxed/simple;
	bh=FPYax10ayg5g0n7U5MGy7J81gsjYsirJmSzTZE5H+1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RXk4iiCNPkp7afOOkBTFBn7V1btr0xi1bNEHNFePHBl+bZjYB6/PpV0FtFHAHMQMfol/k52jy+0mt4ME7PndXPqMQcZigjElhG7+7FvdfNWSFH4jsxfjhSv8zit4Urb81FUFoWb1CtOVGSUJWSheElPj0JL7yDpYF5Ei1V6GgLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHiktToe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHiktToe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514B91F000E9;
	Wed, 20 May 2026 12:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779279191;
	bh=q+QCfZWc1gUgR+daeRrXmb+ID4OyFjgt/3NaFsqRDDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KHiktToeUTDRjs0zHti9AKZKIUG/seZ3zAfYEazxKKGvwfkTEfdVQj6AXcpGZFzaN
	 TJY/sCjYqLkXryH7/VWH/CIoPHOvWHLEL1Ed3owhWBmmWDswLWykMueRDt2FrMXXGY
	 T2UIn1bYQnbzY6DdWg5etGenbxg1QoUk7Qorp2wI=
Date: Wed, 20 May 2026 14:13:15 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Igor Garofano <igorgarofano@gmail.com>
Cc: security@kernel.org, pablo@netfilter.org, fw@strlen.de,
	netfilter-devel@vger.kernel.org
Subject: Re: [SECURITY] nft_byteorder: incorrect u32* stride in 64-bit
 byteorder eval leading to firewall bypass
Message-ID: <2026052028-grain-pencil-0d8b@gregkh>
References: <CAOOOOYyfpwO7inyq2wXtpT0kY0s19-n4OZf2MCR62WRi7vzMMg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOOOOYyfpwO7inyq2wXtpT0kY0s19-n4OZf2MCR62WRi7vzMMg@mail.gmail.com>

On Tue, May 19, 2026 at 07:42:15PM +0200, Igor Garofano wrote:
> SUMMARY
> =======
> 
> A logic error in nft_byteorder_eval() causes incorrect byteorder conversion
> for 64-bit (size=8) operations in nftables. The source register is indexed
> using a u32* pointer (4-byte stride) while nft_reg_load64() reads 8 bytes,
> causing overlapping reads for any priv->len > 8. The result is that bytes
> are swapped from the wrong positions, leading to incorrect packet matching
> decisions.
> 
> This can be exploited by a remote attacker to bypass nftables firewall rules
> that use 64-bit byteorder expressions, without requiring any privilege on
> the
> target system.
> 
> 
> AFFECTED VERSIONS
> =================
> 
> Confirmed affected: Linux 6.19.13 (net/netfilter/nft_byteorder.c)

6.19.y is end-of-life, have you tried the latest 7.1-rc4 release?

> PROPOSED FIX
> ============
> 
> Cast source pointer to u64* before the size=8 loop to obtain correct
> 8-byte stride, matching the destination pointer type:
> 
> --- a/net/netfilter/nft_byteorder.c
> +++ b/net/netfilter/nft_byteorder.c
> @@ -39,19 +39,21 @@ void nft_byteorder_eval(const struct nft_expr *expr,
>         switch (priv->size) {
>         case 8: {
>                 u64 *dst64 = (void *)dst;
> +               u64 *src64 = (void *)src;
>                 u64 src_val;
> 
>                 switch (priv->op) {
>                 case NFT_BYTEORDER_NTOH:
>                         for (i = 0; i < priv->len / 8; i++) {
> -                               src64 = nft_reg_load64(&src[i]);
> +                               src_val = nft_reg_load64((u32 *)&src
>                                 nft_reg_store64(&dst64[i],
> -                                               be64_to_cpu((__force
> +                                               be64_to_cpu((__force
> __be64)src_val));
>                         }
>                         break;
>                 case NFT_BYTEORDER_HTON:
>                         for (i = 0; i < priv->len / 8; i++) {
> -                               src64 = (__force __u64)
> -
> cpu_to_be64(nft_reg_load64(&src[i]));
> +                               src_val = (__force __u64)
> +                                       cpu_to_be64(nft_reg_load64((u32
> *)&src64[i]));
>                                 nft_reg_store64(&dst64[i], src64);
>                         }
> +                               nft_reg_store64(&dst64[i], src_val);
>                         break;
>                 }
>                 break;
> 

Can you turn this into a real patch that can be applied so you get full
credit for resolving this issue?

thanks,

greg k-h
