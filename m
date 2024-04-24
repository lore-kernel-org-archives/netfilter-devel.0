Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E64FA160794
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713972028; cv=none; b=b5FD2ACMsDZol2pySJhnkZsZ19rWhPmYxpEwlhjPEUjyz9NMd0bR1OTPnYztYhx6EkIAa04oiXKXJMdspmt8kHNK5X1Ry67yNmZoNyUpreUMGNLh8GJvZWqM4LCpRgA4GFf69HfSJqOMlERFng+vTmy4G6yWTDN6s7gPvT4MNe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713972028; c=relaxed/simple;
	bh=zxsJYaZjbBJx7J99K3d4Ymn/InuOOYM5rMvucsIrjbc=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bRECFQj/H4H+7h0NxLjCdZo69R3cnkT4LKbmC2WTCSUu2QQb3qxx3BnmAe5Hn/kUYadVk4o0Oj6f41ANhcq8gWJHHpSFuVkiCmNJ/arPp8tNOXbrl5q3GY1k8NJ1JF4Yy3I9Q8Fi8zHSzOCySlX8KQu4l/ElSiPwxYkVAZiXLw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 24 Apr 2024 17:20:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Alexander Kanavin <alex@linutronix.de>,
	netfilter-devel@vger.kernel.org, Khem Raj <raj.khem@gmail.com>
Subject: Re: [iptables][PATCH] configure: Add option to enable/disable
 libnfnetlink
Message-ID: <ZikjLzdb97ZS1muM@calendula>
References: <20240424122804.980366-1-alex@linutronix.de>
 <ZikA0v0PrvZBsqq6@orbyte.nwl.cc>
 <53acd1f2-92ed-4ea5-b7be-05d3a0f5b276@linutronix.de>
 <ZikeIC9v7J0z8GXa@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZikeIC9v7J0z8GXa@orbyte.nwl.cc>

On Wed, Apr 24, 2024 at 04:58:40PM +0200, Phil Sutter wrote:
> On Wed, Apr 24, 2024 at 04:11:59PM +0200, Alexander Kanavin wrote:
> > On 4/24/24 14:53, Phil Sutter wrote:
> > > Hi,
> > >
> > > On Wed, Apr 24, 2024 at 02:28:04PM +0200, Alexander Kanavin wrote:
> > >> From: "Maxin B. John" <maxin.john@intel.com>
> > >>
> > >> This changes the configure behaviour from autodetecting
> > >> for libnfnetlink to having an option to disable it explicitly.
> > >>
> > >> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> > >> Signed-off-by: Maxin B. John <maxin.john@intel.com>
> > >> Signed-off-by: Alexander Kanavin <alex@linutronix.de>
> > > The patch looks fine as-is, I wonder though what's the goal: Does the
> > > build system have an incompatible libnfnetlink which breaks the build?
> > > It is used by nfnl_osf only, right? So maybe introduce
> > > | AC_ARG_ENABLE([nfnl_osf], ...)
> > > instead?
> > 
> > The patch is very old, and I didn't write it (I'm only cleaning up the 
> > custom patches that yocto project is currently carrying). It was 
> > introduced for the purposes of ensuring build determinism and 
> > reproducibility: so that libnfnetlink support doesn't get quietly 
> > enabled or disabled depending on what is available in the build system, 
> > but can be reliably turned off or on.
> 
> Thanks for the explanation. I don't quite get how a build is
> deterministic if libnfnetlink presence is not, but OK.

IIRC, there are also dependencies on utils with libnfnetlink that
would need to be disabled too.

