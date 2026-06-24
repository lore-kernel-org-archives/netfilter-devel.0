Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A222DC789
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2026 23:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782344851; cv=none; b=BOvefTpy9i64L1kPdQ69oBfOAeUU21NIOa5imftSoB3CL9355JXNiWLs1hdTzHxbc+R5RQlhQFNHDKgBr+6HhliZgMtIdMAfSWh5IGmIgCwpkt4N6foDUcxTVkeirquYUmjq0uJ/GxXTrp3KGRSQN5TV+8hcsptiKgOkUMs45FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782344851; c=relaxed/simple;
	bh=Eg7w81MrscIE2wR7eJmlF6Dj9c8Uo1RO1HEegjZC5GE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WwqxLHfr0xvCqtcpRWKTdxS7TVVHDj6XjwbIwRVX12FolXtwmUIuwF33mcvaJ4tym2ac100lnpptHvjYbi/PXdoOPSvFl8M9+rlCOCqGykYT7oiDc5yMkCyRFU6kHaz8s8BBSsTaHYdqWU7hZBGIRl1mADq8f/HgUmmJAsVStjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9789F602A9; Thu, 25 Jun 2026 01:47:26 +0200 (CEST)
Date: Thu, 25 Jun 2026 01:47:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>,
	Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [BUG] netfilter: nft_fib: NULL-ptr-deref (GPF) in nft_fib6_eval
 on netdev egress hook
Message-ID: <ajxsjcDOnwllMfoR@strlen.de>
References: <CAEZyMPC0BQ=FO80mi3BVZaL4=T9y6=MYVL32St=Ck4w53hASqg@mail.gmail.com>
 <ajw7y1y7E8yyasOy@strlen.de>
 <ajxYxVLUjknoL2fg@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajxYxVLUjknoL2fg@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jun 24, 2026 at 10:19:23PM +0200, Florian Westphal wrote:
> > Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com> wrote:
> > > A `fib' expression in a netdev `egress' base chain dereferences the input
> > > device nft_in(pkt), which is NULL on the transmit path, so any IPv6 packet
> > > leaving the chain's device hits a GPF / KASAN NULL-ptr-deref. An unprivileged
> > > user can set this up in a user+net namespace.
> > 
> > Please just send a patch to disable fib on egress.
> 
> I'd suggest nft_fib_netdev needs a nft_fib_netdev_validate().
> 
> And nft_fib_validate() need to be restricted to NFPROTO_IPV4, _IPV6
> and _INET from ctx->family PoV.

Makes sense. Theodor, would you make a patch?
