Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561BB143C4F
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 20:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713989675; cv=none; b=njh/mZnDGa5I+JoUnaASeX9Yk8huaTWo8waWsZZA+HhotjScXwb1GOmQP6VVVZ0LdF2Qz2d3LOLTHmav5uHwrBMjivQk2/ySs6cpS7ADgDHxR4BCdMPrsK3lCPqBA3CuURZbbyeHuvWS11lHxeByz87/BIcAxbr7LYlt6bPANQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713989675; c=relaxed/simple;
	bh=5KpTkWfCkLbosnnbyiLzeMS2aRzjR8aguzWVgccbRfA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=maArPSjQpRhz39CPwQkXizzwIE9nxgH7izT/cy2l+hNNmN/H+LtBjNIZa1TsKmO6LZsQm+DU0St1Tx+r29aihnViuYNPA5OkJoitxf6tGBwcMQ+cbDRC/XhgtwM9lIsdpCazF1+oSyrBVLEkZY+Pr0R5VOaPt5gcwpTAsz7MpbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 24 Apr 2024 22:14:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Alexander Kanavin <alex@linutronix.de>,
	netfilter-devel@vger.kernel.org, Khem Raj <raj.khem@gmail.com>
Subject: Re: [iptables][PATCH] configure: Add option to enable/disable
 libnfnetlink
Message-ID: <ZiloJYUAfVPHdYUO@calendula>
References: <20240424122804.980366-1-alex@linutronix.de>
 <ZikA0v0PrvZBsqq6@orbyte.nwl.cc>
 <53acd1f2-92ed-4ea5-b7be-05d3a0f5b276@linutronix.de>
 <ZikeIC9v7J0z8GXa@orbyte.nwl.cc>
 <ZikjLzdb97ZS1muM@calendula>
 <ZilQ4G2LzdU4ksEq@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZilQ4G2LzdU4ksEq@orbyte.nwl.cc>

On Wed, Apr 24, 2024 at 08:35:12PM +0200, Phil Sutter wrote:
> On Wed, Apr 24, 2024 at 05:20:15PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Apr 24, 2024 at 04:58:40PM +0200, Phil Sutter wrote:
> > > On Wed, Apr 24, 2024 at 04:11:59PM +0200, Alexander Kanavin wrote:
> > > > On 4/24/24 14:53, Phil Sutter wrote:
> > > > > Hi,
> > > > >
> > > > > On Wed, Apr 24, 2024 at 02:28:04PM +0200, Alexander Kanavin wrote:
> > > > >> From: "Maxin B. John" <maxin.john@intel.com>
> > > > >>
> > > > >> This changes the configure behaviour from autodetecting
> > > > >> for libnfnetlink to having an option to disable it explicitly.
> > > > >>
> > > > >> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> > > > >> Signed-off-by: Maxin B. John <maxin.john@intel.com>
> > > > >> Signed-off-by: Alexander Kanavin <alex@linutronix.de>
> > > > > The patch looks fine as-is, I wonder though what's the goal: Does the
> > > > > build system have an incompatible libnfnetlink which breaks the build?
> > > > > It is used by nfnl_osf only, right? So maybe introduce
> > > > > | AC_ARG_ENABLE([nfnl_osf], ...)
> > > > > instead?
> > > > 
> > > > The patch is very old, and I didn't write it (I'm only cleaning up the 
> > > > custom patches that yocto project is currently carrying). It was 
> > > > introduced for the purposes of ensuring build determinism and 
> > > > reproducibility: so that libnfnetlink support doesn't get quietly 
> > > > enabled or disabled depending on what is available in the build system, 
> > > > but can be reliably turned off or on.
> > > 
> > > Thanks for the explanation. I don't quite get how a build is
> > > deterministic if libnfnetlink presence is not, but OK.
> > 
> > IIRC, there are also dependencies on utils with libnfnetlink that
> > would need to be disabled too.
> 
> Within iptables, we only have nfnl_osf (in utils/) which depends on it,
> but missing HAVE_LIBNFNETLINK effectively disables it from being built.
> So unless you have something else in mind, that's fine with and without
> this patch.

That's fine then, thanks.
