Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DCAD53C
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 13:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751548630; cv=none; b=VIdu4RiBlIv9D2yv+MsNTyypaBjsD10cApkMUk4MsUWVXuAScA03QKRtq/4ZCk/hKRs7SjPOEDyMvIL0WDHmfUMng54fM2jeug02q1Rra+aeFoYR/k6inzpSjBd65yM5yAUaMdJ93TdK9vO/E7pwy5U1fya1Vfv46qGnECgb2ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751548630; c=relaxed/simple;
	bh=fbcPT7CzHe3VlUsR3ErKFibdQaoI1wcH5yC3UtwGvCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5aocJfnbH9f55tj1rvuOBC/Efn34U4ATcBTxBqdWFPYakSbj1hVoG/mLvelyxokIORP8ahWFmnpRFFNM6EG0DU2H3InHMq5X2DiZJ0QWA+/Z5lu5Nq4s3Te6eA6paXW03QB26eXf6w9iN2Vepv9ru4n/cH2Fz8s1cWxAu0DXOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WDzgzWPW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WDzgzWPW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zEWYcm923HUSUTNlcu4S2KWl+bVR7+sVtuvpuIdvr3Y=; b=WDzgzWPWfFR7lULfI7KZ3dYHtp
	2See0rYhDn1V3VP2sjsyxckRoFUS2K6IlGzjy3rrwDH1tVcfYCLoxbL8OugPzzsTsGRZb9mrzf7GG
	kxGEkpDFFdUC7O41lh4bzBYp29MX5wL6ucGWFzmoQnDzRz98FXgeJ6z+4wwuHFSKwEwBikfO8M132
	uL0yRy4H36ORvie4/RZqhEutUyOoLx3ogIfylcBggy7fAESLfkgEbFp6Qhw2djN2pBDRj81xX947E
	fPPux6TzBkX4ET4D19WwhldAb/914CYddx0mMTij566hKkMpn0izhsmNsY2dX+2IQOwx//NaUk8Ct
	vB/9FD3g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uXJoI-000000000KB-3IH2;
	Thu, 03 Jul 2025 15:17:06 +0200
Date: Thu, 3 Jul 2025 15:17:06 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>
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
 <aGZ75G4SVuwkNDb9@orbyte.nwl.cc>
 <aGZ9jNVIiq9NrUdi@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGZ9jNVIiq9NrUdi@strlen.de>

On Thu, Jul 03, 2025 at 02:54:36PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > Do we need new query types for this?
> > > nftables could just query via rtnetlink if the device exists or not
> > > and then print a hint if its absent.
> > 
> > Hey, that's a hack! :P
> > Under normal circumstances, this should indeed suffice. The ruleset is
> > per-netns, so the kernel's view matches nft's. The only downside I see
> > is that we would not detect kernel bugs this way, e.g. if a new device
> > slipped through and was not bound. Debatable if the GETDEV extra effort
> > is justified for this "should not happen" situation, though.
> 
> Could the info be included in the dump? For this we'd only need a
> 'is_empty()' result.  For things like eth*, nft list hooks might be
> good enough to spot bugs (e.g., you have 'eth*' subscription, but
> eth0 is registed but eth1 isn't but it should be.

That may indeed be a simple solution avoiding to bloat
NEWFLOWTABLE/NEWCHAIN messages.

> In any case I think that can be added later.

Right now, NFTA_FLOWTABLE_HOOK_DEVS is just an array of NFTA_DEVICE_NAME
attributes. Guess the easiest way would be to introduce
NFTA_FLOWTABLE_HOOKLESS_DEVS array of NFTA_DEVICE_NAME attributes, old
user space would just ignore that second array.

Pablo, WDYT? Feasible alternative to the feature flag?

Thanks, Phil
