Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08DC2E62D8
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 12:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751547282; cv=none; b=rig6OntKm85C3wCEUKPDKdXTMdzrvMKPrMRxXEWLlEf9WJ+2T1oFjC+hKfofWIyhfOxtlNNiuxJzADKcZZoamYGTDF8RbFL67pP1WQ22jD+KSoqp8LIknBHfQhekTn4rd2vXdrWXAr/8jHWMChGIU5IEJEIjXRDcXYfp9S7y2g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751547282; c=relaxed/simple;
	bh=071Grlbvt4yoOuxqEX2bumtquiFtC5z4YViy8yAi0B8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SPxro8unDYNOeBAPvRtNwrAc5+EFktkRgJexfMtN1c6Lbq/Pj3vJN8tv3R9US9MZ9oKKPrlEp1Ze9z2fiCkEWNNNCgv9j9FpCtercT0h4haRMF1HB5ggTZS3Q8ZKoVdb6pR2ulu4mLPPitk0/JPQKAGKvn9ckLjkRk0XY4kNk7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 02C6D604A5; Thu,  3 Jul 2025 14:54:36 +0200 (CEST)
Date: Thu, 3 Jul 2025 14:54:36 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGZ9jNVIiq9NrUdi@strlen.de>
References: <20250702174725.11371-1-phil@nwl.cc>
 <aGW1JNPtUBb_DDAB@strlen.de>
 <aGZZnbgZTXMwo_MS@orbyte.nwl.cc>
 <aGZrD0paQ6IUdnx2@calendula>
 <aGZ21NE61B4wdlq8@orbyte.nwl.cc>
 <aGZ6E0k0AyYMiMvp@strlen.de>
 <aGZ75G4SVuwkNDb9@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGZ75G4SVuwkNDb9@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> > Do we need new query types for this?
> > nftables could just query via rtnetlink if the device exists or not
> > and then print a hint if its absent.
> 
> Hey, that's a hack! :P
> Under normal circumstances, this should indeed suffice. The ruleset is
> per-netns, so the kernel's view matches nft's. The only downside I see
> is that we would not detect kernel bugs this way, e.g. if a new device
> slipped through and was not bound. Debatable if the GETDEV extra effort
> is justified for this "should not happen" situation, though.

Could the info be included in the dump? For this we'd only need a
'is_empty()' result.  For things like eth*, nft list hooks might be
good enough to spot bugs (e.g., you have 'eth*' subscription, but
eth0 is registed but eth1 isn't but it should be.

In any case I think that can be added later.
