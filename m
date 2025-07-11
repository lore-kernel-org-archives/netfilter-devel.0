Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23082745E
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Jul 2025 13:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752239804; cv=none; b=EVSxd4GgWT/HFXjpB6I+8B3O1LtFtp4Mdepiz3i5HtLUMmueJp8RjU0Ng6zjEQnvotLnhNT5GU6PzcQyx5rpjQj0T2maaE/JM90rCUvjBJCxoOCT4rtnsIV3W1yv0NvmpLOXciF9qjzE7FhKovnAtLwPZBntVI3/HkeRkjin2dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752239804; c=relaxed/simple;
	bh=RVn/4r7sCI+zfXxXhM3mbwDl5X+Wb7TwyyN8CDQiZgY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AIbp766SU/qjoGJbMCPhLB6wCSPU30j/5EtIoi2ji/dtgWN06aOVOOGFzfTQas+EyIqmKmzcwIHRIFvm6HFOVoapfZfZJP3CrQhJeYVfOXFJIybiTOhKKA6HJYsLK7tgCrmUXulQwpQ6sD2C5Lsc/JdsOVGpP0dZ0q+abvtohjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8CE58607AC; Fri, 11 Jul 2025 15:16:39 +0200 (CEST)
Date: Fri, 11 Jul 2025 15:16:39 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aHEOtz_Ekj0QV15d@strlen.de>
References: <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>
 <aGaRaHoawJ-DbNUl@calendula>
 <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
 <aGbu5ugsBY8Bu3Ad@calendula>
 <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>
 <aGffdwjA23MaNgPQ@strlen.de>
 <aGwfPqpymU17BFHw@calendula>
 <aG0tdPnwKitQWYA6@orbyte.nwl.cc>
 <aG7wd6ALR7kXb1fl@calendula>
 <aHEBOFfIk3B2bxxr@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHEBOFfIk3B2bxxr@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> On Thu, Jul 10, 2025 at 12:43:03AM +0200, Pablo Neira Ayuso wrote:
> [...]
> > If you accept this suggestion, it is a matter of:
> > 
> > #1 revert the patch in nf.git for the incomplete event notification
> >    (you have three more patches pending for nf-next to complete this
> >     for control plane notifications).
> > #2 add event notifications to net/netfilter/core.c and nfnetlink_hook.
> 
> Since Florian wondered whether I am wasting my time with a quick attempt
> at #2, could you please confirm/deny whether this is a requirement for
> the default to name-based interface hooks or does the 'list hooks'
> extension satisfy the need for user space traceability?

My main point is that rtnetlink has a notifier for new/removed links,
see 'ip monitor.'.

So even if we want a 'nft hooks monitor', I don't see why kernel changes
are needed for it: subscribe to rtnetlink, then for a new link dump
the interfaces hooks *should* work.
