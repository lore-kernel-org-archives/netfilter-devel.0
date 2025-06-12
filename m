Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14FD230BC0;
	Thu, 12 Jun 2025 09:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749722226; cv=none; b=fSbEarFnpYVdQ00YOBJEQNNmviMtlC3p1OIDqj35kWSXt/qQmnvCgSoxtOIRr9jyEHC5gUeg1HFFZhkB95RxCJ2yhQns+mCMojJFpo4+W7LgBDjAbD/hhk79Nu1tXDZ0R/dnkbRgYVRs8vhNbDX4a1VI1dLDYM7RAD0Qy+Dgae8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749722226; c=relaxed/simple;
	bh=HtBJuCR+jbPWq6Af+X7FE87SBUH8rnKx6F+BcOSUNQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JeNxRaDqDnxbCty5lHZ8MpdM9G4pVsSm9hgIDs7hB/MzTuwjQcWG6+0L0R/aANw428NWYxSzNKFcj3yGuSDAxRpb86vPACWx/eshKrs8eMgFrM9Fs/mZVYEDSilhqSCBhvlm+RpppgYMm80CdRuayOF6bkoabEVKSw9YzBFmznQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=eu1a7Ab1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="eu1a7Ab1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=i/QvLnz5MW2voyReZoXUCruy/swRTIE4Z9/jEV0M8E0=; b=eu1a7Ab1amC1IcVHxUuJeOez00
	IJme9bNoasJbXSBmsnxyP7+3wb7auJ2oC3ka0oE5dsVm4wUlGgTfcL5ndlE3TfLgtZbMH96uWLiOa
	55gx5AU0q+3CE55YK61Ck0rWRbX3jnygZVKon7zYIDYxfGn2U+YqX/9280e8iGUz2CBjZCbZmp3km
	AIzhf5A/xkMB6mCkA9vkl4CoJo/INaN6tueS5NPBYzwe8fTofRbC+P3FGzoDMUPh7007TwiKxZHX/
	WOXG7OowMUA9slUAGPYMCUOnOQhgAO+meT9YkKOVLWPskoO22XnPJeMKT7piSdWrvdimu3L0UEjAX
	eiK1nhwA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPeg7-000000004A9-3glK;
	Thu, 12 Jun 2025 11:56:59 +0200
Date: Thu, 12 Jun 2025 11:56:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Klaus Frank <vger.kernel.org@frank.fyi>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Lukas Wunner <lukas@wunner.de>,
	netfilter@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netdev@vger.kernel.org
Subject: Re: Status of native NAT64/NAT46 in Netfilter?
Message-ID: <aEqka3uX7tuFced5@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Klaus Frank <vger.kernel.org@frank.fyi>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Lukas Wunner <lukas@wunner.de>,
	netfilter@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netdev@vger.kernel.org
References: <w7bwjqyae36c6pqhqjmvjcrwtpny6jxjyvxzb2qzt7atjncxd2@gi4xhlyrz27b>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w7bwjqyae36c6pqhqjmvjcrwtpny6jxjyvxzb2qzt7atjncxd2@gi4xhlyrz27b>

Hi,

On Sun, Jun 08, 2025 at 08:37:10PM +0000, Klaus Frank wrote:
> I've been looking through the mailling list archives and couldn't find a clear anser.
> So I wanted to ask here what the status of native NAT64/NAT46 support in netfilter is?
> 
> All I was able to find so far:
> * scanner patches related to "IPv4-Mapped IPv6" and "IPv4-compat IPv6"
> * multiple people asking about this without replies
> * "this is useful with DNS64/NAT64 networks for example" from 2023 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7b308feb4fd2d1c06919445c65c8fbf8e9fd1781
> * "in the future: in-kernel NAT64/NAT46 (Pablo)" from 2021 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=42df6e1d221dddc0f2acf2be37e68d553ad65f96
> * "This hook is also useful for NAT46/NAT64, tunneling and filtering of
> locally generated af_packet traffic such as dhclient." from 2020 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8537f78647c072bdb1a5dbe32e1c7e5b13ff1258
> 
> It kinda looks like native NAT64/NAT46 was planned at some point in time but it just become quite silent afterwards.
> 
> Was there some technical limitation/blocker or some consensus to not move forward with it?

Not to my knowledge. I had an implementation once in iptables, but it
never made it past the PoC stage. Nowadays this would need to be
implemented in nf_tables at least.

I'm not sure about some of the arguments you linked to above, my
implementation happily lived in forward hook for instance. It serves
well though in discovering the limitations of l3/l4 encapsulation, so
might turn into a can of worms. Implementing the icmp/icmpv6 translation
was fun, though!

> I'm kinda looking forward to such a feature and therefore would really like to know more about the current state of things.

AFAIK, this is currently not even planned to be implemented.

Cheers, Phil
