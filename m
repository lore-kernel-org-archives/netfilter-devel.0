Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8F932D45E
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Jan 2026 16:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769011332; cv=none; b=AICJBTOkhaufR2P9q7czxJkNPozywNCL1dyM3btc3uiuWCxW/VMP8fBS14OLYU53Zbl6Jpjh2hOhddNqG+pTZSFs+VRfVmE6AMAinOo6aTh4kF37DWY1BhkDZ6kNgcpBgV3zbUXN9ZLPL1HtnSqU9c1j/evr/kwP/6V9p+KD+X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769011332; c=relaxed/simple;
	bh=tbGNTwbOJ2gX/jSknTvnRnIiBfhXXyNN0IJ+reQOG4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BT8DG9a7MKKeqkufXJ8owWOWsjEG4vGK3zd5DHKXI97hGJmfYEgLrmyj0EiZATcxYHvlQ/B2j+4pPq0YKXCewT4lV5pn4GqkgzuJs1RNliaokvw6PxU4xuFNvrbRIOIHlgA6gbkYnNmXqmmEjdGp/ClBhipoWsiscJawyI4gXxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZllGswQD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZllGswQD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DPMJexcp2ORJ8A4EYkLLQvArIsg8ivOdUmzbG/a4nRQ=; b=ZllGswQD0ZmE5+iTySenyQL4k5
	OsAuGOgzKp/PVbJJIc7hM91i8obWo8pImeko/ko7GchAZ+rf03vYdE5Z7vD84DqPtqq6AFxHEfpqf
	zPHXxjGeBJCZLrYy7J5pnAkr4p7fyas68h/HQZPRKHxG19S6ZmF2d0jkU6MR9kHMesNzdiPfSqVax
	sWdsZrdBhkCD+QE/elWJbOe0i1G/NrAqj/Pn9DG+P3HLLmOHeYAGAqOTvXj3XFtBEDLJ+2LxpKx4c
	xwNafo5Hrit8m3g/hl+tHzHLmaViMgeLLGYJmcvA1+0C//cHOcMc3eF14R2cCBw9p0CKGo7NMmRfb
	frZ8Sfkw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1viaeb-000000001SF-3UEG;
	Wed, 21 Jan 2026 17:01:57 +0100
Date: Wed, 21 Jan 2026 17:01:57 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] monitor: fix memleak in setelem cb
Message-ID: <aXD4dVwPHZHGhhrh@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260121133917.11734-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121133917.11734-1-fw@strlen.de>

Hi,

On Wed, Jan 21, 2026 at 02:39:08PM +0100, Florian Westphal wrote:
> since 4521732ebbf3 ("monitor: missing cache and set handle initialization")
> these fields are initied via handle_merge(), so don't clear them in
> the json output case.  Fixes:
> 
> ==31877==ERROR: LeakSanitizer: detected memory leaks
> Direct leak of 16 byte(s) in 2 object(s) allocated from:
>  #0 0x7f0cb9f29d4b in strdup asan/asan_interceptors.cpp:593
>  #1 0x7f0cb9b584fd in xstrdup src/utils.c:80
>  #2 0x7f0cb9b355b3 in handle_merge src/rule.c:127
>  #3 0x7f0cb9ae12b8 in netlink_events_setelem_cb src/monitor.c:457
> 
> Seen when running tests/monitor with asan enabled.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Looks like a fix of commit 4521732ebbf34 ("monitor: missing cache and
set handle initialization")?

Cheers, Phil
