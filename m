Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1732C2D9493
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 11:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751543732; cv=none; b=gd31bwc9nuuNfuZ5Xd3Qe0B2v++PaDuMHvBllg4aDN4wxOzYq4uQItyJbKaPP+r0G9lyHrCxYXGc6bmIah+mU2NQb/nBbiJ5fCH7fSP47dK9VI7DflLA364U0XltjdOB83B/7Wwec4+8aPRsI5bpuayqEsVlzdugNcpsMEcHp7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751543732; c=relaxed/simple;
	bh=m3By3/GF3bRZUjpjrodRqRgWhzxJKwVyl+3Kw03y0UA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ui2TLhWmvcIJLjtdNRJkgLVmMvg5aNeouq4YlOCJ7tRkDM/FQ86kWVUIf19L045uuLx9sIfv/moZAZ95P+l5XETtqEaoXlEBLUpPqZWKsZ7eqKB3jKPT67KHihNmPwTGdod5U4TUjstFcXo15/vIMe60VZ3WbNU0xGX+9jryDcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7A6E7604EE; Thu,  3 Jul 2025 13:55:26 +0200 (CEST)
Date: Thu, 3 Jul 2025 13:55:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGZvriD0SSakTh-b@strlen.de>
References: <20250702174725.11371-1-phil@nwl.cc>
 <aGW1JNPtUBb_DDAB@strlen.de>
 <aGZZnbgZTXMwo_MS@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGZZnbgZTXMwo_MS@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> On Thu, Jul 03, 2025 at 12:39:32AM +0200, Florian Westphal wrote:
> > > - A wildcard interface spec is accepted as long as at least a single
> > >   interface matches.
> > 
> > Is there a reason for this? Why are they handled differently?
> 
> I wasn't sure if it's "required" to prevent it as well or not. This
> patch was motivated by Pablo reporting users would not notice mis-typed
> interface names anymore and asking for whether introducing a feature
> flag for it was possible. So I went ahead to have something for a
> discussion.

Ah, thanks, that makes sense.

> Actually, wildcards are not handled differently: If user specifies
> "eth123", kernel errors if no "eth123" exists and accepts otherwise. If
> user specifies "eth*", kernel errors if no interface with that prefix
> exists and accepts otherwise.

Indeed, thanks for clarifying.

> I don't know where to go with this. If the flag should turn interface
> specs name-based, its absence should fully restore the old behaviour (as
> you kindly summarized below). If it's just about the typo, this patch
> might be fine.

Yes.

> > Now (this patch, without new flag):
> > - netdev basechain: same as above.
> >   But you do get an error if the device name did not exist.
> >   Unless it was for "foo*", thats accepted even if no match is found.
> 
> No, this patch has the kernel error also if it doesn't find a match for
> the wildcard. It merely asserts that the hook's ops_list is non-empty
> after nft_netdev_hook_alloc() (which did the search for matching
> interfaces) returns.

Aaah, ok, I see now. Then its waaaay less confusing than I thought.

> > If in doubt the flag should not be updateable (hard error), in
> > that case we can refine/relax later.
> 
> My statement above was probably a bit confusing: With non-persistent, I
> meant for the flag to be recognized upon chain/flowtable creation but
> not added to chain->flags or flowtable->data.flags.

I see, thats a good question, I feel exposing it (add to ->flags member)
is better.
