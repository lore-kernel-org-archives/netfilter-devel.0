Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA392ECD0E
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 14:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553233; cv=none; b=gVj5Gv4L1Zo1L4xK8uXSc8FzPk0USRObo/cvk19DTr9YPk/uXIGPpKmompdEbwE5rXriJfqKL5XKkoVPNTEVcgS9tO0gX2KP5sNBPvG3A6jpsRP6EroOg0nqfqcDHM3aM2NkL1sSU3D6T3zfHmjqiJ/gAa2eR9cs54CyjMeHB+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553233; c=relaxed/simple;
	bh=wNo5wNxuw/E2wpZ44JKM5Zu77IK2pRnbmEiBdShG2vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mS/LTFFv/ICDobc8//5gb5odFlfavvus5g/b7vRe+NxlrYge3Cpt8hndoC9YNQ1DfHozoGRlvBe7r1pWWJ/aZ9aYQ5g/X7NgDj/FtWX5LJ/rXcnh2Bt61suEcztVCaxlAxuJ2nNDn4map5+zo3NsWNmblWYHbKYeHq3/C5w6KnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Sgc4Kms2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Sgc4Kms2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Y+5LMV4BjgStPoAwAMvaqss3KYKt6IO1QIIEcCMogRc=; b=Sgc4Kms2pl7yyCUCi6mtZSJeUl
	ETGagyP1vex/gVtUG3iG3vNg8jnVzlrR2g374o9i6j4yjTI8UVh81IVwp9+mL3aM55NDHdjDaw/kC
	fKOAB86J4A0YNQTkAEk17V90rKpxEW2Y6pkbORa8YClcBZllUq+AOhtr6HenC6Bp62s1IIiLdShz9
	Z9DVxR3xWPh2dufBpwxC7ZkIXZpKqu+TqRDlFnFm2Y4px+BVAmOK9/o5s7sr21xOsQSoBlItohWnF
	HNmolBf4pA5TomxbTQ0ocDBSj9dqBF+O1gBGoYW26QcO3j7tl8uR+P0UDVLAVRVLSTu/ZRRsbcmTd
	MwxEbPQw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uXL0X-000000001L1-1nD5;
	Thu, 03 Jul 2025 16:33:49 +0200
Date: Thu, 3 Jul 2025 16:33:49 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250702174725.11371-1-phil@nwl.cc>
 <aGW1JNPtUBb_DDAB@strlen.de>
 <aGZZnbgZTXMwo_MS@orbyte.nwl.cc>
 <aGZrD0paQ6IUdnx2@calendula>
 <aGZ21NE61B4wdlq8@orbyte.nwl.cc>
 <aGZ6E0k0AyYMiMvp@strlen.de>
 <aGZ75G4SVuwkNDb9@orbyte.nwl.cc>
 <aGZ9jNVIiq9NrUdi@strlen.de>
 <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>
 <aGaRaHoawJ-DbNUl@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGaRaHoawJ-DbNUl@calendula>

On Thu, Jul 03, 2025 at 04:19:20PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jul 03, 2025 at 03:17:06PM +0200, Phil Sutter wrote:
> > On Thu, Jul 03, 2025 at 02:54:36PM +0200, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > > Do we need new query types for this?
> > > > > nftables could just query via rtnetlink if the device exists or not
> > > > > and then print a hint if its absent.
> > > > 
> > > > Hey, that's a hack! :P
> > > > Under normal circumstances, this should indeed suffice. The ruleset is
> > > > per-netns, so the kernel's view matches nft's. The only downside I see
> > > > is that we would not detect kernel bugs this way, e.g. if a new device
> > > > slipped through and was not bound. Debatable if the GETDEV extra effort
> > > > is justified for this "should not happen" situation, though.
> > > 
> > > Could the info be included in the dump? For this we'd only need a
> > > 'is_empty()' result.  For things like eth*, nft list hooks might be
> > > good enough to spot bugs (e.g., you have 'eth*' subscription, but
> > > eth0 is registed but eth1 isn't but it should be.
> > 
> > That may indeed be a simple solution avoiding to bloat
> > NEWFLOWTABLE/NEWCHAIN messages.
> > 
> > > In any case I think that can be added later.
> > 
> > Right now, NFTA_FLOWTABLE_HOOK_DEVS is just an array of NFTA_DEVICE_NAME
> > attributes. Guess the easiest way would be to introduce
> > NFTA_FLOWTABLE_HOOKLESS_DEVS array of NFTA_DEVICE_NAME attributes, old
> > user space would just ignore that second array.
> 
> That is, new nftables binaries use NFTA_FLOWTABLE_HOOKLESS_DEVS.

If present, they will use that attribute to indicate that a given device
spec does not match any existing devices.

> > Pablo, WDYT? Feasible alternative to the feature flag?
> 
> If my understanding is correct, I think this approach will break new
> nft binary with old kernel.

If not present (old kernel), new nft would assume all device specs
matched an interface. I would implement this as comment, something like:
"# not bound: ethX, wlan*" which would be missing with old kernels.

Cheers, Phil
