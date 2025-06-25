Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8313A1AA7A6
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Jun 2025 21:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750886370; cv=none; b=J+FVMUs2M4hdZDRRSoHXEF+C41nAWK+L19Ul8Mygf5E4lRbTO3ZyFCWN6aTUQIle2/ElY2GHPn8PSPmZvmCr0TclkrwYc7tVhmcw/OEO4/a5lYD6y53SBejhP5kmcCLLdVaoZXgaRMpU5HdpgDkPUk41vwCkzY1tPqzWKdpt3UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750886370; c=relaxed/simple;
	bh=TqGcmnxmVaZ1ZOzhFO4Jwazw7A1Xjmg31nwVphCmk2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=urK93EBhv3cOoFaQyP9UNxrDvgYd/tMV2qd0k+sSuk9y4X1C+WISrDUCjKahWZG4Mm5VnV/ealWrFede7I2N3l5eCjMb97YOooX1VT+6A8ELgr072zCJSq14wt96+OI8/Mxkdc8QZgISG6uPjtOx52+9ejdG4+uRmVrbzVjAU+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gsH6hy7i; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gsH6hy7i; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gsH6hy7i";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gsH6hy7i"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id BF80A6026B; Wed, 25 Jun 2025 23:19:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750886357;
	bh=DiB78aPSwVQwHvD+AxRInFdm4pbynDTSPZxTHPCeUo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gsH6hy7i9BJZC96vY1Dy2oo57zhzIq1MjNn6p1p1+yAAb/NuMKDoo8x+7TEVCOKhF
	 vk5epqwia5oC2SxSnPy2FDCPD1KSDx9zPoEmfW1xLGKkKqPaNsDWXTYPzMAypj42j/
	 zU6TbSqP0FrQAMoFKMklTuN+Z9js0PzpHc9lyhBm/zby6Wahx+M2cyaRa5xbPfWT6X
	 ZidbUL0xMXs7VLTca4v0i73tcOIrxtVF+KxdM1cSAU74lHmzqAj9L2Tav4mYFraEA8
	 DCHwyhnfkPxIQ9Fxrpa/v5qw4sTumRgiv4p6Hv9jptkPQkQN/alZ18PyQ2y2c3QsLt
	 GRp/C3+K4SmHw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2C7E26026B;
	Wed, 25 Jun 2025 23:19:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750886357;
	bh=DiB78aPSwVQwHvD+AxRInFdm4pbynDTSPZxTHPCeUo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gsH6hy7i9BJZC96vY1Dy2oo57zhzIq1MjNn6p1p1+yAAb/NuMKDoo8x+7TEVCOKhF
	 vk5epqwia5oC2SxSnPy2FDCPD1KSDx9zPoEmfW1xLGKkKqPaNsDWXTYPzMAypj42j/
	 zU6TbSqP0FrQAMoFKMklTuN+Z9js0PzpHc9lyhBm/zby6Wahx+M2cyaRa5xbPfWT6X
	 ZidbUL0xMXs7VLTca4v0i73tcOIrxtVF+KxdM1cSAU74lHmzqAj9L2Tav4mYFraEA8
	 DCHwyhnfkPxIQ9Fxrpa/v5qw4sTumRgiv4p6Hv9jptkPQkQN/alZ18PyQ2y2c3QsLt
	 GRp/C3+K4SmHw==
Date: Wed, 25 Jun 2025 23:19:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: make sure chain jump name comes with a
 null byte
Message-ID: <aFxn0pGPtSqp9lkH@calendula>
References: <20250624210118.27029-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250624210118.27029-1-fw@strlen.de>

On Tue, Jun 24, 2025 at 11:01:13PM +0200, Florian Westphal wrote:
> There is a stack oob read access in netlink_gen_chain():
> 
> 	mpz_export_data(chain, expr->chain->value,
> 			BYTEORDER_HOST_ENDIAN, len);
> 	snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", chain);
> 
> There is no guarantee that chain[] is null terminated, so snprintf
> can read past chain[] array.  ASAN report is:
> 
> AddressSanitizer: stack-buffer-overflow on address 0x7ffff5f00520 at ..
> READ of size 257 at 0x7ffff5f00520 thread T0
>     #0 0x00000032ffb6 in printf_common(void*, char const*, __va_list_tag*) (src/nft+0x32ffb6)
>     #1 0x00000033055d in vsnprintf (src/nft+0x33055d)
>     #2 0x000000332071 in snprintf (src/nft+0x332071)
>     #3 0x0000004eef03 in netlink_gen_chain src/netlink.c:454:2
>     #4 0x0000004eef03 in netlink_gen_verdict src/netlink.c:467:4
> 
> Reject chain jumps that exceed 255 characters, which matches the netlink
> policy on the kernel side.
> 
> The included reproducer fails without asan too because the kernel will
> reject the too-long chain name. But that happens after the asan detected
> bogus read.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
