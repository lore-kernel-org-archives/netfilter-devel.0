Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CD132C8B
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2025 09:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738922070; cv=none; b=sP+aZ/mmloBceGs/td2RGBBC/fhIBvdpv88XvgZoFEEqKj0G7ZOzbG4ngLx0uB8f+3s32fEmYNv65/99NmGpq0TzWgM2xWWTD8lQbpImgP0LmIET6YdYxgPMv1PO2yBUdUIJWd2guK2qGC7mgKsPJJ2Ll6FLp63F/rDmLJQeTAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738922070; c=relaxed/simple;
	bh=7UfNAcWlNNP2kUR42CqrbcLpxObvZW1AB3ZpYf1NOdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OcmRXqB10WiJq49+CgpqagWb6wUZ2i65Ke59/+CwXGsD14hGT72nhoIM4TTbysTsLWZOf9ypIL36BaHvDS+8SDuxtHKNS6VICzBqI7wTtHBZsQ1H95Ha0QsII9GMJW6tlP8MnNw4XkACYeb8nEktTxGkhcl95E33pAJOp0rqfSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LTHw4Ljj; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LTHw4Ljj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LTHw4Ljj";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LTHw4Ljj"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F027B6058E; Fri,  7 Feb 2025 10:54:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738922056;
	bh=jye69p3AG4xnT9kAHTBJoAP7Dp1tU8adp5YTVgywKW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LTHw4LjjsGMhWtyE7svTRW5SQUbjcCu9Jz/KrfJge33E8NRb0c6idjdC2KFqeXBk+
	 dni+51Yc+z3AZxV3xsPsQwucbaMwqAewdTBceIsIAlharAaLVuDkHjh200abst2JTV
	 SzYWFUSXKFIfMoi9dMTJ+L+wfpGXSf1LAPfxo75yiSnr/lKJqgALW5sGLVxX6DJnTP
	 +KlOdh4QU5tPKId4OG6Tc5DNUv+93gntnEamnys7U6DsABzbdTYWpB/qtCXBhs94Gi
	 9qJRB5TiSTzrfy1ACmOu6uX4JyKeXkl7doI0vjjy2kKh7ZMierTclUHzIcHaeML3bQ
	 MI7jTGHBlylnQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D99826058E;
	Fri,  7 Feb 2025 10:54:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738922056;
	bh=jye69p3AG4xnT9kAHTBJoAP7Dp1tU8adp5YTVgywKW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LTHw4LjjsGMhWtyE7svTRW5SQUbjcCu9Jz/KrfJge33E8NRb0c6idjdC2KFqeXBk+
	 dni+51Yc+z3AZxV3xsPsQwucbaMwqAewdTBceIsIAlharAaLVuDkHjh200abst2JTV
	 SzYWFUSXKFIfMoi9dMTJ+L+wfpGXSf1LAPfxo75yiSnr/lKJqgALW5sGLVxX6DJnTP
	 +KlOdh4QU5tPKId4OG6Tc5DNUv+93gntnEamnys7U6DsABzbdTYWpB/qtCXBhs94Gi
	 9qJRB5TiSTzrfy1ACmOu6uX4JyKeXkl7doI0vjjy2kKh7ZMierTclUHzIcHaeML3bQ
	 MI7jTGHBlylnQ==
Date: Fri, 7 Feb 2025 10:54:13 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Sunny73Cr <Sunny73Cr@protonmail.com>
Subject: Re: [PATCH nft 1/3] netlink_delinarize: fix bogus munging of mask
 value
Message-ID: <Z6XYRU-KObYW-w3M@calendula>
References: <20250130174718.6644-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250130174718.6644-1-fw@strlen.de>

On Thu, Jan 30, 2025 at 06:47:12PM +0100, Florian Westphal wrote:
> Given following input:
> table ip t {
>  chain c {
>   @ih,58,6 set 0 @ih,86,6 set 0 @ih,170,22 set 0
>  }
> }
> 
> nft will produce following output:
> chain c {
>  @ih,48,16 set @ih,48,16 & 0x3f @ih,80,16 set @ih,80,16 & 0x3f0 @ih,160,32 set @ih,160,32 & 0x3fffff
> }
> 
> The input side is correct, the generated expressions sent to kernel are:
> 
> 1  [ payload load 2b @ inner header + 6 => reg 1 ]
> 2  [ bitwise reg 1 = ( reg 1 & 0x0000c0ff ) ^ 0x00000000 ]
> 3  [ payload write reg 1 => 2b @ inner header + 6 .. ]
> 4  [ payload load 2b @ inner header + 10 => reg 1 ]
> 5  [ bitwise reg 1 = ( reg 1 & 0x00000ffc ) ^ 0x00000000 ]
> 6  [ payload write reg 1 => 2b @ inner header + 10 .. ]
> 7  [ payload load 4b @ inner header + 20 => reg 1 ]
> 8  [ bitwise reg 1 = ( reg 1 & 0x0000c0ff ) ^ 0x00000000 ]
> 9  [ payload write reg 1 => 4b @ inner header + 20 .. ]
> 
> @ih,58,6 set 0 <- Zero 6 bits, starting with bit 58
> 
> Changes to inner header mandate a checksum update, which only works for
> even byte counts (except for last byte in the payload).
> 
> Thus, we load 2b at offet 6. (16bits, offset 48).
> 
> Because we want to zero 6 bits, we need a mask that retains 10 bits and
> clears 6: b1111111111000000 (first 8 bit retains 48-57, last 6 bit clear
> 58-63).  The '0xc0ff' is not correct, but thats because debug output comes
> from libnftnl which prints values in host byte order, the value will be
> interpreted as big endian on kernel side, so this will do the right thing.
> 
> Next, same problem:
> 
> @ih,86,6 set 0 <- Zero 6 bits, starting with bit 86.
> 
> nft needs to round down to even-sized byte offset, 10, then retain first
> 6 bits (80 + 6 == 86), then clear 6 bits (86-91), then keep 4 more as-is
> (92-95).
> 
> So mask is 0xfc0f (in big endian) would be correct (b1111110000001111).
> 
> Last expression, @ih,170,22 set 0, asks to clear 22 bits starting with bit
> 170, nft correctly rounds this down to a 32 bit read at offset 160.
> 
> Required mask keeps first 10 bits, then clears 22
> (b11111111110000000000000000000000).  Required mask would be 0xffc00000,
> which corresponds to the wrong-endian-printed value in line 8 above.
> 
> Now that we convinced ourselves that the input side is correct, fix up
> netlink delinearize to undo the mask alterations if we can't find a
> template to print a human-readable payload expression.
> 
> With this patch, we get this output:
> 
>   @ih,48,16 set @ih,48,16 & 0xffc0 @ih,80,16 set @ih,80,16 & 0xfc0f @ih,160,32 set @ih,160,32 & 0xffc00000
> 
> ... which isn't ideal.  We should fixup the payload expression to display
> the same output as the input, i.e. adjust payload->len and offset as per
> mask and discard the mask instead.
> 
> This will be done in a followup patch.
> 
> Fixes: 50ca788ca4d0 ("netlink: decode payload statment")
> Reported-by: Sunny73Cr <Sunny73Cr@protonmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
