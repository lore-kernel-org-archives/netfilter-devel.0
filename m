Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9DC286415
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2026 22:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782339789; cv=none; b=keCSyD5SaEWj3NSYCJnUCsD1F+VF8AcSsaAz678AxHMxM3Xo4Oa8RYxzreyCDy9Pi9BMs/EbX++1gaEL9eZo+8GW/YCGwtjVKS4vzzqP/wPG0vCYOGuh5tSgloSfNfPMLJvojgLVJcA8rOvvT6jrSD46DtivaWsxkiuwb8QCmGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782339789; c=relaxed/simple;
	bh=VNKI7pdd8jLzyzKwkhtp1EcvPSOEDkU3Y3PBeHMsOH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KKDdq5v7TCCyPXDiurd5respHFfTC1T99xcdHPs6qDUeMvGN+LS5+lBI/7bBGtod5ufkOYcyY4JSFAWBIixPoL1JJm94lUdehTawCmjo3alblXk1hdkpfPBWkLYxJq3EAZAu7kNOqeTL2Q+WVCPJDogwyBldQQqBF0RuQeseQeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BQLgSzPH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BQLgSzPH"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B2F8860586;
	Thu, 25 Jun 2026 00:23:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782339783;
	bh=oN2jZF1afD8kNxKGFobqb1u8vUit9Hc+sdOqOWTDpSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BQLgSzPHdQKN6v3zQ1XkwL7KsnKjHVYD6UMGIKHt/zksAGgnLYtTcy2nCYi0TZRky
	 QLdZohZ0yIgd5QCZdxwk6/PDPbda54/TSaeJRuXWJfSnpVMrGnhzRKjnXD5vmNVArs
	 299k76w1VYfpDXZww1tRZTcqGdQ4fZqqhaKzRxaTkFT38H8R6nltsLLELEgJlESCec
	 v+qg3xjURx0sA8dtBJEJsdw77SEbBeusRklE/olemRTlJWQzbMVjaGp/kCHNzMeBYM
	 LrXQ9G0X0SKCnNfgBof7CnBHhNIw6DgZxDo0ZUJbEcOulQg+Ukbtf0thy6TpprJPiO
	 dQfsgcj0U8Ywg==
Date: Thu, 25 Jun 2026 00:23:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>,
	Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [BUG] netfilter: nft_fib: NULL-ptr-deref (GPF) in nft_fib6_eval
 on netdev egress hook
Message-ID: <ajxYxVLUjknoL2fg@chamomile>
References: <CAEZyMPC0BQ=FO80mi3BVZaL4=T9y6=MYVL32St=Ck4w53hASqg@mail.gmail.com>
 <ajw7y1y7E8yyasOy@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ajw7y1y7E8yyasOy@strlen.de>

On Wed, Jun 24, 2026 at 10:19:23PM +0200, Florian Westphal wrote:
> Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com> wrote:
> > A `fib' expression in a netdev `egress' base chain dereferences the input
> > device nft_in(pkt), which is NULL on the transmit path, so any IPv6 packet
> > leaving the chain's device hits a GPF / KASAN NULL-ptr-deref. An unprivileged
> > user can set this up in a user+net namespace.
> 
> Please just send a patch to disable fib on egress.

I'd suggest nft_fib_netdev needs a nft_fib_netdev_validate().

And nft_fib_validate() need to be restricted to NFPROTO_IPV4, _IPV6
and _INET from ctx->family PoV.
