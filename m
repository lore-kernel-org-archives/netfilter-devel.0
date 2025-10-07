Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B9F254B03
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 22:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759874759; cv=none; b=YvXcbZAoFTV/1c1tdGRKyF5lqTN3LN+LvJbsd38xx4GBEocjPX7zUQHfc/zLmaxMJ+jzzPp21BTsu5xUaFwREkn2zGm3Mb9ClJJHjfxvTvYyBGP9sBRMVwMYheRSIJ83C6W1Uxux1qiXqYoZfPHvLSQHmD47zA19hdyCTKEfIxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759874759; c=relaxed/simple;
	bh=oTmF/v0KSjb5HycJ++iGhY69MiFHVJwvQVK0Dn2gtqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeI44A3cZbwa0m/FspmwK7HIQrtwXenA12aN/wnIbu9JB/MANhcs9hIhDmBNaWusjvMDS+yfqaJyPs1CWqiqM7byqZ3vHHZcTTQWlOM3Rnn1Bfn1lT25NEeuF9uBXwpi84O2E6zwKU6ZAfYOI9ZTTIGVlH/cTwVvHFw+6RaPPx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YhhCoRqK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YhhCoRqK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lyoohOJuxCZAzXwquiqNNvM+B3nQqmNW2mP21BRhaVo=; b=YhhCoRqK4/yvQMTwsXvJaLk6wd
	UKs1PnCCFa6b5kok0pVZWhBvRci/ubRpxuJEIPDn5aAby1VMEmHse7cuEdJ8/RBlwhHBZ4jFgBqJC
	cELSBqRXFwM0mA5iVD96IrelVfog92ItB8k9eMM0+WSa5Vk9amNrkyZBepS4WIHVSkOembXWlcX6+
	/xr8jeFxloe18zGx59El9ZOOfL22GpIQqMQ1vUw8NClelwXQEPpNs4zKwiog9cH1MZuVw/ePQzKFw
	mIY0OFQAhv6gn58ZJquxhFrdsjYdETXkIhH8yzY/2pjtrXbQFRokG4lXjm+QG32fBKLzmE1clsbKN
	deXHxGGw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1v6Fof-000000001FR-44VA;
	Wed, 08 Oct 2025 00:05:54 +0200
Date: Wed, 8 Oct 2025 00:05:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] utils: Drop asterisk from end of
 NFTA_DEVICE_PREFIX strings
Message-ID: <aOWOwaCWV1SXpdg6@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251007155935.1324-1-phil@nwl.cc>
 <aOWJLfLGdbT5eDST@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOWJLfLGdbT5eDST@calendula>

Hi Pablo,

On Tue, Oct 07, 2025 at 11:42:05PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 07, 2025 at 05:58:26PM +0200, Phil Sutter wrote:
> > The asterisk left in place becomes part of the prefix by accident and is thus
> > both included when matching interface names as well as dumped back to user
> > space.
> > 
> > Fixes: f30eae26d813e ("utils: Add helpers for interface name wildcards")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > This code is currently unused by nftables at least since it builds the
> > netlink message itself.
> 
> This was moved to nftables, and no release was made to include it?
> Would it possible to remove it from libnftnl?

The code layout is a bit inconsistent in this regard: While nftables
does the serialization itself (to record offsets for extack), it relies
upon libnftnl to perform the deserialization. Therefore parts of the
wildcard interface feature will have to be spread over the two projects.
And since this is the case, I decided to keep libnftnl's serialization
code "maintained" in this regard, i.e. enable it to perform the netlink
message building for wildcard interface names as well even though there
is no known user for it.

I'd prefer to keep it, also because I see us eventually returning to
libnftnl's serialization code once there is a mechanism to extract the
offsets for extack. You have the last word though (as always)! :)

Cheers, Phil
