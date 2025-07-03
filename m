Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F832F29
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 12:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751546857; cv=none; b=b49BOwssrTIXdxYD4JYs8ExjRsvJKd5yTIuQ7fXxRj374oATH25sjAnCPbjkbqOXYUr7yCyuwKXqzTwcdElcnGpm27q+mVx7aoUKUjAjK3Bl6aex7maU+ipFGtMXy1mYPsx7jSogPaEDPmYdM/WjP0iiu3SR8zsivie03fiIVS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751546857; c=relaxed/simple;
	bh=ScflClmnU/arD+fAdpy6fmia29wdfgYFVw+6avcIAXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q+DM1LTolw0jcmwQw44IWQB/axQS/nenGBkQuxsHGKtlNsg3nz4H2/PjEZPb1XyWB52g4o5lM4aOiqE2r4YnvEJGFrjZxPgaNzThWPTgMVjsKt3epc5neaaZbWkS+qJygCriEdPBCigRszYEsDCdMIFN7CdRVtMqLcp6mW1BUCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FXQO79/i; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FXQO79/i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=V2jQj+v6T+D54SOZ1r1m9T0i5KK5Ql9ArfSZm6eqbHQ=; b=FXQO79/iBsI+3dx6U+5T9m94nG
	673HTZ/eekWU84pgd8v358s1m1J59m1DOgqLROvEIBKuvBdRkX2I0YaY2Fm5+gaVz5D9xM5wzatYk
	m5PfOzc/3YUtqOHLse+56/dh8xvQ4sNrVhPV6C4Cyli6zhqeHUxabky2VXL6wiCuBwqcu5IjeNoKQ
	Pz/GYHgWYmweDcZfoBYmHf146CG2clgTDKlK26drvD4CMKD4MSu5wdG9FKyVIr1ZFxOFtLH3HpDRp
	NjUKlv/S0lS8CB1xeEqz4DxuLWIdXD2Q573bUM5V3URfQ+cVKIR7YR6Lmmi3qKArJPGhYeyAU6vrq
	xCPpzEQg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uXJLg-000000008Ny-1MoK;
	Thu, 03 Jul 2025 14:47:32 +0200
Date: Thu, 3 Jul 2025 14:47:32 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGZ75G4SVuwkNDb9@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250702174725.11371-1-phil@nwl.cc>
 <aGW1JNPtUBb_DDAB@strlen.de>
 <aGZZnbgZTXMwo_MS@orbyte.nwl.cc>
 <aGZrD0paQ6IUdnx2@calendula>
 <aGZ21NE61B4wdlq8@orbyte.nwl.cc>
 <aGZ6E0k0AyYMiMvp@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGZ6E0k0AyYMiMvp@strlen.de>

On Thu, Jul 03, 2025 at 02:39:47PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > personally wouldn't care about as I find it similar to mis-typing an IP
> > address or RHS to an iifname match.
> 
> Good point.  I think if performance isn't an issue then we can go ahead
> without this flag.
> 
> > If transparency of behaviour is a
> > concern, I'd rather implement GETDEV message type and enable user space
> > to print the list of currently bound interfaces (though it's partially
> > redundant, 'nft list hooks' helps there although it does not show which
> > flowtable/chain "owns" the hook).
> 
> Do we need new query types for this?
> nftables could just query via rtnetlink if the device exists or not
> and then print a hint if its absent.

Hey, that's a hack! :P
Under normal circumstances, this should indeed suffice. The ruleset is
per-netns, so the kernel's view matches nft's. The only downside I see
is that we would not detect kernel bugs this way, e.g. if a new device
slipped through and was not bound. Debatable if the GETDEV extra effort
is justified for this "should not happen" situation, though.

Cheers, Phil
