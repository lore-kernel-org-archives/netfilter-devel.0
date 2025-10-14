Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F172550CD
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Oct 2025 22:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760481238; cv=none; b=dgfVnFB1GWut4mmjY+Vh7eSzlQ60R35KYnjaqU+hLvAZEIVPdmtfwcPMSnDDFDKmqGhm8wqWqqy/AEplna3ztE7TRZC7lN5apm2BOBODyI/52JQ7RDadnZRbGju2tvg897wUylFkYW7byF0HeidlRrvZX+N4hdbry71XSHncJEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760481238; c=relaxed/simple;
	bh=xeAEnsAMu4azJrocqDQkt+LnGIidaO+9dfcF13cOKsE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JleinXe/ht1D5pAcAZaX+vTc0n4Ah7tbtMxTReknByf+TSAHBV8/4R+RKld+qlJCwtfCQy8gHcZewxha9LjSJpYmqog+czKVthW5C0GsbGtFWlREF8Z7jiv/SajTPjCc9Oqr5ICWA08e6Pk32RbohyHtxaug8H6OTi46UcxDTJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PWOMzOAn; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PWOMzOAn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PWOMzOAn";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PWOMzOAn"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 965A160297; Wed, 15 Oct 2025 00:33:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760481227;
	bh=6qYM56kga6l3kEPmzQkXiEVVq609yOgXBTXhC3Pc+K4=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=PWOMzOAnK4VQz6xTBWVXXAqiiQh8yt+IX51D88cr1zGDDL79L++MQToKH/hPfM5sD
	 t2vstJJlEG16W5PNIyHIt/5DmXXYwaXwAZ85r1voBlW3CdPY4ByBat70BhbicJY8Z9
	 QTjSB0n5vXbxUAiJlczMnxz6ZfMGMf+jkIOQ+KatMtnxx8GEivd+RM5YLae8NEOmVM
	 W/XttjHQ1qzNv2e+V/7gDHL2eQxdnjQFsLgmYZ4EIr//9J1sodwoe4iy6lCI4kETSK
	 tmF3IW/jhIJJMUa/eNaEwAZMWsC4UFp9ZdCAHNcKiQM9ucxbYfRGvxubzGMj9dRNWp
	 IcDrLqgH2XNHg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E5CAF60294;
	Wed, 15 Oct 2025 00:33:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760481227;
	bh=6qYM56kga6l3kEPmzQkXiEVVq609yOgXBTXhC3Pc+K4=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=PWOMzOAnK4VQz6xTBWVXXAqiiQh8yt+IX51D88cr1zGDDL79L++MQToKH/hPfM5sD
	 t2vstJJlEG16W5PNIyHIt/5DmXXYwaXwAZ85r1voBlW3CdPY4ByBat70BhbicJY8Z9
	 QTjSB0n5vXbxUAiJlczMnxz6ZfMGMf+jkIOQ+KatMtnxx8GEivd+RM5YLae8NEOmVM
	 W/XttjHQ1qzNv2e+V/7gDHL2eQxdnjQFsLgmYZ4EIr//9J1sodwoe4iy6lCI4kETSK
	 tmF3IW/jhIJJMUa/eNaEwAZMWsC4UFp9ZdCAHNcKiQM9ucxbYfRGvxubzGMj9dRNWp
	 IcDrLqgH2XNHg==
Date: Wed, 15 Oct 2025 00:33:44 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] utils: Drop asterisk from end of
 NFTA_DEVICE_PREFIX strings
Message-ID: <aO7PyNgUnGxg7qHt@calendula>
References: <20251007155935.1324-1-phil@nwl.cc>
 <aOWJLfLGdbT5eDST@calendula>
 <aOWOwaCWV1SXpdg6@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aOWOwaCWV1SXpdg6@orbyte.nwl.cc>

On Wed, Oct 08, 2025 at 12:05:53AM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Tue, Oct 07, 2025 at 11:42:05PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Oct 07, 2025 at 05:58:26PM +0200, Phil Sutter wrote:
> > > The asterisk left in place becomes part of the prefix by accident and is thus
> > > both included when matching interface names as well as dumped back to user
> > > space.
> > > 
> > > Fixes: f30eae26d813e ("utils: Add helpers for interface name wildcards")
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > > This code is currently unused by nftables at least since it builds the
> > > netlink message itself.
> > 
> > This was moved to nftables, and no release was made to include it?
> > Would it possible to remove it from libnftnl?
> 
> The code layout is a bit inconsistent in this regard: While nftables
> does the serialization itself (to record offsets for extack), it relies
> upon libnftnl to perform the deserialization. Therefore parts of the
> wildcard interface feature will have to be spread over the two projects.
> And since this is the case, I decided to keep libnftnl's serialization
> code "maintained" in this regard, i.e. enable it to perform the netlink
> message building for wildcard interface names as well even though there
> is no known user for it.
> 
> I'd prefer to keep it, also because I see us eventually returning to
> libnftnl's serialization code once there is a mechanism to extract the
> offsets for extack. You have the last word though (as always)! :)

LGTM, thanks for explaining.
