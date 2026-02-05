Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C6843147
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 13:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770298241; cv=none; b=O6OXAd2twAlwkU6uu5TfV5PfjTbRZ2djP42NRZ+HISI7327YYorqbAS4QTodqsfC9FKYlBhI69ak+0EVThjzDELjhvYtwnCTwuihpxFMnR8uwkBjK9zZEQY+Q09tIDDY3nMz6V4bbbzPIzHkExspXgEQ1ieTb0gBhAfDOhfVDSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770298241; c=relaxed/simple;
	bh=ioZzyaExkyadNtslEoiUcDLh+1x+dDH3Av2F7f00ZrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOizxssZN8zYekkmhjy1GM3VjghuBSPfhHGItkEe0aJabW/FJGgk1Ew5j+Oq0o7D3MXqf+JxyLmD7ABGjweXkAQwZzHDDjxaWYcV0FWdtkpZPFTRKacQo5EpKdX9DuChHb03R3cQaPAo/PhLSxgAQL9cEZOoKi5l1R7Z+3/NwsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MONOT/al; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MONOT/al"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7BL2ttvhgX4VrgQR9bsduIN9+Y7CEa+5qt5/48swbO0=; b=MONOT/alZcosGc8JjYR2wZErv/
	MghHSu4cheSYcWhq/+vEqtSpZ4Cm7uoCRfztJb5f147bQ1CHOMwbAJml8kSp8xHs+GtH7vED7vpDW
	ADedn6RuQ3AR0mW3/nJeeIrhE15e/j0r1LVZI31oFAlnbxlLq9PCSfUDk5lwsyBPrNS2fvZLNf4/p
	5T/jacPkQKj5ys1FvZWUAwprsJw0htNwm7oOUnLPfz1qgLCHDfnZtuTcohHboyO/yWGIiObeZcyZZ
	o266qB3HMw7Vh8bVpGW7N21YY2mlC54Y0QSXrvxeRVh3EFuonLflzpVkzbSYJ6LZ+6jHLhrfHgVv+
	m6kHqC+Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vnzRP-000000001aW-2NIZ;
	Thu, 05 Feb 2026 14:30:39 +0100
Date: Thu, 5 Feb 2026 14:30:39 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/4] Inspect and improve test suite code coverage
Message-ID: <aYSbfxYZ0Du6rsDP@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20260127222916.31806-1-phil@nwl.cc>
 <aYPz_fmbjh5qjM30@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYPz_fmbjh5qjM30@chamomile>

On Thu, Feb 05, 2026 at 02:35:57AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 27, 2026 at 11:29:12PM +0100, Phil Sutter wrote:
> > While inspecting the test suites' code coverage using --coverage gcc
> > option and gcov(r) for analysis, I noticed that 'nft monitor' processes
> > did not influence the stats at all. It appears that a process receiving
> > SIGTERM or SIGINT (via kill or ctrl-c) does not dump profiling data at
> > exit. Installing a signal handler for those signals which calls exit()
> > resolves this, so patch 1 of this series implements --enable-profiling
> > into configure which also conditionally enables said signal handler.
> > 
> > Patches 2 and 4 fix for zero test coverage of src/nftrace.c and
> > src/xt.c, bumping stats to ~90% for both.
> > 
> > Patch 3 fixes for ignored comment matches in translated iptables-nft
> > rules. This is required for patch 4 which uses a comment match to check
> > whether nft is built with translation support.
> 
> Apart from the aforementioned nitpick, series LGTM.

Thanks for your review. I'll adjust patch 1 as per your feedback and
resubmit.
