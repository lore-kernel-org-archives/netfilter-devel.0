Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA8A215073
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Jul 2025 20:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751919306; cv=none; b=aD306y89NLkKR8FkVnbzhztARCc0OVaxY7jON4cNLTYit35FdRZPlcC3vuSzZ2C2thk9ylBkrVpyxYWacyBOJKA0/47Eh9ykSJktEFuf56KDJwgxm7QEDfm3sgEn1gzmYhBex6ubS6LDtv0cps7pnk1xpVNLSzItKfsfUOXI5sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751919306; c=relaxed/simple;
	bh=AujYnueSdjR3c6tc/R3Y3CYCFqK3k13pOrrLEKqiVqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JobX4j757gVjbNrAZKzfVzzdaUAWVcdxt/SR9KavzSscSjMfhROc46VgkKqN+8+OBnVGn8A2bW61eBVnkggsDdPKb9wCaoaUPYf28v+bZ4QfidF+40zEfgVYBq/FEGjrNyzZC/v1h0sJxLZZN6H0JV9ncs1OAuALy8wT9imJ2/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bP7HVS1b; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bP7HVS1b; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bP7HVS1b";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bP7HVS1b"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E479560279; Mon,  7 Jul 2025 22:15:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751919302;
	bh=bgCRjW0RG/R4cocoutFls54x7d6ahHt76s5twLZ612s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bP7HVS1bd7OK9Ge8hBgL29HzeXwmVT4Bsxl4OY2sTYlpXYtTL5kwgG8+EziltNkPd
	 C4GqQu3geOA4c+AdV+A9Zf3AAaSZ9wNhM3bhEqPijQxjWhqcrLfqCZzHLinvbg20A1
	 3xRy0Ulb6Qhjqv1xyB+ZEyUJWNEq/eoEed2R7WefY+5c08Xzj5y5remRINX5/PqOcZ
	 LCxTcMADUTUzKJ9FFPcLWEayq4Q5aQnZRKGfa64BhIVI9Q845Ro3KiykDtzBHnACEg
	 XBZceXBTf/BV3f7AcuVjzruQEt8EO/KCx5RQ1ZMZV4lDnMsq5s9TAeHeUpwxtKsvbw
	 fIHg6USJvoAJg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4799560279;
	Mon,  7 Jul 2025 22:15:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751919302;
	bh=bgCRjW0RG/R4cocoutFls54x7d6ahHt76s5twLZ612s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bP7HVS1bd7OK9Ge8hBgL29HzeXwmVT4Bsxl4OY2sTYlpXYtTL5kwgG8+EziltNkPd
	 C4GqQu3geOA4c+AdV+A9Zf3AAaSZ9wNhM3bhEqPijQxjWhqcrLfqCZzHLinvbg20A1
	 3xRy0Ulb6Qhjqv1xyB+ZEyUJWNEq/eoEed2R7WefY+5c08Xzj5y5remRINX5/PqOcZ
	 LCxTcMADUTUzKJ9FFPcLWEayq4Q5aQnZRKGfa64BhIVI9Q845Ro3KiykDtzBHnACEg
	 XBZceXBTf/BV3f7AcuVjzruQEt8EO/KCx5RQ1ZMZV4lDnMsq5s9TAeHeUpwxtKsvbw
	 fIHg6USJvoAJg==
Date: Mon, 7 Jul 2025 22:14:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/2] src: add conntrack information to trace monitor
 mode
Message-ID: <aGwqw6OVzDCJhb26@calendula>
References: <20250707094722.2162-1-fw@strlen.de>
 <aGwZ4MKAhUQWuGiL@calendula>
 <aGwf3dCggwBlRKKC@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aGwf3dCggwBlRKKC@strlen.de>

On Mon, Jul 07, 2025 at 09:28:29PM +0200, Florian Westphal wrote:
> diff --git a/src/trace.c b/src/trace.c
> index b270951025b8..b3b2c8fdf1b9 100644
> --- a/src/trace.c
> +++ b/src/trace.c
> @@ -264,7 +264,7 @@ static struct expr *trace_alloc_list(const struct datatype *dtype,
>         for (i = 0; i < 32; i++) {
>                 uint32_t bitv = v & (1 << i);
> 
> -               if (bitv == 0)
> +               if (bitv == 0 || i == IPS_UNTRACKED_BIT)
>                         continue;
> 
> and remove the IPS_UNTRACKED_BIT from the symbol table.
> 
> Then followup with a kernel patch that removes IPS_UNTRACKED_BIT before
> dumping ct->status.
> 
> Does that sound ok?

Yes, let's keep it back until there is a clear use-case for this,
either not exposing it or promoting it as a first class citizen.

> If so, I'll apply the first patch in this series before resending 2/2.

Thanks.
