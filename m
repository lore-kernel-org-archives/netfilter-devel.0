Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7ED31714A2
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 13:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723727418; cv=none; b=DJkWgyK2kQvaSSmC0tYtXoEuxCUvdJ4CkI7S5i4rLAnLDzz0N5yMT+/gIVeYm23pyRxNNLZ6CBZvUtShE311LohRlksvDOEzw3euAhRYJAAuiFuLW/eHDvQeCa8RHsJ3l4nRHzwXC5HaUpPWyvP9yjeOPlRe+JFUbpLpB91lKzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723727418; c=relaxed/simple;
	bh=y45NfZrgA6biPHBrudabtrJiSAt3G5AcUdeP4OMEiII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ogXsJcWwXaUvad10GEg5VGh4qNnWSqq6ElVM73n0TAioW5BV5iRYRekrhgPJdk3gplqzqG5zRA2Q7e7OBvxzdUeAF0ACQ04aq/JyhbiEx5H5iC8vjYBwegs+kaHoJkhm4U8f0fqcWCKxGgXvF1FH3tEoTXqM6JON8Y/pFoBaFxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VwssRSe9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VwssRSe9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yMkmpED/W70CbBjzU8ffsPoHnB0zKVbJK1zLHrcJm+o=; b=VwssRSe9tR+MRX312P/sKWhEOY
	zpGkjZLBV0cIgweLwQBGqmCfBaUXC5BQ0PLyYB9vkvhsitWK7FSz4YhEjpsFcFjfLyGhzlVPDAxmO
	GpI9owfw++EEBOpe2kI85x4fHN6qon483cBLCkitX6mgV8cP686kzWvwDx3Oe9XNymUhDiKDt6Nga
	7KXXkrV+kOIZBoOtmRXUefIFj4JzHfqWydBppMWaJbejbtI5dZ6dty96uZElOA6Pb0cKAvAa44dyv
	eUlYVCCdSvOdwWOeGORZMoPaDWbN0ccaHcoXXopwlFM2VxmPSN8Dz7Tmrg6SlnUPlzrsBfj+T4dhF
	KGU/yD6Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1seaF3-0000000010v-1a4d;
	Thu, 15 Aug 2024 15:10:13 +0200
Date: Thu, 15 Aug 2024 15:10:13 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de, eric@garver.life,
	fw@strlen.de
Subject: Re: [PATCH nft 0/5] relax cache requirements, speed up incremental
 updates
Message-ID: <Zr3-NdL1GCs-aPlR@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de,
	eric@garver.life, fw@strlen.de
References: <20240815113712.1266545-1-pablo@netfilter.org>
 <Zr3zq62D7-aS6WQe@orbyte.nwl.cc>
 <Zr34itYsV9LxG058@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr34itYsV9LxG058@calendula>

On Thu, Aug 15, 2024 at 02:46:02PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Aug 15, 2024 at 02:25:15PM +0200, Phil Sutter wrote:
> > On Thu, Aug 15, 2024 at 01:37:07PM +0200, Pablo Neira Ayuso wrote:
> > > Hi,
> > > 
> > > The following patchset relaxes cache requirements, this is based on the
> > > observation that objects are fetched to report errors and provide hints.
> > 
> > This is nice as it applies to error path only, though the second cache
> > fetch is prone to race conditions.
> 
> The call to nft_cache_update() ensures cache is consistent, old cache
> is dropped and a new consistent cache is obtained. The hint could be
> misleading (worst case) though since the cache could have different
> generation ID that the transaction itself, but it is just a hint.
> 
> > Did you consider retrying the whole transaction with beefed-up cache
> > in error case?
> 
> Why retry? I am assuming a batch where the user made a mistake, retry
> will fail again.
> 
> > I was about to mention how it nicely integrates with transaction
> > refresh in ERESTART case, but then realized this is iptables code
> > and nft doesn't retry in that case?!
> 
> I think you are talking about different scenario, that is, userspace
> sends an update but generation ID mismatches, kernel reports ERESTART
> and nftables revamps, this is to catch an interference with another
> process, that needs to be done in nft, but it is a different issue.

Yes, I had incorrect error reporting in mind: Kernel reports ENOENT for
a chain which another process creates concurrently. The error path cache
update fetches the newly created chain and error reporting suggests to
use the exact chain user specified (I assume). It is indeed a
corner-case issue, though.

Cheers, Phil
