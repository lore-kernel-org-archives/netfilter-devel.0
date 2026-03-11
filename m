Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E463319C566
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 19:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773256530; cv=none; b=DLeE2tdHvTUeywdBmdaxvWsjjGi6+U67T1S+TiYzaAlEMl9px4UxCOB23GD38nBbu+1iFs+Yvaxto7/6J9U5Dd+45PhC7L72YzX6/CKGxJJCu/1DpNmmpwsrbEKIdfariN0Xazs+/yF5fONpYVH11PzQtMUdO7TRNQHrWfcRu10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773256530; c=relaxed/simple;
	bh=EincP9w+SN2xU80sNFZARXAgKyIrUzPRmsClCCd51I8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aBNh8M+ipNnWtc5H2qKIeflDvtt6mIhneaeFVwLbW6EeXBcXF7VyZNUtRgPeL2uVIvbMAUY99gSdPv+RYuaZ3059lVNtn987OZZawcf6gaWvyb4JPvRB443r1E7P1D/QHHWea2Hwrdlkusv6lL1XbvN6YUnaJP1k+O8bTfTN9p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aMMeECAV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aMMeECAV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jpEQZvpQkRdiOXNhOpeHa1EkEUVyySApmwInwE7uK5k=; b=aMMeECAVOpr+l6dzxzuTeVfy1g
	Dzh6jaX7uTroIQ7MBJ1wEmBcLjil7XoUfdjacId7j+t61ilMhmFPU27x3Vxuu8EcjSpXvwEaFLjPj
	psDAa5q36ilO/OBc9CneVIK1aq0vzi9R/rWid70POIo0BFC8MJBTkextp6YsqT/+pdxePmFSOSq+R
	2waoyDv3Pur48JREpfag+01V5rNh5x0uugmzjQ3tY1LreF6dv+skBemlm0H8EtogAFqqWBukGPB1T
	lZ5ZJLBnN0k3O5V+LBqLZbwOgxcprT+thboiwGJZHZjoMqiweWr9HTxDcOQjV0ltywOOxep2y7TTx
	1orWP8kw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w0P1b-000000007Nu-02e5;
	Wed, 11 Mar 2026 20:15:19 +0100
Date: Wed, 11 Mar 2026 20:15:18 +0100
From: Phil Sutter <phil@nwl.cc>
To: Eric Garver <eric@garver.life>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/5] Enhance cache filter for list commands
Message-ID: <abG_RrwTCdXbmGX0@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Eric Garver <eric@garver.life>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20260310231115.25638-1-phil@nwl.cc>
 <abGFDGtr6Lk6dJYq@egarver-mac>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abGFDGtr6Lk6dJYq@egarver-mac>

On Wed, Mar 11, 2026 at 11:06:52AM -0400, Eric Garver wrote:
> On Wed, Mar 11, 2026 at 12:11:10AM +0100, Phil Sutter wrote:
> > Reducing the amount of data fetched from kernel improves performance
> > with large rule sets but also reduces adverse side-effects if multiple
> > versions of nftables access the same kernel rule set. Being able to
> > ignore parts of the rule set one is not interested in allows for (more or
> > less) safe coexistence if each tool is operating on the data it created
> > itself only.
> > 
> > This series reduces caching for list commands which specify a family
> > and/or table. To help testing this, patch 1 extends netlink debug output
> > to include chains, flowtables and objects so a test case may check if
> > they are fetched or not.
> > 
> > The remaining patches actually increase filter use.
> > 
> > Phil Sutter (5):
> >   cache: Include chains, flowtables and objects in netlink debug output
> >   cache: Respect family in all list commands
> >   cache: Relax chain_cache_dump filter application
> >   cache: Filter for table when listing sets or maps
> >   cache: Filter for table when listing flowtables
> > 
> >  src/cache.c                                 | 11 ++--
> >  src/mnl.c                                   | 60 ++++++++++++++++++---
> >  tests/shell/testcases/listing/cache_filters | 53 ++++++++++++++++++
> >  3 files changed, 113 insertions(+), 11 deletions(-)
> >  create mode 100755 tests/shell/testcases/listing/cache_filters
> 
> I ran this series against the firewalld testsuite. All green.
> Thanks Phil!

Thanks for testing, Eric! Shame on me for not putting you in Cc as you
asked for. Next time I'll probably best add a Cc: tag to one of the
commits immediately. ;)

Cheers, Phil
