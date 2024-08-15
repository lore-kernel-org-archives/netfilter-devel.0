Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C711714A8
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 13:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729133; cv=none; b=VhXPdvW5PsL81aAbZPinAjJ0u3Rysy+goQ3I2lOlTJ4ADmr9nPwhCYKCet3D5ZELJRQM8PHuSsIlSq9jeIkXXq6vA3MXs3+xQ5od+9KwX/zy5AahFtFKo9EKWiwWpa9PMpHKYCterOl27v3ck91bHhBYj05VcxcZ25/MrU/3bFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729133; c=relaxed/simple;
	bh=hXHSc8e1gzchgi3KSMHHJRf05p+EeL5igG6NpQoKitU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HBme3eJU3ziCmQTsZcGIHoJ0S/xyz3OQTjlWDzSs3/2ctdeN96Dm+BZ40IMXAquLjWrd7GWKI+dWZKT7nQHRD9+sYR9c68H55KxhOZ53CvQyvOo5ASNaZWPF7gvH427wY3rRgtb98LFfO0TLHgtSos9ICgW5pNPz9bXXfmaUmVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=45156 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1seagg-00H9OV-B0; Thu, 15 Aug 2024 15:38:48 +0200
Date: Thu, 15 Aug 2024 15:38:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	nhofmeyr@sysmocom.de, eric@garver.life, fw@strlen.de
Subject: Re: [PATCH nft 0/5] relax cache requirements, speed up incremental
 updates
Message-ID: <Zr4E5dOwQflRb6tx@calendula>
References: <20240815113712.1266545-1-pablo@netfilter.org>
 <Zr3zq62D7-aS6WQe@orbyte.nwl.cc>
 <Zr34itYsV9LxG058@calendula>
 <Zr3-NdL1GCs-aPlR@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zr3-NdL1GCs-aPlR@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Thu, Aug 15, 2024 at 03:10:13PM +0200, Phil Sutter wrote:
> On Thu, Aug 15, 2024 at 02:46:02PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Aug 15, 2024 at 02:25:15PM +0200, Phil Sutter wrote:
> > > On Thu, Aug 15, 2024 at 01:37:07PM +0200, Pablo Neira Ayuso wrote:
> > > > Hi,
> > > > 
> > > > The following patchset relaxes cache requirements, this is based on the
> > > > observation that objects are fetched to report errors and provide hints.
> > > 
> > > This is nice as it applies to error path only, though the second cache
> > > fetch is prone to race conditions.
> > 
> > The call to nft_cache_update() ensures cache is consistent, old cache
> > is dropped and a new consistent cache is obtained. The hint could be
> > misleading (worst case) though since the cache could have different
> > generation ID that the transaction itself, but it is just a hint.
> > 
> > > Did you consider retrying the whole transaction with beefed-up cache
> > > in error case?
> > 
> > Why retry? I am assuming a batch where the user made a mistake, retry
> > will fail again.
> > 
> > > I was about to mention how it nicely integrates with transaction
> > > refresh in ERESTART case, but then realized this is iptables code
> > > and nft doesn't retry in that case?!
> > 
> > I think you are talking about different scenario, that is, userspace
> > sends an update but generation ID mismatches, kernel reports ERESTART
> > and nftables revamps, this is to catch an interference with another
> > process, that needs to be done in nft, but it is a different issue.
> 
> Yes, I had incorrect error reporting in mind: Kernel reports ENOENT for
> a chain which another process creates concurrently. The error path cache
> update fetches the newly created chain and error reporting suggests to
> use the exact chain user specified (I assume).

IIRC, the fuzzy match code skips exact matches, worst case can be a
very hint.

> It is indeed a corner-case issue, though.

ERESTART handling can be useful for your rule index feature, where
consistency is fundamental to ensure that rule is added where the user
really wants.
