Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E336325F7A5
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 21:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755551260; cv=none; b=VLjn5ti9jzsSiwPv8S1UNZWENrQeazxGZnOYsYbOTdkytyunjrDkUmd3vV95duZ1ol5xglfgOm+ihr3kE8WAPv4/fMJfGKk6Bg3nuDCr9DTxQI9K1+KtoECea7rR8usWpoEZWCgPcPtKpINyAqQTgX1RYxNFbjkKFSq+wE0x4hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755551260; c=relaxed/simple;
	bh=Z/H9Jpz3mbJtr7eD+4MpyhMwTzrRajXzhA6a+FSEroA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jf4+DOlp2kSg/qlB6tOTrtyAK9fxvJcIAb6ItTAC3Yj8Bt6wyUkH0ZOcqxJQ+sFSH472Q8ZPXXEy3pHhgo/ICwtWHTRCfpEoW9tOFtmzYTUtmjUDZRJh/Hhg915JaDEFwPZB8qnzvLwSGg8tjoyLU/cQlxSvzNCUWNl2kJssfuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=a/6nOoH/; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="a/6nOoH/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=91BBlSYG8kA+Avnq9B9sC4CZ12cKghnWfppk46U1qZ8=; b=a/6nOoH/YL4L2rXQL7qrB3xdVz
	q/gDpCokxf6Tudt/DlJvgkzvv/12o2SIDYNmcXlQwE9sXNft07ovtU1a4hp/eR1YTMjB20P+ELgSt
	0D34a6tPL8taF0prS1sMEryfWRf/BopSUGVcm7aX6WEPEa/bqjaNbqcUmcW7VkvLn8AmpW8D7PYQg
	mf+055h+krO/i7ReXuXb2qo1Pl97x8fEjPfuBRZatyXDtfbqgxWNEiL/MDTqf0uLELevNcupGzzx3
	sVQVWoYxQq31Qa+ly9m3U/E4yRtiCu2/+YwfxdrzObMmzB87vvOqfm55hftemHSh2/2E8oeGr4E4O
	XRnmtnIg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uo74o-000000008FZ-2C88;
	Mon, 18 Aug 2025 23:07:34 +0200
Date: Mon, 18 Aug 2025 23:07:34 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 00/14] json: Do not reduce single-item arrays on
 output
Message-ID: <aKOWFj5sjJNySsde@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250813170549.27880-1-phil@nwl.cc>
 <aKM1tbmVvbzoDUqx@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKM1tbmVvbzoDUqx@calendula>

On Mon, Aug 18, 2025 at 04:16:21PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 13, 2025 at 07:05:35PM +0200, Phil Sutter wrote:
> > This series consists of noise (patches 1-13 and most of patch 14) with a
> > bit of signal in patch 14. This is because the relatively simple
> > adjustment to JSON output requires minor adjustments to many stored JSON
> > dumps in shell test suite and stored JSON output in py test suite. While
> > doing this, I noticed some dups and stale entries in py test suite. To
> > clean things up first, I ran tests/py/tools/test-sanitizer.sh, fixed the
> > warnings and sorted the changes into fixes for the respective commits.
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Series applied, thanks!

> I will follow up with a patch to partially revert the fib check change
> for JSON too.

Hmm. That one seems like a sensible change and not just a simplification
of output. I guess if we take this approach seriously, we should agree
on (and communicate) an upgrade path for JSON output. In detail (from
the top of my head):

1) What changes are considered compatible (and which not)
2) In which situations are incompatible changes acceptable
3) How to inform users of the incompatible change

I'd suggest something like:

1) Additions only, no changes of property values or names
2) Critical bug fixes or new (major?) versions
3) Bump JSON_SCHEMA_VERSION? Or is the "version" property in "metainfo"
   sufficient if bumped anyway?

Cheers, Phil
