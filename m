Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8082E8E0A
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 14:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751552367; cv=none; b=fG8/mLY3ahoS08tfVBnOy5V1qz4R+VK1dNBSa93/ncnmF0keiqxPa+pf0Ynj6u0ME1/YotllAz1mdXYeTeM6+7uV6bACqf5fDEhwhj3JKtKXv5W35v1Pgy1ZSIa+LBgy50grbfyW9+qVaeCYZyCRFxSwV8j4+ja8mE8+JF1Jdh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751552367; c=relaxed/simple;
	bh=NSycXXGKLRcxM0+LYSubaotJ1jDOgCFT6D56IMKicV4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b1o1c5ymS+dPb67Stj5xbZxTjlOFICkwcZvJSsoFQpoccO8alzbIWHK8pWHt5RoxUvumaBXR6XpC6d0jq8FXvEZHK4rwkbLsYHekUyXXV9bOLCP9ttozLhbva/06/tCymq3orD5gRsXHyQFTO1zv/te906Qj5W2pfHBP0+DCr6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CTG7roun; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CTG7roun; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CTG7roun";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CTG7roun"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E198B60293; Thu,  3 Jul 2025 16:19:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751552363;
	bh=x8rrNBuFHZVcYJIyC+ZCl+86Xr5qOjY6LFN4H1HRsNk=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=CTG7rounfzxwWLpBfZCkPfSmaFl6T93qoz6I4RsbRKVh5tB1jtB2kr0uzL486AyJL
	 1J+niAuxoItvoUf3KS5ihsrifjeQD5Y8gt/JVmBjUBPj2+sWKoi2F6HT4nb8Pku9Kf
	 /IOj3rbRy95lXYcT6DFWI6WwqZUtNYT5JqJsQHcEevCE6AdVqxiZ1YfXeNGkyE1klB
	 WspuC7jaM09LdM//b0D+5LQ4l2vhy9lz2m7THV0FJiexLgHQSbVPzYelwCUwa3i/YT
	 SkyKtMSCZzq8Djlt/mDwlJ3hGTGqI0Gf8OqKkuQcD6t4sfivpMII6YfhX/jfK34pz/
	 ooqQyHwPClQEA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EBEED6028E;
	Thu,  3 Jul 2025 16:19:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751552363;
	bh=x8rrNBuFHZVcYJIyC+ZCl+86Xr5qOjY6LFN4H1HRsNk=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=CTG7rounfzxwWLpBfZCkPfSmaFl6T93qoz6I4RsbRKVh5tB1jtB2kr0uzL486AyJL
	 1J+niAuxoItvoUf3KS5ihsrifjeQD5Y8gt/JVmBjUBPj2+sWKoi2F6HT4nb8Pku9Kf
	 /IOj3rbRy95lXYcT6DFWI6WwqZUtNYT5JqJsQHcEevCE6AdVqxiZ1YfXeNGkyE1klB
	 WspuC7jaM09LdM//b0D+5LQ4l2vhy9lz2m7THV0FJiexLgHQSbVPzYelwCUwa3i/YT
	 SkyKtMSCZzq8Djlt/mDwlJ3hGTGqI0Gf8OqKkuQcD6t4sfivpMII6YfhX/jfK34pz/
	 ooqQyHwPClQEA==
Date: Thu, 3 Jul 2025 16:19:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGaRaHoawJ-DbNUl@calendula>
References: <20250702174725.11371-1-phil@nwl.cc>
 <aGW1JNPtUBb_DDAB@strlen.de>
 <aGZZnbgZTXMwo_MS@orbyte.nwl.cc>
 <aGZrD0paQ6IUdnx2@calendula>
 <aGZ21NE61B4wdlq8@orbyte.nwl.cc>
 <aGZ6E0k0AyYMiMvp@strlen.de>
 <aGZ75G4SVuwkNDb9@orbyte.nwl.cc>
 <aGZ9jNVIiq9NrUdi@strlen.de>
 <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>

On Thu, Jul 03, 2025 at 03:17:06PM +0200, Phil Sutter wrote:
> On Thu, Jul 03, 2025 at 02:54:36PM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > > Do we need new query types for this?
> > > > nftables could just query via rtnetlink if the device exists or not
> > > > and then print a hint if its absent.
> > > 
> > > Hey, that's a hack! :P
> > > Under normal circumstances, this should indeed suffice. The ruleset is
> > > per-netns, so the kernel's view matches nft's. The only downside I see
> > > is that we would not detect kernel bugs this way, e.g. if a new device
> > > slipped through and was not bound. Debatable if the GETDEV extra effort
> > > is justified for this "should not happen" situation, though.
> > 
> > Could the info be included in the dump? For this we'd only need a
> > 'is_empty()' result.  For things like eth*, nft list hooks might be
> > good enough to spot bugs (e.g., you have 'eth*' subscription, but
> > eth0 is registed but eth1 isn't but it should be.
> 
> That may indeed be a simple solution avoiding to bloat
> NEWFLOWTABLE/NEWCHAIN messages.
> 
> > In any case I think that can be added later.
> 
> Right now, NFTA_FLOWTABLE_HOOK_DEVS is just an array of NFTA_DEVICE_NAME
> attributes. Guess the easiest way would be to introduce
> NFTA_FLOWTABLE_HOOKLESS_DEVS array of NFTA_DEVICE_NAME attributes, old
> user space would just ignore that second array.

That is, new nftables binaries use NFTA_FLOWTABLE_HOOKLESS_DEVS.

> Pablo, WDYT? Feasible alternative to the feature flag?

If my understanding is correct, I think this approach will break new
nft binary with old kernel.
