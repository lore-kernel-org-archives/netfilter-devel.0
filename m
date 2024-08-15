Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E081A00E2
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 12:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723725976; cv=none; b=ZbIWDTfmoiI269HQ7uwIBREWAa1+l8fi9nwQszbHaiWhj1S83ut0lPmIOLcFzDreR8T/sW+81dBKHNkC1BmLypb0i6TmaFD40MeX81vpXS11AL1HY4N7SMiJo08enEj9YEIlGbdjyrkRswvFl9PXvqBpEXjlvO1sV0Vvaa95ZQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723725976; c=relaxed/simple;
	bh=Um83fvzptlGrp3Cr7pZ2IQVeuh1I6bdKMe1n/2mozdQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NW6j1aqpVidpukOOhhgGjFDe6+oNGBzKJ+fAM9dJWYjIIsrtvdSBxUixBdU7E3kxbHBnGB8jfz0yoxg/83qgqNHQAMasuPw+ixrojRQEzyUpAXk0r5uEAkj3JDh2Klk3a0mDMl8zVIuY6v9AwmX6t1gNCt6+r7m6orp1E6+uz2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=55552 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1seZrf-00H6E7-C9; Thu, 15 Aug 2024 14:46:09 +0200
Date: Thu, 15 Aug 2024 14:46:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	nhofmeyr@sysmocom.de, eric@garver.life, fw@strlen.de
Subject: Re: [PATCH nft 0/5] relax cache requirements, speed up incremental
 updates
Message-ID: <Zr34itYsV9LxG058@calendula>
References: <20240815113712.1266545-1-pablo@netfilter.org>
 <Zr3zq62D7-aS6WQe@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zr3zq62D7-aS6WQe@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Thu, Aug 15, 2024 at 02:25:15PM +0200, Phil Sutter wrote:
> On Thu, Aug 15, 2024 at 01:37:07PM +0200, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > The following patchset relaxes cache requirements, this is based on the
> > observation that objects are fetched to report errors and provide hints.
> 
> This is nice as it applies to error path only, though the second cache
> fetch is prone to race conditions.

The call to nft_cache_update() ensures cache is consistent, old cache
is dropped and a new consistent cache is obtained. The hint could be
misleading (worst case) though since the cache could have different
generation ID that the transaction itself, but it is just a hint.

> Did you consider retrying the whole transaction with beefed-up cache
> in error case?

Why retry? I am assuming a batch where the user made a mistake, retry
will fail again.

> I was about to mention how it nicely integrates with transaction
> refresh in ERESTART case, but then realized this is iptables code
> and nft doesn't retry in that case?!

I think you are talking about different scenario, that is, userspace
sends an update but generation ID mismatches, kernel reports ERESTART
and nftables revamps, this is to catch an interference with another
process, that needs to be done in nft, but it is a different issue.
