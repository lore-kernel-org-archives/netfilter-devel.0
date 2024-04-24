Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2160158A3D
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 14:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713970725; cv=none; b=Syww0xmhNmVISA98wI/rNLuatglfvDbYfP9RJoswZkiJnyrp8kvj5W5LQ5LTDB6JXr0HMlPZDaTU7g45XlNc5DH91JNYv+rnwTfNv+dV10AgEELUp27CxFT/onucIEbECj7eKRJJGiZlUjaSpsWaO5Df+Z9trp5lOGDRKIlSTtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713970725; c=relaxed/simple;
	bh=E+6WwcUWq7phjZC2YdYCC3qcV9+00I7KtQKpUIVWFts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E2YyP1TQFhYs/tMVfZyuRgHKRNKwA+b+eLUKonxRh8lU8QybrjWC6bZY+sEJL/SfsYRIuJXzJyMNBNVBx10I4Aezzjx2PGnvb6ec53PM04/Hke6Js2Tub3tDh1Rp0Ci3gWaNumyeW4cW8H0lDZ9Ud3UwUCOjF0IemCS89WoRvoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=K6tiUY5F; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="K6tiUY5F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=x/udrEiuSFQ/OiywGk3B4LDw8jTYoypRCdxhAj2lGf4=; b=K6tiUY5FeOZTbDA04auEtsVmai
	xqfFiAxlnECSYVtGbqog0+Add2wfgEqsVmdh3J/6+NuRBk2hE8DyQXLHA3GV0mcFnc95AhpL3VBtG
	8tilGpqXnISBLBwuwFLSut2gmmIqUnbFqyUgpvpZmrLNq3lUJnSW2+3Rdn0YlWJw4EdwrADA54w7e
	hoOw8WiMGpEiFovSaRXgIor2zGO9pli702mIImBOP7x0ajAMSYmic9ljCxH/i9VzEQ1wMbB9FFLzF
	JOOsSxS122AzKHHN6Eqj08EHqp9XTXfXWB7pMrHrSShS+Hrrp7Qsgiq6DW6auY34fzIHLxwdINaHY
	uYhJD2mQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rze52-000000007hN-2xTL;
	Wed, 24 Apr 2024 16:58:40 +0200
Date: Wed, 24 Apr 2024 16:58:40 +0200
From: Phil Sutter <phil@nwl.cc>
To: Alexander Kanavin <alex@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, Khem Raj <raj.khem@gmail.com>
Subject: Re: [iptables][PATCH] configure: Add option to enable/disable
 libnfnetlink
Message-ID: <ZikeIC9v7J0z8GXa@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexander Kanavin <alex@linutronix.de>,
	netfilter-devel@vger.kernel.org, Khem Raj <raj.khem@gmail.com>
References: <20240424122804.980366-1-alex@linutronix.de>
 <ZikA0v0PrvZBsqq6@orbyte.nwl.cc>
 <53acd1f2-92ed-4ea5-b7be-05d3a0f5b276@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53acd1f2-92ed-4ea5-b7be-05d3a0f5b276@linutronix.de>

On Wed, Apr 24, 2024 at 04:11:59PM +0200, Alexander Kanavin wrote:
> On 4/24/24 14:53, Phil Sutter wrote:
> > Hi,
> >
> > On Wed, Apr 24, 2024 at 02:28:04PM +0200, Alexander Kanavin wrote:
> >> From: "Maxin B. John" <maxin.john@intel.com>
> >>
> >> This changes the configure behaviour from autodetecting
> >> for libnfnetlink to having an option to disable it explicitly.
> >>
> >> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> >> Signed-off-by: Maxin B. John <maxin.john@intel.com>
> >> Signed-off-by: Alexander Kanavin <alex@linutronix.de>
> > The patch looks fine as-is, I wonder though what's the goal: Does the
> > build system have an incompatible libnfnetlink which breaks the build?
> > It is used by nfnl_osf only, right? So maybe introduce
> > | AC_ARG_ENABLE([nfnl_osf], ...)
> > instead?
> 
> The patch is very old, and I didn't write it (I'm only cleaning up the 
> custom patches that yocto project is currently carrying). It was 
> introduced for the purposes of ensuring build determinism and 
> reproducibility: so that libnfnetlink support doesn't get quietly 
> enabled or disabled depending on what is available in the build system, 
> but can be reliably turned off or on.

Thanks for the explanation. I don't quite get how a build is
deterministic if libnfnetlink presence is not, but OK.

The problem I see with the patch is the changed default behaviour. Could
you please retain the conditional build if neither --enable-libnfnetlink
nor --disable-libnfnetlink was specified?

> Note that we also carry a related patch which I didn't look at properly 
> yet, but can submit as well:
> 
> https://git.yoctoproject.org/poky/tree/meta/recipes-extended/iptables/iptables/0004-configure.ac-only-check-conntrack-when-libnfnetlink-.patch

Implementing the above might require adjustments in this one, so you
might want to hold back a bit.

Cheers, Phil
