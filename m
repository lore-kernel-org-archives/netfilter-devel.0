Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5471E86340
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Mar 2025 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741974993; cv=none; b=DndSUGjl4dAhfjpspYCq6G5+nhSfB6YBU2cNWg7C8f8GrV3Db2lxIWg4IeSr62RnnjJhrJb9HH8owkRIeiIjqk9+5TS3uS587FQenvtM/e+amc2mvcFt130qQXDI70f7/nR1RA2JXdtlwzDWFGhc/EfcwoPAjFBkl2vho37SGbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741974993; c=relaxed/simple;
	bh=W1dN/VMg4RpUludaxIbZIS5zwGR7CxjYAVg/fGeMgUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TDKDtUtE5Y7uGNWijuWfrcqTsK8ktIGBYd3wa4CNXZ1ZCNZlTawdLtqdIbxL4yKekDIGnJR535ZM7X8TsJmMb52Ixb2TlHVHKdUm4mWvJcuLhAdjCHEeyyVyRCoVvQmJz53UJcF+pMuj7LZ9VG7J2UOOkt5ZhvcQ4xCE/SRpJXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Pu4bBsEv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Pu4bBsEv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7QUtKG/CUOJXFfHNjhTO4nhZWqMtrFrTcf+38rPnsAE=; b=Pu4bBsEvUy3cbrXrom9LzLeHcV
	Q+LQlMZTu4RVIJa8RqGObtBFhvW1ZHRzEXSZUHPgEZwCHlGKHREJFqvJcKOkQd4+wY1XN1VaLXDBR
	Vc5gOG33K4nckvLgEpeA9Ht5XOEMGPLFnP0651WykEV22AZgfi8mqgTTCtHDSTPrgLfo4nSL3HEHM
	MgdHs1BkV9MU+qdk53sWkP58bMptEPFipYvpwfjZmfahyrqyDSVx+cI7Z/EY4o4lrYTeviucQ8oTT
	OhPGuh6poRkDBQiw9ssYH8BI01JndXq/s/FY/mDSbKIRdkiGUta3kOVODRVqAr6jdI2HyDgIiY94X
	CUsqBvAw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <p.ozlabs@nwl.cc>)
	id 1tt9Gm-000000003GX-1wii;
	Fri, 14 Mar 2025 18:56:28 +0100
Date: Fri, 14 Mar 2025 18:56:28 +0100
From: Phil Sutter <p.ozlabs@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: William Stafford Parsons <entrocraft@gmail.com>, pablo@netfilter.org,
	regit@netfilter.org, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org
Subject: Re: Replacing DJB2 Hash
Message-ID: <Z9RtzLnczdxnY2aG@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <p.ozlabs@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	William Stafford Parsons <entrocraft@gmail.com>,
	pablo@netfilter.org, regit@netfilter.org, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org
References: <CANBG-UO0xoUQq_yah=mLQWfvNQQwJng8y5UPkMSF9daYfQGe-g@mail.gmail.com>
 <20250313201134.GA26508@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313201134.GA26508@breakpoint.cc>

On Thu, Mar 13, 2025 at 09:11:34PM +0100, Florian Westphal wrote:
> William Stafford Parsons <entrocraft@gmail.com> wrote:
> > Hi Core Netfilter Team,
> > 
> > I'm messaging you directly with a critical, simple patch suggestion.
> > 
> > I registered with the username *Eightomic*, but I'm having some issues
> > installing *pwclient* quickly without allowing *--break-system-packages*.
> > 
> > Lines 176-193 could be replaced in the following file.
> > 
> > https://git.netfilter.org/iptables/tree/iptables/nft-cache.c#n176
> > 
> > The following code replaces it.
> 
> .... but... why?

Quoting from https://eightomic.com/hash-32-a/

| EIGHTOMIC HASH 32 A: THE FASTEST 32-BIT, OAAT HASHING ALGORITHM VERSUS
| CDB AND DJB2

While I doubt there's a performance improvement at all and if there is
it won't be measurable in this context, reading the footer of that page
makes me wonder whether the given algorithm is suitable for use in a GPL
licensed project to begin with.

Cheers, Phil
